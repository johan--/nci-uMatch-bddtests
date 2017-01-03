@patients_get
Feature: Patient GET service tests (false results)


########## PT_GF_NI Services without id /api/v1/patients/service(.:format)
  Scenario Outline: PT_GF_NI01. Invalid projections should be ignored
    Given patient GET service: "<service>", patient id: "", id: ""
    Then add projection: "INVALID_PROJECTION" to patient GET url
    When GET from MATCH patient API, http code "200" should return
    Then the response type should be "Array"
    And each element of response should have 0 fields
    Examples:
      | service         |
      | events          |
      | variant_reports |
      | variants        |
      | assignments     |
      | shipments       |
      | patient_limbos  |
      | specimens       |
      |                 |
#
  Scenario Outline: PT_GF_NI02. Service should return 404 and empty result if no resource match query parameters
    Given patient GET service: "<service>", patient id: "", id: ""
    Then add parameter field: "<parameter>" and value: "INVALID_VALUE" to patient GET url
    When GET from MATCH patient API, http code "404" should return
    Then the response message should be empty
    Examples:
      | service         | parameter         |
      | events          | entity_id         |
      | variant_reports | tsv_file_name     |
      | variants        | uuid              |
      | assignments     | report_status     |
      | shipments       | shipment_type     |
      | patient_limbos  | current_status    |
      | specimens       | specimen_type     |
      |                 | registration_date |
#
########## PT_GF_WI Services with id /api/v1/patients/service/:id(.:format)
  Scenario Outline: PT_GF_WI01. Service should return 404 and empty result if provided id has no this type of resource
    Given patient GET service: "<service>", patient id: "", id: "<id>"
    When GET from MATCH patient API, http code "404" should return
    Then the response message should be empty
    Examples:
      | service     | id                           | field1      |
      | assignments | PT_RA07_VrAndAssayReady_ANI1 | analysis_id |

  Scenario Outline: PT_GF_WI02. Service should return 404 and empty result if provided id doesn't exist
    Given patient GET service: "<service>", patient id: "", id: "INVALID_ID"
    When GET from MATCH patient API, http code "404" should return
    Then the response message should be empty
    Examples:
      | service         |
      | events          |
      | variant_reports |
      | variants        |
      | assignments     |
      | shipments       |
      |                 |

  Scenario Outline: PT_GF_WI03. Invalid projections should be ignored
    Given patient GET service: "<service>", patient id: "", id: "<id>"
    Then add projection: "bad_pro" to patient GET url
    When GET from MATCH patient API, http code "200" should return
    Then the response type should be "Array"
    And each element of response should have 0 fields
    Examples:
      | service         | id                                   |
      | events          | ION_AQ04_TsShipped                   |
      | variant_reports | PT_SR10_ProgressReBioY_ANI1          |
      | variants        | af51e559-db26-498d-9e3e-c9ba19d7507e |
      | assignments     | PT_RA07_VrAndAssayReady_ANI1         |
      | shipments       | PT_RA02_OnTreatmentArm_MOI1          |
      | patient_limbos  | PT_VC15_VrReceived_BC1               |
      | specimens       | PT_RA08_RequestNoAssignment          |
      |                 |                                      |
#
  Scenario Outline: PT_GF_WI04. Service should return 404 and empty result if no resource match query parameters
    Given patient GET service: "<service>", patient id: "", id: "<id>"
    Then add parameter field: "<parameter>" and value: "INVALID_VALUE" to patient GET url
    When GET from MATCH patient API, http code "404" should return
    Then the response message should be empty
    Examples:
      | service         | id                                   | parameter           |
      | events          | ION_AQ04_TsShipped                   | event_type          |
      | variant_reports | PT_SR10_ProgressReBioY_ANI1          | status              |
      | variants        | af51e559-db26-498d-9e3e-c9ba19d7507e | variant_type        |
      | assignments     | PT_RA07_VrAndAssayReady_ANI1         | report_status       |
      | shipments       | PT_RA02_OnTreatmentArm_MOI1          | shipment_type       |
      | patient_limbos  | PT_VC15_VrReceived_BC1               | current_status      |
      | specimens       | PT_RA08_RequestNoAssignment          | study_id            |
      |                 |                                      | current_step_number |
#
########## PT_GF_WP Services with patient_id /api/v1/patients/:patient_id/service(.:format)
  Scenario Outline: PT_GF_WP01. Service should return 404 and empty result if patient_id has no this type of resource
    Given patient GET service: "<service>", patient id: "<patient_id>", id: ""
    When GET from MATCH patient API, http code "404" should return
    Then the response message should be empty
    Examples:
      | patient_id         | service               |
      | PT_SR05_Registered | specimens             |
      | PT_SR05_Registered | treatment_arm_history |
      | PT_SR05_Registered | specimen_events       |
#
  Scenario Outline: PT_GF_WP02. Service should return 404 and empty result if patient_id doesn't exist
    Given patient GET service: "<service>", patient id: "INVALID_PT", id: ""
    When GET from MATCH patient API, http code "404" should return
    Then the response message should be empty
    Examples:
      | service               |
      | specimens             |
      | treatment_arm_history |
      | specimen_events       |
      | action_items          |

  Scenario Outline: PT_GF_WP03. Invalid projections should be ignored
    Given patient GET service: "<service>", patient id: "<patient_id>", id: ""
    And add projection: "INVALID_PROJECTION" to patient GET url
    When GET from MATCH patient API, http code "200" should return
    Then the response type should be "Array"
    And each element of response should have 0 fields
    Examples:
      | patient_id             | service               |
      | PT_SS26_TsVRReceived   | specimens             |
      | PT_RA02_OnTreatmentArm | treatment_arm_history |
      | PT_SS26_TsVRReceived   | action_items          |

#
  Scenario Outline: PT_GF_WP04. Service should return 200 and empty array if no resource match query parameters
    Given patient GET service: "<service>", patient id: "<patient_id>", id: ""
    And add parameter field: "<field>" and value: "INVALID_VALUE" to patient GET url
    When GET from MATCH patient API, http code "200" should return
    Then the response type should be "<type>"
    And response should have 0 fields
    Examples:
      | patient_id             | service               | field           | type  |
      | PT_SS26_TsVRReceived   | specimens             | specimen_type   | Array |
      | PT_RA02_OnTreatmentArm | treatment_arm_history | stratum_id      | Array |
      | PT_SS26_TsVRReceived   | specimen_events       | blood_shipments | Hash  |
      | PT_SS26_TsVRReceived   | action_items          | molecular_id    | Array |
#
########## PT_GF_PI Services with patient_id and id /api/v1/patients/:patient_id/service/:id(.:format)
  Scenario Outline: PT_GF_PI01. Service should return 404 and empty result if id doesn't exist
    Given patient GET service: "<service>", patient id: "<patient_id>", id: "INVALID_ID"
    When GET from MATCH patient API, http code "404" should return
    Then the response message should be empty
    Examples:
      | patient_id             | service               |
      | PT_RA02_OnTreatmentArm | specimens             |
      | PT_RA02_OnTreatmentArm | analysis_report       |
      | PT_RA02_OnTreatmentArm | analysis_report_amois |
      | PT_RA02_OnTreatmentArm | qc_variant_reports    |
      | PT_RA02_OnTreatmentArm | variant_file_download |
#
  Scenario Outline: PT_GF_PI02. Service should return 404 and empty result if patient_id doesn't exist
    Given patient GET service: "<service>", patient id: "INVALID_ID", id: "PT_RA02_OnTreatmentArm_ANI1"
    When GET from MATCH patient API, http code "404" should return
    Then the response message should be empty
    Examples:
      | service               |
      | specimens             |
      | analysis_report       |
      | analysis_report_amois |
      | qc_variant_reports    |
      | variant_file_download |
#
  Scenario Outline: PT_GF_PI05. Invalid projections should be ignored
    Given patient GET service: "<service>", patient id: "<patient_id>", id: "<patient_id>_ANI1"
    And add projection: "<INVALID_PROJECTION>" to patient GET url
    When GET from MATCH patient API, http code "200" should return
    Then the response type should be "Array"
    And each element of response should have 0 fields
    Examples:
      | patient_id             | service               |
      | PT_RA02_OnTreatmentArm | specimens             |
      | PT_RA02_OnTreatmentArm | analysis_report       |
      | PT_RA02_OnTreatmentArm | analysis_report_amois |
      | PT_RA02_OnTreatmentArm | qc_variant_reports    |
      | PT_RA02_OnTreatmentArm | variant_file_download |
#
  Scenario Outline: PT_GF_PI06. Service should return 200 and empty array if no resource match query parameters
    Given patient GET service: "<service>", patient id: "<patient_id>", id: "<patient_id>_ANI1"
    And add parameter field: "<field>" and value: "INVALID_VALUE" to patient GET url
    When GET from MATCH patient API, http code "200" should return
    Then the response type should be "Array"
    And each element of response should have 0 fields
    Examples:
      | patient_id             | service               | field             |
      | PT_RA02_OnTreatmentArm | specimens             | surgical_event_id |
      | PT_RA02_OnTreatmentArm | analysis_report       | variant_report    |
      | PT_RA02_OnTreatmentArm | analysis_report_amois | analysis_id       |
      | PT_RA02_OnTreatmentArm | qc_variant_reports    | ion_reporter_id   |
      | PT_RA02_OnTreatmentArm | variant_file_download | tsv_file_name     |

