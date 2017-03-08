require_relative './spec_helper'

Then(/^I "([^"]*)" see a success message$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I "([^"]*)" see the treatment arm in the pending treatment arm table$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

When(/^I upload file "([^"]*)" selecting sheet name "([^"]*)" with version "([^"]*)"$/) do |file_name, sheet_name, version|
  request = "#{@admin_endpoint}/api/v1/admintool/upload_to_aws?user=#{@user}"
  body = {
  	excel_book_name: file_name,
  	excel_sheet_names: [sheet_name],
  	version: version
  }
  @response = Request.post_request(request, body)
end

Then(/^I collect a list of entries from pending treatment arm table$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I "([^"]*)" see the treatment arm "([^"]*)" in the pending treatment arm table$/) do |arg1, arg2|
  pending # Write code here that turns the phrase above into concrete actions
end

When(/^I upload file "([^"]*)" selecting all TAs with version "([^"]*)"$/) do |arg1, arg2|
  pending # Write code here that turns the phrase above into concrete actions
end