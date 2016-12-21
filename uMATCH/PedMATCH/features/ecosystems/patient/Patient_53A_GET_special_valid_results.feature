@patients_get
Feature: Patient GET service valid special case tests

  Scenario: PT_SC01a statistics service should have correct result
    Given patient GET service name "statistics"
    When GET from MATCH patient API, http code "200" should return
    Then patient statistics field "number_of_patients" should have correct value
    Then patient statistics field "number_of_patients_on_treatment_arm" should have correct value
    Then patient statistics field "number_of_patients_with_confirmed_variant_report" should have correct value
    Then patient statistics field "treatment_arm_accrual" should have correct value

  Scenario: PT_SC01b statistics service should update number_of_patients properly

  Scenario Outline: PT_SC01b statistics service should update number_of_patients_with_confirmed_variant_report properly
    Given patient id is "<patient_id>"
    Examples:
      | patient_id          |
      | no vr confirmed     |
      | vr confirmed before |

  Scenario Outline: PT_SC01c statistics service should update treatment arm values properly
    Given patient id is "<patient_id>"
    Examples:
      | patient_id       |
      | not on ta before |
      | on ta before     |

  Scenario: PT_SC02a pending_items should have correct result
    Given patient GET service name "pending_items"
    When GET from MATCH patient API, http code "200" should return
    Then patient pending_items field "tissue_variant_reports" should have correct value
    Then patient pending_items field "assignment_reports" should have correct value

  Scenario: PT_SC02b pending_items should increase tissue_variant_reports value properly
  Scenario: PT_SC02c pending_items should decrease tissue_variant_reports value properly
  Scenario: PT_SC02d pending_items should increase assignment_reports value properly
  Scenario: PT_SC02e pending_items should decrease assignment_reports value properly
# /api/v1/patients/amois(.:format)

  Scenario Outline: PT_SC04a patient_limbos should not have record for patients with certain status
    Given patient GET service name "patient_limbos"
    Then add parameter field: "patient_id" and value: "<patient_id>" to patient GET url
    When GET from MATCH patient API, http code "404" should return

    Examples:
      | patient_id                     |
      | PT_SC04a_Registered            |
      | PT_SC04a_PendingConfirmation   |
      | PT_SC04a_PendingApproval       |
      | PT_SC04a_OffStudy              |
      | PT_SC04a_OffStudyBiopsyExpired |
      | PT_SC04a_RequestAssignment     |
      | PT_SC04a_RequestNoAssignment   |
      | PT_SC04a_OnTreatmentArm        |
      | PT_SC04a_CompassionateCare     |
      | PT_SC04a_NoTaAvailable         |

#  Scenario Outline: PT_SC04b patient_limbos should have correct value
#    Given patient id is "<patient_id>"
#    And patient GET service name "patient_limbos"
#    Then add parameter field: "patient_id" and value: "<patient_id>" to patient GET url
#    When GET from MATCH patient API, http code "200" should return
#    Then this patient patient_limbos current_status should be "<status>"
#    Then this patient patient_limbos active "surgical_event_id" should be "<sei>"
#    Then this patient patient_limbos active "specimen_collected_date" should be "<scd>"
#    Then this patient patient_limbos active "active_molecular_id" should be "<moi>"
#    Then this patient patient_limbos active "active_molecular_id_shipped_date" should be "<msd>"
#    Then this patient patient_limbos message should contain "<contain_message>" not "<not_contain_message>"
#    Then this patient patient_limbos days_pending should be correct
#    Examples:
#      | patient_id | status | sei | scd | moi | msd | contain_message | not_contain_message |
#
#  Scenario: PT_SC04c patient_limbos should update properly after tissue is shipped
#
#  Scenario: PT_SC04d patient_limbos should update properly after assay is received
#
#  Scenario: PT_SC04e patient_limbos should update properly after variant report is confirmed
#
#  Scenario: PT_SC04f patient_limbos should update properly after new tissue specimen is received
#
#  Scenario: PT_SC04g patient_limbos should remove patient once this patient change to OFF_STUDY
#
#  Scenario: PT_SC04h patient_limbos should remove patient once this patient change to OFF_STUDY_BIOPSY_EXPIRED
#
#  Scenario: PT_SC04i patient_limbos should remove patient once this patient change to REQUEST_NO_ASSIGNMENT
## /api/v1/patients/:patient_id/action_items(.:format)
#  PT_SS26_TsVRReceived
## /api/v1/patients/:patient_id/treatment_arm_history(.:format)
#  Scenario Outline: PT_SC07a specimen_events should have correct value
#    Given patient id is "<patient_id>"
#    And patient GET service name "specimen_events"
#    When GET from MATCH patient API, http code "200" should return
#    Then this patient specimen_events type "tissue_specimens" should have "<tissue_count>" elements
#    Then this patient specimen_events type "blood_specimens" should have "<blood_count>" elements
#    Examples:
#      | patient_id | tissue_count | blood_count |
#
#  Scenario Outline: PT_SC07b specimen_events should update properly
#    Given patient id is "<patient_id>"
#    And patient GET service name "specimen_events"
#    When GET from MATCH patient API, http code "200" should return
#    Then this patient specimen_events type "tissue_specimens" should have "<tissue_before>" elements
#    Then this patient specimen_events type "blood_specimens" should have "<blood_before>" elements
#    Then template specimen received message for this patient (type: "<specimen_type>", surgical_event_id: "<sei>")
#    When GET from MATCH patient API, http code "200" should return
#    Then this patient specimen_events type "tissue_specimens" should have "<tissue_after>" elements
#    Then this patient specimen_events type "blood_specimens" should have "<blood_after>" elements
#    Examples:
#      | patient_id | tissue_before | blood_before | specimen_type | sei | tissue_after | blood_after |
