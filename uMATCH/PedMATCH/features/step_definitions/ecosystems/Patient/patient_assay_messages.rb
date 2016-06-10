#!/usr/bin/ruby
require 'rspec'
require 'json'
require_relative '../../../support/helper_methods.rb'
require_relative '../../../support/patient_helper_methods.rb'


Given(/^that a new Assay Order is received from MDA:$/) do |msg|
  @request = Patient_helper_methods.create_assay_order_message(params={"msg"=>msg,"ordered_date"=>"current"})
end

When(/^posted to MATCH assayMessage, returns a message "([^"]*)"$/) do |retMsg|
  @response = Helper_Methods.post_request(ENV['protocol'] + '://' + ENV['DOCKER_HOSTNAME'] + ':' + ENV['patient_api_PORT'] + '/assayMessage',@request)
  expect(@response['message']).to eql(retMsg)
end

Given(/^that assay result is received from MDA:$/) do |msg|
  @request = Patient_helper_methods.create_assay_result_message(params={"msg"=>msg,"reported_date"=>"current"})
end

When(/^assay result is received from MDA with an earlier date than order date$/) do |msg|
  @request = Patient_helper_methods.create_assay_result_message(params={"msg"=>msg,"reported_date"=>"older"})
end

Given(/^that a new Assay Order is received from MDA with older date:$/) do |msg|
  @request = Patient_helper_methods.create_assay_order_message(params={"msg"=>msg,"ordered_date"=>"older"})
end