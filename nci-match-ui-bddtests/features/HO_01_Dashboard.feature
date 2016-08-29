##
# Created by: Raseel Mohamed
#  Date: 08/17/2016
##

@ui
Feature: Dashboard page.
  This feature deals with all the front page elements.

  Background:
    Given I am a logged in user

  Scenario: A User can see the Patients Statistics Section
    When I navigate to the dashboard page
    Then I can see the Dashboard banner
    And I can see the Patients Statistics Section
    And I can see Patients Statistics data

  Scenario: A User can see the Sequenced and Confirmed Patients section
    When I navigate to the dashboard page
    Then I can see sequenced and confirmed patients section
    And I can see Sequenced and confirmed patients data

  Scenario: A User can see the Treatment Arm Accrual Section
    When I navigate to the dashboard page
    Then I can see the Treatment Arm Accrual chart
    And I can see the Treatment Arm Accrual chart data

  Scenario: A user can see the Pending Review Section
    When I navigate to the dashboard page
    Then I can see the Pending Review Section Heading
    And I can see the pending "Tissue Variant Reports" subtab
    And I can see the pending "Blood Variant Reports" subtab
    And I can see the pending "Assignment Reports" subtab

  Scenario Outline: Pending <report_type> reports statistics match pending reports table.
    When I navigate to the dashboard page
    And I collect information for "<report_type>" Dashboard
    And I click on the "<report_type>" sub-tab
    Then The "<report_type>" sub-tab is active
    And The "<report_type>" data columns are seen
    And I select "100" from the "<report_type>" drop down
    And Count of "<report_type>" table match with back end data
    And Appropriate Message is displayed for empty or filled pending "<report_type>" reports
    Examples:
    |report_type            |
    |Tissue Variant Reports |
    |Blood Variant Reports  |
    |Assignment Reports     |

  Scenario: User can filter results on the page
    When I navigate to the dashboard page
    And I click on the "Tissue Variant Reports" sub-tab
    And I enter "PT_SS27_VariantReportUploaded" in the "Tissue Variant Reports" filter textbox
    Then I see that only "1" row of "Tissue Variant Reports" data is seen
    And The patient id "PT_SS27_VariantReportUploaded" is displayed in "Tissue Variant Reports" table
