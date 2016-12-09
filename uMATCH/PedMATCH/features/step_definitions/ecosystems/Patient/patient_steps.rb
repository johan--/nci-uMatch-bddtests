#!/usr/bin/ruby
require 'rspec'
require 'json'
require_relative '../../../support/helper_methods.rb'
require_relative '../../../support/patient_helper_methods.rb'
require_relative '../../../support/cog_helper_methods.rb'


#post
When(/^POST to MATCH patients service, response includes "([^"]*)" with code "([^"]*)"$/) do |retMsg, code|
  response = Patient_helper_methods.post_to_trigger
  first_match_second(response['http_code'], code)
  first_include_second(response['message'], retMsg)
end

When(/^put to MATCH variant report confirm service, returns a message that includes "([^"]*)" with status "([^"]*)"$/) do |retMsg, code|
  Patient_helper_methods.put_vr_confirm(@analysis_id, @variant_report_status)
  first_match_second(response['http_code'], code)
  first_include_second(response['message'], retMsg)
end

When(/^put to MATCH variant confirm service, returns a message that includes "([^"]*)" with status "([^"]*)"$/) do |retMsg, code|
  Patient_helper_methods.put_variant_confirm(@current_variant_uuid, @current_variant_confirm)
  first_match_second(response['http_code'], code)
  first_include_second(response['message'], retMsg)
end

When(/^put to MATCH assignment report confirm service, returns a message that includes "([^"]*)" with status "([^"]*)"$/) do |retMsg, code|
  Patient_helper_methods.put_ar_confirm(@analysis_id, @assignment_report_status)
  first_match_second(response['http_code'], code)
  first_include_second(response['message'], retMsg)
end

#messages
Given(/^template patient registration message for patient: "([^"]*)" on date: "([^"]*)"$/) do |patient_id, date|
  @patient_id = patient_id=='null' ? nil : patient_id
  converted_date = date=='null' ? nil : date
  converted_date = Helper_Methods.getDateAsRequired(converted_date)
  Patient_helper_methods.prepare_register(@patient_id, converted_date)
end

Given(/^template specimen received message in type: "([^"]*)" for patient: "([^"]*)", it has surgical_event_id: "([^"]*)"$/) do |type, patientID, sei|
  @patient_id = patientID=='null' ? nil : patientID
  converted_sei = sei=='null' ? nil : sei
  Patient_helper_methods.prepare_specimen_received(@patient_id, type, converted_sei)
end

Given(/^template specimen shipped message in type: "([^"]*)" for patient: "([^"]*)", it has surgical_event_id: "([^"]*)", molecular_id or slide_barcode: "([^"]*)"/) do |type, patientID, sei, moi_or_barcode|
  @patient_id = patientID=='null' ? nil : patientID
  converted_sei = sei=='null' ? nil : sei
  converted_id = moi_or_barcode=='null' ? nil : moi_or_barcode
  Patient_helper_methods.prepare_specimen_shipped(@patient_id, type, converted_sei, converted_id)
end

Given(/^template assay message with surgical_event_id: "([^"]*)" for patient: "([^"]*)"$/) do |sei, patientID|
  @patient_id = patientID=='null' ? nil : patientID
  converted_sei = sei=='null' ? nil : sei
  Patient_helper_methods.prepare_assay(@patient_id, converted_sei)
end

Given(/^template pathology report with surgical_event_id: "([^"]*)" for patient: "([^"]*)"$/) do |sei, patientID|
  @patient_id = patientID=='null' ? nil : patientID
  converted_sei = sei=='null' ? nil : sei
  Patient_helper_methods.prepare_pathology(@patient_id, converted_sei)
end

Given(/^template variant file uploaded message for patient: "([^"]*)", it has molecular_id: "([^"]*)" and analysis_id: "([^"]*)" and need files in S3 Y or N: "([^"]*)"$/) do |patientID, moi, ani, upload|
  @patient_id = patientID=='null' ? nil : patientID
  converted_moi = moi=='null' ? nil : moi
  @analysis_id = ani=='null' ? nil : ani
  need_file = upload == 'Y'
  Patient_helper_methods.prepare_vr_upload(@patient_id, converted_moi, @analysis_id, need_file, 'bdd_test_ion_reporter')
end

Given(/^template variant confirm message for patient: "([^"]*)", the variant: "([^"]*)" is checked: "([^"]*)" with comment: "([^"]*)"$/) do |patient_id, variant_uuid, confirmed, comment|
  variant_confirm_message(variant_uuid, confirmed, comment)
end

Then(/^create variant confirm message with checked: "([^"]*)" and comment: "([^"]*)" for this variant$/) do |confirmed, comment|
  variant_confirm_message(@current_variant_uuid, confirmed, comment)
end

Given(/^template variant report confirm message for patient: "([^"]*)", it has analysis_id: "([^"]*)" and status: "([^"]*)"$/) do |patient_id, ani, status|
  @patient_id = patient_id=='null' ? nil : patient_id
  @analysis_id = ani=='null' ? nil : ani
  @variant_report_status = status
  Patient_helper_methods.prepare_vr_confirm(@patient_id)
end

Given(/^template assignment report confirm message for patient: "([^"]*)", it has analysis_id: "([^"]*)" and status: "([^"]*)"$/) do |patient_id, ani, status|
  @patient_id = patient_id=='null' ? nil : patient_id
  @analysis_id = ani=='null' ? nil : ani
  @assignment_report_status = status=='null' ? nil : status
  Patient_helper_methods.prepare_assignment_confirm(@patient_id)
end

Given(/^template on treatment arm message for patient: "([^"]*)" with treatment arm id: "([^"]*)", stratum id: "([^"]*)" and step number: "([^"]*)"$/) do |patient_id, ta_id, stratum, step_number|
  @patient_id = patient_id=='null' ? nil : patient_id
  converted_ta_id = ta_id=='null' ? nil : ta_id
  converted_stratum = stratum=='null' ? nil : stratum
  converted_step_number = step_number=='null' ? nil : step_number
  Patient_helper_methods.prepare_on_treatment_arm(@patient_id, converted_ta_id, converted_stratum, converted_step_number)
end

Given(/^template request assignment message for patient: "([^"]*)" with re\-biopsy: "([^"]*)", step number: "([^"]*)"$/) do |patient_id, re_biopsy, step_number|
  @patient_id = patient_id=='null' ? nil : patient_id
  converted_rebiopsy = re_biopsy=='null' ? nil : re_biopsy
  converted_step_number = step_number=='null' ? nil : step_number
  Patient_helper_methods.prepare_request_assignment(@patient_id, converted_rebiopsy, converted_step_number)
end

Given(/^template request no assignment message for patient: "([^"]*)" with step number: "([^"]*)"$/) do |patient_id, step_number|
  @patient_id = patient_id=='null' ? nil : patient_id
  converted_step_number = step_number=='null' ? nil : step_number
  Patient_helper_methods.prepare_request_no_assignment(@patient_id, converted_step_number)
end

Given(/^template off study biopsy expired message for patient: "([^"]*)" on step number: "([^"]*)"$/) do |patient_id, step_number|
  @patient_id = patient_id=='null' ? nil : patient_id
  converted_step_number = step_number=='null' ? nil : step_number
  Patient_helper_methods.prepare_off_study_biopsy_expired(@patient_id, converted_step_number)
end

Given(/^template off study message for patient: "([^"]*)" on step number: "([^"]*)"$/) do |patient_id, step_number|
  @patient_id = patient_id=='null' ? nil : patient_id
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

def variant_confirm_message(variant_uuid, confirmed, comment)
  @current_variant_uuid = variant_uuid
  @current_variant_confirm = confirmed
  @current_variant_comment = comment=='null' ? nil : comment
  Patient_helper_methods.prepare_variant_confirm(@current_variant_comment)
end


#retrieval
Then(/^wait until patient has (\d+) assignment reports$/) do |ar_count|

end
Then(/^patient should have assignment report \(TA id: "([^"]*)", stratum id: "([^"]*)"\) with status "([^"]*)"$/) do |arg1, arg2, arg3|
  pending # Write code here that turns the phrase above into concrete actions
end
Then(/^patient should have assignment report \(report status: "([^"]*)"\) with status "([^"]*)"$/) do |arg1, arg2|
  pending # Write code here that turns the phrase above into concrete actions
end
# Then(/^retrieve patient: "([^"]*)" from API$/) do |patientID|
#   @patient_id = patientID=='null'?nil:patientID
#   print_log = Helper_Methods.is_local_tier
#   @retrieved_patient=Helper_Methods.get_single_request(ENV['patients_endpoint']+'/'+patientID, Helper_Methods.is_local_tier)
#
#   #for testing purpose
#   # @retrieved_patient=JSON(IO.read('/Users/wangl17/match_apps/patient_100100.json'))
# end

Given(/^patient id is "([^"]*)"$/) do |patient_id|
  @patient_id = patient_id
end

Then(/^patient field: "([^"]*)" should have value: "([^"]*)" within (\d+) seconds$/) do |field, value, timeout|
  converted_value = value=='null' ? nil : value
  url = "#{ENV['patients_endpoint']}?patient_id=#{@patient_id}"
  patient_result = Patient_helper_methods.get_special_result_from_url(url, timeout, {field => converted_value})
  first_match_second(patient_result[field], converted_value)
end

Then(/^patient field: "([^"]*)" should have value: "([^"]*)" after (\d+) seconds$/) do |field, value, timeout|
  sleep(timeout.to_f)
  converted_value = value=='null' ? nil : value
  url = "#{ENV['patients_endpoint']}?patient_id=#{@patient_id}"
  patient_result = Patient_helper_methods.get_special_result_from_url(url, 1.0, {field => converted_value})
  first_match_second(patient_result[field], converted_value)
end

# And(/^patient field: "([^"]*)" has value: "([^"]*)"$/) do |field, value|
#   convert_value = value=='null'?nil:value
#   @retrieved_patient[field].should == convert_value
# end

# Then(/^patient "([^"]*)" status will become to "([^"]*)"$/) do |patientID, status|
#   convert_status = status=='null'?nil:status
#   @retrieved_patient=Helper_Methods.get_single_request(ENV['patients_endpoint']+'/'+patientID,
#                                                        Helper_Methods.is_local_tier,
#                                                        'current_status',
#                                                        convert_status,
#                                                        1.0, 30.0)
#   @retrieved_patient['current_status'].should == convert_status
# end

# Then(/^returned patient has value: "([^"]*)" in field: "([^"]*)"$/) do |value, field|
#   convert_value = value=='null'?nil:value
#   @retrieved_patient[field].should == convert_value
# end


Then(/^patient should have selected treatment arm: "([^"]*)" with stratum id: "([^"]*)" within (\d+) seconds$/) do |ta_id, stratum, timeout|
  url = "#{ENV['patients_endpoint']}?patient_id=#{@patient_id}"
  query_hash = {'treatment_arm_id': ta_id, 'stratum_id': stratum}
  query_path = %w(current_assignment)
  patient_result = Patient_helper_methods.get_special_result_from_url(url, timeout, query_hash, query_path)
  if patient_result.keys.include?('current_assignment')
    patient_result = patient_result['current_assignment']
  end
  first_match_second(patient_result['treatment_arm_id'], ta_id)
  first_match_second(patient_result['stratum_id'], stratum)
end

Then(/^patient should have a blood specimen within (\d+) seconds$/) do |timeout|
  url = "#{ENV['patients_endpoint']}/#{@patient_id}/specimens"
  @current_specimen = Patient_helper_methods.get_special_result_from_url(url, timeout, {'specimen_type': 'BLOOD'})
  first_match_second(@current_specimen['patient_id'], @patient_id)
end

Then(/^patient should have specimen \(field: "([^"]*)" is "([^"]*)"\) within (\d+) seconds$/) do |field, value, timeout|
  url = "#{ENV['patients_endpoint']}/#{@patient_id}/specimens?#{field}=#{value}"
  @current_specimen = Patient_helper_methods.get_special_result_from_url(url, timeout, {field => value})
  first_match_second(@current_specimen[field], value)
end

Then(/^patient should have specimen \(surgical_event_id: "([^"]*)"\) within (\d+) seconds$/) do |sei, timeout|
  url = "#{ENV['patients_endpoint']}/#{@patient_id}/specimens?surgical_event_id=#{sei}"
  @current_specimen = Patient_helper_methods.get_special_result_from_url(url, timeout, {'surgical_event_id': sei})
  first_match_second(@current_specimen['surgical_event_id'], sei)
end

Then(/^patient specimen \(surgical_event_id: "([^"]*)"\) should be updated within (\d+) seconds$/) do |sei, timeout|
  url = "#{ENV['patients_endpoint']}/#{@patient_id}/specimens?surgical_event_id=#{sei}"
  @current_specimen = Patient_helper_methods.get_updated_result_from_url(url, timeout)
  first_match_second(@current_specimen['surgical_event_id'], sei)
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
  first_match_second(@current_specimen['pathology_status'], converted_patho_status)
end

And(/^this specimen should have a correct failed_date$/) do
  unless @current_specimen.keys.include?('failed_date')
    raise "specimen #{@current_specimen['surgical_event_id']} does not have field <failed_date>"
  end
  current_time = Time.now.utc.to_i
  returned_result = DateTime.parse(@current_specimen['failed_date']).to_i
  time_diff = current_time - returned_result
  first_include_second((0..300), time_diff)
end

And(/^this specimen field: "([^"]*)" should be: "([^"]*)"$/) do |field, value|
  converted_value = value=='null' ? nil : value
  first_match_second(@current_specimen[field], converted_value)
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
And(/^specimen \(surgical_event_id: "([^"]*)"\) field: "([^"]*)" should have value: "([^"]*)" within (\d+) seconds$/) do |sei, field, value, timeout|
  converted_value = value=='null' ? nil : value
  url = "#{ENV['patients_endpoint']}/#{@patient_id}/specimens?surgical_event_id=#{sei}"
  specimen_result = Patient_helper_methods.get_special_result_from_url(url, timeout, {field => converted_value})
  first_match_second(specimen_result[field], converted_value)
end


Then(/^patient should have blood specimen \(active_molecular_id: "([^"]*)"\) with in (\d+) seconds$/) do |moi, timeout|
  converted_moi = moi=='null' ? nil : moi
  url = "#{ENV['patients_endpoint']}/#{@patient_id}/specimens?active_molecular_id=#{converted_moi}"
  @current_specimen = Patient_helper_methods.get_special_result_from_url(url, timeout, {'active_molecular_id': converted_moi})
  first_match_second(@current_specimen['active_molecular_id'], converted_moi)
end
#
# Then(/^returned patient's blood specimen has value: "([^"]*)" in field: "([^"]*)"$/) do |value, field|
#   convert_value = value=='null'?nil:value
#   blood_specimen = find_specimen(@retrieved_patient, nil)
#   blood_specimen[field].should == convert_value
# end
#
Then(/^patient should have variant report \(analysis_id: "([^"]*)"\) within (\d+) seconds$/) do |ani, timeout|
  url = "#{ENV['patients_endpoint']}/variant_reports?analysis_id=#{ani}"
  @current_variant_report = Patient_helper_methods.get_special_result_from_url(url, timeout, {'analysis_id': ani})
  if @current_variant_report.is_a?(Array)
    if @current_variant_report.length>1
      raise "Expect 1 variant report returned, actually #{@current_variant_report.length} returned"
    end
  end
  first_match_second(@current_variant_report['analysis_id'], ani)
end

Then(/^patient should have variant report \(analysis_id: "([^"]*)"\) after (\d+) seconds$/) do |ani, timeout|
  sleep(timeout.to_f)
  url = "#{ENV['patients_endpoint']}/variant_reports?analysis_id=#{ani}"
  @current_variant_report = Patient_helper_methods.get_special_result_from_url(url, 1.0, {'analysis_id': ani})
  first_match_second(@current_variant_report['analysis_id'], ani)
end

And(/^this variant report has value: "([^"]*)" in field: "([^"]*)"$/) do |value, field|
  first_include_second(@current_variant_report.keys, field)
  convert_value = value=='null' ? nil : value
  returned_value = @current_variant_report[field]
  if returned_value.nil? || convert_value.nil?
    first_match_second(convert_value, returned_value)
  else
    first_match_second(convert_value.to_s.downcase, returned_value.to_s.downcase)
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
  first_include_second((0..20), time_diff)
end
#
# Then(/^returned patient has been assigned to new treatment arm: "([^"]*)", stratum id: "([^"]*)"$/) do |ta_id, stratum|
#   ta_id.should == 'pending'
# end
#
Given(/^a random "([^"]*)" variant in variant report \(analysis_id: "([^"]*)"\) for patient: "([^"]*)"$/) do |variant_type, ani, pt_id|
  @patient_id = pt_id
  url = "#{ENV['patients_endpoint']}/variants?analysis_id=#{ani}&variant_type=#{variant_type}"
  this_variant = Patient_helper_methods.get_any_result_from_url(url)
  if this_variant.is_a?(Array)
    this_variant = this_variant[0]
  end
  @current_variant_uuid = this_variant['uuid']
end

Then(/^this variant has confirmed field: "([^"]*)" and comment field: "([^"]*)" within (\d+) seconds$/) do |confirmed, comment, timeout|
  converted_comment = comment=='null' ? nil : comment
  url = "#{ENV['patients_endpoint']}/variants?uuid=#{@current_variant_uuid}"
  this_variant = Patient_helper_methods.get_special_result_from_url(url, timeout.to_f, {'uuid': @current_variant_uuid})
  first_match_second(this_variant['confirmed'].to_s, confirmed)
  first_match_second(this_variant['comment'], converted_comment)
end

Then(/^variants in variant report \(analysis_id: "([^"]*)"\) have confirmed: "([^"]*)" within (\d+) seconds$/) do |ani, confirmed, timeout|
  url = "#{ENV['patients_endpoint']}/variants?analysis_id=#{ani}"
  variants = Patient_helper_methods.get_special_result_from_url(url, timeout.to_f, {'analysis_id': ani})
  variants.each { |this_variant|
    first_match_second(this_variant['confirmed'].to_s, confirmed)
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

Given(/^patient: "([^"]*)" in mock service lost patient list, service will come back after "([^"]*)" tries$/) do |patient_id, error_times|
  COG_helper_methods.setServiceLostPatient(patient_id, error_times)
end

Then(/^COG received assignment status: "([^"]*)" for this patient$/) do |assignment_status|
  converted_status = assignment_status=='null' ? nil : assignment_status
  response = COG_helper_methods.get_patient_assignment_status(@patient_id)

  if response['message_json']['status'].nil?
    raise response.to_json.to_s
  else
    first_match_second(response['message_json']['status'], converted_status)
  end
end

Then(/^COG received assignment with treatment_arm_id: "([^"]*)" and stratum_id: "([^"]*)" for this patient$/) do |ta_id, stratum|
  converted_ta_id = ta_id=='null' ? nil : ta_id
  converted_stratum = stratum=='null' ? nil : stratum
  response = COG_helper_methods.get_patient_assignment_status(@patient_id)

  if response['message_json']['treatment_arm_id'].nil?
    raise response.to_json.to_s
  else
    first_match_second(response['message_json']['treatment_arm_id'], converted_ta_id)
  end
  if response['message_json']['stratum_id'].nil?
    raise response.to_json.to_s
  else
    first_match_second(response['message_json']['stratum_id'], converted_stratum)
  end
end

def first_match_second(first, second)
  expect(first).to eq second
end

def first_include_second(first, second)
  expect(first).to include second
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

