#encoding: utf-8
#@patients
@patients_end_to_end
Feature: Patients end to end tests
  Scenario: PT_ETE01. patient can reach step 4.1 successfully
    Given patient: "PT_ETE01" with status: "REGISTRATION" on step: "1.0"
    Then tissue specimen received with surgical_event_id: "PT_ETE01_SEI1"
    Then blood specimen received
    Then tissue specimen shipped with molecular_id: "PT_ETE01_MOI1"
    Then slide specimen shipped with barcode: "PT_ETE01_BC1"
    Then blood specimen shipped with molecular_id: "PT_ETE01_BD_MOI1"
    Then ICCPTENs assay result received result: "NEGATIVE"
    Then ICCMLH1s assay result received result: "NEGATIVE"
    Then pathology confirmed with status: "Y"
    Then tissue variant report uploaded with analysis_id: "PT_ETE01_ANI1"
    Then blood variant report uploaded with analysis_id: "PT_ETE01_ANI2"
    Then tissue variant report confirmed with status: "CONFIRMED"
    Then blood variant report confirmed with status: "REJECTED"
    Then wait for "60" seconds
    When retrieve patient: "PT_ETE01" from API
    Then returned patient has value: "ON_TREATMENT_ARM" in field: "current_status"
    Then returned patient has value: "1.1" in field: "current_step_number"
    Then patient has new assignment request with re-biopsy: "true"
    Then tissue specimen received with surgical_event_id: "PT_ETE01_SEI2"
    Then blood specimen received
    Then tissue specimen shipped with molecular_id: "PT_ETE01_MOI2"
    Then slide specimen shipped with barcode: "PT_ETE01_BC2"
    Then blood specimen shipped with molecular_id: "PT_ETE01_BD_MOI2"
    Then ICCPTENs assay result received result: "POSITIVE"
    Then ICCMLH1s assay result received result: "INDETERMINATE"
    Then pathology confirmed with status: "Y"
    Then tissue variant report uploaded with analysis_id: "PT_ETE01_ANI3"
    Then blood variant report uploaded with analysis_id: "PT_ETE01_ANI4"
    Then tissue variant report confirmed with status: "CONFIRMED"
    Then blood variant report confirmed with status: "CONFIRMED"
    Then wait for "60" seconds
    When retrieve patient: "PT_ETE01" from API
    Then returned patient has value: "ON_TREATMENT_ARM" in field: "current_status"
    Then returned patient has value: "2.1" in field: "current_step_number"
    Then patient has new assignment request with re-biopsy: "false"
    Then wait for "60" seconds
    When retrieve patient: "PT_ETE01" from API
    Then returned patient has value: "ON_TREATMENT_ARM" in field: "current_status"
    Then returned patient has value: "3.1" in field: "current_step_number"
    Then patient has new assignment request with re-biopsy: "true"
    Then tissue specimen received with surgical_event_id: "PT_ETE01_SEI3"
    Then tissue specimen shipped with molecular_id: "PT_ETE01_MOI3"
    Then slide specimen shipped with barcode: "PT_ETE01_BC3"
    Then ICCPTENs assay result received result: "POSITIVE"
    Then ICCMLH1s assay result received result: "INDETERMINATE"
    Then pathology confirmed with status: "Y"
    Then tissue variant report uploaded with analysis_id: "PT_ETE01_ANI5"
    Then tissue variant report confirmed with status: "CONFIRMED"
    Then wait for "60" seconds
    When retrieve patient: "PT_ETE01" from API
    Then returned patient has value: "ON_TREATMENT_ARM" in field: "current_status"
    Then returned patient has value: "4.1" in field: "current_step_number"

  Scenario: PT_ETE02. patient with rejected blood variant report trigger assignment process
    Given patient: "PT_ETE02" with status: "BLOOD_VARIANT_REPORT_CONFIRMED" on step: "1.0"
    Given this patients's active molecular_id is "PT_ETE02_MOI1"
    Given this patients's active analysis_id is "PT_ETE02_ANI1"
    Given other prepared steps for this patient: "assay and pathology are ready"
    Then tissue variant report confirmed with status: "CONFIRMED"
    Then wait for "60" seconds
    When retrieve patient: "PT_ETE01" from API
    Then returned patient has value: "ON_TREATMENT_ARM" in field: "current_status"
    Then returned patient has value: "1.1" in field: "current_step_number"


  Scenario: PT_ETE03. patient can reach PENDING_CONFIRMATION status even there is mock service collapse during assignment processing
    Given patient: "PT_ETE03" with status: "BLOOD_VARIANT_REPORT_CONFIRMED" on step: "1.0"
    Given this patients's active molecular_id is "PT_ETE03_MOI1"
    Given this patients's active analysis_id is "PT_ETE03_ANI1"
    Given other prepared steps for this patient: "assay and pathology are ready"
    Then put this patient in mock service lost patient list, service will come back after "5" tries
    Then tissue variant report confirmed with status: "CONFIRMED"
    Then wait for "60" seconds
    Then retrieve patient: "PT_ETE03" from API
    Then returned patient has value: "PENDING_CONFIRMATION" in field: "current_status"

  Scenario Outline: PT_ETE04. patient can be set to OFF_STUDY status from any status
    Given patient: "<patient_id>" with status: "<current_status>" on step: "<current_step_number>"
    Then set patient off_study
    Then wait for "15" seconds
    Then retrieve patient: "<patient_id>" from API
    Then returned patient has value: "OFF_STUDY" in field: "current_status"
  Examples:
  |patient_id              |current_status                   |current_step_number|
  |PT_ETE04_Registered     |REGISTRATION                     |1.0                |
  |PT_ETE04_TsReceived     |TISSUE_SPECIMEN_RECEIVED         |1.0                |
  |PT_ETE04_BdReceived     |BLOOD_SPECIMEN_RECEIVED          |2.0                |
  |PT_ETE04_TsShipped      |TISSUE_NUCLEIC_ACID_SHIPPED      |2.0                |
  |PT_ETE04_BdShipped      |BLOOD_NUCLEIC_ACID_SHIPPED       |3.0                |
  |PT_ETE04_slideShipped   |TISSUE_SLIDE_SPECIMEN_SHIPPED    |4.0                |
  |PT_ETE04_AssayReceived  |ASSAY_RESULTS_RECEIVED           |1.0                |
  |PT_ETE04_PathoConfirmed |PATHOLOGY_REVIEWED               |2.0                |
  |PT_ETE04_TsVrReceived   |TISSUE_VARIANT_REPORT_RECEIVED   |2.0                |
  |PT_ETE04_BdVrReceived   |BLOOD_VARIANT_REPORT_RECEIVED    |1.0                |
  |PT_ETE04_TsVrConfirmed  |TISSUE_VARIANT_REPORT_CONFIRMED  |1.0                |
  |PT_ETE04_BdVrConfirmed  |BLOOD_VARIANT_REPORT_CONFIRMED   |1.0                |
  |PT_ETE04_TsVrRejected   |TISSUE_VARIANT_REPORT_REJECTED   |2.0                |
  |PT_ETE04_BdVrRejected   |BLOOD_VARIANT_REPORT_REJECTED    |1.0                |
  |PT_ETE04_PendingApproval|PENDING_APPROVAL                 |2.0                |
  |PT_ETE04_OnTreatmentArm |ON_TREATMENT_ARM                 |3.1                |


  #data not ready
#Scenario: PT_SR13. new tissue with a surgical_event_id that was used in previous step should fail
## Test patient: PT_SR13_Step2Started: surgical event id: PT_SR13_Step2Started_SEI1 has been used in step 1
#  Given template specimen received message in type: "TISSUE" for patient: "PT_SR13_Step2Started", it has surgical_event_id: "PT_SR13_Step2Started_SEI1"
#  Then set patient message field: "collected_dttm" to value: "current"
#  When post to MATCH patients service, returns a message that includes "same surgical event id" with status "Failure"