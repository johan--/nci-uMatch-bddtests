Feature: Patient Report Tab
  A user can access the details about the Tissue and Blood Variant Report for a patient

  Background:
    Given I am a logged in user
    And I go to patient "PT_CR08_BloodSpecimenUploaded" details page

  @ui_p3
  Scenario: Clicking on the Blood Specimens tab lets the user access information about the Patient's Blood variant reports.
    When I click on the "Blood Specimens" tab
    Then I should see the "Blood Specimens" tab is active
    And I can see "Blood Specimens" sub section under "Blood Specimens" Tab
    And I can see "Blood Shipments" sub section under "Blood Specimens" Tab
    And I can see the Blood Specimen details table
    And I can see the Blood Shipment details table
    And I logout

  @ui_p3
  Scenario: Navigating to a spcific blood variant report lets user see more details.
    When I click on the Blood Variant report
    And I collect information on the blood variant report details of patient "PT_CR08_BloodSpecimenUploaded"
    Then I am taken to the report details page.
    And I see the Variant Report details about the specimen
    And All the existing checkboxes are checked and disabled
    And I logout
