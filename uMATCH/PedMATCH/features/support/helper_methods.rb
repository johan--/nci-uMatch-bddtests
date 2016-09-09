#!/usr/bin/ruby
require 'json'
require 'rest-client'
# require_relative 'env'
require 'active_support'
require 'active_support/core_ext'

class Helper_Methods
  @requestGap = 1.0
  @requestTimeout = 10.0
  def Helper_Methods.get_request(service,params={})
    puts "URL: #{service}\n"
    @params = params.values.join('/')
    @service = "#{service}/#{@params}"
    puts "Calling: #{@service}"
    @res = RestClient::Request.execute(:url => @service, :method => :get, :verify_ssl => false)
    return @res
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

  def Helper_Methods.get_single_request(service, params={})
    @params = ''
    params.each do |key, value|
      @params =  @params + "#{value}/"
    end
    url = "#{service}/#{@params}"
    len = (url.length)-2
    @service = url[0..len]
    print "#{url[0..len]}\n"

    result = {}
    runTime = 0.0
    loop do
      sleep(@requestGap)
      runTime += @requestGap
      begin
        @res = RestClient::Request.execute(:url => @service, :method => :get, :verify_ssl => false)
      rescue StandardError => e
        print "Error: #{e.message} occurred\n"
        print "Response:#{e.response}\n"
        @res = '{}'
        result = JSON.parse(@res)
        return result
      end

      if @res=='null'
        @res = '{}'
      end
      result = JSON.parse(@res)
      if (result!=nil && result.length>0) || runTime >@requestTimeout
        break
      end
    end
    return result
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


  def Helper_Methods.post_request(service,payload)
    print "URL: #{service}\n"
    # # print "JSON:\n#{JSON.pretty_generate(JSON.parse(payload))}\n\n"
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
      @post_response['message'] = e.response
      p e.response
      return @post_response
    end

    http_code = "#{response.code}"
    status = http_code =='200' ? 'Success' : 'Failure'
    @post_response['status'] = status
    @post_response['http_code'] = http_code
    @post_response['message'] = response.body
    if status.eql?('Failure')
      p result['message']
    end
    return result
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
    # print "URL: #{service}\n"
    # # print "JSON:\n#{JSON.pretty_generate(JSON.parse(payload))}\n\n"
    # print "JSON:\n#{payload}\n\n"
    begin
      @res = RestClient::Request.execute(:url => service, :method => :put, :verify_ssl => false, :payload => payload, :headers=>{:content_type => 'json', :accept => 'json'})
    rescue StandardError => e
      print "Error: #{e.message} occurred\n"
      # print "Response:#{e.response}\n"
      if (e.response).empty?
        result = {"Error":e.message}
      else
        result = JSON.parse(e.response)
        result['status'] = 'Failure'
      end
      p result['message']
      return result
    end
    result = JSON.parse(@res)
    httpCode = "#{@res.code}"
    status = httpCode=='200'?'Success':'Failure'
    result['status'] = status
    if status.eql?('Failure')
      p result['message']
    end
    return result
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
    return (time).iso8601
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
    return t.iso8601
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

end
