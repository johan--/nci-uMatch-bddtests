#!/usr/bin/ruby
require 'rspec'
require 'json'
require_relative '../../../support/helper_methods.rb'
require_relative '../../../support/patient_helper_methods.rb'
require_relative '../../../support/cog_helper_methods.rb'

Given(/^patient: "([^"]*)" with status: "([^"]*)" on step: "([^"]*)"$/) do |patient_id, patient_status, step_number|
  @patient_id = patient_id
  @patient_status = patient_status
  @patient_step_number = step_number
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

Given(/^this patients's active analysis_id is "([^"]*)"$/) do |ani|
    @active_ani = ani
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

Then(/^"([^"]*)" specimen shipped with molecular_id or slide_barcode: "([^"]*)"$/) do |type, id|
  @request_hash = Patient_helper_methods.load_patient_message_templates("specimen_shipped_#{type}")
  @request_hash['specimen_shipped']['patient_id'] = @patient_id
  @request_hash['specimen_shipped']['shipped_dttm'] = Helper_Methods.getDateAsRequired('current')
  case type
    when 'TISSUE'
      @request_hash['specimen_shipped']['surgical_event_id'] = @active_sei
      @request_hash['specimen_shipped']['molecular_id'] = id
      @active_ts_moi = id
    when 'SLIDE'
      @request_hash['specimen_shipped']['surgical_event_id'] = @active_sei
      @request_hash['specimen_shipped']['slide_barcode'] = id
      @active_barcode = id
    when 'BLOOD'
      @request_hash['specimen_shipped']['molecular_id'] = id
      @active_bd_moi = id
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
  @request_hash['result'] = result
  post_to_trigger
  validate_response('Success', 'successfully')
end

Then(/^pathology confirmed with status: "([^"]*)"$/) do |status|
  @request_hash = Patient_helper_methods.load_patient_message_templates('pathology_status')
  @request_hash['patient_id'] = @patient_id
  @request_hash['surgical_event_id'] = @active_sei
  @request_hash['reported_date'] = Helper_Methods.getDateAsRequired('current')
  @request_hash['status'] = result
  post_to_trigger
  validate_response('Success', 'successfully')
end

Then(/^"([^"]*)" variant report uploaded with analysis_id: "([^"]*)"$/) do |type, ani|
  @request_hash = Patient_helper_methods.load_patient_message_templates('variant_file_uploaded')
  @request_hash['patient_id'] = @patient_id
  @request_hash['molecular_id'] = case type
                                    when 'TISSUE' then @active_ts_moi
                                    when 'BLOOD' then @active_bd_moi  
                                  end
  @request_hash['analysis_id'] = ani
  @active_ani = ani
  post_to_trigger
  validate_response('Success', 'successfully')
end

Then(/^"([^"]*)" variant report confirmed with status: "([^"]*)"$/) do |type, status|
  @request_hash = Patient_helper_methods.load_patient_message_templates('variant_file_confirmed')
  @request_hash['patient_id'] = @patient_id
  @request_hash['molecular_id'] = case type
                                    when 'TISSUE' then @active_ts_moi
                                    when 'BLOOD' then @active_bd_moi
                                  end
  @request_hash['analysis_id'] = @active_ani
  @request_hash['status'] = status
  post_to_trigger
  validate_response('Success', 'successfully')
end

Then(/^API returns a message that includes "([^"]*)" with status "([^"]*)"$/) do |message, status|
  validate_response(status, message)
end


Then(/^patient has new assignment request with re\-biopsy: "([^"]*)", step number: "([^"]*)", treatment arm id: "([^"]*)", stratum id: "([^"]*)"$/) do |rebio, step_number, ta_id, stratum|
  @request_hash = Patient_helper_methods.load_patient_message_templates('request_assignment')
  @request_hash['patient_id'] = @patient_id
  @request_hash['status'] = 'REQUEST_ASSIGNMENT'
  @request_hash['rebiopsy'] = rebio
  @request_hash['status_date'] = Helper_Methods.getDateAsRequired('current')
  @request_hash['step_number'] = step_number
  @request_hash['treatment_arm_id'] = ta_id
  @request_hash['stratum_id'] = stratum

  post_to_trigger
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

Then(/^patient has on treatment arm approval with treatment arm id: "([^"]*)", stratum id: "([^"]*)" to step: "([^"]*)"$/) do |ta_id, stratum, step_number|
  @request_hash = Patient_helper_methods.load_patient_message_templates('on_treatment_arm')
  @request_hash['patient_id'] = @patient_id
  @request_hash['assignment_date'] = Helper_Methods.getDateAsRequired('current')
  @request_hash['step_number'] = step_number
  @request_hash['treatment_arm_id'] = ta_id
  @request_hash['stratum_id'] = stratum

  post_to_trigger
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
  @request_hash = Patient_helper_methods.load_patient_message_templates('assignment_confirmed')
  @request_hash['patient_id'] = @patient_id
  @request_hash['status'] = status
  @request_hash['molecular_id'] = @active_ts_moi
  @request_hash['analysis_id'] = @active_ani

  post_to_trigger
  validate_response('Success', 'successfully')
end

def post_to_trigger
  puts JSON.pretty_generate(@request_hash)
  @response = Helper_Methods.post_request(ENV['patients_endpoint']+'/'+@patient_id, @request_hash.to_json.to_s)
  sleep(15.0)
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