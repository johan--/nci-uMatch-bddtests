#encoding: utf-8
Feature: Patients assignment tests

  @patients_p1 @demo_p1 @patients_need_queue
  Scenario Outline: PT_AM01. in proper situation, patient ecosystem can send correct status (other than PENDING_APPROVAL) to COG
#    patient: PT_AM01_TsVrReceived1 will not have TA available
#    patient: PT_AM01_TsVrReceived1 will have a closed TA available
    Given patient id is "<patient_id>"
    And patient API user authorization role is "MDA_VARIANT_REPORT_REVIEWER"
    Then load template variant report confirm message for analysis id: "<ani>"
    When PUT to MATCH variant report "confirm" service, response includes "successfully" with code "200"
    Then patient status should change to "PENDING_CONFIRMATION"
    Then patient API user authorization role is "ASSIGNMENT_REPORT_REVIEWER"
    Then load template assignment report confirm message for analysis id: "<ani>"
    Then PUT to MATCH assignment report "confirm" service, response includes "successfully" with code "200"
    Then patient status should change to "<patient_status>"
    Then wait for "15" seconds
    Then COG received assignment status: "<patient_status>" for this patient
    Examples:
      | patient_id            | ani                        | patient_status     |
      | PT_AM01_TsVrReceived1 | PT_AM01_TsVrReceived1_ANI1 | NO_TA_AVAILABLE    |
      | PT_AM01_TsVrReceived2 | PT_AM01_TsVrReceived2_ANI1 | COMPASSIONATE_CARE |

  @patients_p3
  Scenario: PT_AM02. patient can reach PENDING_CONFIRMATION status even cog service collapses during assignment processing
#    patient: "PT_AM02_VrReceived" with status: "TISSUE_VARIANT_REPORT_RECEIVED" on step: "1.0", assays are ready
    #patient api will retry every 60 seconds
    Given patient id is "PT_AM02_VrReceived"
    And this patient is in mock service lost patient list, service will come back after "1" tries
    And patient API user authorization role is "MDA_VARIANT_REPORT_REVIEWER"
    Then load template variant report confirm message for analysis id: "PT_AM02_VrReceived_ANI1"
    When PUT to MATCH variant report "confirm" service, response includes "successfully" with code "200"
    Then wait for "180" seconds
    Then patient status should change to "PENDING_CONFIRMATION"

  @patients_p2 @patients_queueless
  Scenario Outline: PT_AM02b. assignment report can be confirmed if cog service recovered after 2 failures
    Given patient id is "<patient_id>"
    And this patient is in mock assign lost patient list, service will come back after "3" tries
    And patient API user authorization role is "ASSIGNMENT_REPORT_REVIEWER"
    Then load template assignment report confirm message for analysis id: "<ani>"
    Then PUT to MATCH assignment report "confirm" service, response includes "COG after 3 tries" with code "500"
    And this patient is in mock assign lost patient list, service will come back after "2" tries
    And patient API user authorization role is "ASSIGNMENT_REPORT_REVIEWER"
    Then load template assignment report confirm message for analysis id: "<ani>"
    Then PUT to MATCH assignment report "confirm" service, response includes "success" with code "200"
    Examples:
      | patient_id                           | ani                                       |
      | PT_AM02b_PendingConfirmation         | PT_AM02b_PendingConfirmation_ANI1         |
      | PT_AM02b_PendingConfirmationNoTa     | PT_AM02b_PendingConfirmationNoTa_ANI1     |
      | PT_AM02b_PendingConfirmationCompCare | PT_AM02b_PendingConfirmationCompCare_ANI1 |

  @patients_p3
  Scenario: PT_AM03. on treatment arm message with wrong treatment arm information should fail
#    patient: "PT_AM03_PendingApproval" with status: "PENDING_APPROVAL" on step: "1.0"
#    patient is currently on treatment arm: "APEC1621-A", stratum: "100"
    Given patient id is "PT_AM03_PendingApproval"
    And patient API user authorization role is "PATIENT_MESSAGE_SENDER"
    Then load template on treatment arm confirm message for this patient
    Then set patient message field: "treatment_arm_id" to value: "APEC1621-B"
    Then set patient message field: "stratum_id" to value: "100"
    Then set patient message field: "step_number" to value: "1.1"
    When POST to MATCH patients service, response includes "treatment arm id" with code "403"

  @patients_p1 @demo_p1 @patients_need_queue
  Scenario Outline: PT_AM04. treatment arm should be able to assign to multiple patients
    Given patient id is "<patient_id>"
    And patient API user authorization role is "MDA_VARIANT_REPORT_REVIEWER"
    Then load template variant report confirm message for analysis id: "<ani>"
    When PUT to MATCH variant report "confirm" service, response includes "successfully" with code "200"
    Then patient status should change to "PENDING_CONFIRMATION"
    Then load template assignment report confirm message for analysis id: "<ani>"
    And patient API user authorization role is "ASSIGNMENT_REPORT_REVIEWER"
    Then PUT to MATCH assignment report "confirm" service, response includes "successfully" with code "200"
    Then load template on treatment arm confirm message for this patient
    And patient API user authorization role is "PATIENT_MESSAGE_SENDER"
    Then set patient message field: "treatment_arm_id" to value: "APEC1621-A"
    Then set patient message field: "stratum_id" to value: "100"
    Then set patient message field: "step_number" to value: "1.1"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "ON_TREATMENT_ARM"
    Then patient field: "current_step_number" should have value: "1.1"
    Examples:
      | patient_id          | ani                      |
      | PT_AM04_TsReceived1 | PT_AM04_TsReceived1_ANI1 |
      | PT_AM04_TsReceived2 | PT_AM04_TsReceived2_ANI1 |

  @patients_p1 @patients_need_queue
  Scenario Outline: PT_AM05. patients can be properly assigned to treatment arms with same id but different stratum
    Given patient id is "<patient_id>"
    And patient API user authorization role is "MDA_VARIANT_REPORT_REVIEWER"
    Then load template variant report confirm message for analysis id: "<ani>"
    When PUT to MATCH variant report "confirm" service, response includes "successfully" with code "200"
    Then patient status should change to "PENDING_CONFIRMATION"
    Then patient should have selected treatment arm: "APEC1621-X" with stratum id: "<stratum_id>"
    Then load template assignment report confirm message for analysis id: "<ani>"
    And patient API user authorization role is "ASSIGNMENT_REPORT_REVIEWER"
    Then PUT to MATCH assignment report "confirm" service, response includes "successfully" with code "200"
    Then patient status should change to "PENDING_APPROVAL"
    Then load template on treatment arm confirm message for this patient
    And patient API user authorization role is "PATIENT_MESSAGE_SENDER"
    Then set patient message field: "treatment_arm_id" to value: "APEC1621-X"
    Then set patient message field: "stratum_id" to value: "<stratum_id>"
    Then set patient message field: "step_number" to value: "1.1"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "ON_TREATMENT_ARM"
    Then patient field: "current_step_number" should have value: "1.1"
    Examples:
      | patient_id            | ani                        | stratum_id |
      | PT_AM05_TsVrReceived1 | PT_AM05_TsVrReceived1_ANI1 | 100        |
      | PT_AM05_TsVrReceived2 | PT_AM05_TsVrReceived2_ANI1 | 200        |

  @patients_p1 @patients_need_queue
  Scenario Outline: PT_AM06. patient can be properly re-assigned to treatment arms with same id but different stratum
    Given patient id is "<patient_id>"
    And patient API user authorization role is "MDA_VARIANT_REPORT_REVIEWER"
    Then load template variant report confirm message for analysis id: "<ani>"
    When PUT to MATCH variant report "confirm" service, response includes "successfully" with code "200"
    Then patient status should change to "PENDING_CONFIRMATION"
    Then patient should have selected treatment arm: "APEC1621-X" with stratum id: "100"
    Then load template assignment report confirm message for analysis id: "<ani>"
    And patient API user authorization role is "ASSIGNMENT_REPORT_REVIEWER"
    Then PUT to MATCH assignment report "confirm" service, response includes "successfully" with code "200"
    Then patient status should change to "PENDING_APPROVAL"
    Then load template request assignment message for this patient
    Then set patient message field: "rebiopsy" to value: "N"
    And patient API user authorization role is "PATIENT_MESSAGE_SENDER"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "PENDING_CONFIRMATION"
    Then patient should have selected treatment arm: "APEC1621-X" with stratum id: "200"
    Examples:
      | patient_id            | ani                        |
      | PT_AM06_TsVrReceived1 | PT_AM06_TsVrReceived1_ANI1 |

        #no blood status is used anymore
#  Scenario: PT_AM05. rejected blood variant report should not prevent api triggering assignment process
#    Given patient: "PT_AM05" with status: "TISSUE_VARIANT_REPORT_RECEIVED" on step: "1.0"
#    Given this patients's active "TISSUE" molecular_id is "PT_AM05_MOI1"
#    Given this patients's active "TISSUE" analysis_id is "PT_AM05_ANI1"
#    Given other background and comments for this patient: "assay and pathology are ready, blood variant report is rejected"
#    Then "TISSUE" variant report confirmed with status: "CONFIRMED"
#    Then COG approves patient on treatment arm: "APEC1621-A", stratum: "100" to step: "1.1"
#    Then patient status should be "ON_TREATMENT_ARM" within 15 seconds
#    Then patient step number should be "1.1" within 15 seconds


  @patients_p2 @patients_need_queue
  Scenario Outline: PT_AM09. even if patient data from COG has empty drug_id, patient should still be assigned
    #PT_AM09_VrAssayReady1 has drug_id null in mock cog data
    #PT_AM09_VrAssayReady2 has drug_id '' in mock cog data
    #PT_AM09_VrAssayReady3 doesn't have drug_id in mock cog data
    Given patient id is "<patient_id>"
    And patient API user authorization role is "MDA_VARIANT_REPORT_REVIEWER"
    Then load template variant report confirm message for analysis id: "<ani>"
    When PUT to MATCH variant report "confirm" service, response includes "successfully" with code "200"
    Then patient status should change to "PENDING_CONFIRMATION"
    Then patient should have selected treatment arm: "APEC1621-A" with stratum id: "100"
    Examples:
      | patient_id            | ani                        |
      | PT_AM09_VrAssayReady1 | PT_AM09_VrAssayReady1_ANI1 |
      | PT_AM09_VrAssayReady2 | PT_AM09_VrAssayReady2_ANI1 |
      | PT_AM09_VrAssayReady3 | PT_AM09_VrAssayReady3_ANI1 |

  @patients_p1 @patients_need_queue
  Scenario: PT_AM10. patient should show correct assignment for selected arm
    Given patient id is "PT_AM10_AssayVrReady"
    And patient API user authorization role is "MDA_VARIANT_REPORT_REVIEWER"
    Then load template variant report confirm message for analysis id: "PT_AM10_AssayVrReady_ANI1"
    When PUT to MATCH variant report "confirm" service, response includes "successfully" with code "200"
    Then patient status should change to "PENDING_CONFIRMATION"
    Then patient GET service: "analysis_report", patient id: "PT_AM10_AssayVrReady", id: "PT_AM10_AssayVrReady_ANI1"
    When GET from MATCH patient API, http code "200" should return
    Then this patient analysis_report current_assignment should be treatment arm "APEC1621-A" stratum "100"
    Then this patient analysis_report latest assignment SELECTED should be treatment arm "APEC1621-A" stratum "100"
    Then this patient analysis_report latest assignment result should be in the order from following table
      | result items                                  |
      | NO_VARIANT_MATCH_EXCLUSION                    |
      | ARM_SUSPENDED_EXCLUSION                       |
      | LEVEL_OF_EVIDENCE_TIE_BREAKER_BASED_EXCLUSION |
      | SELECTED                                      |
    Then this patient analysis_report latest assignment should have treatment arm descriptions
    Then patient GET service: "specimen_events", patient id: "PT_AM10_AssayVrReady", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then this patient tissue specimen_events analyses "PT_AM10_AssayVrReady_ANI1" latest assignment should be:
      | assignment_report_status | treatment_arm_id | treatment_arm_stratum_id | treatment_arm_version |
      | PENDING                  | APEC1621-A       | 100                      | 2015-08-06            |

  @patients_p3
  Scenario: PT_AM11. patient should show correct assignment for compassionate care
    Given patient id is "PT_AM11_AssayVrCompCareReady"
    And patient API user authorization role is "MDA_VARIANT_REPORT_REVIEWER"
    Then load template variant report confirm message for analysis id: "PT_AM11_AssayVrCompCareReady_ANI1"
    When PUT to MATCH variant report "confirm" service, response includes "successfully" with code "200"
    Then patient status should change to "PENDING_CONFIRMATION"
    Then patient GET service: "analysis_report", patient id: "PT_AM11_AssayVrCompCareReady", id: "PT_AM11_AssayVrCompCareReady_ANI1"
    When GET from MATCH patient API, http code "200" should return
    Then this patient analysis_report current_assignment should be treatment arm "null" stratum "null"
    Then this patient analysis_report latest assignment SELECTED should be treatment arm "null" stratum "null"
    Then this patient analysis_report latest assignment result should be in the order from following table
      | result items               |
      | NO_VARIANT_MATCH_EXCLUSION |
      | ARM_SUSPENDED_EXCLUSION    |
    Then this patient analysis_report latest assignment should have treatment arm descriptions
    Then patient GET service: "specimen_events", patient id: "PT_AM11_AssayVrCompCareReady", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then this patient tissue specimen_events analyses "PT_AM10_AssayVrReady_ANI1" latest assignment should be:
      | assignment_report_status | treatment_arm_id                  | treatment_arm_stratum_id | treatment_arm_version |
      | PENDING                  | "CukeTest-122-1-SUSPENDED (null?) | stratum122a(null?)       | 2015-08-06            |

  @patients_p3
  Scenario: PT_AM12. patient should show correct assignkent for no ta available
    Given patient id is "PT_AM12_AssayVrNoTaReady"
    And patient API user authorization role is "MDA_VARIANT_REPORT_REVIEWER"
    Then load template variant report confirm message for analysis id: "PT_AM12_AssayVrNoTaReady_ANI1"
    When PUT to MATCH variant report "confirm" service, response includes "successfully" with code "200"
    Then patient status should change to "PENDING_CONFIRMATION"
    Then patient GET service: "analysis_report", patient id: "PT_AM12_AssayVrNoTaReady", id: "PT_AM12_AssayVrNoTaReady_ANI1"
    When GET from MATCH patient API, http code "200" should return
    Then this patient analysis_report current_assignment should be treatment arm "null" stratum "null"
    Then this patient analysis_report latest assignment SELECTED should be treatment arm "null" stratum "null"
    Then this patient analysis_report latest assignment result should be in the order from following table
      | result items               |
      | NO_VARIANT_MATCH_EXCLUSION |
      | ARM_SUSPENDED_EXCLUSION    |
    Then this patient analysis_report latest assignment should have treatment arm descriptions
    Then patient GET service: "specimen_events", patient id: "PT_AM12_AssayVrNoTaReady", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then this patient tissue specimen_events analyses "PT_AM10_AssayVrReady_ANI1" latest assignment should be:
      | assignment_report_status | treatment_arm_id | treatment_arm_stratum_id | treatment_arm_version |
      | PENDING                  | null             | null                     | null                  |

  @patients_p1 @patients_need_queue
  Scenario: PT_AM13. multiple assignment can be processed at same time
    Given patient id is "PT_AM13_AssayVrReady1"
    And patient API user authorization role is "MDA_VARIANT_REPORT_REVIEWER"
    Then load template variant report confirm message for analysis id: "PT_AM13_AssayVrReady1_ANI1"
    When PUT to MATCH variant report "confirm" service, response includes "successfully" with code "200"
    Given patient id is "PT_AM13_AssayVrReady2"
    Then load template variant report confirm message for analysis id: "PT_AM13_AssayVrReady2_ANI1"
    When PUT to MATCH variant report "confirm" service, response includes "successfully" with code "200"
    And patient status should change to "PENDING_CONFIRMATION"
    Then patient id is "PT_AM13_AssayVrReady1"
    And patient status should change to "PENDING_CONFIRMATION"

  @patients_p1 @patients_need_queue
  Scenario Outline: PT_AM14. Patient Assignment should also accept Mock COG data with the DOB field in it
    Given patient id is "<patient_id>"
    And patient API user authorization role is "MDA_VARIANT_REPORT_REVIEWER"
    Then load template variant report confirm message for analysis id: "<analysis_id>"
    And call Mock COG and check the existence of DOB field in this patient "<patient_id>" data
    When PUT to MATCH variant report "confirm" service, response includes "successfully" with code "200"
    And patient status should change to "PENDING_CONFIRMATION"
    Then patient API user authorization role is "ASSIGNMENT_REPORT_REVIEWER"
    Then load template assignment report confirm message for analysis id: "<analysis_id>"
    Then PUT to MATCH assignment report "confirm" service, response includes "successfully" with code "200"
    Then patient status should change to "PENDING_APPROVAL"
    Then wait for "15" seconds
    Then COG received assignment status: "PENDING_APPROVAL" for this patient
  Examples:
    | patient_id                | analysis_id                    |
    | PT_DOB1_VrConfirmed3Assay | PT_DOB1_VrConfirmed3Assay_ANI1 |
