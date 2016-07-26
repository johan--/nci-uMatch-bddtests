#!/usr/bin/ruby
require 'rspec'
require 'json'
require_relative '../../../support/helper_methods.rb'
require_relative '../../../support/patient_helper_methods.rb'

Then(/^retrieve patient: "([^"]*)" from API$/) do |patientID|
  @retreived_patient=Helper_Methods.get_single_request(ENV['protocol']+'://'+ENV['DOCKER_HOSTNAME']+':'+ENV['patient_api_PORT']+'/patients/'+patientID)
end

Then(/^returned patient has variant report \(surgical_event_id: "([^"]*)", molecular_id: "([^"]*)", analysis_id: "([^"]*)"\) in status "([^"]*)"$/) do |sei, moi, ani, variant_report_status|
  the_variant = find_variant(@retreived_patient, sei, moi, ani)
  expect_find = "Can find variant with surgical_event_id=#{sei}, molecular_id=#{moi} and analysis_id=#{ani}"
  actual_find = expect_find
  if the_variant == nil
    actual_find = "Cannot find variant with surgical_event_id=#{sei}, molecular_id=#{moi} and analysis_id=#{ani}"
  end
  actual_find.should == expect_find

  the_variant['status'].should == variant_report_status

end

def find_variant (patient_json, sei, moi, ani)
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