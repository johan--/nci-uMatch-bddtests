@patients_rollback
Feature: Patient API rollback tests

  @patients_p1_off
  Scenario Outline: PT_RB01.rollback request will fail when patient is on certain status
    Given patient id is "<patient_id>"
    When PUT to MATCH rollback with step number "1.0", response includes "invalid" with code "403"
    Then patient status should change to "<status>"
    Examples:
      | patient_id            | status                         |
      | PT_RB01_Registered    | REGISTRATION                   |
      | PT_RB01_TsReceived    | TISSUE_SPECIMEN_RECEIVED       |
      | PT_RB01_TsShipped     | TISSUE_NUCLEIC_ACID_SHIPPED    |
      | PT_RB01_slideShipped  | TISSUE_SLIDE_SPECIMEN_SHIPPED  |
      | PT_RB01_AssayReceived | ASSAY_RESULTS_RECEIVED         |
      | PT_RB01_TsVrReceived  | TISSUE_VARIANT_REPORT_RECEIVED |
      | PT_RB01_ReqAssignment | REQUEST_ASSIGNMENT             |
      | PT_RB01_OffStudy      | OFF_STUDY                      |

#  items to check:
#      all statuses: VR_CONFIRMED, VR_REJECTED, PENDING_CONFIRMATION, PENDING_APPROVAL, ON_TA, COMP_CARE, NO_TA
#      ta assignment event should be updated
#      assay result which is sent after the step that need to be rollback should not be affected
#      blood actions which are sent after the step that need to be rollback should not be affected
#      can be re-assigned to same treatment arm (clear recommended treatment arm)
#      status change properly
#      rollback event in timeline
#      dashboard items updated (pending items, limbos, statistics, accrual)
#      only rollback one step (multiple assignments, multiple confirmed(rejected) vr)
#      same rollback can repeat multiple times (rollback->assign->rollback)
#      can be rollback step by step (on treatment arm: rollback->rollback->rollback)
#      no ta found in pending confirmation->rollback->uncheck variant->confirm->ta found
#      no ta found in pending confirmation->rollback->assay->confirm->ta found

  @patients_p1_off
  Scenario Outline: PT_RB02a. VR confirmed (rejected) can be rolled back properly
    Given patient id is "<patient_id>"
    When PUT to MATCH rollback with step number "<step>", response includes "roll back" with code "200"
    Then patient status should change to "TISSUE_VARIANT_REPORT_RECEIVED"
    Then patient should have variant report (analysis_id: "<ani>")
    And this variant report field: "comment_user" should be "null"
    And this variant report field: "status" should be "PENDING"
    And patient latest event field "event_message" should be "Variant report has been rolled back to PENDING"
    Then patient GET service: "pending_items", patient id: "", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "1" patient "tissue_variant_reports" pending_items have field: "analysis_id" value: "<ani>"
    Then patient GET service: "patient_limbos", patient id: "", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "1" patient_limbos have field: "patient_id" value: "<patient_id>"
    Then this patient patient_limbos should have "2" messages which contain "confirmed-Slide"

    Then load template variant report confirm message for analysis id: "<ani>"
    When PUT to MATCH variant report "<confirm>" service, response includes "changed successfully to" with code "200"
    Then patient status should change to "<pt_status>"
    Then patient GET service: "pending_items", patient id: "", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "0" patient "tissue_variant_reports" pending_items have field: "analysis_id" value: "<ani>"
    Then patient GET service: "patient_limbos", patient id: "", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "1" patient_limbos have field: "patient_id" value: "<patient_id>"
    Then this patient patient_limbos should have "2" messages which contain "<limbo_vr>-Slide"

    When PUT to MATCH rollback with step number "<step>", response includes "roll back" with code "200"
    Then patient status should change to "TISSUE_VARIANT_REPORT_RECEIVED"
    Then patient should have variant report (analysis_id: "<ani>")
    And this variant report field: "comment_user" should be "null"
    And this variant report field: "status" should be "PENDING"
    And patient latest event field "event_message" should be "Variant report has been rolled back to PENDING"
    Then patient GET service: "pending_items", patient id: "", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "1" patient "tissue_variant_reports" pending_items have field: "analysis_id" value: "<ani>"
    Then patient GET service: "patient_limbos", patient id: "", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "1" patient_limbos have field: "patient_id" value: "<patient_id>"
    Then this patient patient_limbos should have "2" messages which contain "confirmed-Slide"
    Examples:
      | patient_id                    | ani                                | step | confirm | pt_status                       | limbo_vr  |
      | PT_RB02a_VRConfirmedNoSd      | PT_RB02a_VRConfirmedNoSd_ANI1      | 1.0  | confirm | TISSUE_VARIANT_REPORT_CONFIRMED | confirmed |
      | PT_RB02a_VRRejectedNoSd       | PT_RB02a_VRRejectedNoSd_ANI1       | 1.0  | reject  | TISSUE_VARIANT_REPORT_REJECTED  | Variant   |
      | PT_RB02a_VRConfirmedNoSdStep2 | PT_RB02a_VRConfirmedNoSdStep2_ANI2 | 2.0  | confirm | TISSUE_VARIANT_REPORT_CONFIRMED | confirmed |
      | PT_RB02a_VRRejectedNoSdStep2  | PT_RB02a_VRRejectedNoSdStep2_ANI1  | 2.0  | reject  | TISSUE_VARIANT_REPORT_REJECTED  | Variant   |


  @patients_p1_off
  Scenario Outline: PT_RB02b. PENDING_CONFIRMATION can be rolled back properly
    Given patient id is "<patient_id>"
    When PUT to MATCH rollback with step number "<step>", response includes "roll back" with code "200"
    Then patient status should change to "TISSUE_VARIANT_REPORT_RECEIVED"
    Examples:
      | patient_id                    |
      | PT_RB02b_PendConf             |
      | PT_RB02b_PendConfStep2        |
      | PT_RB02b_PendConfVrThenAssay  |
      | PT_RB02b_PendApprThenPendConf |

  @patients_p1_off
  Scenario Outline: PT_RB01a. confirmed and rejected variant report can be rolled back
    Given patient id is "<patient_id>"
    And patient API user authorization role is "ADMIN"
    When PUT to MATCH rollback with step number "1.0", response includes "roll back" with code "200"
    Then patient status should change to "TISSUE_VARIANT_REPORT_RECEIVED"
    Then patient should have variant report (analysis_id: "<patient_id>_ANI1")
    And this variant report field: "comment_user" should be "null"
    And this variant report field: "status" should be "PENDING"
    And patient latest event field "event_message" should be "Variant report has been rolled back to PENDING"
    Then load template variant report confirm message for analysis id: "<patient_id>_ANI1"
    When PUT to MATCH variant report "confirm" service, response includes "changed successfully to" with code "200"
    Then patient status should change to "TISSUE_VARIANT_REPORT_CONFIRMED"
    Then load template assay message for this patient
    Then set patient message field: "surgical_event_id" to value: "<patient_id>_SEI1"
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
    When PUT to MATCH rollback with step number "1.0", response includes "roll back" with code "200"
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
    When PUT to MATCH rollback with step number "1.0", response includes "roll back" with code "200"
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
    When PUT to MATCH rollback with step number "1.0", response includes "roll back" with code "200"
    Then patient status should change to "PENDING_CONFIRMATION"
    Then this patient should have "1" assignments for analysis id "PT_RB02b_PendingApprStep2_ANI1"
    And this assignment status should be "CONFIRMED"
    Then this patient should have "1" assignments for analysis id "PT_RB02b_PendingApprStep2_ANI2"
    And this assignment status should be "PENDING"


  @patients_p1_off
  Scenario Outline: PT_SC02h pending_items should increase tissue_variant_reports value properly by rolling back confirmed variant report
    Given patient id is "<patient_id>"
    And patient API user authorization role is "ADMIN"
    When PUT to MATCH rollback with step number "1.0", response includes "roll back" with code "200"
    Then patient status should change to "TISSUE_VARIANT_REPORT_RECEIVED"
    Then patient GET service: "pending_items", patient id: "", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "1" patient "<pending_type>" pending_items have field: "analysis_id" value: "<ani>"
    Examples:
      | patient_id             | ani                         | pending_type           |
      | PT_SC02h_TsVrConfirmed | PT_SC02h_TsVrConfirmed_ANI1 | tissue_variant_reports |

  @patients_p1_off
  Scenario Outline: PT_SC02i pending_items should increase tissue_variant_reports value properly by rolling back confirmed assignment report
    Given patient id is "<patient_id>"
    And patient API user authorization role is "ADMIN"
    When PUT to MATCH rollback with step number "1.0", response includes "roll back" with code "200"
    Then patient status should change to "TISSUE_VARIANT_REPORT_RECEIVED"
    Then patient GET service: "pending_items", patient id: "", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "1" patient "tissue_variant_reports" pending_items have field: "analysis_id" value: "<ani>"
    Then there are "0" patient "assignment_reports" pending_items have field: "analysis_id" value: "<ani>"
    Examples:
      | patient_id               | ani                           |
      | PT_SC02i_PendingApproval | PT_SC02i_PendingApproval_ANI1 |