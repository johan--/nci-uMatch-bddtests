require_relative './spec_helper'

@treatment_arm_details = {
  treatment_arm_id: 'default',
  stratum_id: 'default',
  version: 'default'
}

Given(/^I retrieve the template for treatment arm$/) do
  @ta_template = JSON.parse(File.read(File.join(Utility::DATA_FOLDER, 'treatment_arm_template.json')))
end

Given(/^I substitute "([^"]*)" for the "([^"]*)"$/) do |value, field|
  # @treatment_arm_id[value] = field

  @ta_template[field] = value
end

Given(/^I enter a hash "([^"]*)" for the treatment_arm_id$/) do |dict|
  hash_object = eval(dict)
  @ta_template['treatment_arm_id'] = hash_object
end

Given(/^I add a duplicate of the object to "([^"]*)"$/) do |field|
  @field = field
  @field_element = JSON.parse(File.read( File.join( Utility::DATA_FOLDER, "#{@field}.json")))
end

Given(/^I pick the "([^"]*)" ordinal of "([^"]*)"$/) do |ordinal, field|
  @ord = ordinal.to_i
end

Given(/^I set "([^"]*)" to "([^"]*)"$/) do |key, value|
  @field_element[key] = value

  @ta_template[@field] << @field_element
end

When(/^I issue a post request for validation at level "([^"]*)" with the treatment arm$/) do |validation_values|
  request = "#{@admin_endpoint}/api/v1/admintool/validation"

  body = {
    treatment_arm_data: @ta_template,
    validation_values: [validation_values]
  }
  @response = Request.post_request(request, body)
end

Given(/^I remove the field "([^"]*)" from the template$/) do |field|
  @error_field = field
  @ta_template.delete(field)
end

Then(/^I "(should|should not)" see "([^"]*)" value under the "([^"]*)" field$/) do |see_or_not, expected_value, response_field|
  present = see_or_not == 'should'
  response_message = JSON.parse(@response['message'])

  if present
    expect(response_message[response_field].to_s).to eql(expected_value)
  else
    expect(response_message[response_field].to_s).not_to eql(expected_value)
  end
end

Then(/^I should see the reason of rejection on "([^"]*)" as "([^"]*)"$/) do |field, reason|
  message = JSON.parse(@response['message'])

  error_key = message['error_messages'].select { |e| e.key? field }
  expect(error_key.size).to be > 0

  error_message = error_key.select { |e| e.value? reason }
  expect(error_message.size).to be > 0
end

Then(/^I should see the reason of rejection as "([^"]*)"\{'treatment_arm_id': 'The field treatment_arm_id must be a string\. \(i\.e APEC(\d+)A(\d+)\)'\}"([^"]*)"$/) do |arg1, arg2, arg3, arg4|
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I should see the reason of rejection as "([^"]*)"$/) do |arg1|
  message = JSON.parse(@response['message'])
end
