@ui_p2 @blood

Feature: Patient Blood SpecimenTab
  A user can access the details about the Blood Specimen for a patient. Note that
  because blood does not have surgical event id, shipments and specimens are listed separately
  and there is no way to tie them to each other.

  Background:
  Given I stay logged in as "VR_Reviewer_mda" user
  And I go to patient "UI_SP01_MultiBdSpecimens" details page
  

  Scenario: A User can see and go to the Blood Specimens page
  When I click on the Blood Specimens tab
  Then I should see the "Blood Specimens" tab is active
  And I can see the Blood Specimens table columns
  And I can see the Blood Shipments table columns
  And I can see the "Blood Specimens" section
  And I can see the "Blood Shipments" section
    

  Scenario: A User can see all the shipments and the specimens for blood on the blood specimens page
  When I collect information about blood shipments for the patient "UI_SP01_MultiBdSpecimens"
  Then I should see "3" messages of "Specimen of type BLOOD received at NCH." on the front page
  And I should see "3" messages of "Specimen Shipment of type BLOOD_DNA shipped from NCH." on the front page
  When I click on the Blood Specimens tab
  And I should see entries under the Blood Specimens table match with the backend
  And I should see entries under the Blood Shipments table match with the backend
  # And I verify one entry in the Blood Specimens table with the backend
  # And I verify one entry in the Blood Shipments table with the backend
