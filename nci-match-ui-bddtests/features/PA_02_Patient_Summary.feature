##
# Created by: Raseel Mohamed
#  Date: 06/24/2016
##

Feature: Patient Summary Page
  A user can see the summarized details about a particular patient

  Background:
    Given I am a logged in user

  @ui_p1
  Scenario: I can see the patient's details
    When I navigate to the patients page
    And I enter "PT_CR02_OnTreatmentArm" in the patient filter field
    And I click on one of the patients
    And I collect the patient Api Information
    Then I am taken to the patient details page
    And I turn off synchronization
    And I should see Patient details breadcrumb
    And I should see the patient's information table
    And I should see the patient's disease information table
    And I should see the main tabs associated with the patient
    Then I logout

  @ui_p2 @test
  Scenario: I can see the details within the Summary tab of the patient
    When I go to patient "PT_CR02_OnTreatmentArm" details page
    And I collect the patient Api Information
    And I turn off synchronization
    Then I should see the "Summary" tab is active
    And I should see the patient's information match database
    And I should see the patient's disease information match the database
    And I should see the "Patient Timeline" section heading
    Then I logout

  @ui_p2
  Scenario: I can see COG Message in Activity Feed
    When I go to patient "UI_EM_OffStudy" details page
    Then I should see the "Summary" tab is active
    And I scroll to the bottom of the page
    And I should see the "Patient Timeline" section heading
    And I should see a message "Patient is deceased." in the timeline
    Then I logout
