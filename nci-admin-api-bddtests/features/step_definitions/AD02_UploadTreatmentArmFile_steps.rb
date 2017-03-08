require_relative './spec_helper'

Then(/^I "([^"]*)" see a success message$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

When(/^I upload file "([^"]*)" selecting sheet name "([^"]*)" with version "([^"]*)"$/) do |file, sheet_name, ver|
	file_name = Utility.nil_if_empty(file)
	@treatment_arm_id = sheet_name
	@version  = Utility.nil_if_empty(ver)
  request = "#{@admin_endpoint}/api/v1/admintool/upload_to_aws?user=#{@user}"
  body = {
  	excel_book_name: file_name,
  	excel_sheet_names: [@treatment_arm_id],
  	version: @version
  }
  @response = Request.post_request(request, body)
end


When(/^I upload file "([^"]*)" selecting all TAs with version "([^"]*)"$/) do |file, ver|
	file_name = Utility.nil_if_empty(file)
	version = Utility.nil_if_empty(ver)
  request = "#{@admin_endpoint}/api/v1/admintool/upload_to_aws?user=#{@user}"
  body = {
  	excel_book_name: file_name,
  	excel_sheet_names: [],
  	version: version
  }
  @response = Request.post_request(request, body)
  
end

Then(/^I collect a list of entries from pending treatment arm table$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I "(should|should not)" see the treatment arm in the pending treatment arm table$/) do |see_or_not|
  dynamo_client = AWS::DynamoDB.setup_client(@dynamodb_region, @dynamodb_endpoint)
  options = {
  	table_name: "treatment_arm_pending",
  	projection_expression: "treatment_arm_id, version",
  	expression_attribute_values: { ":primary" => @treatment_arm_id, ":secondary" => @version},
  	key_condition_expression: "treatment_arm_id = :primary AND version = :secondary",
  }
  query_result = AWS::DynamoDB.query_entry(dynamo_client, options)
  actual_result = query_result.to_hash

  present = see_or_not == 'should'

  if present
  	expect(actual_result[:count]).to eql(1)
  	first_item = actual_result[:items].first
  	expect(first_item['treatment_arm_id']).to eql(@treatment_arm_id)
  	expect(first_item['version']).to eql(@version)
  else
  	expect(actual_result[:count]).to eql(0)
  end
end


Then(/^I "([^"]*)" see the treatment arm "([^"]*)" and version "([^"]*)" in the pending treatment arm table$/) do |see_or_not, treatment_arm, version|
  @treatment_arm_id = treatment_arm
  @version = version
  step %{I "#{see_or_not}" see the treatment arm in the pending treatment arm table}
end



#Good response:
#{"status"=>"Success", "http_code"=>"200", "message"=>"{\n  \"response\": {\n    \"data\": [\n      {\n        \"reason\": \"\", \n        \"status\": true, \n        \"treatment_arm_id\": \"APEC1621-AC\"\n      }, \n      {\n        \"reason\": \"\", \n        \"status\": true, \n        \"treatment_arm_id\": \"APEC1621-AD\"\n      }\n    ], \n    \"message\": null, \n    \"status\": 1\n  }\n}\n"}
#
#Failed bad response:
#{"status"=>"Failure", "http_code"=>"500", "message"=>"{\"message\": \"File failed to download: An error occurred (404) when calling the HeadObject operation: Not Found\"}\n"}
#
#Failed good reszponse:
#{"status"=>"Success", "http_code"=>"200", "message"=>"{\n  \"response\": {\n    \"data\": [\n      {\n        \"message\": \"No sheet named <u'doesNotExistSheet'>\", \n        \"status\": false, \n        \"treatment_arm_id\": \"doesNotExistSheet\"\n      }\n    ], \n    \"message\": null, \n    \"status\": 2\n  }\n}\n"}
#

