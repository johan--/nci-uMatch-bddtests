##
# Created by: Raseel Mohamed
#  Date: 06/24/2016
##

Feature: Patient Summary Page
  A user can see the summarized details about a particular patient


  Background:
    Given I am a logged in user
    And I navigate to the patients page

  @patient  @broken
  Scenario: I can see the patient's details
    When I click on one of the patients
#    And I collect the patient Api Information
    Then I am taken to the patient details page
    And I should see Patient details breadcrumb
    And I should see the patient's information table
#    And I should see the patient's information match database
    And I should see the patient's disease information table
#    And I should see the patient's disease information match the database
    And I should see the main tabs associated with the patient

  @patient @broken
  Scenario: I can see the details within the Summary tab of the patient
    When I click on one of the patients
    And I click on the "Summary" tab
    Then I should see the "Summary" tab is active
#    And I should see the Actions Needed section with data about the patient
    And I should see the  Treatment Arm History about the patient
#    And I should see the Patient Timeline section with the timeline about the patient
