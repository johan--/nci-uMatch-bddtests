##
# Created by: Raseel Mohamed
#  Date: 08/17/2016
##
Feature: Dashboard page.
  This feature deals with all the front page elements.

  Background:
    Given I am logged in as a "VR_Reviewer_mda" user
  @demo_p1
  @ui_p1
  Scenario: A User can see the Patients Statistics Section
    When I navigate to the dashboard page
    Then I can see the Dashboard banner
    And I can see all sub headings under the top Banner
    And I can see the Patients Statistics Section
    And I collect "patientStats" data from backend
    And I can see the Registered Patients count
    And I can see the Patients with Confirmed Variants count
    And I can see the Patients on Treatment Arms count
    And I collect "pendingItems" data from backend
    And I can see patients with Pending Tissue Variant Reports
    And I can see patients with Pending Assignment Reports
    And I collect "pendingReportStats" data from backend
    Then I can see Sequenced and confirmed patients data
    And I collect "patientStats" data from backend
    Then I can see the Treatment Arm Accrual chart data

  @demo_p1
  @ui_p1
  Scenario: A user can see the Pending Review Section
    Then I can see the Dashboard banner
    And I can see the Pending Review Section Heading
    And I can see the pending "Tissue Variant Reports" subtab
    And I can see the pending "Assignment Reports" subtab

  @ui_p1
  Scenario Outline: Pending <report_type> reports statistics match pending reports table.
    When I can see the Dashboard banner
    And I collect information for "<report_type>" Dashboard
    And I click on the "<report_type>" sub-tab
    And I select "100" from the "<report_type>" drop down
    And Count of "<report_type>" table match with back end data
    And Appropriate Message is displayed for empty or filled pending "<report_type>" reports
    Examples:
    |report_type            |
    |Tissue Variant Reports |
    |Assignment Reports     |

  @ui_p2
  Scenario: User can filter results on the page
    When I click on the "Tissue Variant Reports" sub-tab
    And I enter "PT_SS27_VariantReportUploaded" in the "Tissue Variant Reports" filter textbox
    Then I see that only "1" row of "Tissue Variant Reports" data is seen
    And The patient id "PT_SS27_VariantReportUploaded" is displayed in "Tissue Variant Reports" table

  @ui_p1
  Scenario: User can see the last 10 messages in the Activity feed
    When I collect information on the timeline
    Then I can see the Activity Feed section
    And I can see "10" entries in the section
    And They match with the timeline response in order

  @ui_p2
  Scenario Outline: Pending <report_type> report table look and feel
    When I click on the "<report_type>" sub-tab
    Then The "<report_type>" sub-tab is active
    And The "<report_type>" data columns are seen
    Examples:
      |report_type            |
      |Tissue Variant Reports |
      |Assignment Reports     |

  @ui_p2
  Scenario: User can find a list of all the patients in limbo with their reason
    When I collect information on patients in limbo
    Then I can see table of Patients Awaiting Further Action Or Information
    And I can see a list of patients and the reasons why they are in limbo.
    When I search for "TISSUE_SPECIMEN_RECEIVED" in the limbo table search field
    Then I should see "Tissue DNA and RNA shipment missing" in the limbo table message
    Then I should see "Slide shipment missing" in the limbo table message
    When I search for "TISSUE_VARIANT_REPORT_RECEIVED" in the limbo table search field
    Then I should see "Variant report missing" in the limbo table message
    Then I should see "Slide shipment missing" in the limbo table message
    When I search for "TISSUE_NUCLEIC_ACID_SHIPPED" in the limbo table search field
    Then I should see "Variant report missing" in the limbo table message
    Then I should see "Slide shipment missing" in the limbo table message
    When I search for "TISSUE_VARIANT_REPORT_CONFIRMED" in the limbo table search field
    Then I should see "Slide shipment missing" in the limbo table message
    When I search for "TISSUE_VARIANT_REPORT_RECEIVED" in the limbo table search field
    Then I should see "Variant report missing" in the limbo table message
    When I search for "TISSUE_SLIDE_SPECIMEN_SHIPPED" in the limbo table search field
    Then I should see "Tissue DNA and RNA shipment missing" in the limbo table message
    Then I should see "PTEN assay result missing" in the limbo table message
    Then I should see "BAF47 assay result missing" in the limbo table message
    Then I should see "BRG1 assay result missing" in the limbo table message

    @ui_p2
    Scenario: User can see details about the patient in the limbo table
    When I search for "PT_VU09_VariantReportUploaded" in the limbo table search field
    And I click on the chevron link to expand details for patient "PT_VU09_VariantReportUploaded"
    And I collect information about the patient "PT_VU09_VariantReportUploaded" under limbo
    Then I can see a list of assays under the limbo table for patient "PT_VU09_VariantReportUploaded"
    And I can see details that can be provided about the specimen under the limbo table for patient "PT_VU09_VariantReportUploaded"
    And I can see the actual details about the specimen under the limbo table for patient "PT_VU09_VariantReportUploaded"
    And I can see that the Surgical Event id is a link for patient "PT_VU09_VariantReportUploaded"
    And I can see that the Molecular id is a link for patient "PT_VU09_VariantReportUploaded"
    And I can see that the Analysis id is a link for patient "PT_VU09_VariantReportUploaded"

