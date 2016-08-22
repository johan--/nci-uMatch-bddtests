##
# Created by: Raseel Mohamed
#  Date: 08/17/2016
##

@ui
Feature: Dashboard page.
  This feature deals with all the front page elements.

  Background:
    Given I am a logged in user

  Scenario: A user can see the Pending Review Section
    When I navigate to the dashboard page
    Then I can see the Pending Review Section
    And I can see the pending "Tissue Variant Reports" subtab
    And I can see the pending "Blood Variant Reports" subtab
    And I can see the pending "Assignment Reports" subtab

  Scenario: A User can see the Patients Statistics Section
    When I navigate to the dashboard page
    Then I can see the Patients Statistics Section
    And I can see the Donut chart for confirmed patients with aMOI
    And I can see the Treatment Arm Accrual chart


  Scenario Outline: Pending <report_type> reports statistics match pending reports table.
    When I navigate to the dashboard page.
    And I collect information for the Dashboard
    Then count of "<report_type>" table match with the "<report_type>" statistics
    And if the "<report_type>" table is empty the message
    Examples:
    |report_type            |
    |Tissue Variant Reports |
    |Blood Variant Reports  |
    |Assignment Reports     |
