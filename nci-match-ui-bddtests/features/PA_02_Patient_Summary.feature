##
# Created by: Raseel Mohamed
#  Date: 06/24/2016
##

Feature: Patient Summary Page
  A user can see the summarized details about a particular patient

  Background:
    Given I am a logged in user

  @patients_p1  @ui_p1
  Scenario: I can see the patient's details
    When I navigate to the patients page
    And I click on one of the patients
    And I collect the patient Api Information
    Then I am taken to the patient details page
    And I should see Patient details breadcrumb
    And I should see the patient's information table
    And I should see the patient's disease information table
    And I should see the main tabs associated with the patient


  @patients_p2 @ui_p2
  Scenario: I can see the details within the Summary tab of the patient
    When I go to patient "PT_SR14_VariantReportUploaded" details page
    And I collect the patient Api Information
    And I click on the "Summary" tab
    Then I should see the "Summary" tab is active
    And I should see the patient's information match database
    And I should see the patient's disease information match the database
    And I should see the "Actions Needed" section heading
    And I should see the "Patient Timeline" section heading
