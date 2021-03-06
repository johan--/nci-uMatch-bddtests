##
# Created by: Raseel Mohamed
#  Date: 06/27/2016
##
Feature: Patient Surgical Events Tab
  A user can see Surgical Events tab and the details of each surgical event

  Background:
    Given I stay logged in as "read_only" user

  @ui_p2
  Scenario: Logged in user can see the details of the surgical event
    When I go to patient "PT_CR04_VRUploadedAssayReceived" details page
    And I collect specimen information about the patient
    Then I should see the same number of surgical event tabs
    When I click on the Surgical Event Tab at index "0"
    And I should see the "Event" Section under patient Surgical Events
    And The Surgical Event Id match that of the backend
    And I should see the "Details" Section under patient Surgical Events
    And I should see the "Slide Shipments" under surgical event tab
    And I verify the data within the Slide shipment table
    And I should see the "Assay History" under surgical event tab
    And I verify the data within the Assay History table
    And I should see the "Specimen History" under surgical event tab

  @ui_p2
  Scenario: Logged in user can see multiple assignments for single variant report
    When I go to patient "UI_MA_PendingApproval" details page
    Then I am taken to the patient details page
    And I click on the "Surgical Event UI_MA_PendingApproval_SEI1" tab
    And I scroll to the bottom of the page
    Then I should see "3" Assignments under the Molecular ID "UI_MA_PendingApproval_MOI1"
