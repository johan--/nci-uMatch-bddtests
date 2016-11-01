#!/usr/bin/ruby
require 'rspec'
require 'json'
require_relative '../../../support/helper_methods.rb'
require_relative '../../../support/patient_helper_methods.rb'
require_relative '../../../support/cog_helper_methods.rb'

Given(/^reset COG patient data: "([^"]*)"$/) do |patient_id|
  @response = COG_helper_methods.reset_patient_data(patient_id)
  Patient_helper_methods.validate_response(@response, 'Success', 'reset')
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
  update_moi_or_barcode(type, moi)
end

Given(/^this patients's active "([^"]*)" analysis_id is "([^"]*)"$/) do |type, ani|
  update_ani(type, ani)
end

Given(/^patient: "([^"]*)" is registered$/) do |patient_id|
  @patient_id = patient_id
  date = Helper_Methods.getDateAsRequired('current')
  Patient_helper_methods.prepare_register(patient_id, date)
  @response = Patient_helper_methods.post_to_trigger('', '')
  Patient_helper_methods.wait_until_patient_updated(@patient_id)
end

Then(/^tissue specimen received with surgical_event_id: "([^"]*)"$/) do |sei|
  date = Helper_Methods.getDateAsRequired('today')
  @active_sei = sei
  Patient_helper_methods.prepare_specimen_received(@patient_id, 'TISSUE', sei, date)
  @response = Patient_helper_methods.post_to_trigger('', '')
  Patient_helper_methods.wait_until_patient_updated(@patient_id)
end

Then(/^blood specimen received$/) do
  date = Helper_Methods.getDateAsRequired('current')
  Patient_helper_methods.prepare_specimen_received(@patient_id, 'BLOOD', '', date)
  @response = Patient_helper_methods.post_to_trigger('', '')
  Patient_helper_methods.wait_until_patient_updated(@patient_id)
end

Then(/^"([^"]*)" specimen shipped to "([^"]*)" with molecular_id or slide_barcode: "([^"]*)"$/) do |type, lab, id|
  date = Helper_Methods.getDateAsRequired('current')
  Patient_helper_methods.prepare_specimen_shipped(@patient_id, type, @active_sei, id, lab, date)

  update_moi_or_barcode(type, id)
  update_site(type, lab)
  @response = Patient_helper_methods.post_to_trigger('', '')
  Patient_helper_methods.wait_until_patient_updated(@patient_id)
end

Then(/^"([^"]*)" assay result received result: "([^"]*)"$/) do |type, result|
  order_date = Helper_Methods.getDateAsRequired('one second ago')
  report_date = Helper_Methods.getDateAsRequired('current')
  Patient_helper_methods.prepare_assay(@patient_id, @active_sei, type, result, order_date, report_date)
  @response = Patient_helper_methods.post_to_trigger('', '')
  Patient_helper_methods.wait_until_patient_updated(@patient_id)
end

Then(/^pathology confirmed with status: "([^"]*)"$/) do |status|
  report_date=Helper_Methods.getDateAsRequired('current')
  Patient_helper_methods.prepare_pathology(@patient_id, @active_sei, status, report_date)
  @response = Patient_helper_methods.post_to_trigger('', '')
  Patient_helper_methods.wait_until_patient_updated(@patient_id)
end

Then(/^"([^"]*)" variant report uploaded with analysis_id: "([^"]*)"$/) do |type, ani|
  target_moi = get_moi_or_barcode(type)
  target_site = get_site(type).downcase
  update_ani(type, ani)
  Patient_helper_methods.prepare_vr_upload(@patient_id, target_moi, ani, true, target_site)
  @response = Patient_helper_methods.post_to_trigger('', '')
  Patient_helper_methods.wait_until_patient_updated(@patient_id)
end

Then(/^requests assignment for this patient with re\-biopsy: "([^"]*)", step number: "([^"]*)"$/) do |re_bio, step_number|
  @patient_step_number = step_number
  Patient_helper_methods.prepare_request_assignment(@patient_id, re_bio, step_number)
  @response = Patient_helper_methods.post_to_trigger('', '')
end

Then(/^"([^"]*)" variant\(type: "([^"]*)", field: "([^"]*)", value: "([^"]*)"\) is "([^"]*)"$/) do |specimen_type, variant_type, field, value, status|
  uuid = find_variant_uuid(specimen_type, variant_type, field, value)
  Patient_helper_methods.prepare_variant_confirm
  @response = Patient_helper_methods.put_variant_confirm(uuid, status, '', '')
  Patient_helper_methods.wait_until_patient_updated(@patient_id)
end

Then(/^"([^"]*)" variant report confirmed with status: "([^"]*)"$/) do |type, status|
  target_ani = get_ani(type)
  target_status = process_status(status)
  Patient_helper_methods.prepare_vr_confirm(@patient_id)
  @response = Patient_helper_methods.put_vr_confirm(target_ani, target_status, '', '')
  Patient_helper_methods.wait_until_patient_updated(@patient_id)
end

Then(/^API returns a message that includes "([^"]*)" with status "([^"]*)"$/) do |message, status|
  Patient_helper_methods.validate_response(@response, status, message)
end

Then(/^COG requests assignment for this patient with re\-biopsy: "([^"]*)", step number: "([^"]*)"$/) do |re_bio, step_number|
  @patient_step_number = step_number
  @response = COG_helper_methods.request_assignment(@patient_id, @patient_step_number, re_bio)
  Patient_helper_methods.wait_until_patient_updated(@patient_id)
  # Patient_helper_methods.validate_response(@response, 'Success', 'successfully')
end

Then(/^set patient off_study on step number: "([^"]*)"$/) do |step_number|
  date = Helper_Methods.getDateAsRequired('current')
  Patient_helper_methods.prepare_off_study(@patient_id, step_number, date)
  @response = Patient_helper_methods.post_to_trigger('Success', 'successfully')
  Patient_helper_methods.wait_until_patient_updated(@patient_id)
end

Then(/^COG approves patient on treatment arm: "([^"]*)", stratum: "([^"]*)" to step: "([^"]*)"$/) do |ta_id, stratum, step_number|
  @current_ta_id = ta_id
  @current_stratum = stratum
  @patient_step_number = step_number
  @response = COG_helper_methods.on_treatment_arm(@patient_id, @patient_step_number, @current_ta_id, @current_stratum)
  Patient_helper_methods.wait_until_patient_updated(@patient_id)
  Patient_helper_methods.validate_response(@response, 'Success', 'successfully')
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

Then(/^assignment report is confirmed$/) do
  Patient_helper_methods.prepare_assignment_confirm(@patient_id)
  @response = Patient_helper_methods.put_ar_confirm(@active_ts_ani, 'confirm', '', '')
  Patient_helper_methods.wait_until_patient_updated(@patient_id)
end

Then(/^patient status should be "([^"]*)" within (\d+) seconds$/) do |status, timeout|
  url = "#{ENV['patients_endpoint']}?patient_id=#{@patient_id}"
  patient_result = Patient_helper_methods.get_special_result_from_url(url, timeout, {'current_status':status})
  patient_result['current_status'].should == status
end

Then(/^patient status should be "([^"]*)" after (\d+) seconds$/) do |status, timeout|
  sleep(timeout.to_f)
  url = "#{ENV['patients_endpoint']}?patient_id=#{@patient_id}"
  patient_result = Patient_helper_methods.get_special_result_from_url(url, 1.0, {'current_status':status})
  patient_result['current_status'].should == status
end

Then(/^patient step number should be "([^"]*)" within (\d+) seconds$/) do |step_number, timeout|
  url = "#{ENV['patients_endpoint']}?patient_id=#{@patient_id}"
  patient_result = Patient_helper_methods.get_special_result_from_url(url, timeout, {'current_step_number':step_number})
  patient_result['current_step_number'].should == step_number
end

Then(/^patient should have selected treatment arm: "([^"]*)" with stratum id: "([^"]*)" within (\d+) seconds$/) do |ta_id, stratum, timeout|
  url = "#{ENV['patients_endpoint']}?patient_id=#{@patient_id}"
  query_hash = {'treatment_arm_id':ta_id, 'stratum_id':stratum}
  query_path = %w(current_assignment)
  patient_result = Patient_helper_methods.get_special_result_from_url(url, timeout, query_hash, query_path)
  if patient_result.keys.include?('current_assignment')
    patient_result = patient_result['current_assignment']
  end
  patient_result['treatment_arm_id'].should == ta_id
  patient_result['stratum_id'].should == stratum
end


def find_variant_uuid(specimen_type, variant_type, field, value)
  target_ani = get_ani(specimen_type)
  url = "#{ENV['patients_endpoint']}/variants?analysis_id=#{target_ani}&variant_type=#{variant_type}&#{field}=#{value}"
  # @retrieved_variant = Patient_helper_methods.get_any_result_from_url(url)
  @retrieved_variant=Patient_helper_methods.get_special_result_from_url(url, 15, {'analysis_id':target_ani})
  @retrieved_variant['uuid']
end

def update_moi_or_barcode(type, id)
  case type
    when 'TISSUE'
      @active_ts_moi = id
    when 'BLOOD'
      @active_bd_moi = id
    when 'SLIDE'
      @active_barcode = id
    else
      @active_ts_moi = id
  end
end

def get_moi_or_barcode(type)
  case type
    when 'TISSUE'
      return @active_ts_moi
    when 'BLOOD'
      return @active_bd_moi
    when 'SLIDE'
      return @active_barcode
    else
      return @active_ts_moi
  end
end

def update_ani(type, ani)
  case type
    when 'TISSUE'
      @active_ts_ani = ani
    when 'BLOOD'
      @active_bd_ani = ani
    else
      @active_ts_ani = ani
  end
end

def get_ani(type)
  case type
    when 'TISSUE'
      return @active_ts_ani
    when 'BLOOD'
      return @active_bd_ani
    else
      return @active_ts_ani
  end
end

def update_site(type, site)
  case type
    when 'TISSUE'
      @active_ts_lab = site
    when 'BLOOD'
      @active_bd_lab = site
    when 'SLIDE'
      @active_slide_lab = site
    else
      @active_ts_lab = site
  end
end

def get_site(type)
  case type
    when 'TISSUE'
      result = @active_ts_lab
    when 'BLOOD'
      result = @active_bd_lab
    when 'SLIDE'
      result = @active_slide_lab
    else
      result = @active_ts_lab
  end
  if result.nil?
    result = 'bdd_test_ion_reporter'
  end
  result
end

def process_status(status)
  case status
    when 'CONFIRMED'
      return 'confirm'
    when 'REJECTED'
      return 'reject'
    else
      return 'confirm'
  end
end