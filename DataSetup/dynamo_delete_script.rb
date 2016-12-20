#!/usr/bin/env ruby
require 'aws-sdk'
require 'json'
require 'java-properties'
require_relative 'table_details'
require_relative 'options_manager'

class DynamoDb
  attr_accessor :client
  # attr_accessor :sqs
  DEFAULT_AWS_ENDPOINT = 'https://dynamodb.us-east-1.amazonaws.com'
  DEFAULT_AWS_REGION = 'us-east-1'
  DEFAULT_ENDPOINT = 'http://localhost:8000'
  DEFAULT_REGION = 'us-east-1'
  DEFAULT_FILENAME = File.expand_path(File.join(ENV['HOME'], '.aws/credentials'))
  DEFAULT_LOCAL_DB_ENDPOINT = 'http://localhost:8000'
  DEFAULT_LOCAL_REGION = 'us-east-1'
  DEFAULT_AWS_ACCESS_KEY = ENV['AWS_ACCESS_KEY_ID']
  DEFAULT_AWS_SECRET_KEY = ENV['AWS_SECRET_ACCESS_KEY']
  DEFAULT_AWS_S3_ENDPOINT = 'https://s3.amazonaws.com'

  DEFAULT_OPTIONS = {
      access_key_id: DEFAULT_AWS_ACCESS_KEY,
      secret_access_key: DEFAULT_AWS_SECRET_KEY,
      region: DEFAULT_REGION
  }

  def initialize(options)
    # @prefix = options[:prefix]
    # raise "Provide the prefix or the suffix of the list of tables that you want cleared" if @prefix.nil?

    if options == 'local'
      @endpoint = DEFAULT_LOCAL_DB_ENDPOINT
      @region = DEFAULT_AWS_REGION
      @access_key = DEFAULT_AWS_ACCESS_KEY
      @secret_key = DEFAULT_AWS_SECRET_KEY
    elsif options=='default'
      @endpoint = DEFAULT_AWS_ENDPOINT
      @region = DEFAULT_AWS_REGION
      @access_key = DEFAULT_AWS_ACCESS_KEY
      @secret_key = DEFAULT_AWS_SECRET_KEY
    else
      if options[:endpoint].nil?
        LOG.log("Using Default Endpoint: #{DEFAULT_ENDPOINT}", :info)
        @endpoint = DEFAULT_ENDPOINT
      else
        @endpoint = options[:endpoint]
      end

      if options[:region].nil?
        LOG.log("Using Default Region: #{DEFAULT_REGION}", :info) if options[:region].nil?
        @region = DEFAULT_REGION
      else
        @region = options[:region]
      end

      if options[:file_name].nil? && (options[:endpoint].nil? && options[:aws_access_key_id].nil? && options[:aws_secret_access_key].nil?)
        LOG.log("Using credential file located at #{DEFAULT_FILENAME}", :info)
        @file_location = DEFAULT_FILENAME
        set_params_from_file
      elsif options[:aws_access_key_id] && options[:aws_secret_access_key]
        @access_key = options[:aws_access_key_id]
        @secret_key = options[:aws_secret_access_key]
      elsif options[:file_name]
        @file_location = options[:file_name]
        set_params_from_file
      else
        raise "One or more required parameters missing. Please run ./dynamo_delete_script.rb -h for more help"
      end
    end

    LOG.log("File location: #{@file_location} \nendpoint: #{@endpoint}\nregion: #{@region}", :info)

    DEFAULT_OPTIONS.merge!(endpoint: @endpoint, region: @region)

    Aws.config.update({endpoint: @endpoint,
                       access_key_id: @access_key,
                       secret_access_key: @secret_key,
                       region: @region})
    @client = Aws::DynamoDB::Client.new()
    # @sqs = Aws::SQS::Client.new()
  end

  def set_params_from_file
    file_contents = JavaProperties.load(@file_location)

    @access_key = file_contents[:aws_access_key_id]
    @secret_key = file_contents[:aws_secret_access_key]
  end

  # returns an array of the tables rather than the AWS object
  def list_tables
    @client.list_tables.table_names
  end

  def select_tables
    regex = Regexp.new(@prefix)
    list_tables.select { |table| table.match(regex) }
  end

  def delete_treatment_arm_tables
    @prefix = 'treatment_arm'
    clear_tables_by_prefix
  end

  def delete_patient_tables
    %w(assignment event patient shipment specimen variant variant_report).each do |table|
      @prefix = hgtable
      clear_tables_by_prefix
    end
  end

  def delete_all_tables
    delete_treatment_arm_tables
    delete_patient_tables
  end


  def clear_tables_by_prefix
    begin
      table_list = select_tables
      LOG.log "Tables being cleared: \n#{table_list}", :info
      table_list.each do |table|
        LOG.log("Sending delete Request for #{table}", :info)
        @client.delete_table({table_name: table})
        sleep(1)
      end
    rescue
      LOG.log("Delete Process Terminated. Resetting the delete process", :warn)
      sleep(10)
      retry
    end
  end

  def collect_key_list(name)
    actual_table_name = name.gsub(/_(development|test)/, '').upcase
    table_details = TableDetails.const_get(actual_table_name)
    table_list = []
    begin
      # table_list = @client.scan(table_name: name, attributes_to_get: table_details[:keys])['items']
      @client.scan(table_name: name, attributes_to_get: table_details[:keys])['items'].each do |this_item|
        table_list << {delete_request: {key: this_item}}
      end
    rescue Aws::DynamoDB::Errors::ResourceNotFoundException => e
      LOG.log("Table '#{name.upcase}' not found.", :warn)
      table_list = nil
    rescue => e
      p e.backtrace
    end
    table_list
  end

  def add_suffix(name)
    dev_table = "#{name}_development"
    test_table = "#{name}_test"
    @endpoint =~ /localhost/ ? dev_table : test_table
  end

  def clear_table(table_name)

    # table_name = add_suffix(table_name) if table_name =~ /treatment_arm/
    # Keeping this here if we need it
    list = collect_key_list(table_name)
    return if list.nil?

    start_stamp = Time.now
    message = list.size
    batch_limit = 25
    list.each_slice(batch_limit) do |group|
      request = {request_items: {table_name => group}}
      begin
        @client.batch_write_item(request)
      rescue Aws::DynamoDB::Errors::ValidationException => e
        puts "The keys in the the table #{table_name} have changed."
      rescue => e
        puts "Could not delete table #{table_name}"
        p e.backtrace
      end
    end

    if message>0
      end_stamp = Time.now
      diff = (end_stamp - start_stamp) * 1000.0
      LOG.log("Deleted #{message} records from the #{table_name} in #{diff.to_f / 1000.0} secs!")
    else
      LOG.log("Table '#{table_name.upcase}' is empty skipping...")
    end
    #
    # delete_request = []
    # list.each_with_index do |keys, index|
    #   delete_request << {delete_request: {key: keys}}
    #   if delete_request.count == 25 || (index == (list.count - 1) && delete_request.count > 0)
    #     request = {request_items: {table_name => delete_request}}
    #     begin
    #       @client.batch_write_item(request)
    #       message += delete_request.count
    #       delete_request.clear
    #     rescue Aws::DynamoDB::Errors::ValidationException => e
    #       puts "The keys in the the table #{table_name} have changed."
    #     rescue => e
    #       puts "Could not delete table #{table_name}"
    #       p e.backtrace
    #     end
    #   end
    # end
    # LOG.log("Deleted #{message} records from the #{table_name}")
  end

  def get_keys_from_table(table_name)
    result = []
    table_detail = @client.describe_table({table_name: table_name})
    table_detail.table.key_schema.each { |this_schema|
      result << this_schema.attribute_name }
    result
  end

  def clear_all_tables
    LOG.log('Deleting tables patient and treatment arm ecosystem')
    TableDetails.all_tables.each do |table|
      clear_table(table)
    end
  end

  def clear_all_patient_tables
    LOG.log('Deleting tables patient ecosystem')
    TableDetails.patient_tables.each do |table|
      clear_table(table)
    end
  end

  def clear_all_treatment_arm_tables
    LOG.log('Deleting tables treatment arm ecosystem')
    TableDetails.treatment_arm_tables.each do |table|
      clear_table(table)
    end
  end

  def clear_all_ion_tables
    LOG.log('Deleting tables ion ecosystem')
    TableDetails.ion_tables.each do |table|
      clear_table(table)
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

if __FILE__ == $0
  options = OptionsManager.parse(ARGV)
  # DynamoDb.new(options).clear_tables_by_prefix
  DynamoDb.new(options).clear_all_tables
end
