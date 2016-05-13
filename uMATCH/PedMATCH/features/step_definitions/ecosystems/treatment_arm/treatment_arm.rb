#!/usr/bin/ruby
require 'rspec'
require 'json'
require_relative '../../../support/helper_methods.rb'

When(/^the service \/version is called$/) do
  @res=Helper_Methods.get_request(ENV['protocol']+'://'+ENV['DOCKER_HOSTNAME']+':'+ENV['treatment_arm_api_PORT']+'/version')
end

Then(/^the version "([^"]*)" is returned$/) do |arg1|
  expect(@res).to eql(arg1)
end

