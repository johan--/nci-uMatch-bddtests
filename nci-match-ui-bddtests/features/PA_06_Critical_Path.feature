##
# Created by: Raseel Mohamed
#  Date: 08/31/2016
##
@ui
Feature: This is the critical path test cases

  Background: User goes to a patient with 'TISSUE_VARIANT_REPORT_RECEIVED' status
    Given I am a logged in user
    And I go to patient "PT_SR10_TsVrReceived" details page
    And I click on the "Tissue Reports" tab
    And I collect information about the patient

    Scenario: User must comment when rejecting individual variants
      When I uncheck the variant of ordinal "1"
      Then I "should" see the confirmation modal pop up
      When I click on the "Cancel" button
      Then The variant at ordinal "1" is "still" checked

    Scenario: Users comments are stored when rejecting a variant
      When I uncheck the variant of ordinal "1"
      And I can see the comment column in the variant at ordinal "1" is "not empty"
      And I enter the comment "<comment>" in the modal text box
      And I click on the "OK" button
      Then I "should not" see the confirmation modal pop up
      And The variant at ordinal "1" is "not" checked
      And I can see the comment column in the variant at ordinal "1"
      When I click on the comment link
      Then I can see the "<comment>" in the modal text box

    Scenario:
      When I click on the "REJECT" button
      Then I "should" see the confirmation modal pop up
      When I enter the comment "<comment>" in the modal text box
      And I click on the "OK" button
      Then I "should" see the confirmation modal pop up
      When I enter the comment "<comment>" in the modal text box
      And  I click "ok" to accept the comment
      Then I "should not" see the confirmation modal pop up
      And I see the status of Report as "Rejected"
      And I can see the name of the commenter is present

    Scenario:
      When I click on the "CONFIRM" button
      Then I "should" see the confirmation modal pop up
      When I click on the "OK" button
      Then I "should not" see the confirmation modal pop up
      And I see the status of Report as "Confirmed"

