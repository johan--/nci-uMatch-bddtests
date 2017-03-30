#!/usr/bin/ruby
require 'rspec'
require 'json'
require_relative '../../../support/helper_methods.rb'
require_relative '../../../support/uploader_helper_methods.rb'

ADULT_MATCH = 'adult_match'
PED_MATCH = 'ped_match'

############################################################################
###################                                   ######################
###################      Uploader setup and run       ######################
###################                                   ######################
############################################################################

Given(/^set match uploader config field "([^"]*)" to "([^"]*)"$/) do |field, value|
  UploaderHelperMethods.set_config(field, value)
end

Then(/^run uploader heartbeat service$/) do
  UploaderHelperMethods.run_heartbeat
end


############################################################################
###################                                   ######################
###################           Match api query         ######################
###################                                   ######################
############################################################################

When(/^GET ion_reporter "([^"]*)" healthcheck from pedmatch should response code "([^"]*)"$/) do |ir_id, code|
  @current_match = PED_MATCH
end

When(/^GET ion_reporter "([^"]*)" healthcheck from adult match should response code "([^"]*)"$/) do |ir_id, code|
  @current_match = ADULT_MATCH
end

Then(/^returned ion_reporter healthcheck ir_status should be within (\d+) seconds$/) do |second|
  pending # Write code here that turns the phrase above into concrete actions
end

And(/^returned ion_reporter healthcheck last_contact should be within (\d+) seconds$/) do |second|
  pending # Write code here that turns the phrase above into concrete actions
end

And(/^returned ion_reporter healthcheck host_name should be correct$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

And(/^returned ion_reporter healthcheck internal_ip_address should be correct$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

And(/^returned ion_reporter healthcheck field "([^"]*)" should be "([^"]*)"$/) do |field, value|
  pending # Write code here that turns the phrase above into concrete actions
end