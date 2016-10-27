##
# Created by: Raseel Mohamed
#  Date: 08/31/2016
##
@ui_p1
Feature: This is the critical path test cases

  Background: User goes to a patient with 'TISSUE_VARIANT_REPORT_RECEIVED' status
    Given I am a logged in user

  Scenario: User cannot reject a variant without comment
    And I go to patient "PT_CR04_VRUploadedAssayReceived" details page
    When I click on the "Surgical Event PT_CR04_VRUploadedAssayReceived_SEI1" tab
    And I collect information about the patient
    Then I should see the variant report link for "PT_CR04_VRUploadedAssayReceived_ANI1"
    When I should click on the variant report link
    Then I see that all the variant check boxes are selected
    When I uncheck the variant of ordinal "1"
    Then I "should" see the confirmation modal pop up
    And The "OK" button is "disabled"
#      And the variant table is updated for that variant to "false"
    When I click on the "Cancel" button
    Then The variant at ordinal "1" is "checked"
    When I uncheck the variant of ordinal "1"
    Then I "should" see the confirmation modal pop up
    And I enter the comment "This is a comment" in the modal text box
    And The "OK" button is "enabled"
    When I click on the "Cancel" button
    Then The variant at ordinal "1" is "checked"

  Scenario: User can see all the amois associated with the patient and matches the table
    When I go to the patient "PT_CR04_VRUploadedAssayReceived" with variant report "PT_CR04_VRUploadedAssayReceived_ANI1"
    Then I can see the variant report page
    Then I see that Total MOIs match the number of MOIs on the page
    And I see that the Total aMOIs match the number of aMOIs on the page.
    And I get the Total confirmed MOIs on the page
    And I get the Total confirmed aMOIs on the page
    And I see that the Total Confirmed MOIs match the number of MOIs on the page
#      And I see that the Total Confirmed aMOIs match the number of aMOIs on the page

  Scenario: Rejecting a variant will be noted in the backend and will change the number of confirmed mois
    When I go to the patient "PT_CR03_VRUploadedPathConfirmed" with variant report "PT_CR03_VRUploadedPathConfirmed_ANI1"
    Then I can see the variant report page
    And I get the Total confirmed MOIs on the page
    When I uncheck the variant of ordinal "1"
    Then I "should" see the confirmation modal pop up
    And I enter the comment "This is a comment" in the modal text box
    When I click on the "OK" button
    Then The variant at ordinal "1" is "unchecked"
    And I go to the patient "PT_CR03_VRUploadedPathConfirmed" with variant report "PT_CR03_VRUploadedPathConfirmed_ANI1"
    Then The total number of confirmed MOI has "decreased" by "1"
    When I click on the comment link at ordinal "1"
    Then I can see the "This is a comment" in the modal text box



  Scenario: Confirming a variant report will update the status of the report and also inform the activity feed on both dashboard and patient page.
    When I go to the patient "PT_CR03_VRUploadedPathConfirmed" with variant report "PT_CR03_VRUploadedPathConfirmed_ANI1"
    And I click on the "Confirm" button
    Then I "should" see the confirmation modal pop up
    When I click on the "OK" button
    Then The variant report status is marked "Confirmed"
    And The checkboxes are disabled
    And I "should not" see the "REJECT" button on the VR page
    And I "should not" see the "CONFIRM" button on the VR page
    When I go to patient "PT_CR04_VRUploadedAssayReceived" details page
    Then I see the confirmation message in the Patient activity feed
    When I navigate to the dashboard page
    Then I see the confirmation message in the Dashboard activity feed


  Scenario: Users is allowed reject a variant after entering a comment
    And I go to patient "PT_CR01_PathAssayDoneVRUploadedToConfirm" details page
    And I click on the "Tissue Reports" tab
    And I collect information about the patient
    When I uncheck the variant of ordinal "1"
    And I enter the comment "This is a comment" in the modal text box
    And I click on the "OK" button
    Then I "should not" see the confirmation modal pop up
    And The variant at ordinal "1" is not checked
    And I can see the comment column in the variant at ordinal "1"
    When I click on the comment link at ordinal "1"
    Then I can see the "This is a comment" in the modal text box
    When I clear the text in the modal text box
    Then The "OK" button is disabled

  Scenario: User comments are required when rejecting a report
    And I go to patient "PT_CR03_VRUploadedPathConfirmed" details page
    And I click on the "Tissue Reports" tab
    And I collect information about the patient
    When I click on the "REJECT" button
    Then I "should" see the VR confirmation modal pop up
    And The "OK" button is disabled
    When I enter the comment "This is a VR comment" in the VR modal text box
    And I click on the "OK" button
    And I "should not" see the VR confirmation modal pop up
    And I "should not" see the "REJECT" button on the VR page
    And I "should not" see the "CONFIRM" button on the VR page
    And I see the status of Report as "Rejected"
    And I can see the name of the commenter is present

  Scenario: Rejecting a vairant switches the confirm status for that variant only
    And I go to patient "PT_CR03_VRUploadedPathConfirmed" with variant report "PT_CR03_VRUploadedPathConfirmed_ANI1"
    And I collect information about the patient variant report
    And I verify that confirmed status under "gene_fusion" is "true" for uuid "1407b7d7-26f3-4c1c-a437-027de7791121"
    And I verify that confirmed status under "gene_fusion" is "true" for uuid "afce018f-4ad6-4e9d-b741-2c65f5227fe4"
    And I uncheck the variant of ordinal "<string>"
    And I enter the comment "Test Comment" in the modal text box
    And I verify that confirmed status under "gene_fusion" is "true" for uuid "1407b7d7-26f3-4c1c-a437-027de7791121"
    And I verify that confirmed status under "gene_fusion" is "true" for uuid "afce018f-4ad6-4e9d-b741-2c65f5227fe4"




