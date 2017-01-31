@ui_p3
Feature: MATCHKB-541. Filtered variant report column sort not working.
  The user is able open a variant report with data, and sort columns in tables

  Background:
    Given I am a logged in user

  @test
  Scenario Outline: I can sort Variant Report tables by clicking column headers
    When I go to the patient "ION_AQ41_TsVrUploaded" with variant report "ION_AQ41_TsVrUploaded_ANI1"
    Then I can see the variant report page
    And I scroll to the bottom of the page
    Then I can see the "TABLE" table
    And I remember "COLUMN" column order
    And I click on "COLUMN" column
    Then I should see the data in the "COLUMN" column to be re-arranged
    Then I logout
    Examples:
      | table             | column       |
      | Gene Fusions      | ID           |
      | Gene Fusions      | Gene 1 Count |
