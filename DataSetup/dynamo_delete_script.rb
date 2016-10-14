#!/usr/bin/env ruby
require 'aws-sdk'
require 'json'
require 'java-properties'
require_relative 'table_details'
require_relative 'options_manager'

class DynamoDb
  attr_accessor :client
  DEFAULT_AWS_ENDPOINT = 'https://dynamodb.us-east-1.amazonaws.com'
  DEFAULT_AWS_REGION = 'us-east-1'
  DEFAULT_ENDPOINT = 'http://localhost:8000'
  DEFAULT_REGION = 'us-east-1'
  DEFAULT_FILENAME = File.expand_path(File.join(ENV['HOME'], '.aws/credentials'))
  DEFAULT_LOCAL_DB_ENDPOINT = 'http://localhost:8000'
  DEFAULT_LOCAL_REGION = 'localhost'
  DEFAULT_AWS_ACCESS_KEY = ENV['AWS_ACCESS_KEY_ID']
  DEFAULT_AWS_SECRET_KEY = ENV['AWS_SECRET_ACCESS_KEY']

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
    list_tables.select { |table| table.match(regex)}
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
      @client.scan(table_name: name)['items'].each do |elem|
        row = {}
        table_details[:keys].each do |key|
          row[key.to_sym] = elem[key]
        end
        table_list << row
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
    dev_table  = "#{name}_development"
    test_table = "#{name}_test"
    @endpoint =~ /localhost/ ? dev_table : test_table
  end

  def clear_table(table_name)
    # table_name = add_suffix(table_name) if table_name =~ /treatment_arm/
    # Keeping this here if we need it
    list = collect_key_list(table_name)
    message = []
    message << table_name.upcase

    return if list.nil?

    if list.size.zero?
      LOG.log("Table '#{table_name.upcase}' is empty skipping...")
      return
    end
    list.each do |keys|
      key = keys.flatten.first
      message << "Deleting #{key}: #{keys[key]} from #{table_name}"
      begin
        @client.delete_item(table_name: table_name, key: keys)
      rescue  Aws::DynamoDB::Errors::ValidationException => e
        puts "The keys in the the table #{table_name} have changed."
      rescue => e
        puts "Could not delete table #{table_name}"
        p e.backtrace
      end
    end
    LOG.log(message)
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
