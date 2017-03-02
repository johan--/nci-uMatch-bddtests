# !/usr/bin/ruby
require 'rspec'
require 'json'
require_relative '../../../support/helper_methods.rb'
require_relative '../../../support/ion_helper_methods.rb'


And(/^ir user authorization role is "([^"]*)"$/) do |role|
  @current_auth0_role = role
end

When(/^the ion reporter service \/version is called, the version "([^"]*)" is returned$/) do |version|
  url = "#{ENV['ion_system_endpoint']}/ion_reporters/version"
  response = Helper_Methods.simple_get_request(url)['message_json']
  raise "response is expected to be a Hash, but it is a #{response.class.to_s}" unless response.is_a?(Hash)
  raise "response is expected to contain field version, but it is #{response.to_s}" unless response.keys.include?('version')
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

Given(/^molecular id is "([^"]*)"$/) do |moi|
  @molecular_id = moi
end

And(/^analysis id is "([^"]*)"$/) do |ani|
  @analysis_id = ani=='null' ? nil : ani
end

And(/^aliquot file name is "([^"]*)"$/) do |file|
  @analysis_file = file=='null' ? nil : file
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

When(/^POST to ion_reporters service (\d+) times, response includes "([^"]*)" with code "([^"]*)"$/) do |times, message, code|
  @current_auth0_role = 'ADMIN' unless @current_auth0_role.present?
  i = 1
  @generated_ion_ids = []
  until i > times.to_i
    response = Helper_Methods.post_request(prepare_ion_reporters_url, @payload.to_json.to_s, true, @current_auth0_role)
    expect(response['http_code']).to eq code
    expect(response['message']).to include message
    @ion_generate_date = Time.now.utc.to_i
    @generated_ion_ids.append(JSON.parse(response['message'])['ion_reporter_id'])
    i += 1
  end
end

When(/^PUT to ion_reporters service, response includes "([^"]*)" with code "([^"]*)"$/) do |message, code|
  @current_auth0_role = 'ADMIN' unless @current_auth0_role.present?
  response = Helper_Methods.put_request(prepare_ion_reporters_url, @payload.to_json.to_s, true, @current_auth0_role)
  @ion_update_date = Time.now.utc.to_i
  expect(response['http_code']).to eq code
  expect(response['message']).to include message
end

When(/^DELETE to ion_reporters service, response includes "([^"]*)" with code "([^"]*)"$/) do |message, code|
  @current_auth0_role = 'ADMIN' unless @current_auth0_role.present?
  response = Helper_Methods.delete_request(prepare_ion_reporters_url, true, @current_auth0_role)
  expect(response['http_code']).to eq code
  expect(response['message']).to include message
end

When(/^GET from ion_reporters service, response includes "([^"]*)" with code "([^"]*)"$/) do |message, code|
  @current_auth0_role = 'ADMIN' unless @current_auth0_role.present?
  response = Helper_Methods.simple_get_request(prepare_ion_reporters_url, true, @current_auth0_role)
  expect(response['http_code']).to eq code
  expect(response['message']).to include message
  @returned_ions = response['message_json']
end

When(/^GET sample_controls from ion_reporters service, response includes "([^"]*)" with code "([^"]*)"$/) do |message, code|
  @current_auth0_role = 'ADMIN' unless @current_auth0_role.present?
  @ion_sub_service = 'sample_controls'
  response = Helper_Methods.simple_get_request(prepare_ion_reporters_url, true, @current_auth0_role)
  expect(response['http_code']).to eq code
  expect(response['message']).to include message
  @returned_sample_control = response['message_json']
end

Then(/^wait up to (\d+) seconds until this ion_reporter get updated$/) do |timeout|
  url = prepare_ion_reporters_url
  Helper_Methods.wait_until_updated(url, timeout.to_f)
end

Then(/^wait up to (\d+) seconds until this sample_control get updated$/) do |timeout|
  url = prepare_sample_controls_url
  @returned_sample_control_result = Helper_Methods.wait_until_updated(url, timeout.to_f)
end

Then(/^wait up to (\d+) seconds until this aliquot get updated$/) do |timeout|
  url = prepare_aliquot_url
  @returned_aliquot_result = Helper_Methods.wait_until_updated(url, timeout.to_f)
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
  converted_value = value=='null' ? nil : value
  @generated_ion_ids.each { |this_ion_id|
    @ion_id = this_ion_id
    url = prepare_ion_reporters_url #"#{ENV['ion_system_endpoint']}/ion_reporters/#{this_ion_id}"
    ion_reporter = Helper_Methods.simple_get_request(url)['message_json']
    ion_reporter[field].should == converted_value
  }
end

Then(/^field: "([^"]*)" for this ion_reporter should be: "([^"]*)"$/) do |field, value|
  converted_value = value=='null' ? nil : value
  url = prepare_ion_reporters_url #"#{ENV['ion_system_endpoint']}/ion_reporters/#{@ion_id}"
  ion_reporter = Helper_Methods.simple_get_request(url)['message_json']
  if ion_reporter.is_a?(Array)
    ion_reporter = ion_reporter[0]
  end
  ion_reporter[field].should == converted_value
end

Then(/^add field: "([^"]*)" value: "([^"]*)" to message body$/) do |field, value|
  converted_value = value=='null' ? nil : value
  converted_value = true if value == 'true'
  converted_value = false if value == 'false'
  if @payload.nil?
    @payload = {}
  end
  @payload[field]=converted_value
end

Then(/^last_contact for this ion_reporter should have correct value$/) do
  url = prepare_ion_reporters_url
  ion_reporter = Helper_Methods.simple_get_request(url)['message_json']
  if ion_reporter.is_a?(Array)
    ion_reporter = ion_reporter[0]
  end
  returned_date = DateTime.parse(ion_reporter['last_contact']).to_i
  validate_date_diff('last_contact', @ion_update_date, returned_date)
end

Then(/^last_contact for this ion_reporter healthcheck should have correct value$/) do
  url = prepare_ion_healthcheck_url
  ion_reporter = Helper_Methods.simple_get_request(url)['message_json']
  if ion_reporter.is_a?(Array)
    ion_reporter = ion_reporter[0]
  end
  returned_date = DateTime.parse(ion_reporter['last_contact']).to_i
  validate_date_diff('last_contact', @ion_update_date, returned_date)
end

Then(/^ir_status for this ion_reporter healthcheck should be less than (\d+) seconds$/) do |seconds|
  url = prepare_ion_healthcheck_url
  ion_reporter = Helper_Methods.simple_get_request(url)['message_json']
  if ion_reporter.is_a?(Array)
    ion_reporter = ion_reporter[0]
  end
  ir_status = ion_reporter['ir_status']
  parts = ir_status.split(' ')
  numbers = parts.select { |v| !!(v =~ /\A[-+]?[0-9]+\z/) }
  actual_seconds = case numbers.size
                     when 1
                       numbers[0].to_i
                     when 2
                       numbers[0].to_i*60+numbers[1].to_i
                     when 3
                       numbers[0].to_i*3600+numbers[1].to_i*60+numbers[2].to_i
                     else
                       ir_status
                   end
  actual_seconds.should < seconds.to_i
end

Then(/^this ion_reporter healthcheck field "([^"]*)" should be "([^"]*)"$/) do |field, value|
  converted_value = value=='null' ? nil : value
  url = prepare_ion_healthcheck_url
  ion_reporter = Helper_Methods.simple_get_request(url)['message_json']
  if ion_reporter.is_a?(Array)
    ion_reporter = ion_reporter[0]
  end
  ion_reporter[field].should == converted_value
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
  puts "Current ion reporter count is #{current_count}, previous count is #{@total_ion_count}"
  count_diff = current_count - @total_ion_count
  count_diff.should == diff.to_i
end

Then(/^record all ion_reporters which has field "([^"]*)"$/) do |field|
  @recorded_ion_ids = [] unless @recorded_ion_ids.present?
  @returned_ions.each { |this_ion|
    if this_ion.has_key?(field)
      @recorded_ion_ids << this_ion['ion_reporter_id']
    end
  }
end

Then(/^ion_repoters healthcheck service result should match the recorded list$/) do
  url = prepare_ion_healthcheck_url
  ion_reporters = Helper_Methods.simple_get_request(url)['message_json']
  healthcheck_ion_ids = []
  ion_reporters.each { |this_ion|
    healthcheck_ion_ids << this_ion['ion_reporter_id'] }
  extra_actual = healthcheck_ion_ids - @recorded_ion_ids
  absent_actual = @recorded_ion_ids - healthcheck_ion_ids

  raise "These ion_reporter_id should NOT show up in result: #{extra_actual.to_s}" if extra_actual.size > 0
  raise "These ion_reporter_id should show up in result: #{absent_actual.to_s}" if absent_actual.size > 0

  @returned_ions.each { |this_ion|
    healthcheck_ion = ion_reporters.find { |x| x['ion_reporter_id'] == this_ion['ion_reporter_id'] }
    healthcheck_last_contact = Time.parse(healthcheck_ion['last_contact'])
    this_ion_last_contact = Time.parse(this_ion['last_contact'])
    unless healthcheck_last_contact == this_ion_last_contact
      error = "ion_reporter #{this_ion['ion_reporter_id']} last contact is #{this_ion['last_contact']}"
      error += ", but its healthcheck last contact is #{healthcheck_ion['last_contact']}"
      raise error
    end
  }
end
################################################
##############               ###################
##############sample controls###################
##############               ###################
################################################

When(/^POST to sample_controls service, response includes "([^"]*)" with code "([^"]*)"$/) do |message, code|
  @current_auth0_role = 'ADMIN' unless @current_auth0_role.present?
  response = Helper_Methods.post_request(prepare_sample_controls_url, @payload.to_json.to_s, true, @current_auth0_role)
  puts response.to_s
  expect(response['http_code']).to eq code
  expect(response['message']).to include message
  @sc_generate_date = Time.now.utc.to_i
  @molecular_id = JSON.parse(response['message'])['molecular_id']
end

When(/^PUT to sample_controls service, response includes "([^"]*)" with code "([^"]*)"$/) do |message, code|
  @current_auth0_role = 'ADMIN' unless @current_auth0_role.present?
  response = Helper_Methods.put_request(prepare_sample_controls_url, @payload.to_json.to_s, true, @current_auth0_role)
  expect(response['http_code']).to eq code
  expect(response['message']).to include message
end

When(/^DELETE to sample_controls service, response includes "([^"]*)" with code "([^"]*)"$/) do |message, code|
  @current_auth0_role = 'ADMIN' unless @current_auth0_role.present?
  response = Helper_Methods.delete_request(prepare_sample_controls_url, true, @current_auth0_role)
  expect(response['http_code']).to eq code
  expect(response['message']).to include message
end

When(/^GET from sample_controls service, response includes "([^"]*)" with code "([^"]*)"$/) do |message, code|
  @current_auth0_role = 'ADMIN' unless @current_auth0_role.present?
  response = Helper_Methods.simple_get_request(prepare_sample_controls_url, true, @current_auth0_role)
  expect(response['http_code']).to eq code
  expect(response['message']).to include message
  @returned_sample_control = response['message_json']
end

Then(/^if sample_control list returned, it should have editable: "([^"]*)"$/) do |editable|
  field = 'editable'
  if @returned_aliquot_result.is_a?(Hash) && @returned_aliquot_result.keys.include?('molecular_id_type')
    expect(@returned_aliquot_result.keys).to include field
    expect(contains[0][field]).to eql editable
  end
end

Then(/^if aliquot returned, it should have editable: "([^"]*)"$/) do |editable|
  if @returned_sample_control.is_a?(Array)
    contains = @returned_sample_control.select { |h| h.keys.include?('editable') }
    raise "returned sample control list doesn't have 'editable' field" if contains.size<1
    expect(contains[0]['editable']).to eql editable
  end
end

Then(/^field: "([^"]*)" for generated sample_control should be: "([^"]*)"$/) do |field, value|
  converted_value = value=='null' ? nil : value
  url = prepare_sample_controls_url
  sample_control = Helper_Methods.simple_get_request(url)['message_json']
  sample_control[field].to_s.should == converted_value.to_s
end

Then(/^generated sample_control should have (\d+) field\-value pairs$/) do |count|
  url = prepare_sample_controls_url
  sample_control = Helper_Methods.simple_get_request(url)['message_json']
  sample_control.keys.length.should == count.to_i
end

Then(/^generated sample_control should have field: "([^"]*)"$/) do |field|
  url = prepare_sample_controls_url
  sample_control = Helper_Methods.simple_get_request(url)['message_json']
  expect_result = "sample_control #{@molecular_id} has field: #{field}"
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
    if this_sc['molecular_id']==@molecular_id
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

Then(/^sample_control should not have field: "([^"]*)"$/) do |field|
  url = prepare_sample_controls_url
  sample_control = Helper_Methods.simple_get_request(url)['message_json']
  expect_result = "sample_control #{@molecular_id} doesn't have field: #{field}"
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
  url = "#{ENV['ion_system_endpoint']}/sample_controls"
  sample_controls = Helper_Methods.simple_get_request(url)['message_json']
  @total_sc_count = sample_controls.length
end

Then(/^new and old total sample_controls counts should have (\d+) difference$/) do |diff|
  url = "#{ENV['ion_system_endpoint']}/sample_controls"
  sample_controls = Helper_Methods.simple_get_request(url)['message_json']
  current_count = sample_controls.length
  puts "Current sample control count is #{current_count}, previous count is #{@total_sc_count}"
  count_diff = current_count - @total_sc_count
  count_diff.should == diff.to_i
end

Then(/^field: "([^"]*)" for this sample_control should be: "([^"]*)"$/) do |field, value|
  converted_value = value=='null' ? nil : value
  url = prepare_sample_controls_url
  sample_control = Helper_Methods.simple_get_request(url)['message_json']
  if sample_control.is_a?(Array)
    sample_control = sample_control[0]
  end
  sample_control[field].to_s.should == converted_value.to_s
end


################################################
##############               ###################
##############    aliquot   ###################
##############               ###################
################################################
Then(/^PUT to aliquot service, response includes "([^"]*)" with code "([^"]*)"$/) do |message, code|
  @current_auth0_role = 'ADMIN' unless @current_auth0_role.present?
  response = Helper_Methods.put_request(prepare_aliquot_url, @payload.to_json.to_s, true, @current_auth0_role)
  expect(response['http_code']).to eq code
  expect(response['message']).to include message
end

When(/^GET from aliquot service, response "([^"]*)" with code "([^"]*)"$/) do |message, code|
  @current_auth0_role = 'ADMIN' unless @current_auth0_role.present?
  response = Helper_Methods.simple_get_request(prepare_aliquot_url, true, @current_auth0_role)
  expect(response['http_code']).to eq code
  expect(response['message']).to include message
  @returned_aliquot_result = response['message_json']
end

When(/^POST to aliquot service, response includes "([^"]*)" with code "([^"]*)"$/) do |message, code|
  @current_auth0_role = 'ADMIN' unless @current_auth0_role.present?
  response = Helper_Methods.post_request(prepare_aliquot_url, @payload.to_json.to_s, true, @current_auth0_role)
  expect(response['http_code']).to eq code
  expect(response['message']).to include message
end

When(/^DELETE to aliquot service, response includes "([^"]*)" with code "([^"]*)"$/) do |message, code|
  @current_auth0_role = 'ADMIN' unless @current_auth0_role.present?
  response = Helper_Methods.delete_request(prepare_aliquot_url, true, @current_auth0_role)
  expect(response['http_code']).to eq code
  expect(response['message']).to include message
end

Then(/^field: "([^"]*)" for this aliquot should be: "([^"]*)"$/) do |field, value|
  converted_value = value=='null' ? nil : value
  @returned_aliquot_result[field].should == converted_value
end

# doesn't have varaint_report field anymore, this field has been flatten into root
# Then(/^field: "([^"]*)" for this aliquot variant_report should be: "([^"]*)"$/) do |field, value|
#   converted_value = value=='null' ? nil : value
#   unless @returned_aliquot_result.keys.include?('variant_report')
#     raise 'This returned aliquot doesn not have variant_report field'
#   end
#   @returned_aliquot_result['variant_report'][field].should == converted_value
# end

And(/^file: "([^"]*)" should be available in S3$/) do |file|
  Helper_Methods.s3_file_exists(ENV['s3_bucket'], file).should == true
end

Then(/^call aliquot GET service, field: "([^"]*)" for this sample_control should be: "([^"]*)"$/) do |field, value|
  converted_value = value=='null' ? nil : value
  url = prepare_aliquot_url
  sample_control = Helper_Methods.simple_get_request(url)['message_json']
  puts url
  if sample_control.is_a?(Array)
    sample_control = sample_control[0]
  end
  sample_control[field].should == converted_value
end

Then(/^each returned aliquot result should have (\d+) fields$/) do |count|
  if @returned_aliquot_result.is_a?(Array)
    @returned_aliquot_result.each { |this_aq|
      this_aq.keys.length.should == count.to_i }
  elsif @returned_aliquot_result.is_a?(Hash)
    @returned_aliquot_result.keys.length.should == count.to_i
  else
    0.should == count.to_i
  end
end

Then(/^each returned aliquot result should have field "([^"]*)"$/) do |field|
  if @returned_aliquot_result.is_a?(Array)
    @returned_aliquot_result.each { |this_aq|
      expect_result = "aliquot result has field: #{field}"
      actual_result = expect_result
      unless this_aq.keys.include?(field)
        actual_result = "aliquot result fields: #{this_aq.keys.to_s} do not include #{field}"
      end
      actual_result.should == expect_result
    }
  elsif @returned_aliquot_result.is_a?(Hash)
    expect_result = "aliquot result has field: #{field}"
    actual_result = expect_result
    unless @returned_aliquot_result.keys.include?(field)
      actual_result = "aliquot result fields: #{@returned_aliquot_result.keys.to_s} do not include #{field}"
    end
    actual_result.should == expect_result
  else
    expect_result = 'aliquot result returned'
    actual_result = 'no aliquot result returned'
    actual_result.should == expect_result
  end
end


And(/^file: "([^"]*)" has been removed from S3 bucket$/) do |file_name|
  Helper_Methods.s3_delete_path(ENV['s3_bucket'], file_name)
  wrong_result = "#{file_name} is still in bucket <#{ENV['s3_bucket']}>"
  if Helper_Methods.s3_file_exists(ENV['s3_bucket'], file_name)
    raise wrong_result
  end
end


################################################
##############               ###################
##############   files(seq)  ###################
##############               ###################
################################################
Given(/^sequence file type: "([^"]*)", nucleic acid type: "([^"]*)"$/) do |type, sub_type|
  @sequence_file_type = type
  @sequence_file_sub_type = sub_type
end

Given(/^file name for files service is: "([^"]*)"$/) do |file_name|
  @misc_file_name = file_name
end

# Then(/^sequence file type: "([^"]*)", nucleic acid type: "([^"]*)" for this molecular id should be "([^"]*)"$/) do |type, sub_type, result|
#   url = prepare_sequence_file_url(@sequence_file_type, @sequence_file_sub_type)
#   response = Helper_Methods.simple_get_request(url)
#   unless response.keys.include?('s3_download_file_url')
#     raise "response doesn't contain file url: \n#{response.to_json.to_s}"
#   end
#   validate_file_url(response['s3_download_file_url'], result)
# end

Then(/^PUT to sequence_files service, response includes "([^"]*)" with code "([^"]*)"$/) do |message, code|
  @current_auth0_role = 'ADMIN' unless @current_auth0_role.present?
  url = prepare_sequence_file_url(@sequence_file_type, @sequence_file_sub_type)
  response = Helper_Methods.put_request(url, @payload.to_json.to_s, true, @current_auth0_role)
  expect(response['http_code']).to eq code
  expect(response['message']).to include message
end

When(/^GET from sequence_files service, response includes "([^"]*)" with code "([^"]*)"$/) do |message, code|
  @current_auth0_role = 'ADMIN' unless @current_auth0_role.present?
  url = prepare_sequence_file_url(@sequence_file_type, @sequence_file_sub_type)
  puts url
  response = Helper_Methods.simple_get_request(url, true, @current_auth0_role)
  expect(response['http_code']).to eq code
  expect(response['message']).to include message
  @returned_sequence_file = response['message_json']
end

When(/^POST to sequence_files service, response includes "([^"]*)" with code "([^"]*)"$/) do |message, code|
  @current_auth0_role = 'ADMIN' unless @current_auth0_role.present?
  url = prepare_sequence_file_url(@sequence_file_type, @sequence_file_sub_type)
  response = Helper_Methods.post_request(url, @payload.to_json.to_s, true, @current_auth0_role)
  expect(response['http_code']).to eq code
  expect(response['message']).to include message
end

When(/^DELETE to sequence_files service, response includes "([^"]*)" with code "([^"]*)"$/) do |message, code|
  @current_auth0_role = 'ADMIN' unless @current_auth0_role.present?
  url = prepare_sequence_file_url(@sequence_file_type, @sequence_file_sub_type)
  response = Helper_Methods.delete_request(url, true, @current_auth0_role)
  expect(response['http_code']).to eq code
  expect(response['message']).to include message
end

Then(/^PUT to files service, response includes "([^"]*)" with code "([^"]*)"$/) do |message, code|
  @current_auth0_role = 'ADMIN' unless @current_auth0_role.present?
  url = prepare_files_url(@misc_file_name)
  response = Helper_Methods.put_request(url, @payload.to_json.to_s, true, @current_auth0_role)
  expect(response['http_code']).to eq code
  expect(response['message']).to include message
end

When(/^GET from files service, response includes "([^"]*)" with code "([^"]*)"$/) do |message, code|
  @current_auth0_role = 'ADMIN' unless @current_auth0_role.present?
  url = prepare_files_url(@misc_file_name)
  puts url
  response = Helper_Methods.simple_get_request(url, true, @current_auth0_role)
  expect(response['http_code']).to eq code
  expect(response['message']).to include message
  @returned_sequence_file = response['message_json']
end

When(/^POST to files service, response includes "([^"]*)" with code "([^"]*)"$/) do |message, code|
  @current_auth0_role = 'ADMIN' unless @current_auth0_role.present?
  url = prepare_files_url(@misc_file_name)
  response = Helper_Methods.post_request(url, @payload.to_json.to_s, true, @current_auth0_role)
  expect(response['http_code']).to eq code
  expect(response['message']).to include message
end

When(/^DELETE to files service, response includes "([^"]*)" with code "([^"]*)"$/) do |message, code|
  @current_auth0_role = 'ADMIN' unless @current_auth0_role.present?
  url = prepare_files_url(@misc_file_name)
  response = Helper_Methods.delete_request(url, true, @current_auth0_role)
  expect(response['http_code']).to eq code
  expect(response['message']).to include message
end

def prepare_ion_healthcheck_url
  params = @url_params.clone
  if @ion_id.present?
    params['ion_reporter_id']=@ion_id
  end
  url = "#{ENV['ion_system_endpoint']}/ion_reporters/healthcheck"
  add_parameters_to_url(url, params)
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
  if @molecular_id!=nil && @molecular_id.length>0
    slash_moi = "/#{@molecular_id}"
  end

  # slash_service = ''
  # if @ion_sub_service!=nil && @ion_sub_service.length>0
  #   slash_service = "/#{@ion_sub_service}"
  # end
  # url = "#{ENV['ion_system_endpoint']}/ion_reporters#{slash_ion_id}#{slash_service}"
  url = "#{ENV['ion_system_endpoint']}/sample_controls#{slash_moi}"

  add_parameters_to_url(url, @url_params)
end

def prepare_sequence_file_url(type, sub_type)
  slash_moi = ''
  if @molecular_id!=nil && @molecular_id.length>0
    slash_moi = "/#{@molecular_id}"
  end
  slash_type = ''
  if type!=nil && type.length>0
    slash_type = "/#{type}"
  end
  slash_sub_type = ''
  if sub_type!=nil && sub_type.length>0
    slash_sub_type = "/#{sub_type}"
  end
  url = "#{ENV['ion_system_endpoint']}/sample_controls/sequence_files#{slash_moi}#{slash_type}#{slash_sub_type}"
  add_parameters_to_url(url, @url_params)
end

def prepare_files_url(file_name)
  slash_moi = ''
  if @molecular_id!=nil && @molecular_id.length>0
    slash_moi = "/#{@molecular_id}"
  end
  slash_file_name = ''
  if file_name!=nil && file_name.length>0
    slash_file_name = "/#{file_name}"
  end
  url = "#{ENV['ion_system_endpoint']}/sample_controls/files#{slash_moi}#{slash_file_name}"
  add_parameters_to_url(url, @url_params)
end

def prepare_aliquot_url
  slash_moi = ''
  if @molecular_id!=nil && @molecular_id.length>0
    slash_moi = "/#{@molecular_id}"
  end
  url = "#{ENV['ion_system_endpoint']}/aliquot#{slash_moi}"
  add_parameters_to_url(url, @url_params)
end

def prepare_aliquot_file_url
  url = "#{ENV['ion_system_endpoint']}/aliquot/files/#{@ion_id}/#{@molecular_id}/#{@analysis_id}"
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
  expect_result = "#{date_field} is #{DateTime.strptime(expect_date.to_s, '%s')} "
  expect_result += "(#{max_diff_second} seconds difference is allowed)"
  actual_result = expect_result
  if time_diff < 0 || time_diff > max_diff_second
    actual_result = "#{date_field} is #{DateTime.strptime(actual_date.to_s, '%s')}"
  end
  actual_result.should == expect_result
end