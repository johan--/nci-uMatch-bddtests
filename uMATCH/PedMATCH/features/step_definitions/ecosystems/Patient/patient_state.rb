#!/usr/bin/ruby
require 'rspec'
require 'json'
require_relative '../../../support/helper_methods.rb'
require_relative '../../../support/patient_helper_methods.rb'

When(/^the patient service \/version is called$/) do
  @res=Helper_Methods.get_request(ENV['patients_endpoint']+'/version')
end

When(/^the patient processor service \/version is called$/) do
  @res=Helper_Methods.get_request(ENV['patients_endpoint']+'/version')
end

Given(/^that Patient StudyID "([^"]*)" PatientSeqNumber "([^"]*)" StepNumber "([^"]*)" PatientStatus "([^"]*)" Message "([^"]*)" with "([^"]*)" dateCreated is received from EA layer$/) do |study_id, psn, stepNumber, patientStatus, message, isDateCreated|
  str = Patient_helper_methods.createPatientTriggerRequestJSON(study_id, psn, stepNumber, patientStatus, message, isDateCreated)
  @jsonString = str.to_s
end

When(/^posted to MATCH patient registration$/) do
  p JSON.parse(@jsonString)
  p ENV['protocol'] + '://' + ENV['DOCKER_HOSTNAME'] + ':' + ENV['patient_api_PORT'] + '/trigger'
  @response = Helper_Methods.post_request(ENV['protocol'] + '://' + ENV['DOCKER_HOSTNAME'] + ':' + ENV['patient_api_PORT'] + '/trigger',@jsonString)
end

Then(/^a message "(.*?)" is returned with a "(.*?)"$/) do |msg, status|
  expect(@response['status']).to eql(status)
end

Given(/^patient "([^"]*)" exist in "([^"]*)"$/) do |pt_id,study|
  if study.eql?("MATCH")
    study_id = "EAY131"
    stepNumber = "0"
  elsif study.eql?("PEDMatch")
    study_id = "APEC1621"
    stepNumber = "1.0"
  end
  jsonString = Patient_helper_methods.createPatientTriggerRequestJSON(study_id, pt_id, stepNumber, "REGISTRATION", "Patient trigger", "current");
  p jsonString
  p ENV['protocol'] + '://' + ENV['DOCKER_HOSTNAME'] + ':' + ENV['patient_api_PORT'] + '/registration'
  @response = Helper_Methods.post_request(ENV['protocol'] + '://' + ENV['DOCKER_HOSTNAME'] + ':' + ENV['patient_api_PORT'] + '/registration',jsonString)
  @response['status'].should == 'Success'
end
