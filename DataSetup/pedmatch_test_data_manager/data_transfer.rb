#!/usr/bin/env ruby
require 'bundler/setup'
require 'aws-sdk'
require 'json'
require 'active_support'
require 'active_support/core_ext'
require_relative 'table_info'
require_relative 'logger'
require_relative 'seed_file'

class DataTransfer
  LOCAL_TIER = 'local'
  INT_TIER = 'int'
  UAT_TIER = 'uat'
  LOCAL_DB_ENDPOINT = 'http://localhost:8000'
  LOCAL_REGION = 'us-east-1'
  INT_DB_ENDPOINT = 'https://dynamodb.us-east-1.amazonaws.com'
  INT_REGION = 'us-east-1'
  UAT_DB_ENDPOINT = 'https://dynamodb.us-east-1.amazonaws.com'
  UAT_REGION = 'us-east-1'

  ################backup
  def self.backup(tag='patients')
    TableInfo.all_tables.each { |table|
      copy_table_to_file(table, SeedFile.seed_file(table, tag)) if table_exist(table, LOCAL_TIER)
    }
    Logger.log('Local backup done!')
  end

  def self.copy_table_to_file(table_name, file)
    cmd = "aws dynamodb scan --table-name #{table_name} "
    cmd = cmd + "--endpoint-url #{LOCAL_DB_ENDPOINT} > "
    cmd = cmd + file
    `#{cmd}`
    Logger.log("Table <#{table_name}> has been exported to #{file}")
  end

  ################clear
  def self.clear_all_local
    TableInfo.all_tables.each { |table| clear_table(table, LOCAL_TIER) }
    Logger.log('Clear local dynamodb done!')
  end

  def self.clear_all_int
    TableInfo.all_tables.each { |table| clear_table(table, INT_TIER) }
    Logger.log('Clear int dynamodb done!')
  end

  def self.clear_table(table_name, tier)
    setup_aws(tier)
    unless table_exist(table_name, tier)
      return
    end
    table_keys = TableInfo.keys(table_name)
    table_keys_should_match(table_name, table_keys)

    start_stamp = Time.now
    # scan_result = @aws_db.scan(table_name: table_name, attributes_to_get: table_keys)
    # all_items = scan_result.items
    all_items = scan_all(table_name, table_keys) #scan_result.items
    if all_items.nil? || all_items.size<1
      Logger.log("Table '#{table_name.upcase}' is empty skipping...")
    else
      deleted = 0
      batch_size = 25
      all_items.each_slice(batch_size) { |this_batch|
        items = []
        this_batch.each { |this_item| items << {delete_request: {key: this_item}} }
        request = {request_items: {table_name => items}}
        begin
          @aws_db.batch_write_item(request)
          deleted += items.size
        rescue => e
          Logger.warning("Could not delete table #{table_name}")
          Logger.warning(e.backtrace)
        end
      }

      end_stamp = Time.now
      diff = ((end_stamp - start_stamp) * 1000.0).to_f / 1000.0
      Logger.log("Deleted #{deleted}/#{all_items.size} records from #{tier} \"#{table_name}\" table in #{diff} secs!")
      unless deleted == all_items.size
        raise "Expected to delete #{all_items.size} items, actually deleted #{deleted} items"
      end
    end
  end

  #################upload
  def self.upload_seed_data_to_local(tag='patients')
    TableInfo.all_tables.each do |table|
      upload_seed_data(table, tag, LOCAL_TIER)
    end
    Logger.log('Upload to local dynamodb done!')
  end

  def self.upload_seed_data_to_int(tag='patients')
    TableInfo.all_tables.each do |table|
      upload_seed_data(table, tag, INT_TIER)
    end
    Logger.log('Upload to int dynamodb done!')
  end

  def self.upload_seed_data(table_name, tag, tier)
    all_items = SeedFile.all_items(table_name, tag)
    setup_aws(tier)
    return unless table_exist(table_name, tier)
    table_keys = TableInfo.keys(table_name)
    table_keys_should_match(table_name, table_keys)

    start_stamp = Time.now

    if all_items.nil? || all_items.size<1
      Logger.log("Seed data for table '#{table_name.upcase}' is empty skipping...")
    else
      uploaded = 0
      batch_size = 25
      all_items.each_slice(batch_size) { |this_batch|
        items = []
        this_batch.each { |this_item|
          converted_item = {}
          this_item.keys.each do |this_field|
            unless is_a_valid_field(table_name, this_field, this_item[this_field])
              return
            end

            converted_item[this_field] = extract_value(this_item[this_field])
          end
          items << {put_request: {item: converted_item}}
        }
        request = {request_items: {table_name => items}}
        begin
          @aws_db.batch_write_item(request)
          uploaded += items.size
        rescue => e
          Logger.warning("Could not upload seed to table #{table_name}")
          Logger.warning(e.backtrace)
        end
      }

      end_stamp = Time.now
      diff = ((end_stamp - start_stamp) * 1000.0).to_f / 1000.0
      Logger.log("Uploaded #{uploaded}/#{all_items.size} records to #{tier} \"#{table_name}\" table in #{diff} secs!")
      unless uploaded == all_items.size
        raise "Expected to upload #{all_items.size} items, actually uploaded #{uploaded} items"
      end
    end
  end

  def self.extract_value(field_object)
    if field_object.keys[0] == 'M'
      result = {}
      field_object.values[0].each do |key, value|
        result[key] = extract_value(value)
      end
      result
    elsif field_object.keys[0] == 'N'
      field_object.values[0].to_f
    elsif field_object.keys[0] == 'L'
      result = []
      field_object.values[0].each do |item|
        result << extract_value(item)
      end
      result
    elsif field_object.keys[0] == 'NULL'
      nil
    else
      field_object.values[0]
    end
  end

  def self.is_a_valid_field(class_name, field_name, field_object)
    length_correct = field_object.keys.length == 1
    unless length_correct
      Logger.warning("#{class_name}-#{field_name} has #{field_object.keys.length} keys")
    end

    acceptable_types = %w(M S BOOL N L NULL)
    type_correct = acceptable_types.include?(field_object.keys[0])
    unless type_correct
      Logger.warning("#{class_name}-#{field_name} has invalid key #{field_object.keys[0]}")
    end
    length_correct && type_correct
  end


  #################aws unitilies
  def self.setup_aws(tier)
    @aws_options = {
        endpoint: '',
        region: '',
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    }
    case tier
      when LOCAL_TIER
        @aws_options[:endpoint] = LOCAL_DB_ENDPOINT
        @aws_options[:region] = LOCAL_REGION
      when INT_TIER
        @aws_options[:endpoint] = INT_DB_ENDPOINT
        @aws_options[:region] = INT_REGION
      when UAT_TIER
        @aws_options[:endpoint] = UAT_DB_ENDPOINT
        @aws_options[:region] = UAT_REGION
      else
    end
    Aws.config.update(@aws_options)
    @aws_db = Aws::DynamoDB::Client.new
  end

  def self.table_exist(table_name, tier)
    setup_aws(tier) unless @aws_db.present?
    exist = @aws_db.list_tables.table_names.include?(table_name)
    Logger.warning("Table '#{table_name.upcase}' not found.") unless exist
    exist
  end

  def self.table_keys_should_match(table_name, keys)
    actual_keys = []
    resp = @aws_db.describe_table({table_name: table_name})
    resp.table.key_schema.each { |this_key| actual_keys << this_key.attribute_name }
    unless keys == actual_keys
      Logger.warning("The keys in the the table #{table_name} have changed.")
      exit
    end
  end

  def self.scan_all(table_name, attribute_to_get, start_key={})
    return {} if start_key.nil?
    if start_key.size > 0
      scan_result = @aws_db.scan(table_name: table_name,
                                 attributes_to_get: attribute_to_get,
                                 exclusive_start_key: start_key)
    else
      scan_result = @aws_db.scan(table_name: table_name,
                                 attributes_to_get: attribute_to_get)
    end
    items = scan_result.items
    items.push(*scan_all(table_name, attribute_to_get, scan_result.last_evaluated_key))
  end
end