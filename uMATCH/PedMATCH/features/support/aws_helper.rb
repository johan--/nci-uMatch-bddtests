require 'aws-sdk'

class AWSHelper

  def self.dir(folder_path, base_name=false)
    raise "#{folder_path} is not a folder!" unless File.directory?(folder_path)
    if folder_path.end_with?('/')
      path = "#{folder_path}*"
    else
      path = "#{folder_path}/*"
    end
    result = Dir[path]
    if base_name
      result = result.collect {|f| File.basename(f)}
    end
    result
  end

  def self.s3_client(endpoint='https://s3.amazonaws.com', region='us-east-1')
    @s3 ||= Aws::S3::Resource.new(
        endpoint: endpoint,
        region: region,
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'])
    @s3
  end

  def self.s3_list_files(bucket, path)
    files = s3_client.bucket(bucket).objects(prefix: path).collect(&:key)
    files
  end

  def self.s3_file_exists(bucket, file_path)
    files = s3_list_files(bucket, file_path)
    if files.nil?
      return false
    else
      return files.include?(file_path)
    end
  end

  def self.s3_delete_path(bucket, path)
    files = s3_client.bucket(bucket).objects(prefix: path)
    files.each {|this_file|
      this_file.delete
      puts "Deleted #{this_file.identifiers[:key]} from bucket <#{this_file.identifiers[:bucket_name]}>"
    }
  end

  def self.s3_download_file(bucket, s3_path, download_target)
    s3_client.bucket(bucket).object(s3_path).download_file(download_target)
    puts "#{download_target} has been downloaded from S3 #{bucket}/#{s3_path}"
  end

  def self.s3_upload_file(bucket, local_file, aws_file)
    s3_client.bucket(bucket).object(aws_file).upload_file(local_file)
    puts "#{file_path} has been uploaded to S3 #{bucket}/#{s3_path}"
  end

  def self.s3_upload_folder(bucket, aws_folder, local_folder)
    files = dir(local_folder)
    if files.size < 1
      puts "#{local_folder} has no content, nothing will be uploaded to s3"
      return
    end
    files.each {|this_file_name|
      if aws_folder.end_with?('/')
        aws_path = "#{aws_folder}#{File.basename(this_file_name)}"
      else
        aws_path = "#{aws_folder}/#{File.basename(this_file_name)}"
      end
      obj = s3_client.bucket(bucket).object(aws_path)
      obj.upload_file(this_file_name)
      puts "Uploaded file #{this_file_name} to S3 folder: #{aws_folder}"
    }
  end

  def self.s3_cp_single_file(source_path, target_path)
    cmd = "aws s3 cp #{source_path} #{target_path} --region us-east-1"
    `#{cmd}`
    puts "#{source_path} has been uploaded to #{target_path}" if ENV['print_log'] == 'YES'
  end

  def self.s3_sync_folder(source_folder, target_folder)
    cmd = "aws s3 sync #{source_folder} #{target_folder} --region us-east-1"
    `#{cmd}`
    puts "#{target_folder} has been synced from #{source_folder}" if ENV['print_log'] == 'YES'
  end

  def self.dynamodb_client
    @dynamodb_client ||= Aws::DynamoDB::Client.new(
        endpoint: ENV['dynamodb_endpoint'],
        region: ENV['dynamodb_region'],
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'])
    @dynamodb_client
  end

  def self.dynamodb_table_items(table, criteria={}, columns=[])
    filter = {}
    criteria.map {|k, v| filter[k] = {comparison_operator: 'EQ', attribute_value_list: [v]}}
    scan_option = {table_name: table}
    scan_option['scan_filter'] = filter if filter.length>0
    scan_option['conditional_operator'] = 'AND' if filter.length>1
    scan_option['attributes_to_get'] = columns if columns.length>0
    # table_content = @dynamodb_client.scan(scan_option)
    # table_content.items
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

  def self.dynamodb_table_distinct_column(table, criteria={}, distinct_column)
    all_result = dynamodb_table_items(table, criteria)
    all_result.map {|hash| hash[distinct_column]}.uniq
  end

  def self.dynamodb_table_primary_key(table)
    resp = dynamodb_client.describe_table({table_name: table})
    key = 'no_sorting_key'
    resp.table.key_schema.each {|this_key|
      if this_key.key_type == 'HASH'
        key = this_key.attribute_name
      end
    }
    key
  end

  def self.dynamodb_table_sorting_key(table)
    resp = dynamodb_client.describe_table({table_name: table})
    key = 'no_sorting_key'
    resp.table.key_schema.each {|this_key|
      if this_key.key_type == 'RANGE'
        key = this_key.attribute_name
      end
    }
    key
  end

  def self.dynamodb_put_item(item_hash, table)
    dynamodb_client.put_item({:item => item_hash, :table_name => table_name})
  end
end