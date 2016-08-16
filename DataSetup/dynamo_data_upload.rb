#!/usr/bin/env ruby
require 'bundler/setup'
require 'aws-sdk'
require_relative 'table_details'
require_relative 'options_manager'

class DynamoDataUploader


  DEFAULT_AWS_ENDPOINT = 'https://dynamodb.us-east-1.amazonaws.com'
  DEFAULT_AWS_REGION = 'us-east-1'
  DEFAULT_AWS_ACCESS_KEY = ENV['AWS_ACCESS_KEY_ID']
  DEFAULT_AWS_SECRET_KEY = ENV['AWS_SECRET_ACCESS_KEY']
  DEFAULT_LOCAL_DB_ENDPOINT = 'http://localhost:8000'
  DEFAULT_LOCAL_REGION = 'localhost'
  SEED_DATA_FOLDER = 'seed_data_for_upload'
  SEED_FILE_PREFIX = 'nci_match_bddtests_seed_data'



  def self.backup_all_local_db
    TableDetails.all_tables.each { |table_name|
      backup_local_table(table_name)
    }
    p 'Done!'
  end

  def self.backup_local_table(table_name)
    query_table_name = table_name
    if query_table_name.start_with?('treatment_arm')
      query_table_name = table_name + '_development'
    end
    cmd = "aws dynamodb scan --table-name #{query_table_name} "
    cmd = cmd + "--endpoint-url #{DEFAULT_LOCAL_DB_ENDPOINT} > "
    cmd = cmd + File.dirname(__FILE__)+"/#{SEED_DATA_FOLDER}/#{SEED_FILE_PREFIX}_#{table_name}.json"
    `#{cmd}`
    p "Table <#{table_name}> has been exported"
  end


  def initialize(options)
    if options=='local'
      @endpoint = DEFAULT_LOCAL_DB_ENDPOINT
      @region = DEFAULT_LOCAL_REGION
      @access_key = DEFAULT_AWS_ACCESS_KEY
      @secret_key = DEFAULT_AWS_SECRET_KEY
    elsif options=='default'
      @endpoint = DEFAULT_AWS_ENDPOINT
      @region = DEFAULT_AWS_REGION
      @access_key = DEFAULT_AWS_ACCESS_KEY
      @secret_key = DEFAULT_AWS_SECRET_KEY
    else
      if options[:endpoint].nil?
        @endpoint = DEFAULT_AWS_ENDPOINT
      else
        @endpoint = options[:endpoint]
      end
      if options[:region].nil?
        @region = DEFAULT_AWS_REGION
      else
        @region = options[:region]
      end
      if options[:aws_access_key_id].nil?
        @access_key = DEFAULT_AWS_ACCESS_KEY
      else
        @access_key = options[:aws_access_key_id]
      end
      if options[:@secret_key].nil?
        @secret_key = DEFAULT_AWS_SECRET_KEY
      else
        @secret_key = options[:@secret_key]
      end
    end

    Aws.config.update({endpoint: @endpoint,
                       access_key_id: @access_key,
                       secret_access_key: @secret_key,
                       region: @region})
    @aws_db = Aws::DynamoDB::Client.new()
    p "AWS endpoint: #{@endpoint}, region: #{@region}"
  end

  def upload_patient_data_to_aws
    start_stamp = Time.now
    # TableDetails.patient_tables.each { |table_name| upload_patient_table_to_aws(table_name) }
    TableDetails.patient_tables.each { |table_name| upload_table_to_aws(table_name) }
    end_stamp = Time.now
    diff = (end_stamp - start_stamp) * 1000.0
    p "All patient local to aws works done! It took #{diff.to_f/1000.0} seconds"
  end

  def upload_treatment_arm_to_aws
    start_stamp = Time.now
    TableDetails.treatment_arm_tables.each { |table_name| upload_table_to_aws(table_name) }
    end_stamp = Time.now
    diff = (end_stamp - start_stamp) * 1000.0
    p "All treatment arm local to aws works done! It took #{diff.to_f/1000.0} seconds"
  end

  def upload_table_to_aws(table_name)
    file_location = "#{File.dirname(__FILE__)}/#{SEED_DATA_FOLDER}/#{SEED_FILE_PREFIX}_#{table_name}.json"
    local_json = JSON.parse(File.read(file_location))
    items = local_json['Items']
    put_requests = Array.new
    items_count = 0
    items.each_with_index do |this_item, index|
      converted_item = Hash.new
      this_item.keys.each do |this_field|
        unless is_a_valid_field(table_name, this_field, this_item[this_field])
          return
        end

        converted_item[this_field] = extract_value(this_item[this_field])
      end
      put_requests << {put_request:{item:converted_item}}
      if put_requests.count==25 || (index == (items.count - 1) && put_requests.count>0)
        request = {:request_items=>{table_name=>put_requests}}
        @aws_db.batch_write_item(request)
        items_count += put_requests.count
        put_requests.clear
      end
      # @aws_db.put_item({:table_name => table_name, :item => converted_item})
    end

    p "#{items_count} #{table_name} items are writen!"
  end

  def extract_value(field_object)
    if field_object.keys[0] == 'M'
      result = Hash.new
      field_object.values[0].each do |key, value|
        result[key] = value.values[0]
      end
      result
    elsif field_object.keys[0] == 'N'
      field_object.values[0].to_f
    #   if field_object.values[0].include? '.'
    #     field_object.values[0].to_f
    #   else
    #     field_object.values[0].to_i
    #   end
    # elsif field_object.keys[0] == 'BOOL'
    #   if field_object.values[0].eql? 'true'
    #     true
    #   else
    #     false
    #   end
    elsif field_object.keys[0] == 'L'
      result = Array.new
      field_object.values[0].each do |item|
        result << extract_value(item)
      end
      result
    elsif field_object.keys[0] == 'NULL'
      return nil
    else
      field_object.values[0]
    end
  end

  def is_a_valid_field(class_name, field_name, field_object)
    length_correct = field_object.keys.length == 1
    unless length_correct
      p "#{class_name}-#{field_name} has #{field_object.keys.length} keys"
    end

    acceptable_types = %w(M S BOOL N L NULL)
    type_correct = acceptable_types.include?(field_object.keys[0])
    unless type_correct
      p "#{class_name}-#{field_name} has invalid key #{field_object.keys[0]}"
    end
    length_correct&&type_correct
  end
end

if __FILE__ == $0
  options = OptionsManager.parse(ARGV)
  DynamoDataUploader.new(options).upload_patient_data_to_aws
  DynamoDataUploader.new(options).upload_treatment_arm_to_aws
end