#!/usr/bin/ruby
require 'json'
require 'rest-client'
require_relative 'env'
class Helper_Methods
  def Helper_Methods.get_request(service)
    print "URL: #{service}\n"
    @res = RestClient::Request.execute(:url => service, :method => :get, :verify_ssl => false)
    return @res
  end

  def Helper_Methods.post_request(service,payload)

  end
end
