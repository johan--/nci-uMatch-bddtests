#!/usr/bin/ruby
require 'rspec'
require 'json'
require_relative '../../../support/helper_methods.rb'
require_relative '../../../support/patient_helper_methods.rb'


#post
When(/^posted to MATCH patient trigger service, returns a message that includes "([^"]*)" with status "([^"]*)"$/) do |retMsg, status|
  puts JSON.pretty_generate(@request_json)
  @response = Helper_Methods.post_request(ENV['protocol'] + '://' + ENV['DOCKER_HOSTNAME'] + ':' + ENV['patient_api_PORT'] + '/trigger',@request)
  expect(@response['status']).to eql(status)
  expect_message = "returned message include <#{retMsg}>"
  actual_message = @response['message']
  if @response['message'].include?retMsg
    actual_message = "returned message include <#{retMsg}>"
  end
  actual_message.should == expect_message
end

#messages
Given(/^template specimen received message in type: "([^"]*)" for patient: "([^"]*)"$/) do |type, patientID|
  @request_json = Patient_helper_methods.load_patient_message_templates("specimen_received_#{type}")
  converted_patient_id = patientID=='null'?nil:patientID
  @patient_message_root_key = 'specimen_received'
  @request_json[@patient_message_root_key]['patient_id'] = converted_patient_id
  @request = @request_json.to_json.to_s
end

Given(/^template specimen shipped message in type: "([^"]*)" for patient: "([^"]*)"$/) do |type, patientID|
  @request_json = Patient_helper_methods.load_patient_message_templates("specimen_shipped_#{type}")
  converted_patient_id = patientID=='null'?nil:patientID
  @patient_message_root_key = 'specimen_shipped'
  @request_json[@patient_message_root_key]['patient_id'] = converted_patient_id
  @request = @request_json.to_json.to_s
end

Given(/^template assay message with surgical_event_id: "([^"]*)" for patient: "([^"]*)"$/) do |sei, patientID|
  @request_json = Patient_helper_methods.load_patient_message_templates('assay_result_reported')
  converted_patient_id = patientID=='null'?nil:patientID
  converted_sei = sei=='null'?nil:sei
  @patient_message_root_key = ''
  @request_json['patient_id'] = converted_patient_id
  @request_json['surgical_event_id'] = converted_sei
  @request = @request_json.to_json.to_s
end

Given(/^template pathology report with surgical_event_id: "([^"]*)" for patient: "([^"]*)"$/) do |sei, patientID|
  @request_json = Patient_helper_methods.load_patient_message_templates('pathology_status')
  converted_patient_id = patientID=='null'?nil:patientID
  converted_sei = sei=='null'?nil:sei
  @patient_message_root_key = ''
  @request_json['patient_id'] = converted_patient_id
  @request_json['surgical_event_id'] = converted_sei
  @request = @request_json.to_json.to_s
end

Given(/^template variant uploaded message for patient: "([^"]*)", it has surgical_event_id: "([^"]*)", molecular_id: "([^"]*)" and analysis_id: "([^"]*)"$/) do |patientID, sei, moi, ani|
  @request_json = Patient_helper_methods.load_patient_message_templates('variant_file_uploaded')
  converted_patient_id = patientID=='null'?nil:patientID
  converted_sei = sei=='null'?nil:sei
  converted_moi = moi=='null'?nil:moi
  converted_ani = ani=='null'?nil:ani
  @patient_message_root_key = ''
  @request_json['patient_id'] = converted_patient_id
  @request_json['surgical_event_id'] = converted_sei
  @request_json['molecular_id'] = converted_moi
  @request_json['analysis_id'] = converted_ani
  @request = @request_json.to_json.to_s
end

Given(/^template variant confirm message for variant: "([^"]*)", it is confirmed: "([^"]*)" with comment: "([^"]*)"$/) do |variant_uuid, confirmed, comment|
  variant_confirm_message(variant_uuid, confirmed, comment)
end

Then(/^create variant confirm message with confirmed: "([^"]*)" and comment: "([^"]*)" for this variant$/) do |confirmed, comment|
  variant_confirm_message(@current_variant_uuid, confirmed, comment)
end

Given(/^template variant report confirm message for patient: "([^"]*)", it has surgical_event_id: "([^"]*)", molecular_id: "([^"]*)", analysis_id: "([^"]*)" and status: "([^"]*)"$/) do |patient_id, sei, moi, ani, status|
  @request_json = Patient_helper_methods.load_patient_message_templates('variant_file_confirmed')
  converted_patient_id = patientID=='null'?nil:patientID
  converted_sei = sei=='null'?nil:sei
  converted_moi = moi=='null'?nil:moi
  converted_ani = ani=='null'?nil:ani
  converted_status = status=='null'?nil:status
  @patient_message_root_key = ''
  @request_json['patient_id'] = converted_patient_id
  @request_json['surgical_event_id'] = converted_sei
  @request_json['molecular_id'] = converted_moi
  @request_json['analysis_id'] = converted_ani
  @request_json['status'] = converted_status
  @request = @request_json.to_json.to_s

end

Then(/^set patient message field: "([^"]*)" to value: "([^"]*)"$/) do |field, value|
  converted_value = value=='null'?nil:value
  if @patient_message_root_key == ''
    @request_json[field] = converted_value
  else
    @request_json[@patient_message_root_key][field] = converted_value
  end
  @request = @request_json.to_json.to_s
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
  converted_uuid = variant_uuid=='null'?nil:variant_uuid
  converted_confirmed = confirmed=='null'?nil:confirmed
  converted_comment = comment=='null'?nil:comment
  @patient_message_root_key = ''
  @request_json['variant_uuid'] = converted_uuid
  @request_json['confirmed'] = converted_confirmed
  @request_json['comment'] = converted_comment
  @request = @request_json.to_json.to_s
end



#retrieval
Then(/^retrieve patient: "([^"]*)" from API$/) do |patientID|
  @retrieved_patient=Helper_Methods.get_single_request(ENV['protocol']+'://'+ENV['DOCKER_HOSTNAME']+':'+ENV['patient_api_PORT']+'/patients/'+patientID)

  #for testing purpose
  # @retrieved_patient=JSON(IO.read('/Users/wangl17/match_apps/patient_100100.json'))
end

Then(/^returned patient has variant report \(surgical_event_id: "([^"]*)", molecular_id: "([^"]*)", analysis_id: "([^"]*)"\)$/) do |sei, moi, ani|
  @current_variant_report = find_variant_report(@retrieved_patient, sei, moi, ani)
  expect_find = "Can find variant with surgical_event_id=#{sei}, molecular_id=#{moi} and analysis_id=#{ani}"
  actual_find = expect_find
  if @current_variant_report == nil
    actual_find = "Cannot find variant with surgical_event_id=#{sei}, molecular_id=#{moi} and analysis_id=#{ani}"
  end
  actual_find.should == expect_find

end

And(/^this variant report has value: "([^"]*)" in field: "([^"]*)"$/) do |value, field|
  @current_variant_report[field].should == value
end

And(/^this variant report has correct status_date$/) do
  current_time = Time.now.utc.to_i
  returned_result = DateTime.parse(@current_variant_report['status_date']).to_i
  time_diff = current_time - returned_result
  time_diff.should >=0
  time_diff.should <=20
end

Then(/^find the first "([^"]*)" variant in variant report which has surgical_event_id: "([^"]*)", molecular_id: "([^"]*)" and analysis_id: "([^"]*)"$/) do |variant_type, sei, moi, ani|
  this_variant_report = find_variant_report(@retrieved_patient, sei, moi, ani)
  variant_list_field = case variant_type
                         when 'snv_id' then 'snvs_and_indels'
                         when 'cnv' then 'copy_number_variants'
                         when 'gf' then 'gene_fusions'
                       end
  all_variants = this_variant_report['variants']

  expect_result = "this patient has #{variant_list_field} variants"
  actual_result = all_variants.key?(variant_list_field)?expect_result:"this patient doesn't have #{variant_list_field} variants"
  actual_result.should == expect_result

  @current_variant_uuid = all_variants[variant_list_field][0]['uuid']
end

Then(/^this variant has confirmed field: "([^"]*)" and comment field: "([^"]*)"$/) do |confirmed, comment|
  this_variant = find_variant(@retrieved_patient, @current_variant_uuid)
  this_variant['confirmed'].should == convert_string_to_bool(confirmed)
  this_variant['comment'].should == comment
end

# we don't have status_date in variant level
# And(/^this variant has correct status_date value$/) do
#   this_variant = find_variant(@retrieved_patient, @current_variant_uuid)
#   currentTime = Time.now.utc.to_i
#   returnedResult = DateTime.parse(this_variant['status_date']).to_i
#   timeDiff = currentTime - returnedResult
#   timeDiff.should >=0
#   timeDiff.should <=20
# end

Then(/^variants in variant report \(surgical_event_id: "([^"]*)", molecular_id: "([^"]*)", analysis_id: "([^"]*)"\) has confirmed: "([^"]*)"$/) do |sei, moi, ani, confirmed|
  variant_report = find_variant_report(@retrieved_patient, sei, moi, ani)

  variants = variant_report['variants']
  variants.each {|key, value|
    value.each{|variant|
      expect_result = "variant uuid: #{variant['uuid']}, confirmed = #{confirmed}"
      actual_result = "variant uuid: #{variant['uuid']}, confirmed = #{variant['confirmed']}"
      actual_result.should == expect_result
    }
  }
end

def convert_string_to_bool(string)
  case string
    when 'true' then true
    when 'false' then false
    when 'null' then nil
  end
end

def find_variant_report (patient_json, sei, moi, ani)
  variant_reports = patient_json['variant_reports']
  variant_reports.each do |thisVariantReport|
    is_this = true
    is_this = is_this && (thisVariantReport['surgical_event_id'] == sei)
    is_this = is_this && (thisVariantReport['molecular_id'] == moi)
    is_this = is_this && (thisVariantReport['analysis_id'] == ani)
    if is_this
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

