##
# Created by: Raseel Mohamed
#  Date: 06/27/2016
##
Feature: Patient Surgical Events Tab
  A user can see Surgical Events tab and the details of each surgical event

  Background:
    Given I am a logged in user
    And I navigate to the patients page

  @patients @ui @broken @dev
  Scenario: Logged in user can see the details of the surgical event
    When I click on one of the patients
    And I click on the "Surgical Events" tab
    Then I should see the "Surgical Events" tab is active
    And I capture the current Surgical Event Id
    And I should see the Surgical Events drop down button
    And I should see the "Event" Section under patient Surgical Events
#    And They match with the patient json for "Event" section
    And I should see the "Pathology" Section under patient Surgical Events
#    And They match with the patient json for "Pathology" section
    And I see that the Event Section match with the one in the drop down
    And I should see the "Assay History" Sub Section under Surgical Events
#    And I see the Assay History Match with the database
    And I should see the "Specimen History" Sub section under Surgical Events
    And The status of each molecularId is displayed

  @patients @ui @broken
  Scenario: Switching the Surgical Events will update all the elements in the table.
    When I click on one of the patients
    And I click on the "Surgical Events" tab
    Then I see that the Event Section match with the one in the drop down
    When I select another Surgical Events from the drop down
    Then I see that the Event Section match with the one in the drop down
    And I should see the Pathology Section
    And I should see the Assay History Section
    And I see the Assay History Match with the database
    And I should see the Specimen History section
    And The status of each molecularId is displayed
