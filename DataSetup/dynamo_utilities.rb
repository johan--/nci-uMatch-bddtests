#!/usr/bin/env ruby
require 'bundler/setup'
require 'aws-sdk'
require_relative 'table_details'

class DynamoUtilities
  LOCAL_TIER = 'local'
  INT_TIER = 'int'
  UAT_TIER = 'uat'
  LOCAL_DB_ENDPOINT = 'http://localhost:8000'
  LOCAL_REGION = 'us-east-1'
  INT_DB_ENDPOINT = 'https://dynamodb.us-east-1.amazonaws.com'
  INT_REGION = 'us-east-1'
  UAT_DB_ENDPOINT = 'https://dynamodb.us-east-1.amazonaws.com'
  UAT_REGION = 'us-east-1'

  #############backup local
  def self.backup_local_table_to_file(table_name, file)
    setup_aws(LOCAL_TIER)
    result = @aws_db.scan({table_name:table_name})['items']
    File.open(file, 'w') {|f| f.write(JSON.pretty_generate(result))}
    LOG.log("#{result.size} items are exported from table \"#{table_name}\" to local")
  end

  ################clear
  def self.clear_table(table_name, tier)
    setup_aws(tier)
    table_should_exist(table_name)
    table_keys = TableDetails.const_get(table_name.upcase)[:keys]
    table_keys_should_match(table_name, table_keys)

    start_stamp = Time.now
    all_items = @aws_db.scan(table_name: table_name, attributes_to_get: table_keys)['items']
    if all_items.nil? || all_items.size<1
      LOG.log("Table '#{table_name.upcase}' is empty skipping...")
    else
      all_items.each_slice(25) { |this_batch|
        items = []
        this_batch.each { |this_item| items << {delete_request: {key: this_item}} }
        request = {request_items: {table_name => items}}
        begin
          @aws_db.batch_write_item(request)
        rescue => e
          LOG.log("Could not delete table #{table_name}", :warn)
          puts e.backtrace
        end
      }

      end_stamp = Time.now
      diff = ((end_stamp - start_stamp) * 1000.0).to_f / 1000.0
      LOG.log("Deleted #{all_items.size} records from #{tier} \"#{table_name}\" table in #{diff} secs!")
    end
  end

  #################upload
  def self.upload_seed_data(table_name, seed_file, tier)
    setup_aws(tier)
    table_should_exist(table_name)
    table_keys = TableDetails.const_get(table_name.upcase)[:keys]
    table_keys_should_match(table_name, table_keys)

    start_stamp = Time.now
    all_items = JSON.parse(File.read(seed_file))
    if all_items.nil? || all_items.size<1
      LOG.log("Seed data for table '#{table_name.upcase}' is empty skipping...")
    else
      all_items.each_slice(25) { |this_batch|
        items = []
        this_batch.each { |this_item| items << {put_request: {item: this_item}} }
        request = {request_items: {table_name => items}}
        begin
          @aws_db.batch_write_item(request)
        rescue => e
          LOG.log("Could not upload seed to table #{table_name}", :warn)
          puts e.backtrace
        end
      }

      end_stamp = Time.now
      diff = ((end_stamp - start_stamp) * 1000.0).to_f / 1000.0
      LOG.log("Uploaded #{all_items.size} records to #{tier} \"#{table_name}\" table in #{diff} secs!")
    end
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

  def self.table_should_exist(table_name)
    unless @aws_db.list_tables.table_names.include?(table_name)
      LOG.log("Table '#{name.upcase}' not found.", :warn)
      exit
    end
  end

  def self.table_keys_should_match(table_name, keys)
    actual_keys = []
    resp = @aws_db.describe_table({table_name: table_name})
    resp.table.key_schema.each { |this_key| actual_keys << this_key.attribute_name }
    unless keys == actual_keys
      Log.log("The keys in the the table #{table_name} have changed.", :warn)
      exit
    end
  end
end

# Logger
class LOG
  def self.log(msg, level = :info)
    print_message = msg if level == :info
    print_message = "************************************** WARNING *************************************\n#{msg}" if level == :warn
    puts print_message
  end
end
