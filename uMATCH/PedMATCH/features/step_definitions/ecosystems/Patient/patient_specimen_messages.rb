#!/usr/bin/ruby
require 'rspec'
require 'json'
require_relative '../../../support/helper_methods.rb'
require_relative '../../../support/patient_helper_methods.rb'


Given(/^that a specimen is received from NCH:$/) do |specimenMessage|
  @request = Patient_helper_methods.createSpecimenRequest(params={"msg"=>specimenMessage,"receivedDate"=>"current","collectionDate"=>"current"})
  p @request
end

When(/^posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "([^"]*)" with status "([^"]*)"$/) do |retMsg, status|
  sleep(5)
  @response = Helper_Methods.post_request(ENV['protocol'] + '://' + ENV['DOCKER_HOSTNAME'] + ':' + ENV['patient_api_PORT'] + '/specimenReceived',@request)
  expect(@response['status']).to eql(status)
end

Given(/^a new specimen is received from NCH with future received date:$/) do |specimenMessage|
  @request = Patient_helper_methods.createSpecimenRequest(params={"msg"=>specimenMessage,"receivedDate"=>"future","collectionDate"=>"current"})
end

Given(/^that a specimen is received from NCH with older collection date:$/) do |specimenMessage|
  @request = Patient_helper_methods.createSpecimenRequest(params={"msg"=>specimenMessage,"receivedDate"=>"current","collectionDate"=>"older"})
end

Given(/^that a specimen is received from NCH with received date older than collection date:$/) do |specimenMessage|
  @request = Patient_helper_methods.createSpecimenRequest(params={"msg"=>specimenMessage,"receivedDate"=>"older","collectionDate"=>"current"})
end

Given(/^specimen is received for "([^"]*)" for type "([^"]*)"$/) do |psn, type|
  @request = Patient_helper_methods.create_new_specimen_received_message(psn, type, 'current')
  @response = Helper_Methods.post_request(ENV['protocol'] + '://' + ENV['DOCKER_HOSTNAME'] + ':' + ENV['patient_api_PORT'] + '/specimenReceived',@request)
  expect(@response['message']).to eql('specimen(s) received and saved.')
end

Given(/^specimen shipped message is received for patient "([^"]*)", type "([^"]*)", surgical_id "([^"]*)", molecular_id "([^"]*)" with shipped date as "([^"]*)"$/) do |patient_id, type, surgical_id, molecular_id, shipDate|
  @request = Patient_helper_methods.create_new_specimen_shipped_message(patient_id, type, surgical_id, molecular_id,shipDate)
  p @request
  @response = Helper_Methods.post_request(ENV['protocol'] + '://' + ENV['DOCKER_HOSTNAME'] + ':' + ENV['patient_api_PORT'] + '/specimenShipped',@request)
  expect(@response['message']).to eql('specimen shipped message received and saved.')
end
And(/^specimen is received for "([^"]*)" for type "([^"]*)" with older dates$/) do |patient_id, type|
  @request = Patient_helper_methods.create_new_specimen_received_message(patient_id, type, 'a few days older')
end

Given(/^that a specimen shipped message is received from NCH:$/) do |specimenMessage|
  @request = Patient_helper_methods.createSpecimenShippedMessageRequest(params={"msg"=>specimenMessage,"shipped_date"=>"current"})
  p @request
end

When(/^posted to MATCH setNucleicAcidsShippingDetails, returns a message "([^"]*)"$/) do |retMsg|
  @response = Helper_Methods.post_request(ENV['protocol'] + '://' + ENV['DOCKER_HOSTNAME'] + ':' + ENV['patient_api_PORT'] + '/specimenShipped',@request)
  expect(@response['message']).to eql(retMsg)
end

Given(/^template specimen received message in type: "([^"]*)" for patient: "([^"]*)"$/) do |type, patientID|
  @requestJson = Patient_helper_methods.createSpecimenReceivedTemplate()
  @requestJson['type'] = type
  @requestJson['patient_id'] = patientID
  @request = @request.to_json.to_s
end

Then(/^set patient message field: "([^"]*)" to "([^"]*)"$/) do |field, value|
  convertedValue = value=='null'?nil:value
  @requestJson[field] = convertedValue
  @request = @request.to_json.to_s
end

Then(/^remove field: "([^"]*)" from patient message$/) do |field|
  @requestJson.delete(field)
  @request = @request.to_json.to_s
end
