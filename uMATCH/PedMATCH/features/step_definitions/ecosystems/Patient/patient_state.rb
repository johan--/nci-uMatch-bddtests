#!/usr/bin/ruby
require 'rspec'
require 'json'
require_relative '../../../support/helper_methods.rb'
require_relative '../../../support/patient_helper_methods.rb'

Given(/^that Patient StudyID "([^"]*)" PatientSeqNumber "([^"]*)" StepNumber "([^"]*)" PatientStatus "([^"]*)" Message "([^"]*)" AccrualGroupId "([^"]*)" with "([^"]*)" dateCreated is received from EA layer$/) do |studyId, psn, stepNumber, patientStatus, message, accrualGrpId, isDateCreated|
  str = Patient_helper_methods.createPatientTriggerRequestJSON(studyId, psn, stepNumber, patientStatus, message, accrualGrpId, isDateCreated)
  @jsonString = str.to_s
end

When(/^posted to MATCH setPatientTrigger$/) do
  p @jsonString
  p ENV['protocol'] + '://' + ENV['patient_state_DOCKER_HOSTNAME'] + ':' + ENV['patient_state_PORT'] + '/patient_state'
  @response = Helper_Methods.post_request(ENV['protocol'] + '://' + ENV['patient_state_DOCKER_HOSTNAME'] + ':' + ENV['patient_state_PORT'] + '/patient_state',@jsonString)
end

Then(/^a message "(.*?)" is returned with a "(.*?)"$/) do |msg, status|
  expect(@response['status']).to eql(status)
end

Given(/^patient "([^"]*)" exist in "([^"]*)"$/) do |pt_id,study|
  if study.equal?("MATCH")
    study_id = "EAY131"
    stepNumber = "0"
  elsif study.equal?("PEDMatch")
    study_id = "APEC1621"
    stepNumber = "1.0"
  end
  jsonString = Patient_helper_methods.createPatientTriggerRequestJSON(study_id, pt_id, stepNumber, "REGISTRATION", "Patient trigger", "22334a2sr", "current");

  p ENV['protocol'] + '://' + ENV['patient_state_DOCKER_HOSTNAME'] + ':' + ENV['patient_state_PORT'] + '/patient_state'
  @response = Helper_Methods.post_request(ENV['protocol'] + '://' + ENV['patient_state_DOCKER_HOSTNAME'] + ':' + ENV['patient_state_PORT'] + '/patient_state',@jsonString)
  @response['message'].should == 'Saved to datastore.'   #MATCH-1451
end


Given(/^that a new specimen is received from NCH:$/) do |specimenMessage|
  @request = Patient_helper_methods.createBiopsyRequest(params={"msg"=>specimenMessage,"receivedDate"=>"current","collectionDate"=>"current"})
  p @request
end

When(/^posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "([^"]*)"$/) do |retMsg|
  @response = Helper_Methods.post_request(ENV['protocol'] + '://' + ENV['patient_state_DOCKER_HOSTNAME'] + ':' + ENV['patient_state_PORT'] + '/setBiopsySpecimenDetails',@request)
  expect(@response['message']).to eql(retMsg)
end

Given(/^a new specimen is received from NCH with future received date:$/) do |specimenMessage|
  @request = Patient_helper_methods.createBiopsyRequest(params={"msg"=>specimenMessage,"receivedDate"=>"future","collectionDate"=>"current"})
  p @request
end