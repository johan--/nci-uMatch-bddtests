#!/usr/bin/ruby
require 'rspec'
require 'json'
require_relative '../../../support/helper_methods.rb'
require_relative '../../../support/patient_helper_methods.rb'
require_relative '../../../support/cog_helper_methods.rb'

#########################################################
################   service calls   ######################
#########################################################
And(/^patient API user authorization role is "([^"]*)"$/) do |role|
  @current_auth0_role = role
end

When(/^POST to MATCH patients service, response includes "([^"]*)" with code "([^"]*)"$/) do |retMsg, code|
  @current_auth0_role = 'ADMIN' unless @current_auth0_role.present?
  response = Patient_helper_methods.post_to_trigger(@current_auth0_role)
  puts response.to_s
  actual_match_expect(response['http_code'], code)
  # actual_include_expect(response['message'], retMsg)
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
  if response['message']==''
    @get_response = ''
  else
    @get_response = response['message_json']
  end
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

And(/^analysis id is "([^"]*)"$/) do |ani|
  @analysis_id = ani=='null' ? nil : ani
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

Given(/^load template variant file uploaded message for this patient$/) do
  Patient_helper_methods.load_template(@patient_id, 'variant_file_uploaded')
end

Then(/^files for molecular_id "([^"]*)" and analysis_id "([^"]*)" are in S3$/) do |moi, ani|
  Patient_helper_methods.upload_vr_to_s3(moi, ani)
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

Then(/^wait until patient has (\d+) assignment reports$/) do |ar_count|

end
Then(/^patient should have assignment report \(TA id: "([^"]*)", stratum id: "([^"]*)"\) with status "([^"]*)"$/) do |arg1, arg2, arg3|
  pending # Write code here that turns the phrase above into concrete actions
end
Then(/^patient should have assignment report \(report status: "([^"]*)"\) with status "([^"]*)"$/) do |arg1, arg2|
  pending # Write code here that turns the phrase above into concrete actions
end


#########################################################
###############  result validation  #####################
#########################################################
Then(/^patient field: "([^"]*)" should have value: "([^"]*)"$/) do |field, value|
  get_patient_if_needed
  converted_value = value=='null' ? nil : value
  actual_match_expect(@current_patient_hash[field], converted_value)
end

Then(/^patient should have selected treatment arm: "([^"]*)" with stratum id: "([^"]*)"$/) do |ta_id, stratum|
  get_patient_if_needed
  current_assignment = 'current_assignment'
  expect(@current_patient_hash.keys).to include current_assignment
  actual_match_expect(@current_patient_hash[current_assignment]['treatment_arm_id'], ta_id)
  actual_match_expect(@current_patient_hash[current_assignment]['stratum_id'], stratum)
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
  @current_variant_report = Patient_helper_methods.get_any_result_from_url(url)
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

And(/^this variant report field: "([^"]*)" should be "([^"]*)"$/) do |field, value|
  actual_include_expect(@current_variant_report.keys, field)
  convert_value = value=='null' ? nil : value
  returned_value = @current_variant_report[field]
  if returned_value.nil? || convert_value.nil?
    actual_match_expect(returned_value, convert_value)
  else
    actual_match_expect(convert_value.to_s.downcase, returned_value.to_s.downcase)
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
  expect(@get_response.keys).to include field
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
  @get_response[field].each { |this_item|
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
    unless actual_list.any? { |this_actual| this_actual.include?(this_contain) }
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
  collect_date = Date.parse(this_patient_limbos['active_tissue_specimen']['specimen_collected_date'])
  today = Date.today
  expect_duration = (today-collect_date).to_i
  actual_duration = this_patient_limbos['days_pending'].to_i
  expect(actual_duration).to eql expect_duration
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

Then(/^this patient specimen_events type "([^"]*)" should have "([^"]*)" elements/) do |type, count|
  expect(@get_response.class).to eql Hash
  expect(@get_response.keys).to include type
  expect(@get_response[type].class).to eql Array
  expect(@get_response[type].size).to eql count.to_i
end

Then(/^this patient specimen_events should have assignment: analysis_id "([^"]*)" and comment "([^"]*)"$/) do |ani, cmt|
  type = 'tissue_specimens'
  expect(@get_response.class).to eql Hash
  expect(@get_response.keys).to include type
  assignments = []
  @get_response[type]['specimen_shipments'].each { |this_shippment|
    this_shippment['analyses'].each { |this_analysis|
      if this_analysis['analysis_id'] == ani
        assignments = this_analysis['assignments']
        break
      end
    }
  }
  expect(assignments.size).to > 0
  target = assignments.select{|this_as| this_as['comment'] == cmt}
  expect(target.size).to eql 1
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
  all_variants.each{|this_variant|
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

