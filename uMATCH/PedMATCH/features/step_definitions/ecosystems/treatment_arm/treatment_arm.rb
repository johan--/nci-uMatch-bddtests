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

Given(/^that treatment arm is received from COG:$/) do |taJson|
  @jsonString = JSON.parse(taJson).to_json
end

Then(/^a failure message is returned which contains:/) do |string|
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

    # {"active"=>nil,
    #  "random_variable"=>nil,
    #  "num_patients_assigned"=>nil,
    #  "date_created"=>"2016-05-25 17:32:35 UTC",
    #  "variant_report"=>{"copy_number_variants"=>[], "indels"=>[], "single_nucleotide_variants"=>[{"position"=>"11184573", "read_depth"=>"0", "gene"=>"ALK", "allele_frequency"=>"0.0", "alternative"=>"A", "type"=>"snv", "chromosome"=>"1", "reference"=>"G", "inclusion"=>true, "rare"=>false, "description"=>"some description", "level_of_evidence"=>"2.0", "identifier"=>"COSM1686998", "public_med_ids"=>["23724913"]}], "non_hotspot_rules"=>[], "gene_fusions"=>[]},
    #  "exclusion_diseases"=>nil, "exclusion_drugs"=>nil, "pten_results"=>nil, "status_log"=>nil}


end
