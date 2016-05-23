#!/usr/bin/ruby
require 'json'
require 'rest-client'
require_relative 'env'
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

  def Helper_Methods.post_request(service,payload)
    print "URL: #{service}\n"
    begin
      @res = RestClient::Request.execute(:url => service, :method => :post, :verify_ssl => false, :payload => payload, :headers=>{:content_type => 'json', :accept => 'json'})
    rescue StandardError => e
      print "Error: #{e.message} occurred"
      return JSON.parse(e.response)
    end
    return JSON.parse(@res)
  end

  def Helper_Methods.aFewDaysOlder()
    # time = Time.new
    # t = (time.getutc - 144000).strftime("%Y-%m-%dT%H:%M:%S.%LZ")
    time = DateTime.now
    t = (time - 3.days).strftime("%Y-%m-%dT%H:%M:%S.%LZ")
    return t
  end

  def Helper_Methods.olderThanSixMonthsDate()
    # time = Time.new
    # t = (time.getutc - 16069000).strftime("%Y-%m-%dT%H:%M:%S.%LZ")
    time = DateTime.now
    t = (time - 6.months).strftime("%Y-%m-%dT%H:%M:%S.%LZ")
    print "Date:#{t}\n"
    return t
  end

  def Helper_Methods.olderThanFiveMonthsDate()
    # time = Time.new
    # t = (time.getutc - 16069000).strftime("%Y-%m-%dT%H:%M:%S.%LZ")
    time = DateTime.now
    t = (time - 5.months).strftime("%Y-%m-%dT%H:%M:%S.%LZ")
    print "Date:#{t}\n"
    return t
  end

  def Helper_Methods.dateDDMMYYYYHHMMSS ()
    time = Time.new
    return time.getutc.strftime("%Y-%m-%dT%H:%M:%S.%LZ") #2015-08-19T05:35:00.216Z
    # time = DateTime.now
    # return (time).strftime("%Y-%m-%dT%H:%M:%S.%LZ")
  end

  def Helper_Methods.backDate ()
    # time = Time.new
    # t = (time.getutc - 10800).strftime("%Y-%m-%dT%H:%M:%S.%LZ")
    time = DateTime.now
    return (time - 6.hours).strftime("%Y-%m-%dT%H:%M:%S.%LZ")
  end

  def Helper_Methods.earlierThanBackDate()
    # time = Time.new
    # return (time.getutc - 18000).strftime("%Y-%m-%dT%H:%M:%S.%LZ") # >3 hours earlier
    time = DateTime.now
    return (time - 10.hours).strftime("%Y-%m-%dT%H:%M:%S.%LZ")
  end

  def Helper_Methods.futureDate ()
    # time = Time.new
    # return (time.getutc + 10800).strftime("%Y-%m-%dT%H:%M:%S.%LZ") #3 hours ahead
    time = DateTime.now
    return (time + 6.hours).strftime("%Y-%m-%dT%H:%M:%S.%LZ")
  end

end