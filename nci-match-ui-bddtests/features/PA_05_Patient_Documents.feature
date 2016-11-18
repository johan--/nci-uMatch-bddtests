Feature: Patient Document Tab

  Scenario: User can see the documents attached to the patient
    Given I am a logged in user
    And I navigate to the patients page
    And I click on one of the patients
    When I click on the "Documents" tab
    Then I can patient's document table
    And The number of documents displayed match the ones from the API

