#!/usr/bin/ruby
require 'rspec'
require 'json'
require 'roo'
require_relative '../../../support/helper_methods.rb'
require_relative '../../../support/patient_helper_methods.rb'
require_relative '../../../support/cog_helper_methods.rb'

#########################################################
################   service calls   ######################
#########################################################
And(/^patient API user authorization role is "([^"]*)"$/) do |role|
  @current_auth0_role = role
end

When(/^POST to MATCH patients service$/) do
  @current_auth0_role = 'ADMIN' unless @current_auth0_role.present?
  response = Patient_helper_methods.post_to_trigger(@current_auth0_role)
end

When(/^POST to MATCH patients service, response includes "([^"]*)" with code "([^"]*)"$/) do |retMsg, code|
  @current_auth0_role = 'ADMIN' unless @current_auth0_role.present?
  response = Patient_helper_methods.post_to_trigger(@current_auth0_role)
  puts response.to_s
  actual_match_expect(response['http_code'], code)
  # actual_include_expect(response['message'], retMsg)
end

When(/^POST to MATCH patients event service, response includes "([^"]*)" with code "([^"]*)"$/) do |retMsg, code|
  @current_auth0_role = 'ADMIN' unless @current_auth0_role.present?
  response = Patient_helper_methods.post_vr_upload_event(@current_auth0_role)
  puts response.to_s
  actual_match_expect(response['http_code'], code)
  # actual_include_expect(response['message'], retMsg)
end

When(/^POST to MATCH variant report upload service, response includes "([^"]*)" with code "([^"]*)"$/) do |retMsg, code|
  @current_auth0_role = 'ADMIN' unless @current_auth0_role.present?
  response = Patient_helper_methods.post_vr_upload(@molecular_id, @current_auth0_role)
  puts response.to_s
  actual_match_expect(response['http_code'], code)
  # actual_include_expect(response['message'], retMsg)
end

When(/^POST to MATCH variant report upload service$/) do
  @current_auth0_role = 'ADMIN' unless @current_auth0_role.present?
  response = Patient_helper_methods.post_vr_upload(@molecular_id, @current_auth0_role)
  puts response.to_s
end

When(/^PUT to MATCH variant report "([^"]*)" service, response includes "([^"]*)" with code "([^"]*)"$/) do |status, retMsg, code|
  @current_auth0_role = 'ADMIN' unless @current_auth0_role.present?
  response = Patient_helper_methods.put_vr_confirm(@analysis_id, status, @current_auth0_role)
  puts response.to_s
  actual_match_expect(response['http_code'], code)
  # actual_include_expect(response['message'], retMsg)
end

When(/^PUT to MATCH variant "([^"]*)" service for this uuid, response includes "([^"]*)" with code "([^"]*)"$/) do |checked, retMsg, code|
  @current_auth0_role = 'ADMIN' unless @current_auth0_role.present?
  response = Patient_helper_methods.put_variant_confirm(@current_variant_uuid, checked, @current_auth0_role)
  puts response.to_s
  actual_match_expect(response['http_code'], code)
  # actual_include_expect(response['message'], retMsg)
end

When(/^PUT to MATCH assignment report "([^"]*)" service, response includes "([^"]*)" with code "([^"]*)"$/) do |status, retMsg, code|
  @current_auth0_role = 'ADMIN' unless @current_auth0_role.present?
  response = Patient_helper_methods.put_ar_confirm(@analysis_id, status, @current_auth0_role)
  puts response.to_s
  actual_match_expect(response['http_code'], code)
  # actual_include_expect(response['message'], retMsg)
end

When(/^GET from MATCH patient API, http code "([^"]*)" should return$/) do |code|
  url = prepare_get_url
  puts url
  @current_auth0_role = 'ADMIN' unless @current_auth0_role.present?
  response = Patient_helper_methods.get_response_and_code(url, @current_auth0_role)
  actual_match_expect(response['http_code'], code)
  @get_message = response['message']
  if response['message']==''
    @get_response = ''
  else
    @get_response = response['message_json']
  end
end

When(/^PUT to MATCH variant report rollback, response includes "([^"]*)" with code "([^"]*)"$/) do |message, code|
  @current_auth0_role = 'ADMIN' unless @current_auth0_role.present?
  response = Patient_helper_methods.put_vr_rollback(@patient_id, @current_auth0_role)
  puts response.to_s
  actual_match_expect(response['http_code'], code)
  # actual_include_expect(response['message'], retMsg)
end

When(/^PUT to MATCH assignment report rollback, response includes "([^"]*)" with code "([^"]*)"$/) do |message, code|
  @current_auth0_role = 'ADMIN' unless @current_auth0_role.present?
  response = Patient_helper_methods.put_assignment_rollback(@patient_id, @current_auth0_role)
  puts response.to_s
  actual_match_expect(response['http_code'], code)
  # actual_include_expect(response['message'], retMsg)
end

#########################################################
###############  prepare GET message  ###################
#########################################################

Given(/^patient GET service: "([^"]*)", patient id: "([^"]*)", id: "([^"]*)"$/) do |service, patient_id, id|
  @get_service_name = service
  @get_service_patient_id = patient_id
  @get_service_id = id
end

Then(/^add projection: "([^"]*)" to patient GET url$/) do |projection|
  @get_service_projections = [] if @get_service_projections.nil?
  @get_service_projections << projection
end

Then(/^add parameter field: "([^"]*)" and value: "([^"]*)" to patient GET url$/) do |field, value|
  @get_service_parameters = {} if @get_service_parameters.nil?
  @get_service_parameters[field]=value
end

def prepare_get_url
  url = ENV['patients_endpoint']
  unless @get_service_patient_id.nil? || @get_service_patient_id.length<1
    url += "/#{@get_service_patient_id}"
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

And(/^variant uuid is "([^"]*)"$/) do |uuid|
  @current_variant_uuid = uuid=='null' ? nil : uuid
end

Given(/^load template registration message for this patient$/) do
  Patient_helper_methods.load_template(@patient_id, 'registration')
end

Given(/^load template specimen type: "([^"]*)" received message for this patient$/) do |type|
  Patient_helper_methods.load_template(@patient_id, "specimen_received_#{type}")
end

Given(/^load template specimen type: "([^"]*)" shipped message for this patient$/) do |type|
  Patient_helper_methods.load_template(@patient_id, "specimen_shipped_#{type}")
end

Given(/^load template assay message for this patient$/) do
  Patient_helper_methods.load_template(@patient_id, 'assay_result_reported')
end

Given(/^load template variant file uploaded message for molecular id: "([^"]*)"$/) do |moi|
  @molecular_id = moi=='null' ? nil : moi
  Patient_helper_methods.load_template(@patient_id, 'variant_file_uploaded')
  Patient_helper_methods.update_patient_message('molecular_id', @molecular_id)
end

Given(/^load template variant file uploaded event message for this patient$/) do
  Patient_helper_methods.load_template(@patient_id, 'variant_file_uploaded_event')
end


Then(/^files for molecular_id "([^"]*)" and analysis_id "([^"]*)" are in S3$/) do |moi, ani|
  Patient_helper_methods.upload_vr_to_s3(moi, ani)
end

Then(/^upload files for molecular_id "([^"]*)" analysis_id "([^"]*)" using template "([^"]*)"$/) do |moi, ani, template|
  Patient_helper_methods.upload_vr_to_s3(moi, ani, template)
end

Given(/^load template variant confirm message for this patient$/) do
  Patient_helper_methods.load_template(@patient_id, 'variant_confirmed')
end

Given(/^load template variant report confirm message for analysis id: "([^"]*)"$/) do |ani|
  @analysis_id = ani=='null' ? nil : ani
  Patient_helper_methods.load_template(@patient_id, 'variant_file_confirmed')
end

Given(/^load template assignment report confirm message for analysis id: "([^"]*)"$/) do |ani|
  @analysis_id = ani=='null' ? nil : ani
  Patient_helper_methods.load_template(@patient_id, 'assignment_confirmed')
end

Given(/^load template on treatment arm confirm message for this patient$/) do
  Patient_helper_methods.load_template(@patient_id, 'on_treatment_arm')
end

Given(/^load template request assignment message for this patient$/) do
  Patient_helper_methods.load_template(@patient_id, 'request_assignment')
  Patient_helper_methods.update_patient_message('status', 'REQUEST_ASSIGNMENT')
end

Given(/^load template request no assignment message for this patient$/) do
  Patient_helper_methods.load_template(@patient_id, 'request_assignment')
  Patient_helper_methods.update_patient_message('status', 'REQUEST_NO_ASSIGNMENT')
  Patient_helper_methods.update_patient_message('rebiopsy', '')
end

Given(/^load template off study biopsy expired message for this patient$/) do
  Patient_helper_methods.load_template(@patient_id, 'off_study')
  Patient_helper_methods.update_patient_message('status', 'OFF_STUDY_BIOPSY_EXPIRED')
end

Given(/^load template off study message for this patient$/) do
  Patient_helper_methods.load_template(@patient_id, 'off_study')
  Patient_helper_methods.update_patient_message('status', 'OFF_STUDY')
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

Then(/^set patient variant file uploaded event message field: "([^"]*)" to value: "([^"]*)"$/) do |field, value|
  if value == 'null'
    converted_value = nil
  else
    converted_value = value
  end
  Patient_helper_methods.update_vr_event_message(field, converted_value)
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

Then(/^wait until patient is updated$/) do
  Patient_helper_methods.wait_until_patient_updated(@patient_id)
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

Then(/^wait until patient event is updated$/) do
  Patient_helper_methods.wait_until_event_updated(@patient_id)
end

# Then(/^wait until patient has (\d+) assignment reports$/) do |ar_count|
#
# end
# Then(/^patient should have assignment report \(TA id: "([^"]*)", stratum id: "([^"]*)"\) with status "([^"]*)"$/) do |arg1, arg2, arg3|
#   pending # Write code here that turns the phrase above into concrete actions
# end
# Then(/^patient should have assignment report \(report status: "([^"]*)"\) with status "([^"]*)"$/) do |arg1, arg2|
#   pending # Write code here that turns the phrase above into concrete actions
# end


#########################################################
###############  result validation  #####################
#########################################################
Then(/^there should have one patient with id "([^"]*)"$/) do |pt_id|
  patients = Patient_helper_methods.get_any_result_from_url("#{ENV['patients_endpoint']}")
  filtered = patients.select { |this_pt| this_pt['patient_id']==pt_id }
  expect(filtered.size).to eq 1
end


Then(/^patient field: "([^"]*)" should have value: "([^"]*)"$/) do |field, value|
  get_patient_if_needed
  converted_value = value=='null' ? nil : value
  actual_match_expect(@current_patient_hash[field], converted_value)
end

Then(/^patient should have selected treatment arm: "([^"]*)" with stratum id: "([^"]*)"$/) do |ta_id, stratum|
  get_patient_if_needed
  current_assignment = 'current_assignment'
  # selected_ta = 'selected_treatment_arm'
  expect(@current_patient_hash.keys).to include current_assignment
  # expect(@current_patient_hash[current_assignment].keys).to include selected_ta
  # actual_match_expect(@current_patient_hash[current_assignment][selected_ta]['treatment_arm_id'], ta_id)
  # actual_match_expect(@current_patient_hash[current_assignment][selected_ta]['stratum_id'], stratum)
  actual_match_expect(@current_patient_hash[current_assignment]['treatment_arm_id'], ta_id)
  actual_match_expect(@current_patient_hash[current_assignment]['stratum_id'], stratum)
end

And(/^patient should have prior_recommended_treatment_arms: "([^"]*)" with stratum id: "([^"]*)"$/) do |ta_id, stratum|
  url = "#{ENV['patients_endpoint']}/#{@patient_id}"
  @current_patient_hash = Patient_helper_methods.get_any_result_from_url(url)
  if ta_id.length * stratum.length > 0
    pra = 'prior_recommended_treatment_arms'
    expect(@current_patient_hash.keys).to include pra
    expect(@current_patient_hash[pra].class).to eq Array
    ta = @current_patient_hash[pra].select{|i| i['treatment_arm_id']==ta_id && i['stratum_id'] == stratum}
    expect(ta.size).to eq 1
  end
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

Then(/^patient should have one shipment with molecular_id "([^"]*)"$/) do |moi|
  url = "#{ENV['patients_endpoint']}/#{@patient_id}/specimens?molecular_id=#{moi}"
  @current_specimen = Patient_helper_methods.get_any_result_from_url(url)
end

Then(/^patient should have one specimen with surgical_event_id "([^"]*)"$/) do |sei|
  url = "#{ENV['patients_endpoint']}/#{@patient_id}/specimens?surgical_event_id=#{sei}"
  shipment = Patient_helper_methods.get_any_result_from_url(url)
  expect(shipment.size).to eq 1
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
  try_time = 0
  while try_time < 9
    @current_variant_report = Patient_helper_methods.get_any_result_from_url(url)
    break if @current_variant_report.size > 0
    puts "Retrying to get variant report #{ani}..."
    try_time += 1
    sleep 5.0
  end
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

Then(/^this patient should have "([^"]*)" assignments for analysis id "([^"]*)"$/) do |count, ani|
  url = "#{ENV['patients_endpoint']}/assignments?analysis_id=#{ani}"
  try_time = 0
  while try_time < 9
    @current_assignment = Patient_helper_methods.get_any_result_from_url(url)
    break if @current_assignment.size > 0
    puts "Retrying to get variant report #{ani}..."
    try_time += 1
    sleep 5.0
  end
  if @current_assignment.is_a?(Array)
    if @current_assignment.length==count.to_i
      @current_assignment = @current_assignment[0]
    else
      raise "Expect #{count} assignment reports returned, actually #{@current_assignment.length} returned"
    end
  else
    raise "Expect array returned, actually #{@current_assignment.class.to_s} returned"
  end
  actual_match_expect(@current_assignment['analysis_id'], ani)
end

And(/^this assignment status should be "([^"]*)"$/) do |status|
  actual_match_expect(@current_assignment['status'], status)
end

And(/^this assignment field "([^"]*)" should be "([^"]*)"$/) do |field, value|
  convert_value = value=='null' ? nil : value
  actual_match_expect(@current_assignment[field], convert_value)
end

Then(/^patient should have one variant report for analysis_id: "([^"]*)"$/) do |ani|
  url = "#{ENV['patients_endpoint']}/variant_reports?analysis_id=#{ani}"
  vrs = Patient_helper_methods.get_any_result_from_url(url)
  expect(vrs.size).to eq 1
end

Then(/^patient should "(have|not have)" variant report \(analysis_id: "([^"]*)"\)$/) do |have, ani|
  url = "#{ENV['patients_endpoint']}/variant_reports?analysis_id=#{ani}"
  response = Patient_helper_methods.get_any_result_from_url(url)
  expect(response.class).to eq Array
  case have
    when 'have'
      expect(response.size).to eq 1
    when 'not have'
      expect(response.size).to eq 0
    else
  end
end

Then(/^patient should "(have|not have)" assignment report \(analysis_id: "([^"]*)"\)$/) do |have, ani|
  url = "#{ENV['patients_endpoint']}/assignments?analysis_id=#{ani}"
  response = Patient_helper_methods.get_any_result_from_url(url)
  expect(response.class).to eq Array
  case have
    when 'have'
      expect(response.size).to be > 0
    when 'not have'
      expect(response.size).to eq 0
    else
  end

  url = "#{ENV['patients_endpoint']}/#{@patient_id}/specimen_events"
  response = Patient_helper_methods.get_any_result_from_url(url)
  expect(response.class).to eq Hash
  assignments = []
  response['tissue_specimens'].each { |this_specimen|
    this_specimen['specimen_shipments'].each { |this_shippment|
      this_shippment['analyses'].each { |this_analysis|
        if this_analysis['analysis_id'] == ani
          assignments = this_analysis['assignments']
          break
        end
      }
    }
  }
  case have
    when 'have'
      expect(assignments.size).to be > 0
    when 'not have'
      expect(assignments.size).to eq 0
    else
  end
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
end

And(/^this variant report oncomine_control pool "(1|2)" sum should be "([^"]*)"$/) do |pool, value|
  convert_value = value=='null' ? nil : value
  actual_include_expect(@current_variant_report.keys, 'oncomine_control_panel_summary')
  actual_match_expect(@current_variant_report['oncomine_control_panel_summary']["pool#{pool}Sum"], value)
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
Given(/^a random "([^"]*)" variant for analysis id "([^"]*)"$/) do |variant_type, ani|
  @analysis_id = ani=='null' ? nil : ani
  url = "#{ENV['patients_endpoint']}/variants?analysis_id=#{@analysis_id}&variant_type=#{variant_type}"
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

And(/^patient latest event field "([^"]*)" should be "([^"]*)"$/) do |field, value|
  url = "#{ENV['patients_endpoint']}/events?order=desc&entity_id=#{@patient_id}"
  events = Patient_helper_methods.get_any_result_from_url(url)
  expect(events.class).to eq Array
  expect(events.size).to be > 0
  latest_event = events[0]
  expect(latest_event.keys).to include field
  expect(latest_event[field]).to eq value
end

And(/^patient latest event_data field "([^"]*)" should be "([^"]*)"$/) do |field, value|
  url = "#{ENV['patients_endpoint']}/events?order=desc&entity_id=#{@patient_id}"
  events = Patient_helper_methods.get_any_result_from_url(url)
  expect(events.class).to eq Array
  expect(events.size).to be > 0
  latest_event = events[0]
  expect(latest_event.keys).to include 'event_data'
  expect(latest_event['event_data'].class).to eq Hash
  expect(latest_event['event_data'].keys).to include field
  expect(latest_event['event_data'][field]).to eq value
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
  expect(@get_response.to_s).to eql ''
end

Then(/^the response type should be "([^"]*)"$/) do |type|
  expect(@get_response.class.to_s).to eql type
end

And(/^the count of array elements should be (\d+)$/) do |count|
  expect(@get_response.size).to eql count.to_i
end

And(/^the count of array elements should match database table "([^"]*)"$/) do |table|
  if @get_service_parameters.nil?
    query = {}
  else
    query = @get_service_parameters
  end
  if @get_service_patient_id.present? && !query.keys.include?('patient_id')
    query['patient_id'] = @get_service_patient_id
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

And(/^response should have field "([^"]*)"/) do |field|
  expect(@get_response.keys).to include field
end


And(/^response should have (\d+) fields$/) do |field_count|
  expect(@get_response.length).to eql field_count.to_i
end

And(/^hash response should have field "([^"]*)" with value "([^"]*)"$/) do |field, value|
  expect(@get_response[field]).to eql value
end


#########################################################
############  special case validation  ##################
#########################################################

And(/^patient statistics field "([^"]*)" should have correct value$/) do |field|
  expect(@get_response.keys).to include field
  actual = @get_response[field]
  case field
    when 'number_of_patients'
      expect(actual.to_i).to eql Helper_Methods.dynamodb_table_items('patient', {}).length
    when 'number_of_patients_on_treatment_arm'
      expect(actual.to_i).to eql Helper_Methods.dynamodb_table_items('patient', {current_status: 'ON_TREATMENT_ARM'}).length
    when 'number_of_patients_with_confirmed_variant_report'
      expect(actual.to_i).to eql Helper_Methods.dynamodb_table_distinct_column('variant_report', {status: 'CONFIRMED'}, 'patient_id').length
    when 'treatment_arm_accrual'
      db_accrual = {}
      patients = Helper_Methods.dynamodb_table_items('patient', {current_status: 'ON_TREATMENT_ARM'})
      patients.each { |this_patient|
        ta = this_patient['current_assignment']['selected_treatment_arm']['treatment_arm_id']
        st = this_patient['current_assignment']['selected_treatment_arm']['stratum_id']
        vs = this_patient['current_assignment']['selected_treatment_arm']['version']
        tt = "#{ta} (#{st}, #{vs})"
        if db_accrual.keys.include?(tt)
          db_accrual[tt]['patients'] += 1
        else
          db_accrual[tt] = {'name' => ta, 'stratum_id' => st, 'patients' => 1}
        end
      }
      expect(@get_response['treatment_arm_accrual']).to eql db_accrual
    else
  end
end


And(/^patient pending_items field "([^"]*)" should have correct value$/) do |field|
  # do a get in this step, do not use @get_response which is generated from previous step, because the BDD is running parallelly
  #between previous GET step and this step there might have another test running which will change the get result
  url = prepare_get_url
  @current_auth0_role = 'ADMIN' unless @current_auth0_role.present?
  response = Patient_helper_methods.get_response_and_code(url, @current_auth0_role)['message_json']
  expect(response.keys).to include field
  actual_key_list = []
  expect_key_list = []
  patient_list = Patient_helper_methods.get_any_result_from_url(ENV['patients_endpoint'])
  skip_status = %w(OFF_STUDY OFF_STUDY_BIOPSY_EXPIRED REQUEST_NO_ASSIGNMENT)
  patient_list.each { |this_patient|
    next if skip_status.include?(this_patient['current_status'])
    case field
      when 'tissue_variant_reports'
        next unless this_patient.keys.include?('active_tissue_specimen')
        next unless this_patient['active_tissue_specimen']['variant_report_status'] == 'PENDING'
        unless expect_key_list.include?(this_patient['active_tissue_specimen']['active_analysis_id'])
          expect_key_list << this_patient['active_tissue_specimen']['active_analysis_id']
        end
      when 'assignment_reports'
        if this_patient['current_status'] == 'PENDING_CONFIRMATION'
          expect_key_list << this_patient['active_tissue_specimen']['active_analysis_id']
        end
      else
    end
  }
  response[field].each { |this_item|
    actual_key_list << this_item['analysis_id']
  }
  extra_actual = actual_key_list - expect_key_list
  absent_actual = expect_key_list - actual_key_list

  raise "These items should NOT show up in result: #{extra_actual.to_s}" if extra_actual.size > 0
  raise "These items should show up in result: #{absent_actual.to_s}" if absent_actual.size > 0
end

Then(/^there are "([^"]*)" patient "([^"]*)" pending_items have field: "([^"]*)" value: "([^"]*)"$/) do |count, type, field, value|
  expect(@get_response.class).to eql Hash
  expect(@get_response.keys).to include type
  expect_result = "There are #{count} matching results"
  actual_count = 0
  @get_response[type].each { |this_item|
    if this_item[field]==value
      actual_count += 1
    end
  }
  actual_result = "There are #{actual_count} matching results"
  expect(actual_result).to eql expect_result
end

Then(/^there are "([^"]*)" patient_limbos have field: "([^"]*)" value: "([^"]*)"$/) do |count, field, value|
  expect(@get_response.class).to eql Array
  expect_result = "There are #{count} matching results"
  actual_count = 0
  @get_response.each { |this_item|
    if this_item[field]==value
      actual_count += 1
    end
  }
  actual_result = "There are #{actual_count} matching results"
  expect(actual_result).to eql expect_result
end

Then(/^this patient patient_limbos field "([^"]*)" should be correct$/) do |field|
  expect(@get_response.class).to eql Array
  this_patient_limbos = @get_response.find { |this_item| this_item['patient_id'] == @patient_id }
  expect(this_patient_limbos).not_to eql nil
  get_patient_if_needed
  expect(this_patient_limbos[field]).to eql @current_patient_hash[field]
end

Then(/^this patient patient_limbos should have "([^"]*)" messages which contain "([^"]*)"$/) do |count, contain|
  expect(@get_response.class).to eql Array
  this_patient_limbos = @get_response.find { |this_item| this_item['patient_id'] == @patient_id }
  expect(this_patient_limbos).not_to eql nil
  expect(this_patient_limbos.keys).to include 'message'
  contain_list = contain.split('-')
  actual_list = this_patient_limbos['message']

  expect(actual_list.size).to eql count.to_i
  contain_list.each { |this_contain|
    unless actual_list.any? { |this_actual| this_actual.downcase.include?(this_contain.downcase) }
      raise "#{actual_list.to_s} is expected to contain #{this_contain}"
    end
  }
end

Then(/^this patient patient_limbos days_pending should be correct$/) do
  expect(@get_response.class).to eql Array
  this_patient_limbos = @get_response.find { |this_item| this_item['patient_id'] == @patient_id }
  ats = 'active_tissue_specimen'
  dp = 'days_pending'
  expect(this_patient_limbos).not_to eql nil
  expect(this_patient_limbos.keys).to include ats
  expect(this_patient_limbos.keys).to include dp
  collect_date = Date.parse(this_patient_limbos['active_tissue_specimen']['specimen_received_date'])
  today = Date.today
  expect_duration = (today-collect_date).to_i
  actual_duration = this_patient_limbos['days_pending'].to_i
  expect(actual_duration).to eql expect_duration
end

Then(/^this patient patient_limbos has_amoi should be "(true|false)"$/) do |has_amoi|
  expect(@get_response.class).to eql Array
  this_patient_limbos = @get_response.find { |this_item| this_item['patient_id'] == @patient_id }

  # check test PT_SC04f
  # expect(this_patient_limbos).not_to eql nil
  # expect(this_patient_limbos.keys).to include 'active_tissue_specimen'
  unless this_patient_limbos.nil?
    if this_patient_limbos['active_tissue_specimen'].keys.include?('has_amoi')
      expect(this_patient_limbos['active_tissue_specimen']['has_amoi'].to_s).to eq has_amoi
    elsif has_amoi == 'true'
      raise 'Cannot find has_amoi field'
    end
  end

end

Then(/^there are "([^"]*)" patient action_items have field: "([^"]*)" value: "([^"]*)"$/) do |count, field, value|
  expect(@get_response.class).to eql Array
  expect_result = "There are #{count} matching results"
  actual_count = 0
  @get_response.each { |this_item|
    if this_item[field]==value
      actual_count += 1
    end
  }
  actual_result = "There are #{actual_count} matching results"
  expect(actual_result).to eql expect_result
end

Then(/^there are "([^"]*)" patient action_items$/) do |count|
  expect(@get_response.class).to eql Array
  expect(@get_response.size).to eql count.to_i
end

Then(/^there are "([^"]*)" patient treatment_arm_history/) do |count|
  expect(@get_response.class).to eql Array
  expect(@get_response.size).to eql count.to_i
end

Then(/^patient treatment_arm_history should have treatment_arm: "([^"]*)", stratum: "([^"]*)", step: "([^"]*)"/) do |ta, stratum, step|
  expect(@get_response.class).to eql Array
  has = @get_response.any? { |this_ta|
    this_ta['treatment_arm_id'] == ta &&
        this_ta['stratum_id'] == stratum &&
        this_ta['step'] == step
  }
  unless has
    raise "There is NO treatment arm with id #{ta}, stratum #{stratum} and step #{step}"
  end
end

Then(/^patient treatment_arm_history should not have treatment_arm: "([^"]*)", stratum: "([^"]*)"/) do |ta, stratum|
  expect(@get_response.class).to eql Array
  has = @get_response.any? { |this_ta|
    this_ta['treatment_arm_id'] == ta &&
        this_ta['stratum_id'] == stratum
  }
  if has
    raise "There IS treatment arm with id #{ta} and stratum #{stratum}"
  end
end

Then(/^this patient tissue specimen_events should have "([^"]*)" elements/) do |count|
  expect(@get_response.class).to eql Hash
  expect(@get_response.keys).to include 'tissue_specimens'
  expect(@get_response['tissue_specimens'].class).to eql Array
  expect(@get_response['tissue_specimens'].size).to eql count.to_i
end

Then(/^this patient blood specimen_events should have "([^"]*)" specimens/) do |count|
  expect(@get_response.class).to eql Hash
  expect(@get_response.keys).to include 'blood_specimens'
  expect(@get_response['blood_specimens'].class).to eql Hash
  expect(@get_response['blood_specimens'].keys).to include 'specimens'
  expect(@get_response['blood_specimens']['specimens'].class).to eql Array
  expect(@get_response['blood_specimens']['specimens'].size).to eql count.to_i
end

Then(/^this patient specimen_events should have assignment: analysis_id "([^"]*)" and comment "([^"]*)"$/) do |ani, cmt|
  type = 'tissue_specimens'
  expect(@get_response.class).to eql Hash
  expect(@get_response.keys).to include type
  assignments = []
  @get_response[type].each { |this_specimen|
    this_specimen['specimen_shipments'].each { |this_shippment|
      this_shippment['analyses'].each { |this_analysis|
        if this_analysis['analysis_id'] == ani
          assignments = this_analysis['assignments']
          break
        end
      }
    }
  }
  expect(assignments.size).to be > 0
  target = assignments.select { |this_as| this_as['comment'] == cmt }
  expect(target.size).to eql 1
end

Then(/^this patient tissue specimen_events "([^"]*)" should have field "([^"]*)" value "([^"]*)"$/) do |moi, field, value|
  type = 'tissue_specimens'
  converted_value = value == 'null' ? nil : value
  expect(@get_response.class).to eql Hash
  expect(@get_response.keys).to include type
  has_result = false
  @get_response[type].each { |this_specimen|
    this_specimen['specimen_shipments'].each { |this_shippment|
      next unless this_shippment['molecular_id'] == moi
      has_result = true
      expect(this_shippment.keys).to include field
      expect(this_shippment[field].to_s).to eq converted_value
    }
  }
  unless has_result
    raise "Cannot find specimen shippment with molecular id #{moi}"
  end
end

Then(/^this patient tissue specimen_events "([^"]*)" allow_upload field should be "([^"]*)"$/) do |moi, allow|
  type = 'tissue_specimens'
  field = 'allow_upload'
  expect(@get_response.class).to eql Hash
  expect(@get_response.keys).to include type
  has_result = false
  @get_response[type].each { |this_specimen|
    this_specimen['specimen_shipments'].each { |this_shipment|
      next unless this_shipment['molecular_id'] == moi
      has_result = true
      if allow == 'true'
        expect(this_shipment.keys).to include field
        expect(this_shipment[field].to_s).to eq allow
      elsif this_shipment.keys.include?(field)
        expect(this_shipment[field].to_s).to eq allow
      end
    }
  }
  unless has_result
    raise "Cannot find specimen shippment with molecular id #{moi}"
  end
end

Then(/^this patient tissue specimen_events analyses "([^"]*)" should have correct "([^"]*)" file names: "([^"]*)"$/) do |ani, file_type, name|
  has_result = false
  @get_response['tissue_specimens'].each { |this_specimen|
    this_specimen['specimen_shipments'].each { |this_shipment|
      this_shipment['analyses'].each { |this_analyses|
        if this_analyses['analysis_id'] == ani
          has_result = true
          case file_type
            when 'dna'
              expect(this_analyses.keys).to include 'dna_bam_name'
              expect(this_analyses.keys).to include 'dna_bam_path_name'
              expect(this_analyses.keys).to include 'dna_bai_path_name'
              expect(this_analyses['dna_bam_name']).to eq name
              expect(this_analyses['dna_bam_path_name']).to end_with "/#{ani}/#{name}"
              expect(this_analyses['dna_bai_path_name']).to end_with "/#{ani}/#{name[0..name.size-5]}.bai"
            when 'cdna'
              expect(this_analyses.keys).to include 'cdna_bam_name'
              expect(this_analyses.keys).to include 'rna_bam_path_name'
              expect(this_analyses.keys).to include 'rna_bai_path_name'
              expect(this_analyses['cdna_bam_name']).to eq name
              expect(this_analyses['rna_bam_path_name']).to end_with "/#{ani}/#{name}"
              expect(this_analyses['rna_bai_path_name']).to end_with "/#{ani}/#{name[0..name.size-5]}.bai"
            when 'vcf'
              expect(this_analyses.keys).to include 'vcf_file_name'
              expect(this_analyses.keys).to include 'vcf_path_name'
              expect(this_analyses['vcf_file_name']).to eq name
              expect(this_analyses['vcf_path_name']).to end_with "/#{ani}/#{name[0..name.size-5]}.vcf"
          end
        end
      }
    }
  }
  unless has_result
    raise "Cannot find analyses with analysis id #{ani}"
  end
end


Then(/^this patient tissue specimen_events specimen "([^"]*)" assays number "([^"]*)" field "([^"]*)" should be "([^"]*)"$/) do |sei, order, field, value|
  has_result = false
  @get_response['tissue_specimens'].each { |this_specimen|
     if this_specimen['surgical_event_id'] == sei
       has_result = true
       assays = this_specimen['assays']
       expect(assays[order.to_i-1][field]).to eq value
     end
  }
  unless has_result
    raise "Cannot find specimen with molecular id #{moi}"
  end
end

Then(/^this patient tissue analysis_report should have correct "([^"]*)" file names: "([^"]*)"$/) do |file_type, name|
  vr = @get_response['variant_report']
  case file_type
    when 'dna'
      expect(vr.keys).to include 'dna_bam_name'
      expect(vr.keys).to include 'dna_bam_path_name'
      expect(vr.keys).to include 'dna_bai_path_name'
      expect(vr['dna_bam_name']).to eq name
      expect(vr['dna_bam_path_name']).to end_with "/#{name}"
      expect(vr['dna_bai_path_name']).to end_with "/#{name[0..name.size-5]}.bai"
    when 'cdna'
      expect(vr.keys).to include 'cdna_bam_name'
      expect(vr.keys).to include 'rna_bam_path_name'
      expect(vr.keys).to include 'rna_bai_path_name'
      expect(vr['cdna_bam_name']).to eq name
      expect(vr['rna_bam_path_name']).to end_with "/#{name}"
      expect(vr['rna_bai_path_name']).to end_with "#{name[0..name.size-5]}.bai"
    when 'vcf'
      expect(vr.keys).to include 'vcf_file_name'
      expect(vr.keys).to include 'vcf_path_name'
      expect(vr['vcf_file_name']).to eq name
      expect(vr['vcf_path_name']).to end_with "/#{name[0..name.size-5]}.vcf"
  end
end

Then(/^this patient tissue analysis_report variant field "([^"]*)" should include id "([^"]*)"$/) do |field, id|
  vr = @get_response['variant_report']
  expect(vr.keys).to include field
  expect(vr[field].class).to eq Array
  expect(vr[field].size).to be > 0
  all_ids = vr[field].collect { |this_variant| this_variant['identifier'] }
  expect(all_ids).to include id
end

Then(/^this patient analysis_report should have variant report editable: "([^"]*)"$/) do |editable|
  vr = @get_response['variant_report']
  expect(vr.keys).to include 'editable'
  expect(vr['editable'].to_s).to eq editable
end

Then(/^this patient analysis_report should have assignment report editable: "([^"]*)"$/) do |editable|
  ars = @get_response['assignments']
  ars.each { |this_ar|
    expect(this_ar.keys).to include 'editable'
    expect(this_ar['editable'].to_s).to eq editable
  }
end

Then(/^this patient blood specimen_shipments "([^"]*)" should have field "([^"]*)" value "([^"]*)"$/) do |moi, field, value|
  type = 'blood_specimens'
  shipment = 'specimen_shipments'
  converted_value = value == 'null' ? nil : value
  expect(@get_response.class).to eql Hash
  expect(@get_response.keys).to include type
  expect(@get_response[type].class).to eql Hash
  expect(@get_response[type].keys).to include shipment
  expect(@get_response[type][shipment].class).to eql Array
  has_result = false
  @get_response[type][shipment].each { |this_shipment|
    next unless this_shipment['molecular_id'] == moi
    has_result = true
    expect(this_shipment.keys).to include field
    expect(this_shipment[field].to_s).to eq converted_value
  }
  unless has_result
    raise "Cannot find specimen shippment with molecular id #{moi}"
  end
end

Then(/^save response from "([^"]*)" report download service to temp file$/) do |report_type|
  url = prepare_get_url
  file_name = "#{report_type}_report_#{@patient_id}.xlsx"
  file_path = "#{File.dirname(__FILE__)}/../../../../public/downloaded_report_files/#{file_name}"
  @current_auth0_role = 'ADMIN' unless @current_auth0_role.present?
  Helper_Methods.simple_get_download(url, file_path, true, @current_auth0_role)
end


Then(/^the saved variant report should have patient id "([^"]*)", analysis id "([^"]*)"$/) do |patient_id, ani|
  file_path = "#{File.dirname(__FILE__)}/../../../../public/downloaded_report_files/variant_report_#{@patient_id}.xlsx"
  xlsx = Roo::Spreadsheet.open(file_path)
  sheet = xlsx.sheet(0)
  actual_patient_id = sheet.cell('C', 5)
  actual_ani = sheet.cell('C', 7)
  actual_match_expect(actual_patient_id, patient_id)
  actual_match_expect(actual_ani, ani)
end

Then(/^the saved assignment report should have patient id "([^"]*)", assignment date "([^"]*)"$/) do |patient_id, date|
  file_path = "#{File.dirname(__FILE__)}/../../../../public/downloaded_report_files/assignment_report_#{@patient_id}.xlsx"
  xlsx = Roo::Spreadsheet.open(file_path)
  sheet = xlsx.sheet(0)
  actual_patient_id = sheet.cell('C', 5)
  puts sheet.cell('C', 14)
  actual_date = sheet.cell('C', 14).utc
  actual_match_expect(actual_patient_id, patient_id)
  actual_match_expect(actual_date, DateTime.parse(date).utc)
end

#1. list all patients, pick patients which have active_tissue_specimen=>variant_report_status
# and the status should be CONFIRMED
#2. get the active_tissue_specimen=>active_analysis_id into a list
#3. list all variants, only look at analysis id exist in list of #2
#4. count amois variants by active_analysis_id
#5. sort them in to 0,1,2,3,4,5+ categories
Then(/^patient amois should have correct value$/) do
  all_patients = Helper_Methods.dynamodb_table_items('patient')
  qualified_active_ani = {}
  all_patients.each { |this_patient|
    next unless this_patient.keys.include?('active_tissue_specimen')
    active_ts_specimen = this_patient['active_tissue_specimen']
    next unless active_ts_specimen.keys.include?('active_analysis_id')
    active_ani = active_ts_specimen['active_analysis_id']
    next unless active_ts_specimen.keys.include?('variant_report_status')
    next unless active_ts_specimen['variant_report_status'] == 'CONFIRMED'
    puts "more than one patient has this active ani:#{active_ani}" if qualified_active_ani.keys.include?(active_ani)
    qualified_active_ani[active_ani] = 0
  }
  all_variants = Helper_Methods.dynamodb_table_items('variant')
  all_variants.each { |this_variant|
    next unless qualified_active_ani.keys.include?(this_variant['analysis_id'])
    if this_variant.keys.include?('amois') && this_variant['amois'].size > 0
      qualified_active_ani[this_variant['analysis_id']] += 1
    end
  }

  # all_vr = Helper_Methods.dynamodb_table_items('variant_report')
  # all_vr.each { |this_vr|
  #   next unless qualified_active_ani.keys.include?(this_vr['analysis_id'])
  #   if this_vr.keys.include?('total_amois')
  #     qualified_active_ani[this_vr['analysis_id']] = this_vr['total_amois'].to_i
  #   end
  # }
  puts qualified_active_ani.select { |k, v| v.to_i==1 }
  expect = "#{qualified_active_ani.select { |k, v| v.to_i==0 }.size},"
  expect += " #{qualified_active_ani.select { |k, v| v.to_i==1 }.size},"
  expect += " #{qualified_active_ani.select { |k, v| v.to_i==2 }.size},"
  expect += " #{qualified_active_ani.select { |k, v| v.to_i==3 }.size},"
  expect += " #{qualified_active_ani.select { |k, v| v.to_i==4 }.size},"
  expect += " #{qualified_active_ani.select { |k, v| v.to_i>4 }.size}"
  actual = "#{@get_response['amois'][0]},"
  actual += " #{@get_response['amois'][1]},"
  actual += " #{@get_response['amois'][2]},"
  actual += " #{@get_response['amois'][3]},"
  actual += " #{@get_response['amois'][4]},"
  actual += " #{@get_response['amois'][5]}"

  expect(actual).to eql expect
end

Then(/^returned events should include assay event with biomacker "([^"]*)" result "([^"]*)"$/) do |biomacker, result|
  expect(@get_response.class).to eq Array
  assay_events = @get_response.select { |event|
    event['entity_id'] == @patient_id && event['event_type'] == 'assay' }
  expect(assay_events.size).to be > 0
  result = assay_events.select { |event|
    event['event_data']['assay_result'] == result && event['event_data']['biomarker']==biomacker }
  expect(result.size).to eq 1
end

Then(/^returned events should have field "([^"]*)" with "(string|date|number|array|hash)" value$/) do |field, value_type|
  expect(@get_response.class).to eq Array
  @get_response.each { |event|
    expect(event.keys).to include field
    case value_type
      when 'string'
        expect(event[field].class).to eq String
      when 'date'
        expect(Helper_Methods.is_date?(event[field])).to be true
      when 'number'
        expect(Helper_Methods.is_number?(event[field])).to be true
      when 'array'
        expect(event[field].class).to eq Array
      when 'hash'
        expect(event[field].class).to eq Hash
    end
  }
end

Then(/^returned event_data should have field "([^"]*)" with "(string|date|number|array|hash)" value$/) do |field, value_type|
  expect(@get_response.class).to eq Array
  @get_response.each { |event|
    puts event['entity_id']
    expect(event.keys).to include 'event_data'
    expect(event['event_data'].class).to eq Hash
    unless event['event_data'].has_key?(field)
      puts JSON.pretty_generate(event)
      raise "Expected #{event['event_data'].keys} to include #{field}"
    end
    case value_type
      when 'string'
        expect(event['event_data'][field].class).to eq String
      when 'date'
        expect(Helper_Methods.is_date?(event['event_data'][field])).to be true
      when 'number'
        expect(Helper_Methods.is_number?(event['event_data'][field])).to be true
      when 'array'
        expect(event['event_data'][field].class).to eq Array
      when 'hash'
        expect(event['event_data'][field].class).to eq Hash
    end
  }
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

