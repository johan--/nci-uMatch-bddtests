#encoding: utf-8
#@patients
@patients_end_to_end
Feature: Patients end to end tests
  Scenario: PT_ETE01. patient can reach step 4.1 successfully
    Given patient: "PT_ETE01" with status: "REGISTRATION" on step: "1.0"
    Then tissue specimen received with surgical_event_id: "PT_ETE01_SEI1"
    Then blood specimen received
    Then "TISSUE" specimen shipped with molecular_id or slide_barcode: "PT_ETE01_MOI1"
    Then "SLIDE" specimen shipped with molecular_id or slide_barcode: "PT_ETE01_BC1"
    Then "BLOOD" specimen shipped with molecular_id or slide_barcode: "PT_ETE01_BD_MOI1"
    Then "ICCPTENs" assay result received result: "NEGATIVE"
    Then "ICCMLH1s" assay result received result: "NEGATIVE"
    Then pathology confirmed with status: "Y"
    Then "TISSUE" variant report uploaded with analysis_id: "PT_ETE01_ANI1"
    Then "BLOOD" variant report uploaded with analysis_id: "PT_ETE01_ANI2"
    Then "TISSUE" variant report confirmed with status: "CONFIRMED"
    Then "BLOOD" variant report confirmed with status: "REJECTED"
    Then wait for "30" seconds
    Then assignment report is "CONFIRMED"
    Then wait for "30" seconds
    When retrieve patient: "PT_ETE01" from API
    Then returned patient has value: "ON_TREATMENT_ARM" in field: "current_status"
    Then returned patient has value: "1.1" in field: "current_step_number"
    Then patient has new assignment request with re-biopsy: "true", step number: "2.0"
    Then tissue specimen received with surgical_event_id: "PT_ETE01_SEI2"
    Then blood specimen received
    Then "TISSUE" specimen shipped with molecular_id or slide_barcode: "PT_ETE01_MOI2"
    Then "SLIDE" specimen shipped with molecular_id or slide_barcode: "PT_ETE01_BC2"
    Then "BLOOD" specimen shipped with molecular_id or slide_barcode: "PT_ETE01_BD_MOI2"
    Then "ICCPTENs" assay result received result: "POSITIVE"
    Then "ICCMLH1s" assay result received result: "INDETERMINATE"
    Then pathology confirmed with status: "Y"
    Then "TISSUE" variant report uploaded with analysis_id: "PT_ETE01_ANI3"
    Then "BLOOD" variant report uploaded with analysis_id: "PT_ETE01_ANI4"
    Then "TISSUE" variant report confirmed with status: "CONFIRMED"
    Then "BLOOD" variant report confirmed with status: "CONFIRMED"
    Then wait for "30" seconds
    Then assignment report is "CONFIRMED"
    Then wait for "30" seconds
    When retrieve patient: "PT_ETE01" from API
    Then returned patient has value: "ON_TREATMENT_ARM" in field: "current_status"
    Then returned patient has value: "2.1" in field: "current_step_number"
    Then patient has new assignment request with re-biopsy: "false", step number: "3.0"
    Then wait for "30" seconds
    Then assignment report is "CONFIRMED"
    Then wait for "30" seconds
    When retrieve patient: "PT_ETE01" from API
    Then returned patient has value: "ON_TREATMENT_ARM" in field: "current_status"
    Then returned patient has value: "3.1" in field: "current_step_number"
    Then patient has new assignment request with re-biopsy: "true", step number: "4.0"
    Then tissue specimen received with surgical_event_id: "PT_ETE01_SEI3"
    Then "TISSUE" specimen shipped with molecular_id or slide_barcode: "PT_ETE01_MOI3"
    Then "SLIDE" specimen shipped with molecular_id or slide_barcode: "PT_ETE01_BC3"
    Then "ICCPTENs" assay result received result: "POSITIVE"
    Then "ICCMLH1s" assay result received result: "INDETERMINATE"
    Then pathology confirmed with status: "Y"
    Then "TISSUE" variant report uploaded with analysis_id: "PT_ETE01_ANI5"
    Then "TISSUE" variant report confirmed with status: "CONFIRMED"
    Then wait for "30" seconds
    Then assignment report is "CONFIRMED"
    Then wait for "30" seconds
    When retrieve patient: "PT_ETE01" from API
    Then returned patient has value: "ON_TREATMENT_ARM" in field: "current_status"
    Then returned patient has value: "4.1" in field: "current_step_number"

  Scenario: PT_ETE02. rejected blood variant report should not prevent api triggering assignment process
    Given patient: "PT_ETE02" with status: "BLOOD_VARIANT_REPORT_CONFIRMED" on step: "1.0"
    Given this patients's active "TISSUE" molecular_id is "PT_ETE02_MOI1"
    Given this patients's active analysis_id is "PT_ETE02_ANI1"
    Given other prepared steps for this patient: "assay and pathology are ready"
    Then "TISSUE" variant report confirmed with status: "CONFIRMED"
    Then wait for "60" seconds
    When retrieve patient: "PT_ETE01" from API
    Then returned patient has value: "ON_TREATMENT_ARM" in field: "current_status"
    Then returned patient has value: "1.1" in field: "current_step_number"


  Scenario: PT_ETE03. patient can reach PENDING_CONFIRMATION status even there is mock service collapse during assignment processing
    Given patient: "PT_ETE03" with status: "BLOOD_VARIANT_REPORT_CONFIRMED" on step: "1.0"
    Given patient: "PT_ETE03" in mock service lost patient list, service will come back after "5" tries
    Given this patients's active "TISSUE" molecular_id is "PT_ETE03_MOI1"
    Given this patients's active analysis_id is "PT_ETE03_ANI1"
    Given other prepared steps for this patient: "assay and pathology are ready"
    Then "TISSUE" variant report confirmed with status: "CONFIRMED"
    Then wait for "60" seconds
    Then retrieve patient: "PT_ETE03" from API
    Then returned patient has value: "PENDING_CONFIRMATION" in field: "current_status"

  Scenario Outline: PT_ETE04. patient can be set to OFF_STUDY status from any status
    Given patient: "<patient_id>" with status: "<current_status>" on step: "<current_step_number>"
    Then set patient off_study on step number: "<current_step_number>"
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
  |PT_ETE04_ReqAssignment  |REQUEST_ASSIGNMENT               |2.0                |

  Scenario: PT_ETE05. new tissue specimen with a surgical_event_id that was used in previous step should fail
    Given patient: "PT_ETE05" with status: "REQUEST_ASSIGNMENT" on step: "2.0"
    Given other prepared steps for this patient: "surgical_event_id PT_ETE05_SEI1 has been used in step 1.0"
    Then tissue specimen received with surgical_event_id: "PT_ETE05_SEI1"
    Then API returns a message that includes "same surgical event id" with status "Failure"

  Scenario Outline: PT_ETE06. shipment with molecular_id (or barcode) that was used in previous step should fail
    Given patient: "<patient_id>" with status: "<current_status>" on step: "2.0"
    Given other prepared steps for this patient: "<moi_or_barcode> has been used in step 1.0"
    Given this patients's active surgical_event_id is "<patient_id>_SEI5"
    Then "<type>" specimen shipped with molecular_id or slide_barcode: "<moi_or_barcode>"
    Then API returns a message that includes "<message>" with status "Failure"
    Examples:
      |patient_id                   |moi_or_barcode                     |type       |message                          |current_status            |
      |PT_ETE06_Step2TissueReceived1|PT_ETE06_Step2TissueReceived1_MOI1 |TISSUE     |same molecular id has been found |TISSUE_SPECIMEN_RECEIVED  |
      |PT_ETE06_Step2TissueReceived2|PT_ETE06_Step2TissueReceived2_BC1  |SLIDE      |same barcode has been found      |TISSUE_SPECIMEN_RECEIVED  |
      |PT_ETE06_Step2BloodReceived  |PT_ETE06_Step2BloodReceived_BD_MOI1|BLOOD      |same molecular id has been found |BLOOD_SPECIMEN_RECEIVED   |

  Scenario Outline: PT_ETE07. patient ecosystem can send correct status (other than PENDING_APPROVAL) to COG
    Given patient: "<patient_id>" with status: "TISSUE_VARIANT_REPORT_RECEIVED" on step: "1.0"
    Given this patients's active "TISSUE" molecular_id is "<moi>"
    Given this patients's active analysis_id is "<ani>"
    Given other prepared steps for this patient: "All data is ready, there will <description>"
    Then "TISSUE" variant report confirmed with status: "CONFIRMED"
    Then wait for "60" seconds
    Then COG received assignment status: "<assignment_status>" for this patient
    Examples:
    |patient_id             |moi                         |ani                         |description               |assignment_status |
    |PT_ETE07_TsVrReceived1 |PT_ETE07_TsVrReceived1_MOI1 |PT_ETE07_TsVrReceived1_ANI1 |not have TA available     |NO_TA_AVAILABLE   |
    |PT_ETE07_TsVrReceived2 |PT_ETE07_TsVrReceived2_MOI1 |PT_ETE07_TsVrReceived2_ANI1 |have a closed TA available|COMPASSIONATE_CARE|

  Scenario Outline: PT_ETE05. variant report confirmation should fail if patient is on OFF_STUDY status
    Given patient: "<patient_id>" with status: "<current_status>" on step: "1.0"
    Given other prepared steps for this patient: "All data is ready, tissue variant report was waiting for confirmation before patient changed to OFF_STUDY"
    Then "TISSUE" variant report confirmed with status: "CONFIRMED"
    Then API returns a message that includes "OFF_STUDY" with status "Failure"
    Examples:
      |patient_id                 |current_status           |
      |PT_ETE05_OffStudy1         |OFF_STUDY                |
      |PT_ETE05_OffStudy2         |OFF_STUDY_BIOPSY_EXPIRED |

  Scenario Outline: PT_ETE06. assignment report confirmation should fail if patient is on OFF_STUDY status
    Given patient: "<patient_id>" with status: "<current_status>" on step: "1.0"
    Given other prepared steps for this patient: "Assignment report was waiting for confirmation before patient changed to OFF_STUDY"
    Then assignment report is "CONFIRMED"
    Then API returns a message that includes "OFF_STUDY" with status "Failure"
    Examples:
      |patient_id                 |current_status           |
      |PT_ETE06_OffStudy1         |OFF_STUDY                |
      |PT_ETE06_OffStudy2         |OFF_STUDY_BIOPSY_EXPIRED |
    
  Scenario: PT_ETE07. request assignment message with rebiopsy = N will fail if the current biopsy is expired
    Given patient: "PT_ETE07" with status: "ON_TREATMENT_ARM" on step: "1.1"
    Given other prepared steps for this patient: "the specimen received date is over 6 months ago"
    Then patient has new assignment request with re-biopsy: "false", step number: "2.0"
    Then API returns a message that includes "expired" with status "Failure"