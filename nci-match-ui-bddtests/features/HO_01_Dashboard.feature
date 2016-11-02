##
# Created by: Raseel Mohamed
#  Date: 08/17/2016
##

Feature: Dashboard page.
  This feature deals with all the front page elements.

  Background:
    Given I am a logged in user
  @demo_p1
  @ui_p1
  Scenario: A User can see the Patients Statistics Section
    When I navigate to the dashboard page
    Then I can see the Dashboard banner
    And I can see all sub headings under the top Banner
    And I can see the Patients Statistics Section
    And I collect "patientStats" data from backend
    And I can see Patients Statistics data
    And I collect "pendingTissueVR" data from backend
    And I can see patients with Pending Tissue Variant Reports
#    And I collect "pendingBloodVR" data from backend
#    And I can see patients with Pending Blood Variant Reports
    And I collect "pendingAssignment" data from backend
    And I can see patients with Pending Assignment Reports
    And I collect "pendingReportStats" data from backend
    Then I can see Sequenced and confirmed patients data
    And I collect "patientStats" data from backend
    Then I can see the Treatment Arm Accrual chart data

  @demo_p1
  @ui_p1
  Scenario: A user can see the Pending Review Section
    When I navigate to the dashboard page
    Then I can see the Pending Review Section Heading
    And I can see the pending "Tissue Variant Reports" subtab
#    And I can see the pending "Blood Variant Reports" subtab
    And I can see the pending "Assignment Reports" subtab

  @ui_p1
  Scenario Outline: Pending <report_type> reports statistics match pending reports table.
    When I navigate to the dashboard page
    And I collect information for "<report_type>" Dashboard
    And I click on the "<report_type>" sub-tab
    And I select "100" from the "<report_type>" drop down
    And Count of "<report_type>" table match with back end data
    And Appropriate Message is displayed for empty or filled pending "<report_type>" reports
    Examples:
    |report_type            |
    |Tissue Variant Reports |
    |Assignment Reports     |
#    |Blood Variant Reports  |

  @ui_p3
  Scenario: User can filter results on the page
    When I navigate to the dashboard page
    And I click on the "Tissue Variant Reports" sub-tab
    And I enter "PT_SS27_VariantReportUploaded" in the "Tissue Variant Reports" filter textbox
    Then I see that only "1" row of "Tissue Variant Reports" data is seen
    And The patient id "PT_SS27_VariantReportUploaded" is displayed in "Tissue Variant Reports" table

  @ui_p1
  Scenario: User can see the last 10 messages in the Activity feed
    When I navigate to the dashboard page
    And I collect information on the timeline
    Then I can see the Activity Feed section
    And I can see "10" entries in the section
    And They match with the timeline response in order

  @ui_p3
  Scenario Outline: Pending <report_type> report table look and feel
    When I navigate to the dashboard page
    And I click on the "<report_type>" sub-tab
    Then The "<report_type>" sub-tab is active
    And The "<report_type>" data columns are seen
    Examples:
      |report_type            |
      |Tissue Variant Reports |
#      |Blood Variant Reports  |
      |Assignment Reports     |
