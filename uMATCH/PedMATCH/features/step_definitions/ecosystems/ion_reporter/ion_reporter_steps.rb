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
  if @url_params.nil?
    @url_params = {}
  end
  @url_params['site'] = site
end

Given(/^control_type is "([^"]*)"$/) do |control_type|
  if @url_params.nil?
    @url_params = {}
  end
  @url_params['control_type'] = control_type
  end

Given(/^sample_control molecular id is "([^"]*)"$/) do |moi|
  @sc_moi = moi
end


  Given(/^ion_reporter_id is "([^"]*)"$/) do |ion_reporter_id|
  @ion_id = ion_reporter_id
end

Then(/^add field: "([^"]*)" value: "([^"]*)" to url$/) do |field, value|
  if @url_params.nil?
    @url_params = {}
  end
  @url_params[field] = value
end

Then(/^add projection: "([^"]*)" to url$/) do |proj|
  if @url_params.nil?
    @url_params = {}
  end
  @url_params[proj] = 'projection' #see the implementation of function add_parameters_to_url
                                  #to find why this line is coded like this
end

When(/^call ion_reporters POST service (\d+) times, returns a message that includes "([^"]*)" with status "([^"]*)"$/) do |times, message, status|
  i = 1
  @generated_ion_ids = []
  until i > times.to_i
    # url = "#{ENV['ion_system_endpoint']}/ion_reporters"
    # url = add_parameters_to_url(url, @url_params)
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
  # url = add_parameters_to_url(url, @url_params)
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
  # url = add_parameters_to_url(url, @url_params)
  url = prepare_ion_reporters_url
  response = Helper_Methods.simple_get_request(url)
  validate_response(response, status, message)
  @returned_ions = response['message_json']
end

When(/^call ion_reporters GET sample_controls service, returns a message that includes "([^"]*)" with status "([^"]*)"$/) do |message, status|
  @ion_sub_service = 'sample_controls'
  url = prepare_ion_reporters_url
  response = Helper_Methods.simple_get_request(url)
  validate_response(response, status, message)
  @returned_sample_control = response['message_json']
end

Then(/^there are (\d+) ion_reporter_ids generated$/) do |count|
  @generated_ion_ids.length.should==count.to_i
end

Then(/^each generated ion_reporter_id should have (\d+) record$/) do |count|
  url = "#{ENV['ion_system_endpoint']}/ion_reporters"
  ion_reporters = Helper_Methods.simple_get_request(url)['message_json']
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
    ion_reporter = Helper_Methods.simple_get_request(url)['message_json']
    ion_reporter[field].should == converted_value
  }
end

Then(/^field: "([^"]*)" for this ion_reporter should be: "([^"]*)"$/) do |field, value|
  converted_value = value=='null'?nil:value
  url = prepare_ion_reporters_url #"#{ENV['ion_system_endpoint']}/ion_reporters/#{@ion_id}"
  ion_reporter = Helper_Methods.simple_get_request(url)['message_json']
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

Then(/^each generated ion_reporter should have (\d+) field\-value pairs$/) do |count|
  @generated_ion_ids.each { |this_ion_id|
    @ion_id = this_ion_id
    url = prepare_ion_reporters_url #"#{ENV['ion_system_endpoint']}/ion_reporters/#{this_ion_id}"
    ion_reporter = Helper_Methods.simple_get_request(url)['message_json']
    ion_reporter.keys.length.should == count.to_i
  }
end

Then(/^each generated ion_reporter should have field: "([^"]*)"$/) do |field|
  @generated_ion_ids.each { |this_ion_id|
    @ion_id = this_ion_id
    url = prepare_ion_reporters_url #"#{ENV['ion_system_endpoint']}/ion_reporters/#{this_ion_id}"
    ion_reporter = Helper_Methods.simple_get_request(url)['message_json']
    expect_result = "ion_reporter #{this_ion_id} has field: #{field}"
    actual_result = expect_result
    unless ion_reporter.keys.include?(field)
      actual_result = "ion_reporter fields: #{ion_reporter.keys.to_s} do not include #{field}"
    end
    actual_result.should == expect_result
  }
end

Then(/^there are\|is (\d+) ion_reporter returned$/) do |count|
  if @returned_ions.is_a?(Array)
    @returned_ions.length.should == count.to_i
  elsif @returned_ions.is_a?(Hash)
    1.should == count.to_i
  else
    0.should == count.to_i
  end
end

Then(/^each returned ion_reporter should have (\d+) fields$/) do |count|
  if @returned_ions.is_a?(Array)
    @returned_ions.each { |this_ion|
      this_ion.keys.length.should == count.to_i }
  elsif @returned_ions.is_a?(Hash)
    @returned_ions.keys.length.should == count.to_i
  else
    0.should == count.to_i
  end
end

Then(/^each returned ion_reporter should have field "([^"]*)"$/) do |field|
  if @returned_ions.is_a?(Array)
    @returned_ions.each { |this_ion|
      expect_result = "ion_reporter has field: #{field}"
      actual_result = expect_result
      unless this_ion.keys.include?(field)
        actual_result = "ion_reporter fields: #{this_ion.keys.to_s} do not include #{field}"
      end
      actual_result.should == expect_result
    }
  elsif @returned_ions.is_a?(Hash)
    expect_result = "ion_reporter has field: #{field}"
    actual_result = expect_result
    unless @returned_ions.keys.include?(field)
      actual_result = "ion_reporter fields: #{@returned_ions.keys.to_s} do not include #{field}"
    end
    actual_result.should == expect_result
  else
    expect_result = 'ion_reporter should be returned'
    actual_result = 'no ion_reporter is returned'
    actual_result.should == expect_result
  end
end

Then(/^updated ion_reporter should not have field: "([^"]*)"$/) do |field|
  url = prepare_ion_reporters_url #"#{ENV['ion_system_endpoint']}/ion_reporters/#{@ion_id}"
  ion_reporter = Helper_Methods.simple_get_request(url)['message_json']
  expect_result = "ion_reporter #{@ion_id} doesn't have field: #{field}"
  actual_result = expect_result
  if ion_reporter.keys.include?(field)
    actual_result = "ion_reporter has fields: #{field}, value is #{ion_reporter[field]}"
  end
  actual_result.should == expect_result
end

Then(/^each generated ion_reporter should have correct date_ion_reporter_id_created$/) do
  @generated_ion_ids.each { |this_ion_id|
    @ion_id = this_ion_id
    url = prepare_ion_reporters_url #"#{ENV['ion_system_endpoint']}/ion_reporters/#{this_ion_id}"
    ion_reporter = Helper_Methods.simple_get_request(url)['message_json']
    returned_date = DateTime.parse(ion_reporter['date_ion_reporter_id_created']).to_i
    validate_date_diff('date_ion_reporter_id_created', @ion_generate_date, returned_date)
    # time_diff = @ion_generate_date - returned_date
    # max_diff = 5
    # expect_result = "date_ion_reporter_id_created is #{DateTime.strptime(@ion_generate_date.to_s,'%s')} "
    # expect_result += "(#{max_diff} seconds difference is allowed)"
    # actual_result = expect_result
    # if time_diff < 0 || time_diff > max_diff
    #   actual_result = "date_ion_reporter_id_created is #{ion_reporter['date_ion_reporter_id_created']}"
    # end
    # actual_result.should == expect_result
  }
end

Then(/^record total ion_reporters count$/) do
  url = "#{ENV['ion_system_endpoint']}/ion_reporters"
  ion_reporters = Helper_Methods.simple_get_request(url)['message_json']
  @total_ion_count = ion_reporters.length
end

Then(/^new and old total ion_reporters counts should have (\d+) difference$/) do |diff|
  url = "#{ENV['ion_system_endpoint']}/ion_reporters"
  ion_reporters = Helper_Methods.simple_get_request(url)['message_json']
  current_count = ion_reporters.length
  count_diff = current_count - @total_ion_count
  count_diff.should == diff.to_i
end






################################################
##############               ###################
##############sample controls###################
##############               ###################
################################################

When(/^call sample_controls POST service, returns a message that includes "([^"]*)" with status "([^"]*)"$/) do |message, status|
  url = prepare_sample_controls_url
  response = Helper_Methods.post_request(url, @payload.to_json.to_s)
  validate_response(response, status, message)
  @sc_generate_date = Time.now.utc.to_i
   @sc_moi = JSON.parse(response['message'])['molecular_id']
end

When(/^call sample_controls PUT service, returns a message that includes "([^"]*)" with status "([^"]*)"$/) do |message, status|
  url = prepare_sample_controls_url
  response = Helper_Methods.put_request(url, @payload.to_json.to_s)
  validate_response(response, status, message)
end

When(/^call sample_controls DELETE service, returns a message that includes "([^"]*)" with status "([^"]*)"$/) do |message, status|
  url = prepare_sample_controls_url
  response = Helper_Methods.delete_request(url)
  validate_response(response, status, message)
end

When(/^call sample_controls GET service, returns a message that includes "([^"]*)" with status "([^"]*)"$/) do |message, status|
  url = prepare_sample_controls_url
  response = Helper_Methods.simple_get_request(url)
  validate_response(response, status, message)
  @returned_sample_control = response['message_json']
end

Then(/^field: "([^"]*)" for generated sample_control should be: "([^"]*)"$/) do |field, value|
  converted_value = value=='null'?nil:value
  url = prepare_sample_controls_url
  sample_control = Helper_Methods.simple_get_request(url)['message_json']
  sample_control[field].should == converted_value
end

Then(/^generated sample_control should have (\d+) field\-value pairs$/) do |count|
  url = prepare_sample_controls_url
  sample_control = Helper_Methods.simple_get_request(url)['message_json']
  sample_control.keys.length.should == count.to_i
end

Then(/^generated sample_control should have field: "([^"]*)"$/) do |field|
  url = prepare_sample_controls_url
  sample_control = Helper_Methods.simple_get_request(url)['message_json']
  expect_result = "sample_control #{@sc_moi} has field: #{field}"
  actual_result = expect_result
  unless sample_control.keys.include?(field)
    actual_result = "sample_control fields: #{sample_control.keys.to_s} do not include #{field}"
  end
  actual_result.should == expect_result
end


Then(/^generated sample_control molecular id should have (\d+) record$/) do |count|
  url = "#{ENV['ion_system_endpoint']}/sample_controls"
  sample_controls = Helper_Methods.simple_get_request(url)['message_json']
  total = 0
  sample_controls.each { |this_sc|
    if this_sc['molecular_id']==@sc_moi
      total+=1
    end
  }
  total.should==count.to_i
end

Then(/^generated sample_control should have correct date_molecular_id_created/) do
    url = prepare_sample_controls_url
    sample_control = Helper_Methods.simple_get_request(url)['message_json']
    returned_date = DateTime.parse(sample_control['date_molecular_id_created']).to_i
    validate_date_diff('date_molecular_id_created', @sc_generate_date, returned_date)
end

Then(/^there are\|is (\d+) sample_control returned$/) do |count|
  if @returned_sample_control.nil?
    @returned_sample_control = []
  end
  if @returned_sample_control.is_a?(Array)
    @returned_sample_control.length.should == count.to_i
  elsif @returned_sample_control.is_a?(Hash)
    1.should == count.to_i
  else
    0.should == count.to_i
  end
end

Then(/^updated sample_control should not have field: "([^"]*)"$/) do |field|
  url = prepare_sample_controls_url
  sample_control = Helper_Methods.simple_get_request(url)['message_json']
  expect_result = "sample_control #{@sc_moi} doesn't have field: #{field}"
  actual_result = expect_result
  if sample_control.keys.include?(field)
    actual_result = "sample_control has fields: #{field}, value is #{sample_control[field]}"
  end
  actual_result.should == expect_result
end

Then(/^returned sample_control should contain molecular_id: "([^"]*)"$/) do |moi|
  if @returned_sample_control.nil?
    @returned_sample_control = []
  end
  expected_result = "Can find molecular_id: #{moi} in returned sample_controls"
  actual_result = "Cannot find molecular_id: #{moi} in returned sample_controls"
  if @returned_sample_control.is_a?(Array)
    @returned_sample_control.each { |this_sc|
      if this_sc['molecular_id']==moi
        actual_result = expected_result
        break
      end
    }
  elsif @returned_sample_control.is_a?(Hash)
    if @returned_sample_control['molecular_id']==moi
      actual_result = expected_result
    end
  else
  end
  actual_result.should == expected_result
end

Then(/^each returned sample_control should have (\d+) fields$/) do |count|
  if @returned_sample_control.is_a?(Array)
    @returned_sample_control.each { |this_sc|
      this_sc.keys.length.should == count.to_i }
  elsif @returned_sample_control.is_a?(Hash)
    @returned_sample_control.keys.length.should == count.to_i
  else
    0.should == count.to_i
  end
end

Then(/^each returned sample_control should have field "([^"]*)"$/) do |field|
  if @returned_sample_control.is_a?(Array)
    @returned_sample_control.each { |this_sc|
      expect_result = "sample_control has field: #{field}"
      actual_result = expect_result
      unless this_sc.keys.include?(field)
        actual_result = "sample_control fields: #{this_sc.keys.to_s} do not include #{field}"
      end
      actual_result.should == expect_result
    }
  elsif @returned_sample_control.is_a?(Hash)
    expect_result = "sample_control has field: #{field}"
    actual_result = expect_result
    unless @returned_sample_control.keys.include?(field)
      actual_result = "sample_control fields: #{@returned_sample_control.keys.to_s} do not include #{field}"
    end
    actual_result.should == expect_result
  else
    expect_result = 'sample_control returned'
    actual_result = 'no sample_contorl returned'
    actual_result.should == expect_result
  end
end

Then(/^record total sample_controls count$/) do
  url = "#{ENV['ion_system_endpoint']}/ion_reporters"
  ion_reporters = Helper_Methods.simple_get_request(url)['message_json']
  @total_ion_count = ion_reporters.length
end

Then(/^new and old total sample_controls counts should have (\d+) difference$/) do |diff|
  url = "#{ENV['ion_system_endpoint']}/ion_reporters"
  ion_reporters = Helper_Methods.simple_get_request(url)['message_json']
  current_count = ion_reporters.length
  count_diff = current_count - @total_ion_count
  count_diff.should == diff.to_i
end

Then(/^field: "([^"]*)" for this sample_control should be: "([^"]*)"$/) do |field, value|
  converted_value = value=='null'?nil:value
  url = prepare_sample_controls_url
  sample_control = Helper_Methods.simple_get_request(url)['message_json']
  if sample_control.is_a?(Array)
    sample_control = sample_control[0]
  end
  sample_control[field].should == converted_value
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

  slash_service = ''
  if @ion_sub_service!=nil && @ion_sub_service.length>0
    slash_service = "/#{@ion_sub_service}"
  end
  url = "#{ENV['ion_system_endpoint']}/ion_reporters#{slash_ion_id}#{slash_service}"
  add_parameters_to_url(url, @url_params)
end

def prepare_sample_controls_url
  slash_moi = ''
  if @sc_moi!=nil && @sc_moi.length>0
    slash_moi = "/#{@sc_moi}"
  end

  # slash_service = ''
  # if @ion_sub_service!=nil && @ion_sub_service.length>0
  #   slash_service = "/#{@ion_sub_service}"
  # end
  # url = "#{ENV['ion_system_endpoint']}/ion_reporters#{slash_ion_id}#{slash_service}"
  url = "#{ENV['ion_system_endpoint']}/sample_controls#{slash_moi}"

  add_parameters_to_url(url, @url_params)
end

def add_parameters_to_url(url, params)
  parameters = ''
  unless params.nil?
    params.each { |key, value|
      if value == 'projection' #this is why
        parameters += "&#{value}=#{key}"
      else
        parameters += "&#{key}=#{value}"
      end
    }
    parameters = '?' + parameters.last(parameters.length-1)
  end
  url+parameters
end

def validate_date_diff(date_field, expect_date, actual_date, max_diff_second=5)
  time_diff = expect_date - actual_date
  expect_result = "#{date_field} is #{DateTime.strptime(expect_date.to_s,'%s')} "
  expect_result += "(#{max_diff_second} seconds difference is allowed)"
  actual_result = expect_result
  if time_diff < 0 || time_diff > max_diff_second
    actual_result = "#{date_field} is #{DateTime.strptime(actual_date.to_s,'%s')}"
  end
  actual_result.should == expect_result
end