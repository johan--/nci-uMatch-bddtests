# !/usr/bin/ruby
# require 'rspec'
# require 'json'
require_relative '../../../support/helper_methods.rb'
require_relative '../../../support/ion_helper_methods.rb'

When(/^the ion reporter service \/version is called, the version "([^"]*)" is returned$/) do |version|
  url = "#{ENV['ion_system_endpoint']}/ion_reporters/version"
  response = ION_helper_methods.get_any_result_from_url(url)
  raise "response is expected to be a Hash, but it is a #{response.class.to_s}" unless response.is_a?(Hash)
  raise "response is expected to contain field version, but it is #{response.to_json.to_s}" unless response.keys.include?('version')
  response['version'].should == version
end