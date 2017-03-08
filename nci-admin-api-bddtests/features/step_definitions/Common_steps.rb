require_relative './spec_helper'

Given(/^I am a user of type "([^"]*)"$/) do |role|
	user_details = UserManagement.get_user_details(role)
	@role = role
	@user = user_details[:email]
	@password = user_details[:password]
	@host_name = ENV['HOSTNAME']
	@admin_endpoint = ENV['ADMIN_ENDPOINT']
end

Then(/^I "(should|should not)" see a "([^"]*)" message$/) do |see_or_not, message|
  success = see_or_not == 'should' 
  if (success)
  	expect(@response["status"]).to eql(message)
  else
  	expect(@response["status"]).not.to.eql(message)
  end
end

Then(/^I should see a status code of "([^"]*)"$/) do |status_code|
  expect(@response['http_code']).to eql(status_code)
end

