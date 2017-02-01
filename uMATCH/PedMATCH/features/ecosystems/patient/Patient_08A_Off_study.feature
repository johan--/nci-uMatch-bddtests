#encoding: utf-8
Feature: Patients off study tests

  Background:
    Given patient API user authorization role is "PATIENT_MESSAGE_SENDER"

  @patients_p1
  Scenario Outline: PT_OS01. patient can be set to OFF_STUDY status from certain status
    Given patient id is "<patient_id>"
    And load template off study message for this patient
    Then set patient message field: "step_number" to value: "<current_step_number>"
    When POST to MATCH patients service, response includes "<message>" with code "<http_code>"
    Then patient status should change to "<patient_status>"
    And patient field: "current_step_number" should have value: "<current_step_number>"
    Examples:
      | patient_id                    | current_step_number | message      | http_code | patient_status           |
      | PT_OS01_Registered            | 1.0                 | successfully | 202       | OFF_STUDY                |
      | PT_OS01_TsReceived            | 1.0                 | successfully | 202       | OFF_STUDY                |
      | PT_OS01_TsShipped             | 2.0                 | successfully | 202       | OFF_STUDY                |
      | PT_OS01_slideShipped          | 2.0                 | successfully | 202       | OFF_STUDY                |
      | PT_OS01_AssayReceived         | 1.0                 | successfully | 202       | OFF_STUDY                |
      | PT_OS01_TsVrReceived          | 2.0                 | successfully | 202       | OFF_STUDY                |
      | PT_OS01_TsVrConfirmed         | 1.0                 | successfully | 202       | OFF_STUDY                |
      | PT_OS01_TsVrRejected          | 1.0                 | successfully | 202       | OFF_STUDY                |
      | PT_OS01_PendingConfirmation   | 2.0                 | successfully | 202       | OFF_STUDY                |
      | PT_OS01_PendingApproval       | 2.0                 | successfully | 202       | OFF_STUDY                |
      | PT_OS01_OnTreatmentArm        | 1.1                 | successfully | 202       | OFF_STUDY                |
      | PT_OS01_ReqAssignment         | 2.0                 | successfully | 202       | OFF_STUDY                |
      | PT_OS01_ReqNoAssignment       | 1.1                 | successfully | 202       | OFF_STUDY                |
      | PT_OS01_NoTaAvailable         | 1.0                 | successfully | 202       | OFF_STUDY                |
      | PT_OS01_CompassionateCare     | 1.0                 | successfully | 202       | OFF_STUDY                |
      | PT_OS01_OffStudy              | 1.0                 | off          | 403       | OFF_STUDY                |
      | PT_OS01_OffStudyBiopsyExpired | 1.0                 | expired      | 403       | OFF_STUDY_BIOPSY_EXPIRED |
    #no blood status is used anymore
#  |PT_OS01_BdReceived     |BLOOD_SPECIMEN_RECEIVED          |2.0                |
#  |PT_OS01_BdShipped      |BLOOD_NUCLEIC_ACID_SHIPPED       |2.0                |
#  |PT_OS01_BdVrReceived   |BLOOD_VARIANT_REPORT_RECEIVED    |1.0                |
#  |PT_OS01_BdVrConfirmed  |BLOOD_VARIANT_REPORT_CONFIRMED   |1.0                |
#  |PT_OS01_BdVrRejected   |BLOOD_VARIANT_REPORT_REJECTED    |1.0                |
    #there is no “PATHOLOGY_REVIEWED” status anymore
#      | PT_OS01_PathoConfirmed  | PATHOLOGY_REVIEWED              | 2.0                 |


  @patients_p2
  Scenario Outline: PT_OS01a. patient can be set to OFF_STUDY_BIOPSY_EXPIRED status from certain status
    Given patient id is "<patient_id>"
    And load template off study biopsy expired message for this patient
    Then set patient message field: "step_number" to value: "<current_step_number>"
    When POST to MATCH patients service, response includes "<message>" with code "<http_code>"
    Then patient status should change to "<patient_status>"
    And patient field: "current_step_number" should have value: "<current_step_number>"
    Examples:
      | patient_id                     | current_step_number | message      | http_code | patient_status           |
      | PT_OS01a_Registered            | 1.0                 | specimen     | 403       | REGISTRATION             |
      | PT_OS01a_TsReceived            | 1.0                 | successfully | 202       | OFF_STUDY_BIOPSY_EXPIRED |
      | PT_OS01a_TsShipped             | 2.0                 | successfully | 202       | OFF_STUDY_BIOPSY_EXPIRED |
      | PT_OS01a_slideShipped          | 2.0                 | successfully | 202       | OFF_STUDY_BIOPSY_EXPIRED |
      | PT_OS01a_AssayReceived         | 1.0                 | successfully | 202       | OFF_STUDY_BIOPSY_EXPIRED |
      | PT_OS01a_TsVrReceived          | 2.0                 | successfully | 202       | OFF_STUDY_BIOPSY_EXPIRED |
      | PT_OS01a_TsVrConfirmed         | 1.0                 | successfully | 202       | OFF_STUDY_BIOPSY_EXPIRED |
      | PT_OS01a_TsVrRejected          | 1.0                 | successfully | 202       | OFF_STUDY_BIOPSY_EXPIRED |
      | PT_OS01a_PendingConfirmation   | 2.0                 | successfully | 202       | OFF_STUDY_BIOPSY_EXPIRED |
      | PT_OS01a_PendingApproval       | 2.0                 | successfully | 202       | OFF_STUDY_BIOPSY_EXPIRED |
      | PT_OS01a_OnTreatmentArm        | 1.1                 | successfully | 403       | ON_TREATMENT_ARM         |
      | PT_OS01a_ReqAssignment         | 2.0                 | successfully | 202       | OFF_STUDY_BIOPSY_EXPIRED |
      | PT_OS01a_ReqNoAssignment       | 1.1                 | successfully | 202       | OFF_STUDY_BIOPSY_EXPIRED |
      | PT_OS01a_NoTaAvailable         | 1.0                 | successfully | 202       | OFF_STUDY_BIOPSY_EXPIRED |
      | PT_OS01a_CompassionateCare     | 1.0                 | successfully | 202       | OFF_STUDY_BIOPSY_EXPIRED |
      | PT_OS01a_OffStudy              | 1.0                 | off          | 403       | OFF_STUDY                |
      | PT_OS01a_OffStudyBiopsyExpired | 1.0                 | expired      | 403       | OFF_STUDY_BIOPSY_EXPIRED |

  @patients_p2
  Scenario Outline: PT_OS02. variant report confirmation should fail if patient is on OFF_STUDY status
#    patient: "PT_OS02_OffStudy1" assay ready, tissue vr waiting for confirm before OFF_STUDY
#    patient: "PT_OS02_OffStudy2" assay ready, tissue vr waiting for confirm before OFF_STUDY_BIOPSY_EXPIRED
    Given patient id is "<patient_id>"
    And patient API user authorization role is "MDA_VARIANT_REPORT_REVIEWER"
    And load template variant report confirm message for analysis id: "<ani>"
    When PUT to MATCH variant report "confirm" service, response includes "OFF_STUDY" with code "403"
    Examples:
      | patient_id        | ani                    |
      | PT_OS02_OffStudy1 | PT_OS02_OffStudy1_ANI1 |
      | PT_OS02_OffStudy2 | PT_OS02_OffStudy2_ANI1 |

  @patients_p2
  Scenario Outline: PT_OS02a. variant report upload should fail if patient is on OFF_STUDY status
#    patient: "PT_OS02a_OffStudy1" tissue shipped before OFF_STUDY
#    patient: "PT_OS02a_OffStudy2" tissue shipped before OFF_STUDY_BIOPSY_EXPIRED
    Given patient id is "<patient_id>"
    And patient API user authorization role is "MDA_VARIANT_REPORT_REVIEWER"
    Then load template variant file uploaded message for molecular id: "<patient_id>_MOI1"
    Then set patient message field: "analysis_id" to value: "<patient_id>_ANI1"
    Then files for molecular_id "<patient_id>_MOI1" and analysis_id "<patient_id>_ANI1" are in S3
    When POST to MATCH variant report upload service, response includes "OFF_STUDY" with code "403"
    Examples:
      | patient_id         |
      | PT_OS02a_OffStudy1 |
      | PT_OS02a_OffStudy2 |

  @patients_p2
  Scenario Outline: PT_OS03. assignment report confirmation should fail if patient is on OFF_STUDY status
#    patient: "PT_OS03_OffStudy1" assay ready, Assignment report waiting for confirmation before OFF_STUDY
#    patient: "PT_OS03_OffStudy2" assay ready, Assignment report waiting for confirm before OFF_STUDY_BIOPSY_EXPIRED
    Given patient id is "<patient_id>"
    And patient API user authorization role is "ASSIGNMENT_REPORT_REVIEWER"
    And load template assignment report confirm message for analysis id: "<ani>"
    When PUT to MATCH assignment report "confirm" service, response includes "OFF_STUDY" with code "403"
    Examples:
      | patient_id        | ani                    |
      | PT_OS03_OffStudy1 | PT_OS03_OffStudy1_ANI1 |
      | PT_OS03_OffStudy2 | PT_OS03_OffStudy2_ANI1 |

  @patients_p3
  Scenario Outline: PT_OS04. request assignment should fail if patient is on OFF_STUDY status
#    Given patient: "<patient_id>" with status: "<current_status>" on step: "1.1"
#    Given patient is currently on treatment arm: "APEC1621-A", stratum: "100"
    Given patient id is "<patient_id>"
    And load template request assignment message for this patient
    Then set patient message field: "rebiopsy" to value: "<rebiopsy>"
    And set patient message field: "step_number" to value: "2.0"
    When POST to MATCH patients service, response includes "off" with code "403"
    Examples:
      | patient_id    | current_status           | rebiopsy |
      | PT_OS04_OnTA1 | OFF_STUDY                | Y        |
      | PT_OS04_OnTA1 | OFF_STUDY                | N        |
      | PT_OS04_OnTA2 | OFF_STUDY_BIOPSY_EXPIRED | Y        |
      | PT_OS04_OnTA2 | OFF_STUDY_BIOPSY_EXPIRED | N        |

#  Scenario Outline: PT_OS05 OFF_STUDY should fail if patient is on OFF_STUDY status
#    Given patient: "<patient_id>" with status: "<current_status>" on step: "1.1"
#    Given patient is currently on treatment arm: "APEC1621-A", stratum: "100"
#    Then requests assignment for this patient with re-biopsy: "<rebiopsy>", step number: "2.0"
#    Then API returns a message that includes "off" with status "Failure"
#    Examples:
#      |patient_id     |current_status               |rebiopsy |
#      |PT_OS05_OnTA1 |OFF_STUDY                    |Y        |
#      |PT_OS05_OnTA2 |OFF_STUDY_BIOPSY_EXPIRED     |N        |