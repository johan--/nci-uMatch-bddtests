#encoding: utf-8
Feature: Patients off study tests

  @patients_p1
  Scenario Outline: PT_OS01. patient can be set to OFF_STUDY status from any status
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
      | PT_ETE04_TsVrReceived    | TISSUE_VARIANT_REPORT_RECEIVED  | 2.0                 |
      | PT_ETE04_TsVrConfirmed   | TISSUE_VARIANT_REPORT_CONFIRMED | 1.0                 |
      | PT_ETE04_TsVrRejected    | TISSUE_VARIANT_REPORT_REJECTED  | 1.0                 |
      | PT_ETE04_PendingApproval | PENDING_APPROVAL                | 2.0                 |
      | PT_ETE04_OnTreatmentArm  | ON_TREATMENT_ARM                | 1.1                 |
      | PT_ETE04_ReqAssignment   | REQUEST_ASSIGNMENT              | 2.0                 |
      | PT_ETE04_ReqNoAssignment | REQUEST_NO_ASSIGNMENT           | 1.1                 |
    #no blood status is used anymore
#  |PT_ETE04_BdReceived     |BLOOD_SPECIMEN_RECEIVED          |2.0                |
#  |PT_ETE04_BdShipped      |BLOOD_NUCLEIC_ACID_SHIPPED       |2.0                |
#  |PT_ETE04_BdVrReceived   |BLOOD_VARIANT_REPORT_RECEIVED    |1.0                |
#  |PT_ETE04_BdVrConfirmed  |BLOOD_VARIANT_REPORT_CONFIRMED   |1.0                |
#  |PT_ETE04_BdVrRejected   |BLOOD_VARIANT_REPORT_REJECTED    |1.0                |
    #there is no “PATHOLOGY_REVIEWED” status anymore
#      | PT_ETE04_PathoConfirmed  | PATHOLOGY_REVIEWED              | 2.0                 |

  @patients_p2
  Scenario Outline: PT_OS02. variant report confirmation should fail if patient is on OFF_STUDY status
    Given patient: "<patient_id>" with status: "<current_status>" on step: "1.0"
    Given this patients's active "TISSUE" analysis_id is "<ani>"
    Given other background and comments for this patient: "All data is ready, tissue variant report was waiting for confirmation before patient changed to OFF_STUDY"
    Then "TISSUE" variant report confirmed with status: "CONFIRMED"
    Then API returns a message that includes "OFF_STUDY" with status "Failure"
    Examples:
      | patient_id         | current_status           | ani                     |
      | PT_ETE08_OffStudy1 | OFF_STUDY                | PT_ETE08_OffStudy1_ANI1 |
      | PT_ETE08_OffStudy2 | OFF_STUDY_BIOPSY_EXPIRED | PT_ETE08_OffStudy2_ANI1 |

  @patients_p2
  Scenario Outline: PT_OS03. assignment report confirmation should fail if patient is on OFF_STUDY status
    Given patient: "<patient_id>" with status: "<current_status>" on step: "1.0"
    Given this patients's active "TISSUE" analysis_id is "<ani>"
    Given other background and comments for this patient: "Assignment report was waiting for confirmation before patient changed to OFF_STUDY"
    Then assignment report is confirmed
    Then API returns a message that includes "OFF_STUDY" with status "Failure"
    Examples:
      | patient_id         | current_status           | ani                     |
      | PT_ETE09_OffStudy1 | OFF_STUDY                | PT_ETE09_OffStudy1_ANI1 |
      | PT_ETE09_OffStudy2 | OFF_STUDY_BIOPSY_EXPIRED | PT_ETE09_OffStudy2_ANI1 |

  @patients_p3
  Scenario Outline: PT_OS04. request assignment should fail if patient is on OFF_STUDY status
    Given patient: "<patient_id>" with status: "<current_status>" on step: "1.1"
    Given patient is currently on treatment arm: "APEC1621-A", stratum: "100"
    Then requests assignment for this patient with re-biopsy: "<rebiopsy>", step number: "2.0"
    Then API returns a message that includes "off" with status "Failure"
    Examples:
      | patient_id      | current_status           | rebiopsy |
      | PT_ETE09a_OnTA1 | OFF_STUDY                | Y        |
      | PT_ETE09a_OnTA2 | OFF_STUDY_BIOPSY_EXPIRED | N        |

#  Scenario Outline: PT_OS05 OFF_STUDY should fail if patient is on OFF_STUDY status
#    Given patient: "<patient_id>" with status: "<current_status>" on step: "1.1"
#    Given patient is currently on treatment arm: "APEC1621-A", stratum: "100"
#    Then requests assignment for this patient with re-biopsy: "<rebiopsy>", step number: "2.0"
#    Then API returns a message that includes "off" with status "Failure"
#    Examples:
#      |patient_id     |current_status               |rebiopsy |
#      |PT_ETE13_OnTA1 |OFF_STUDY                    |Y        |
#      |PT_ETE13_OnTA2 |OFF_STUDY_BIOPSY_EXPIRED     |N        |