#!/usr/bin/ruby
require 'json'
require 'rest-client'
# require_relative 'env'
require 'active_support'
require 'active_support/core_ext'

class Helper_Methods
  def Helper_Methods.get_request(service,params={})
    print "URL: #{service}\n"
    @params = ''
    params.each do |key, value|
      @params =  @params + "#{value}/"
    end
    url = "#{service}/#{@params}"
    len = (url.length)-2
    @service = url[0..len]
    print "#{url[0..len]}\n"
    @res = RestClient::Request.execute(:url => @service, :method => :get, :verify_ssl => false)
    return @res
  end

  def Helper_Methods.get_list_request(service, params={})
    @params = ''
    params.each do |key, value|
      @params =  @params + "#{value}/"
    end
    url = "#{service}/#{@params}"
    len = (url.length)-2
    @service = url[0..len]
    print "#{url[0..len]}\n"

    result = Array.new()
    runTime = 0.0
    loop do
      sleep(0.2)
      runTime += 0.2
      @res = RestClient::Request.execute(:url => @service, :method => :get, :verify_ssl => false)
      if @res=='null'
        @res = '[]'
      end
      result = JSON.parse(@res)
      if (result!=nil && result.length>0) || runTime >10.0
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

    result = Hash.new()
    runTime = 0.0
    loop do
      sleep(0.2)
      runTime += 0.2
      @res = RestClient::Request.execute(:url => @service, :method => :get, :verify_ssl => false)
      if @res=='null'
        @res = '{}'
      end
      result = JSON.parse(@res)
      if (result!=nil && result.length>0) || runTime >10.0
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
    # print "URL: #{service}\n"
    # # print "JSON:\n#{JSON.pretty_generate(JSON.parse(payload))}\n\n"
    # print "JSON:\n#{payload}\n\n"
    begin
      @res = RestClient::Request.execute(:url => service, :method => :post, :verify_ssl => false, :payload => payload, :headers=>{:content_type => 'json', :accept => 'json'})
    rescue StandardError => e
      print "Error: #{e.message} occurred\n"
      print "Response:#{e.response}\n"
      return JSON.parse(e.response)
    end
    return JSON.parse(@res)
  end

  def Helper_Methods.aFewDaysOlder()
    time = DateTime.now
    t = (time - 3.days)
    return t.iso8601
  end

  def Helper_Methods.olderThanSixMonthsDate()
    time = DateTime.now
    t = (time - 6.months)
    return t.iso8601
  end

  def Helper_Methods.olderThanFiveMonthsDate()
    time = DateTime.now
    t = (time - 5.months)
    return t.iso8601
  end

  def Helper_Methods.dateDDMMYYYYHHMMSS ()
    time = DateTime.now
    return (time).iso8601
  end

  def Helper_Methods.backDate ()
    time = DateTime.now
    time = (time - 6.hours).iso8601
    return time
  end

  def Helper_Methods.earlierThanBackDate()
    time = DateTime.now
    return (time - 10.hours).iso8601
  end

  def Helper_Methods.futureDate ()
    time = DateTime.now
    return (time + 6.hours).iso8601
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
      else
        reqDate = dateStr
    end
    return reqDate
  end

end
