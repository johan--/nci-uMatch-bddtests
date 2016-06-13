#!/usr/bin/env ruby
require 'aws-sdk'
require 'json'
require 'optparse'
require 'ostruct'
require 'java-properties'

class DynamoDb
  attr_accessor :client
  DEFAULT_ENDPOINT = 'http://localhost:8000'
  DEFAULT_REGION = 'us-east-1'
  DEFAULT_FILENAME = File.expand_path(File.join(ENV['HOME'], '.aws/credentials'))

  def initialize(options)
    @prefix = options[:prefix]
    raise "Provide the prefix or the suffix of the list of tables that you want cleared" if @prefix.nil?

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
    while select_tables.size > 0
      begin
	table_list = select_tables
        LOG.log "Tables being cleared: \n#{table_list}", 'INFO'
        table_list.each do |table|
          @client.delete_table({table_name: table})
        end
      rescue => e
        LOG.log("Delete Process Terminated. Resetting the delete process", 'WARN')
        sleep(10)
      end
        
    end
  end
end

class LOG
  def self.log(msg, level)
    print_message = msg if level == 'INFO'
    print_message = "#{3.times {puts "***************************************************************************"}}#{msg}" if level =='WARN'
    puts print_message
    puts "***************************************************************************"
  end
end

class OptionsManager
  def self.parse(args)
    options = OpenStruct.new
    options.file_name = nil
    options.endpoint = nil
    options.access_key_id = nil
    options.secret_access_key = nil
    options.region = nil

    opt_parser = OptParse.new do |opts|
      opts.banner = 'Usage ./dynamo_delete_script.rb [options]'

      opts.on("-p p", "--prefix=p", "[Required] Prefix/Suffix of the table that needs to be cleared") do |prefix|
        options.prefix = prefix
      end

      opts.on("-f f", "--file_name=f", "[Required] Location of aws credentials file. DEFAULT is <user_home>/.aws/credentials") do |file|
        options.file_name = file.to_s
      end

      opts.on("-e e", "--endpoint=e", "[Optional] Host name of DynamoDb. Default is http://localhost:8000") do |endpoint|
        options.endpoint = endpoint.to_s
      end

      opts.on("-a a", "--access_key=a", "[Optional] Access Key from AWS credentials. Required if no aws cred file is provided") do |akey|
        options.aws_access_key_id = akey.to_s
      end

      opts.on("-s s", "--secret_key=s", "[Optional] Secret access Key from AWS credentials.  Required if no aws cred file is provided") do |secret|
        options.aws_secret_access_key = secret.to_s
      end

      opts.on("-r r", "--region=r", "[Optional] Region of use. NOTE: Default value is 'us-east-1'") do |region|
        options.region = region.to_s
      end


    end
    opt_parser.parse!
    options
  end
end

options = OptionsManager.parse(ARGV)
DynamoDb.new(options).clear_tables_by_prefix
