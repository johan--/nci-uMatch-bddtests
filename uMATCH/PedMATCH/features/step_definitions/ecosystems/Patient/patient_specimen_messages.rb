#!/usr/bin/ruby
require 'rspec'
require 'json'
require_relative '../../../support/helper_methods.rb'
require_relative '../../../support/patient_helper_methods.rb'


Given(/^that a specimen is received from NCH:$/) do |specimenMessage|
  @request = Patient_helper_methods.createSpecimenRequest(params={"msg"=>specimenMessage,"receivedDate"=>"current","collectionDate"=>"current"})
end

When(/^posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "([^"]*)"$/) do |retMsg|
  @response = Helper_Methods.post_request(ENV['protocol'] + '://' + ENV['DOCKER_HOSTNAME'] + ':' + ENV['patient_api_PORT'] + '/setBiopsySpecimenDetails',@request)
  expect(@response['message']).to eql(retMsg)
end

Given(/^a new specimen is received from NCH with future received date:$/) do |specimenMessage|
  @request = Patient_helper_methods.createSpecimenRequest(params={"msg"=>specimenMessage,"receivedDate"=>"future","collectionDate"=>"current"})
end

Given(/^that a specimen is received from NCH with older collection date:$/) do |specimenMessage|
  @request = Patient_helper_methods.createSpecimenRequest(params={"msg"=>specimenMessage,"receivedDate"=>"current","collectionDate"=>"older"})
end

Given(/^that a specimen is received from NCH with received date older collection date:$/) do |specimenMessage|
  @request = Patient_helper_methods.createSpecimenRequest(params={"msg"=>specimenMessage,"receivedDate"=>"older","collectionDate"=>"current"})
end

Given(/^specimen is received for "([^"]*)" for type "([^"]*)"$/) do |psn, type|
  @request = Patient_helper_methods.create_new_specimen_received_message(psn, type, 'current')
end

And(/^specimen is received for "([^"]*)" for type "([^"]*)" with older dates$/) do |patient_id, type|
  @request = Patient_helper_methods.create_new_specimen_received_message(patient_id, type, 'a few days older')
end