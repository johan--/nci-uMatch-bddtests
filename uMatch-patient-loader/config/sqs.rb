require 'yaml'
require 'aws-sdk'

module Aws
  module Sqs
    class Publisher

      attr_accessor :client,
                    :url,
                    :queue_name


      def self.publish(message)
        begin

          p "==== @queue_name at publish: #{@queue_name}"

          @url = self.client.get_queue_url(queue_name: @queue_name).queue_url
          @client.send_message({queue_url: @url, :message_body => message.to_json})
        rescue Aws::SQS::Errors::ServiceError => error
          p error
        end
      end


      def self.client
        secrets = YAML.load_file("#{File.expand_path File.dirname(__FILE__)}/secrets.yml")
        configs = YAML.load_file("#{File.expand_path File.dirname(__FILE__)}/config.yml")

        end_point = configs['aws_sqs_endpoint']
        p "==== end point: #{end_point}"

        region = configs['aws_region']
        p "==== region: #{region}"

        @queue_name = configs['queue_name']
        p "==== @queue_name: #{@queue_name}"

        access_key = secrets['aws_access_key_id']
        aws_secret_access_key = secrets['aws_secret_access_key']

        creds = Aws::Credentials.new(access_key, aws_secret_access_key)

        @client ||= Aws::SQS::Client.new(endpoint: end_point,
                                         region: region,
                                         credentials: creds)

      end
    end
  end
end


