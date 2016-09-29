#!/usr/bin/ruby
require 'rspec'
require 'json'
require_relative '../../../support/helper_methods.rb'
require_relative '../../../support/patient_helper_methods.rb'
require_relative '../../../support/cog_helper_methods.rb'


#post
# When(/^posted to MATCH patient trigger service, returns a message that includes "([^"]*)" with status "([^"]*)"$/) do |retMsg, status|
#   puts JSON.pretty_generate(@request_json)
#   @response = Helper_Methods.post_request(ENV['protocol'] + '://' + ENV['DOCKER_HOSTNAME'] + ':' + ENV['patient_api_PORT'] + '/trigger',@request)
#   expect(@response['status']).to eql(status)
#   expect_message = "returned message include <#{retMsg}>"
#   actual_message = @response['message']
#   if @response['message'].include?retMsg
#     actual_message = "returned message include <#{retMsg}>"
#   end
#   actual_message.should == expect_message
# end

When(/^post to MATCH patients service, returns a message that includes "([^"]*)" with status "([^"]*)"$/) do |retMsg, status|
  puts JSON.pretty_generate(@request_json)
  @response = Helper_Methods.post_request(ENV['patients_endpoint']+'/'+@patient_id, @request)
  expect(@response['status']).to eql(status)
  expect_message = "returned message include <#{retMsg}>"
  actual_message = @response['message']
  if @response['message'].downcase.include?retMsg.downcase
    actual_message = "returned message include <#{retMsg}>"
  end
  actual_message.should == expect_message
end

When(/^put to MATCH variant report confirm service, returns a message that includes "([^"]*)" with status "([^"]*)"$/) do |retMsg, status|
  puts JSON.pretty_generate(@request_json)
  url = ENV['patients_endpoint'] + '/'
  url = url + @patient_id + '/variant_reports/' + @analysis_id + '/' + @variant_report_status
  @response = Helper_Methods.put_request(url, @request)
  expect(@response['status']).to eql(status)
  expect_message = "returned message include <#{retMsg}>"
  actual_message = @response['message']
  if @response['message'].include?retMsg
    actual_message = "returned message include <#{retMsg}>"
  end
  actual_message.should == expect_message

end

When(/^put to MATCH variant confirm service, returns a message that includes "([^"]*)" with status "([^"]*)"$/) do |retMsg, status|
  puts JSON.pretty_generate(@request_json)
  url = ENV['patients_endpoint'] + '/'
  url = url + 'variant/' + @current_variant_uuid + '/' + @current_variant_confirm
  @response = Helper_Methods.put_request(url, @request)
  expect(@response['status']).to eql(status)
  expect_message = "returned message include <#{retMsg}>"
  actual_message = @response['message']
  if @response['message'].include?retMsg
    actual_message = "returned message include <#{retMsg}>"
  end
  actual_message.should == expect_message

end

When(/^post to MATCH assignment confirm service with assigned_date: "([^"]*)", returns a message that includes "([^"]*)" with status "([^"]*)"$/) do |assign_date, retMsg, status|
  puts JSON.pretty_generate(@request_json)
  url = ENV['patients_endpoint'] + '/'
  url = url + @patient_id + '/assignment_reports/' + assign_date + '/confirm'
  @response = Helper_Methods.put_request(url, @request)
  expect(@response['status']).to eql(status)
  expect_message = "returned message include <#{retMsg}>"
  actual_message = @response['message']
  if @response['message'].include?retMsg
    actual_message = "returned message include <#{retMsg}>"
  end
  actual_message.should == expect_message

end

#messages
Given(/^template patient registration message for patient: "([^"]*)" on date: "([^"]*)"$/) do |patient_id, date|
  @request_json = Patient_helper_methods.load_patient_message_templates('registration')
  @patient_id = patient_id=='null'?nil:patient_id
  converted_date = date=='null'?nil:date
  converted_date = Helper_Methods.getDateAsRequired(converted_date)
  @patient_message_root_key = ''
  @request_json['patient_id'] = @patient_id
  @request_json['registration_date'] = converted_date
  @request = @request_json.to_json.to_s
end

Given(/^template specimen received message in type: "([^"]*)" for patient: "([^"]*)", it has surgical_event_id: "([^"]*)"$/) do |type, patientID, sei|
  @request_json = Patient_helper_methods.load_patient_message_templates("specimen_received_#{type}")
  @patient_id = patientID=='null'?nil:patientID
  @surgical_event_id = sei=='null'?nil:sei
  @patient_message_root_key = 'specimen_received'
  @request_json[@patient_message_root_key]['patient_id'] = @patient_id
  if type == 'TISSUE'
    @request_json[@patient_message_root_key]['surgical_event_id'] = @surgical_event_id
  end
  @request = @request_json.to_json.to_s
end

Given(/^template specimen shipped message in type: "([^"]*)" for patient: "([^"]*)", it has surgical_event_id: "([^"]*)", molecular_id: "([^"]*)", slide_barcode: "([^"]*)"/) do |type, patientID, sei, moi, barcode|
  @request_json = Patient_helper_methods.load_patient_message_templates("specimen_shipped_#{type}")
  converted_patient_id = patientID=='null'?nil:patientID
  @patient_id = converted_patient_id
  @surgical_event_id = sei=='null'?nil:sei
  @molecular_id = moi=='null'?nil:moi
  @slide_barcode = barcode=='null'?nil:barcode
  @patient_message_root_key = 'specimen_shipped'
  @request_json[@patient_message_root_key]['patient_id'] = @patient_id
  if type == 'TISSUE' || type == 'SLIDE'
    @request_json[@patient_message_root_key]['surgical_event_id'] = @surgical_event_id
  end
  if type == 'TISSUE' || type == 'BLOOD'
    @request_json[@patient_message_root_key]['molecular_id'] = @molecular_id
    @request_json[@patient_message_root_key]['molecular_dna_id'] = @molecular_id+'D'
    @request_json[@patient_message_root_key]['molecular_cdna_id'] = @molecular_id+'C'
  end
  if type == 'SLIDE'
    @request_json[@patient_message_root_key]['slide_barcode'] = @slide_barcode
  end
  @request = @request_json.to_json.to_s
end

Given(/^template assay message with surgical_event_id: "([^"]*)" for patient: "([^"]*)"$/) do |sei, patientID|
  @request_json = Patient_helper_methods.load_patient_message_templates('assay_result_reported')
  @patient_id = patientID=='null'?nil:patientID
  @surgical_event_id = sei=='null'?nil:sei

  @patient_message_root_key = ''
  @request_json['patient_id'] = @patient_id
  @request_json['surgical_event_id'] = @surgical_event_id
  @request = @request_json.to_json.to_s
end

Given(/^template pathology report with surgical_event_id: "([^"]*)" for patient: "([^"]*)"$/) do |sei, patientID|
  @request_json = Patient_helper_methods.load_patient_message_templates('pathology_status')
  @patient_id = patientID=='null'?nil:patientID
  @surgical_event_id = sei=='null'?nil:sei
  @patient_message_root_key = ''
  @request_json['patient_id'] = @patient_id
  @request_json['surgical_event_id'] = @surgical_event_id
  @request = @request_json.to_json.to_s
end

Given(/^template variant file uploaded message for patient: "([^"]*)", it has molecular_id: "([^"]*)" and analysis_id: "([^"]*)"$/) do |patientID, moi, ani|
  @request_json = Patient_helper_methods.load_patient_message_templates('variant_file_uploaded')
  @patient_id = patientID=='null'?nil:patientID
  @molecular_id = moi=='null'?nil:moi
  @analysis_id = ani=='null'?nil:ani
  @patient_message_root_key = ''
  @request_json['molecular_id'] = @molecular_id
  @request_json['analysis_id'] = @analysis_id
  @request = @request_json.to_json.to_s
end

Given(/^template variant confirm message for patient: "([^"]*)", the variant: "([^"]*)" is checked: "([^"]*)" with comment: "([^"]*)"$/) do |patient_id, variant_uuid, confirmed, comment|
  variant_confirm_message(variant_uuid, confirmed, comment)
end

Then(/^create variant confirm message with checked: "([^"]*)" and comment: "([^"]*)" for this variant$/) do |confirmed, comment|
  variant_confirm_message(@current_variant_uuid, confirmed, comment)
end

Given(/^template variant report confirm message for patient: "([^"]*)", it has analysis_id: "([^"]*)" and status: "([^"]*)"$/) do |patient_id, ani, status|
  @request_json = Patient_helper_methods.load_patient_message_templates('variant_file_confirmed')
  @patient_id = patient_id
  @analysis_id = ani
  @variant_report_status = status
  @patient_message_root_key = ''
  @request = @request_json.to_json.to_s
end

Given(/^template assignment report confirm message for patient: "([^"]*)", it has molecular_id: "([^"]*)", analysis_id: "([^"]*)" and status: "([^"]*)"$/) do |patient_id, moi, ani, status|
  @request_json = Patient_helper_methods.load_patient_message_templates('assignment_confirmed')
  @patient_id = patient_id=='null'?nil:patient_id
  @molecular_id = moi=='null'?nil:moi
  @analysis_id = ani=='null'?nil:ani
  @assignment_report_status = status=='null'?nil:status
  @patient_message_root_key = ''
  @request_json['patient_id'] = @patient_id
  @request_json['molecular_id'] = @molecular_id
  @request_json['analysis_id'] = @analysis_id
  @request_json['status'] = @assignment_report_status
  @request = @request_json.to_json.to_s

end

Then(/^set patient message field: "([^"]*)" to value: "([^"]*)"$/) do |field, value|
  if value != 'skip_this_value'
    converted_value = String.new
    if value == 'null'
      converted_value = nil
    elsif value.eql?('current')
      converted_value = Helper_Methods.getDateAsRequired(value)
    else
      converted_value = value
    end

    if @patient_message_root_key == ''
      @request_json[field] = converted_value
    else
      @request_json[@patient_message_root_key][field] = converted_value
    end
    @request = @request_json.to_json.to_s
  end
end

Then(/^remove field: "([^"]*)" from patient message$/) do |field|
  if @patient_message_root_key == ''
    @request_json.delete(field)
  else
    @request_json[@patient_message_root_key].delete(field)
  end

  @request = @request_json.to_json.to_s
end

def variant_confirm_message(variant_uuid, confirmed, comment)
  @request_json = Patient_helper_methods.load_patient_message_templates('variant_confirmed')
  @current_variant_uuid = variant_uuid
  @current_variant_confirm = confirmed
  @current_variant_comment = comment=='null'?nil:comment
  @patient_message_root_key = ''
  @request_json['comment'] = @current_variant_comment
  @request = @request_json.to_json.to_s
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

Then(/^patient field: "([^"]*)" should have value: "([^"]*)" within (\d+) seconds$/) do |field, value, timeout|
  converted_value = value=='null'?nil:value
  url = "#{ENV['patients_endpoint']}?patient_id=#{@patient_id}"
  patient_result = Patient_helper_methods.get_result_from_url(url, field, converted_value, timeout)
  patient_result[field].should == converted_value
end

Then(/^patient field: "([^"]*)" should have value: "([^"]*)" after (\d+) seconds$/) do |field, value, timeout|
  sleep(timeout.to_f)
  converted_value = value=='null'?nil:value
  url = "#{ENV['patients_endpoint']}?patient_id=#{@patient_id}"
  patient_result = Patient_helper_methods.get_result_from_url(url, field, converted_value, 1.0)
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

Then(/^patient should have specimen \(surgical_event_id: "([^"]*)"\) within (\d+) seconds$/) do |sei, timeout|
  url = "#{ENV['patients_endpoint']}/#{@patient_id}/specimens?surgical_event_id=#{sei}"
  @current_specimen = Patient_helper_methods.get_result_from_url(url, 'surgical_event_id', sei, timeout)
  @current_specimen['surgical_event_id'].should == sei
end

And(/^this specimen has assay \(biomarker: "([^"]*)", result: "([^"]*)", reported_date: "([^"]*)"\)$/) do |biomarker, result, reported_date|
  converted_biomarker = biomarker=='null'?nil:biomarker
  converted_result = result=='null'?nil:result
  converted_reported_date = reported_date=='null'?nil:reported_date
  returned_assay = find_assay(@current_specimen, converted_biomarker, converted_result, converted_reported_date)
  expect_result = "Can find assay with biomarker:#{biomarker}, result:#{result} and report_date:#{reported_date}"
  actual_result = "Can NOT find assay with biomarker:#{biomarker}, result:#{result} and report_date:#{reported_date}"
  if returned_assay.nil?
    actual_result = expect_result
  end
  actual_result.should == expect_result
end

# # And(/^this specimen has assay: "([^"]*)" in field: "([^"]*)"$/) do |value, field|
# #   convert_value = value=='null'?nil:value
# #   @current_specimen[field].should == convert_value
# # end
#
And(/^this specimen has value: "([^"]*)" in field: "([^"]*)"$/) do |value, field|
  convert_value = value=='null'?nil:value
  @current_specimen[field].should == convert_value
end
#
# Then(/^returned patient's blood specimen has value: "([^"]*)" in field: "([^"]*)"$/) do |value, field|
#   convert_value = value=='null'?nil:value
#   blood_specimen = find_specimen(@retrieved_patient, nil)
#   blood_specimen[field].should == convert_value
# end
#
Then(/^patient should have variant report \(analysis_id: "([^"]*)"\) within (\d+) seconds$/) do |ani, timeout|
  url = "#{ENV['patients_endpoint']}/#{@patient_id}/variant_reports?analysis_id=#{ani}"
  @current_variant_report = Patient_helper_methods.get_result_from_url(url, 'analysis_id', ani, timeout)
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
#
#
# Then(/^find the first "([^"]*)" variant in variant report which has analysis_id: "([^"]*)"$/) do |variant_type, ani|
#   this_variant_report = find_variant_report(@retrieved_patient, ani)
#   variant_list_field = case variant_type
#                          when 'snv_id' then 'snvs_and_indels'
#                          when 'cnv' then 'copy_number_variants'
#                          when 'gf' then 'gene_fusions'
#                        end
#   all_variants = this_variant_report['variants']
#
#   expect_result = "this patient has #{variant_list_field} variants"
#   actual_result = all_variants.key?(variant_list_field)?expect_result:"this patient doesn't have #{variant_list_field} variants"
#   actual_result.should == expect_result
#
#   @current_variant_uuid = all_variants[variant_list_field][0]['uuid']
# end
#
# Then(/^this variant has confirmed field: "([^"]*)" and comment field: "([^"]*)"$/) do |confirmed, comment|
#   convertec_comment = comment=='null'?nil:comment
#   this_variant = find_variant(@retrieved_patient, @current_variant_uuid)
#   this_variant['confirmed'].should == convert_string_to_bool(confirmed)
#   this_variant['comment'].should == convertec_comment
# end
#
# # we don't have status_date in variant level
# # And(/^this variant has correct status_date value$/) do
# #   this_variant = find_variant(@retrieved_patient, @current_variant_uuid)
# #   currentTime = Time.now.utc.to_i
# #   returnedResult = DateTime.parse(this_variant['status_date']).to_i
# #   timeDiff = currentTime - returnedResult
# #   timeDiff.should >=0
# #   timeDiff.should <=20
# # end
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

