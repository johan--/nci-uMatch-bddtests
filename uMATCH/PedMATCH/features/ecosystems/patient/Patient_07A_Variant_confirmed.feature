#encoding: utf-8
#@patients
@variant_confirm
Feature: Variant files confirmed messages
#  variant_confirmed:

  Scenario Outline: PT_VC00. variant confirm message with invalid patient_id should fail
    Given template variant confirm message for patient: "<patient_id>", the variant: "uuid" is confirmed: "false" with comment: "test"
    When post to MATCH variant confirm service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |patient_id     |message               |
      |               |can't be blank        |
      |null           |can't be blank        |
      |nonPatient     |not been registered   |

  Scenario Outline: PT_VC01. variant confirm message with invalid variant_uuid should fail
    Given template variant confirm message for patient: "PT_VC01_VRUploaded", the variant: "<uuid>" is confirmed: "false" with comment: "test"
    When post to MATCH variant confirm service, returns a message that includes "<message>" with status "Failure"
    Examples:
    |uuid                             |message               |
    |                                 |can't be blank        |
    |null                             |can't be blank        |
    |non-existing_uuid                |not exist             |

  Scenario Outline: PT_VC02. variant confirm message with invalid confirmed should fail
    #    Test Patient: PT_VC02_VRUploaded, VR uploaded PT_VC02_VRUploaded(_SEI1, _MOI1, _ANI1)
    Given retrieve patient: "PT_VC02_VRUploaded" from API
    Then find the first "snv_id" variant in variant report which has surgical_event_id: "PT_VC02_VRUploaded_SEI1", molecular_id: "PT_VC02_VRUploaded_MOI1" and analysis_id: "PT_VC02_VRUploaded_ANI1"
    Then create variant confirm message with confirmed: "<confirmed>" and comment: "Tests" for this variant
    When post to MATCH variant confirm service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |confirmed                        |message                                                  |
      |                                 |not of a minimum string length of 1                      |
      |null                             |NilClass did not match the following type: string        |
      |not_true_or_false                |not exist                                                |

  Scenario: PT_VC03. variant_confirmed message will not be accepted if it is using a variant uuid that belongs to a rejected variant report (uuid should be only ones in current pending variant list)
#    Test Patient: PT_VC03_VRUploadedAfterRejected, VR rejected: PT_VC03_VRUploadedAfterRejected(_SEI1, _MOI1, _ANI1), VR uploaded PT_VC03_VRUploadedAfterRejected(_SEI1, _MOI1, _ANI2)
    Given retrieve patient: "PT_VC03_VRUploadedAfterRejected" from API
    Then find the first "snv_id" variant in variant report which has surgical_event_id: "PT_VC03_VRUploadedAfterRejected_SEI1", molecular_id: "PT_VC03_VRUploadedAfterRejected_MOI1" and analysis_id: "PT_VC03_VRUploadedAfterRejected_ANI1"
    Then create variant confirm message with confirmed: "false" and comment: "Tests" for this variant
    When post to MATCH variant confirm service, returns a message that includes "TBD" with status "Failure"

#  comment: should not be null or empty if confirmed is false --- DON'T test, this will be UI work


  Scenario: PT_VC04. when variant get confirmed again after it get un-confirmed, the comment value should be cleared
    #    Test Patient: PT_VC04_VRUploaded, VR uploaded PT_VC04_VRUploaded(_SEI1, _MOI1, _ANI1)
    Given retrieve patient: "PT_VC04_VRUploaded" from API
    Then find the first "snv_id" variant in variant report which has surgical_event_id: "PT_VC04_VRUploaded_SEI1", molecular_id: "PT_VC04_VRUploaded_MOI1" and analysis_id: "PT_VC04_VRUploaded_ANI1"
    Then create variant confirm message with confirmed: "false" and comment: "TEST" for this variant
    When post to MATCH variant confirm service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "10" seconds
    Then retrieve patient: "PT_VC04_VRUploaded" from API
    Then this variant has confirmed field: "false" and comment field: "TEST"
    Then create variant confirm message with confirmed: "true" and comment: "" for this variant
    When post to MATCH variant confirm service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "10" seconds
    Then retrieve patient: "PT_VC04_VRUploaded" from API
    Then this variant has confirmed field: "true" and comment field: ""


  Scenario: PT_VC05. confirmed fields should be "true" as default
    #    Test Patient: PT_VC05_TissueShipped, Tissue shipped PT_VC05_TissueShipped(_SEI1, _MOI1)
    Given template variant uploaded message for patient: "PT_VC05_TissueShipped", it has molecular_id: "PT_VC05_TissueShipped_MOI1" and analysis_id: "PT_VC05_TissueShipped_ANI1"
    When post to MATCH variant confirm service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "15" seconds
    Then retrieve patient: "PT_VC05_VRUploaded" from API
    Then variants in variant report (surgical_event_id: "PT_VC05_TissueShipped_SEI1", molecular_id: "PT_VC05_TissueShipped_MOI1", analysis_id: "PT_VC05_TissueShipped_ANI1") have confirmed: "true"


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
  Scenario Outline: PT_VC06. variant report confirm message with invalid patient_id should fail
    Given template variant report confirm message for patient: "<value>", it has molecular_id: "MOI1", analysis_id: "ANI1" and status: "CONFIRMED"
    When post to MATCH variant report confirm service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |value          |message               |
      |               |can't be blank        |
      |null           |can't be blank        |
      |nonPatient     |not been registered   |

#    surgical_event_id has been removed from variant report confirm message
#  Scenario Outline: PT_VC07. variant report confirm message with invalid surgical_event_id should fail
#    Given template variant report confirm message for patient: "PT_VC07_VRUploaded", it has molecular_id: "MOI_01", analysis_id: "ANI_01" and status: "CONFIRMED"
#    When post to MATCH patients service, returns a message that includes "<message>" with status "Failure"
#    Examples:
#      |SEI            |message                                                  |
#      |               |empty string                                             |
#      |null           |NilClass did not match the following type: string        |
#      |other          |not exist                                                |

  Scenario Outline: PT_VC08. variant report confirm message with invalid molecular_id should fail
    Given template variant report confirm message for patient: "PT_VC08_VRUploaded", it has molecular_id: "<MOI>", analysis_id: "PT_VC08_VRUploaded_ANI1" and status: "CONFIRMED"
    When post to MATCH variant report confirm service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |MOI            |message                    |
      |               |can't be blank             |
      |null           |can't be blank             |
      |other          |Molecular id doesn't exist |

  Scenario Outline: PT_VC09. variant report confirm message with invalid analysis_id should fail
    Given template variant report confirm message for patient: "PT_VC09_VRUploaded", it has molecular_id: "PT_VC09_VRUploaded_MOI1", analysis_id: "<ANI>" and status: "CONFIRMED"
    When post to MATCH variant report confirm service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |ANI            |message                    |
      |               |can't be blank             |
      |null           |can't be blank             |
      |other          |Analysis id doesn't exist  |
# data not ready yet
  Scenario Outline: PT_VC10. variant report confirm message using non-current ids should fail
##  Test patient: PT_VC10_VRUploadedSEIExpired: 1. PT_VC10_VRUploadedSEIExpired(_SEI1, _MOI1, _ANI1), 2. PT_VC10_VRUploadedSEIExpired(_SEI2, MOI2, _ANI2)
##  Test patient: PT_VC10_VRUploadedMOIExpired: 1. PT_VC10_VRUploadedMOIExpired(_SEI1, _MOI1, _ANI1), 2. PT_VC10_VRUploadedMOIExpired(_SEI1, MOI2, _ANI2)
##  Test patient: PT_VC10_VRUploadedANIExpired: 1. PT_VC10_VRUploadedANIExpired(_SEI1, _MOI1, _ANI1), 2. PT_VC10_VRUploadedANIExpired(_SEI1, MOI1, _ANI2)

    Given template variant report confirm message for patient: "<patient_id>", it has molecular_id: "<moi>", analysis_id: "<ani>" and status: "CONFIRMED"
    When post to MATCH variant report confirm service, returns a message that includes "<message>" with status "Failure"
    Examples:
    |patient_id                     |moi                                |ani                                |message                                                  |
    |PT_VC10_VRUploadedSEIExpired   |PT_VC10_VRUploadedSEIExpired_MOI1  |PT_VC10_VRUploadedSEIExpired_ANI1  |TBD                                                      |
    |PT_VC10_VRUploadedMOIExpired   |PT_VC10_VRUploadedMOIExpired_MOI1  |PT_VC10_VRUploadedMOIExpired_ANI1  |TBD                                                      |
    |PT_VC10_VRUploadedANIExpired   |PT_VC10_VRUploadedANIExpired_MOI1  |PT_VC10_VRUploadedANIExpired_ANI1  |TBD                                                      |

  Scenario Outline: PT_VC11. variant report confirm message with invalid status should fail
    Given template variant report confirm message for patient: "PT_VC11_VRUploaded", it has molecular_id: "PT_VC11_VRUploaded_MOI1", analysis_id: "PT_VC11_VRUploaded_ANI1" and status: "<status>"
    When post to MATCH variant report confirm service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |status         |message               |
      |               |can't be blank        |
      |null           |can't be blank        |
      |other          |valid status          |

  Scenario Outline: PT_VC12. after accepting variant_file_confirmed message, patient should be set to correct status, comment, user and date
#  Test patient: PT_VC12_VRUploaded1: vr uploaded PT_VC12_VRUploaded1(_SEI1, _MOI1, _SEI1)
#  Test patient: PT_VC12_VRUploaded2: vr uploaded PT_VC12_VRUploaded2(_SEI1, _MOI1, _SEI1)
    Given template variant report confirm message for patient: "<patient_id>", it has molecular_id: "<moi>", analysis_id: "<ani>" and status: "<status>"
    Then set patient message field: "comment" to value: "<comment>"
    Then set patient message field: "comment_user" to value: "<user>"
    When post to MATCH variant report confirm service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then retrieve patient: "<patient_id>" from API
    Then returned patient has variant report (surgical_event_id: "<sei>", molecular_id: "<moi>", analysis_id: "<ani>")
    And this variant report has value: "<status>" in field: "status"
    And this variant report has value: "<comment>" in field: "comment"
    And this variant report has value: "<user>" in field: "comment_user"
    And this variant report has correct status_date
    Examples:
    |patient_id           |sei                        |moi                        |ani                        |status     |comment                          |user         |
    |PT_VC12_VRUploaded1  |PT_VC12_VRUploaded1_SEI1   |PT_VC12_VRUploaded1_MOI1   |PT_VC12_VRUploaded1_ANI1   |CONFIRMED  |                                 |user1        |
    |PT_VC12_VRUploaded2  |PT_VC12_VRUploaded2_SEI1   |PT_VC12_VRUploaded2_MOI1   |PT_VC12_VRUploaded2_ANI1   |REJECTED   |this variant report is rejected  |user2        |

  Scenario: PT_VC13. if variant report rejected, comment values for variants that are in this variant report should NOT BE cleared (this test has been changed, before the comments values should BE changed)
#    Test patient PT_VC13_VRUploaded: vr uploaded   PT_VC13_VRUploaded(_SEI1, _MOI1, _SEI1)
#    first snv variant has confirmed=false, comment="TEST"
    Given retrieve patient: "PT_VC13_VRUploaded" from API
    Then find the first "snv_id" variant in variant report which has surgical_event_id: "PT_VC13_VRUploaded_SEI1", molecular_id: "PT_VC13_VRUploaded_MOI1" and analysis_id: "PT_VC13_VRUploaded_ANI1"
    Then create variant confirm message with confirmed: "false" and comment: "Tests" for this variant
    When post to MATCH variant report confirm service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then template variant report confirm message for patient: "PT_VC13_VRUploaded", it has molecular_id: "PT_VC13_VRUploaded_MOI1", analysis_id: "PT_VC13_VRUploaded_ANI1" and status: "REJECTED"
    Then set patient message field: "comment" to value: "TEST"
    When post to MATCH variant report confirm service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then retrieve patient: "PT_VC13_VRUploaded" from API
    Then find the first "snv_id" variant in variant report which has surgical_event_id: "PT_VC13_VRUploaded_SEI1", molecular_id: "PT_VC13_VRUploaded_MOI1" and analysis_id: "PT_VC13_VRUploaded_ANI1"
    Then this variant has confirmed field: "false" and comment field: "Tests"
    
  Scenario: PT_VC14. confirming blood variant report will not trigger patient assignment process
  #Test patient PT_VC14_BdVRUploadedTsVRUploadedOtherReady assay and pathology are ready,
  #tissue PT_VC14_BdVRUploadedTsVRUploadedOtherReady(_SEI1, _MOI1, _ANI1) and blood(_BD_MOI1, _ANI2) variant report are uploaded
    Given template variant report confirm message for patient: "PT_VC14_BdVRUploadedTsVRUploadedOtherReady", it has molecular_id: "PT_VC14_BdVRUploadedTsVRUploadedOtherReady_BD_MOI1", analysis_id: "PT_VC14_BdVRUploadedTsVRUploadedOtherReady_ANI2" and status: "CONFIRMED"
    When post to MATCH variant report confirm service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "20" seconds
    Then retrieve patient: "PT_VC14_BdVRUploadedTsVRUploadedOtherReady" from API
    Then returned patient has value: "BLOOD_VARIANT_REPORT_CONFIRMED" in field: "current_status"

  Scenario Outline: PT_VC15. variant file confirmation will not trigger patient assignment process unless patient has COMPLETE_MDA_DATA_SET status
  #Test patient PT_VC15_VRUploadedPathConfirmed VR uploaded PT_VC15_VRUploadedPathConfirmed(_SEI1, _MOI1, _ANI1), Pathology confirmed (_SEI1), Assay result is not received yet
  #             PT_VC15_VRUploadedAssayReceived VR uploaded PT_VC15_VRUploadedAssayReceived(_SEI1, _MOI1, _ANI1), Assay result received (_SEI1, _BC1), Pathology is not confirmed yet
  #             PT_VC15_PathAssayDoneVRUploadedToConfirm VR uploaded PT_VC15_PathAssayDoneVRUploadedToConfirm(_SEI1, _MOI1, _ANI1), Assay result received (_SEI1, _BC1), Pathology is confirmed (_SEI1)
  #             PT_VC15_PathAssayDoneVRUploadedToReject VR uploaded PT_VC15_PathAssayDoneVRUploadedToReject(_SEI1, _MOI1, _ANI1), Assay result received (_SEI1, _BC1), Pathology is confirmed (_SEI1)
    Given template variant report confirm message for patient: "<patient_id>", it has molecular_id: "<moi>", analysis_id: "<ani>" and status: "<vr_status>"
    When post to MATCH variant report confirm service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "60" seconds
    Then retrieve patient: "<patient_id>" from API
    Then returned patient has value: "<patient_status>" in field: "current_status"
    Examples:
    |patient_id                               |moi                                            |ani                                            |vr_status    |patient_status                     |
    |PT_VC15_VRUploadedPathConfirmed          |PT_VC15_VRUploadedPathConfirmed_MOI1           |PT_VC15_VRUploadedPathConfirmed_ANI1           |CONFIRMED    |TISSUE_VARIANT_REPORT_CONFIRMED    |
    |PT_VC15_VRUploadedAssayReceived          |PT_VC15_VRUploadedAssayReceived_MOI1           |PT_VC15_VRUploadedAssayReceived_ANI1           |CONFIRMED    |TISSUE_VARIANT_REPORT_CONFIRMED    |
    |PT_VC15_PathAssayDoneVRUploadedToConfirm |PT_VC15_PathAssayDoneVRUploadedToConfirm_MOI1  |PT_VC15_PathAssayDoneVRUploadedToConfirm_ANI1  |CONFIRMED    |PENDING_CONFIRMATION               |
    |PT_VC15_PathAssayDoneVRUploadedToReject  |PT_VC15_PathAssayDoneVRUploadedToReject_MOI1   |PT_VC15_PathAssayDoneVRUploadedToReject_ANI1   |REJECTED     |TISSUE_VARIANT_REPORT_REJECTED     |

  Scenario: PT_VC16. patient can reach PENDING_CONFIRMATION status once all data ready, even there is mock service collapse in-between
  #Test patient PT_VC16_PathAssayDoneVRUploadedToConfirm VR uploaded PT_VC16_VRAssayPathoReady(_SEI1, _MOI1, _ANI1),
#                                         Pathology confirmed (_SEI1)
#                                         Assay result received (_SEI1, _BC1)
    Given patient: "PT_VC16_PathAssayDoneVRUploadedToConfirm" in mock service lost patient list, service will come back after "5" tries
#    Then template variant report confirm message for patient: "PT_VC16_VRAssayPathoReady", it has molecular_id: "PT_VC16_VRAssayPathoReady_MOI1", analysis_id: "PT_VC16_VRAssayPathoReady_ANI1" and status: "CONFIRMED"
    Then template variant report confirm message for patient: "PT_VC16_PathAssayDoneVRUploadedToConfirm", it has molecular_id: "PT_VC16_PathAssayDoneVRUploadedToConfirm_MOI1", analysis_id: "PT_VC16_PathAssayDoneVRUploadedToConfirm_ANI1" and status: "CONFIRMED"
    When post to MATCH variant report confirm service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "60" seconds
    Then retrieve patient: "PT_VC16_PathAssayDoneVRUploadedToConfirm" from API
    Then returned patient has value: "PENDING_CONFIRMATION" in field: "current_status"

#  cannot confirm blood variant file using previous molecular_id (confirmed)
#  blood variant file can be confirmed when when patient is in next step number (from 1.0 to 2.0)
