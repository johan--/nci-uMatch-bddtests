#!/usr/bin/ruby
require 'rspec'
require 'json'
require_relative '../../../support/helper_methods.rb'

When(/^the service \/version is called$/) do
  @res=Helper_Methods.get_request(ENV['protocol']+'://'+ENV['treatment_arm_DOCKER_HOSTNAME']+':'+ENV['treatment_arm_api_PORT']+'/version')
end

Then(/^the version "([^"]*)" is returned$/) do |arg1|
  expect(@res).to eql(arg1)
end

Given(/^that a new treatment arm is received from COG with study_id: "([^"]*)" id: "([^"]*)" name: "([^"]*)" description: "([^"]*)" targetId: "([^"]*)" targetName: "([^"]*)" gene: "([^"]*)" and with one drug: "([^"]*)" and with tastatus: "([^"]*)"$/) do |study_id, taId, taName, description, targetId, targetName, gene, taDrugs, taStatus|
  Treatment_arm_helper.createTreatmentArmRequestJSON(study_id, taId, taName, description, targetId, targetName, gene, taDrugs, taStatus)
end

Given(/^with variant report$/) do |variantReport|
  @taReq = Treatment_arm_helper.taVariantReport(variantReport)
  @jsonString = @taReq.to_json.to_s
end

When(/^posted to MATCH newTreatmentArm$/) do
  "Unable to obtain lock to add/update the treatment arm."
  flag = false
  while flag == false
    @response = Helper_Methods.post_request(ENV['protocol']+'://'+ENV['treatment_arm_DOCKER_HOSTNAME']+':'+ENV['treatment_arm_api_PORT']+'/newTreatmentArm',@jsonString)
    if (@response['message'] == "Unable to obtain lock to add/update the treatment arm.")
    else
      flag = true
    end
    sleep(5)
  end
end


Then(/^a message with Status "([^"]*)" and message "([^"]*)" is returned:$/) do |status, msg|
  # @response['message'].should == msg
  @response['status'].should == status
end

Given(/^that treatment arm is received from COG:$/) do |taJson|
  @jsonString = JSON.parse(taJson).to_json
end

Then(/^a failure message is returned which contains:/) do |string|
  @response['message'].should == string
end

Then(/^the treatmentArmStatus field has a value "([^"]*)" for the ta "([^"]*)"$/) do |status, taId|
  @response = Helper_Methods.get_request(ENV['protocol']+'://'+ENV['treatment_arm_DOCKER_HOSTNAME']+':'+ENV['treatment_arm_api_PORT']+'/treatmentArms',params={"id"=>taId})
  print "#{@response}\n"
  JSON.parse(@response).each do |child|
    print "#{child}"
    child['treatment_arm_status'].should == status
    break
  end

end