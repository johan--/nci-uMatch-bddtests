#!/usr/bin/ruby
require 'rspec'
require 'json'
require_relative '../../../support/helper_methods.rb'
require_relative '../../../support/treatment_arm_helper'
# require_relative '../../../support/cog_helper_methods.rb'
require_relative '../../../support/drug_obj.rb'


When(/^the ta service \/version is called$/) do
  @res=Helper_Methods.get_request(ENV['protocol']+'://'+ENV['DOCKER_HOSTNAME']+':'+ENV['treatment_arm_api_PORT']+'/version')
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
  @response = Helper_Methods.post_request(ENV['protocol']+'://'+ENV['DOCKER_HOSTNAME']+':'+ENV['treatment_arm_api_PORT']+'/newTreatmentArm',@jsonString)
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
  @response['error'].should == string
end

Then(/^the treatmentArmStatus field has a value "([^"]*)" for the ta "([^"]*)"$/) do |status, taId|
  @response = Helper_Methods.get_request(ENV['protocol']+'://'+ENV['DOCKER_HOSTNAME']+':'+ENV['treatment_arm_api_PORT']+'/treatmentArms',params={"id"=>taId})
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

  @response = Helper_Methods.get_request(ENV['protocol']+'://'+ENV['DOCKER_HOSTNAME']+':'+ENV['treatment_arm_api_PORT']+'/treatmentArms',params={"id"=>id})
  tas = JSON.parse(@response)
  returnedTASize = tas.length.should > 0
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
  correctTA = findTheOnlyMatchTAResultFromResponse(id, version)

  expectFieldResult = "#{field} is #{value}"
  returnedResult = "#{field} is #{correctTA[field]}"
  returnedResult.should == expectFieldResult
end

Then(/^the treatment arm with id: "([^"]*)" and version: "([^"]*)" return from API should not have field: "([^"]*)"$/) do |id, version, field|
  correctTA = findTheOnlyMatchTAResultFromResponse(id, version)

  expectFieldResult = "#{field} doesn't exist"
  returnedResult = expectFieldResult
  if correctTA.key?(field)
    returnedResult = "#{field} exists"
  end
  returnedResult.should == expectFieldResult
end

Then(/^the treatment arm with id: "([^"]*)" and version: "([^"]*)" return from API has "([^"]*)" drug \(name:"([^"]*)" pathway: "([^"]*)" and id: "([^"]*)"\)$/) do |id, version,times, drugName, drugPathway, drugId|
  correctTA = findTheOnlyMatchTAResultFromResponse(id, version)

  matchDrugs = Treatment_arm_helper.findDrugsFromJson(correctTA, drugName, drugPathway, drugId)
  matchDrugs.length.should == times.to_i
end

Then(/^the treatment arm with id: "([^"]*)" and version: "([^"]*)" should return from database$/) do |id, version|
  findTheOnlyMatchTAResultFromResponse(id, version)
end

Given(/^template json with a new unique id$/) do
  loadTemplateJson()
  @taReq['id'] = "APEC1621-#{Time.now.to_i.to_s}"
  @jsonString = @taReq.to_json.to_s
  @savedTAID = @taReq['id']
end

Then(/^the treatment arm with id: "([^"]*)" and version: "([^"]*)" return from API has correct dateCreated value$/) do |id, version|
  correctTA = findTheOnlyMatchTAResultFromResponse(id, version)

  currentTime = Time.now.utc.to_i
  returnedResult = DateTime.parse(correctTA['date_created']).to_i
  timeDiff = currentTime - returnedResult
  timeDiff.should >=0
  timeDiff.should <=6
  end

Then(/^the treatment arm with id: "([^"]*)" and version: "([^"]*)" return from API has ptenResults \(ptenIhcResult: "([^"]*)", ptenVariant: "([^"]*)", description: "([^"]*)"\)$/) do |id, version, ptenIhcResult, ptenVariant, description|
  correctTA = findTheOnlyMatchTAResultFromResponse(id, version)

  matchPtenResults = Treatment_arm_helper.findPtenResultFromJson(correctTA, ptenIhcResult, ptenVariant, description)
  matchPtenResults.length.should > 0
end

Then(/^the treatment arm with id: "([^"]*)" and version: "([^"]*)" return from API has "([^"]*)" variant \(id: "([^"]*)", field: "([^"]*)", value: "([^"]*)"\)$/) do |id, version, variantType, variantId, variantField, variantValue|
  correctTA = findTheOnlyMatchTAResultFromResponse(id, version)

  matchVariant = Treatment_arm_helper.findVariantFromJson(correctTA, variantType, variantId, variantField, variantValue)
  matchVariant.length.should == 1
end

Then(/^the treatment arm with id: "([^"]*)" and version: "([^"]*)" return from API has "([^"]*)" variant \(id: "([^"]*)", publicMedIds: "([^"]*)"\)$/) do |id, version, variantType, variantId, pmIdString|
  correctTA = findTheOnlyMatchTAResultFromResponse(id, version)

  matchVariant = Treatment_arm_helper.findVariantFromJson(correctTA, variantType, variantId, "public_med_ids", pmIdString.split(','))
  matchVariant.length.should == 1
end

Then(/^the treatment arm with id: "([^"]*)" and version: "([^"]*)" return from API has "([^"]*)" variant count:"([^"]*)"$/) do |id, version, variantType, count|
  correctTA = findTheOnlyMatchTAResultFromResponse(id, version)


  matchVariants = Treatment_arm_helper.getVariantListFromJson(correctTA, variantType)
  matchVariants.length.should == count.to_i
  end

Then(/^the treatment arm with id: "([^"]*)" and version: "([^"]*)" return from API is in the place: "([^"]*)"$/) do |id, version, place|
  returnedPlace = findTreatmentArmPlaceFromResponse(id, version)
  returned = "Returned treatment arm version:#{version} is in place #{returnedPlace}"
  returned.should == "Returned treatment arm version:#{version} is in place #{place}"
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
                        when 'string' then
                          value
                        when 'int' then
                          value.to_i
                        when 'bool' then
                          value=='true'?true:false
                        when 'float' then
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

And(/^clear list field: "([^"]*)" from template json$/) do |fieldName|
  loadTemplateJson()
  if @taReq[fieldName].kind_of?(Array)
    @taReq[fieldName].clear()
  end
  @jsonString = @taReq.to_json.to_s
end

And(/^add drug with name: "([^"]*)" pathway: "([^"]*)" and id: "([^"]*)" to template json$/) do |drugName, drugPathway, drugId|
  loadTemplateJson()
  @taReq = Treatment_arm_helper.addDrug(drugName, drugPathway, drugId)
  @jsonString = @taReq.to_json.to_s
end

Then(/^add ptenResult with ptenIhcResult: "([^"]*)", ptenVariant: "([^"]*)" and description: "([^"]*)"$/) do |ptenIhcResult, ptenVariant, description|
  loadTemplateJson()
  @taReq = Treatment_arm_helper.addPtenResult(ptenIhcResult, ptenVariant, description)
  @jsonString = @taReq.to_json.to_s
end

And(/^add PedMATCH exclusion drug with name: "([^"]*)" and id: "([^"]*)" to template json$/) do |drugName, drugId|
  loadTemplateJson()
  @taReq = Treatment_arm_helper.addPedMATCHExclusionDrug(drugName, drugId)
  @jsonString = @taReq.to_json.to_s
end

Then(/^clear template json's variant: "([^"]*)" list$/) do |variantAbbr|
  loadTemplateJson()
  @taReq['variantReport'][convertVariantAbbrToFull(variantAbbr)].clear()
  @jsonString = @taReq.to_json.to_s
end

Then(/^create a template variant: "([^"]*)"$/) do |variantAbbr|
  @preparedVariant = Treatment_arm_helper.templateVariant(variantAbbr)
end

And(/^set template variant field: "([^"]*)" to string value: "([^"]*)"$/) do |field, sValue|
  @preparedVariant[field] = sValue
end

And(/^set template variant field: "([^"]*)" to bool value: "([^"]*)"$/) do |field, bValue|
  @preparedVariant[field] = bValue
end

And(/^set template variant publicMedIds: "([^"]*)"$/) do |pmIds|
  idList = pmIds.split(',')
  @preparedVariant['publicMedIds'] = idList
end

Then(/^add template variant: "([^"]*)" to template json$/) do |variantAbbr|
  loadTemplateJson()
  @taReq['variantReport'][convertVariantAbbrToFull(variantAbbr)].push(@preparedVariant)
  @jsonString = @taReq.to_json.to_s
end

And(/^remove template variant field: "([^"]*)"$/) do |field|
  @preparedVariant.delete(field)
end

Then(/^cog changes treatment arm with id:"([^"]*)" status to: "([^"]*)"$/) do |treatmentArmID, treatmentArmStatus|
  convertedID = treatmentArmID=='saved_id'?@savedTAID:id
  COG_helper_methods.setTreatmentArmStatus(convertedID, treatmentArmStatus)
end

Then(/^api update status of treatment arm with id:"([^"]*)" from cog$/) do |treatmentArmID|
  convertedID = treatmentArmID=='saved_id'?@savedTAID:id

  queryTreatmentArm = {'treatmentArmId' => convertedID}
  url = ENV['protocol']+'://'+ENV['DOCKER_HOSTNAME']+':'+ENV['treatment_arm_api_PORT']+'/ecogTreatmentArmList'
  Helper_Methods.post_request(url, queryTreatmentArm.to_json)
  sleep(2.0)
end

def loadTemplateJson()
  unless @isTemplateJsonLoaded
    @taReq = Treatment_arm_helper.validRquestJson()
    @isTemplateJsonLoaded = true
  end
end

def findTheOnlyMatchTAResultFromResponse(id, version)
  convertedID = id=='saved_id'?@savedTAID:id

  @response = Helper_Methods.get_request(ENV['protocol']+'://'+ENV['DOCKER_HOSTNAME']+':'+ENV['treatment_arm_api_PORT']+'/treatmentArms',params={"id"=>convertedID, "version"=>version})
  sleep(2)
  result = JSON.parse(@response)
  result.should_not == nil
  returnedTASize = "Returned treatment arm count is #{result.length}"
  returnedTASize.should_not == 'Returned treatment arm count is 0'

  return result
end

def findTreatmentArmPlaceFromResponse(id, version)
  convertedID = id=='saved_id'?@savedTAID:id
  @response = Helper_Methods.get_request(ENV['protocol']+'://'+ENV['DOCKER_HOSTNAME']+':'+ENV['treatment_arm_api_PORT']+'/treatmentArms',params={"id"=>convertedID})
  sleep(1)
  place = Treatment_arm_helper.findPlaceFromResponseUsingVersion(@response, version)
  return place
end

def convertVariantAbbrToFull(variantAbbr)
  result = case variantAbbr
             when 'snv' then
               'singleNucleotideVariants'
             when 'id' then
               'indels'
             when 'cnv' then
               'copyNumberVariants'
             when 'gf' then
               'geneFusions'
             when 'nhr' then
               'nonHotspotRules'
           end
  return result
end

