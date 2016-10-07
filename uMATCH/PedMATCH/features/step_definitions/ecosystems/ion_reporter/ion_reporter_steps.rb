# !/usr/bin/ruby
# require 'rspec'
# require 'json'
require_relative '../../../support/helper_methods.rb'
require_relative '../../../support/ion_helper_methods.rb'

When(/^the ion reporter service \/version is called, the version "([^"]*)" is returned$/) do |version|
  url = "#{ENV['ion_system_endpoint']}/ion_reporters/version"
  response = Helper_Methods.simple_get_request(url)
  raise "response is expected to be a Hash, but it is a #{response.class.to_s}" unless response.is_a?(Hash)
  raise "response is expected to contain field version, but it is #{response.to_json.to_s}" unless response.keys.include?('version')
  response['version'].should == version
end


Given(/^site is "([^"]*)"$/) do |site|
  if @ion_params.nil?
    @ion_params = {}
  end
  @ion_params['site'] = site
end

Given(/^ion_reporter_id is "([^"]*)"$/) do |ion_reporter_id|
  @ion_id = ion_reporter_id
end

Then(/^add field: "([^"]*)" value: "([^"]*)" to url$/) do |field, value|
  if @ion_params.nil?
    @ion_params = {}
  end
  @ion_params[field] = value
end

When(/^call ion_reporters POST service (\d+) times, returns a message that includes "([^"]*)" with status "([^"]*)"$/) do |times, message, status|
  i = 1
  @generated_ion_ids = []
  until i > times.to_i
    # url = "#{ENV['ion_system_endpoint']}/ion_reporters"
    # url = add_parameters_to_url(url, @ion_params)
    url = prepare_ion_reporters_url
    response = Helper_Methods.post_request(url, @payload.to_json.to_s)
    validate_response(response, status, message)
    @ion_generate_date = Time.now.utc.to_i
    @generated_ion_ids.append(JSON.parse(response['message'])['ion_reporter_id'])
    i += 1
  end
end

When(/^call ion_reporters PUT service, returns a message that includes "([^"]*)" with status "([^"]*)"$/) do |message, status|
  # slash_ion_id = ''
  # if @ion_id.length>0
  #   slash_ion_id = "/#{@ion_id}"
  # end
  # url = "#{ENV['ion_system_endpoint']}/ion_reporters#{slash_ion_id}"
  url = prepare_ion_reporters_url
  response = Helper_Methods.put_request(url, @payload.to_json.to_s)
  validate_response(response, status, message)
end

When(/^call ion_reporters DELETE service, returns a message that includes "([^"]*)" with status "([^"]*)"$/) do |message, status|
  # slash_ion_id = ''
  # if @ion_id.length>0
  #   slash_ion_id = "/#{@ion_id}"
  # end
  # url = "#{ENV['ion_system_endpoint']}/ion_reporters#{slash_ion_id}"
  # url = add_parameters_to_url(url, @ion_params)
  url = prepare_ion_reporters_url
  response = Helper_Methods.delete_request(url)
  validate_response(response, status, message)
end

When(/^call ion_reporters GET service, returns a message that includes "([^"]*)" with status "([^"]*)"$/) do |message, status|
  # slash_ion_id = ''
  # if @ion_id.length>0
  #   slash_ion_id = "/#{@ion_id}"
  # end
  # url = "#{ENV['ion_system_endpoint']}/ion_reporters#{slash_ion_id}"
  # url = add_parameters_to_url(url, @ion_params)
  url = prepare_ion_reporters_url
  response = Helper_Methods.simple_get_request(url)
  validate_response(response, status, message)
end

Then(/^there are (\d+) ion_reporter_ids generated$/) do |count|
  @generated_ion_ids.length.should==count.to_i
end

Then(/^each generated ion_reporter_id should have (\d+) record$/) do |count|
  url = "#{ENV['ion_system_endpoint']}/ion_reporters"
  ion_reporters = Helper_Methods.simple_get_request(url)
  @generated_ion_ids.each { |this_ion_id|
    total = 0
    ion_reporters.each { |this_ion|
      if this_ion['ion_reporter_id']==this_ion_id
        total+=1
      end
    }
    total.should==count.to_i
  }
end

Then(/^field: "([^"]*)" for each generated ion_reporter should be: "([^"]*)"$/) do |field, value|
  converted_value = value=='null'?nil:value
  @generated_ion_ids.each { |this_ion_id|
    @ion_id = this_ion_id
    url = prepare_ion_reporters_url #"#{ENV['ion_system_endpoint']}/ion_reporters/#{this_ion_id}"
    ion_reporter = Helper_Methods.simple_get_request(url)
    ion_reporter[field].should == converted_value
  }
end

Then(/^field: "([^"]*)" for this ion_reporter should be: "([^"]*)"$/) do |field, value|
  converted_value = value=='null'?nil:value
  url = prepare_ion_reporters_url #"#{ENV['ion_system_endpoint']}/ion_reporters/#{@ion_id}"
  ion_reporter = Helper_Methods.simple_get_request(url)
  if ion_reporter.is_a?(Array)
    ion_reporter = ion_reporter[0]
  end
  ion_reporter[field].should == converted_value
end

Then(/^add field: "([^"]*)" value: "([^"]*)" to message body$/) do |field, value|
  converted_value = value=='null'?nil:value
  if @payload.nil?
    @payload = {}
  end
  @payload[field]=converted_value
end

Then(/^each generated ion_reporter_id should have (\d+) field\-value pairs$/) do |count|
  @generated_ion_ids.each { |this_ion_id|
    @ion_id = this_ion_id
    url = prepare_ion_reporters_url #"#{ENV['ion_system_endpoint']}/ion_reporters/#{this_ion_id}"
    ion_reporter = Helper_Methods.simple_get_request(url)
    ion_reporter.keys.length.should == count.to_i
  }
end

Then(/^each generated ion_reporter_id should have field: "([^"]*)"$/) do |field|
  @generated_ion_ids.each { |this_ion_id|
    @ion_id = this_ion_id
    url = prepare_ion_reporters_url #"#{ENV['ion_system_endpoint']}/ion_reporters/#{this_ion_id}"
    ion_reporter = Helper_Methods.simple_get_request(url)
    expect_result = "ion_reporter #{this_ion_id} has field: #{field}"
    actual_result = expect_result
    unless ion_reporter.keys.include?(field)
      actual_result = "ion_reporter fields: #{ion_reporter.keys.to_s} do not include #{field}"
    end
    actual_result.should == expect_result
  }
end

Then(/^updated ion_reporter should not have field: "([^"]*)"$/) do |field|
  url = prepare_ion_reporters_url #"#{ENV['ion_system_endpoint']}/ion_reporters/#{@ion_id}"
  ion_reporter = Helper_Methods.simple_get_request(url)
  expect_result = "ion_reporter #{@ion_id} doesn't have field: #{field}"
  actual_result = expect_result
  if ion_reporter.keys.include?(field)
    actual_result = "ion_reporter has fields: #{field}, value is #{ion_reporter[field]}"
  end
  actual_result.should == expect_result
end

Then(/^each generated ion_reporter_id should have correct date_ion_reporter_id_created$/) do
  @generated_ion_ids.each { |this_ion_id|
    @ion_id = this_ion_id
    url = prepare_ion_reporters_url #"#{ENV['ion_system_endpoint']}/ion_reporters/#{this_ion_id}"
    ion_reporter = Helper_Methods.simple_get_request(url)
    returned_date = DateTime.parse(ion_reporter['date_ion_reporter_id_created']).to_i
    time_diff = @ion_generate_date - returned_date
    max_diff = 5
    expect_result = "date_ion_reporter_id_created is #{DateTime.strptime(@ion_generate_date.to_s,'%s')} "
    expect_result += "(#{max_diff} seconds difference is allowed)"
    actual_result = expect_result
    if time_diff < 0 || time_diff > max_diff
      actual_result = "date_ion_reporter_id_created is #{ion_reporter['date_ion_reporter_id_created']}"
    end
    actual_result.should == expect_result
  }
end

Then(/^record total ion_reporters count$/) do
  url = "#{ENV['ion_system_endpoint']}/ion_reporters"
  ion_reporters = Helper_Methods.simple_get_request(url)
  @total_ion_count = ion_reporters.length
end

Then(/^new and old total ion_reporters counts should have (\d+) difference$/) do |diff|
  url = "#{ENV['ion_system_endpoint']}/ion_reporters"
  ion_reporters = Helper_Methods.simple_get_request(url)
  current_count = ion_reporters.length
  count_diff = current_count - @total_ion_count
  count_diff.should == diff.to_i
end







def validate_response(response, expected_status, expected_partial_message)
  response['status'].downcase.should == expected_status.downcase
  expect_message = "returned message include <#{expected_partial_message}>"
  actual_message = response['message']
  if response['message'].downcase.include?expected_partial_message.downcase
    actual_message = expect_message
  end
  actual_message.should == expect_message
end

def prepare_ion_reporters_url
  slash_ion_id = ''
  if @ion_id!=nil && @ion_id.length>0
    slash_ion_id = "/#{@ion_id}"
  end
  url = "#{ENV['ion_system_endpoint']}/ion_reporters#{slash_ion_id}"
  add_parameters_to_url(url, @ion_params)
end

def add_parameters_to_url(url, params)
  parameters = ''
  unless params.nil?
    params.each { |key, value|
      parameters += "&#{key}=#{value}"
    }
    parameters = '?' + parameters.last(parameters.length-1)
  end
  url+parameters
end