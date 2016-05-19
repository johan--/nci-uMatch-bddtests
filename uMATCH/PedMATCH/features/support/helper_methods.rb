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

end
