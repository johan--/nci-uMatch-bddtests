#!/usr/bin/ruby
require 'rspec'
require 'json'
require_relative '../../../support/helper_methods.rb'
require_relative '../../../support/patient_helper_methods.rb'
require_relative '../../../support/cog_helper_methods.rb'

Given(/^reset COG patient data: "([^"]*)"$/) do |patient_id|
  @response = COG_helper_methods.reset_patient_data(patient_id)
  validate_response('Success', 'reset')
end

Given(/^patient: "([^"]*)" with status: "([^"]*)" on step: "([^"]*)"$/) do |patient_id, patient_status, step_number|
  @patient_id = patient_id
  @patient_status = patient_status
  @patient_step_number = step_number
end

Given(/^patient is currently on treatment arm: "([^"]*)", stratum: "([^"]*)"$/) do |ta_id, stratum|
  @current_stratum = stratum
  @current_ta_id = ta_id
end

Given(/^other background and comments for this patient: "([^"]*)"$/) do |arg1|
#   this is just a description step
end

Given(/^this patients's active surgical_event_id is "([^"]*)"$/) do |sei|
    @active_sei = sei
end

Given(/^this patients's active "([^"]*)" molecular_id is "([^"]*)"$/) do |type, moi|
  case type
    when 'TISSUE'
      @active_ts_moi = moi
    when 'BLOOD'
      @active_bd_moi = moi
  end
end

Given(/^this patients's active "([^"]*)" analysis_id is "([^"]*)"$/) do |type, ani|
  case type
    when 'TISSUE'
      @active_ts_ani = ani
    when 'BLOOD'
      @active_bd_ani = ani
  end
end

Given(/^patient: "([^"]*)" is registered$/) do |patient_id|
  @patient_id = patient_id
  @request_hash = Patient_helper_methods.load_patient_message_templates('registration')
  @request_hash['patient_id'] = @patient_id
  @request_hash['registration_date'] = Helper_Methods.getDateAsRequired('current')
  post_to_trigger
  validate_response('Success', 'successfully')
end

Then(/^tissue specimen received with surgical_event_id: "([^"]*)"$/) do |sei|
  @request_hash = Patient_helper_methods.load_patient_message_templates('specimen_received_TISSUE')
  @request_hash['specimen_received']['patient_id'] = @patient_id
  @request_hash['specimen_received']['surgical_event_id'] = sei
  @request_hash['specimen_received']['collected_dttm'] = Helper_Methods.getDateAsRequired('current')
  @active_sei = sei
  post_to_trigger
  validate_response('Success', 'successfully')
end

Then(/^blood specimen received$/) do
  @request_hash = Patient_helper_methods.load_patient_message_templates('specimen_received_BLOOD')
  @request_hash['specimen_received']['patient_id'] = @patient_id
  @request_hash['specimen_received']['collected_dttm'] = Helper_Methods.getDateAsRequired('current')
  post_to_trigger
  validate_response('Success', 'successfully')
end

Then(/^"([^"]*)" specimen shipped to "([^"]*)" with molecular_id or slide_barcode: "([^"]*)"$/) do |type, lab, id|
  @request_hash = Patient_helper_methods.load_patient_message_templates("specimen_shipped_#{type}")
  @request_hash['specimen_shipped']['patient_id'] = @patient_id
  @request_hash['specimen_shipped']['shipped_dttm'] = Helper_Methods.getDateAsRequired('current')
  case type
    when 'TISSUE'
      @request_hash['specimen_shipped']['surgical_event_id'] = @active_sei
      @request_hash['specimen_shipped']['molecular_id'] = id
      @active_ts_moi = id
      @active_ts_lab = lab
    when 'SLIDE'
      @request_hash['specimen_shipped']['surgical_event_id'] = @active_sei
      @request_hash['specimen_shipped']['slide_barcode'] = id
      @active_barcode = id
      @active_slide_lb = lab
    when 'BLOOD'
      @request_hash['specimen_shipped']['molecular_id'] = id
      @active_bd_moi = id
      @active_bd_lab = lab
  end
  post_to_trigger
  validate_response('Success', 'successfully')
end

Then(/^"([^"]*)" assay result received result: "([^"]*)"$/) do |type, result|
  @request_hash = Patient_helper_methods.load_patient_message_templates('assay_result_reported')
  @request_hash['patient_id'] = @patient_id
  @request_hash['surgical_event_id'] = @active_sei
  @request_hash['biomarker'] = type
  @request_hash['ordered_date'] = Helper_Methods.getDateAsRequired('one second ago')
  @request_hash['reported_date'] = Helper_Methods.getDateAsRequired('current')
  @request_hash['case_number'] = "assay_#{@active_sei}_#{@request_hash['ordered_date']}"
  @request_hash['result'] = result
  post_to_trigger
  validate_response('Success', 'successfully')
end

Then(/^pathology confirmed with status: "([^"]*)"$/) do |status|
  @request_hash = Patient_helper_methods.load_patient_message_templates('pathology_status')
  @request_hash['patient_id'] = @patient_id
  @request_hash['surgical_event_id'] = @active_sei
  @request_hash['reported_date'] = Helper_Methods.getDateAsRequired('current')
  @request_hash['status'] = status
  @request_hash['case_number'] = "pathology_#{@active_sei}_#{@request_hash['reported_date']}"
  post_to_trigger
  validate_response('Success', 'successfully')
end

Then(/^"([^"]*)" variant report uploaded with analysis_id: "([^"]*)"$/) do |type, ani|
  target_moi = case type
                 when 'TISSUE' then @active_ts_moi
                 when 'BLOOD' then @active_bd_moi
               end
  target_site = case type
                  when 'TISSUE' then @active_ts_lab
                  when 'BLOOD' then @active_bd_lab
                end
  @request_hash = Patient_helper_methods.load_patient_message_templates('variant_file_uploaded')
  @request_hash['ion_reporter_id'] = target_site.downcase
  @request_hash['molecular_id'] = target_moi
  @request_hash['analysis_id'] = ani
  case type
    when 'TISSUE'
      @active_ts_ani = ani
    when 'BLOOD'
      @active_bd_ani = ani
  end
  post_to_trigger
  validate_response('Success', 'successfully')
end

Then(/^"([^"]*)" variant\(type: "([^"]*)", field: "([^"]*)", value: "([^"]*)"\) is "([^"]*)"$/) do |specimen_type, variant_type, field, value, status|
  @request_hash = Patient_helper_methods.load_patient_message_templates('variant_confirmed')
  uuid = find_variant_uuid(specimen_type, variant_type, field, value)
  url = ENV['patients_endpoint'] + '/'
  url = url + 'variant/' + uuid + '/' + status
  @response = Helper_Methods.put_request(url, @request_hash.to_json.to_s)
  validate_response('Success', 'status changed to')
  sleep(15.0)
end

Then(/^"([^"]*)" variant report confirmed with status: "([^"]*)"$/) do |type, status|
  target_moi = case type
                 when 'TISSUE' then @active_ts_moi
                 when 'BLOOD' then @active_bd_moi
               end
  target_ani = case type
                 when 'TISSUE' then @active_ts_ani
                 when 'BLOOD' then @active_bd_ani
               end
  target_status = case status
                    when 'CONFIRMED' then 'confirm'
                    when 'REJECTED' then 'reject'
                  end
  @request_hash = Patient_helper_methods.load_patient_message_templates('variant_file_confirmed')
  put_vr_confirm(target_moi, target_ani, target_status)
  validate_response('Success', 'successfully')
end

Then(/^API returns a message that includes "([^"]*)" with status "([^"]*)"$/) do |message, status|
  validate_response(status, message)
end

Then(/^COG requests assignment for this patient with re\-biopsy: "([^"]*)", step number: "([^"]*)"$/) do |re_bio, step_number|
  @patient_step_number = step_number
  @response = COG_helper_methods.request_assignment(@patient_id, @patient_step_number, re_bio)
  sleep(15.0)
  validate_response('Success', 'successfully')
end

Then(/^set patient off_study on step number: "([^"]*)"$/) do |step_number|
  @request_hash = Patient_helper_methods.load_patient_message_templates('off_study')
  @request_hash['patient_id'] = @patient_id
  @request_hash['status'] = 'OFF_STUDY'
  @request_hash['status_date'] = Helper_Methods.getDateAsRequired('current')
  @request_hash['step_number'] = step_number

  post_to_trigger
  validate_response('Success', 'successfully')
end

Then(/^COG approves patient on treatment arm: "([^"]*)", stratum: "([^"]*)" to step: "([^"]*)"$/) do |ta_id, stratum, step_number|
  @current_ta_id = ta_id
  @current_stratum = stratum
  @patient_step_number = step_number
  @response = COG_helper_methods.on_treatment_arm(@patient_id, @patient_step_number, @current_ta_id, @current_stratum)
  sleep(15.0)
  validate_response('Success', 'successfully')
end

Then(/^COG received assignment status: "([^"]*)" for this patient$/) do |assignment_status|
  @response = COG_helper_methods.get_patient_assignment_status(@patient_id)

  expect_message = "Assignment status for patient #{@patient_id} is #{assignment_status}"
  actual_message = @response['message']
  if @response['message'].include?assignment_status
    actual_message = "Assignment status for patient #{@patient_id} is #{assignment_status}"
  end
  actual_message.should == expect_message
end

Then(/^assignment report is "([^"]*)"$/) do |status|
  @retrieved_patient=Helper_Methods.get_single_request(ENV['patients_endpoint']+'/'+@patient_id)
  assignment_date = @retrieved_patient['current_assignment']['date_generated']
  target_status = case status
                    when 'CONFIRMED' then 'confirm'
                    when 'REJECTED' then 'reject'
                  end
  @request_hash = Patient_helper_methods.load_patient_message_templates('assignment_confirmed')
  put_ar_confirm(target_status, assignment_date)
  validate_response('Success', 'successfully')
end

def post_to_trigger
  puts JSON.pretty_generate(@request_hash)
  @response = Helper_Methods.post_request(ENV['patients_endpoint']+'/'+@patient_id, @request_hash.to_json.to_s)
  sleep(15.0)
end

def put_vr_confirm(moi, ani, status)
  puts JSON.pretty_generate(@request_hash)
  url = ENV['patients_endpoint'] + '/'
  url = url + @patient_id + '/variant_reports/' + moi + '/' + ani + '/' + status
  @response = Helper_Methods.put_request(url, @request_hash.to_json.to_s)
end

def put_ar_confirm(status, ar_date)
  puts JSON.pretty_generate(@request_hash)
  url = ENV['patients_endpoint'] + '/'
  url = url + @patient_id + '/assignment_reports/' + ar_date + '/' + status
  @response = Helper_Methods.put_request(url, @request_hash.to_json.to_s)
end

def validate_response(expected_status, expected_partial_message)
  @response['status'].downcase.should == expected_status.downcase
  expect_message = "returned message include <#{expected_partial_message}>"
  actual_message = @response['message']
  if @response['message'].downcase.include?expected_partial_message.downcase
    actual_message = expect_message
  end
  actual_message.should == expect_message
end

def find_variant_uuid(specimen_type, variant_type, field, value)
  target_moi = case specimen_type
                 when 'BLOOD' then @active_bd_moi
                 when 'TISSUE' then @active_ts_moi
               end
  target_ani = case specimen_type
                 when 'BLOOD' then @active_bd_ani
                 when 'TISSUE' then @active_ts_ani
               end
  @retrieved_patient=Helper_Methods.get_single_request(ENV['patients_endpoint']+'/'+@patient_id)
  @retrieved_patient['variant_reports'].each { |this_vr|
    if this_vr['variant_report_type']==specimen_type && this_vr['molecular_id'] == target_moi && this_vr['analysis_id'] == target_ani
      this_vr['variants'][variant_type].each { |this_variant|
        if this_variant[field] == value
          return this_variant['uuid']
        end
      }
    end
  }
  ''
end