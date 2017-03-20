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
	@treatment_arm_id[value.to_sym] = field

	@ta_template[field] = value
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



Then(/^I should see the reason of rejection as "([^"]*)"$/) do |reason|
	message =  JSON.parse(@response['message'])
	error_message = message['error_messages'].first['all']

	expect(error_message).to eql(reason)
end
