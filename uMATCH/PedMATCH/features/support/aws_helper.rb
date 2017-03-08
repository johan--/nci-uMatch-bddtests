require 'aws-sdk'

module AWSHelper
  class S3
    def self.setup_client(endpoint='https://s3.amazonaws.com', region='us-east-1')
      @s3 ||= Aws::S3::Resource.new(
          endpoint: endpoint,
          region: region,
          access_key_id: ENV['AWS_ACCESS_KEY_ID'],
          secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'])
    end

    def self.list_files(bucket,
        path,
        endpoint='https://s3.amazonaws.com',
        region='us-east-1'
    )
      setup_client(endpoint, region)
      files = @s3.bucket(bucket).objects(prefix: path).collect(&:key)
      files
    end

    def self.file_exists(bucket, file_path)
      files = s3_list_files(bucket, file_path)
      if files.length>0
        return s3_list_files(bucket, file_path).include?(file_path)
      else
        return false
      end
    end

    def self.delete_path(bucket,
        path,
        endpoint='https://s3.amazonaws.com',
        region='us-east-1'
    )
      setup_client(endpoint, region)
      files = @s3.bucket(bucket).objects(prefix: path)
      files.each { |this_file|
        this_file.delete
        if ENV['print_log'] == 'YES'
          puts "Deleted #{this_file.identifiers[:key]} from bucket <#{this_file.identifiers[:bucket_name]}>"
        end
      }
    end

    def self.download_file(bucket, s3_path, download_target)
      cmd = "aws s3 cp s3://#{bucket}/#{s3_path} #{download_target}  --recursive --region us-east-1"
      `#{cmd}`
      puts "#{download_target} has been downloaded from S3 #{bucket}/#{s3_path}" if ENV['print_log'] == 'YES'
    end

    def self.upload_file(file_path, bucket, s3_path)
      recursive = ''
      if File.directory?(file_path)
        recursive = '--recursive'
      end
      cmd = "aws s3 cp #{file_path}  s3://#{bucket}/#{s3_path} #{recursive} --region us-east-1"
      `#{cmd}`
      puts "#{file_path} has been uploaded to S3 #{bucket}/#{s3_path}" if ENV['print_log'] == 'YES'
    end

    def self.cp_single_file(source_path, target_path)
      cmd = "aws s3 cp #{source_path} #{target_path} --region us-east-1"
      `#{cmd}`
      puts "#{source_path} has been uploaded to #{target_path}" if ENV['print_log'] == 'YES'
    end

    def self.sync_folder(source_folder, target_folder)
      cmd = "aws s3 sync #{source_folder} #{target_folder} --region us-east-1"
      `#{cmd}`
      puts "#{target_folder} has been synced from #{source_folder}" if ENV['print_log'] == 'YES'
    end
  end
  class Dynamodb
    def self.setup_client
      @dynamodb_client ||= Aws::DynamoDB::Client.new(
          endpoint: ENV['dynamodb_endpoint'],
          region: ENV['dynamodb_region'],
          access_key_id: ENV['AWS_ACCESS_KEY_ID'],
          secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'])
    end

    def self.table_items(table, criteria={}, columns=[])
      setup_client
      filter = {}
      criteria.map { |k, v| filter[k] = {comparison_operator: 'EQ', attribute_value_list: [v]} }
      scan_option = {table_name: table}
      scan_option['scan_filter'] = filter if filter.length>0
      scan_option['conditional_operator'] = 'AND' if filter.length>1
      scan_option['attributes_to_get'] = columns if columns.length>0
      # table_content = @dynamodb_client.scan(scan_option)
      # table_content.items
      dynamodb_scan_all(scan_option)
    end

    def self.scan_all(opt, start_key={})
      return {} if start_key.nil?
      if start_key.size > 0
        opt['exclusive_start_key'] = start_key
      end
      scan_result = @dynamodb_client.scan(opt)
      items = scan_result.items
      items.push(*dynamodb_scan_all(opt, scan_result.last_evaluated_key))
    end

    def self.table_distinct_column(table, criteria={}, distinct_column)
      setup_client
      all_result = dynamodb_table_items(table, criteria)
      all_result.map { |hash| hash[distinct_column] }.uniq
    end

    def self.table_primary_key(table)
      setup_client
      resp = @dynamodb_client.describe_table({table_name: table})
      key = 'no_sorting_key'
      resp.table.key_schema.each { |this_key|
        if this_key.key_type == 'HASH'
          key = this_key.attribute_name
        end
      }
      key
    end

    def self.table_sorting_key(table)
      setup_client
      resp = @dynamodb_client.describe_table({table_name: table})
      key = 'no_sorting_key'
      resp.table.key_schema.each { |this_key|
        if this_key.key_type == 'RANGE'
          key = this_key.attribute_name
        end
      }
      key
    end
  end
end