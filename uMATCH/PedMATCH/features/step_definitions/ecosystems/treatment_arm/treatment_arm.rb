#!/usr/bin/ruby
require 'rspec'
require 'json'
require_relative '../../../support/helper_methods.rb'
require_relative '../../../support/treatment_arm_helper'
# require_relative '../../../support/cog_helper_methods.rb'
require_relative '../../../support/drug_obj.rb'


When(/^the ta service \/version is called$/) do
  @res=Helper_Methods.get_request("#{ENV['treatment_arm_endpoint']}/api/v1/treatment_arms/version")
end

Then(/^the version "([^"]*)" is returned$/) do |arg1|
  expect(@res['http_code']).to eql(200)
  # expect(@res).to include(arg1)
end

Given(/^GET list service for treatment arm id "([^"]*)", stratum id "([^"]*)" and version "([^"]*)"$/) do |ta_id, stratum_id, version|
  @version = version
  @ta_id = ta_id
  @stratum_id = stratum_id
  @request_url = "#{ENV['treatment_arm_endpoint']}/api/v1/treatment_arms"
  if @ta_id.present?
    @request_url += "/#{@ta_id}/#{@stratum_id}"
    if @version.present?
      @request_url += "/#{@version}"
    end
  end
end

Then(/^wait until patient "([^"]*)" ta assignment report for id "([^"]*)" stratum "([^"]*)" is updated$/) do |patient_id, ta_id, stratum|
  @ta_id = ta_id
  @stratum_id = stratum
  @request_url = "#{ENV['treatment_arm_endpoint']}/api/v1/treatment_arms/#{@ta_id}/#{@stratum_id}/assignment_report"
  try_time = 0
  old_patient_assignment = 'nothing'
  while try_time < 30
    @response = Helper_Methods.simple_get_request(@request_url)['message_json']
    next if @response.is_a?(Array) #when it's the first patient in this ta's assignment event table
    #the first time call this ta's assignment event GET, the response is an empty array (instead of an empty hash)
    new_patient_assignment = @response['patients_list'].select {|a| a['patient_id']==patient_id}
    new_patient_assignment = new_patient_assignment[0] if new_patient_assignment.is_a?(Array)
    old_patient_assignment = new_patient_assignment if old_patient_assignment == 'nothing'
    break unless new_patient_assignment == old_patient_assignment
    puts "Retrying to get updated treatment arm assignment for patient #{patient_id}..."
    try_time += 1
    sleep 5.0
  end
end

Given(/^GET assignment report service for treatment arm id "([^"]*)" and stratum id "([^"]*)"$/) do |ta_id, stratum_id|
  @ta_id = ta_id
  @stratum_id = stratum_id
  @request_url = "#{ENV['treatment_arm_endpoint']}/api/v1/treatment_arms/#{@ta_id}/#{@stratum_id}/assignment_report"
end

When(/^GET from MATCH treatment arm API as authorization role "([^"]*)"$/) do |role|
  @response = Helper_Methods.get_request(@request_url, {}, true, role)
end

Given(/^that a new treatment arm is received from COG with version: "([^"]*)" study_id: "([^"]*)" id: "([^"]*)" name: "([^"]*)" description: "([^"]*)" target_id: "([^"]*)" target_name: "([^"]*)" gene: "([^"]*)" and with one drug: "([^"]*)" and with tastatus: "([^"]*)" and with stratum_id "([^"]*)"$/) do |version, study_id, taId, taName, description, target_id, target_name, gene, taDrugs, taStatus, stratum_id|
  @version = version
  @ta_id = taId
  @stratum_id = stratum_id

  @taReq = Treatment_arm_helper.createTreatmentArmRequestJSON(version, study_id, taId, taName, description, target_id, target_name, gene, taDrugs, taStatus, stratum_id)
  @jsonString = @taReq.to_json.to_s
end

Given(/^that treatment arm is received from COG:$/) do |taJson|
  request = JSON.parse(taJson)
  @ta_id = request['treatment_arm_id']
  @stratum_id = request['stratum_id']
  @version = request['version']
  request['date_created'] = Helper_Methods.getDateAsRequired(request['date_created'])
  @jsonString = request.to_json
end


Given(/^template treatment arm json with a random id$/) do
  loadTemplateJson()
  sleep(2)
  @taReq['treatment_arm_id'] = "APEC1621-#{Time.now.to_i.to_s}"
  @ta_id = @taReq['treatment_arm_id']
  @stratum_id = @taReq['stratum_id']
  @version = @taReq['version']
  @jsonString = @taReq.to_json.to_s
end

Given(/^template treatment arm json with an id: "([^"]*)"$/) do |id|
  loadTemplateJson()
  @taReq['treatment_arm_id'] = id == 'null' ? nil : id
  @ta_id = @taReq['treatment_arm_id']
  @version = @taReq['version']
  @stratum_id = @taReq['stratum_id']
  @jsonString = @taReq.to_json.to_s
end


Given(/^template treatment arm json with an id: "([^"]*)", stratum_id: "([^"]*)" and version: "([^"]*)"$/) do |id, stratum_id, version|
  loadTemplateJson()
  @taReq['treatment_arm_id'] = id == 'null' ? nil : id
  @taReq['version'] = version == 'null' ? nil : version
  @taReq['stratum_id'] = stratum_id == 'null' ? nil : stratum_id
  @ta_id = @taReq['treatment_arm_id']
  @stratum_id = @taReq['stratum_id']
  @version = @taReq['version']
  @jsonString = @taReq.to_json.to_s
  @request_url = "#{ENV['treatment_arm_endpoint']}/api/v1/treatment_arms/#{@ta_id}/#{@stratum_id}/#{@version}"
end


Given(/^template treatment arm assignment json for patient "([^"]*)" with treatment arm id: "([^"]*)", stratum_id: "([^"]*)" and version: "([^"]*)"$/) do |patient_id, ta_id, stratum_id, version|
  @version = version
  @ta_id = ta_id
  @stratum_id = stratum_id
  assignment_json_file = File.join(Support::TEMPLATE_FOLDER, 'validPedMATCHTreatmentArmAssignmentEventTempalte.json')
  @jsonString = File.read(assignment_json_file)
  @jsonString.gsub!('**pt_id**', patient_id)
  @jsonString.gsub!('**ta_id**', ta_id)
  @jsonString.gsub!('**stratum**', stratum_id)
  @jsonString.gsub!('**version**', version)
  @request_url = "#{ENV['treatment_arm_endpoint']}/api/v1/treatment_arms/#{@ta_id}/#{@stratum_id}/#{@version}/assignment_event"
end

Given(/^with variant report$/) do |variantReport|
  @taReq = Treatment_arm_helper.taVariantReport(variantReport)
  @jsonString = @taReq.to_json.to_s
end

Given(/^retrieving all treatment arms based on "(.+?)"$/) do |projection|
  @projections = "?projection[]=#{projection.split(',').join('&projection[]=')}"
  url = "#{ENV['treatment_arm_endpoint']}/api/v1/treatment_arms/#{@projections}"
  @response = Helper_Methods.get_request(url)
end

Then(/^I should get an array of empty objects equal to the count of treatment arms$/) do
  complete_tas = Helper_Methods.get_request("#{ENV['treatment_arm_endpoint']}/api/v1/treatment_arms")

  expected = JSON.parse(complete_tas['message'])
  actual = JSON.parse(@response['message'])
  expect(expected.size).to eql(actual.size)
  expect(actual.first.size).to eql(0)

end

Then(/^each element should only have the keys listed in "(.+?)"$/) do |projection|
  projection_array = projection.split(',')

  # taking and comparing only the first element in the response
  jsonResponse = JSON.parse(@response['message'])
  expect(jsonResponse.first.size).to eql(projection_array.size)
  expect(jsonResponse.first.keys).to eql(projection_array)
end

When(/^creating a new treatment arm using post request$/) do
  url = "#{ENV['treatment_arm_endpoint']}/api/v1/treatment_arms/#{@ta_id}/#{@stratum_id}/#{@version}"
  puts JSON.pretty_genereate(@taReq) if ENV['print_log'] == 'YES'
  @response = Helper_Methods.post_request(url, @jsonString)
end

When(/^POST to MATCH treatment arm API as authorization role "([^"]*)"$/) do |role|
  @response = Helper_Methods.post_request(@request_url, @jsonString, true, role)
end

When(/^updating an existing treatment arm using "(put|post)" request$/) do |type|
  url = "#{ENV['treatment_arm_endpoint']}/api/v1/treatment_arms/#{@ta_id}/#{@stratum_id}/#{@version}"
  if type == 'put'
    @response = Helper_Methods.put_request(url, @jsonString)
  elsif type == 'post'
    @response = Helper_Methods.post_request(url, @jsonString)
  end
end

When(/^updating treatment arm status using put request as authorization role "([^"]*)"$/) do |role|
  url = "#{ENV['treatment_arm_endpoint']}/api/v1/treatment_arms/status"
  @response = Helper_Methods.put_request(url, '', true, role)
end

Then(/^a message with Status "([^"]*)" and message "([^"]*)" is returned:$/) do |status, msg|

  @response['status'].downcase.should == status.downcase
end

Then(/^a success message is returned$/) do
  @response['status'].downcase.should == 'success'
end

Then(/^the "(.+?)" field has a "(.+)" value$/) do |field, value|
  body = JSON.parse(@response['message'])
  if value == 'null'
    expect(body[field]).to be_nil
  else
    expect(body[field].to_s).to eql value.to_s
  end
end

When(/^calling with basic "(true|false)" and active "(.+?)"$/) do |basic, active|
  params = []
  flag_basic = basic == 'true' ? true : false
  params << "basic=#{flag_basic}"
  flag_active = nil
  if active.match(/true|false/)
    flag_active = active == 'true' ? true : false
  end
  params << "active=#{flag_active}" unless flag_active.nil?
  param = params.join("&")

  @response = Helper_Methods.get_request("#{ENV['treatment_arm_endpoint']}/api/v1/treatment_arms?#{param}")
end

When(/^calling uploaded treatment arm with basic "(true|false)" and active "(.+?)"$/) do |basic, active|
  params = []
  if active.match(/true|false/)
    flag_active = active == 'true' ? true : false
  end
  params << "active=#{flag_active}" unless active.match(/null/)
  param = params.join("&")
  @response = Helper_Methods.get_request("#{ENV['treatment_arm_endpoint']}/api/v1/treatment_arms/#{@ta_id}/#{@stratum_id}?#{param}")
end

Then (/^should return "(.+)" of the records$/) do |num_records|
  expect(JSON.parse(@response['message']).size).to eq(num_records.to_i)
end

Then (/^the returned treatment arm has "(.+?)" as the version$/) do |version|
  expect(JSON.parse(@response['message']).first['version']).to eql(version)
end

Then(/^following ta assignment reports for patient "([^"]*)" should be found$/) do |patient_id, table|
  table.hashes.each do |param|
    url = "#{ENV['treatment_arm_endpoint']}/api/v1/treatment_arms/#{param['ta_id']}/#{param['stratum']}/assignment_report"
    response = Helper_Methods.simple_get_request(url)['message_json']
    expect(response.keys).to include 'patients_list'
    expect(response['patients_list'].class).to eq Array
    found = false
    selected = response['patients_list'].select {|this_pt| this_pt['patient_id'] == patient_id}
    if param['patient_status'].present?
      selected.each do |this_pt|
        if this_pt['patient_id'] == patient_id
          found = true
          expect(this_pt['version']).to eq param['version']
          expect(this_pt['patient_status']).to eq param['patient_status']
        end
      end
      raise "Cannot find patient #{patient_id}" unless found
    else
      error = "#{patient_id} should not exist in assignment report for"
      error += "#{param['ta_id']}/#{param['stratum']}/#{param['version']}"
      raise error if selected.size > 0
    end
  end
end

Then(/^wait for "([^"]*)" seconds$/) do |seconds|
  puts "Waiting for #{seconds} seconds"
  sleep(seconds.to_f)
end

Then(/^wait for processor to complete request in "(.+?)" attempts/) do |attempts|
  status = wait_for_processor(attempts.to_i, 10)
  expect(status).to eql true
end

Then (/^failure message listing "(.+?)" and reason as "(.+?)" is returned$/) do |variant_type, missing_field|
  expect(@response['status'].downcase).to eq('failure')
  expected = extract_cause_from_message(@response['message'])
  expect(expected[:variant]).to eq (convertVariantAbbrToFull(variant_type))
  expect(expected[:missing_field]).to eq missing_field
end

Then(/^a failure message is returned which contains: "([^"]*)"$/) do |message|
  expect(@response['status'].downcase).to eq('failure')
  expect(@response['message']).to include(message)
end

Then(/^a failure response code of "([^"]*)" is returned$/) do |response_code|
  expect(@response['status']).to eq('Failure')
  expect(@response['http_code']).to eq(response_code)
end

Then(/^a http response code of "([^"]*)" is returned$/) do |response_code|
  if @response['http_code'].to_s != response_code.to_s
    puts @response
  end
  expect(@response['http_code'].to_s).to eq(response_code.to_s)
end

Then(/^the treatment_arm_status field has a value "([^"]*)" for the ta "([^"]*)"$/) do |status, taId|
  sleep(10)
  endpoint = "api/v1/treatment_arms/#{taId}/#{@stratum_id}/#{@version}"

  response = Helper_Methods.get_request("#{ENV['treatment_arm_endpoint']}/#{endpoint}")
  tas = JSON.parse(response['message'])
  tas.length.should > 0
  expect(tas['treatment_arm_status']).to eq(status)
end

Then(/^the treatment arm: "([^"]*)" return from database has correct version: "([^"]*)" study_id: "([^"]*)" name: "([^"]*)" description: "([^"]*)" target_id: "([^"]*)" target_name: "([^"]*)" gene: "([^"]*)" and with one drug: "([^"]*)" and with tastatus: "([^"]*)"$/) do |id, version, study_id, name, description, target_id, target_name, gene, drug, tastatus|

  expectDrug = Drug_obj.new(drug)
  expectTAStatus = "Treatment Arm Status is #{tastatus}"
  expectStudyID = "Study ID is #{study_id}"
  expectName = "Name is #{name}"
  expectDescription = "Description is #{description}"
  expectTargetID = "Target ID is #{target_id}"
  expectTargetName = "Target Name is #{target_name}"
  expectGene = "Gene is #{gene}"
  expectDrugPathway = "Drug Pathway is #{expectDrug.pathway}"
  expectDrugID = "Drug ID is #{expectDrug.drugId}"
  expectDrugName = "Drug Name is #{expectDrug.drugName}"

  @response = Helper_Methods.get_request("#{ENV['treatment_arm_endpoint']}/api/v1/treatment_arms", params={"treatment_arm_id" => id})
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

Then(/^treatment arm return from basic treatment arms has correct status: "([^"]*)"$/) do |status|
  response = find_all_basic_treatment_arms
  @response = JSON.parse(response)

  selected_ta = @response.select {|e| e['id'] == @ta_id && e['stratum_id'] == @stratum_id}
  expect(selected_ta.size).to be > 0

  element = selected_ta.first

  expected_array = %w(id name stratum_id treatment_arm_status date_opened date_closed current_patients former_patients not_enrolled_patients pending_patients)
  expect(element.keys).to match_array(expected_array)

  expect(element['treatment_arm_status']).to eq(status)
end

Then(/^the treatment arm return from \/basciTreatmentArms\/id has correct values, name: "([^"]*)" and status: "([^"]*)"$/) do |id, status|
  correctBasicTAs = find_treatment_arm_basic(id, @stratum_id)
  returnedTASize = "Returned treatment arm count is #{correctBasicTAs.length}"
  returnedTASize.should_not == 'Returned treatment arm count is 0'

  expectValue = nil
  correctBasicTAs[0].each {|key, value|
    if key.eql? 'name'
      realResult = "name value is #{value}"
      realResult.should == "name value is #{id}"
    elsif key.eql? 'treatment_arm_status'
      realResult = "status value is #{value}"
      realResult.should == "status value is #{status}"
    elsif key.eql? 'date_created'
      convertedValue = (value==nil) ? 'null' : value
      realResult = "date_created value is #{convertedValue}"
      realResult.should_not == 'date_created value is null'
    elsif key.eql? 'stratum_id'
      convertedValue = (value==nil) ? 'null' : value
      realResult = "date_created value is #{convertedValue}"
      realResult.should_not == 'date_created value is null'
    else
      convertedValue = (value==nil) ? 'null' : value
      realResult = "#{key} value is #{convertedValue}"
      realResult.should == "#{key} value is null"
    end
  }
end

Then(/^retrieve the posted treatment arm from API$/) do
  sleep(3)
  @response = find_single_treatment_arm(@ta_id, @stratum_id, @version)
  # @response = response
end

Then(/^retrieve treatment arm with id: "([^"]*)", stratum_id: "([^"]*)" and version: "([^"]*)" from API$/) do |id, stratum, version|
  @response = find_single_treatment_arm(id, stratum, version)
end

Then(/^retrieve treatment arms with id: "([^"]*)" and stratum_id: "([^"]*)" from API$/) do |id, stratum|
  find_all_versions(id, stratum)
end

Given(/^retrieve all treatment arms from \/treatmentArms$/) do
  @all_treatment_arms = find_all_treatment_arms()
end

Then(/^retrieve basic list of treatment arms$/) do
  @all_basic_treatment_arms = find_all_basic_treatment_arms()
end

Then(/^retrieve the treatment arm using the get service$/) do
  @response = find_single_treatment_arm(@ta_id, @stratum_id, @version)
end

Then(/^retrieve single treatment arm with id: "([^"]*)" and stratum_id: "([^"]*)" using \/treatmentArm service$/) do |id, stratum_id|
  @response = findSingleTreatmentArm(id, stratum_id)
end

Then(/^the returned treatment arm has value: "([^"]*)" in field: "([^"]*)"$/) do |value, field|
  response = JSON.parse(@response['message'])
  expect(response[field].to_s).to eq(value)
end

Then(/^the first returned treatment arm has value: "([^"]*)" in field: "([^"]*)"$/) do |value, field|
  data = JSON.parse(@response['message']).first
  expect(data[field].to_s).to eq(value)
end

Then(/^the first returned treatment arm has "([^"]*)" variant \(id: "([^"]*)", field: "([^"]*)", value: "([^"]*)"\)$/) do |type, id, field, value|
  data = JSON.parse(@response['message']).first
  match_variant = Treatment_arm_helper.findVariantFromJson(data, type, id, field, value)
  match_variant.length.should == 1
  @current_variant = match_variant[0]
end


Then(/^the returned treatment arm has "([^"]*)" value: "([^"]*)" in field: "([^"]*)"$/) do |type, value, field|
  if type == :number || :float || :int
    returnedValue = returnedValue.to_f
    expectedValue = expectedValue.to_f
  else
    returnedValue = @response['message'][field]
    expectedValue = value
  end
  expect("#{field}: #{returnedValue}").to eq("#{field}: #{expectedValue}")
end

Then(/^the returned treatment arm should not have field: "([^"]*)"$/) do |field|
  expectFieldResult = "#{field} doesn't exist"
  returnedResult = expectFieldResult
  if @response.key?(field)
    returnedResult = "#{field} exists"
  end
  returnedResult.should == expectFieldResult
end

Then(/^the returned treatment arm has "([^"]*)" drug \(name:"([^"]*)" pathway: "([^"]*)" and id: "([^"]*)"\)$/) do |times, drugName, _drugPathway, drugId|
  sut = @response['treatment_arm_drugs']
  expect(sut.size.to_s).to eql times
  expect(sut['drug_name']).to eql drugName
  expect(sut['drug_id']).to eql drugId
end

Then(/^the returned treatment arm has correct latest status that match cog record$/) do
  apiLastStatusDate = "lastest treatment arm status date is #{Treatment_arm_helper.findStatusDateFromJson(@response, 0)}"
  apiLastStatusName = "lastest treatment arm status is #{Treatment_arm_helper.findStatusFromJson(@response, 0)}"
  cogLastStatus = JSON.parse(COG_helper_methods.getTreatmentArmStatus(@response['name'], @response['stratum_id']))
  cogLastStatusDate = "lastest treatment arm status date is #{cogLastStatus['status_date']}"
  cogLastStatusName = "lastest treatment arm status is #{cogLastStatus['status']}"
  apiLastStatusDate.should == cogLastStatusDate
  apiLastStatusName.should == cogLastStatusName
end

Then(/^the returned treatment arm has correct date_created value$/) do
  currentTime = Time.now.utc.to_i
  response = JSON.parse(@response['message'])
  returnedResult = DateTime.parse(response['date_created']).to_i

  expect(returnedResult).to be_within(15).of(currentTime)
end

Then(/^the returned treatment arm has ptenResults \(ptenhIhcResult: "([^"]*)", ptenVariant: "([^"]*)", description: "([^"]*)"\)$/) do |ptenIhcResult, ptenVariant, description|
  matchPtenResults = Treatment_arm_helper.findPtenResultFromJson(@response, ptenIhcResult, ptenVariant, description)
  matchPtenResults.length.should > 0
end

Then(/^the returned treatment arm has assayResult \(gene: "([^"]*)", type: "([^"]*)", assay_result_status: "([^"]*)", assay_variant: "([^"]*)", LOE: "([^"]*)", description: "([^"]*)"\)$/) do |gene, type, status, variant, loe, description|
  gene_expected = nil_if_null gene
  type_expected = nil_if_null type
  status_expected = nil_if_null status
  variant_expected = nil_if_null variant
  loe_expected = nil_if_null loe
  desc_expected = nil_if_null description

  expected_hash = {
      'gene' => gene_expected,
      'type' => type_expected,
      'assay_result_status' => status_expected,
      'assay_variant' => variant_expected,
      'level_of_evidence' => loe_expected,
      'description' => desc_expected,
  }
  assay_rules = JSON.parse(@response['message'])['assay_rules']
  expect(assay_rules).to include(expected_hash)
end

Then(/^the returned treatment arm has exclusionCriteria \(id: "([^"]*)", description: "([^"]*)"\)$/) do |exclusionCriteriaID, description|
  matchExclusionCriteria = Treatment_arm_helper.findExlusionCriteriaFromJson(@response, exclusionCriteriaID, description)
  matchExclusionCriteria.length.should > 0
end

Then(/^the returned treatment arm has "([^"]*)" variant \(id: "([^"]*)", field: "([^"]*)", value: "([^"]*)"\)$/) do |variantType, variantId, variantField, variantValue|
  response = JSON.parse(@response['message'])
  match_variant = Treatment_arm_helper.findVariantFromJson(response, variantType, variantId, variantField, variantValue)
  match_variant.length.should == 1
  @current_variant = match_variant[0]
end

And(/^this treatment arm variant has field "([^"]*)" value "([^"]*)"$/) do |field, value|
  converted_value = value=='null' ? nil : value
  expect(@current_variant.keys).to include field
  expect(@current_variant[field]).to eq converted_value
end

Then(/^the returned treatment arm has "([^"]*)" variant \(id: "([^"]*)", public_med_ids: "([^"]*)"\)$/) do |variantType, variantId, pmIdString|
  response = JSON.parse(@response['message'])
  matchVariant = Treatment_arm_helper.findVariantFromJson(response, variantType, variantId, "public_med_ids", pmIdString.split(','))
  matchVariant.length.should == 1
end

Then(/^the returned treatment arm has "([^"]*)" variant count:"([^"]*)"$/) do |variantType, count|
  response = JSON.parse(@response['message'])
  matchVariants = Treatment_arm_helper.getVariantListFromJson(response, variantType)
  expect(matchVariants.length.to_s).to eql(count)
end

Then(/^the treatment arm with version: "([^"]*)" is in the place: "([^"]*)" of returned treatment arm list$/) do |version, place|
  returnedPlace = 0
  @response['message'].each do |child|
    returnedPlace += 1
    if child['version'] == version
      break
    end
  end
  returned = "Returned treatment arm version:#{version} is in place #{returnedPlace}"
  returned.should == "Returned treatment arm version:#{version} is in place #{place}"
end

Then(/^there are "([^"]*)" treatment arms in returned list$/) do |count|
  size = JSON.parse(@response['message']).length
  expect(size).to eql count
end

Then(/^There are "([^"]*)" treatment arm with id: "([^"]*)" and stratum_id: "([^"]*)" return from API \/basicTreatmentArms$/) do |count, id, stratum|
  returnedTAs = findAllBasicTreatmentArmsForID(id)
  returnedCount = 0
  returnedTAs.each do |child|
    if child['stratum_id'] == stratum
      returnedCount += 1
    end
  end
  returnedCount.should == count.to_i
end

And(/^set template treatment arm json field: "([^"]*)" to string value: "([^"]*)"$/) do |field, sValue|
  if sValue == 'null'
    converted_value = nil
  elsif field.include?('date')
    converted_value = Helper_Methods.getDateAsRequired(sValue)
  else
    converted_value = sValue
  end
  loadTemplateJson()
  @taReq[field] = converted_value
  @jsonString = @taReq.to_json.to_s
end

And(/^set the version of the treatment arm to "([^"]*)"$/) do |version|
  @version = nil_if_null version
  body = JSON.parse(@jsonString)
  body['version'] = @version

  @jsonString = body.to_json.to_s
end


And(/^set template treatment arm json field: "([^"]*)" to value: "([^"]*)" in type: "([^"]*)"$/) do |field, value, type|
  loadTemplateJson()
  if value == 'null'
    @taReq[field] = nil
  else
    val = case type
            when 'string' then
              value
            when 'int' then
              value.to_i
            when 'bool' then
              value == 'true' ? true : false
            when 'float' then
              value.to_f
          end
    @taReq[field] = val
  end
  @jsonString = @taReq.to_json.to_s
end

And(/^add prefix: "([^"]*)" to the value of template json field: "([^"]*)"$/) do |prefix, field|
  loadTemplateJson()
  @taReq[field] = "#{prefix}_#{@taReq[field]}"
  @jsonString = @taReq.to_json.to_s
end

And(/^add suffix: "([^"]*)" to the value of treatment arm template json field: "([^"]*)"$/) do |suffix, field|
  loadTemplateJson()
  @taReq[field] = "#{@taReq[field]}_#{suffix}"
  @jsonString = @taReq.to_json.to_s
end

And(/^remove field: "([^"]*)" from template treatment arm json$/) do |fieldName|
  loadTemplateJson()
  @taReq.delete(fieldName)
  @jsonString = @taReq.to_json.to_s
end

And(/^clear list field: "([^"]*)" from template treatment arm json$/) do |fieldName|
  @taReq[fieldName].clear if @taReq[fieldName].kind_of?(Array)

  @jsonString = @taReq.to_json.to_s
end

And(/^add drug with name: "([^"]*)" pathway: "([^"]*)" and id: "([^"]*)" to template treatment arm json$/) do |drugName, drugPathway, drugId|
  loadTemplateJson()
  @taReq = Treatment_arm_helper.add_drug(drugName, drugId, drugPathway)
  @jsonString = @taReq.to_json.to_s
end

Then(/^add ptenResult with ptenIhcResult: "([^"]*)", ptenVariant: "([^"]*)" and description: "([^"]*)"$/) do |ptenIhcResult, ptenVariant, description|
  loadTemplateJson()
  @taReq = Treatment_arm_helper.addPtenResult(ptenIhcResult, ptenVariant, description)
  @jsonString = @taReq.to_json.to_s
end

Then (/^add assayResult with gene: "([^"]*)", type: "(.+?)", assay_result_status: "([^"]*)", assay_variant: "([^"]*)", LOE: "([^"]*)" and description: "([^"]*)"$/) do |gene, type, status, variant, loe, description|
  loadTemplateJson()
  @taReq = Treatment_arm_helper.addAssayResult(gene, type, status, variant, loe, description)
  @jsonString = @taReq.to_json.to_s
end

Then(/^add exclusionCriterias with id: "([^"]*)" and description: "([^"]*)"$/) do |exclusionCriteriaID, description|
  loadTemplateJson()
  @taReq = Treatment_arm_helper.addExclusionCriteria(exclusionCriteriaID, description)
  @jsonString = @taReq.to_json.to_s
end

And(/^add PedMATCH exclusion drug with name: "([^"]*)" and id: "([^"]*)" to template treatment arm json$/) do |drugName, drugId|
  loadTemplateJson()
  @taReq = Treatment_arm_helper.add_exclusion_drug(drugName, drugId)
  @jsonString = @taReq.to_json.to_s
end

Then(/^clear template treatment arm json's variant: "([^"]*)" list$/) do |variantAbbr|
  loadTemplateJson()
  @taReq[convertVariantAbbrToFull(variantAbbr)].clear()
  @jsonString = @taReq.to_json.to_s
end

Then(/^create a template variant: "([^"]*)" for treatment arm$/) do |variantAbbr|
  @preparedVariant = Treatment_arm_helper.templateVariant(variantAbbr)
end

When(/^remove "([^"]*)" field from the variant$/) do |element|
  @preparedVariant.delete(element)
end

And(/^set template treatment arm variant field: "([^"]*)" to string value: "([^"]*)"$/) do |field, sValue|
  @preparedVariant[field] = sValue
end

And(/^set template treatment arm variant field: "([^"]*)" to bool value: "([^"]*)"$/) do |field, bValue|
  val = bValue == 'true' ? true : false
  @preparedVariant[field] = val
end

And(/^set template treatment arm variant public_med_ids: "([^"]*)"$/) do |pmIds|
  idList = pmIds.split(',')
  @preparedVariant['public_med_ids'] = idList
end

Then(/^add template variant: "([^"]*)" to template treatment arm json$/) do |variantAbbr|
  loadTemplateJson()
  @taReq[convertVariantAbbrToFull(variantAbbr)].push(@preparedVariant)
  @jsonString = @taReq.to_json.to_s
end

And(/^remove template treatment arm variant field: "([^"]*)"$/) do |field|
  @preparedVariant.delete(field)
end

Then(/^cog changes treatment arm with id:"([^"]*)" and stratumID:"([^"]*)" status to: "([^"]*)"$/) do |treatmentArmID, stratumID, treatment_arm_status|
  response = COG_helper_methods.setTreatmentArmStatus(treatmentArmID, stratumID, treatment_arm_status)
  puts response
end

Then(/^api update status of treatment arm with id:"([^"]*)" from cog$/) do |treatmentArmID|
  queryTreatmentArm = {'treatment_arm_id' => treatmentArmID}
  url = ENV['treatment_arm_endpoint']+'/ecogTreatmentArmList'
  Helper_Methods.post_request(url, queryTreatmentArm.to_json)
end

Then(/^every id\-stratumID combination from \/treatmentArms should have "([^"]*)" result in \/basicTreatmentArms$/) do |count|
  taExtract = Array.new
  basicExtract = Array.new
  @response.each do |thisTA|
    thisExtract = "#{thisTA['name']}_#{thisTA['stratum_id']}"
    if !taExtract.include?(thisExtract)
      taExtract.append(thisExtract)
    end
  end
  @response.each do |thisBTA|
    thisExtract = "#{thisBTA['name']}_#{thisBTA['stratum_id']}"
    if !basicExtract.include?(thisExtract)
      basicExtract.append(thisExtract)
    end
  end
  basicExtract.uniq.sort.should == taExtract.uniq.sort
end

Then(/^every result from basic treatment arms should exist in regular call$/) do

  basic_TA_ids = []
  ta_ids = []


  basic_treatment_arms = JSON.parse(@all_basic_treatment_arms['message'])
  treatment_arms = JSON.parse(@all_treatment_arms['message'])

  expect(basic_treatment_arms.size).to eql treatment_arms.size

  basic_treatment_arms.each do |ta|
    basic_TA_ids << ta['id']
  end

  treatment_arms.each do |ta|
    ta_ids << ta['id']
  end
  expect(basic_TA_ids.sort).to eql(ta_ids.sort)
end

Given(/^response of treatment arm accrual command should match database$/) do
  url = "#{ENV['treatment_arm_endpoint']}/api/v1/treatment_arms/accrual"
  response = Helper_Methods.simple_get_request(url)['message_json']
  db_accrual = []
  Helper_Methods.dynamodb_table_items('assignment').each do |a|
    next if a['cog_assignment_date'].nil?
    ta = a['selected_treatment_arm']['treatment_arm_id']
    st = a['selected_treatment_arm']['stratum_id']
    selected = db_accrual.select do |t|
      t["treatment_arm_id"] == ta && t["stratum_id"] == st
    end
    if selected.size < 1
      new = {"treatment_arm_id" => ta, "stratum_id" => st, "patient_count" => 1}
      db_accrual << new
    else
      selected[0]['patient_count'] += 1
    end
  end
  expect(response.size).to eq db_accrual.size
  actual_hash = {}
  expect_hash = {}
  response.each {|h| actual_hash["#{h['treatment_arm_id']}_#{h['stratum_id']}"] = h['patient_count']}
  db_accrual.each {|h| expect_hash["#{h['treatment_arm_id']}_#{h['stratum_id']}"] = h['patient_count']}
  expect(actual_hash.keys.sort).to eq expect_hash.keys.sort
  actual_hash.keys.each do |key|
    expect = "#{key}: #{expect_hash[key]}"
    actual = "#{key}: #{actual_hash[key]}"
    expect(actual).to eq expect
  end

end

And(/^record treatment arm statistic numbers$/) do
  url = "#{ENV['treatment_arm_endpoint']}/api/v1/treatment_arms"
  response = Helper_Methods.simple_get_request(url)['message_json']
  @recorded_ta_statistics = {}
  response.each do |this_ta|
    ta_stratum = "#{this_ta['treatment_arm_id']}_#{this_ta['stratum_id']}"
    version = this_ta['version']
    @recorded_ta_statistics[ta_stratum] ||= {}
    @recorded_ta_statistics[ta_stratum][version] = {}
    @recorded_ta_statistics[ta_stratum][version]['version_statistics'] = this_ta['version_statistics']
    @recorded_ta_statistics[ta_stratum][version]['stratum_statistics'] = this_ta['stratum_statistics']
  end
end

Then(/^the statistic number changes for treatment arms should be described in this table$/) do |table|
  url = "#{ENV['treatment_arm_endpoint']}/api/v1/treatment_arms"
  response = Helper_Methods.simple_get_request(url)['message_json']
  new_ta_statistics = {}
  response.each do |this_ta|
    ta_stratum = "#{this_ta['treatment_arm_id']}_#{this_ta['stratum_id']}"
    version = this_ta['version']
    new_ta_statistics[ta_stratum] ||= {}
    new_ta_statistics[ta_stratum][version] = {}
    new_ta_statistics[ta_stratum][version]['version_statistics'] = this_ta['version_statistics']
    new_ta_statistics[ta_stratum][version]['stratum_statistics'] = this_ta['stratum_statistics']
  end

  new_expected_statistics = Marshal.load(Marshal.dump(@recorded_ta_statistics))
  table.hashes.each do |this_h|
    ta_stratum = "#{this_h['ta_id']}_#{this_h['stratum']}"
    next if this_h['ta_id'].empty?
    stratums = new_expected_statistics.select {|id, _| id == ta_stratum}
    expect(stratums.size).to be 1
    stratums[ta_stratum].each do |ver, statistics|
      value = statistics['stratum_statistics']['current_patients'].to_i
      statistics['stratum_statistics']['current_patients'] = value + this_h['current_patients'].to_i
      value = statistics['stratum_statistics']['former_patients'].to_i
      statistics['stratum_statistics']['former_patients'] = value + this_h['former_patients'].to_i
      value = statistics['stratum_statistics']['not_enrolled_patients'].to_i
      statistics['stratum_statistics']['not_enrolled_patients'] = value + this_h['not_enrolled_patients'].to_i
      value = statistics['stratum_statistics']['pending_patients'].to_i
      statistics['stratum_statistics']['pending_patients'] = value + this_h['pending_patients'].to_i
      if ver == this_h['version']
        value = statistics['version_statistics']['current_patients'].to_i
        statistics['version_statistics']['current_patients'] = value + this_h['current_patients'].to_i
        value = statistics['version_statistics']['former_patients'].to_i
        statistics['version_statistics']['former_patients'] = value + this_h['former_patients'].to_i
        value = statistics['version_statistics']['not_enrolled_patients'].to_i
        statistics['version_statistics']['not_enrolled_patients'] = value + this_h['not_enrolled_patients'].to_i
        value = statistics['version_statistics']['pending_patients'].to_i
        statistics['version_statistics']['pending_patients'] = value + this_h['pending_patients'].to_i
      end
    end
  end
  expect(new_ta_statistics.keys.sort).to eq new_expected_statistics.keys.sort
  new_ta_statistics.each do |id, v|
    puts id
    expect(v.keys.sort).to eq new_expected_statistics[id].keys.sort
    v.each {|version, statistics|
      puts version
      expect(statistics).to eq new_expected_statistics[id][version]
    }
  end
end

Then(/^there is no treatment arm statistic number change$/) do
  url = "#{ENV['treatment_arm_endpoint']}/api/v1/treatment_arms"
  response = Helper_Methods.simple_get_request(url)['message_json']
  new_ta_statistics = {}
  response.each do |this_ta|
    ta_stratum = "#{this_ta['treatment_arm_id']}_#{this_ta['stratum_id']}"
    version = this_ta['version']
    new_ta_statistics[ta_stratum] ||= {}
    new_ta_statistics[ta_stratum][version] = {}
    new_ta_statistics[ta_stratum][version]['version_statistics'] = this_ta['version_statistics']
    new_ta_statistics[ta_stratum][version]['stratum_statistics'] = this_ta['stratum_statistics']
  end

  expect(new_ta_statistics).to eq @recorded_ta_statistics
end

def nil_if_null(value)
  value == 'null' ? nil : value
end

def loadTemplateJson()
  unless @isTemplateJsonLoaded
    @taReq = Treatment_arm_helper.valid_request_json()
    @isTemplateJsonLoaded = true
  end
end

def findSingleTreatmentArm(id, stratum)
  @response = Helper_Methods.get_single_request("#{ENV['treatment_arm_endpoint']}/api/v1/treatment_arms/#{id}/#{stratum}")
  @response.should_not == nil

  @response
end

def find_single_treatment_arm(id, stratum, version)
  Helper_Methods.get_request("#{ENV['treatment_arm_endpoint']}/api/v1/treatment_arms/#{id}/#{stratum}/#{version}")
end

def find_treatment_arm_all_versions(id, stratum_id)
  data = Helper_Methods.get_request("#{ENV['treatment_arm_endpoint']}/api/v1/treatment_arms", params={id: id, stratum_id: stratum_id})
  @response = JSON.parse(data)
  expect(@response['message'].size).to be_greater_than(0)
end

def find_all_basic_treatment_arms
  Helper_Methods.get_request("#{ENV['treatment_arm_endpoint']}/api/v1/treatment_arms?projection[]=treatment_arm_id")
end

def find_treatment_arm_basic(id, stratum, version = nil)
  Helper_Methods.get_request("#{ENV['treatment_arm_endpoint']}/api/v1/treatment_arms/#{id}/#{stratum}/#{version}?basic=true&active=true")
end

def find_all_versions (id, stratum)
  # @response = Helper_Methods.get_request("#{ENV['treatment_arm_endpoint']}/api/v1/treatment_arms/#{id}/#{stratum}")
  cnt = 5
  counter = 0
  while counter <= cnt
    sleep(3)
    @response = Helper_Methods.get_request("#{ENV['treatment_arm_endpoint']}/api/v1/treatment_arms/#{id}/#{stratum}")
    # if response['message'].match(/(read_attribute_for_serialization|\+)/)

    if JSON.parse(@response['message']).size == 0
      sleep(1)
    else
      break
    end
    counter += 1
  end
end

#returns a hash with the variant type and the field missing in the variant
def extract_cause_from_message(message)
  abbr = {
      snv: 'snv_indels',
      id: 'indels',
      cnv: 'copy_number_variants',
      gf: 'gene_fusions',
      nhr: 'non_hotspot_rules'
  }
  variant_regex = Regexp.new(abbr.values.join('|'))
  reason_regex = Regexp.new("did not contain a required property of '(.+?)'")
  variant_type = message.match(variant_regex).to_s
  reason = message.match(reason_regex)
  {variant: variant_type, missing_field: reason[1]}
end

def find_all_treatment_arms
  @response = Helper_Methods.get_request("#{ENV['treatment_arm_endpoint']}/api/v1/treatment_arms")
  @response
end


def findAllTAsByID(id)
  @response = Helper_Methods.get_list_request("#{ENV['treatment_arm_endpoint']}/api/v1/treatment_arms", params={"treatment_arm_id" => id})
  @response.should_not == nil
  returnedTASize = "Returned treatment arm count is #{@response.length}"
  returnedTASize.should_not == 'Returned treatment arm count is 0'

  @response
end

def findAllBasicTreatmentArms()
  @response = Helper_Methods.get_list_request(ENV['treatment_arm_endpoint']+'/api/v1/treatment_arms?active=true&basic=true', params={})
  @response
end

def findAllBasicTreatmentArmsForID(id)
  # sleep(5.0)
  # @response = Helper_Methods.get_request(ENV['treatment_arm_endpoint']+'/basicTreatmentArms',params={})
  @response = Helper_Methods.get_list_request("#{ENV['treatment_arm_endpoint']}/api/v1/treatment_arms", params={})
  allTAs = Treatment_arm_helper.findTreatmentArmsFromResponseUsingID(@response, id)
  allTAs
end

def findSpecificBasicTreatmentArms(id)
  # sleep(5.0)
  # @response = Helper_Methods.get_request(ENV['treatment_arm_endpoint']+'/basicTreatmentArms',params={"id"=>id})
  @response = Helper_Methods.get_list_request("#{ENV['treatment_arm_endpoint']}/api/v1/treatment_arms", params={"treatment_arm_id" => id})
  @response.should_not == nil
  @response
end

def convertVariantAbbrToFull(variantAbbr)
  abbr = {
      snv: 'snv_indels',
      id: 'snv_indels',
      cnv: 'copy_number_variants',
      gf: 'gene_fusions',
      nhr: 'non_hotspot_rules'
  }
  abbr[variantAbbr.to_sym]
end

# pings the api "cnt" times. If it is successful in getting a treatment arm within that count it returns a true.
# if we do not get a 200 or get any other error after "cnt" times it will return a false.
def wait_for_processor(cnt = 5, retry_in = 1)
  counter = 0
  while counter <= cnt
    response = Helper_Methods.get_request("#{ENV['treatment_arm_endpoint']}/api/v1/treatment_arms/#{@ta_id}/#{@stratum_id}/#{@version}", {'no_log' => true})
    # if response['message'].match(/(read_attribute_for_serialization|\+)/)
    if response['http_code'] != 200
      sleep(retry_in)
    else
      return true if response['http_code'] == 200
    end
    counter += 1
  end
  p "Wait for processor ended with http_code: #{response['http_code']}"
  return false
end
