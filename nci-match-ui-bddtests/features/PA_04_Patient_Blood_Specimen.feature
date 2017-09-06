@ui_p2 @blood

Feature: Patient Blood SpecimenTab
  A user can access the details about the Blood Specimen for a patient. Note that
  because blood does not have surgical event id, shipments and specimens are listed separately
  and there is no way to tie them to each other.

  Background:
    Given I stay logged in as "VR_Reviewer_mda" user


  Scenario: A User can see and go to the Blood Specimens page
    Given I go to patient "UI_SP01_MultiBdSpecimens" details page
    When I click on the Blood Specimens tab
    Then I should see the "Blood Specimens" tab is active
    And I can see the Blood Specimens table columns
    And I can see the Blood Shipments table columns
    And I can see the "Blood Specimens" section
    And I can see the "Blood Shipments" section


  Scenario: A User can see all the shipments and the specimens for blood on the blood specimens page
    Given I go to patient "UI_SP01_MultiBdSpecimens" details page
    When I collect information about blood shipments for the patient "UI_SP01_MultiBdSpecimens"
  # Then I should see "3" messages of "Specimen of type BLOOD received at NCH." on the front page
  # And I should see "3" messages of "Specimen Shipment of type BLOOD_DNA shipped from NCH." on the front page
    When I click on the Blood Specimens tab
    And I should see entries under the Blood Specimens table match with the backend
    And I should see entries under the Blood Shipments table match with the backend
  # And I verify one entry in the Blood Specimens table with the backend
  # And I verify one entry in the Blood Shipments table with the backend

  Scenario: A user should see the Top level details on the Blood Variant Report tab
    When I go to the patient "PT_VU16_BdVRUploaded" with variant report "PT_VU16_BdVRUploaded_BD_ANI1"
    Then I should see the top level details of the blood variant report
    And I collect information about the patient "PT_VU16_BdVRUploaded" with blood variant report "PT_VU16_BdVRUploaded_BD_ANI1"
    And I should see the top level data maps to the back end call


  Scenario: A user should see the Top level details on the Blood Variant Report tab
    Given I collect information about the patient "PT_VU16_BdVRUploaded" with blood variant report "PT_VU16_BdVRUploaded_BD_ANI1"
    When I go to the patient "PT_VU16_BdVRUploaded" with variant report "PT_VU16_BdVRUploaded_BD_ANI1"
    Then I can see the SNV table for Blood variant report
    And I can see the Gene Fusions table for Blood Variant Report
    And I can see that the SNV table for Blood variant report matches with the backend
    And I can see that the Gene table for Blood variant report matches with the backend

  @ui_p1 
  Scenario: Confirming a Blood variant report will update the status of the report and also inform the activity feed on both dashboard and patient page.
    Given I stay logged in as "VR_Reviewer_mda" user
    When I go to the patient "PT_VU16_BdVRUploaded" with variant report "PT_VU16_BdVRUploaded_BD_ANI1"
    Then I can see the variant report page
    And I scroll to the bottom of the page
    And I click on the "CONFIRM" button
    Then I "should" see the confirmation modal pop up
    When I click on the "OK" button
    Then The variant report status is marked "CONFIRMED"
