@admin_ui_p1
Feature: This feature tests the upload funcctionality of the admin tool 
@upload

Scenario: An admin can choose to upload only one treatment arm from an excel
Given I am a logged in user
And I select "select_one_from_list.xlsx" file for upload
Then I expect to see the file "select_one_from_list.xlsx" in the upload section
When I click on "Select Specific Treatment Arms" label on Upload section
And I enter "APEC1621-E" in the input
And I see that the "Upload File" button is "enabled"
And I click on "Upload File" button
And I wait for "15" seconds
Then I expect to see the file "select_one_from_list.xlsx" on S3 bucket "test-admin-tool"
Then The treatment arms are uploaded to the temporary table
When I click on "Confirm upload to Treatment Arm" button
Then I am taken to the "Confirmation" page
And I verify that there is/are "1" treatment arm(s) in the list
And I collect the treatment arm details on row "1"
And I hit the "Confirm Upload" button next to treatment arm on row "1"
And I call the Treatment Arm Api to verify the presence of the treatment arm
And I delete the file from the S3 bucket "test-admin-tool"
And I logout

Scenario: An admin can upload an excel sheet with all the treatment arms 
Given I am a logged in user
And I select "two_treatment_arms.xlsx" file for upload
And I click on "Select All Treatment Arms" label on Upload section
And I click on "Upload File" button
Then The treatment arms are uploaded to the temporary table
When I click on "Confirm upload to Treatment Arm"
Then I am taken to the "Confirmation" page
And I verify that there is/are "2" treatment arm(s) in the list
And I collect the treatment arm details on row "1"
And I hit the "Confirm Upload" button next to treatment arm on row "1"
And I call the Treatment Arm Api to verify the presence of the treatment arm
And I logout

Scenario: An Excel sheet with errors will not be uploaded to the pending treatment arms table
Given I am a logged in user
And I select "select_one_from_list.xlsx" file for upload
Then I expect to see the file "select_one_from_list.xlsx" in the upload section
When I click on "Select Specific Treatment Arms" label on Upload section
And I enter "APEC1621-E" in the input
And I see that the "Upload File" button is "enabled"
And I click on "Upload File" button
And I wait for "15" seconds
Then I expect to see the file "select_one_from_list.xlsx" on S3 bucket "test-admin-tool"
Then The treatment arms are not uploaded to the temporary table
