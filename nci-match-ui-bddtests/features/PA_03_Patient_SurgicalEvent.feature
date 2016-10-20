##
# Created by: Raseel Mohamed
#  Date: 06/27/2016
##
Feature: Patient Surgical Events Tab
  A user can see Surgical Events tab and the details of each surgical event

  Background:
    Given I am a logged in user
    And I navigate to the patients page
    And I go to patient "PT_CR04_VRUploadedAssayReceived" details page

  @ui_p2
  Scenario: Logged in user can see the details of the surgical event
    When I collect specimen information about the patient
    Then I should see the same number of surgical event tabs
    When I click on the Surgical Event Tab and index "0"
    And I should see the "Event" Section under patient Surgical Events
    And The Surgical Event Id match that of the backend
    And I should see the "Pathology" Section under patient Surgical Events
    And They match with the patient json for "Event" section
#    And They match with the patient json for "Pathology" section
    And I should see the "Slide Shipments" section heading
    And I should see the "Assay History" section heading
    And I should see the "Specimen History" section heading
#    And I see the Assay History Match with the database
#    And The status of each molecularId is displayed
