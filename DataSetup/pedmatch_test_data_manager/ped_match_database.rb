#!/usr/bin/env ruby
require 'bundler/setup'
require 'aws-sdk'
require 'json'
require 'active_support'
require 'active_support/core_ext'
require_relative 'table_info'
require_relative 'log'
require_relative 'seed_file'
require_relative 'constants'

class PedMatchDatabase

  ################backup
  def self.backup(tag='patients')
    TableInfo.all_tables.each {|table|
      copy_table_to_file(table, SeedFile.seed_file(table, tag)) if table_exist(table)
    }
    Log.info('Local backup done!')
  end

  def self.dump_int
    tag = 'int_dump'
    SeedFile.create_tag_if_not_exist(tag, false)
    TableInfo.all_tables.each {|table|
      copy_table_to_file(table, SeedFile.seed_file(table, tag), Constants.tier_int) if table_exist(table)
    }
  end

  def self.backup_treatment_arm(tag='patients')
    TableInfo.treatment_arm_tables.each {|table|
      copy_table_to_file(table, SeedFile.seed_file(table, tag)) if table_exist(table)
    }
    Log.info('Local treatment arm tables backup done!')
  end

  def self.backup_ion(tag='patients')
    TableInfo.ion_tables.each {|table|
      copy_table_to_file(table, SeedFile.seed_file(table, tag)) if table_exist(table)
    }
    Log.info('Local treatment arm tables backup done!')
  end

  def self.copy_table_to_file(table_name, file, tier=Constants.tier_local)
    current_tier = Constants.current_tier
    Constants.set_tier(tier)
    cmd = "aws dynamodb scan --table-name #{table_name} "
    cmd = cmd + "--endpoint-url #{Constants.dynamodb_url} > "
    cmd = cmd + file
    `#{cmd}`
    Constants.set_tier(current_tier)
    Log.info("Table <#{table_name}> has been exported to #{file}")
  end

  ################reload
  def self.reload_local(tag='patients')
    clear_all_local(true, tag)
    upload_seed_data_to_local(tag)
  end

  def self.reload_int(tag='patients')
    clear_all_int
    upload_seed_data_to_int(tag)
  end

  def self.load_int_to_local
    dump_int
    reload_local('int_dump')
  end

  ################clear
  def self.clear_all_local(only_items_not_in_seed = false, tag = nil)
    tier = Constants.current_tier
    Constants.set_tier(Constants.tier_local)
    TableInfo.all_tables.each {|table|
      if only_items_not_in_seed
        raise 'When set only_items_not_in_seed to true, tag parameter is required' if tag.nil?
        all_db_keys = scan_all(table, TableInfo.keys(table))
        all_seed_keys = SeedFile.all_keys(table, tag)
        keys_need_delete = all_db_keys - all_seed_keys
        clear_by_keys(table, keys_need_delete)
      else
        clear_table(table)
      end
    }
    Constants.set_tier(tier)
    Log.info('Clear local dynamodb done!')
  end

  def self.clear_all_int(only_items_not_in_seed = false, tag = nil)
    tier = Constants.current_tier
    Constants.set_tier(Constants.tier_int)
    TableInfo.all_tables.each {|table|
      if only_items_not_in_seed
        raise 'When set only_items_not_in_seed to true, tag parameter is required' if tag.nil?
        all_db_keys = scan_all(table, TableInfo.keys(table))
        all_seed_keys = SeedFile.all_keys(table, tag)
        keys_need_delete = all_db_keys - all_seed_keys
        clear_by_keys(table, keys_need_delete)
      else
        clear_table(table)
      end
    }
    Constants.set_tier(tier)
    Log.info('Clear int dynamodb done!')
  end

  def self.clear_by_keys(table_name, keys)
    if keys.nil? || keys.size<1
      Log.info("Table '#{table_name.upcase}' is empty skipping...")
    else
      start_stamp = Time.now
      deleted = 0
      batch_size = 25
      keys.each_slice(batch_size) {|this_batch|
        items = []
        this_batch.each {|this_item| items << {delete_request: {key: this_item}}}
        request = {request_items: {table_name => items}}
        begin
          ddb.batch_write_item(request)
          deleted += items.size
        rescue => e
          Log.warning("Could not delete table #{table_name}")
          Log.warning(e.backtrace)
        end
      }
      end_stamp = Time.now
      diff = ((end_stamp - start_stamp) * 1000.0).to_f / 1000.0
      message = "Deleted #{deleted}/#{keys.size} records from #{Constants.current_tier} "
      message += "\"#{table_name}\" table in #{diff} secs!"
      Log.info(message)
      unless deleted == keys.size
        raise "Expected to delete #{keys.size} items, actually deleted #{deleted} items"
      end
    end
  end

  def self.clear_table(table_name)
    unless table_exist(table_name)
      return
    end
    table_keys = TableInfo.keys(table_name)
    table_keys_should_match(table_name, table_keys)

    all_items = scan_all(table_name, table_keys)
    clear_by_keys(table_name, all_items)
  end

  #################upload
  def self.upload_seed_data_to_local(tag='patients')
    tier = Constants.current_tier
    Constants.set_tier(Constants.tier_local)
    TableInfo.all_tables.each do |table|
      upload_seed_data(table, tag)
    end
    Constants.set_tier(tier)
    Log.info('Upload to local dynamodb done!')
  end

  def self.upload_ion_seed_to_local(tag='patient')
    tier = Constants.current_tier
    Constants.set_tier(Constants.tier_local)
    TableInfo.ion_tables.each {|table| upload_seed_data(table, tag)}
    Constants.set_tier(tier)
    Log.info('Upload ion seed to local dynamodb done!')
  end

  def self.upload_seed_data_to_int(tag='patients')
    tier = Constants.current_tier
    Constants.set_tier(Constants.tier_int)
    TableInfo.all_tables.each do |table|
      upload_seed_data(table, tag)
    end
    Constants.set_tier(tier)
    Log.info('Upload to int dynamodb done!')
  end

  def self.upload_seed_data(table_name, tag)
    all_items = SeedFile.all_items(table_name, tag)
    return unless table_exist(table_name)
    table_keys = TableInfo.keys(table_name)
    table_keys_should_match(table_name, table_keys)

    start_stamp = Time.now

    if all_items.nil? || all_items.size<1
      Log.info("Seed data for table '#{table_name.upcase}' is empty skipping...")
    else
      uploaded = 0
      batch_size = 25
      all_items.each_slice(batch_size) {|this_batch|
        items = []
        this_batch.each {|this_item|
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
          ddb.batch_write_item(request)
          uploaded += items.size
        rescue => e
          Log.warning("Could not upload seed to table #{table_name}")
          Log.warning(e.backtrace)
        end
      }

      end_stamp = Time.now
      diff = ((end_stamp - start_stamp) * 1000.0).to_f / 1000.0
      message = "Uploaded #{uploaded}/#{all_items.size} records to #{Constants.current_tier} "
      message += "\"#{table_name}\" table in #{diff} secs!"
      Log.info(message)
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
      Log.warning("#{class_name}-#{field_name} has #{field_object.keys.length} keys")
    end

    acceptable_types = %w(M S BOOL N L NULL)
    type_correct = acceptable_types.include?(field_object.keys[0])
    unless type_correct
      Log.warning("#{class_name}-#{field_name} has invalid key #{field_object.keys[0]}")
    end
    length_correct && type_correct
  end


  #################aws unitilies
  def self.ddb
    @aws_options = {
        endpoint: Constants.dynamodb_url,
        region: Constants.dynamodb_region,
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    }
    Aws.config.update(@aws_options)
    @dynamodb ||= Aws::DynamoDB::Client.new
  end

  def self.table_exist(table_name)
    exist = ddb.list_tables.table_names.include?(table_name)
    Log.warning("Table '#{table_name.upcase}' not found.") unless exist
    exist
  end

  def self.table_keys_should_match(table_name, keys)
    actual_keys = []
    resp = ddb.describe_table({table_name: table_name})
    resp.table.key_schema.each {|this_key| actual_keys << this_key.attribute_name}
    unless keys == actual_keys
      Log.warning("The keys in the the table #{table_name} have changed.")
      exit
    end
  end

  def self.scan_all(table_name, attribute_to_get, start_key={})
    return {} if start_key.nil?
    if start_key.size > 0
      scan_result = ddb.scan(table_name: table_name,
                             attributes_to_get: attribute_to_get,
                             exclusive_start_key: start_key)
    else
      scan_result = ddb.scan(table_name: table_name,
                             attributes_to_get: attribute_to_get)
    end
    items = scan_result.items
    items.push(*scan_all(table_name, attribute_to_get, scan_result.last_evaluated_key))
  end
end