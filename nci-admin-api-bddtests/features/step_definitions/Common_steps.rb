require_relative '../../support/auth0_client'
require_relative '../../support/request'

Given(/^I am a user of type "([^"]*)"$/) do |user|
  Auth0Token.get_auth0_token(user)
  puts ENV["auth0token"]
end