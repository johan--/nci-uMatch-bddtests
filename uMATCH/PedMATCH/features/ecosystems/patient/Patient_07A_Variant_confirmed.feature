#encoding: utf-8
@variant_confirm
Feature: Variant files confirmed messages

  Background:
    Given patient API user authorization role is "MDA_VARIANT_REPORT_REVIEWER"

  @patients_p1 @patients_queueless
  Scenario: PT_VC00. blood variant can be confirmed properly
    Given patient id is "PT_VC00_BdVrUploaded"
    And a random variant for analysis id "PT_VC00_BdVrUploaded_BD_ANI1"
    Then load template variant confirm message for this patient
    Then set patient message field: "comment" to value: "unchecking variant"
    When PUT to MATCH variant "unchecked" service for this uuid, response includes "changed to false" with code "200"
    Then this variant should have confirmed field: "false" and comment field: "unchecking variant"
    Then set patient message field: "comment" to value: "checking variant"
    When PUT to MATCH variant "checked" service for this uuid, response includes "changed to true" with code "200"
    Then this variant should have confirmed field: "true" and comment field: "checking variant"

  @patients_p2 @patients_queueless
  Scenario Outline: PT_VC01. variant confirm message with invalid variant_uuid should fail
    Given patient id is "PT_VC01_VRUploaded"
    And variant uuid is "<uuid>"
    And load template variant confirm message for this patient
    When PUT to MATCH variant "unchecked" service for this uuid, response includes "<message>" with code "404"
    Examples:
      | uuid              | message   |
  #    |                                 |can't be blank        |
  #    |null                             |can't be blank        |
      | non-existing_uuid | not exist |

  @patients_p3 @patients_travis_test
  Scenario Outline: PT_VC02. variant confirm message with invalid confirmed should fail
    #    Test Patient: PT_VC02_VRUploaded, VR uploaded PT_VC02_VRUploaded(_SEI1, _MOI1, _ANI1)
    Given patient id is "PT_VC02_VRUploaded"
    And a random variant for analysis id "PT_VC02_VRUploaded_ANI1"
    And load template variant confirm message for this patient
    Then PUT to MATCH variant "<checked>" service for this uuid, response includes "<message>" with code "403"
    Examples:
      | checked                  | message                                             |
#      |                                 |not of a minimum string length of 1                      |
#      |null                             |NilClass did not match the following type: string        |
      | not_checked_or_unchecked | Unregnized checked flag in variant confirmation url |

  @patients_p2 @patients_queueless
  Scenario: PT_VC03. variant_confirmed message will not be accepted if it is using a variant uuid that belongs to a rejected variant report (uuid should be only ones in current pending variant list)
#    Test Patient: PT_VC03_VRUploadedAfterRejected, VR rejected: PT_VC03_VRUploadedAfterRejected(_SEI1, _MOI1, _ANI1), VR uploaded PT_VC03_VRUploadedAfterRejected(_SEI1, _MOI1, _ANI2)
    Given patient id is "PT_VC03_VRUploadedAfterRejected"
    And a random variant for analysis id "PT_VC03_VRUploadedAfterRejected_ANI1"
    And load template variant confirm message for this patient
    Then PUT to MATCH variant "unchecked" service for this uuid, response includes "REJECTED" with code "403"

#  comment: should not be null or empty if confirmed is false --- DON'T test, this will be UI work

  @patients_p2 @patients_queueless
  Scenario: PT_VC04. when variant get confirmed again after it get un-confirmed, the comment value should be cleared
    #    Test Patient: PT_VC04_VRUploaded, VR uploaded PT_VC04_VRUploaded(_SEI1, _MOI1, _ANI1)
    Given patient id is "PT_VC04_VRUploaded"
    And a random variant for analysis id "PT_VC04_VRUploaded_ANI1"
    And load template variant confirm message for this patient
    Then set patient message field: "comment" to value: "TEST"
    Then PUT to MATCH variant "unchecked" service for this uuid, response includes "changed to false" with code "200"
    Then this variant should have confirmed field: "false" and comment field: "TEST"
    Then set patient message field: "comment" to value: ""
    Then PUT to MATCH variant "checked" service for this uuid, response includes "changed to true" with code "200"
    Then this variant should have confirmed field: "true" and comment field: "null"

  @patients_p2 @patients_queueless
  Scenario: PT_VC04a. comment can be updated properly
    #Test patient: PT_VC04a_VRUploaded, PT_VC04a_VRUploaded(_SEI1, _MOI1, _ANI1)
    Given patient id is "PT_VC04a_VRUploaded"
    And a random variant for analysis id "PT_VC04a_VRUploaded_ANI1"
    And load template variant confirm message for this patient
    Then set patient message field: "comment" to value: "TEST"
    Then PUT to MATCH variant "unchecked" service for this uuid, response includes "changed to false" with code "200"
    Then set patient message field: "comment" to value: "COMMENT_EDITED"
    Then PUT to MATCH variant "unchecked" service for this uuid, response includes "changed to false" with code "200"
    Then this variant should have confirmed field: "false" and comment field: "COMMENT_EDITED"

  @patients_p2 @patients_need_queue
  Scenario: PT_VC05. confirmed fields should be "true" as default
    #    Test Patient: PT_VC05_TissueShipped, Tissue shipped PT_VC05_TissueShipped(_SEI1, _MOI1)
    Given patient id is "PT_VC05_TissueShipped"
    And patient API user authorization role is "SYSTEM"
    And load template variant file uploaded message for molecular id: "PT_VC05_TissueShipped_MOI1"
    Then set patient message field: "analysis_id" to value: "PT_VC05_TissueShipped_ANI1"
    Then files for molecular_id "PT_VC05_TissueShipped_MOI1" and analysis_id "PT_VC05_TissueShipped_ANI1" are in S3
    When POST to MATCH variant report upload service, response includes "successfully" with code "202"
    Then patient status should change to "TISSUE_VARIANT_REPORT_RECEIVED"
    Then variants in variant report (analysis_id: "PT_VC05_TissueShipped_ANI1") have confirmed: "true"

  @patients_p2 @patients_need_queue
  Scenario: PT_VC05a. all confirmed fields should be "false" after a new variant report get uploaded
    #    Test Patient: PT_VC05a_VRUploaded, VR uploaded PT_VC05a_VRUploaded(_SEI1, _MOI1, _ANI1)
    Given patient id is "PT_VC05a_VRUploaded"
    And a random variant for analysis id "PT_VC05a_VRUploaded_ANI1"
    And load template variant confirm message for this patient
    Then set patient message field: "comment" to value: "TEST"
    Then PUT to MATCH variant "unchecked" service for this uuid, response includes "changed to false" with code "200"
    And load template variant file uploaded message for molecular id: "PT_VC05a_VRUploaded_MOI1"
    And patient API user authorization role is "SYSTEM"
    Then set patient message field: "molecular_id" to value: "PT_VC05a_VRUploaded_MOI1"
    Then set patient message field: "analysis_id" to value: "PT_VC05a_VRUploaded_ANI2"
    Then files for molecular_id "PT_VC05a_VRUploaded_MOI1" and analysis_id "PT_VC05a_VRUploaded_ANI2" are in S3
    When POST to MATCH variant report upload service, response includes "successfully" with code "202"
    Then wait until patient variant report is updated
    Then variants in variant report (analysis_id: "PT_VC05a_VRUploaded_ANI1") have confirmed: "false"


## we don't have status_date in variant level
#  Scenario: PT_VC06. status_date can be generated correctly
#    #    Test Patient: PT_VC06_VRUploaded, VR uploaded SEI_01, MOI_01, ANI_01
#    Given retrieve patient: "PT_VC04_VRUploaded" from API
#    Then find the first "gf" variant in variant report which has surgical_event_id: "SEI_01", molecular_id: "MOI_01" and analysis_id: "ANI_01"
#    Then create variant confirm message with confirmed: "false" and comment: "TEST" for this variant
#    When POST to MATCH patients service, response includes "TBD" with status "Success"
#    Then wait for "10" seconds
#    Then retrieve patient: "PT_VC04_VRUploaded" from API
#    Then this variant has correct status_date value

#  variant_file_confirmed:
  @patients_p3 @patients_travis_test
  Scenario Outline: PT_VC06. variant report confirm message with invalid patient_id should fail
    Given patient id is "<value>"
    Then load template variant report confirm message for analysis id: "ANI1"
    When PUT to MATCH variant report "confirm" service, response includes "<message>" with code "403"
    Examples:
      | value      | message             |
#      |               |can't be blank        |
#      |null           |can't be blank        |
      | nonPatient | not been registered |

#    molecular_id has been removed from this service
#  Scenario Outline: PT_VC08. variant report confirm message with invalid molecular_id should fail
#    Given template variant report confirm message for patient: "PT_VC08_VRUploaded", it has analysis_id: "PT_VC08_VRUploaded_ANI1" and status: "confirm"
#    When PUT to MATCH variant report confirm service, response includes "<message>" with status "Failure"
#    Examples:
#      |MOI            |message                    |
##      |               |can't be blank             |
##      |null           |can't be blank             |
#      |other          |Molecular id doesn't exist |

  @patients_p3
  Scenario Outline: PT_VC09. variant report confirm message with invalid analysis_id should fail
    Given patient id is "PT_VC09_VRUploaded"
    Then load template variant report confirm message for analysis id: "<ANI>"
    When PUT to MATCH variant report "confirm" service, response includes "latest analysis id" with code "403"
    Examples:
      | ANI                                 | comment                                      |
      | other                               | non existing analysis id                     |
      | PT_SS21_TissueVariantConfirmed_ANI1 | confirmed analysis id from other patient     |
      | PT_VC01_VRUploaded_ANI1             | not confirmed analysis id from other patient |

  @patients_p2 @patients_queueless
  Scenario Outline: PT_VC10. variant report confirm message using non-current ids should fail
    Given patient id is "<patient_id>"
    Then load template variant report confirm message for analysis id: "<ani>"
    When PUT to MATCH variant report "confirm" service, response includes "analysis id" with code "403"
    Examples:
      | patient_id                   | ani                               |
      | PT_VC10_VRUploadedSEIExpired | PT_VC10_VRUploadedSEIExpired_ANI1 |
      | PT_VC10_VRUploadedMOIExpired | PT_VC10_VRUploadedMOIExpired_ANI1 |
      | PT_VC10_VRUploadedANIExpired | PT_VC10_VRUploadedANIExpired_ANI1 |
      | PT_VC10_2ndBdVrUploaded      | PT_VC10_2ndBdVrUploaded_BD_ANI1   |

  @patients_p3
  Scenario Outline: PT_VC11. variant report confirm message with invalid status should fail
    Given patient id is "PT_VC11_VRUploaded"
    Then load template variant report confirm message for analysis id: "PT_VC11_VRUploaded_ANI1"
    When PUT to MATCH variant report "<status>" service, response includes "<message>" with code "403"
    Examples:
      | status | message                           |
#      |               |can't be blank                                                                  |
#      |null           |can't be blank                                                                  |
      | other  | can only be 'confirm' or 'reject' |

  @patients_p2 @patients_queueless
  Scenario Outline: PT_VC11b. variant report cannot be confirmed (rejected) more than one time
    Given patient id is "<patient_id>"
    Then load template variant report confirm message for analysis id: "<ani>"
    When PUT to MATCH variant report "<status>" service, response includes "<message>" with code "403"
    Then patient should have variant report (analysis_id: "<ani>")
    And this variant report field: "status" should be "<previous_status>"
    Examples:
      | patient_id             | ani                            | status  | previous_status | message              |
      | PT_VC11b_TsVRConfirmed | PT_VC11b_TsVRConfirmed_ANI1    | confirm | confirmed       | CONFIRMED            |
      | PT_VC11b_TsVRRejected  | PT_VC11b_TsVRRejected_ANI1     | confirm | rejected        | REJECTED             |
      | PT_VC11b_TsVRConfirmed | PT_VC11b_TsVRConfirmed_ANI1    | reject  | confirmed       | CONFIRMED            |
      | PT_VC11b_TsVRRejected  | PT_VC11b_TsVRRejected_ANI1     | reject  | rejected        | REJECTED             |
      | PT_VC11b_BdVRConfirmed | PT_VC11b_BdVRConfirmed_BD_ANI1 | confirm | confirmed       | not in PENDING state |
      | PT_VC11b_BdVRRejected  | PT_VC11b_BdVRRejected_BD_ANI1  | confirm | rejected        | not in PENDING state |
      | PT_VC11b_BdVRConfirmed | PT_VC11b_BdVRConfirmed_BD_ANI1 | reject  | confirmed       | not in PENDING state |
      | PT_VC11b_BdVRRejected  | PT_VC11b_BdVRRejected_BD_ANI1  | reject  | rejected        | not in PENDING state |


  @patients_p1 @patients_queueless
  Scenario Outline: PT_VC12. after accepting variant_file_confirmed message, patient should be set to correct status, comment, user and date
#  Test patient: PT_VC12_VRUploaded1: vr uploaded PT_VC12_VRUploaded1(_SEI1, _MOI1, _SEI1)
#  Test patient: PT_VC12_VRUploaded2: vr uploaded PT_VC12_VRUploaded2(_SEI1, _MOI1, _SEI1)
    Given patient id is "<patient_id>"
    Then load template variant report confirm message for analysis id: "<ani>"
    Then set patient message field: "comment" to value: "<comment>"
    Then set patient message field: "comment_user" to value: "<user>"
    When PUT to MATCH variant report "<status>" service, response includes "changed successfully to" with code "200"
    Then patient should have variant report (analysis_id: "<ani>")
    And this variant report field: "status" should be "<status>ed"
    And this variant report field: "comment" should be "<comment>"
    And this variant report field: "comment_user" should be "<user>"
    And this variant report has correct status_date
    Examples:
      | patient_id          | ani                      | status  | comment                         | user  |
      | PT_VC12_VRUploaded1 | PT_VC12_VRUploaded1_ANI1 | confirm | a                               | user1 |
      | PT_VC12_VRUploaded2 | PT_VC12_VRUploaded2_ANI1 | reject  | this variant report is rejected | user2 |

  @patients_p2 @patients_queueless
  Scenario: PT_VC13. if variant report rejected, comment values for variants that are in this variant report should NOT BE cleared (this test has been changed, before the comments values should BE changed)
#    Test patient PT_VC13_VRUploaded1: vr uploaded   PT_VC13_VRUploaded1(_SEI1, _MOI1, _ANI1)
#    first snv variant has confirmed=false, comment="TEST"
    Given patient id is "PT_VC13_VRUploaded1"
    And a random variant for analysis id "PT_VC13_VRUploaded1_ANI1"
    And load template variant confirm message for this patient
    Then set patient message field: "comment" to value: "Tests"
    Then PUT to MATCH variant "unchecked" service for this uuid, response includes "changed to false" with code "200"
    And load template variant report confirm message for analysis id: "PT_VC13_VRUploaded1_ANI1"
    Then set patient message field: "comment" to value: "TEST"
    When PUT to MATCH variant report "reject" service, response includes "changed successfully to" with code "200"
    Then patient status should change to "TISSUE_VARIANT_REPORT_REJECTED"
    Then this variant should have confirmed field: "false" and comment field: "Tests"

  @patients_p2 @patients_queueless
  Scenario: PT_VC14. confirming blood variant report will not trigger patient assignment process
    Given patient id is "PT_VC14_BdTsVrUploadedAssayReady"
    Then load template variant report confirm message for analysis id: "PT_VC14_BdTsVrUploadedAssayReady_BD_ANI1"
    When PUT to MATCH variant report "confirm" service, response includes "success" with code "200"
    Then wait for "5" seconds
    Then patient status should change to "TISSUE_VARIANT_REPORT_RECEIVED"

  @patients_p2 @demo_p1 @patients_need_queue
  Scenario Outline: PT_VC15. variant file confirmation will or will not trigger assignment properly
    Given patient id is "<patient_id>"
    Then load template variant report confirm message for analysis id: "<ani>"
    When PUT to MATCH variant report "<vr_status>" service, response includes "changed successfully to" with code "200"
    Then wait for "5" seconds
    Then patient status should change to "<patient_status>"

    Examples:
      | patient_id                               | ani                                           | vr_status | patient_status                  |
      | PT_VC15_VrReceived                       | PT_VC15_VrReceived_ANI1                       | confirm   | TISSUE_VARIANT_REPORT_CONFIRMED |
      | PT_VC15_AssayReceivedVrReceivedToConfirm | PT_VC15_AssayReceivedVrReceivedToConfirm_ANI1 | confirm   | PENDING_CONFIRMATION            |
      | PT_VC15_AssayReceivedVrReceivedToReject  | PT_VC15_AssayReceivedVrReceivedToReject_ANI1  | reject    | TISSUE_VARIANT_REPORT_REJECTED  |
      | PT_VC15_PtenAndVrReceived                | PT_VC15_PtenAndVrReceived_ANI1                | confirm   | TISSUE_VARIANT_REPORT_CONFIRMED |
      | PT_VC15_Baf47AndVrReceived               | PT_VC15_Baf47AndVrReceived_ANI1               | confirm   | TISSUE_VARIANT_REPORT_CONFIRMED |
      | PT_VC15_Brg1AndVrReceived                | PT_VC15_Brg1AndVrReceived_ANI1                | confirm   | TISSUE_VARIANT_REPORT_CONFIRMED |
      | PT_VC15_PtenBaf47AndVrReceived           | PT_VC15_PtenBaf47AndVrReceived_ANI1           | confirm   | TISSUE_VARIANT_REPORT_CONFIRMED |
      | PT_VC15_PtenBrg1AndVrReceived            | PT_VC15_PtenBrg1AndVrReceived_ANI1            | confirm   | TISSUE_VARIANT_REPORT_CONFIRMED |
      | PT_VC15_Baf47Brg1AndVrReceived           | PT_VC15_Baf47Brg1AndVrReceived_ANI1           | confirm   | TISSUE_VARIANT_REPORT_CONFIRMED |
      | PT_VC15_3AssayRbVrReceived               | PT_VC15_3AssayRbVrReceived_ANI1               | confirm   | RB_ORDER_REQUESTED              |
      | PT_VC15_NoAssayRbVrReceived              | PT_VC15_NoAssayRbVrReceived_ANI1              | confirm   | RB_ORDER_REQUESTED              |
      | PT_VC15_3AssayRbVrReceivedRbUnchecked    | PT_VC15_3AssayRbVrReceivedRbUnchecked_ANI1    | confirm   | PENDING_CONFIRMATION            | new
      | PT_VC15_NoAssayRbVrReceivedRbUnchecked   | PT_VC15_NoAssayRbVrReceivedRbUnchecked_ANI1   | confirm   | TISSUE_VARIANT_REPORT_CONFIRMED |
          #there is no “PATHOLOGY_REVIEWED” status anymore
#      | PT_VC15_VRUploadedPathConfirmed          | PT_VC15_VRUploadedPathConfirmed_ANI1          | confirm   | TISSUE_VARIANT_REPORT_CONFIRMED |
#      | PT_VC15_VRUploadedAssayReceived          | PT_VC15_VRUploadedAssayReceived_ANI1          | confirm   | TISSUE_VARIANT_REPORT_CONFIRMED |
#      | PT_VC15_PathAssayDoneVRUploadedToConfirm | PT_VC15_PathAssayDoneVRUploadedToConfirm_ANI1 | confirm   | PENDING_CONFIRMATION            |
#      | PT_VC15_PathAssayDoneVRUploadedToReject  | PT_VC15_PathAssayDoneVRUploadedToReject_ANI1  | reject    | TISSUE_VARIANT_REPORT_REJECTED  |
#      | PT_VC15_PathDoneOneAssayVRUploaded       | PT_VC15_PathDoneOneAssayVRUploaded_ANI1       | confirm   | TISSUE_VARIANT_REPORT_CONFIRMED |

  @patients_p2 @patients_queueless
  Scenario Outline: PT_VC16. blood variant report can be confirmed when patient is in certain status
    Given patient id is "<patient_id>"
    Then load template variant report confirm message for analysis id: "<patient_id>_BD_ANI1"
    When PUT to MATCH variant report "confirm" service, response includes "<message>" with code "<code>"
    Examples:
      | patient_id                      | message   | code |
      | PT_VC16_BdVrTsReceived          | success   | 200  |
      | PT_VC16_BdVrTsShipped           | success   | 200  |
      | PT_VC16_BdVrSlideShipped        | success   | 200  |
      | PT_VC16_BdVrAssayReceived       | success   | 200  |
      | PT_VC16_BdVrTsVrReceived        | success   | 200  |
      | PT_VC16_BdVrTsVrConfirmed       | success   | 200  |
      | PT_VC16_BdVrTsVrRejected        | success   | 200  |
      | PT_VC16_BdVrPendingConfirmation | success   | 200  |
      | PT_VC16_BdVrPendingApproval     | success   | 200  |
      | PT_VC16_BdVrOnTreatmentArm      | success   | 200  |
      | PT_VC16_BdVrReqAssignment       | success   | 200  |
      | PT_VC16_BdVrNoTaAvailable       | success   | 200  |
      | PT_VC16_BdVrCompassionateCare   | success   | 200  |
      | PT_VC16_BdVrOffStudy            | OFF_STUDY | 403  |
