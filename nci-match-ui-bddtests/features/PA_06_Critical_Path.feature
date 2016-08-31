##
# Created by: Raseel Mohamed
#  Date: 08/31/2016
##
@broken
Feature: This is the critical path test cases

  Background: User goes to a patient with 'TISSUE_VARIANT_REPORT_RECEIVED' status
    Given I am a logged in user
    And I navigate to the patients page
    And I enter "TISSUE_VARIANT_REPORT_RECEIVED" in the patient filter field
    And I click on one of the patients
    And I collect information about the patient
    And I click on the "Tissue Reports" tab

    Scenario: User must comment when rejecting individual variants
      When I uncheck the variant of ordinal "1"
      Then I "should" see the confirmation modal pop up
      When I click the cancel button
      Then The variant at ordinal "1" is "still" checked

    Scenario: Users comments are stored when rejecting a variant
      When I uncheck the variant of ordinal "1"
      And I can see the comment column in the variant at ordinal "1" is "not empty"
      And I enter the comment "<comment>" in the modal text box
      And I click "ok" to accept the comment
      Then I "should not" see the confirmation modal pop up
      And The variant at ordinal "1" is "not" checked
      And I can see the comment column in the variant at ordinal "1"
      When I click on the comment link
      Then I can see the "<comment>" in the modal text box

    Scenario:
      When I click on the "Reject" button
      Then I "should" see the confirmation modal pop up
      When I click "ok" to accept the comment
      Then I "should" see the confirmation modal pop up
      When I enter the comment "<comment>" in the modal text box
      And  I click "ok" to accept the comment
      Then I "should not" see the confirmation modal pop up
      And I see the status of Report as "Rejected"
      And I can see the name of the commenter is present


    Scenario:
      When I click on the "Confirm" button
      Then I "should" see the confirmation modal pop up
      When I click "ok" to accept the comment
      Then I "should not" see the confirmation modal pop up
      And I see the status of Report as "Confirmed"
      And I can see the name of the commenter is present
