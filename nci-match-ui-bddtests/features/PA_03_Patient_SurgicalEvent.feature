##
# Created by: Raseel Mohamed
#  Date: 06/27/2016
##
Feature: Patient Surgical Events Tab
  A user can see Surgical Events tab and the details of each surgical event

  Background:
    Given I am a logged in user
    And I navigate to the patients page
    And I click on one of the patients

  @patients_p2 @ui_p2
  Scenario: Logged in user can see the details of the surgical event
    When I click on the "Surgical Events" tab
    And I collect information about the patient
    Then I should see the "Surgical Events" tab is active
    And I should see the Surgical Events drop down button
    And I capture the current Surgical Event Id from the drop down
    And I should see the "Event" Section under patient Surgical Events
    And The Surgical Event Id match that of the drop down
    And They match with the patient json for "Event" section
    And I should see the "Pathology" Section under patient Surgical Events
#    And They match with the patient json for "Pathology" section
    And I should see the "Slide Shipments" section heading
    And I should see the "Assay History" section heading
    And I should see the "Specimen History" section heading
#    And I see the Assay History Match with the database
#    And The status of each molecularId is displayed

  @patients_p2 @ui_p2
  Scenario: Switching the Surgical Events will auto update all the elements in the table.
    When I click on the "Surgical Events" tab
    And I capture the current Surgical Event Id from the drop down
    And The Surgical Event Id match that of the drop down
    And I select another from the drop down
    Then I capture the current Surgical Event Id from the drop down
    And The Surgical Event Id match that of the drop down
