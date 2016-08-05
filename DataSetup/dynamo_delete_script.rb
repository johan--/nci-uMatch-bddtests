#!/usr/bin/env ruby
require 'aws-sdk'
require 'json'
require 'java-properties'
require_relative 'table_details'
require_relative 'options_manager'

class DynamoDb
  attr_accessor :client
  DEFAULT_ENDPOINT = 'http://localhost:8000'
  DEFAULT_REGION = 'us-east-1'
  DEFAULT_FILENAME = File.expand_path(File.join(ENV['HOME'], '.aws/credentials'))
  DEFAULT_LOCAL_DB_ENDPOINT = 'http://localhost:8000'
  DEFAULT_LOCAL_REGION = 'localhost'
  DEFAULT_AWS_ACCESS_KEY = ENV['AWS_ACCESS_KEY_ID']
  DEFAULT_AWS_SECRET_KEY = ENV['AWS_SECRET_ACCESS_KEY']

  def initialize(options)
    # @prefix = options[:prefix]
    # raise "Provide the prefix or the suffix of the list of tables that you want cleared" if @prefix.nil?

    if options=='local'
      @client = Aws::DynamoDB::Client.new(
          endpoint: DEFAULT_LOCAL_DB_ENDPOINT,
          access_key_id: DEFAULT_AWS_ACCESS_KEY,
          secret_access_key: DEFAULT_AWS_SECRET_KEY,
          region: DEFAULT_LOCAL_REGION
      )
      return
    end

    if options[:endpoint].nil?
      LOG.log("Using Default Endpoint: #{DEFAULT_ENDPOINT}", 'INFO')
      @endpoint = DEFAULT_ENDPOINT
    else
      @endpoint = options[:endpoint]
    end

    if options[:region].nil?
      LOG.log("Using Default Region: #{DEFAULT_REGION}", 'INFO') if options[:region].nil?
      @region = DEFAULT_REGION
    else
      @region = options[:region]
    end


    if options[:file_name].nil? && (options[:endpoint].nil? && options[:aws_access_key_id].nil? && options[:aws_secret_access_key].nil?)
      LOG.log("Using credential file located at #{DEFAULT_FILENAME}", 'INFO')
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

    LOG.log("File location: #{@file_location} \nendpoint: #{@endpoint}\nregion: #{@region}", 'INFO')

    @client = Aws::DynamoDB::Client.new(
        endpoint: @endpoint,
        access_key_id: @access_key,
        secret_access_key: @secret_key,
        region: @region
    )
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

  def clear_tables_by_prefix
    begin
      table_list = select_tables
      LOG.log "Tables being cleared: \n#{table_list}", 'INFO'
      table_list.each do |table|
        LOG.log("Sending delete Request for #{table}", 'INFO')
        @client.delete_table({table_name: table})
        sleep(1)
      end
    rescue
      LOG.log("Delete Process Terminated. Resetting the delete process", 'WARN')
      sleep(10)
      retry
    end
  end

  def collect_key_list(name)
    table_details = TableDetails.const_get(name.upcase)
    table_list = []
    begin
    @client.scan(table_name: name)['items'].each do |elem|
      row = {}
      table_details[:keys].each do |key|
        row[key.to_sym] = elem[key]
      end
      table_list << row
    end
    rescue => e
      p e
    end

    table_list
  end

  def clear_table(table_name)
    list = collect_key_list(table_name)
    return if list.empty?
    list.each do |keys|
      key = keys.flatten.first
      puts "Deleting #{key}: #{keys[key]} from #{table_name}"
      @client.delete_item(table_name: table_name, key: keys)
    end
  end

  def clear_all_tables
    TableDetails.all_tables.each { |table| clear_table(table) }
  end
end

class LOG
  def self.log(msg, level)
    print_message = msg if level == 'INFO'
    print_message = "************************************** WARNING *************************************\n#{msg}" if level =='WARN'
    puts print_message
  end
end

if __FILE__ == $0
  options = OptionsManager.parse(ARGV)
  # DynamoDb.new(options).clear_tables_by_prefix
  DynamoDb.new(options).clear_all_tables
end
