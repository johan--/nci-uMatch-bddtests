##
# Created by raseel.mohamed on 6/7/16
##
Feature: Treatment Arms Dashboard
  A user should be able to access the list of Treatment Arms available and
  be able to drill into them to get further details.

  Background:
    Given I stay logged in as "read_only" user


  @ui_p1
  Scenario: A User can access the Treatment Arms list page
    Given I navigate to the treatment-arms page
    Then I should see the Treatment Arms Title
    And I should see the Treatment Arms breadcrumb
    And I should see treatment-arms table
    And I should see the headings in the table
    And I should see data in the table
    When I enter only id "APEC1621-UI" and note stratum "STR100" in the treatment arm filter textbox
    And I collect backend information about the treatment arm
    And I should see the data maps to the relevant column

  @ui_p1
  Scenario: Treatment arms are sorted by id first then stratum
    Given I navigate to the treatment-arms page
    And I select "100" from the treatment arm drop down
    When I enter only id "APEC1621-X" and note stratum "100" in the treatment arm filter textbox
    And I grab all the treatment arm stratum ids from the page
    Then I see that "100" is before "200" in the list


  @ui_p1
  Scenario: Logged in user can access the dashboard of Treatment Arms page
    When I go to treatment arm with "APEC1621-A" as the id and "100" as stratum id
    And I collect backend information about the treatment arm
    Then I should see the treatment-arms detail dashboard
    And I should see detailed Treatment Arms breadcrumb
    And I should see the Name Details
    And I should see the Gene Details
    And I should see three tabs related to the treatment arm

  @ui_p2
  Scenario: Logged in user can access different versions of the treatment arm
    When I go to treatment arm with "APEC1621-UI" as the id and "STR100" as stratum id
    Then I should see the drop down to select different versions of the treatment arm

  @ui_p2
  Scenario: Logged in user can access Patients data on the Analysis Tab
    When I go to treatment arm with "APEC1621-A" as the id and "100" as stratum id
    And I select the "Analysis" Main Tab
    And I collect patient information related to treatment arm
    Then I should see Analysis Details Tab
    And I scroll to the bottom of the page
    And I should see the All Patients Data Table on the Treatment Arm
    And I should see message about the total count of the patients
    And I should see a patient's data in the All Patients Data Table
#    And All Patients Data displays patients that have been ever assigned to "APEC1621-A"

  @ui_p2
  Scenario: Logged in user can access Patients Assignment Outcome on the Analysis Tab
    When I go to treatment arm with "APEC1621-A" as the id and "100" as stratum id
    Then I should see Analysis Details Tab
    And I can see the legend for the charts
    And I should see Patient Assignment Outcome chart
    And I should see Diseases Represented chart

  @ui_p2
  Scenario: Treatment arms are grayed out in the list page and in the details page.
    Given I navigate to the treatment-arms page
    And I enter id "APEC1621-SCTest" in the treatment arm filter textbox
    Then I should see "APEC1621-" is marked as prefix and "SCTest" as the remainder
    When I enter id "APEC1621SC-SCTest" in the treatment arm filter textbox
    Then I should see "APEC1621SC-" is marked as prefix and "SCTest" as the remainder
    When I go to treatment arm with "APEC1621-SCTest" as the id and "100" as stratum id
    Then I should see the "APEC1621-" is marked as prefix and the "SCTest" as remainder in the ID
    When I go to treatment arm with "APEC1621SC-SCTest" as the id and "100" as stratum id
    Then I should see the "APEC1621SC-" is marked as prefix and the "SCTest" as remainder in the ID

  @broken
  Scenario: Logged in user can access the different versions of Treatment Arm under the History Tab
    When I go to treatment arm with "APEC1621-2V" as the id and "100" as stratum id
    And I select the "History" Main Tab
    Then I should see the different versions of the Treatment Arm
    And I "should" be on the latest version
    And I should see the message "This is the latest version." regarding the version
    When I select an another version
    Then I "should not" be on the latest version
    And I should see the message "This is not the latest version." regarding the version


#  @broken @incomplete @ui_p3
#  Scenario: Logged in user can download Treatment Arms in PDF
#    When I go to treatment arm with "APEC1621-UI" as the id and "STR100" as stratum id
#    And I click on the download in PDF Format
#    Then I download the file locally in PDF format
#
#  @broken @incomplete @ui_p3
#  Scenario: Logged in user can download Treatment Arms in Excel
#    When I go to treatment arm with "APEC1621-UI" as the id and "STR100" as stratum id
#    And I click on the download in Excel Format
#    Then I download the file locally in Excel format
