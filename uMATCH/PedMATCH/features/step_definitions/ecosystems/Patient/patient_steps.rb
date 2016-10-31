#!/usr/bin/ruby
require 'rspec'
require 'json'
require_relative '../../../support/helper_methods.rb'
require_relative '../../../support/patient_helper_methods.rb'
require_relative '../../../support/cog_helper_methods.rb'


#post
When(/^post to MATCH patients service, returns a message that includes "([^"]*)" with status "([^"]*)"$/) do |retMsg, status|
  Patient_helper_methods.post_to_trigger(status, retMsg)
end

When(/^put to MATCH variant report confirm service, returns a message that includes "([^"]*)" with status "([^"]*)"$/) do |retMsg, status|
  Patient_helper_methods.put_vr_confirm(@analysis_id, @variant_report_status, status, retMsg)
end

When(/^put to MATCH variant confirm service, returns a message that includes "([^"]*)" with status "([^"]*)"$/) do |retMsg, status|
  Patient_helper_methods.put_variant_confirm(@current_variant_uuid, @current_variant_confirm, status, retMsg)
end

When(/^post to MATCH assignment confirm service, returns a message that includes "([^"]*)" with status "([^"]*)"$/) do |retMsg, status|
  Patient_helper_methods.put_ar_confirm(@analysis_id, @assignment_report_status, status, retMsg)
end

#messages
Given(/^template patient registration message for patient: "([^"]*)" on date: "([^"]*)"$/) do |patient_id, date|
  @patient_id = patient_id=='null'?nil:patient_id
  converted_date = date=='null'?nil:date
  converted_date = Helper_Methods.getDateAsRequired(converted_date)
  Patient_helper_methods.prepare_register(@patient_id, converted_date)
end

Given(/^template specimen received message in type: "([^"]*)" for patient: "([^"]*)", it has surgical_event_id: "([^"]*)"$/) do |type, patientID, sei|
  @patient_id = patientID=='null'?nil:patientID
  converted_sei = sei=='null'?nil:sei
  Patient_helper_methods.prepare_specimen_received(@patient_id, type, converted_sei)
end

Given(/^template specimen shipped message in type: "([^"]*)" for patient: "([^"]*)", it has surgical_event_id: "([^"]*)", molecular_id or slide_barcode: "([^"]*)"/) do |type, patientID, sei, moi_or_barcode|
  @patient_id = patientID=='null'?nil:patientID
  converted_sei = sei=='null'?nil:sei
  converted_id = moi_or_barcode=='null'?nil:moi_or_barcode
  Patient_helper_methods.prepare_specimen_shipped(@patient_id, type, converted_sei, converted_id)
end

Given(/^template assay message with surgical_event_id: "([^"]*)" for patient: "([^"]*)"$/) do |sei, patientID|
  @patient_id = patientID=='null'?nil:patientID
  converted_sei = sei=='null'?nil:sei
  Patient_helper_methods.prepare_assay(@patient_id, converted_sei)
end

Given(/^template pathology report with surgical_event_id: "([^"]*)" for patient: "([^"]*)"$/) do |sei, patientID|
  @patient_id = patientID=='null'?nil:patientID
  converted_sei = sei=='null'?nil:sei
  Patient_helper_methods.prepare_pathology(@patient_id, converted_sei)
end

Given(/^template variant file uploaded message for patient: "([^"]*)", it has molecular_id: "([^"]*)" and analysis_id: "([^"]*)" and need files in S3 Y or N: "([^"]*)"$/) do |patientID, moi, ani, upload|
  @patient_id = patientID=='null'?nil:patientID
  converted_moi = moi=='null'?nil:moi
  @analysis_id = ani=='null'?nil:ani
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
  @patient_id = patient_id=='null'?nil:patient_id
  @analysis_id = ani=='null'?nil:ani
  @variant_report_status = status
  Patient_helper_methods.prepare_vr_confirm(@patient_id)
end

Given(/^template assignment report confirm message for patient: "([^"]*)", it has analysis_id: "([^"]*)" and status: "([^"]*)"$/) do |patient_id, ani, status|
  @patient_id = patient_id=='null'?nil:patient_id
  @analysis_id = ani=='null'?nil:ani
  @assignment_report_status = status=='null'?nil:status
  Patient_helper_methods.prepare_assignment_confirm(@patient_id)

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
  @current_variant_comment = comment=='null'?nil:comment
  Patient_helper_methods.prepare_variant_confirm(@current_variant_comment)
end



#retrieval

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
  converted_value = value=='null'?nil:value
  url = "#{ENV['patients_endpoint']}?patient_id=#{@patient_id}"
  patient_result = Patient_helper_methods.get_special_result_from_url(url, timeout, {field=>converted_value})
  patient_result[field].should == converted_value
end

Then(/^patient field: "([^"]*)" should have value: "([^"]*)" after (\d+) seconds$/) do |field, value, timeout|
  sleep(timeout.to_f)
  converted_value = value=='null'?nil:value
  url = "#{ENV['patients_endpoint']}?patient_id=#{@patient_id}"
  patient_result = Patient_helper_methods.get_special_result_from_url(url, 1.0, {field=>converted_value})
  patient_result[field].should == converted_value
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

# Then(/^returned patient has selected treatment arm: "([^"]*)" with stratum id: "([^"]*)"$/) do |ta_id, stratum|
#   convert_ta_id = ta_id=='null'?nil:ta_id
#   convert_stratum = stratum=='null'?nil:stratum
#   @retrieved_patient['current_assignment']['selected_treatment_arm']['treatment_arm_id'].should == convert_ta_id
#   @retrieved_patient['current_assignment']['selected_treatment_arm']['stratum_id'].should == convert_stratum
# end
#

Then(/^patient should have a blood specimen within (\d+) seconds$/) do |timeout|
  url = "#{ENV['patients_endpoint']}/#{@patient_id}/specimens"
  @current_specimen = Patient_helper_methods.get_special_result_from_url(url, timeout, {'specimen_type':'BLOOD'})
  @current_specimen['patient_id'].should == @patient_id
end

Then(/^patient should have specimen \(field: "([^"]*)" is "([^"]*)"\) within (\d+) seconds$/) do |field, value, timeout|
  url = "#{ENV['patients_endpoint']}/#{@patient_id}/specimens?#{field}=#{value}"
  @current_specimen = Patient_helper_methods.get_special_result_from_url(url, timeout, {field=>value})
  @current_specimen[field].should == value
end

Then(/^patient should have specimen \(surgical_event_id: "([^"]*)"\) within (\d+) seconds$/) do |sei, timeout|
  url = "#{ENV['patients_endpoint']}/#{@patient_id}/specimens?surgical_event_id=#{sei}"
  @current_specimen = Patient_helper_methods.get_special_result_from_url(url, timeout, {'surgical_event_id':sei})
  @current_specimen['surgical_event_id'].should == sei
end

Then(/^patient specimen \(surgical_event_id: "([^"]*)"\) should be updated within (\d+) seconds$/) do |sei, timeout|
  url = "#{ENV['patients_endpoint']}/#{@patient_id}/specimens?surgical_event_id=#{sei}"
  @current_specimen = Patient_helper_methods.get_updated_result_from_url(url, timeout)
  @current_specimen['surgical_event_id'].should == sei
end


And(/^this specimen has assay \(biomarker: "([^"]*)", result: "([^"]*)", reported_date: "([^"]*)"\)$/) do |biomarker, result, reported_date|
  converted_biomarker = biomarker=='null'?nil:biomarker
  converted_result = result=='null'?nil:result
  converted_reported_date = reported_date=='null'?nil:reported_date
  returned_assay = find_assay(@current_specimen, converted_biomarker, converted_result, converted_reported_date)
  expect_result = "Can find assay with biomarker:#{biomarker}, result:#{result} and report_date:#{reported_date}"
  actual_result = "Can NOT find assay with biomarker:#{biomarker}, result:#{result} and report_date:#{reported_date}"
  unless returned_assay.nil?
    actual_result = expect_result
  end
  actual_result.should == expect_result
end

And(/^this specimen has pathology status: "([^"]*)"$/) do |pathology_status|
  converted_patho_status = pathology_status=='null'?nil:pathology_status
  @current_specimen['pathology_status'].should == converted_patho_status
end

# # And(/^this specimen has assay: "([^"]*)" in field: "([^"]*)"$/) do |value, field|
# #   convert_value = value=='null'?nil:value
# #   @current_specimen[field].should == convert_value
# # end
#
And(/^specimen \(surgical_event_id: "([^"]*)"\) field: "([^"]*)" should have value: "([^"]*)" within (\d+) seconds$/) do |sei, field, value, timeout|
  converted_value = value=='null'?nil:value
  url = "#{ENV['patients_endpoint']}/#{@patient_id}/specimens?surgical_event_id=#{sei}"
  specimen_result = Patient_helper_methods.get_special_result_from_url(url, timeout, {field=>converted_value})
  specimen_result[field].should == converted_value
end


Then(/^patient should have blood specimen \(active_molecular_id: "([^"]*)"\) with in (\d+) seconds$/) do |moi, timeout|
  converted_moi = moi=='null'?nil:moi
  url = "#{ENV['patients_endpoint']}/#{@patient_id}/specimens?active_molecular_id=#{converted_moi}"
  @current_specimen = Patient_helper_methods.get_special_result_from_url(url, timeout, {'active_molecular_id':converted_moi})
  @current_specimen['active_molecular_id'].should == converted_moi
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
  @current_variant_report = Patient_helper_methods.get_special_result_from_url(url, timeout, {'analysis_id':ani})
  @current_variant_report['analysis_id'].should == ani
end

Then(/^patient should have variant report \(analysis_id: "([^"]*)"\) after (\d+) seconds$/) do |ani, timeout|
  sleep(timeout.to_f)
  url = "#{ENV['patients_endpoint']}/variant_reports?analysis_id=#{ani}"
  @current_variant_report = Patient_helper_methods.get_special_result_from_url(url, 1.0, {'analysis_id':ani})
  @current_variant_report['analysis_id'].should == ani
end

And(/^this variant report has value: "([^"]*)" in field: "([^"]*)"$/) do |value, field|
  expect_field = "variant report contains field: #{field}"
  actual_field = expect_field
  unless @current_variant_report.keys.include?(field)
    actual_field = "variant repor does not contain field: #{field}"
  end
  actual_field.should == expect_field
  convert_value = value=='null'?nil:value
  expect_result = "Value of field #{field} contains #{convert_value}"
  returned_value = @current_variant_report[field]
  real_result = "Value of field #{field} is #{@current_variant_report[field]}"
  equal = returned_value == convert_value
  unless equal
    if returned_value.nil? || convert_value.nil?
      equal = false
    else
      equal = returned_value.downcase.include?(convert_value.downcase)
    end
  end
  if equal
    real_result = expect_result
  end
  real_result.should == expect_result
end

And(/^this variant report has correct status_date$/) do
  current_time = Time.now.utc.to_i
  returned_result = DateTime.parse(@current_variant_report['status_date']).to_i
  time_diff = current_time - returned_result
  time_diff.should >=0
  time_diff.should <=20
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
  converted_comment = comment=='null'?nil:comment
  url = "#{ENV['patients_endpoint']}/variants?uuid=#{@current_variant_uuid}"
  this_variant = Patient_helper_methods.get_special_result_from_url(url, timeout.to_f, {'uuid':@current_variant_uuid})
  this_variant['confirmed'].should == convert_string_to_bool(confirmed)
  this_variant['comment'].should == converted_comment
end

Then(/^variants in variant report \(analysis_id: "([^"]*)"\) have confirmed: "([^"]*)" within (\d+) seconds$/) do |ani, confirmed, timeout|
  url = "#{ENV['patients_endpoint']}/variants?analysis_id=#{ani}"
  variants = Patient_helper_methods.get_special_result_from_url(url, timeout.to_f, {'analysis_id':ani})
  variants.each { |this_variant|
    this_variant['confirmed'].to_s.should==confirmed
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

def convert_string_to_bool(string)
  case string
    when 'true' then true
    when 'false' then false
    when 'null' then nil
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
    variants.each {|key, value|
      value.each{|variant|
        if variant['uuid']==variant_uuid
          return variant
        end
      }
    }
  end
  nil
end

