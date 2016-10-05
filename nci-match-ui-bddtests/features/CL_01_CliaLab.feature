Feature: Clia Labs Page

  Background:
    Given I am a logged in user

  @ui_p3 @broken
  Scenario: User can access the Clia lab page
    When I navigate to the Clia Labs page
    Then I can see the Clia Labs page

  @ui_p3 @broken
  Scenario: User can see details about the MoCha
    When I navigate to the Clia Labs page
    And I cick on the "MoCha" button
    And I select "Positive Sample Controls" sub-tab under "Mocha"
    Then I can see the "Mocha" breadcrumb
    And I can see "Positive Sample Controls" is active
    And I can see the "Positive Sample Controls" table
    When I cick on the "MD Andersson" button
    Then I can see the "MD Andersson" breadcrumb
