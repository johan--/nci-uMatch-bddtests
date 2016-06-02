#!/usr/bin/ruby
require 'rspec'
require 'json'
require_relative '../../../support/helper_methods.rb'
require_relative '../../../support/drug_obj.rb'


When(/^the service \/version is called$/) do
  @res=Helper_Methods.get_request(ENV['protocol']+'://'+ENV['treatment_arm_DOCKER_HOSTNAME']+':'+ENV['treatment_arm_api_PORT']+'/version')
end

Then(/^the version "([^"]*)" is returned$/) do |arg1|
  expect(@res).to eql(arg1)
end

Given(/^that a new treatment arm is received from COG with version: "([^"]*)" study_id: "([^"]*)" id: "([^"]*)" name: "([^"]*)" description: "([^"]*)" targetId: "([^"]*)" targetName: "([^"]*)" gene: "([^"]*)" and with one drug: "([^"]*)" and with tastatus: "([^"]*)"$/) do |version, study_id, taId, taName, description, targetId, targetName, gene, taDrugs, taStatus|
  @taReq = Treatment_arm_helper.createTreatmentArmRequestJSON(version, study_id, taId, taName, description, targetId, targetName, gene, taDrugs, taStatus)
  @jsonString = @taReq.to_json.to_s
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
    if (@response['message'] == "Unable to obtain lock to add/update the treatment arm.") or @response == nil?
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

Then(/^success message is returned:$/) do
  @response['status'].should == 'SUCCESS'
end

Given(/^that treatment arm is received from COG:$/) do |taJson|
  @jsonString = JSON.parse(taJson).to_json
end

Then(/^a failure message is returned which contains: "([^"]*)"$/) do |string|
  @response['status'].should == 'FAILURE'
  @response['message'].should == string
end

Then(/^the treatmentArmStatus field has a value "([^"]*)" for the ta "([^"]*)"$/) do |status, taId|
  @response = Helper_Methods.get_request(ENV['protocol']+'://'+ENV['treatment_arm_DOCKER_HOSTNAME']+':'+ENV['treatment_arm_api_PORT']+'/treatmentArms',params={"id"=>taId})
  print "#{@response}\n"
  tas = JSON.parse(@response)
  tas.length.should > 0
  tas.each do |child|
    print "#{child}"
    child['treatment_arm_status'].should == status
    break
  end

end

Then(/^the treatment arm: "([^"]*)" return from database has correct version: "([^"]*)" study_id: "([^"]*)" name: "([^"]*)" description: "([^"]*)" targetId: "([^"]*)" targetName: "([^"]*)" gene: "([^"]*)" and with one drug: "([^"]*)" and with tastatus: "([^"]*)"$/) do |id, version, study_id, name, description, targetId, targetName, gene, drug, tastatus|

  expectDrug = Drug_obj.new(drug)
  expectTAStatus = "Treatment Arm Status is #{tastatus}"
  expectStudyID = "Study ID is #{study_id}"
  expectName = "Name is #{name}"
  expectDescription = "Description is #{description}"
  expectTargetID = "Target ID is #{targetId}"
  expectTargetName = "Target Name is #{targetName}"
  expectGene = "Gene is #{gene}"
  expectDrugPathway = "Drug Pathway is #{expectDrug.pathway}"
  expectDrugID = "Drug ID is #{expectDrug.drugId}"
  expectDrugName = "Drug Name is #{expectDrug.drugName}"

  @response = Helper_Methods.get_request(ENV['protocol']+'://'+ENV['treatment_arm_DOCKER_HOSTNAME']+':'+ENV['treatment_arm_api_PORT']+'/treatmentArms',params={"id"=>id})
  tas = JSON.parse(@response)
  returnedtTASize = tas.length.should > 0
  foundCorrectResult = false
  tas.each do |child|
    if child['version'] == version
      # print "#{child}"
      foundCorrectResult = true

      expectTAStatus.should == "Treatment Arm Status is #{child['treatment_arm_status']}"
      expectStudyID.should == "Study ID is #{child['study_id']}"
      expectName.should == "Name is #{child['name']}"
      expectDescription.should == "Description is #{child['description']}"
      expectTargetID.should == "Target ID is #{child['target_id']}"
      expectTargetName.should == "Target Name is #{child['target_name']}"
      expectGene.should == "Gene is #{child['gene']}"

      returnedDrug = child['treatment_arm_drugs'].at(0)
      expectDrugPathway.should == "Drug Pathway is #{returnedDrug['pathway']}"
      expectDrugID.should == "Drug ID is #{returnedDrug['drug_id']}"
      expectDrugName.should == "Drug Name is #{returnedDrug['name']}"
    end
  end
  foundCorrectResult.should == true
end

Then(/^the treatment arm with id: "([^"]*)" and version: "([^"]*)" return from API has value: "([^"]*)" in field: "([^"]*)"$/) do |id, version, value, field|
  if id == 'saved_id'
    id = @savedTAID
  end
  @response = Helper_Methods.get_request(ENV['protocol']+'://'+ENV['treatment_arm_DOCKER_HOSTNAME']+':'+ENV['treatment_arm_api_PORT']+'/treatmentArms',params={"id"=>id})
  tas = JSON.parse(@response)
  returnedtTASize = "Returned treatment arms count is #{tas.length}"
  returnedtTASize.should_not == 'Returned treatment arms count is 0'
  foundCorrectResult = "Cannot find version #{version} in returned treatment arms"
  expectFieldResult = "#{field} is #{value}"
  tas.each do |child|
    if child['version'] == version
      foundCorrectResult = version
      returnedResult = "#{field} is #{child[field]}"
      returnedResult.should == expectFieldResult
    end
  end
  foundCorrectResult.should == version
end

Then(/^the treatment arm with id: "([^"]*)" and version: "([^"]*)" should return from database$/) do |id, version|
  if id == 'saved_id'
    id = @savedTAID
  end
  @response = Helper_Methods.get_request(ENV['protocol']+'://'+ENV['treatment_arm_DOCKER_HOSTNAME']+':'+ENV['treatment_arm_api_PORT']+'/treatmentArms',params={"id"=>id})
  tas = JSON.parse(@response)
  matchItems = 0
  tas.each do |child|
    if child['version'] == version
      matchItems += 1
    end
  end
  returnedtTASize = "Returned treatment arms count is #{matchItems}"
  returnedtTASize.should == 'Returned treatment arms count is 1'
end

Given(/^template json with a new unique id$/) do
  loadTemplateJson()
  @taReq['id'] = "TA_BDDTESTs_#{Time.now.to_i.to_s}"
  @jsonString = @taReq.to_json.to_s
  @savedTAID = @taReq['id']
end

And(/^set template json field: "([^"]*)" to string value: "([^"]*)"$/) do |field, sValue|
  if sValue == 'null'
    sValue = nil
  end
  loadTemplateJson()
  @taReq[field] = sValue
  @jsonString = @taReq.to_json.to_s
end

And(/^set template json field: "([^"]*)" to value: "([^"]*)" in type: "([^"]*)"$/) do |field, value, type|
  loadTemplateJson()

  if value == 'null'
    value = nil
    @taReq[field] = value
  elsif (typedValue = case type
                        when "string" then
                          value
                        when "int" then
                          value.to_i
                        when "bool" then
                          value.to_b
                        when "float" then
                          value.to_f
                      end)
  @taReq[field] = typedValue
  end
  @jsonString = @taReq.to_json.to_s
end

And(/^add prefix: "([^"]*)" to the value of template json field: "([^"]*)"$/) do |prefix, field|
  loadTemplateJson()
  @taReq[field] = "#{prefix}_#{@taReq[field]}"
  @jsonString = @taReq.to_json.to_s
end

And(/^add suffix: "([^"]*)" to the value of template json field: "([^"]*)"$/) do |suffix, field|
  loadTemplateJson()
  @taReq[field] = "#{@taReq[field]}_#{suffix}"
  @jsonString = @taReq.to_json.to_s
end

And(/^remove field: "([^"]*)" from template json$/) do |fieldName|
  loadTemplateJson()
  @taReq.delete(fieldName)
  @jsonString = @taReq.to_json.to_s
end

def loadTemplateJson()
  unless @isTemplateJsonLoaded
    @taReq = Treatment_arm_helper.validRquestJson()
    @isTemplateJsonLoaded = true
  end
end


# Then(/^load template json with saved id$/) do
#   loadTemplateJson()
#   @taReq['id'] = @savedTAID
#   @jsonString = @taReq.to_json.to_s
# end

# And(/^restore to saved id$/) do
#   @taReq['id'] = @savedTAID
#   @jsonString = @taReq.to_json.to_s
# end

# And(/^restore saved id and add suffix: "([^"]*)"$/) do |suffix|
#   @taReq['id'] = "#{@savedTAID}_#{suffix}"
#   @jsonString = @taReq.to_json.to_s
# end

# And(/^set template json unique version$/) do
#   loadTemplateJson()
#   @taReq['version'] = "V#{Time.now.to_i.to_s}"
#   @jsonString = @taReq.to_json.to_s
# end