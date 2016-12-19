@patients_get
Feature: Patient GET service tests (valid results)

  Scenario Outline: PT_GV01. Service without id should return valid result
    Given patient GET service name "<service>"
    When GET from MATCH patient API, http code "200" should return
    Then the response type should be "Array"
    And the count of array elements should match database table "<table>"
    And each element of response should have field "<field1>"
    And each element of response should have field "<field2>"
    And each element of response should have field "<field3>"
    Examples:
      | service         | table          | field1                       | field2         | field3              |
      | events          | event          | entity_id                    | event_message  | event_data          |
      | variant_reports | variant_report | variant_report_received_date | tsv_file_name  | total_amois         |
      | variants        | variant        | uuid                         | amois          | variant_type        |
      | assignments     | assignment     | assignment_date              | step_number    | report_status       |
      | shipments       | shipment       | shipped_date                 | carrier        | shipment_type       |
      | patient_limbos  |                | message                      | days_pending   | current_status      |
      | specimens       | specimen       | failed_date                  | collected_date | specimen_type       |
      |                 | patient        | registration_date            | current_status | current_step_number |


  Scenario Outline: PT_GV02. Service without id should return valid projections
    Given patient GET service name "<service>"
    Then add projection: "<projection1>" to patient GET url
    Then add projection: "<projection2>" to patient GET url
    Then add projection: "<projection3>" to patient GET url
    When GET from MATCH patient API, http code "200" should return
    Then the response type should be "Array"
    And each element of response should have 3 fields
    And each element of response should have field "<projection1>"
    And each element of response should have field "<projection2>"
    And each element of response should have field "<projection3>"
    Examples:
      | service         | projection1                  | projection2    | projection3         |
      | events          | entity_id                    | event_message  | event_data          |
      | variant_reports | variant_report_received_date | tsv_file_name  | total_amois         |
      | variants        | uuid                         | amois          | variant_type        |
      | assignments     | assignment_date              | step_number    | sent_to_cog_date    |
      | shipments       | shipped_date                 | carrier        | shipment_type       |
      | patient_limbos  | message                      | days_pending   | current_status      |
      | specimens       | failed_date                  | collected_date | specimen_type       |
      |                 | registration_date            | current_status | current_step_number |


  Scenario Outline: PT_GV03. Service without id should return valid result with parameters
    Given patient GET service name "<service>"
    Then add parameter field: "<field>" and value: "<value>" to patient GET url
    When GET from MATCH patient API, http code "200" should return
    Then the response type should be "Array"
    And the count of array elements should match database table "<table>"
    And each element of response should have field "<field>" with value "<value>"
    Examples:
      | service         | table          | field               | value              |
      | events          | event          | event_type          | patient            |
      | variant_reports | variant_report | status              | PENDING            |
      | variants        | variant        | variant_type        | fusion             |
      | assignments     | assignment     | report_status       | NO_TREATMENT_FOUND |
      | shipments       | shipment       | shipment_type       | SLIDE              |
      | patient_limbos  |                | current_status      | PENDING_APPROVAL   |
      | specimens       | specimen       | study_id            | APEC1621           |
      |                 | patient        | current_step_number | 2.0                |


  Scenario Outline: PT_GV11. Service with id should return valid result
    Given patient GET service name "<service>"
    Then set id: "<id>" for patient GET url
    When GET from MATCH patient API, http code "200" should return
    Then the response type should be "Hash"
    And hash response should have field "<field1>" with value "<id>"
    Examples:
      | service         | id                                   | field1        |
      | events          | ION_AQ04_TsShipped                   | entity_id     |
      | variant_reports | PT_SR10_ProgressReBioY_ANI1          | analysis_id   |
      | variants        | af51e559-db26-498d-9e3e-c9ba19d7507e | uuid          |
      | assignments     | PT_RA07_VrAndAssayReady_ANI1         | analysis_id   |
      | shipments       | PT_RA02_OnTreatmentArm_MOI1          | molecular_id  |
      | shipments       | PT_VC15_VrReceived_BC1               | slide_barcode |
      |                 | PT_RA08_RequestNoAssignment          | patient_id    |


  Scenario Outline: PT_GV12. Service with id should return valid projections
    Given patient GET service name "<service>"
    Then set id: "<value1>" for patient GET url
    Then add projection: "<field1>" to patient GET url
    Then add projection: "<field2>" to patient GET url
    Then add projection: "<field3>" to patient GET url
    When GET from MATCH patient API, http code "200" should return
    Then the response type should be "Hash"
    And each element of response should have 3 fields
    And hash response should have field "<field1>" with value "<value1>"
    And each element of response should have field "<field2>" with value "<value2>"
    And each element of response should have field "<field3>" with value "<value3>"
    Examples:
      | service         | field1                       | value1 | field2         | value2 | field3              | value3 |
      | events          | entity_id                    |        | event_message  |        | event_data          |        |
      | variant_reports | variant_report_received_date |        | tsv_file_name  |        | total_amois         |        |
      | variants        | uuid                         |        | amois          |        | variant_type        |        |
      | assignments     | assignment_date              |        | step_number    |        | sent_to_cog_date    |        |
      | shipments       | shipped_date                 |        | carrier        |        | shipment_type       |        |
      |                 | registration_date            |        | current_status |        | current_step_number |        |

#  not necessary
#  Scenario Outline: PT_GV13. Service with id should return valid result with parameters
#    Examples:


  Scenario Outline: PT_GV21. Service with patient_id should return valid result
    Given patient id is "<patient_id>"
    And patient GET service name "<service>"
    When GET from MATCH patient API, http code "200" should return
    Then the response type should be "Array"
    And the count of array elements should match database table "<table>"
    And each element of response should have field "patient_id" with value "<patient_id>"
    And each element of response should have field "<field1>"
    And each element of response should have field "<field2>"
    And each element of response should have field "<field3>"
    Examples:
      | patient_id                  | service   | table    | field1      | field2         | field3        |
      | PT_RA08_RequestNoAssignment | specimens | specimen | failed_date | collected_date | specimen_type |


  Scenario Outline: PT_GV22. Service with patient_id should return valid projections
    Given patient id is "<patient_id>"
    And patient GET service name "<service>"
    Then add projection: "<projection1>" to patient GET url
    Then add projection: "<projection2>" to patient GET url
    Then add projection: "<projection3>" to patient GET url
    When GET from MATCH patient API, http code "200" should return
    Then the response type should be "Array"
    And each element of response should have 3 fields
    And each element of response should have field "<projection1>"
    And each element of response should have field "<projection2>"
    And each element of response should have field "<projection3>"
    Examples:
      | patient_id                  | service               | projection1      | projection2    | projection3       |
      | PT_VC02_VRUploaded          | action_items          | action_type      | analysis_id    | created_date      |
      | PT_RA08_RequestNoAssignment | treatment_arm_history | treatment_arm_id | version        | assignment_reason |
      | PT_RA08_RequestNoAssignment | specimens             | failed_date      | collected_date | pathology_status  |

  Scenario Outline: PT_GV23. Service with patient_id should return valid result with parameters
    Given patient id is "<patient_id>"
    And patient GET service name "<service>"
    Then add parameter field: "<field>" and value: "<value>" to patient GET url
    When GET from MATCH patient API, http code "200" should return
    Then the response type should be "Array"
    And the count of array elements should match database table "<table>"
    And each element of response should have field "<field>" with value "<value>"
    Examples:
      | patient_id              | service   | table    | field             | value                        |
      | PT_SR09_TsReceivedTwice | specimens | specimen | surgical_event_id | PT_SR09_TsReceivedTwice_SEI2 |


  Scenario Outline: PT_GV31. Service with patient_id and id should return valid result
    Given patient id is "<patient_id>"
    And patient GET service name "<service>"
    Then set id: "<id>" for patient GET url
    When GET from MATCH patient API, http code "200" should return
    Then the response type should be "Hash"
    And hash response should have field "<field1>" with value "<id>"
    Examples:
      | patient_id              | service            | id                           | field1            |
      | PT_RA07_VrAndAssayReady | qc_variant_reports | PT_RA07_VrAndAssayReady_ANI1 | analysis_id       |
      | PT_RA07_VrAndAssayReady | specimens          | PT_RA07_VrAndAssayReady_SEI1 | surgical_event_id |
#      | PT_RA07_VrAndAssayReady | analysis_report       | PT_RA07_VrAndAssayReady_ANI1         | analysis_id       |
#      | patient_id              | analysis_report_amois | af51e559-db26-498d-9e3e-c9ba19d7507e | uuid              |
#      | patient_id              | variant_file_download | PT_RA02_OnTreatmentArm_MOI1          | molecular_id      |
#
#
  Scenario Outline: PT_GV32. Service with patient_id and id should return valid projections
    Given patient id is "<patient_id>"
    And patient GET service name "<service>"
    Then set id: "<value1>" for patient GET url
    Then add projection: "<field1>" to patient GET url
    Then add projection: "<field2>" to patient GET url
    Then add projection: "<field3>" to patient GET url
    When GET from MATCH patient API, http code "200" should return
    Then the response type should be "Hash"
    And each element of response should have 3 fields
    And hash response should have field "<field1>" with value "<value1>"
    And each element of response should have field "<field2>" with value "<value2>"
    And each element of response should have field "<field3>" with value "<value3>"
    Examples:
      | patient_id              | service               | field1                       | value1 | field2        | value2 | field3           | value3 |
      | PT_RA07_VrAndAssayReady | specimens             | entity_id                    |        | event_message |        | event_data       |        |
      | PT_RA07_VrAndAssayReady | analysis_report       | variant_report_received_date |        | tsv_file_name |        | total_amois      |        |
      | PT_RA07_VrAndAssayReady | analysis_report_amois | uuid                         |        | amois         |        | variant_type     |        |
      | patient_id              | qc_variant_reports    | assignment_date              |        | step_number   |        | sent_to_cog_date |        |
      | patient_id              | variant_file_download | shipped_date                 |        | carrier       |        | shipment_type    |        |

#
#  not necessary
#  Scenario Outline: PT_GV33. Service with patient_id and id should return valid result with parameters
#    Examples: