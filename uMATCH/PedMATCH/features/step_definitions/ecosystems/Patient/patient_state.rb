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