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
  case type
    when 'TISSUE'
      @active_ts_moi = moi
    when 'BLOOD'
      @active_bd_moi = moi
    else
  end
end

Given(/^this patients's active "([^"]*)" analysis_id is "([^"]*)"$/) do |type, ani|
  case type
    when 'TISSUE'
      @active_ts_ani = ani
    when 'BLOOD'
      @active_bd_ani = ani
    else
  end
end

Given(/^patient: "([^"]*)" is registered$/) do |patient_id|
  @patient_id = patient_id
  date = Helper_Methods.getDateAsRequired('current')
  Patient_helper_methods.prepare_register(patient_id, date)
  @response = Patient_helper_methods.post_to_trigger('Success', 'successfully')
  Patient_helper_methods.wait_until_patient_updated(@patient_id)
end

Then(/^tissue specimen received with surgical_event_id: "([^"]*)"$/) do |sei|
  date = Helper_Methods.getDateAsRequired('current')
  @active_sei = sei
  Patient_helper_methods.prepare_specimen_received(@patient_id, 'TISSUE', sei, date)
  @response = Patient_helper_methods.post_to_trigger('Success', 'successfully')
  Patient_helper_methods.wait_until_patient_updated(@patient_id)
end

Then(/^blood specimen received$/) do
  date = Helper_Methods.getDateAsRequired('current')
  Patient_helper_methods.prepare_specimen_received(@patient_id, 'BLOOD', '', date)
  @response = Patient_helper_methods.post_to_trigger('Success', 'successfully')
  Patient_helper_methods.wait_until_patient_updated(@patient_id)
end

Then(/^"([^"]*)" specimen shipped to "([^"]*)" with molecular_id or slide_barcode: "([^"]*)"$/) do |type, lab, id|
  date = Helper_Methods.getDateAsRequired('current')
  Patient_helper_methods.prepare_specimen_shipped(@patient_id, type, lab, @active_sei, id, date)

  case type
    when 'TISSUE'
      @active_ts_moi = id
      @active_ts_lab = lab
    when 'SLIDE'
      @active_barcode = id
      @active_slide_lab = lab
    when 'BLOOD'
      @active_bd_moi = id
      @active_bd_lab = lab
    else
  end
  @response = Patient_helper_methods.post_to_trigger('Success', 'successfully')
  Patient_helper_methods.wait_until_patient_updated(@patient_id)
end

Then(/^"([^"]*)" assay result received result: "([^"]*)"$/) do |type, result|
  order_date = Helper_Methods.getDateAsRequired('one second ago')
  report_date = Helper_Methods.getDateAsRequired('current')
  Patient_helper_methods.prepare_assay(@patient_id, @active_sei, type, result, order_date, report_date)
  @response = Patient_helper_methods.post_to_trigger('Success', 'successfully')
  Patient_helper_methods.wait_until_patient_updated(@patient_id)
end

Then(/^pathology confirmed with status: "([^"]*)"$/) do |status|
  report_date=Helper_Methods.getDateAsRequired('current')
  Patient_helper_methods.prepare_pathology(@patient_id, @active_sei, status, report_date)
  @response = Patient_helper_methods.post_to_trigger('Success', 'successfully')
  Patient_helper_methods.wait_until_patient_updated(@patient_id)
end

Then(/^"([^"]*)" variant report uploaded with analysis_id: "([^"]*)"$/) do |type, ani|
  target_moi = case type
                 when 'TISSUE' then @active_ts_moi
                 when 'BLOOD' then @active_bd_moi
                 else @active_ts_moi
               end
  target_site = case type
                  when 'TISSUE' then @active_ts_lab
                  when 'BLOOD' then @active_bd_lab
                  else @active_ts_lab
                end
  case type
    when 'TISSUE'
      @active_ts_ani = ani
    when 'BLOOD'
      @active_bd_ani = ani
    else
  end
  Patient_helper_methods.prepare_vr_upload(@patient_id, target_site, target_moi, ani)
  @response = Patient_helper_methods.post_to_trigger('Success', 'successfully')
  Patient_helper_methods.wait_until_patient_updated(@patient_id)
end

Then(/^"([^"]*)" variant\(type: "([^"]*)", field: "([^"]*)", value: "([^"]*)"\) is "([^"]*)"$/) do |specimen_type, variant_type, field, value, status|
  uuid = find_variant_uuid(specimen_type, variant_type, field, value)
  Patient_helper_methods.prepare_variant_confirm
  @response = Patient_helper_methods.put_variant_confirm(uuid, status, 'Success', 'status changed to')
  Patient_helper_methods.wait_until_patient_updated(@patient_id)
end

Then(/^"([^"]*)" variant report confirmed with status: "([^"]*)"$/) do |type, status|
  target_ani = case type
                 when 'TISSUE' then @active_ts_ani
                 when 'BLOOD' then @active_bd_ani
                 else @active_ts_ani
               end
  target_status = case status
                    when 'CONFIRMED' then 'confirm'
                    when 'REJECTED' then 'reject'
                    else 'confirm'
                  end
  Patient_helper_methods.prepare_vr_confirm(@patient_id)
  @response = Patient_helper_methods.put_vr_confirm(target_ani, target_status, 'Success', 'successfully')
  Patient_helper_methods.wait_until_patient_updated(@patient_id)
end

Then(/^API returns a message that includes "([^"]*)" with status "([^"]*)"$/) do |message, status|
  Patient_helper_methods.validate_response(@response, status, message)
end

Then(/^COG requests assignment for this patient with re\-biopsy: "([^"]*)", step number: "([^"]*)"$/) do |re_bio, step_number|
  @patient_step_number = step_number
  @response = COG_helper_methods.request_assignment(@patient_id, @patient_step_number, re_bio)
  Patient_helper_methods.wait_until_patient_updated(@patient_id)
  Patient_helper_methods.validate_response(@response, 'Success', 'successfully')
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
  Patient_helper_methods.put_ar_confirm(@active_ts_ani, 'Success', 'successfully')
  Patient_helper_methods.wait_until_patient_updated(@patient_id)
end

Then(/^patient status should be "([^"]*)" within (\d+) seconds$/) do |status, timeout|
  url = "#{ENV['patients_endpoint']}?patient_id=#{@patient_id}"
  patient_result = Patient_helper_methods.get_result_from_url(url, 'current_status', status, timeout)
  patient_result['current_status'].should == status
end

Then(/^patient status should be "([^"]*)" after (\d+) seconds$/) do |status, timeout|
  sleep(timeout.to_f)
  url = "#{ENV['patients_endpoint']}?patient_id=#{@patient_id}"
  patient_result = Patient_helper_methods.get_result_from_url(url, 'current_status', status, 1.0)
  patient_result['current_status'].should == status
end

Then(/^patient step number should be "([^"]*)" within (\d+) seconds$/) do |step_number, timeout|
  url = "#{ENV['patients_endpoint']}?patient_id=#{@patient_id}"
  patient_result = Patient_helper_methods.get_result_from_url(url, 'current_step_number', step_number, timeout)
  patient_result['current_step_number'].should == step_number
end

# Then(/^patient should have selected treatment arm: "([^"]*)" with stratum id: "([^"]*)" within (\d+) seconds$/) do |ta_id, stratum, timeout|
#   url = "#{ENV['patients_endpoint']}?patient_id=#{@patient_id}"
#   patient_result = Patient_helper_methods.get_result_from_url(url, field, converted_value, timeout)
#   patient_result[field].should == converted_value
# end


def find_variant_uuid(specimen_type, variant_type, field, value)
  target_moi = case specimen_type
                 when 'BLOOD' then @active_bd_moi
                 when 'TISSUE' then @active_ts_moi
                 else @active_ts_moi
               end
  target_ani = case specimen_type
                 when 'BLOOD' then @active_bd_ani
                 when 'TISSUE' then @active_ts_ani
                 else @active_ts_ani
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