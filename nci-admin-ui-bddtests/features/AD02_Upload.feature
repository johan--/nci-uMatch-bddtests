@admin_ui_p1 @upload
Feature: This feature tests the upload functionality of the admin tool

  Scenario: Upload01 - An admin can choose to upload only one treatment arm from an excel
    Given I am a logged in user
    And I select "UploadOneTAFromListTest.xlsx" file for upload
    Then I expect to see the file "UploadOneTAFromListTest.xlsx" in the upload section
    When I click on "Select Specific Sheet Names" label on Upload section
    And I enter "APEC1621-AA" in the input
    And I see that the "Upload File" button is "enabled"
    And I click on "Upload File" button
    And I wait for "5" seconds
    Then I expect to see the file "UploadOneTAFromListTest.xlsx" on S3 bucket
    When I click on "Confirm upload to Treatment Arm" button
    Then I am taken to the "Confirmation" page
    And I verify that there is "APEC1621-AA" treatment arm in the list
    And I collect the treatment arm details for "APEC1621-AA" on the page
    And I hit the "Confirm" button next to treatment arm
    And I click on the "Upload Treatment Arm" button on the modal window
    And I delete the file from the S3 bucket
    And I get the authorization token
    And I call the Treatment Arm Api to verify the presence of the treatment arm "APEC1621-AA" and stratum "1"

  Scenario: Upload02 - An admin can upload an excel sheet with all the treatment arms
    Given I am a logged in user
    And I select "UploadAllTAFromListTest.xlsx" file for upload
    And I click on "Select All Sheet Names" label on Upload section
    And I click on "Upload File" button
    And I wait for "10" seconds
    When I click on "Confirm upload to Treatment Arm" button
    Then I am taken to the "Confirmation" page
    And I verify that there is "APEC1621-CC" treatment arm in the list
    And I verify that there is "APEC1621-DD" treatment arm in the list
    And I collect the treatment arm details for "APEC1621-CC" on the page


  Scenario: Upload03 - An Excel sheet with errors will not be uploaded to the pending treatment arms table
    Given I am a logged in user
    And I select "UploadOneTAFromListTest.xlsx" file for upload
    Then I expect to see the file "UploadOneTAFromListTest.xlsx" in the upload section
    When I click on "Select Specific Sheet Names" label on Upload section
    And I enter "APEC1621-BB" in the input
    And I see that the "Upload File" button is "enabled"
    And I click on "Upload File" button
    And I wait for "15" seconds
    Then I expect to see the file "UploadOneTAFromListTest.xlsx" on S3 bucket
    Then The treatment arms are not uploaded to the temporary table
