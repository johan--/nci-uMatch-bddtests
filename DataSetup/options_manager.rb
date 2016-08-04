require 'optparse'
require 'ostruct'

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
      #
      # opts.on("-p p", "--prefix=p", "[Required] Prefix/Suffix of the table that needs to be cleared") do |prefix|
      #   options.prefix = prefix
      # end

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