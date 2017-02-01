@ui_p3
Feature: MATCHKB-541. Filtered variant report column sort not working.
  The user is able open a variant report with data, and sort columns in tables

  Background:
    Given I am a logged in user

  Scenario Outline: I can sort Variant Report tables by clicking column headers
    When I go to the patient "ION_AQ41_TsVrUploaded" with variant report "ION_AQ41_TsVrUploaded_ANI1"
    Then I can see the variant report page
    And I scroll to the bottom of the page
    Then I can see the "<table>" table
    # And I remember "<columnNumber>" column order of the "<table>" table
    # And I click on "<columnNumber>" column header of the "<table>" table
    # Then I should see the data in the "<columnNumber>" column to be re-arranged
    Then I logout
    Examples:
      | table             | columnNumber |
      | Gene Fusions      | 1            |
