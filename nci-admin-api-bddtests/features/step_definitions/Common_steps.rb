require_relative './spec_helper'

Given(/^I am a user of type "([^"]*)"$/) do |user|
	@user = user
  Auth0Client.get_auth0_token(@user)
  puts ENV["#{user}_AUTH0_TOKEN"]#{user}_AUTH0_TOKEN
end