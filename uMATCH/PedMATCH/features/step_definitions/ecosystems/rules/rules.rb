#!/usr/bin/ruby
require 'rspec'
require 'json'
require_relative '../../../support/helper_methods.rb'

Given(/^the patient assignment json "([^"]*)"$/) do |patient_json|
  patientAssignmentJson =  File.join(File.dirname(__FILE__),ENV['PATIENT_ASSIGNMENT_JSON_LOCATION']+'/'+patient_json+'.json')
  expect(File.exist?(patientAssignmentJson)).to be_truthy
  @patient = JSON(IO.read(patientAssignmentJson))
end

And(/^treatment arm json "([^"]*)"$/) do |ta|
  ta = File.join(File.dirname(__FILE__),ENV['PATIENT_ASSIGNMENT_JSON_LOCATION']+'/'+ta+'.json')
  expect(File.exist?(ta)).to be_truthy
  @ta = JSON(IO.read(ta))
end


When(/^assignPatient service is called$/) do

  msgHash = Hash.new
  msgHash = {'patient'=> @patient, 'treatment_arms'=>@ta}
  @payload = msgHash.to_json

  res = Helper_Methods.post_request(ENV['protocol']+'://'+ENV['DOCKER_HOSTNAME']+':'+ENV['rules_PORT']+'/nci-match-rules/rules/rs/assignPatient',@payload)
  @res = res.to_json
end

Then(/^a patient assignment json is returned with reason category "([^"]*)" for treatment arm "([^"]*)"$/) do |assignment_reason,ta|
  JSON.parse(@res)['patientAssignmentLogic'].each do |logic|
    if logic['treatmentArmName'] == ta
      expect(logic['reasonCategory']).to eql(assignment_reason)
    end
  end
end

Then(/^the patient assignment reason is "([^"]*)" for treatment arm "([^"]*)"$/) do |reason,ta|
   expect(JSON.parse(@res)['patientAssignmentStatus']).to eql(reason)
end


