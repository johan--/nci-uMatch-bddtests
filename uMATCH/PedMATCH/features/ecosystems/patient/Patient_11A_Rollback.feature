@patients_rollback
Feature: Patient API rollback tests

  @patients_p1_off
  Scenario Outline: PT_RB01.rollback request will fail when patient is on certain status
    Given patient id is "<patient_id>"
    When PUT to MATCH rollback, response includes "invalid" with code "403"
    Then patient status should change to "<status>"
    Examples:
      | patient_id            | status                   |
      | PT_RB01_Registered    | REGISTRATION             |
      | PT_RB01_TsReceived    | OFF_STUDY_BIOPSY_EXPIRED |
      | PT_RB01_TsShipped     | OFF_STUDY_BIOPSY_EXPIRED |
      | PT_RB01_slideShipped  | OFF_STUDY_BIOPSY_EXPIRED |
      | PT_RB01_AssayReceived | OFF_STUDY_BIOPSY_EXPIRED |
      | PT_RB01_TsVrReceived  | OFF_STUDY_BIOPSY_EXPIRED |
      | PT_RB01_ReqAssignment | OFF_STUDY_BIOPSY_EXPIRED |
      | PT_RB01_OffStudy      | OFF_STUDY                |
#      | PT_RB01_TsVrConfirmed         | OFF_STUDY_BIOPSY_EXPIRED |
#      | PT_RB01_TsVrRejected          | OFF_STUDY_BIOPSY_EXPIRED |
#      | PT_RB01_PendingConfirmation   | OFF_STUDY_BIOPSY_EXPIRED |
#      | PT_RB01_PendingApproval       | OFF_STUDY_BIOPSY_EXPIRED |
#      | PT_RB01_OnTreatmentArm        | ON_TREATMENT_ARM         |
#      | PT_RB01_ReqNoAssignment       | OFF_STUDY_BIOPSY_EXPIRED |
#      | PT_RB01_NoTaAvailable         | OFF_STUDY_BIOPSY_EXPIRED |
#      | PT_RB01_CompassionateCare     | OFF_STUDY_BIOPSY_EXPIRED |

  @patients_p1_off
  Scenario Outline: PT_RB01a. confirmed and rejected variant report can be rolled back
    Given patient id is "<patient_id>"
    And patient API user authorization role is "ADMIN"
    When PUT to MATCH rollback, response includes "roll back" with code "200"
    Then patient status should change to "TISSUE_VARIANT_REPORT_RECEIVED"
    Then patient should have variant report (analysis_id: "<patient_id>_ANI1")
    And this variant report field: "comment_user" should be "null"
    And this variant report field: "status" should be "PENDING"
    And patient latest event field "event_message" should be "Variant report has been rolled back to PENDING"
    Then load template variant report confirm message for analysis id: "<patient_id>__ANI1"
    When PUT to MATCH variant report "confirm" service, response includes "changed successfully to" with code "200"
    Then patient status should change to "TISSUE_VARIANT_REPORT_CONFIRMED"
    Then load template assay message for this patient
    Then set patient message field: "surgical_event_id" to value: "<patient_id>__SEI1"
    Then set patient message field: "biomarker" to value: " ICCBRG1s"
    Then set patient message field: "result" to value: "POSITIVE"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "PENDING_CONFIRMATION"
    Examples:
      | patient_id                    |
      | PT_RB01a_VrConfirmedTwoAssays |
      | PT_RB01a_VrRejectedTwoAssays  |

  @patients_p2_off
  Scenario Outline: PT_RB01b. rollback request should only rollback the latest confirmed variant report
    Given patient id is "<patient_id>"
    And patient API user authorization role is "ADMIN"
    When PUT to MATCH rollback, response includes "" with code "200"
    Then patient status should change to "TISSUE_VARIANT_REPORT_RECEIVED"
    Then patient should have variant report (analysis_id: "<patient_id>_ANI2")
    And this variant report field: "status" should be "PENDING"
    Then patient should have variant report (analysis_id: "<patient_id>_ANI1")
    And this variant report field: "status" should be "CONFIRMED"
    Examples:
      | patient_id                |
      | PT_RB01b_VrConfirmedStep2 |
      | PT_RB01b_VrRejectedStep2  |

  @patients_p1_off
  Scenario Outline: PT_RB02a. confirmed assignment report can be rolled back and redo the assignment should have same result
    Given patient id is "<patient_id>"
    And this patient should have "<count>" assignments for analysis id "<patient_id>_ANI1"
    And patient should have selected treatment arm: "<selected_ta1>" with stratum id: "100"
    And patient should have prior_recommended_treatment_arms: "<prior_ta1>" with stratum id: "<prior_str1>"
    And patient should have prior_recommended_treatment_arms: "<prior_ta2>" with stratum id: "<prior_str2>"
    And patient API user authorization role is "ADMIN"
    When PUT to MATCH rollback, response includes "roll back" with code "200"
    Then patient status should change to "TISSUE_VARIANT_REPORT_RECEIVED"
    Then patient should "not have" assignment report (analysis_id: "<patient_id>_ANI1")
    Then patient should have variant report (analysis_id: "<patient_id>_ANI1")
    And this variant report field: "comment_user" should be "null"
    And this variant report field: "status" should be "PENDING"
    Then load template variant report confirm message for analysis id: "<patient_id>_ANI1"
    When PUT to MATCH variant report "confirm" service, response includes "changed successfully to" with code "200"
    Then patient status should change to "PENDING_CONFIRMATION"
    And patient should have selected treatment arm: "APEC1621-A" with stratum id: "100"
    Examples:
      | patient_id                   | count | selected_ta1   | prior_ta1  | prior_str1 | prior_ta2      | prior_str2 |
      | PT_RB02a_PendingConfirmation | 1     | APEC1621-A     |            |            |                |            |
      | PT_RB02a_PendingApproval     | 1     | APEC1621-A     |            |            |                |            |
      | PT_RB02a_PendAppr3Assigns    | 3     | APEC1621-ETE-C | APEC1621-A | 100        | APEC1621-ETE-A | 100        |

  @patients_p2_off
  Scenario: PT_RB02b. rollback service only rollback the latest confirmed assignment report
    Given patient id is "PT_RB02b_PendingApprStep2"
    When PUT to MATCH rollback, response includes "" with code "200"
    Then patient status should change to "PENDING_CONFIRMATION"
    Then this patient should have "1" assignments for analysis id "PT_RB02b_PendingApprStep2_ANI1"
    And this assignment status should be "CONFIRMED"
    Then this patient should have "1" assignments for analysis id "PT_RB02b_PendingApprStep2_ANI2"
    And this assignment status should be "PENDING"