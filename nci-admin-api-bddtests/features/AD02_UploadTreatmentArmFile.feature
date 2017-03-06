Feature: Upload Treatment Arm from File
As an Admin user
I can upload an excel file to Admin tool 
So that I can view the enclosed treatment arms in the file for upload to TA ecosystem

Background:
Given I am a user of type "ADMIN"

Scenario: Uploading an excel sheet and selecting one treatment arm should upload only the selected one
When I upload file "select_one_ta.xlsx" selecting TA "APEC1621-AA" with version "version1"
Then I "should" see a "success" message
And I should see a status code of "200"
And I collect a list of tables from pending treatment arm table
And I "should" see the treatment arm "APEC1621-AA" in the pending treatment arm table

Scenario: Uploading an excel sheet and selecting no treatment arm should upload all the treamtnet arms
When I upload file "select_all.xlsx" selecting all TAs with version "version1"
Then I "should" see a "success" message
And I collect a list of tables from pending treatment arm table
And I "should" see the treatment arm "APEC1621-AC" in the pending treatment arm table
And I "should" see the treatment arm "APEC1621-AD" in the pending treatment arm table

Scenario: When calling the upload_to_aws with a non-existing excel sheet in S3 should raise an error
When I upload file "doesNotExist.xlsx" selecting all TAs with version "version1"
Then I "should not" see a success message
And I should see a status code of "200"
And I "should not" see the treatment arm in the pending treatment arm table

Scenario: When calling the upoad_to_aws with a missing sheet from a valid excel should raise an error
When I upload file "select_all.xlsx" selecting TA "doesNotExistSheet" with version "version1"
Then I "should not" see a "success" message
And I collect a list of tables from pending treatment arm table
And I "should" see the treatment arm "APEC1621-AC" in the pending treatment arm table

Scenario: Missing a version param shold cause the request to fail
When I upload file "select_one_ta.xlsx" selecting TA "APEC1621-AA" with version "version1"
Then I "should not" see a "success" message

