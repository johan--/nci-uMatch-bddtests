#!/usr/bin/ruby
require 'rspec'
require 'json'
require_relative '../../../support/helper_methods.rb'
require_relative '../../../support/patient_helper_methods.rb'
require_relative '../../../support/cog_helper_methods.rb'

Given(/^reset COG patient data: "([^"]*)"$/) do |patient_id|
  @response = COG_helper_methods.reset_patient_data(patient_id)
  # Patient_helper_methods.validate_response(@response, 'Success', 'reset')
end
Given(/^patient id is "([^"]*)" analysis_id is "([^"]*)"$/) do |pt_id, ani|
  @patient_id = pt_id
  @active_ts_ani = ani
end
# Given(/^patient: "([^"]*)" with status: "([^"]*)" on step: "([^"]*)"$/) do |patient_id, patient_status, step_number|
#   @patient_id = patient_id
#   @patient_status = patient_status
#   @patient_step_number = step_number
# end
#
# Given(/^patient is currently on treatment arm: "([^"]*)", stratum: "([^"]*)"$/) do |ta_id, stratum|
#   @current_stratum = stratum
#   @current_ta_id = ta_id
# end
#
# Given(/^other background and comments for this patient: "([^"]*)"$/) do |arg1|
# #   this is just a description step
# end
#
# Given(/^this patients's active surgical_event_id is "([^"]*)"$/) do |sei|
#     @active_sei = sei
# end
#
# Given(/^this patients's active "([^"]*)" molecular_id is "([^"]*)"$/) do |type, moi|
#   update_moi_or_barcode(type, moi)
# end
#
# Given(/^this patients's active "([^"]*)" analysis_id is "([^"]*)"$/) do |type, ani|
#   update_ani(type, ani)
# end

Given(/^patient: "([^"]*)" is registered$/) do |patient_id|
  @patient_id = patient_id
  date = Helper_Methods.getDateAsRequired('current')
  Patient_helper_methods.prepare_register(patient_id, date)
  @response = Patient_helper_methods.post_to_trigger
  code = '202'
  expect(@response['http_code']).to eq code
  Patient_helper_methods.wait_until_patient_field_is(@patient_id, 'current_status', 'REGISTRATION')
end

Then(/^tissue specimen received with surgical_event_id: "([^"]*)"$/) do |sei|
  date = Helper_Methods.getDateAsRequired('today')
  @active_sei = sei
  Patient_helper_methods.prepare_specimen_received(@patient_id, 'TISSUE', sei, date)
  @response = Patient_helper_methods.post_to_trigger
  code = '202'
  expect(@response['http_code']).to eq code
  Patient_helper_methods.wait_until_patient_field_is(@patient_id, 'current_status', 'TISSUE_SPECIMEN_RECEIVED')
end

Then(/^blood specimen received$/) do
  date = Helper_Methods.getDateAsRequired('current')
  Patient_helper_methods.prepare_specimen_received(@patient_id, 'BLOOD', '', date)
  @response = Patient_helper_methods.post_to_trigger
  code = '202'
  expect(@response['http_code']).to eq code
  Patient_helper_methods.wait_until_patient_updated(@patient_id)
end

Then(/^"([^"]*)" specimen shipped to "([^"]*)" with molecular_id or slide_barcode: "([^"]*)"$/) do |type, lab, id|
  date = Helper_Methods.getDateAsRequired('current')
  Patient_helper_methods.prepare_specimen_shipped(@patient_id, type, @active_sei, id, lab, date)

  update_moi_or_barcode(type, id)
  update_site(type, lab)
  @response = Patient_helper_methods.post_to_trigger
  code = '202'
  expect(@response['http_code']).to eq code
  if type == 'TISSUE'
    Patient_helper_methods.wait_until_patient_field_is(@patient_id, 'current_status', 'TISSUE_NUCLEIC_ACID_SHIPPED')
  elsif type == 'SLIDE'
    Patient_helper_methods.wait_until_patient_field_is(@patient_id, 'current_status', 'TISSUE_SLIDE_SPECIMEN_SHIPPED')
  else
    Patient_helper_methods.wait_until_patient_updated(@patient_id)
  end
end

Then(/^"([^"]*)" assay result received result: "([^"]*)"$/) do |type, result|
  order_date = Helper_Methods.getDateAsRequired('one second ago')
  report_date = Helper_Methods.getDateAsRequired('current')
  Patient_helper_methods.prepare_assay(@patient_id, @active_sei, type, result, order_date, report_date)
  @response = Patient_helper_methods.post_to_trigger
  code = '202'
  expect(@response['http_code']).to eq code
  Patient_helper_methods.wait_until_patient_updated(@patient_id)
end

# Then(/^pathology confirmed with status: "([^"]*)"$/) do |status|
#   report_date=Helper_Methods.getDateAsRequired('current')
#   Patient_helper_methods.prepare_pathology(@patient_id, @active_sei, status, report_date)
#   @response = Patient_helper_methods.post_to_trigger('Success', 'successfully')
#   Patient_helper_methods.wait_until_patient_updated(@patient_id)
# end

Then(/^"([^"]*)" variant report uploaded with analysis_id: "([^"]*)"$/) do |type, ani|
  target_moi = get_moi_or_barcode(type)
  target_site = get_site(type).downcase
  update_ani(type, ani)
  Patient_helper_methods.prepare_vr_upload(@patient_id, target_moi, ani, true, target_site)
  @response = Patient_helper_methods.post_to_trigger
  code = '202'
  expect(@response['http_code']).to eq code
  if type == 'TISSUE'
    Patient_helper_methods.wait_until_patient_field_is(@patient_id, 'current_status', 'TISSUE_VARIANT_REPORT_RECEIVED')
  else
    Patient_helper_methods.wait_until_patient_updated(@patient_id)
  end
end

# Then(/^requests assignment for this patient with re\-biopsy: "([^"]*)", step number: "([^"]*)"$/) do |re_bio, step_number|
#   @patient_step_number = step_number
#   Patient_helper_methods.prepare_request_assignment(@patient_id, re_bio, step_number)
#   @response = Patient_helper_methods.post_to_trigger('Success', 'successfully')
#   Patient_helper_methods.wait_until_patient_field_is(@patient_id, 'REQUEST_ASSIGNMENT')
# end

Then(/^"([^"]*)" variant\(type: "([^"]*)", field: "([^"]*)", value: "([^"]*)"\) is "([^"]*)"$/) do |specimen_type, variant_type, field, value, status|
  uuid = find_variant_uuid(specimen_type, variant_type, field, value)
  Patient_helper_methods.prepare_variant_confirm
  @response = Patient_helper_methods.put_variant_confirm(uuid, status)
  code = '200'
  expect(@response['http_code']).to eq code
  Patient_helper_methods.wait_until_patient_updated(@patient_id)
end

Then(/^"([^"]*)" variant report confirmed with status: "([^"]*)"$/) do |type, status|
  target_ani = get_ani(type)
  target_status = process_status(status)
  Patient_helper_methods.prepare_vr_confirm(@patient_id)
  @response = Patient_helper_methods.put_vr_confirm(target_ani, target_status)
  code = '200'
  expect(@response['http_code']).to eq code
  if type == 'TISSUE'
    Patient_helper_methods.wait_until_patient_field_is(@patient_id, 'current_status', "TISSUE_VARIANT_REPORT_#{status}")
  else
    Patient_helper_methods.wait_until_patient_updated(@patient_id)
  end
end

Then(/^API returns a message that includes "([^"]*)" with status "([^"]*)"$/) do |message, status|
  # Patient_helper_methods.validate_response(@response, status, message)
end

Then(/^COG requests assignment for this patient with re\-biopsy: "([^"]*)", step number: "([^"]*)"$/) do |re_bio, step_number|
  @patient_step_number = step_number
  @response = COG_helper_methods.request_assignment(@patient_id, @patient_step_number, re_bio)
  Patient_helper_methods.wait_until_patient_field_is(@patient_id, 'current_status', 'REQUEST_ASSIGNMENT')
  # Patient_helper_methods.validate_response(@response, 'Success', 'successfully')
end

Then(/^set patient off_study on step number: "([^"]*)"$/) do |step_number|
  date = Helper_Methods.getDateAsRequired('current')
  Patient_helper_methods.prepare_off_study(@patient_id, step_number, date)
  @response = Patient_helper_methods.post_to_trigger
  code = '202'
  expect(@response['http_code']).to eq code
  Patient_helper_methods.wait_until_patient_field_is(@patient_id, 'current_status', 'OFF_STUDY')
end

Then(/^COG approves patient on treatment arm: "([^"]*)", stratum: "([^"]*)" to step: "([^"]*)"$/) do |ta_id, stratum, step_number|
  @current_ta_id = ta_id
  @current_stratum = stratum
  @patient_step_number = step_number
  @response = COG_helper_methods.on_treatment_arm(@patient_id, @patient_step_number, @current_ta_id, @current_stratum)
  # Patient_helper_methods.validate_response(@response, 'Success', 'successfully')
  Patient_helper_methods.wait_until_patient_field_is(@patient_id, 'current_status', 'ON_TREATMENT_ARM')
end

Then(/^assignment report is confirmed$/) do
  Patient_helper_methods.prepare_assignment_confirm(@patient_id)
  @response = Patient_helper_methods.put_ar_confirm(@active_ts_ani, 'confirm')
  code = '200'
  expect(@response['http_code']).to eq code
  Patient_helper_methods.wait_until_patient_field_is(@patient_id, 'current_status', 'PENDING_APPROVAL')
end

Then(/^patient status should be "([^"]*)"$/) do |status|
  field = 'current_status'
  patient_hash = Patient_helper_methods.wait_until_patient_field_is(@patient_id, field, status)
  expect(patient_hash[field]).to eql status
end

Then(/^patient step number should be "([^"]*)"$/) do |step_number|
  url = "#{ENV['patients_endpoint']}/#{@patient_id}"
  patient_result = Patient_helper_methods.get_any_result_from_url(url)
  expect(patient_result['current_step_number']).to eq step_number
end

Then(/^treatment arm: "([^"]*)" with stratum id: "([^"]*)" is selected$/) do |ta_id, stratum|
  url = "#{ENV['patients_endpoint']}/#{@patient_id}"
  patient_result = Patient_helper_methods.get_any_result_from_url(url)
  current_assignment = 'current_assignment'
  expect(patient_result.keys).to include current_assignment
  expect(patient_result[current_assignment]['treatment_arm_id']).to eq ta_id
  expect(patient_result[current_assignment]['stratum_id']).to eq stratum
end

def find_variant_uuid(specimen_type, variant_type, field, value)
  target_ani = get_ani(specimen_type)
  url = "#{ENV['patients_endpoint']}/variants?analysis_id=#{target_ani}&variant_type=#{variant_type}&#{field}=#{value}"
  # @retrieved_variant = Patient_helper_methods.get_any_result_from_url(url)
  @retrieved_variant=Patient_helper_methods.get_special_result_from_url(url, 15, {'analysis_id': target_ani})
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