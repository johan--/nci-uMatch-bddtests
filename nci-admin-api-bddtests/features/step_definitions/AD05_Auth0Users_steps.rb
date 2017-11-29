
When(/^I issue a get request to auth(\d+)_information$/) do |_arg1|
  url       = "#{@admin_endpoint}/api/v1/admintool/auth0_information?auth0_api_endpoint=users"
  @response = Request.get_request(url)
end

Then(/^I should get a list of all the Auth(\d+) users$/) do |_arg1|
  parsed_response = JSON.parse(@response['message'])

  auth0_emails    = parsed_response.map { |response| response['email'] }
  auth0_user_ids  = parsed_response.map { |response| response['user_id'] }
  auth0_names     = parsed_response.map { |response| response['name'] }

  expect(parsed_response).to be_a Array

  expect(auth0_emails).not_to be_empty
  expect(auth0_user_ids).not_to be_empty
  expect(auth0_names).not_to be_empty

  expect(auth0_emails.size).to eq(parsed_response.size)
  expect(auth0_user_ids.size).to eq(parsed_response.size)
  expect(auth0_names.size).to eq(parsed_response.size)
end
