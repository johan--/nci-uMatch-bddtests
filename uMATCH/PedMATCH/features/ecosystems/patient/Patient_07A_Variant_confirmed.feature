#encoding: utf-8
@variant_confirm
Feature: Variant files confirmed messages
#  variant_confirmed:

  #no patient id in variant confirm service anymore
#  Scenario Outline: PT_VC00. variant confirm message with invalid patient_id should fail
#    Given template variant confirm message for patient: "<patient_id>", the variant: "uuid" is checked: "unchecked" with comment: "test"
#    When put to MATCH variant confirm service, returns a message that includes "<message>" with status "Failure"
#    Examples:
#      |patient_id     |message               |
##      |               |can't be blank        |
##      |null           |can't be blank        |
#      |nonPatient     |not been registered   |
  @patients_p2
  Scenario Outline: PT_VC01. variant confirm message with invalid variant_uuid should fail
    Given template variant confirm message for patient: "PT_VC01_VRUploaded", the variant: "<uuid>" is checked: "unchecked" with comment: "test"
    When put to MATCH variant confirm service, returns a message that includes "<message>" with status "Failure"
    Examples:
      | uuid              | message   |
  #    |                                 |can't be blank        |
  #    |null                             |can't be blank        |
      | non-existing_uuid | not exist |

  @patients_p2
  Scenario Outline: PT_VC02. variant confirm message with invalid confirmed should fail
    #    Test Patient: PT_VC02_VRUploaded, VR uploaded PT_VC02_VRUploaded(_SEI1, _MOI1, _ANI1)
    Given a random "fusion" variant in variant report (analysis_id: "PT_VC02_VRUploaded_ANI1") for patient: "PT_VC02_VRUploaded"
    Then create variant confirm message with checked: "<confirmed>" and comment: "Tests" for this variant
    When put to MATCH variant confirm service, returns a message that includes "<message>" with status "Failure"
    Examples:
      | confirmed                | message                                             |
#      |                                 |not of a minimum string length of 1                      |
#      |null                             |NilClass did not match the following type: string        |
      | not_checked_or_unchecked | Unregnized checked flag in variant confirmation url |

  @patients_p2
  Scenario: PT_VC03. variant_confirmed message will not be accepted if it is using a variant uuid that belongs to a rejected variant report (uuid should be only ones in current pending variant list)
#    Test Patient: PT_VC03_VRUploadedAfterRejected, VR rejected: PT_VC03_VRUploadedAfterRejected(_SEI1, _MOI1, _ANI1), VR uploaded PT_VC03_VRUploadedAfterRejected(_SEI1, _MOI1, _ANI2)
    Given a random "fusion" variant in variant report (analysis_id: "PT_VC03_VRUploadedAfterRejected_ANI1") for patient: "PT_VC03_VRUploadedAfterRejected"
    Then create variant confirm message with checked: "unchecked" and comment: "Tests" for this variant
    When put to MATCH variant confirm service, returns a message that includes "TBD" with status "Failure"

#  comment: should not be null or empty if confirmed is false --- DON'T test, this will be UI work

  @patients_p2
  Scenario: PT_VC04. when variant get confirmed again after it get un-confirmed, the comment value should be cleared
    #    Test Patient: PT_VC04_VRUploaded, VR uploaded PT_VC04_VRUploaded(_SEI1, _MOI1, _ANI1)
    Given a random "fusion" variant in variant report (analysis_id: "PT_VC04_VRUploaded_ANI1") for patient: "PT_VC04_VRUploaded"
    Then create variant confirm message with checked: "unchecked" and comment: "TEST" for this variant
    When put to MATCH variant confirm service, returns a message that includes "confirmed status changed to false" with status "Success"
    Then this variant has confirmed field: "false" and comment field: "TEST" within 15 seconds
    Then create variant confirm message with checked: "checked" and comment: "" for this variant
    When put to MATCH variant confirm service, returns a message that includes "confirmed status changed to true" with status "Success"
    Then this variant has confirmed field: "true" and comment field: "null" within 15 seconds

  @patients_p2
  Scenario: PT_VC04a. comment can be updated properly
    #Test patient: PT_VC04a_VRUploaded, PT_VC04a_VRUploaded(_SEI1, _MOI1, _ANI1)
    Given a random "fusion" variant in variant report (analysis_id: "PT_VC04a_VRUploaded_ANI1") for patient: "PT_VC04a_VRUploaded"
    Then create variant confirm message with checked: "unchecked" and comment: "TEST" for this variant
    When put to MATCH variant confirm service, returns a message that includes "confirmed status changed to false" with status "Success"
    Then create variant confirm message with checked: "unchecked" and comment: "COMMENT_EDITED" for this variant
    When put to MATCH variant confirm service, returns a message that includes "confirmed status changed to false" with status "Success"
    Then this variant has confirmed field: "false" and comment field: "COMMENT_EDITED" within 15 seconds

  @patients_p2
  Scenario: PT_VC05. confirmed fields should be "true" as default
    #    Test Patient: PT_VC05_TissueShipped, Tissue shipped PT_VC05_TissueShipped(_SEI1, _MOI1)
    Given template variant file uploaded message for patient: "PT_VC05_TissueShipped", it has molecular_id: "PT_VC05_TissueShipped_MOI1" and analysis_id: "PT_VC05_TissueShipped_ANI1" and need files in S3 Y or N: "Y"
    When post to MATCH patients service, returns a message that includes "processed successfully" with status "Success"
    Then variants in variant report (analysis_id: "PT_VC05_TissueShipped_ANI1") have confirmed: "true" within 15 seconds

  @patients_p2
  Scenario: PT_VC05a. all confirmed fields should be "false" after a new variant report get uploaded
    #    Test Patient: PT_VC05a_VRUploaded, VR uploaded PT_VC05a_VRUploaded(_SEI1, _MOI1, _ANI1)
    Given a random "fusion" variant in variant report (analysis_id: "PT_VC05a_VRUploaded_ANI1") for patient: "PT_VC05a_VRUploaded"
    Then create variant confirm message with checked: "unchecked" and comment: "TEST" for this variant
    When put to MATCH variant confirm service, returns a message that includes "confirmed status changed to false" with status "Success"
    Then template variant file uploaded message for patient: "PT_VC05a_VRUploaded", it has molecular_id: "PT_VC05a_VRUploaded_MOI1" and analysis_id: "PT_VC05a_VRUploaded_ANI2" and need files in S3 Y or N: "Y"
    When post to MATCH patients service, returns a message that includes "processed successfully" with status "Success"
    Then variants in variant report (analysis_id: "PT_VC05a_VRUploaded_ANI1") have confirmed: "false" within 15 seconds


## we don't have status_date in variant level
#  Scenario: PT_VC06. status_date can be generated correctly
#    #    Test Patient: PT_VC06_VRUploaded, VR uploaded SEI_01, MOI_01, ANI_01
#    Given retrieve patient: "PT_VC04_VRUploaded" from API
#    Then find the first "gf" variant in variant report which has surgical_event_id: "SEI_01", molecular_id: "MOI_01" and analysis_id: "ANI_01"
#    Then create variant confirm message with confirmed: "false" and comment: "TEST" for this variant
#    When post to MATCH patients service, returns a message that includes "TBD" with status "Success"
#    Then wait for "10" seconds
#    Then retrieve patient: "PT_VC04_VRUploaded" from API
#    Then this variant has correct status_date value

#  variant_file_confirmed:
  @patients_p2
  Scenario Outline: PT_VC06. variant report confirm message with invalid patient_id should fail
    Given template variant report confirm message for patient: "<value>", it has analysis_id: "ANI1" and status: "confirm"
    When put to MATCH variant report confirm service, returns a message that includes "<message>" with status "Failure"
    Examples:
      | value      | message             |
#      |               |can't be blank        |
#      |null           |can't be blank        |
      | nonPatient | not been registered |

#    molecular_id has been removed from this service
#  Scenario Outline: PT_VC08. variant report confirm message with invalid molecular_id should fail
#    Given template variant report confirm message for patient: "PT_VC08_VRUploaded", it has analysis_id: "PT_VC08_VRUploaded_ANI1" and status: "confirm"
#    When put to MATCH variant report confirm service, returns a message that includes "<message>" with status "Failure"
#    Examples:
#      |MOI            |message                    |
##      |               |can't be blank             |
##      |null           |can't be blank             |
#      |other          |Molecular id doesn't exist |

  @patients_p2
  Scenario Outline: PT_VC09. variant report confirm message with invalid analysis_id should fail
    Given template variant report confirm message for patient: "PT_VC09_VRUploaded", it has analysis_id: "<ANI>" and status: "confirm"
    When put to MATCH variant report confirm service, returns a message that includes "<message>" with status "Failure"
    Examples:
      | ANI   | message            |
#      |               |can't be blank             |
#      |null           |can't be blank             |
      | other | latest analysis id |

  @patients_p2
  Scenario Outline: PT_VC10. variant report confirm message using non-current ids should fail
##  Test patient: PT_VC10_VRUploadedSEIExpired: 1. PT_VC10_VRUploadedSEIExpired(_SEI1, _MOI1, _ANI1), 2. PT_VC10_VRUploadedSEIExpired(_SEI2, MOI2, _ANI2)
##  Test patient: PT_VC10_VRUploadedMOIExpired: 1. PT_VC10_VRUploadedMOIExpired(_SEI1, _MOI1, _ANI1), 2. PT_VC10_VRUploadedMOIExpired(_SEI1, MOI2, _ANI2)
##  Test patient: PT_VC10_VRUploadedANIExpired: 1. PT_VC10_VRUploadedANIExpired(_SEI1, _MOI1, _ANI1), 2. PT_VC10_VRUploadedANIExpired(_SEI1, MOI1, _ANI2)

    Given template variant report confirm message for patient: "<patient_id>", it has analysis_id: "<ani>" and status: "confirm"
    When put to MATCH variant report confirm service, returns a message that includes "doesn't match current specimen's latest analysis id" with status "Failure"
    Examples:
      | patient_id                   | ani                               |
      | PT_VC10_VRUploadedSEIExpired | PT_VC10_VRUploadedSEIExpired_ANI1 |
      | PT_VC10_VRUploadedMOIExpired | PT_VC10_VRUploadedMOIExpired_ANI1 |
      | PT_VC10_VRUploadedANIExpired | PT_VC10_VRUploadedANIExpired_ANI1 |

  @patients_p2
  Scenario Outline: PT_VC11. variant report confirm message with invalid status should fail
    Given template variant report confirm message for patient: "PT_VC11_VRUploaded", it has analysis_id: "PT_VC11_VRUploaded_ANI1" and status: "<status>"
    When put to MATCH variant report confirm service, returns a message that includes "<message>" with status "Failure"
    Examples:
      | status | message                                                                |
#      |               |can't be blank                                                                  |
#      |null           |can't be blank                                                                  |
      | other  | Unrecognized confirm\|reject flag passed in confirm variant report url |

  @patient_p2
  Scenario Outline: PT_VC11b. variant report cannot be confirmed (rejected) more than one time
    Given template variant report confirm message for patient: "<patient_id>", it has analysis_id: "<patient_id>_ANI1" and status: "<status>"
    When put to MATCH variant report confirm service, returns a message that includes "latest variant report is not in PENDING state" with status "Failure"
    Then patient should have variant report (analysis_id: "<patient_id>_ANI1") after 15 seconds
    And this variant report has value: "<previous_status>" in field: "status"
    Examples:
      | patient_id             | status  | previous_status |
      | PT_VC11b_TsVRConfirmed | confirm | confirm         |
      | PT_VC11b_TsVRRejected  | confirm | reject          |
      | PT_VC11b_TsVRConfirmed | reject  | confirm         |
      | PT_VC11b_TsVRRejected  | reject  | reject          |
    #we don't confirm or reject BLOOD variant report anymore
#      | PT_VC11b_BdVRConfirmed | confirm | confirm         |
#      | PT_VC11b_BdVRRejected  | confirm | reject          |
#      | PT_VC11b_BdVRConfirmed | reject  | confirm         |
#      | PT_VC11b_BdVRRejected  | reject  | reject          |


  @patients_p1
  Scenario Outline: PT_VC12. after accepting variant_file_confirmed message, patient should be set to correct status, comment, user and date
#  Test patient: PT_VC12_VRUploaded1: vr uploaded PT_VC12_VRUploaded1(_SEI1, _MOI1, _SEI1)
#  Test patient: PT_VC12_VRUploaded2: vr uploaded PT_VC12_VRUploaded2(_SEI1, _MOI1, _SEI1)
    Given template variant report confirm message for patient: "<patient_id>", it has analysis_id: "<ani>" and status: "<status>"
    Then set patient message field: "comment" to value: "<comment>"
    Then set patient message field: "comment_user" to value: "<user>"
    When put to MATCH variant report confirm service, returns a message that includes "Variant Report status changed successfully to" with status "Success"
    Then patient should have variant report (analysis_id: "<ani>") within 15 seconds
    And this variant report has value: "<status>" in field: "status"
    And this variant report has value: "<comment>" in field: "comment"
    And this variant report has value: "<user>" in field: "comment_user"
    And this variant report has correct status_date
    Examples:
      | patient_id          | ani                      | status  | comment                         | user  |
      | PT_VC12_VRUploaded1 | PT_VC12_VRUploaded1_ANI1 | confirm | a                               | user1 |
      | PT_VC12_VRUploaded2 | PT_VC12_VRUploaded2_ANI1 | reject  | this variant report is rejected | user2 |

  @patients_p2
  Scenario: PT_VC13. if variant report rejected, comment values for variants that are in this variant report should NOT BE cleared (this test has been changed, before the comments values should BE changed)
#    Test patient PT_VC13_VRUploaded1: vr uploaded   PT_VC13_VRUploaded1(_SEI1, _MOI1, _SEI1)
#    first snv variant has confirmed=false, comment="TEST"
    Given a random "fusion" variant in variant report (analysis_id: "PT_VC13_VRUploaded1_ANI1") for patient: "PT_VC13_VRUploaded1"
    Then create variant confirm message with checked: "unchecked" and comment: "Tests" for this variant
    When put to MATCH variant confirm service, returns a message that includes "confirmed status changed to false" with status "Success"
    Then template variant report confirm message for patient: "PT_VC13_VRUploaded1", it has analysis_id: "PT_VC13_VRUploaded1_ANI1" and status: "reject"
    Then set patient message field: "comment" to value: "TEST"
    When put to MATCH variant report confirm service, returns a message that includes "Variant Report status changed successfully to" with status "Success"
    Then patient field: "current_status" should have value: "TISSUE_VARIANT_REPORT_REJECTED" within 15 seconds
    Then this variant has confirmed field: "false" and comment field: "Tests" within 15 seconds

    #we don't confirm or reject BLOOD variant report anymore
#  Scenario: PT_VC14. confirming blood variant report will not trigger patient assignment process
#  #Test patient PT_VC14_BdVRUploadedTsVRUploadedOtherReady assay and pathology are ready,
#  #tissue PT_VC14_BdVRUploadedTsVRUploadedOtherReady(_SEI1, _MOI1, _ANI1) and blood(_BD_MOI1, _ANI2) variant report are uploaded
#    Given template variant report confirm message for patient: "PT_VC14_BdVRUploadedTsVRUploadedOtherReady", it has analysis_id: "PT_VC14_BdVRUploadedTsVRUploadedOtherReady_ANI2" and status: "confirm"
#    When put to MATCH variant report confirm service, returns a message that includes "Variant Report status changed successfully to" with status "Success"
#    Then patient field: "current_status" should have value: "BLOOD_VARIANT_REPORT_CONFIRMED" after 30 seconds

  @patients_p2
  Scenario Outline: PT_VC15. variant file confirmation will not trigger patient assignment process unless patient has two types of assay ready
    Given template variant report confirm message for patient: "<patient_id>", it has analysis_id: "<ani>" and status: "<vr_status>"
    When put to MATCH variant report confirm service, returns a message that includes "Variant Report status changed successfully to" with status "Success"
    Then patient field: "current_status" should have value: "<patient_status>" after 45 seconds

    Examples:
      | patient_id                               | ani                                           | vr_status | patient_status                  |
      | PT_VC15_VrReceived                       | PT_VC15_VrReceived_ANI1                       | confirm   | TISSUE_VARIANT_REPORT_CONFIRMED |
      | PT_VC15_AssayReceivedVrReceivedToConfirm | PT_VC15_AssayReceivedVrReceivedToConfirm_ANI1 | confirm   | PENDING_CONFIRMATION            |
      | PT_VC15_AssayReceivedVrReceivedToReject  | PT_VC15_AssayReceivedVrReceivedToReject_ANI1  | reject    | TISSUE_VARIANT_REPORT_REJECTED  |
      | PT_VC15_OneAssayAndVrReceived            | PT_VC15_OneAssayAndVrReceived_ANI1            | confirm   | TISSUE_VARIANT_REPORT_CONFIRMED |
          #there is no “PATHOLOGY_REVIEWED” status anymore
#      | PT_VC15_VRUploadedPathConfirmed          | PT_VC15_VRUploadedPathConfirmed_ANI1          | confirm   | TISSUE_VARIANT_REPORT_CONFIRMED |
#      | PT_VC15_VRUploadedAssayReceived          | PT_VC15_VRUploadedAssayReceived_ANI1          | confirm   | TISSUE_VARIANT_REPORT_CONFIRMED |
#      | PT_VC15_PathAssayDoneVRUploadedToConfirm | PT_VC15_PathAssayDoneVRUploadedToConfirm_ANI1 | confirm   | PENDING_CONFIRMATION            |
#      | PT_VC15_PathAssayDoneVRUploadedToReject  | PT_VC15_PathAssayDoneVRUploadedToReject_ANI1  | reject    | TISSUE_VARIANT_REPORT_REJECTED  |
#      | PT_VC15_PathDoneOneAssayVRUploaded       | PT_VC15_PathDoneOneAssayVRUploaded_ANI1       | confirm   | TISSUE_VARIANT_REPORT_CONFIRMED |