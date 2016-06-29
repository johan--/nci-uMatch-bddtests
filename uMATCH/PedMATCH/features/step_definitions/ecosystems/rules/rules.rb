#!/usr/bin/ruby
require 'rspec'
require 'json'
require_relative '../../../support/helper_methods.rb'

Given(/^the patient assignment json "([^"]*)"$/) do |patient_json|
  @patientAssignmentJson =  File.join(File.dirname(__FILE__),ENV['PATIENT_ASSIGNMENT_JSON_LOCATION']+'/'+patient_json+'.json')
  p @patientAssignmentJson
end

When(/^posted to the AssignPatient service$/) do
  @res=Helper_Methods.get_request_url_param(ENV['protocol']+'://'+ENV['DOCKER_HOSTNAME']+':'+ENV['rules_PORT']+'/nci-match-rules/rules/rs/assignPatient', params={'patient'=>@patientAssignmentJson})
  p @res
end

Then(/^a patient assignment json is returned with patient_assignment_status "([^"]*)"$/) do |assignment_status|
  expect((JSON.parse(@res))['patientAssignmentStatus']).to eql(assignment_status)

end


