require_relative './spec_helper'

Given(/^I build a request param with id "([^"]*)", stratum id "([^"]*)" and version "([^"]*)"$/) do |treatment_arm_id, stratum, version|
	@treatment_arm_id = Utility.nil_if_empty(treatment_arm_id)
	@stratum_id = 	Utility.nil_if_empty(stratum)
	@version = Utility.nil_if_empty(version)

	param_array = []
	param_array << @treatment_arm_id unless @treatment_arm_id.nil?
	param_array << @stratum_id unless @stratum_id.nil?
	param_array << @version unless @version.nil?

  @query = param_array.join('/')
end

Given(/^I build a request param with id "([^"]*)"$/) do |treatment_arm_id|
  step %{I build a request param with id "#{treatment_arm_id}", stratum id "" and version ""}
end

Given(/^I build a request param with "([^"]*)" "([^"]*)" and "([^"]*)" "([^"]*)"$/) do |arg1, arg1_value, arg2, arg2_value|
  default = {
  	treatment_arm_id: '',
  	stratum_id: '',
  	version: ''
  }

  default[arg1.to_sym] = arg1_value
  default[arg2.to_sym] = arg2_value

  step %{I build a request param with id "#{default[:treatment_arm_id]}", stratum id "#{default[:stratum_id]}" and version "#{default[:version]}"}
end

When(/^I make a get call to treatment_arm_api with those parameters$/) do
  request = "#{@admin_endpoint}/api/v1/admintool/treatment_arm_api/#{@query}"
  @response = Request.get_request(request)
end

Then(/^I should retrieve one treatment arm$/) do
	response_message = JSON.parse(@response['message'])
  expect(response_message).to be_a Hash
  expect(response_message['treatment_arm_id']).to eq(@treatment_arm_id)
  expect(response_message['stratum_id']).to eq(@stratum_id)
  expect(response_message['version']).to eq(@version)
end

Then(/^I should retrieve an array of treatment arm\(s\)$/) do
	response_message = JSON.parse(@response['message'])
  expect(response_message).to be_a Array
end

Then(/^All the "([^"]*)" in all the treatment arm is "([^"]*)"$/) do |field, value|
	response_message = JSON.parse(@response['message'])
  field_collection = response_message.map { |e| e[field] }

  expected_collection = response_message.map { |ta| ta[field] == value }

  expect(expected_collection.size).to eql(response_message.size)

  field_collection.each do |f|
  	expect(f).to eql(value)
  end
end

Then(/^I should receive an appropriate message$/) do
  response_message = JSON.parse(@response['message'])
  expect(response_message).to be_a Hash
  expect(response_message['message']).to include('Unsuccessful GET from treatment arm');
end

Then(/^I should receive an empty array$/) do
  response_message = JSON.parse(@response['message'])
  expect(response_message).to be_a Array
  expect(response_message.size).to eql(0)
end
