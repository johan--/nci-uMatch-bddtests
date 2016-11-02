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
    When I click on the "Cancel" button
    Then I "should not" see the confirmation modal pop up
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
    When I go to the patient "PT_CR06_RejectOneVariant" with variant report "PT_CR06_RejectOneVariant_ANI1"
    And I collect information about the patient variant report
    Then I can see the variant report page
    And I get the Total confirmed MOIs on the page
    When I note the ID of the variant at ordinal "1"
    Then I verify that the status of confirmation of that ID is "confirmed"
    When I uncheck the variant of ordinal "1"
    Then I "should" see the confirmation modal pop up
    And I enter the comment "This is a comment" in the modal text box
    When I click on the "OK" button
    Then The variant at ordinal "1" is "unchecked"
    When I collect information about the patient variant report
    Then I verify that the status of confirmation of that ID is "rejected"
    And I go to the patient "PT_CR06_RejectOneVariant" with variant report "PT_CR06_RejectOneVariant_ANI1"
    Then The total number of confirmed MOI has "decreased" by "1"
    When I click on the comment link at ordinal "1"
    Then I can see the "This is a comment" in the modal text box

  Scenario: Confirming a variant report will update the status of the report and also inform the activity feed on both dashboard and patient page.
    When I go to the patient "PT_CR03_VRUploadedPathConfirmed" with variant report "PT_CR03_VRUploadedPathConfirmed_ANI1"
    Then I can see the variant report page
    And I click on the "CONFIRM" button
    Then I "should" see the confirmation modal pop up
    When I click on the "OK" button
    Then The variant report status is marked "CONFIRMED"
    And The checkboxes are disabled
    And I "should not" see the "REJECT" button on the VR page
    And I "should not" see the "CONFIRM" button on the VR page
    When I go to patient "PT_CR03_VRUploadedPathConfirmed" details page
    Then I see the confirmation message in the Patient activity feed as "CONFIRMED"
    When I navigate to the dashboard page
    Then I see the confirmation message in the Dashboard activity feed as "CONFIRMED"

  Scenario: Rejecting a report will update the status of the report
    When I go to the patient "PT_CR07_RejectVariantReport" with variant report "PT_CR07_RejectVariantReport_ANI1"
    Then I can see the variant report page
    And I click on the "REJECT" button
    Then I "should" see the confirmation modal pop up
    And I enter the comment "This is a comment" in the VR modal text box
    When I click on the "OK" button
    Then I "should not" see the confirmation modal pop up
    Then The variant report status is marked "REJECTED"
    And The checkboxes are disabled
    And Total confirmed MOIs and aMOIs are now '0'
    And I "should not" see the "REJECT" button on the VR page
    And I "should not" see the "CONFIRM" button on the VR page
    When I go to patient "PT_CR07_RejectVariantReport" details page
    Then I see the confirmation message in the Patient activity feed as "REJECTED"
    When I navigate to the dashboard page
    Then I see the confirmation message in the Dashboard activity feed as "REJECTED"

  Scenario: Confirming a variant report followed by assignment report will update the status to Awaiting assignment
    When I go to the patient "PT_CR01_PathAssayDoneVRUploadedToConfirm" with variant report "PT_CR01_PathAssayDoneVRUploadedToConfirm_ANI1"
    Then I can see the variant report page
    And I click on the "CONFIRM" button
    Then I "should" see the confirmation modal pop up
    When I click on the "OK" button
    Then The variant report status is marked "CONFIRMED"
    And I wait "59" seconds
    When I go to patient "PT_CR01_PathAssayDoneVRUploadedToConfirm" details page
    Then I "should" see the patient "status" as "PENDING_CONFIRMATION"
    And I click on the Surgical Event Tab at index "0"
    Then I should see the assignment report link for "PT_CR01_PathAssayDoneVRUploadedToConfirm_ANI1"
    When I collect information about the assignment
    And I click on the assignment report link
    Then I can see the assignment report page
    And I can see the top level details about assignment report
    And I can see the selected Treatment arm id "APEC1621-A" and stratum "100" and version "2015-08-06" in a box with reason
    And I can see the Assignment Logic section
    And I can see the selected treatment arm and the reason
    And The Types of Logic is the same as the backend
    And I "should" see the Assignment report "CONFIRM" button
    When I click on the Assignment report "CONFIRM" button
    Then I "should" see the confirmation modal pop up
    When I click on the "OK" button
    Then I "should not" see the confirmation modal pop up
    And I "should not" see the Assignment report "CONFIRM" button
    When I go to patient "PT_CR01_PathAssayDoneVRUploadedToConfirm" details page
    Then I "should" see the patient "Status" as "PENDING_APPROVAL"
    And I "should" see the patient "Treatment Arm Id" as "APEC1621-A"
    And I "should" see the patient "Stratum Id" as "100"
    And I "should" see the patient "Version" as "2015-08-06"
    When I go to the patient "PT_CR01_PathAssayDoneVRUploadedToConfirm" with assignment report "PT_CR01_PathAssayDoneVRUploadedToConfirm_ANI1"
    When I collect information about the assignment
    Then I can see more new top level details about assignment report


