##
# Created by: Raseel Mohamed
#  Date: 06/24/2016
##

Feature: A logged in user can access details about a patient.

  Background:
    Given I am a logged in user
    And I navigate to the patients page

  Scenario: I can see the patients details
    When I click on one of the patients
    Then I am taken to the patient details page.
    And I should see Patient details breadcrumb
    And I should see the patient's information
    And I should see the patient's disease information
    And I should see the main tabs associated with the patient


  Scenario:
    When I click on one of the patients
    And I click on the "Summary" tab
    Then I should see the "Summary" tab is active
    And I should see the Actions Needed section with data about the patient
    And I should see the Patient Timeline section with the timeline about the patient

  Scenario:
    When I click on one of the patients
    And I click on the "Surgical Event" tab
    Then I should see the "Surgical Event" tab is active
    And I should see the Surgical Event drop down
    And I should see the Specimen Section
    And I should see the Pathology Section
    And I should see the Assay History Section
    And I should see the Latest Analysis Section
    And I shoild see the Specimen History section


  Scenario:
    When I click on one of the patients
    And I click on the "Variant Report" tab
    Then I should see the "Variant Report" tab is active
    And I should see the Variant Report drop down

