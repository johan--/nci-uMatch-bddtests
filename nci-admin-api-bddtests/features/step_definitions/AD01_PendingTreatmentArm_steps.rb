require_relative ('./spec_helper')

When(/^I issue a get request to pending treatment arms$/) do
  url = "#{@admin_endpoint}/api/v1/admintool/pending_treatment_arms"
  @response = Request.get_request(url)
end


When(/^I issue a get request to pending treatment arms with id "([^"]*)" and version "([^"]*)"$/) do |treatment_arm_id, version|
  url = "#{@admin_endpoint}/api/v1/admintool/pending_treatment_arms/#{treatment_arm_id}/#{version}"
  @response = Request.get_request(url)
end

Then(/^I should get a list of all the treatment arm in the table$/) do
	message = JSON.parse(@response['message'])
	treatment_arm_collection = message.map { | ta | ta['treatment_arm_id'] }
  expect(message).to be_a Array
  expect(treatment_arm_collection.size).to eq(message.size)
end

When(/^The "([^"]*)" of the treatment arm should be "([^"]*)"$/) do |field, value|
  message = JSON.parse(@response['message'])
  expect(message[field]).to eq(value)
end
