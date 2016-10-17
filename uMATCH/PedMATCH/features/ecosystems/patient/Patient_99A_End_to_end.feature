#encoding: utf-8
#@patients
@patients_end_to_end
Feature: Patients end to end tests

  @patients
  Scenario: PT_ETE01. patient can reach step 4.1 successfully
#      Given patient: "PT_ETE01" with status: "BLOOD_VARIANT_REPORT_RECEIVED" on step: "3.0"
#    Given this patients's active "TISSUE" molecular_id is "PT_ETE01_MOI2"
#    Given this patients's active "BLOOD" molecular_id is "PT_ETE01_BD_MOI2"
#    Given this patients's active "TISSUE" analysis_id is "PT_ETE01_ANI3"
#    Given this patients's active "BLOOD" analysis_id is "PT_ETE01_ANI4"
    Given reset COG patient data: "PT_ETE01"
    Given patient: "PT_ETE01" is registered
    Then tissue specimen received with surgical_event_id: "PT_ETE01_SEI1"
    Then blood specimen received
    Then "TISSUE" specimen shipped to "MDA" with molecular_id or slide_barcode: "PT_ETE01_MOI1"
    Then "SLIDE" specimen shipped to "MDA" with molecular_id or slide_barcode: "PT_ETE01_BC1"
    Then "BLOOD" specimen shipped to "MDA" with molecular_id or slide_barcode: "PT_ETE01_BD_MOI1"
    Then "ICCPTENs" assay result received result: "NEGATIVE"
    Then "ICCMLH1s" assay result received result: "NEGATIVE"
    Then pathology confirmed with status: "Y"
    Then "TISSUE" variant report uploaded with analysis_id: "PT_ETE01_ANI1"
    Then "BLOOD" variant report uploaded with analysis_id: "PT_ETE01_ANI2"
    Then "TISSUE" variant report confirmed with status: "CONFIRMED"
#    Then "BLOOD" variant report confirmed with status: "REJECTED"
    Then patient status should be "PENDING_CONFIRMATION" within 30 seconds
    Then patient should have selected treatment arm: "APEC1621-ETE-C" with stratum id: "100" within 15 seconds
    Then assignment report is confirmed
    Then COG approves patient on treatment arm: "APEC1621-ETE-C", stratum: "100" to step: "1.1"
    Then patient status should be "ON_TREATMENT_ARM" within 15 seconds
    Then patient step number should be "1.1" within 15 seconds
    Then COG requests assignment for this patient with re-biopsy: "N", step number: "2.0"
    Then patient status should be "PENDING_CONFIRMATION" within 30 seconds
    Then patient step number should be "2.0" within 15 seconds
    Then patient should have selected treatment arm: "APEC1621-ETE-A" with stratum id: "100" within 15 seconds
    Then assignment report is confirmed
    Then COG approves patient on treatment arm: "APEC1621-ETE-A", stratum: "100" to step: "2.1"
    Then patient status should be "ON_TREATMENT_ARM" within 15 seconds
    Then patient step number should be "2.1" within 15 seconds
    Then COG requests assignment for this patient with re-biopsy: "Y", step number: "3.0"
    Then patient status should be "REQUEST_ASSIGNMENT" within 15 seconds
    Then patient step number should be "3.0" within 15 seconds
    Then tissue specimen received with surgical_event_id: "PT_ETE01_SEI2"
    Then blood specimen received
    Then "TISSUE" specimen shipped to "MoCha" with molecular_id or slide_barcode: "PT_ETE01_MOI2"
    Then "SLIDE" specimen shipped to "MDA" with molecular_id or slide_barcode: "PT_ETE01_BC2"
    Then "BLOOD" specimen shipped to "MoCha" with molecular_id or slide_barcode: "PT_ETE01_BD_MOI2"
    Then "ICCPTENs" assay result received result: "POSITIVE"
    Then "ICCMLH1s" assay result received result: "INDETERMINATE"
    Then pathology confirmed with status: "Y"
    Then "TISSUE" variant report uploaded with analysis_id: "PT_ETE01_ANI3"
    Then "BLOOD" variant report uploaded with analysis_id: "PT_ETE01_ANI4"
    Then "TISSUE" variant(type: "fusion", field: "identifier", value: "FGFR2-OFD1.F17O3") is "unchecked"
    Then "TISSUE" variant(type: "fusion", field: "identifier", value: "CCDC6-RET.C1R12.COSF1271") is "unchecked"
    Then "TISSUE" variant report confirmed with status: "CONFIRMED"
    Then wait for "2" seconds
#    Then "BLOOD" variant report confirmed with status: "CONFIRMED"
    Then patient status should be "PENDING_CONFIRMATION" within 30 seconds
    Then patient should have selected treatment arm: "APEC1621-ETE-B" with stratum id: "100" within 15 seconds
    Then assignment report is confirmed
    Then COG approves patient on treatment arm: "APEC1621-ETE-B", stratum: "100" to step: "3.1"
    Then patient status should be "ON_TREATMENT_ARM" within 15 seconds
    Then patient step number should be "3.1" within 15 seconds
    Then COG requests assignment for this patient with re-biopsy: "N", step number: "4.0"
    Then patient status should be "PENDING_CONFIRMATION" within 30 seconds
    Then patient step number should be "4.0" within 15 seconds
    Then patient should have selected treatment arm: "APEC1621-ETE-D" with stratum id: "100" within 15 seconds
    Then assignment report is confirmed
    Then COG approves patient on treatment arm: "APEC1621-ETE-D", stratum: "100" to step: "4.1"
    Then patient status should be "ON_TREATMENT_ARM" within 15 seconds
    Then patient step number should be "4.1" within 15 seconds


  Scenario Outline: PT_ETE02. in proper situation, patient ecosystem can send correct status (other than PENDING_APPROVAL) to COG
    Given patient: "<patient_id>" with status: "TISSUE_VARIANT_REPORT_RECEIVED" on step: "1.0"
    Given this patients's active "TISSUE" molecular_id is "<moi>"
    Given this patients's active "TISSUE" analysis_id is "<ani>"
    Given other background and comments for this patient: "All data is ready, there will <description>"
    Then "TISSUE" variant report confirmed with status: "CONFIRMED"
    Then wait for "60" seconds
    Then COG received assignment status: "<assignment_status>" for this patient
    Examples:
      | patient_id             | moi                         | ani                         | description                | assignment_status  |
      | PT_ETE02_TsVrReceived1 | PT_ETE02_TsVrReceived1_MOI1 | PT_ETE02_TsVrReceived1_ANI1 | not have TA available      | NO_TA_AVAILABLE    |
      | PT_ETE02_TsVrReceived2 | PT_ETE02_TsVrReceived2_MOI1 | PT_ETE02_TsVrReceived2_ANI1 | have a closed TA available | COMPASSIONATE_CARE |

  Scenario: PT_ETE03. patient can reach PENDING_CONFIRMATION status even cog service collapses during assignment processing
    Given patient: "PT_ETE03" with status: "TISSUE_VARIANT_REPORT_RECEIVED" on step: "1.0"
    Given patient: "PT_ETE03" in mock service lost patient list, service will come back after "5" tries
    Given this patients's active "TISSUE" molecular_id is "PT_ETE03_MOI1"
    Given this patients's active "TISSUE" analysis_id is "PT_ETE03_ANI1"
    Given other background and comments for this patient: "assay and pathology are ready"
    Then "TISSUE" variant report confirmed with status: "CONFIRMED"
    Then patient status should be "PENDING_CONFIRMATION" within 60 seconds

  @patients_p1
  Scenario Outline: PT_ETE04. patient can be set to OFF_STUDY status from any status
    Given patient: "<patient_id>" with status: "<current_status>" on step: "<current_step_number>"
    Then set patient off_study on step number: "<current_step_number>"
    Then patient status should be "OFF_STUDY" within 15 seconds
    Then patient step number should be "<current_step_number>" within 15 seconds
    Examples:
      | patient_id               | current_status                  | current_step_number |
      | PT_ETE04_Registered      | REGISTRATION                    | 1.0                 |
      | PT_ETE04_TsReceived      | TISSUE_SPECIMEN_RECEIVED        | 1.0                 |
      | PT_ETE04_TsShipped       | TISSUE_NUCLEIC_ACID_SHIPPED     | 2.0                 |
      | PT_ETE04_slideShipped    | TISSUE_SLIDE_SPECIMEN_SHIPPED   | 2.0                 |
      | PT_ETE04_AssayReceived   | ASSAY_RESULTS_RECEIVED          | 1.0                 |
      | PT_ETE04_PathoConfirmed  | PATHOLOGY_REVIEWED              | 2.0                 |
      | PT_ETE04_TsVrReceived    | TISSUE_VARIANT_REPORT_RECEIVED  | 2.0                 |
      | PT_ETE04_TsVrConfirmed   | TISSUE_VARIANT_REPORT_CONFIRMED | 1.0                 |
      | PT_ETE04_TsVrRejected    | TISSUE_VARIANT_REPORT_REJECTED  | 1.0                 |
      | PT_ETE04_PendingApproval | PENDING_APPROVAL                | 2.0                 |
      | PT_ETE04_OnTreatmentArm  | ON_TREATMENT_ARM                | 1.1                 |
      | PT_ETE04_ReqAssignment   | REQUEST_ASSIGNMENT              | 2.0                 |
    #no blood status is used anymore
#  |PT_ETE04_BdReceived     |BLOOD_SPECIMEN_RECEIVED          |2.0                |
#  |PT_ETE04_BdShipped      |BLOOD_NUCLEIC_ACID_SHIPPED       |2.0                |
#  |PT_ETE04_BdVrReceived   |BLOOD_VARIANT_REPORT_RECEIVED    |1.0                |
#  |PT_ETE04_BdVrConfirmed  |BLOOD_VARIANT_REPORT_CONFIRMED   |1.0                |
#  |PT_ETE04_BdVrRejected   |BLOOD_VARIANT_REPORT_REJECTED    |1.0                |

  Scenario: PT_ETE05. new tissue specimen with a surgical_event_id that was used in previous step should fail
    Given patient: "PT_ETE05" with status: "REQUEST_ASSIGNMENT" on step: "2.0"
    Given other background and comments for this patient: "surgical_event_id PT_ETE05_SEI1 has been used in step 1.0"
    Then tissue specimen received with surgical_event_id: "PT_ETE05_SEI1"
    Then API returns a message that includes "same surgical event id" with status "Failure"

  Scenario Outline: PT_ETE06. shipment with molecular_id (or barcode) that was used in previous step should fail
    Given patient: "<patient_id>" with status: "<current_status>" on step: "2.0"
    Given other background and comments for this patient: "<moi_or_barcode> has been used in step 1.0"
    Given this patients's active surgical_event_id is "<patient_id>_SEI5"
    Then "<type>" specimen shipped to "MoCha" with molecular_id or slide_barcode: "<moi_or_barcode>"
    Then API returns a message that includes "<message>" with status "Failure"
    Examples:
      | patient_id                | moi_or_barcode                   | type   | message                          | current_status           |
      | PT_ETE06_Step2TsReceived1 | PT_ETE06_Step2TsReceived1_MOI1   | TISSUE | same molecular id has been found | TISSUE_SPECIMEN_RECEIVED |
      | PT_ETE06_Step2TsReceived2 | PT_ETE06_Step2TsReceived2_BC1    | SLIDE  | same barcode has been found      | TISSUE_SPECIMEN_RECEIVED |
      | PT_ETE06_Step2BdReceived  | PT_ETE06_Step2BdReceived_BD_MOI1 | BLOOD  | same molecular id has been found | BLOOD_SPECIMEN_RECEIVED  |

  Scenario: PT_ETE07. rejected blood variant report should not prevent api triggering assignment process
    Given patient: "PT_ETE07" with status: "TISSUE_VARIANT_REPORT_RECEIVED" on step: "1.0"
    Given this patients's active "TISSUE" molecular_id is "PT_ETE07_MOI1"
    Given this patients's active "TISSUE" analysis_id is "PT_ETE07_ANI1"
    Given other background and comments for this patient: "assay and pathology are ready, blood variant report is rejected"
    Then "TISSUE" variant report confirmed with status: "CONFIRMED"
    Then COG approves patient on treatment arm: "APEC1621-A", stratum: "100" to step: "1.1"
    Then patient status should be "ON_TREATMENT_ARM" within 15 seconds
    Then patient step number should be "1.1" within 15 seconds

  Scenario Outline: PT_ETE08. variant report confirmation should fail if patient is on OFF_STUDY status
    Given patient: "<patient_id>" with status: "<current_status>" on step: "1.0"
    Given other background and comments for this patient: "All data is ready, tissue variant report was waiting for confirmation before patient changed to OFF_STUDY"
    Then "TISSUE" variant report confirmed with status: "CONFIRMED"
    Then API returns a message that includes "OFF_STUDY" with status "Failure"
    Examples:
      | patient_id         | current_status           |
      | PT_ETE08_OffStudy1 | OFF_STUDY                |
      | PT_ETE08_OffStudy2 | OFF_STUDY_BIOPSY_EXPIRED |

  Scenario Outline: PT_ETE09. assignment report confirmation should fail if patient is on OFF_STUDY status
    Given patient: "<patient_id>" with status: "<current_status>" on step: "1.0"
    Given other background and comments for this patient: "Assignment report was waiting for confirmation before patient changed to OFF_STUDY"
    Then assignment report is confirmed
    Then API returns a message that includes "OFF_STUDY" with status "Failure"
    Examples:
      | patient_id         | current_status           |
      | PT_ETE09_OffStudy1 | OFF_STUDY                |
      | PT_ETE09_OffStudy2 | OFF_STUDY_BIOPSY_EXPIRED |

  Scenario Outline: PT_ETE09a. request assignment should fail if patient is on OFF_STUDY status
    Given patient: "<patient_id>" with status: "<current_status>" on step: "1.1"
    Given patient is currently on treatment arm: "APEC1621-A", stratum: "100"
    Then COG requests assignment for this patient with re-biopsy: "<rebiopsy>", step number: "2.0"
    Then API returns a message that includes "off" with status "Failure"
    Examples:
      | patient_id      | current_status           | rebiopsy |
      | PT_ETE09a_OnTA1 | OFF_STUDY                | Y        |
      | PT_ETE09a_OnTA2 | OFF_STUDY_BIOPSY_EXPIRED | N        |
#  Scenario Outline: PT_ETE09b OFF_STUDY should fail if patient is on OFF_STUDY status
#    Given patient: "<patient_id>" with status: "<current_status>" on step: "1.1"
#    Given patient is currently on treatment arm: "APEC1621-A", stratum: "100"
#    Then COG requests assignment for this patient with re-biopsy: "<rebiopsy>", step number: "2.0"
#    Then API returns a message that includes "off" with status "Failure"
#    Examples:
#      |patient_id     |current_status               |rebiopsy |
#      |PT_ETE13_OnTA1 |OFF_STUDY                    |Y        |
#      |PT_ETE13_OnTA2 |OFF_STUDY_BIOPSY_EXPIRED     |N        |

  Scenario: PT_ETE10. request assignment message with rebiopsy = N will fail if the current biopsy is expired
    Given patient: "PT_ETE10" with status: "ON_TREATMENT_ARM" on step: "1.1"
    Given other background and comments for this patient: "the specimen received date is over 6 months ago"
    Given patient is currently on treatment arm: "APEC1621-A", stratum: "100"
    Then COG requests assignment for this patient with re-biopsy: "N", step number: "2.0"
    Then API returns a message that includes "expired" with status "Failure"

  Scenario Outline: PT_ETE11. assignment process should not be triggered if assignment request has rebiopsy = Y
    Given patient: "<patient_id>" with status: "<patient_status>" on step: "<step_number>"
    Given patient is currently on treatment arm: "APEC1621-A", stratum: "100"
    Then COG requests assignment for this patient with re-biopsy: "Y", step number: "2.0"
    Then patient status should be "REQUEST_ASSIGNMENT" after 30 seconds
    Examples:
      | patient_id              | patient_status   | step_number |
      | PT_ETE11_OnTreatmentArm | ON_TREATMENT_ARM | 1.1         |
      | PT_ETE11_PendingAproval | PENDING_APPROVAL | 1.0         |

#    not required anymore
#  Scenario Outline: PT_ETE13. assignment request will fail if patient is on step 4.1
#    Given patient: "<patient_id>" with status: "ON_TREATMENT_ARM" on step: "4.1"
#    Given patient is currently on treatment arm: "APEC1621-A", stratum: "100"
#    Then COG requests assignment for this patient with re-biopsy: "<rebiopsy>", step number: "5.0"
#    Then API returns a message that includes "4" with status "Failure"
#    Examples:
#    |patient_id     |rebiopsy |
#    |PT_ETE13_OnTA1 |Y        |
#    |PT_ETE13_OnTA2 |N        |

  Scenario: PT_ETE14. on treatment arm message with wrong treatment arm information should fail
    Given patient: "PT_ETE14" with status: "PENDING_APPROVAL" on step: "1.0"
    Given patient is currently on treatment arm: "APEC1621-A", stratum: "100"
    Then COG approves patient on treatment arm: "APEC1621-B", stratum: "100" to step: "1.1"
    Then API returns a message that includes "treatment arm" with status "Failure"


  Scenario Outline: PT_ETE15. treatment arm should be able to assign to multiple patients
    Given patient: "<patient_id>" with status: "TISSUE_VARIANT_REPORT_RECEIVED" on step: "1.0"
    Given this patients's active "TISSUE" molecular_id is "<moi>"
    Given this patients's active "TISSUE" analysis_id is "<ani>"
    Given other background and comments for this patient: "assay and pathology are ready"
    Then "TISSUE" variant report confirmed with status: "CONFIRMED"
    Then wait for "10" seconds
    Then assignment report is confirmed
    Then COG approves patient on treatment arm: "APEC1621-A", stratum: "100" to step: "1.1"
    Then patient status should be "ON_TREATMENT_ARM" within 15 seconds
    Then patient step number should be "1.1" within 15 seconds
    Examples:
      | patient_id           | moi                       | ani                       |
      | PT_ETE15_TsReceived1 | PT_ETE15_TsReceived1_MOI1 | PT_ETE15_TsReceived1_ANI1 |
      | PT_ETE15_TsReceived2 | PT_ETE15_TsReceived2_MOI1 | PT_ETE15_TsReceived2_ANI1 |


#  request no assignment status should not accept any message
#  Scenario: PT_ETE12. Assay