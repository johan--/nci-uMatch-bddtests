#!/usr/bin/ruby
require 'rspec'
require 'json'
require_relative '../../../support/helper_methods.rb'

When(/^call healthcheck for application "(patient_api|patient_state|patient_processor|ta_api|ta_processor|rules|admin|aliquot|sample_control|ion_reporter)", http code "([^"]*)" should be returned$/) do |app, code|
  url = case
          when 'patient_api' then 'https://pedmatch-int.nci.nih.gov/api/v1/patients/healthcheck'
          when 'patient_state' then 'https://pedmatch-int.nci.nih.gov/api/v1/patients/healthcheck'
          when 'patient_processor' then 'https://pedmatch-int.nci.nih.gov/api/v1/patients/healthcheck'
          when 'ta_api' then 'https://pedmatch-int.nci.nih.gov/api/v1/patients/healthcheck'
          when 'ta_processor' then 'https://pedmatch-int.nci.nih.gov/api/v1/patients/healthcheck'
          when 'rules' then 'https://pedmatch-int.nci.nih.gov/api/v1/patients/healthcheck'
          when 'admin' then 'https://pedmatch-int.nci.nih.gov/api/v1/patients/healthcheck'
          when 'aliquot' then 'https://pedmatch-int.nci.nih.gov/api/v1/aliquots_api/version'
          when 'sample_control' then 'https://pedmatch-int.nci.nih.gov/api/v1/sample_controls_api/version'
          when 'ion_reporter' then 'https://pedmatch-int.nci.nih.gov/api/v1/ion_reporters_api/version'
          else 'https://pedmatch-int.nci.nih.gov/api/v1/patients/healthcheck'
        end
  response = Helper_Methods.simple_get_request(url, false)
  expect(response['http_code'].to_s).to eq code
  @healthcheck = response['message_json']
end

Then(/^following key\-value pairs should be returned$/) do |table|
  table.rows_hash.each do |k, v|
    expect(@healthcheck.keys).to include k
    expect(@healthcheck[k]).to eq v
  end
end