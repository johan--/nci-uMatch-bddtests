#!/usr/bin/ruby

# require_relative 'env'
require 'json'
require 'rest-client'
require 'active_support'
require 'active_support/core_ext'
require 'aws-sdk'
require_relative 'auth0_token'
require 'roo'
require 'concurrent'

module Helper_Methods
  extend self

  # constants
  REQUEST_GAP ||= 5
  REQUEST_TIMEOUT ||= 60

  # hash that holds statistics
  STATS ||= Concurrent::Hash.new
  %i(idle_time auth0_calls_count http_count http_time).each{|k| STATS[k] = 0} # keys with initail value == 0
  STATS[:auth0_calls_per_user]        = Concurrent::Hash.new(0)
  STATS[:slow_http_requests]          = Concurrent::Hash.new
  STATS[:slow_http_request_treshold]  = 0.5 # slower than 0.5 seconds

  def get_request(url, params={}, auth0_on = true, auth0_role = 'ADMIN')
    get_response = {}
    no_log = params['no_log']
    params.delete('no_log')
    @params = params.values.join('/')
    if @params.empty?
      @url = url
    else
      @url = [url, @params].join('/')
    end
    puts "Get Url: #{@url}"
    headers = {}
    Auth0Token.add_auth0_if_needed(headers, auth0_role) if auth0_on
    begin
      start_time = Time.now
      response = RestClient::Request.execute(:url => @url,
                                             :method => :get,
                                             :verify_ssl => false,
                                             :headers => headers,
                                             :timeout => REQUEST_TIMEOUT)
      duration = Time.now - start_time
      log_http_duration(duration, @url)
      puts "[uMATCH BDD]#{Time.now.to_s} Complete GET URL: \t\"#{@url}\", duration: #{duration} seconds"

      get_response['http_code'] = response.code
      get_response['status'] = response.code == 200 ? 'Success' : 'Failure'
      get_response['message'] = response.body

      puts get_response if get_response['status'].eql? 'Failure'

      return get_response
    rescue StandardError => e
      get_response['status'] = 'Failure'
      get_response['http_code'] = e.message.nil? ? '500' : e.message[0, 3]
      if e.respond_to?('response')
        get_response['message'] = e.response
      else
        get_response['message'] = e.message
      end

      unless no_log
        puts get_response['message']
      end

      return get_response
    end
  end

  def get_list_request(service, params={}, auth0_on = true, auth0_role = 'ADMIN')
    @params = params.values.join('/')
    @service = "#{service}/#{@params}"

    puts "Calling: #{@service}"
    headers = {}
    Auth0Token.add_auth0_if_needed(headers, auth0_role) if auth0_on

    result = []
    runTime = 0.0
    start_time = Time.now
    loop do
      sleep_for(REQUEST_GAP)
      runTime += REQUEST_GAP
      begin
        start_time = Time.now
        @res = RestClient::Request.execute(:url => @service,
                                           :method => :get,
                                           :verify_ssl => false,
                                           :headers => headers,
                                           :timeout => REQUEST_TIMEOUT)
        log_http_duration(Time.now - start_time, @service)
      rescue StandardError => e
        puts "Error: #{e.message} occurred"
        @res = '[]'
        result = JSON.parse(@res)
        end_time = Time.now
        puts "[uMATCH BDD]#{Time.now.to_s} Complete GET URL: \t#{service}, duration: #{end_time-start_time} seconds"
        return result
      end
      if @res=='null'
        @res = '[]'
      end
      result = JSON.parse(@res)
      if (result!=nil && result.length>0) || runTime > 10
        break
      end
    end
    end_time = Time.now
    puts "[uMATCH BDD]#{Time.now.to_s} Complete GET URL: \t#{service}, duration: #{end_time-start_time} seconds"
    return result
  end

  def simple_get_download(service, output_file, auth0_on = true, auth0_role = 'ADMIN')
    #do not use RestClient, because cucumber use UTF-8, which will cause encoding problem when writing binary file
    @get_response={}
    headers = {}
    if auth0_on
      Auth0Token.add_auth0_if_needed(headers, auth0_role)
      header = "--header 'Authorization:#{headers['Authorization']}'"
    else
      header = ''
    end
    cmd = "curl -o #{output_file} #{header} #{service} &> /dev/null"
    start_time = Time.now
    `#{cmd}`
    log_http_duration(Time.now - start_time, service)
  end

  def simple_get_request(service, auth0_on = true, auth0_role = 'ADMIN')
    @get_response={}
    headers = {}
    Auth0Token.add_auth0_if_needed(headers, auth0_role) if auth0_on
    begin
      start_time = Time.now
      response = RestClient::Request.execute(:url => service,
                                             :method => :get,
                                             :verify_ssl => false,
                                             :headers => headers,
                                             :timeout => REQUEST_TIMEOUT)
      duration = Time.now - start_time
      log_http_duration(duration, service)
      puts "[uMATCH BDD]#{Time.now.to_s} Complete GET URL: \t#{service}, duration: #{duration} seconds"
    rescue StandardError => e
      @get_response['status'] = 'Failure'
      if e.message.nil?
        http_code = '500'
      else
        http_code = e.message[0, 3]
      end
      @get_response['http_code'] = http_code
      if e.respond_to?('response')
        @get_response['message'] = e.response
      else
        @get_response['message'] = e.message
      end
      @get_response['message_json'] = {}
      return @get_response
    end

    http_code = "#{response.code}"
    status = http_code =='200' ? 'Success' : 'Failure'
    @get_response['status'] = status
    @get_response['http_code'] = http_code
    @get_response['message'] = response.body
    if response.body.nil?
      @get_response['message_json'] = {}
    else
      begin
        @get_response['message_json'] = JSON.parse(response.body)
      rescue
        @get_response['message_json'] = {'error' => "Bad json format: #{response.body}"}
      end
    end
    if status.eql?('Failure')
      puts @get_response['message']
    end
    return @get_response
  end

  def get_single_request(service,
      print_tick=false,
      key='',
      value='',
      request_gap_seconds=5,
      time_out_seconds=15.0,
      auth0_on = true,
      auth0_role = 'ADMIN')
    print "#{service}\n"

    last_response = nil
    runTime = 0.0
    headers = {}
    Auth0Token.add_auth0_if_needed(headers, auth0_role) if auth0_on
    loop do
      begin
        start_time = Time.now
        response_string = RestClient::Request.execute(:url => service,
                                                      :method => :get,
                                                      :verify_ssl => false,
                                                      :headers => headers,
                                                      :timeout => REQUEST_TIMEOUT)

        log_http_duration(Time.now - start_time, service)
      rescue StandardError => e
        print "Error: #{e.message} occurred\n"
        return {}
      end

      if response_string=='null'
        response_string = '{}'
      end
      new_response = response_string=='null' ? {} : JSON.parse(response_string)
      if print_tick
        key_value = key=='' ? '' : "#{key}=#{new_response[key]}"
        p "Http GET on UTC time: #{Time.current.utc.iso8601}   #{key_value}"
      end

      if last_response.nil?
        last_response = new_response
      end

      if runTime>time_out_seconds
        p "time out! after #{time_out_seconds} seconds"
        return new_response
      end

      unless new_response == last_response
        if key==''
          p "Total Http query length is #{runTime} seconds"
          return new_response
        elsif new_response.keys.include?(key) && new_response[key] == value
          p "Total Http query length is #{runTime} seconds"
          return new_response
        end
      end
      sleep_for(request_gap_seconds)
      runTime += request_gap_seconds
    end
    return {}
  end

  def get_request_url_param(service, params={}, auth0_on = true, auth0_role = 'ADMIN')
    print "URL: #{service}\n"
    @params = ''
    params.each do |key, value|
      @params = @params + "#{key}=#{value}&"
    end
    url = "#{service}?#{@params}"
    len = (url.length)-2
    @service = url[0..len]
    print "#{url[0..len]}\n"
    headers = {}
    Auth0Token.add_auth0_if_needed(headers, auth0_role) if auth0_on
    start_time = Time.now
    @res = RestClient::Request.execute(:url => @service,
                                       :method => :get,
                                       :verify_ssl => false,
                                       :headers => headers,
                                       :timeout => REQUEST_TIMEOUT)
    duration = Time.now - start_time
    log_http_duration(duration, @service)
    puts "[uMATCH BDD]#{Time.now.to_s} Complete GET URL: \t#{service}, duration: #{duration} seconds"
    return @res
  end

  def wait_until_updated(url, timeout)
    total_time = 0.0
    old_hash = nil
    wait_time = 5
    internal_timeout = 30.0
    loop do
      new_hash = simple_get_request(url)['message_json']
      # puts new_hash.to_json.to_s
      if old_hash.nil?
        old_hash = new_hash
      end

      unless old_hash == new_hash
        return new_hash
      end
      total_time += wait_time
      if total_time>internal_timeout
        return new_hash
      end
      sleep_for(wait_time)
    end
    {}
  end

  def get_special_result_from_url(url, timeout, query_hash, path=[])
    internal_timeout = 30.0
    run_time = 0.0
    wait_time = 5
    loop do
      response = simple_get_request(url)['message_json']
      target_object = response
      if response.is_a?(Array)
        if response.length == 1
          target_object = response[0]
        elsif response.length == 0
          target_object = {}
        else
          next
        end
      end

      if is_this_hash(target_object, query_hash, path)
        puts "response matched query hash: #{query_hash.to_json}"
        return target_object
      end

      if run_time > internal_timeout
        puts "response did not match query hash: #{query_hash.to_json} till timeout!"
        return target_object
      end

      sleep_for(wait_time)
      run_time += wait_time
    end
  end

  def is_this_hash(target_object, query, path)
    new_target = target_object
    path.each do |path_key|
      new_target = new_target[path_key]
    end
    is_this = true
    query.each do |key, value|
      is_this = is_this && new_target[key.to_s]==value.to_s
    end
    is_this
  end

  def post_request(service, payload, auth0_on = true, auth0_role = 'ADMIN')
    # print "JSON:\n#{payload}\n\n"
    @post_response = {}
    headers = {:content_type => 'json', :accept => 'json'}
    Auth0Token.add_auth0_if_needed(headers, auth0_role) if auth0_on
    begin
      start_time = Time.now
      puts "[uMATCH BDD]#{start_time} Start POST URL: \t#{service}"
      response = RestClient::Request.execute(:url => service,
                                             :method => :post,
                                             :verify_ssl => false,
                                             :payload => payload,
                                             :headers => headers,
                                             :timeout => REQUEST_TIMEOUT)
     log_http_duration(Time.now - start_time, service)
    rescue StandardError => e
      @post_response['status'] = 'Failure'
      if e.message.nil?
        http_code = '500'
      else
        http_code = e.message[0, 3]
      end
      @post_response['http_code'] = http_code
      if e.respond_to?('response')
        @post_response['message'] = e.response
      else
        @post_response['message'] = e.message
      end
      # puts @post_response['message']
      return @post_response
    end

    http_code = "#{response.code}"
    status = http_code.match(/20(\d)/) ? 'Success' : 'Failure'
    @post_response['status'] = status
    @post_response['http_code'] = http_code
    @post_response['message'] = response.body
    if status.eql?('Failure')
      p @post_response['message']
    end
    return @post_response
  end

  def patch_request(service, payload, auth0_role = 'PWD_ADMIN')
    patch_response = {}
    headers = {:content_type => 'json', :accept => 'json'}
    Auth0Token.add_auth0_if_needed(headers, auth0_role)
    begin
      start_time = Time.now
      puts "[uMATCH BDD]#{start_time} Start PATCH URL: \t#{service}"
      response = RestClient::Request.execute(:url => service,
                                             :method => :patch,
                                             :verify_ssl => false,
                                             :payload => payload,
                                             :headers => headers,
                                             :timeout => REQUEST_TIMEOUT)
      log_http_duration(Time.now - start_time, service)
    rescue StandardError => e
      patch_response['status'] = 'Failure'
      if e.message.nil?
        http_code = '500'
      else
        http_code = e.message[0, 3]
      end
      patch_response['http_code'] = http_code
      if e.respond_to?('response')
        patch_response['message'] = e.response
      else
        patch_response['message'] = e.message
      end
      # puts patch_response['message']
      return patch_response
    end

    http_code = "#{response.code}"
    status = http_code.match(/20(\d)/) ? 'Success' : 'Failure'
    patch_response['status'] = status
    patch_response['http_code'] = http_code
    patch_response['message'] = response.body
    if status.eql?('Failure')
      p patch_response['message']
    end
    return patch_response

  end

  def valid_json?(json)
    begin
      JSON.parse(json)
      return true
    rescue JSON::ParserError => e
      return false
    end
  end

  def put_request(service, payload, auth0_on = true, auth0_role = 'ADMIN')
    # # print "JSON:\n#{JSON.pretty_generate(JSON.parse(payload))}\n\n"
    # print "JSON:\n#{payload}\n\n"
    @put_response = {}
    puts "URL: #{service}"
    puts "Payload: #{payload}"
    headers = {:content_type => 'json', :accept => 'json'}

    Auth0Token.add_auth0_if_needed(headers, auth0_role) if auth0_on
    # puts "Headers: #{headers}"
    begin
      start_time = Time.now
      puts "[uMATCH BDD]#{start_time} Start PUT URL: \t#{service}"
      response = RestClient::Request.execute(:url => service,
                                             :method => :put,
                                             :verify_ssl => false,
                                             :payload => payload,
                                             :headers => headers,
                                             :timeout => REQUEST_TIMEOUT)
      log_http_duration(Time.now - start_time, service)
    rescue StandardError => e
      @put_response['status'] = 'Failure'
      if e.message.nil?
        http_code = '500'
      else
        http_code = e.message[0, 3]
      end
      @put_response['http_code'] = http_code
      if e.respond_to?('response')
        @put_response['message'] = e.response
      else
        @put_response['message'] = e.message
      end
      p @put_response['message']
      return @put_response
    end

    http_code = "#{response.code}"
    status = http_code =='200' ? 'Success' : 'Failure'
    @put_response['status'] = status
    @put_response['http_code'] = http_code
    @put_response['message'] = response.body
    if status.eql?('Failure')
      p @put_response['message']
    end
    return @put_response
  end

  def delete_request(service, auth0_on = true, auth0_role = 'ADMIN')
    @delete_response = {}
    headers = {:accept => 'json'}
    Auth0Token.add_auth0_if_needed(headers, auth0_role) if auth0_on
    begin
      start_time = Time.now
      puts "[uMATCH BDD]#{start_time} Start DELETE URL: \n#{service}"
      response = RestClient::Request.execute(:url => service,
                                             :method => :delete,
                                             :verify_ssl => false,
                                             :headers => headers,
                                             :timeout => REQUEST_TIMEOUT)
      log_http_duration(Time.now - start_time, service)
    rescue StandardError => e
      @delete_response['status'] = 'Failure'
      if e.message.nil?
        http_code = '500'
      else
        http_code = e.message[0, 3]
      end
      @delete_response['http_code'] = http_code
      if e.respond_to?('response')
        @delete_response['message'] = e.response
      else
        @delete_response['message'] = e.message
      end
      p @delete_response['message']
      return @delete_response
    end

    http_code = "#{response.code}"
    status = http_code =='200' ? 'Success' : 'Failure'
    @delete_response['status'] = status
    @delete_response['http_code'] = http_code
    @delete_response['message'] = response.body
    if status.eql?('Failure')
      p @delete_response['message']
    end
    return @delete_response
  end

  def aFewDaysOlder()
    time = DateTime.current.utc
    t = (time - 3.days)
    return t.iso8601
  end

  def olderThanSixMonthsDate()
    time = DateTime.current.utc
    t = (time - 6.months)
    return t.iso8601
  end

  def olderThanFiveMonthsDate()
    time = DateTime.current.utc
    t = (time - 5.months)
    return t.iso8601
  end

  def dateDDMMYYYYHHMMSS ()
    time = DateTime.current.utc
    return (time).iso8601
  end

  def dateYYYYMMDD ()
    return Time.now.strftime("%Y-%m-%d")
  end

  def backDate ()
    time = DateTime.current.utc
    time = (time - 6.hours).iso8601
    return time
  end

  def earlierThanBackDate()
    time = DateTime.current.utc
    return (time - 10.hours).iso8601
  end

  def futureDate ()
    time = DateTime.current.utc
    return (time + 6.hours).iso8601
  end

  def oneSecondOlder ()
    time = DateTime.current.utc
    t = time - 1.seconds
    return (time - 4.hours).iso8601
  end

  def getDateAsRequired(dateStr)
    case dateStr
      when 'current'
        reqDate = dateDDMMYYYYHHMMSS
      when 'today'
        reqDate = dateYYYYMMDD
      when 'older'
        reqDate = backDate
      when 'future'
        reqDate = futureDate
      when 'older than 6 months'
        reqDate = olderThanSixMonthsDate
      when 'a few days older'
        reqDate = aFewDaysOlder
      when 'one second ago'
        reqDate = oneSecondOlder
      else
        reqDate = dateStr
    end
    return reqDate
  end

  def is_date?(string)
    true if Date.parse(string) rescue false
  end

  def is_number?(obj)
    true if Float(obj) rescue false
  end

  def is_boolean(obj)
    obj.to_s.downcase=='true'||obj.to_s.downcase=='false'
  end

  def s3_list_files(bucket,
      path,
      endpoint='https://s3.amazonaws.com',
      region='us-east-1'
  )
    s3 = Aws::S3::Resource.new(
        endpoint: endpoint,
        region: region,
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'])
    files = s3.bucket(bucket).objects(prefix: path).collect(&:key)
    files
  end

  def s3_file_size(bucket,
      path,
      endpoint='https://s3.amazonaws.com',
      region='us-east-1'
  )
    s3 = Aws::S3::Resource.new(
        endpoint: endpoint,
        region: region,
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    )
    files = s3.bucket(bucket).objects(prefix: path)
    file = nil
    files.each {|this_file|
      file = this_file
    }
    file.content_length
  end

  def s3_file_exists(bucket, file_path)
    files = s3_list_files(bucket, file_path)
    if files.length>0
      return s3_list_files(bucket, file_path).include?(file_path)
    else
      return false
    end
  end

  def s3_delete_path(bucket,
      path,
      endpoint='https://s3.amazonaws.com',
      region='us-east-1'
  )
    s3 = Aws::S3::Resource.new(
        endpoint: endpoint,
        region: region,
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    )
    files = s3.bucket(bucket).objects(prefix: path)
    files.each {|this_file|
      this_file.delete if this_file.key.eql?(path)
      if ENV['print_log'] == 'YES'
        puts "Deleted #{this_file.identifiers[:key]} from bucket <#{this_file.identifiers[:bucket_name]}>"
      end
    }

  end

  def upload_vr_to_s3(bucket, ion_folder, moi, ani, base_name = 'test1', template_type = 'default')
    template_folder = "#{path_for_named_parent_folder('nci-uMatch-bddtests')}/DataSetup/variant_file_templates"
    output_folder = "#{template_folder}/upload"
    target_ani_path = "#{output_folder}/#{moi}/#{ani}"
    template_ani_path = "#{template_folder}/#{template_type}"

    cmd = "mkdir -p #{target_ani_path}"
    `#{cmd}`
    cmd = "cp #{template_ani_path}/* #{target_ani_path}"
    `#{cmd}`
    unless base_name=='test1'
      cmd = "mv #{target_ani_path}/test1.vcf #{target_ani_path}/#{base_name}.vcf"
      `#{cmd}`
      cmd = "mv #{target_ani_path}/test1.tsv #{target_ani_path}/#{base_name}.tsv"
      `#{cmd}`
      cmd = "mv #{target_ani_path}/test1.zip #{target_ani_path}/#{base_name}.zip"
      `#{cmd}`
    end
    s3_delete_path(bucket, "#{ion_folder}/#{moi}/#{ani}/#{base_name}.json")
    cmd = "aws s3 cp #{output_folder} s3://#{bucket}/#{ion_folder}/ --recursive --region us-east-1"
    `#{cmd}`
    cmd = "rm -R #{output_folder}"
    `#{cmd}`
    puts "#{target_ani_path} has been uploaded to S3 bucket #{bucket}" if ENV['print_log'] == 'YES'
  end


  def s3_download_file(bucket, s3_path, download_target)
    s3_client = Aws::S3::Resource.new(
        endpoint: 'https://s3.amazonaws.com',
        region: 'us-east-1',
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'])
    s3_client.bucket(bucket).object(s3_path).download_file(download_target)
    puts "#{download_target} has been downloaded from S3 #{bucket}/#{s3_path}" if ENV['print_log'] == 'YES'
  end

  def s3_read_text_file(bucket, s3_path)
    tmp_file = "#{File.dirname(__FILE__)}/tmp_#{Time.now.to_i.to_s}.txt"
    s3_download_file(bucket, s3_path, tmp_file)
    sleep_for 10.0 unless File.exist?(tmp_file)
    result = File.read(tmp_file)
    FileUtils.remove(tmp_file)
    result
  end

  def s3_upload_file(file_path, bucket, s3_path)
    recursive = ''
    if File.directory?(file_path)
      recursive = '--recursive'
    end
    cmd = "aws s3 cp #{file_path}  s3://#{bucket}/#{s3_path} #{recursive} --region us-east-1"
    `#{cmd}`
    puts "#{file_path} has been uploaded to S3 #{bucket}/#{s3_path}" if ENV['print_log'] == 'YES'
  end

  def s3_cp_single_file(source_path, target_path)
    cmd = "aws s3 cp #{source_path} #{target_path} --region us-east-1"
    `#{cmd}`
    puts "#{source_path} has been uploaded to #{target_path}" if ENV['print_log'] == 'YES'
  end

  def s3_sync_folder(source_folder, target_folder)
    cmd = "aws s3 sync #{source_folder} #{target_folder} --region us-east-1"
    `#{cmd}`
    puts "#{target_folder} has been synced from #{source_folder}" if ENV['print_log'] == 'YES'
  end

  def dynamodb_create_client()
    if @dynamodb_client.nil?
      @dynamodb_client = Aws::DynamoDB::Client.new(
          endpoint: ENV['dynamodb_endpoint'],
          region: ENV['dynamodb_region'],
          access_key_id: ENV['AWS_ACCESS_KEY_ID'],
          secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'])
    end
  end

  def dynamodb_table_items(table, criteria={}, columns=[])
    dynamodb_create_client
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

  def dynamodb_scan_all(opt, start_key={})
    return {} if start_key.nil?
    if start_key.size > 0
      opt['exclusive_start_key'] = start_key
    end
    scan_result = @dynamodb_client.scan(opt)
    items = scan_result.items
    items.push(*dynamodb_scan_all(opt, scan_result.last_evaluated_key))
  end

  def dynamodb_table_distinct_column(table, criteria={}, distinct_column)
    dynamodb_create_client
    all_result = dynamodb_table_items(table, criteria)
    all_result.map {|hash| hash[distinct_column]}.uniq
  end

  def dynamodb_table_primary_key(table)
    dynamodb_create_client
    resp = @dynamodb_client.describe_table({table_name: table})
    key = 'no_sorting_key'
    resp.table.key_schema.each {|this_key|
      if this_key.key_type == 'HASH'
        key = this_key.attribute_name
      end
    }
    key
  end

  def dynamodb_table_sorting_key(table)
    dynamodb_create_client
    resp = @dynamodb_client.describe_table({table_name: table})
    key = 'no_sorting_key'
    resp.table.key_schema.each {|this_key|
      if this_key.key_type == 'RANGE'
        key = this_key.attribute_name
      end
    }
    key
  end

  def path_for_named_parent_folder(parent_name)
    parent_path = __FILE__
    until parent_path.end_with?(parent_name) do
      parent_path = File.expand_path('..', parent_path)
    end
    parent_path
  end

  def xlsx_row_hash(file_path, sheet_id, key_column, value_column, row_range=(1..1000))
    xlsx = Roo::Spreadsheet.open(file_path)
    sheet = xlsx.sheet(sheet_id)
    result = {}
    row_range.each {|this_row|
      result[sheet.cell(key_column, this_row)] = sheet.cell(value_column, this_row)
    }
    result
  end

  def xlsx_table_hashes(file_path, sheet_id, title_row)
    xlsx = Roo::Spreadsheet.open(file_path)
    sheet = xlsx.sheet(sheet_id)
    keys = sheet.row(title_row)
    result = []
    i = title_row
    while true
      i += 1
      this_row = sheet.row(i)
      break unless this_row[0].present?
      obj = {}
      keys.each_with_index {|key, id| obj[key] = this_row[id]}
      result << obj
    end
    result
  end

  def xlsx_first_occurrence_row(file_path, sheet_id, key_word)
    xlsx = Roo::Spreadsheet.open(file_path)
    sheet = xlsx.sheet(sheet_id)
    result = 0
    found = false
    while result<sheet.last_row
      result += 1
      this_row = sheet.row(result)
      if this_row.include?(key_word)
        found = true
        break
      end
    end
    result = -1 unless found
    result
  end

  def sleep_for(duration)
    STATS[:idle_time] = STATS[:idle_time] + duration
    puts "Sleeping for #{duration}s. Total idle time is #{STATS[:idle_time].round(2)}s."
    sleep duration
  end

  def log_http_duration(duration, url = false)
    STATS[:http_time] = STATS[:http_time] + duration
    STATS[:http_count] = STATS[:http_count] + 1
    STATS[:slow_http_requests][duration] = url if url && duration > STATS[:slow_http_request_treshold]
    puts "HTTP request ##{STATS[:http_count]}, time spent #{duration.round(2)}s. Total HTTP time is #{STATS[:http_time].round(2)}s."
  end
end
