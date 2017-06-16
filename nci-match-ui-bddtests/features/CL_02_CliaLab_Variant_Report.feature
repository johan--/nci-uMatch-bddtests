Feature: CLIA Labs Variant Reports Page

  @ui_p2 @demo_p4 @clia
  Scenario Outline: User can access and Fail the uploaded Positive Sample Control report.
    Given I am logged in as a "<userType>" user
    And I go to clia variant filtered report with "<molecularId>" as the molecular_id on "<subTabName>" tab
    Then I should see the status as "<oldStatus>"
    And The clia report "<statusButton>" button is "visible"
    When I click on clia report "<statusButton>" button on "<subTabName>"
    Then I enter the Clia Lab comment "Changing Status from PASSED to FAILED" in the modal text box
    And I click "OK" on clia report Comment button
    And I should see the status as "<newStatus>"
    And I should see the comment as "Changing Status from PASSED to FAILED"
    When I navigate to the CLIA Labs page
    And I click on the "MoCha" section
    And I click on "<subTabName>" under "MoCha"
    And I enter "<molecularId>" in the search field of "<subTabName>" under "MoCha"
    Then I should see the status of variant report in list as "<newStatus>"

    Examples:
      | userType          | subTabName               | statusButton | molecularId    | oldStatus | newStatus |
      | VR_Reviewer_mocha | Positive Sample Controls | FAIL         | SC_MOCHA_5AMCC | PASSED    | FAILED    |
