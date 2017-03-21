@ui_p2
Feature: As a valid user I can access the variant report for a patient and navigate around

  Background:
    Given I stay logged in as "read_only" user

  Scenario Outline: I can sort Variant Report tables by clicking column headers
    When I go to the patient "ION_AQ41_TsVrUploaded" with variant report "ION_AQ41_TsVrUploaded_ANI1"
    And I scroll to the bottom of the page
    Then I can see the "<table>" table
    And I remember order of elements in column "<columnNumber>" of the "<table>" table
    And I click on "<columnNumber>" column header of the "<table>" table
    Then I should see the data in the column to be sorted properly
    Then I logout
    Examples:
      | table             | columnNumber |
      | Gene Fusions      | 2            |
@sort
  Scenario: Surgical Event link in the variant report should link back to the Surgical Event
    When I go to the patient "UI_PA08_PendingConfirmation" with variant report "UI_PA08_PendingConfirmation_ANI1"
    And I click on the Surgical Event Id Link
    Then I should go to the surgical event page of the patient
    When I go to the patient "UI_PA08_PendingConfirmation" with variant report "UI_PA08_PendingConfirmation_ANI1"
    And I click on the Molecular ID link
    Then I should go to the molecular id section of the surgical event page

