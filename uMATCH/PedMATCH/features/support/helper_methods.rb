#!/usr/bin/ruby
require 'json'
require 'rest-client'
# require_relative 'env'
require 'active_support'
require 'active_support/core_ext'
require 'aws-sdk'

class Helper_Methods
  @requestGap = 1.0
  @requestTimeout = 10.0

  def Helper_Methods.get_request(url , params={})
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

    begin
      response = RestClient::Request.execute(:url => @url, :method => :get, :verify_ssl => false)
      get_response['http_code'] = response.code
      get_response['status']    = response.code == 200 ? 'Success': 'Failure'
      get_response['message']   = response.body

      puts get_response if get_response['status'].eql? 'Failure'

      return get_response
    rescue StandardError => e
      get_response['status'] = 'Failure'
      get_response['http_code'] = e.message.nil? ? '500' : e.message[0,3]
      get_response['message'] = e.response

      unless no_log
        puts get_response['message']
      end

      return get_response
    end
  end

  def Helper_Methods.get_list_request(service, params={})
    @params = params.values.join('/')
    @service  = "#{service}/#{@params}"

    puts "Calling: #{@service}"

    result = []
    runTime = 0.0
    loop do
      sleep(@requestGap)
      runTime += @requestGap
      begin
        @res = RestClient::Request.execute(:url => @service, :method => :get, :verify_ssl => false)
      rescue StandardError => e
        puts "Error: #{e.message} occurred"
        puts "Response:#{e.response}"
        @res = '[]'
        result = JSON.parse(@res)
        return result
      end
      if @res=='null'
        @res = '[]'
      end
      result = JSON.parse(@res)
      if (result!=nil && result.length>0) || runTime >@requestTimeout
        break
      end
    end
    return result
  end

  def Helper_Methods.simple_get_request(service)
    @get_response={}
    begin
      response = RestClient::Request.execute(:url => service, :method => :get, :verify_ssl => false)
    rescue StandardError => e
      @get_response['status'] = 'Failure'
      if e.message.nil?
        http_code = '500'
      else
        http_code = e.message[0,3]
      end
      @get_response['http_code'] = http_code
      @get_response['message'] = e.response
      if e.response.nil?
        @get_response['message_json'] = {}
      else
        @get_response['message_json'] = JSON.parse(e.response)
      end
      # p e.response
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
      @get_response['message_json'] = JSON.parse(response.body)
    end
    if status.eql?('Failure')
      p @get_response['message']
    end
    return @get_response
  end

  def Helper_Methods.get_single_request(service,
                                        print_tick=false,
                                        key='',
                                        value='',
                                        request_gap_seconds=1.0,
                                        time_out_seconds=15.0)
    print "#{service}\n"

    last_response = nil
    runTime = 0.0
    loop do
      begin
        response_string = RestClient::Request.execute(:url => service, :method => :get, :verify_ssl => false)
      rescue StandardError => e
        print "Error: #{e.message} occurred\n"
        print "Response:#{e.response}\n"
        return {}
      end

      if response_string=='null'
        response_string = '{}'
      end
      new_response = response_string=='null'?{}:JSON.parse(response_string)
      if print_tick
          key_value = key==''?'':"#{key}=#{new_response[key]}"
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
      sleep(request_gap_seconds)
      runTime += request_gap_seconds
    end
    return {}
  end

  def Helper_Methods.get_request_url_param(service,params={})
    print "URL: #{service}\n"
    @params = ''
    params.each do |key, value|
      @params =  @params + "#{key}=#{value}&"
    end
    url = "#{service}?#{@params}"
    len = (url.length)-2
    @service = url[0..len]
    print "#{url[0..len]}\n"
    @res = RestClient::Request.execute(:url => @service, :method => :get, :verify_ssl => false)
    return @res
  end

  def Helper_Methods.wait_until_updated(url, timeout)
    total_time = 0.0
    old_hash = nil
    loop do
      new_hash = Helper_Methods.simple_get_request(url)['message_json']
      # puts new_hash.to_json.to_s
      if old_hash.nil?
        old_hash = new_hash
      end

      unless old_hash == new_hash
        return new_hash
      end
      total_time += 0.5
      if total_time>timeout
        return new_hash
      end
      sleep(0.5)
    end
    {}
  end

  def Helper_Methods.get_request_when_method_true(url, method, timeout=30.0)
    total_time = 0.0
    wait_time = 1.0
    loop do
      new_result = Helper_Methods.simple_get_request(url)['message_json']
      # puts new_result.to_json.to_s
      total_time += wait_time
      if method.call(new_result) || total_time>timeout
        return new_result
      end

      sleep(wait_time)
    end
    {}
  end

  def Helper_Methods.get_request_when_method_false(url, method, timeout=30.0)
    total_time = 0.0
    wait_time = 1.0
    loop do
      new_result = Helper_Methods.simple_get_request(url)['message_json']
      # puts new_result.to_json.to_s
      total_time += wait_time
      if !method.call(new_result) || total_time>timeout
        return new_result
      end

      sleep(wait_time)
    end
    {}
  end

  # post_request
  # returns: Hash
  #   {
  #       'status' => 'Success' | 'Failure',
  #       'http_code' => <http_code returned>
  #       'message'  => UNALTERED body of the response
  #   }
  def Helper_Methods.post_request(service,payload)
    puts "Post URL: #{service}"
    # print "JSON:\n#{payload}\n\n"
    @post_response = {}
    begin
    response = RestClient::Request.execute(:url => service, :method => :post, :verify_ssl => false, :payload => payload, :headers=>{:content_type => 'json', :accept => 'json'})
    rescue StandardError => e
      @post_response['status'] = 'Failure'
      if e.message.nil?
        http_code = '500'
      else
        http_code = e.message[0,3]
      end
      @post_response['http_code'] = http_code
      @post_response['message'] = e.response.body
      p @post_response['message']
      return @post_response
    end

    http_code = "#{response.code}"
    status = http_code =='200' ? 'Success' : 'Failure'
    @post_response['status'] = status
    @post_response['http_code'] = http_code
    @post_response['message'] = response.body
    if status.eql?('Failure')
      p @post_response['message']
    end
    return @post_response
  end

  def self.valid_json?(json)
    begin
      JSON.parse(json)
      return true
    rescue JSON::ParserError => e
      return false
    end
  end

  def Helper_Methods.put_request(service,payload)
    print "Put URL: #{service}\n"
    # # print "JSON:\n#{JSON.pretty_generate(JSON.parse(payload))}\n\n"
    # print "JSON:\n#{payload}\n\n"
    @put_response = {}
    begin
      response = RestClient::Request.execute(:url => service, :method => :put, :verify_ssl => false, :payload => payload, :headers=>{:content_type => 'json', :accept => 'json'})
    rescue StandardError => e
      @put_response['status'] = 'Failure'
      if e.message.nil?
        http_code = '500'
      else
        http_code = e.message[0,3]
      end
      @put_response['http_code'] = http_code
      @put_response['message'] = e.response
      p e.response
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

  def Helper_Methods.delete_request(service)
    print "Delete URL: #{service}\n"
    @delete_response = {}
    begin
      response = RestClient::Request.execute(:url => service, :method => :delete, :verify_ssl => false, :headers=>{:accept => 'json'})
    rescue StandardError => e
      @delete_response['status'] = 'Failure'
      if e.message.nil?
        http_code = '500'
      else
        http_code = e.message[0,3]
      end
      @delete_response['http_code'] = http_code
      @delete_response['message'] = e.response
      p e.response
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

  def Helper_Methods.aFewDaysOlder()
    time = DateTime.current.utc
    t = (time - 3.days)
    return t.iso8601
  end

  def Helper_Methods.olderThanSixMonthsDate()
    time = DateTime.current.utc
    t = (time - 6.months)
    return t.iso8601
  end

  def Helper_Methods.olderThanFiveMonthsDate()
    time = DateTime.current.utc
    t = (time - 5.months)
    return t.iso8601
  end

  def Helper_Methods.dateDDMMYYYYHHMMSS ()
    time = DateTime.current.utc
    return (time - 4.hours).iso8601
  end

  def Helper_Methods.backDate ()
    time = DateTime.current.utc
    time = (time - 6.hours).iso8601
    return time
  end

  def Helper_Methods.earlierThanBackDate()
    time = DateTime.current.utc
    return (time - 10.hours).iso8601
  end

  def Helper_Methods.futureDate ()
    time = DateTime.current.utc
    return (time + 6.hours).iso8601
  end

  def Helper_Methods.oneSecondOlder ()
    time = DateTime.current.utc
    t = time - 1.seconds
    return (time - 4.hours).iso8601
  end

  def Helper_Methods.getDateAsRequired(dateStr)
    case dateStr
      when 'current'
        reqDate = Helper_Methods.dateDDMMYYYYHHMMSS
      when 'older'
        reqDate = Helper_Methods.backDate
      when 'future'
        reqDate = Helper_Methods.futureDate
      when 'older than 6 months'
        reqDate = Helper_Methods.olderThanSixMonthsDate
      when 'a few days older'
        reqDate = Helper_Methods.aFewDaysOlder
      when 'one second ago'
        reqDate = Helper_Methods.oneSecondOlder
      else
        reqDate = dateStr
    end
    return reqDate
  end

  def self.is_local_tier
    Environment.getTier == 'local'
  end

  def self.s3_list_files(bucket,
      path,
      endpoint='https://s3-accelerate.amazonaws.com',
      region='us-east-1'
  )
    default_option = {
        endpoint: endpoint,
        region:   region,
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    }

    Aws.config.update(default_option)
    s3 = Aws::S3::Resource.new()
    files = s3.bucket(bucket).objects(prefix:path).collect(&:key)
    files
  end

  def self.s3_file_exists(bucket, file_path)
    return s3_list_files(bucket, file_path).include?(file_path)
  end

end
