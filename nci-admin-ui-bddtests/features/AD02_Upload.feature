Feature: This feature tests the upload funcctionality of the admin tool 

Scenario: An admin can upload only one treatment arm from an excel
Given I am a logged in user
And I select "select_one_from_list" file for upload
And I click on "Select Specific Treatment Arms" button on Upload section
And I enter "SelectME" in the input
Then the files are uploaded to the temporary table
When I click on the "Confirm upload to Treatment Arm" button on the Status section
Then I am taken to the "Confirmation" page
And I verify that there is/are "1" treatment arm(s) in the list
And I collect the treatment arm details on row "1"
And I hit the "Confirm Upload" button next to treatment arm on row "1"
And I call the Treatment Arm Api to verify the presence of the treatment arm

Scenario: An admin can upload an excel sheet with all the treatment arms 
Given I am a logged in user
And I select "two_treatment_arms" file for upload
And I click on "Select All Treatment Arms" button on Upload section
Then the files are uploaded to the temporary table
When I click on the "Confirm upload to Treatment Arm" button on the Status section
Then I am taken to the "Confirmation" page
And I verify that there is/are "2" treatment arm(s) in the list
And I collect the treatment arm details on row "1"
And I hit the "Confirm Upload" button next to treatment arm on row "1"
And I call the Treatment Arm Api to verify the presence of the treatment arm

