require 'fileutils'
require 'json'
require 'active_support'
require 'active_support/core_ext'
require_relative 'log'


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
end