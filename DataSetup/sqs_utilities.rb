#!/usr/bin/env ruby
require 'bundler/setup'
require 'aws-sdk'
require 'json'

class SQSUtilities
  def self.setup_aws
    @aws_options = {
        region: 'us-east-1',
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    }
    Aws.config.update(@aws_options)
    @aws_sqs = Aws::SQS::Client.new
  end

  def self.list_queue_urls
    setup_aws
    @aws_sqs.list_queues['queue_urls']
  end

  def self.queue_exist(queue_name)
    list_queue_urls.any?{|this_url| this_url.end_with?("/#{queue_name}")}
  end

  def self.purge_queue(queue_name)
    unless queue_exist(queue_name)
      raise "#{queue_name} is not a valid SQS queue name"
    end
    queue_url = "https://sqs.us-east-1.amazonaws.com/127516845550/#{queue_name}"
    @aws_sqs.purge_queue({queue_url:queue_url})
    puts "SQS queue #{queue_name} is purged"
  end
end