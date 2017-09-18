require 'fileutils'
require 'json'
require 'active_support'
require 'active_support/core_ext'
require_relative 'log'
require 'aws-sdk'


class Utilities
  BDD_IR = 'bdd_test_ion_reporter'
  DEV_BUCKET = 'pedmatch-dev'
  INT_BUCKET = 'pedmatch-int'


  def self.upload_vr(moi, ani, type='default')
    template_folder = "#{File.dirname(__FILE__)}/../variant_file_templates"
    output_folder = "#{template_folder}/upload"
    target_ani_path = "#{output_folder}/#{moi}/#{ani}"
    template_ani_path = "#{template_folder}/#{type}"

    FileUtils.mkdir_p(target_ani_path)
    FileUtils.cp_r("#{template_ani_path}/.", target_ani_path)
    cmd = "aws s3 cp #{output_folder} s3://#{DEV_BUCKET}/#{BDD_IR}/ --recursive --region us-east-1"
    `#{cmd}`
    Log.info("#{target_ani_path} has been uploaded to S3 bucket #{DEV_BUCKET}")
    cmd = "aws s3 cp #{output_folder} s3://#{INT_BUCKET}/#{BDD_IR}/ --recursive --region us-east-1"
    `#{cmd}`
    Log.info("#{target_ani_path} has been uploaded to S3 bucket #{INT_BUCKET}")
    FileUtils.rm_r(output_folder)
  end

  def self.copy_json_to_int(file_path)
    dev_path = "s3://#{DEV_BUCKET}/#{file_path}"
    int_path = "s3://#{INT_BUCKET}/#{file_path}"
    cmd = "aws s3 cp #{dev_path} #{int_path} --region us-east-1"
    `#{cmd}`
    Log.info("#{dev_path} has been uploaded to #{int_path}")
    true
  end

  def self.sync_qc_report(moi, ani, json_name='test1.json')
    dev_path = "s3://#{DEV_BUCKET}/#{BDD_IR}/#{moi}/#{ani}/#{json_name}"
    int_path = "s3://#{INT_BUCKET}/#{BDD_IR}/#{moi}/#{ani}/#{json_name}"
    cmd = "aws s3 cp #{dev_path} #{int_path} --region us-east-1"
    `#{cmd}`
    Log.info("#{dev_path} has been uploaded to #{int_path}")
  end

  def self.dynamodb_client
    @dynamodb_client ||= Aws::DynamoDB::Client.new(
        endpoint: 'https://dynamodb.us-east-1.amazonaws.com',
        region: 'us-east-1',
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'])
    @dynamodb_client
  end

  def self.dynamodb_put_item(item_hash, table_name)
    dynamodb_client.put_item({:item => item_hash, :table_name => table_name})
  end

  def self.dynamodb_table_items(table, criteria={}, columns=[])
    filter = {}
    criteria.map {|k, v| filter[k] = {comparison_operator: 'EQ', attribute_value_list: [v]}}
    scan_option = {table_name: table}
    scan_option['scan_filter'] = filter if filter.length>0
    scan_option['conditional_operator'] = 'AND' if filter.length>1
    scan_option['attributes_to_get'] = columns if columns.length>0
    dynamodb_scan_all(scan_option)
  end

  def self.dynamodb_scan_all(opt, start_key={})
    return {} if start_key.nil?
    if start_key.size > 0
      opt['exclusive_start_key'] = start_key
    end
    scan_result = dynamodb_client.scan(opt)
    items = scan_result.items
    items.push(*dynamodb_scan_all(opt, scan_result.last_evaluated_key))
  end

  def self.dynamodb_table_distinct_column(table, distinct_column, criteria={})
    all_result = dynamodb_table_items(table, criteria)
    all_result.map {|hash| hash[distinct_column]}.uniq
  end
end