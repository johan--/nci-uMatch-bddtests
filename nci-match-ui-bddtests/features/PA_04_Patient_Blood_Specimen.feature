@ui_p3 
Feature: Patient Blood Variant Report Tab
  A user can access the details about the Tissue and Blood Variant Report for a patient

  Background:
    Given I am a logged in user
    And I go to patient "PT_CR08_BloodSpecimenUploaded" details page
    Then I am taken to the patient details page

  @ui_p3
  Scenario: Clicking on the Blood Specimens tab lets the user access information about the Patient's Blood variant reports.
    When I click on the "Blood Specimens" tab
    Then I should see the "Blood Specimens" tab is active
    And I can see the "Blood Specimens" table
    And I can see the "Blood Shipments" table 
    Then I logout

  @ui_p3 @test
  Scenario: Navigating to a specific blood variant report lets user see more details.
    When I click on the "Blood Specimens" tab
    And I scroll to the bottom of the page
    And I click the variant report link for "PT_CR08_BloodSpecimenUploaded_ANI1"
    Then I can see the variant report page
    And All the existing checkboxes are checked and disabled
    Then I logout
