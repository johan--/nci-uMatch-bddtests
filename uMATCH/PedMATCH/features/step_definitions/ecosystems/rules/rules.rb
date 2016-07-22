#!/usr/bin/ruby
require 'rspec'
require 'json'
require_relative '../../../support/helper_methods.rb'

Given(/^the patient assignment json "([^"]*)"$/) do |patient_json|
  @patientAssignmentJson =  File.join(File.dirname(__FILE__),ENV['PATIENT_ASSIGNMENT_JSON_LOCATION']+'/'+patient_json+'.json')
  @ta = File.join(File.dirname(__FILE__),ENV['PATIENT_ASSIGNMENT_JSON_LOCATION']+'/TA.json')
  expect(File.exist?(@patientAssignmentJson)).to be_truthy


end

When(/^assignPatient service is called$/) do
  @res=Helper_Methods.get_request_url_param(ENV['protocol']+'://'+ENV['DOCKER_HOSTNAME']+':'+ENV['rules_PORT']+'/nci-match-rules/rules/rs/assignPatient', params={'patient'=>@patientAssignmentJson,'ta'=>@ta})
  p @res
end

Then(/^a patient assignment json is returned with patient_assignment_reason "([^"]*)" for treatment arm "([^"]*)"$/) do |assignment_reason,ta|
  JSON.parse(@res)['patientAssignmentLogic'].each do |logic|
    if logic['treatmentArmName'] == ta
      expect(logic['reasonCategory']).to eql(assignment_reason)
    end
  end
end


