Feature: Clia Labs Page

  Background:
    Given I am a logged in user
    When I navigate to the Clia Labs page

  @ui_p3
  Scenario: Clia labs page is accessible to a logged in user
    Then I can see the Clia Labs page

  @ui_p3
  Scenario: User can switch between MoCha and MDA
    When I click on the "MoCha" section
    Then I am on the "MoCha" section
    When I click on the "MD Andersson" section
    Then I am on the "MD Andersson" section

  @ui_p3
  Scenario Outline: User is able to see Lab details under <sectionName> section
    When I click on the "<sectionName>" section
    And I click on "<subTabName>" under "<sectionName>"
    And I collect information on "<subTabName>" under "<sectionName>"
    Then I verify that "<subTabName>" under "<sectionName>" is active
    And I verify the headings for "<subTabName>" under "<sectionName>"
    And I verify that the data retrieved is present for "<subTabName>" under "<sectionName>"
    Examples:
      | sectionName  | subTabName                 |
      | MoCha        | Positive Sample Controls   |
      | MoCha        | No Template Control        |
      | MoCha        | Proficiency And Competency |
      | MD Andersson | Positive Sample Controls   |
      | MD Andersson | No Template Control        |
      | MD Andersson | Proficiency And Competency |
