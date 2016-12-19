#!/usr/bin/ruby
require 'rspec'
require 'json'
require_relative '../../../support/helper_methods.rb'
require_relative '../../../support/patient_helper_methods.rb'
require_relative '../../../support/cog_helper_methods.rb'

#########################################################
################   service calls   ######################
#########################################################
When(/^POST to MATCH patients service, response includes "([^"]*)" with code "([^"]*)"$/) do |retMsg, code|
  response = Patient_helper_methods.post_to_trigger
  puts response.to_json
  actual_match_expect(response['http_code'], code)
  # actual_include_expect(response['message'], retMsg)
end

When(/^PUT to MATCH variant report confirm service, response includes "([^"]*)" with code "([^"]*)"$/) do |retMsg, code|
  response = Patient_helper_methods.put_vr_confirm(@analysis_id, @variant_report_status)
  actual_match_expect(response['http_code'], code)
  # actual_include_expect(response['message'], retMsg)
end

When(/^PUT to MATCH variant confirm service, response includes "([^"]*)" with code "([^"]*)"$/) do |retMsg, code|
  response = Patient_helper_methods.put_variant_confirm(@current_variant_uuid, @current_variant_confirm)
  actual_match_expect(response['http_code'], code)
  # actual_include_expect(response['message'], retMsg)
end

When(/^PUT to MATCH assignment report confirm service, response includes "([^"]*)" with code "([^"]*)"$/) do |retMsg, code|
  response = Patient_helper_methods.put_ar_confirm(@analysis_id, @assignment_report_status)
  actual_match_expect(response['http_code'], code)
  # actual_include_expect(response['message'], retMsg)
end

When(/^GET from MATCH patient API, http code "([^"]*)" should return$/) do |code|
  url = prepare_get_url
  puts url
  response = Patient_helper_methods.get_response_and_code(url)
  actual_match_expect(response['http_code'], code)
  @get_response = response['message_json']
end


#########################################################
###############  prepare GET message  ###################
#########################################################

Given(/^patient GET service name "([^"]*)"$/) do |service|
  @get_service_name = service
end

Given(/^patient GET service name "([^"]*)" for patient "([^"]*)"$/) do |service, patient_id|
  @get_service_name = "#{patient_id}/#{service}"
end

Then(/^add projection: "([^"]*)" to patient GET url$/) do |projection|
  @get_service_projections = [] if @get_service_projections.nil?
  @get_service_projections << projection
end

Then(/^add parameter field: "([^"]*)" and value: "([^"]*)" to patient GET url$/) do |field, value|
  @get_service_parameters = {} if @get_service_parameters.nil?
  @get_service_parameters[field]=value
end

Then(/^set id: "([^"]*)" for patient GET url$/) do |id|
  @get_service_id = id
end

def prepare_get_url
  url = ENV['patients_endpoint']
  unless @patient_id.nil? || @patient_id.length<1
    url += "/#{@patient_id}"
  end
  unless @get_service_name.nil? || @get_service_name.length<1
    url += "/#{@get_service_name}"
  end
  unless @get_service_id.nil? || @get_service_id.length<1
    url += "/#{@get_service_id}"
  end
  get_service_queries = ''
  unless @get_service_projections.nil?
    get_service_queries = "&projections=[#{@get_service_projections.join(',')}]"
  end
  unless @get_service_parameters.nil?
    get_service_queries += "&#{@get_service_parameters.map { |k, v| "#{k}=#{v}" }.join('&')}"
  end
  url += get_service_queries.sub('&', '?') #.sub method only replace the first occurrence
end

#########################################################
############  prepare POST PUT message  #################
#########################################################
Given(/^patient id is "([^"]*)"$/) do |patient_id|
  @patient_id = patient_id=='null' ? nil : patient_id
end

Given(/^template registration message for this patient on date: "([^"]*)"$/) do |date|
  converted_date = date=='null' ? nil : date
  converted_date = Helper_Methods.getDateAsRequired(converted_date)
  Patient_helper_methods.prepare_register(@patient_id, converted_date)
end

Given(/^template specimen received message for this patient \(type: "([^"]*)", surgical_event_id: "([^"]*)"\)$/) do |type, sei|
  converted_sei = sei=='null' ? nil : sei
  Patient_helper_methods.prepare_specimen_received(@patient_id, type, converted_sei)
end

Given(/^template specimen shipped message for this patient \(type: "([^"]*)", surgical_event_id: "([^"]*)", molecular_id or slide_barcode: "([^"]*)"\)/) do |type, sei, moi_or_barcode|
  converted_sei = sei=='null' ? nil : sei
  converted_id = moi_or_barcode=='null' ? nil : moi_or_barcode
  Patient_helper_methods.prepare_specimen_shipped(@patient_id, type, converted_sei, converted_id)
end

Given(/^template assay message with surgical_event_id: "([^"]*)" for patient: "([^"]*)"$/) do |sei, patientID|
  @patient_id = patientID=='null' ? nil : patientID
  converted_sei = sei=='null' ? nil : sei
  Patient_helper_methods.prepare_assay(@patient_id, converted_sei)
end

Given(/^template variant file uploaded message for this patient \(molecular_id: "([^"]*)", analysis_id: "([^"]*)"\) and need files in S3 Y or N: "([^"]*)"$/) do |moi, ani, upload|
  converted_moi = moi=='null' ? nil : moi
  @analysis_id = ani=='null' ? nil : ani
  need_file = upload == 'Y'
  Patient_helper_methods.prepare_vr_upload(@patient_id, converted_moi, @analysis_id, need_file, 'bdd_test_ion_reporter')
end

Given(/^template variant confirm message for this patient \(uuid: "([^"]*)", status: "([^"]*)", comment: "([^"]*)"\)$/) do |variant_uuid, confirmed, comment|
  @current_variant_uuid = variant_uuid
  @current_variant_confirm = confirmed
  converted_comment = comment=='null' ? nil : comment
  Patient_helper_methods.prepare_variant_confirm(converted_comment)
end

Then(/^create variant confirm message with checked: "([^"]*)" and comment: "([^"]*)" for this variant$/) do |confirmed, comment|
  @current_variant_confirm = confirmed
  converted_comment = comment=='null' ? nil : comment
  Patient_helper_methods.prepare_variant_confirm(converted_comment)
end

Given(/^template variant report confirm message for this patient \(analysis_id: "([^"]*)", status: "([^"]*)"\)$/) do |ani, status|
  @analysis_id = ani=='null' ? nil : ani
  @variant_report_status = status
  Patient_helper_methods.prepare_vr_confirm(@patient_id)
end

Given(/^template assignment report confirm message for this patient \(analysis_id: "([^"]*)" and status: "([^"]*)"\)$/) do |ani, status|
  @analysis_id = ani=='null' ? nil : ani
  @assignment_report_status = status=='null' ? nil : status
  Patient_helper_methods.prepare_assignment_confirm(@patient_id)
end

Given(/^template on treatment arm message for this patient \(treatment arm id: "([^"]*)", stratum id: "([^"]*)", step number: "([^"]*)"\)$/) do |ta_id, stratum, step_number|
  converted_ta_id = ta_id=='null' ? nil : ta_id
  converted_stratum = stratum=='null' ? nil : stratum
  converted_step_number = step_number=='null' ? nil : step_number
  Patient_helper_methods.prepare_on_treatment_arm(@patient_id, converted_ta_id, converted_stratum, converted_step_number)
end

Given(/^template request assignment message for this patient \(rebiopsy: "([^"]*)", step number: "([^"]*)"\)$/) do |re_biopsy, step_number|
  converted_rebiopsy = re_biopsy=='null' ? nil : re_biopsy
  converted_step_number = step_number=='null' ? nil : step_number
  Patient_helper_methods.prepare_request_assignment(@patient_id, converted_rebiopsy, converted_step_number)
end

Given(/^template request no assignment message for this patient with step number: "([^"]*)"$/) do |step_number|
  converted_step_number = step_number=='null' ? nil : step_number
  Patient_helper_methods.prepare_request_no_assignment(@patient_id, converted_step_number)
end

Given(/^template off study biopsy expired message for this patient \(step number: "([^"]*)"\)$/) do |step_number|
  converted_step_number = step_number=='null' ? nil : step_number
  Patient_helper_methods.prepare_off_study_biopsy_expired(@patient_id, converted_step_number)
end

Given(/^template off study message for this patient \(step number: "([^"]*)"\)$/) do |step_number|
  converted_step_number = step_number=='null' ? nil : step_number
  Patient_helper_methods.prepare_off_study(@patient_id, converted_step_number)
end

Then(/^set patient message field: "([^"]*)" to value: "([^"]*)"$/) do |field, value|
  unless value == 'skip_this_value'
    if value == 'null'
      converted_value = nil
    elsif value.eql?('current') || value.eql?('today')
      converted_value = Helper_Methods.getDateAsRequired(value)
    else
      converted_value = value
    end
    Patient_helper_methods.update_patient_message(field, converted_value)
  end
end

Then(/^remove field: "([^"]*)" from patient message$/) do |field|
  Patient_helper_methods.remove_field_patient_message(field)
end


#########################################################
################  wait for update  ######################
#########################################################
Then(/^patient status should change to "([^"]*)"$/) do |status|
  field = 'current_status'
  @current_patient_hash = Patient_helper_methods.wait_until_patient_field_is(@patient_id, field, status)
  actual_match_expect(@current_patient_hash[field], status)
end

Then(/^wait until patient specimen is updated$/) do
  Patient_helper_methods.wait_until_specimen_updated(@patient_id)
end

Then(/^wait until patient variant report is updated$/) do
  Patient_helper_methods.wait_until_vr_updated(@patient_id)
end

Then(/^wait until patient variant is updated$/) do
  Patient_helper_methods.wait_until_variant_updated(@patient_id)
end

Then(/^wait until patient has (\d+) assignment reports$/) do |ar_count|

end
Then(/^patient should have assignment report \(TA id: "([^"]*)", stratum id: "([^"]*)"\) with status "([^"]*)"$/) do |arg1, arg2, arg3|
  pending # Write code here that turns the phrase above into concrete actions
end
Then(/^patient should have assignment report \(report status: "([^"]*)"\) with status "([^"]*)"$/) do |arg1, arg2|
  pending # Write code here that turns the phrase above into concrete actions
end


#########################################################
###############  result validation  #####################
#########################################################
Then(/^patient field: "([^"]*)" should have value: "([^"]*)"$/) do |field, value|
  get_patient_if_needed
  converted_value = value=='null' ? nil : value
  actual_match_expect(@current_patient_hash[field], converted_value)
end

Then(/^patient should have selected treatment arm: "([^"]*)" with stratum id: "([^"]*)"$/) do |ta_id, stratum|
  get_patient_if_needed
  current_assignment = 'current_assignment'
  expect(@current_patient_hash.keys).to include current_assignment
  actual_match_expect(@current_patient_hash[current_assignment]['treatment_arm_id'], ta_id)
  actual_match_expect(@current_patient_hash[current_assignment]['stratum_id'], stratum)
end

Then(/^patient should have (\d+) blood specimens$/) do |count|
  url = "#{ENV['patients_endpoint']}/#{@patient_id}/specimens?specimen_type=BLOOD"
  @current_specimen = Patient_helper_methods.get_any_result_from_url(url)
  actual_match_expect(@current_specimen.length, count.to_i)
end

Then(/^patient should have specimen \(field: "([^"]*)" is "([^"]*)"\)$/) do |field, value|
  url = "#{ENV['patients_endpoint']}/#{@patient_id}/specimens?#{field}=#{value}"
  @current_specimen = Patient_helper_methods.get_any_result_from_url(url)
  if @current_specimen.is_a?(Array)
    if @current_specimen.length==1
      @current_specimen = @current_specimen[0]
    else
      raise "Expect 1 specimen returned, actually #{@current_specimen.length} returned"
    end
  else
    raise "Expect array returned, actually #{@current_specimen.class.to_s} returned"
  end
  actual_match_expect(@current_specimen[field], value)
end


And(/^this specimen has assay \(biomarker: "([^"]*)", result: "([^"]*)", reported_date: "([^"]*)"\)$/) do |biomarker, result, reported_date|
  converted_biomarker = biomarker=='null' ? nil : biomarker
  converted_result = result=='null' ? nil : result
  converted_reported_date = reported_date=='null' ? nil : reported_date
  returned_assay = find_assay(@current_specimen, converted_biomarker, converted_result, converted_reported_date)
  expect_result = "Can find assay with biomarker:#{biomarker}, result:#{result} and report_date:#{reported_date}"
  actual_result = "Can NOT find assay with biomarker:#{biomarker}, result:#{result} and report_date:#{reported_date}"
  unless returned_assay.nil?
    actual_result = expect_result
  end
  actual_result.should == expect_result
end

And(/^this specimen has pathology status: "([^"]*)"$/) do |pathology_status|
  converted_patho_status = pathology_status=='null' ? nil : pathology_status
  actual_match_expect(@current_specimen['pathology_status'], converted_patho_status)
end

And(/^this specimen should have a correct failed_date$/) do
  unless @current_specimen.keys.include?('failed_date')
    raise "specimen #{@current_specimen['surgical_event_id']} does not have field <failed_date>"
  end
  current_time = Time.now.utc.to_i
  returned_result = DateTime.parse(@current_specimen['failed_date']).to_i
  time_diff = current_time - returned_result
  actual_include_expect((0..300), time_diff)
end

And(/^patient active tissue specimen field "([^"]*)" should be "([^"]*)"$/) do |field, value|
  get_patient_if_needed
  converted_value = value=='null' ? nil : value
  ats = 'active_tissue_specimen'
  expect(@current_patient_hash.keys).to include ats
  expect(@current_patient_hash[ats][field]).to eq converted_value
end

And(/^this specimen field: "([^"]*)" should be: "([^"]*)"$/) do |field, value|
  converted_value = value=='null' ? nil : value
  actual_match_expect(@current_specimen[field], converted_value)
end

And(/^this specimen should not have field: "([^"]*)"$/) do |field|
  # expect_result = "specimen #{@current_specimen['surgical_event_id']} does not have field <#{field}>"
  # if @current_specimen.keys.include?(field)
  #   actual_result = "specimen #{@current_specimen['surgical_event_id']} has field <#{field}>"
  # else
  #   actual_result = expect_result
  # end
  # actual_result.should == expect_result
  expect(@current_specimen.keys).not_to include field
end

# # And(/^this specimen has assay: "([^"]*)" in field: "([^"]*)"$/) do |value, field|
# #   convert_value = value=='null'?nil:value
# #   @current_specimen[field].should == convert_value
# # end

#
# Then(/^returned patient's blood specimen has value: "([^"]*)" in field: "([^"]*)"$/) do |value, field|
#   convert_value = value=='null'?nil:value
#   blood_specimen = find_specimen(@retrieved_patient, nil)
#   blood_specimen[field].should == convert_value
# end
#
Then(/^patient should have variant report \(analysis_id: "([^"]*)"\)$/) do |ani|
  url = "#{ENV['patients_endpoint']}/variant_reports?analysis_id=#{ani}"
  @current_variant_report = Patient_helper_methods.get_any_result_from_url(url)
  if @current_variant_report.is_a?(Array)
    if @current_variant_report.length==1
      @current_variant_report = @current_variant_report[0]
    else
      raise "Expect 1 variant report returned, actually #{@current_variant_report.length} returned"
    end
  else
    raise "Expect array returned, actually #{@current_variant_report.class.to_s} returned"
  end
  actual_match_expect(@current_variant_report['analysis_id'], ani)
end

And(/^this variant report field: "([^"]*)" should be "([^"]*)"$/) do |field, value|
  actual_include_expect(@current_variant_report.keys, field)
  convert_value = value=='null' ? nil : value
  returned_value = @current_variant_report[field]
  if returned_value.nil? || convert_value.nil?
    actual_match_expect(returned_value, convert_value)
  else
    actual_match_expect(convert_value.to_s.downcase, returned_value.to_s.downcase)
  end
  # expect_result = "Value of field #{field} contains #{convert_value}"
  # real_result = "Value of field #{field} is #{@current_variant_report[field]}"
  # equal = returned_value == convert_value
  # unless equal
  #   if returned_value.nil? || convert_value.nil?
  #     equal = false
  #   else
  #     equal = returned_value.downcase.include?(convert_value.downcase)
  #   end
  # end
  # if equal
  #   real_result = expect_result
  # end
  # real_result.should == expect_result
end

And(/^this variant report has correct status_date$/) do
  current_time = Time.now.utc.to_i
  returned_result = DateTime.parse(@current_variant_report['status_date']).to_i
  time_diff = current_time - returned_result
  actual_include_expect((0..20), time_diff)
end
#
# Then(/^returned patient has been assigned to new treatment arm: "([^"]*)", stratum id: "([^"]*)"$/) do |ta_id, stratum|
#   ta_id.should == 'pending'
# end
#
Given(/^a random "([^"]*)" variant in variant report \(analysis_id: "([^"]*)"\) for this patient$/) do |variant_type, ani|
  url = "#{ENV['patients_endpoint']}/variants?analysis_id=#{ani}&variant_type=#{variant_type}"
  this_variant = Patient_helper_methods.get_any_result_from_url(url)
  if this_variant.is_a?(Array)
    this_variant = this_variant[0]
  end
  @current_variant_uuid = this_variant['uuid']
end

Then(/^this variant should have confirmed field: "([^"]*)" and comment field: "([^"]*)"$/) do |confirmed, comment|
  converted_comment = comment=='null' ? nil : comment
  url = "#{ENV['patients_endpoint']}/variants?uuid=#{@current_variant_uuid}"
  this_variant = Patient_helper_methods.get_any_result_from_url(url)
  if this_variant.is_a?(Array)
    if this_variant.length==1
      this_variant = this_variant[0]
    else
      raise "Expect 1 variant returned, actually #{this_variant.length} returned"
    end
  else
    raise "Expect array returned, actually #{this_variant.class.to_s} returned"
  end
  actual_match_expect(this_variant['confirmed'].to_s, confirmed)
  actual_match_expect(this_variant['comment'], converted_comment)
end

Then(/^variants in variant report \(analysis_id: "([^"]*)"\) have confirmed: "([^"]*)"$/) do |ani, confirmed|
  url = "#{ENV['patients_endpoint']}/variants?analysis_id=#{ani}"
  variants = Patient_helper_methods.get_any_result_from_url(url)
  unless variants.is_a?(Array)
    raise "Expect array returned, actually #{variants.class.to_s} returned"
  end
  variants.each { |this_variant|
    actual_match_expect(this_variant['confirmed'].to_s, confirmed)
  }
end
#
# Then(/^variants in variant report \(analysis_id: "([^"]*)"\) have confirmed: "([^"]*)"$/) do |ani, confirmed|
#   variant_report = find_variant_report(@retrieved_patient, ani)
#
#   variants = variant_report['variants']
#   variants.each {|key, value|
#     value.each{|variant|
#       expect_result = "variant uuid: #{variant['uuid']}, confirmed = #{confirmed}"
#       actual_result = "variant uuid: #{variant['uuid']}, confirmed = #{variant['confirmed']}"
#       actual_result.should == expect_result
#     }
#   }
# end

And(/^analysis_id "([^"]*)" should have (\d+) PENDING (\d+) REJECTED (\d+) CONFIRMED assignment reports$/) do |ani, pending, rejected, confirmed|
  url = "#{ENV['patients_endpoint']}/assignments?analysis_id=#{ani}"
  assignments = Patient_helper_methods.get_any_result_from_url(url)
  expect_pending = "There are #{pending} PENDING assignment reports"
  expect_rejected = "There are #{rejected} REJECTED assignment reports"
  expect_confirmed = "There are #{confirmed} CONFIRMED assignment reports"
  actual_pending = 0
  actual_rejected = 0
  actual_confirmed = 0
  if assignments.is_a?(Array)
    assignments.each { |this_assignment|
      case this_assignment['status']
        when 'PENDING'
          actual_pending += 1
        when 'REJECTED'
          actual_rejected += 1
        when 'CONFIRMED'
          actual_confirmed += 1
        else
          raise "Assignment report expect PENDING, CONFIRMED, REJECTED, actually got #{this_assignment['status']}"
      end
    }
    actual_pending = "There are #{actual_pending} PENDING assignment reports"
    actual_rejected = "There are #{actual_rejected} REJECTED assignment reports"
    actual_confirmed = "There are #{actual_confirmed} CONFIRMED assignment reports"
  else
    raise "Expect array returned, actually #{assignments.class.to_s} returned"
  end
  actual_match_expect(actual_pending, expect_pending)
  actual_match_expect(actual_rejected, expect_rejected)
  actual_match_expect(actual_confirmed, expect_confirmed)
end

And(/^patient pending assignment report selected treatment arm is "([^"]*)" with stratum_id "([^"]*)"$/) do |ta_id, stratum|
  url = "#{ENV['patients_endpoint']}/assignments?patient_id=#{@patient_id}&status=PENDING"
  @current_assignment = Patient_helper_methods.get_any_result_from_url(url)
  if @current_assignment.is_a?(Array)
    if @current_assignment.length==1
      assignment = @current_assignment[0]
      selected_ta = 'selected_treatment_arm'
      expect(assignment.keys).to include selected_ta
      actual_match_expect(assignment[selected_ta]['treatment_arm_id'], ta_id)
      actual_match_expect(assignment[selected_ta]['stratum_id'], stratum)
    else
      raise "Expect 1 assignment report returned, actually #{@current_assignment.length} returned"
    end
  else
    raise "Expect array returned, actually #{@current_assignment.class.to_s} returned"
  end
end

And(/^patient pending assignment report field "([^"]*)" should be "([^"]*)"$/) do |field, status|
  url = "#{ENV['patients_endpoint']}/assignments?patient_id=#{@patient_id}&status=PENDING"
  @current_assignment = Patient_helper_methods.get_any_result_from_url(url)
  if @current_assignment.is_a?(Array)
    if @current_assignment.length==1
      actual_include_expect(@current_assignment[0].keys, field)
      actual_match_expect(@current_assignment[0][field], status)
    else
      raise "Expect 1 assignment report returned, actually #{@current_assignment.length} returned"
    end
  else
    raise "Expect array returned, actually #{@current_assignment.class.to_s} returned"
  end
end

Given(/^this patient is in mock service lost patient list, service will come back after "([^"]*)" tries$/) do |error_times|
  COG_helper_methods.setServiceLostPatient(@patient_id, error_times)
end

Then(/^COG received assignment status: "([^"]*)" for this patient$/) do |assignment_status|
  converted_status = assignment_status=='null' ? nil : assignment_status
  response = COG_helper_methods.get_patient_assignment_status(@patient_id)

  if response['message_json']['status'].nil?
    raise response.to_json.to_s
  else
    actual_match_expect(response['message_json']['status'], converted_status)
  end
end

Then(/^COG received assignment with treatment_arm_id: "([^"]*)" and stratum_id: "([^"]*)" for this patient$/) do |ta_id, stratum|
  converted_ta_id = ta_id=='null' ? nil : ta_id
  converted_stratum = stratum=='null' ? nil : stratum
  response = COG_helper_methods.get_patient_assignment_status(@patient_id)

  if response['message_json']['treatment_arm_id'].nil?
    raise response.to_json.to_s
  else
    actual_match_expect(response['message_json']['treatment_arm_id'], converted_ta_id)
  end
  if response['message_json']['stratum_id'].nil?
    raise response.to_json.to_s
  else
    actual_match_expect(response['message_json']['stratum_id'], converted_stratum)
  end
end

Then(/^the response message should be empty$/) do
  expect(@get_response.class.to_s).to eql type
end

Then(/^the response type should be "([^"]*)"$/) do |type|
  expect(@get_response.class.to_s).to eql type
end

And(/^the count of array elements should match database table "([^"]*)"$/) do |table|
  if @get_service_parameters.nil?
    query = {}
  else
    query = @get_service_parameters
  end
  unless @patient_id.nil? || @patient_id.length<1 || query.keys.include?('patient_id')
    query['patient_id'] = @patient_id
  end
  if table.length>1
    expect(@get_response.length).to eql Helper_Methods.dynamodb_table_items(table, query).length
  end
end

And(/^each element of response should have field "([^"]*)"$/) do |field|
  raise 'GET response is empty' if @get_response.length<1
  @get_response.each { |this_element|
    expect(this_element.keys).to include field
  }
end

And(/^each element of response should have field "([^"]*)" with value "([^"]*)"$/) do |field, value|
  raise 'GET response is empty' if @get_response.length<1
  @get_response.each { |this_element|
    expect(this_element.keys).to include field
    expect(this_element[field]).to eql value
  }
end

And(/^each element of response should have (\d+) fields$/) do |field_count|
  raise 'GET response is empty' if @get_response.length<1
  @get_response.each { |this_element|
    expect(this_element.length).to eql field_count.to_i
  }
end

And(/^hash response should have field "([^"]*)" with value "([^"]*)"$/) do |field, value|
  expect(@get_response[field]).to eql value
end

def actual_match_expect(actual, expect)
  expect(actual).to eq expect
end

def actual_include_expect(actual, expect)
  expect(actual).to include expect
end

def convert_string_to_bool(string)
  case string
    when 'true' then
      true
    when 'false' then
      false
    when 'null' then
      nil
  end
end

def get_patient_if_needed
  if @current_patient_hash.nil?
    url = "#{ENV['patients_endpoint']}/#{@patient_id}"
    @current_patient_hash = Patient_helper_methods.get_any_result_from_url(url)
  end
end

def find_specimen(patient_json, sei)
  specimens = patient_json['specimens']
  specimens.each do |this_specimen|
    if this_specimen['surgical_event_id'] == sei
      return this_specimen
    end
  end
  nil
end

def find_assay(specimen_json, biomarker, result, date)
  assays = specimen_json['assays']
  assays.each do |this_assay|
    is_this = true
    unless this_assay['biomarker']==biomarker
      is_this = false
    end
    unless this_assay['result']==result
      is_this = false
    end
    unless this_assay['result_date']==date
      is_this = false
    end
    if is_this
      return this_assay
    end
  end
  nil
end

def find_variant_report (patient_json, ani)
  variant_reports = patient_json['variant_reports']
  variant_reports.each do |thisVariantReport|
    if thisVariantReport['analysis_id'] == ani
      return thisVariantReport
    end
  end
  nil
end

def find_variant (patient_json, variant_uuid)
  variant_reports = patient_json['variant_reports']
  variant_reports.each do |thisVariantReport|
    variants = thisVariantReport['variants']
    variants.each { |key, value|
      value.each { |variant|
        if variant['uuid']==variant_uuid
          return variant
        end
      }
    }
  end
  nil
end

