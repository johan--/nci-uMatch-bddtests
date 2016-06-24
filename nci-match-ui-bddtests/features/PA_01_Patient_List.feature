##
# Created by: Raseel Mohamed
#  Date: 06/24/2016
##

Feature:
  A logged in user can access the Patients list page.

  Scenario:
    Given I am a logged in user
    When I navigate to the patients page
    Then I should see the Patients breadcrumb
    And I should see the Patients Title
    And I should see patients table
    And I should see the headings in the patient table
    And I should see data in the patient table