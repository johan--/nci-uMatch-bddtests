#!/usr/bin/ruby
require 'rspec'
require 'json'
require_relative '../../../support/helper_methods.rb'
require_relative '../../../support/patient_helper_methods.rb'


Given(/^that a new Assay Order is received from MDA:$/) do |msg|
  @request = Patient_helper_methods.create_assay_order_message(params={"msg"=>msg,"orderDate"=>"current"})
end