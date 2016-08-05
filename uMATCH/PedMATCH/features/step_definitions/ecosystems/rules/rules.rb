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
  # p @res
  expect((JSON.parse(@res)['Error'])).to be_nil
end

Then(/^a patient assignment json is returned with reason category "([^"]*)" for treatment arm "([^"]*)"$/) do |assignment_reason,ta|
  JSON.parse(@res)['patientAssignmentLogic'].each do |logic|
    if logic['treatmentArmName'] == ta
      expect(logic['reasonCategory']).to eql(assignment_reason)
    end
  end
end

Then(/^the patient assignment reason is "([^"]*)"$/) do |reason|
   expect(JSON.parse(@res)['patientAssignmentStatus']).to eql(reason)
end

Given(/^a tsv variant report file file "([^"]*)" and treatment arms file "([^"]*)"$/) do |arg1, arg2|
  @bucket = "bdd-test-data"
  @tsv = arg1
  @ta = arg2
end

When(/^call the amoi rest service$/) do
  @res = Helper_Methods.get_request_url_param(ENV['protocol']+'://'+ENV['DOCKER_HOSTNAME']+':'+ENV['rules_PORT']+'/nci-match-rules/rules/rs/amois',{"bucket"=>@bucket,"tsv"=>@tsv,"ta"=>@ta})
  # p @res
  expect((JSON.parse(@res)['Error'])).to be_nil
end

Then(/^moi report is returned with the snv variant "([^"]*)" as an amoi$/) do |arg1|
  JSON.parse(@res)['single_nucleotide_variants'].each do |snv|
    if snv['identifier'] == arg1
      expect(snv['amoi']).to eql(true)
    end
  end
end


Then(/^amoi treatment arm names for snv variant "([^"]*)" include:$/) do |arg1, string|
  arrTA = string.split(/\n+/)
  JSON.parse(@res)['single_nucleotide_variants'].each do |snv|
    if snv['identifier'] == arg1
      expect(snv['treatmentArmNames']).to match_array(arrTA)
    end
  end
end

Then(/^amoi treatment arms for snv variant "([^"]*)" include:$/) do |arg1, string|
  taHash = JSON.parse(string)
  JSON.parse(@res)['single_nucleotide_variants'].each do |snv|
    if snv['identifier'] == arg1
      expect((snv['treatmentArms']).flatten).to match_array((taHash).flatten)
    end
  end
end

Then(/^moi report is returned without the snv variant "([^"]*)"$/) do |arg1|
  JSON.parse(@res)['single_nucleotide_variants'].each do |snv|
    if snv['identifier'] == arg1
      fail ("The SNV #{arg1} is found in the moi report")
    end
  end
end

Then(/^moi report is returned with the snv variant "([^"]*)"$/) do |arg1|
  flag = false
  JSON.parse(@res)['single_nucleotide_variants'].each do |snv|
    if snv['identifier'] == arg1
      flag = true
    end
  end
  if flag == false
    fail ("The SNV #{arg1} is not found in the moi report")
  end
end