##
# Created by: Raseel Mohamed
#  Date: 08/31/2016
##
@ui_p1
Feature: This is the critical path test cases

  Background: User goes to a patient with 'TISSUE_VARIANT_REPORT_RECEIVED' status
    Given I am a logged in user

    Scenario: User must comment when rejecting individual variants
      And I go to patient "PT_CR01_PathAssayDoneVRUploadedToConfirm" details page
      And I click on the "Tissue Reports" tab
      And I collect information about the patient
      Then I see that all the variant check boxes are selected
      When I uncheck the variant of ordinal "1"
      Then I "should" see the confirmation modal pop up
      And The "OK" button is disabled
      When I click on the "Cancel" button
      Then The variant at ordinal "1" is checked

    Scenario: Users comments are required when rejecting a variant
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

    Scenario: A user can confirm a variant report
      And I go to patient "PT_CR01_PathAssayDoneVRUploadedToConfirm" details page
      And I click on the "Tissue Reports" tab
      And I collect information about the patient
      When I click on the "CONFIRM" button
      Then I "should" see the confirmation modal pop up
      When I click on the "OK" button
      Then I "should not" see the confirmation modal pop up
      And I see the status of Report as "Confirmed"

