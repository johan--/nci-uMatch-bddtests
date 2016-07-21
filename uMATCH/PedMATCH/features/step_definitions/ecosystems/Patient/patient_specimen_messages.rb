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

When(/^posted to MATCH patient trigger service, returns a message that includes "([^"]*)" with status "([^"]*)"$/) do |retMsg, status|
  puts JSON.pretty_generate(@requestJson)
  @response = Helper_Methods.post_request(ENV['protocol'] + '://' + ENV['DOCKER_HOSTNAME'] + ':' + ENV['patient_api_PORT'] + '/trigger',@request)
  expect(@response['status']).to eql(status)
  expectMessage = "returned message include <#{retMsg}>"
  actualMessage = @response['message']
  if @response['message'].include?retMsg
    actualMessage = "returned message include <#{retMsg}>"
  end
  actualMessage.should == expectMessage
end


Given(/^template specimen received message in type: "([^"]*)" for patient: "([^"]*)"$/) do |type, patientID|
  @requestJson = Patient_helper_methods.loadPaitentMessageTemplates()
  @requestJson = @requestJson["specimen_received_#{type}"]
  convertedPID = patientID=='null'?nil:patientID
  @patientMessageRootKey = 'specimen_received'
  @requestJson[@patientMessageRootKey]['patient_id'] = convertedPID
  @request = @requestJson.to_json.to_s
end

Given(/^template specimen shipped message in type: "([^"]*)" for patient: "([^"]*)"$/) do |type, patientID|
  @requestJson = Patient_helper_methods.loadPaitentMessageTemplates()
  @requestJson = @requestJson["specimen_shipped_#{type}"]
  convertedPID = patientID=='null'?nil:patientID
  @patientMessageRootKey = 'specimen_shipped'
  @requestJson[@patientMessageRootKey]['patient_id'] = convertedPID
  @request = @requestJson.to_json.to_s
end

Given(/^template assay message with surgical_event_id: "([^"]*)" for patient: "([^"]*)"$/) do |sei, patientID|
  @requestJson = Patient_helper_methods.loadPaitentMessageTemplates()
  @requestJson = @requestJson['assay_result_reported']
  convertedPID = patientID=='null'?nil:patientID
  convertedSEI = sei=='null'?nil:sei
  @patientMessageRootKey = ''
  @requestJson['patient_id'] = convertedPID
  @requestJson['surgical_event_id'] = convertedSEI
  @request = @requestJson.to_json.to_s
end

Given(/^template pathology report with surgical_event_id: "([^"]*)" for patient: "([^"]*)"$/) do |sei, patientID|
  @requestJson = Patient_helper_methods.loadPaitentMessageTemplates()
  @requestJson = @requestJson['pathology_status']
  convertedPID = patientID=='null'?nil:patientID
  convertedSEI = sei=='null'?nil:sei
  @patientMessageRootKey = ''
  @requestJson['patient_id'] = convertedPID
  @requestJson['surgical_event_id'] = convertedSEI
  @request = @requestJson.to_json.to_s
end

Then(/^set patient message field: "([^"]*)" to value: "([^"]*)"$/) do |field, value|
  convertedValue = value=='null'?nil:value
  if @patientMessageRootKey == ''
    @requestJson[field] = convertedValue
  else
    @requestJson[@patientMessageRootKey][field] = convertedValue
  end
  @request = @requestJson.to_json.to_s
end

Then(/^remove field: "([^"]*)" from patient message$/) do |field|
  if @patientMessageRootKey == ''
    @requestJson.delete(field)
  else
    @requestJson[@patientMessageRootKey].delete(field)
  end

  @request = @requestJson.to_json.to_s
end
