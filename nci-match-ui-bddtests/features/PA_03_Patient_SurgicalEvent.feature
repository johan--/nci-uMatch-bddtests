##
# Created by: Raseel Mohamed
#  Date: 06/27/2016
##
Feature: Patient Surgical Event Tab
  A user can see Surgical Event tab and the details of each surgical event

  Background:
    Given I am a logged in user
    And I navigate to the patients page

  Scenario: Logged in user can see the details of the surgical event
    When I click on one of the patients
    And I click on the "Surgical Event" tab
    Then I should see the "Surgical Event" tab is active
    And I should see the Surgical Events drop down
    And I should see the Event Section
    And I see that the Event Section match with the one in the drop down
    And I should see the Pathology Section
    And I should see the Assay History Section
    And I see the Assay History Match with the database
    And I should see the Specimen History section
    And The status of each molecularId is displayed

  Scenario: Switching the Surgical Event will update all the elements in the table.
    When I click on one of the patients
    And I click on the "Surgical Event" tab
    Then I see that the Event Section match with the one in the drop down
    When I select another Surgical Event from the drop down
    Then I see that the Event Section match with the one in the drop down
    And I should see the Pathology Section
    And I should see the Assay History Section
    And I see the Assay History Match with the database
    And I should see the Specimen History section
    And The status of each molecularId is displayed
