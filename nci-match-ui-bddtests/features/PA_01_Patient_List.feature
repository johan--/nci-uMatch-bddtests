##
# Created by: Raseel Mohamed
#  Date: 06/24/2016
##

Feature:Patients list page
  The user is able to see all the patients and their current status

  @ui_p1
  Scenario: A user can see a list of all the patients registered
    Given I stay logged in as "read_only" user
    When I navigate to the patients page
    Then I should see the Patients breadcrumb
    And I should see the Patients Title
    And I should see patients table
    And I should see the headings in the patient table
    And I should see data in the patient table
    Then I logout
