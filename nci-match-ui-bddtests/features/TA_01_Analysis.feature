##
# Created by raseel.mohamed on 6/7/16
##

Feature: Treatment Arms Dashboard
  A user should be able to access the list of Treatment Arms available and
  be able to drill into them to get further details.

  Background:
    Given I am a logged in user
    And I navigate to the treatment-arms page

  @treatment_arm @ui
  Scenario: A User can access the Treatment Arms list page
    When I navigate to the treatment-arms page
    Then I should see the Treatment Arms Title
    And I should see the Treatment Arms breadcrumb
    And I should see treatment-arms table
    And I should see the headings in the table
    And I should see data in the table

  @treatment_arm @ui
  Scenario: Logged in user can access the dashboard of Treatment Arms page
    When I click on one of the treatment arms
    And I collect backend information about the treatment arm
    Then I should see the treatment-arms detail dashboard
    And I should see detailed Treatment Arms breadcrumb
    And I should see the Name Details
    And I should see the Gene Details
    And I should see three tabs related to the treatment arm

  @treatment_arm @ui
  Scenario: Logged in user can access different versions of the treatment arm
    When I click on one of the treatment arms
    Then I should see the drop down to select different versions of the treatment arm

  @treatment_arm @ui
  Scenario: Logged in user can access Patients data on the Analysis Tab
    When I click on one of the treatment arms
    And I select the Analysis Main Tab
    Then I should see Analysis Details Tab
    And I should see the All Patients Data Table on the Treatment Arm
    And I should see data in the All Patients Data Table

  @treatment_arm @ui
  Scenario: Logged in user can access Patients Assignment Outcome on the Analysis Tab
    When I click on one of the treatment arms
    Then I should see Analysis Details Tab
    And I can see the legend for the charts
    And I should see Patient Assignment Outcome chart
    And I should see Diseases Represented chart

  @treatment_arm @incomplete @ui @broken
  Scenario: Logged in user can download Treatment Arms in PDF
    When I click on one of the treatment arms
    And I click on the download in PDF Format
    Then I download the file locally in PDF format

  @treatment_arm @incomplete @ui @broken
  Scenario: Logged in user can download Treatment Arms in Excel
    When I click on one of the treatment arms
    And I click on the download in Excel Format
    Then I download the file locally in Excel format

  @treatment_arm @ui @broken
  Scenario: Logged in user can access the different versions of Treatment Arm under the History Tab
    When I click on one of the treatment arms
    And I select the History Main Tab
    Then I should see the different versions of the Treatment Arm
