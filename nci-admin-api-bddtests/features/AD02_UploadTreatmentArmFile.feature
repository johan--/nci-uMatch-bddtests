@admin_api_p1
Feature: Upload Treatment Arm from File
As an Admin user
I can upload an excel file to Admin tool 
So that I can view the enclosed treatment arms in the file for upload to TA ecosystem

Background:
Given I am a user of type "ADMIN"

Scenario: Uploading an excel sheet and selecting one treatment arm should upload only the selected one
When I upload file "select_one_ta_test.xlsx-1.1.2017_100" selecting sheet name "APEC1621-AA" with version "1.1.2017_100"
Then  I "should" see a "Success" message
And I should see a status code of "200"
And I "should" see the treatment arm in the pending treatment arm table

Scenario: Uploading an excel sheet and selecting no treatment arm should upload all the treamtnet arms
When I upload file "select_all_test.xlsx-1.1.2017_100" selecting all TAs with version "1.1.2017_100"
Then  I "should" see a "Success" message
And I "should" see the treatment arm "APEC1621-AC" and version "1.1.2017_100" in the pending treatment arm table
And I "should" see the treatment arm "APEC1621-AD" and version "1.1.2017_100" in the pending treatment arm table

Scenario: When calling the upload_to_aws with a non-existing excel book in S3 should raise an error
When I upload file "doesNotExist.xlsx" selecting sheet name "doesNotExistSheet" with version "1.1.2017_100"
Then I "should" see a "Failure" message
And I should see a status code of "500"
And I "should not" see the treatment arm in the pending treatment arm table

Scenario: When calling the upoad_to_aws with a missing sheet from a valid excel should fail with message
When I upload file "select_one_ta_test.xlsx-1.1.2017_100" selecting sheet name "doesNotExistSheet" with version "1.1.2017_100"
Then I "should" see a "Success" message
And I "should not" see the treatment arm "doesNotExistSheet" and version "1.1.2017_100" in the pending treatment arm table

Scenario Outline: Missing a <parameter> parameter should cause the request to fail
When I upload file "select_one_ta_test.xlsx-1.1.2017_100" with missing "<parameter>"
Then I "should" see a "Failure" message
And I should see a status code of "500"
Examples:
| parameter 				|
| excel_book_name 	|
| excel_sheet_names |
| version        		|

Scenario Outline: Having a null <parameter> should cause the request to fail
When I upload file "select_one_ta_test.xlsx-1.1.2017_100" selecting sheet name "APEC1621-AA" with version "1.1.2017_100" and "<parameter>" value as nil
Then I "should" see a "Failure" message
Examples:
| parameter 				|
| excel_book_name 	|

