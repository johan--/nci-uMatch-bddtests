#encoding: utf-8
@patients @variant_confirm
Feature: Variant files confirmed messages
#  variant_confirmed:
  Scenario Outline: PT_VC01. variant confirm message with invalid variant_uuid should fail
    Given template variant confirm message for variant: "<uuid>", it is confirmed: "true" with comment: "no comment"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
    |uuid                             |message                                                  |
    |                                 |not of a minimum string length of 1                      |
    |null                             |NilClass did not match the following type: string        |
    |non-existing_uuid                |not exist                                                |
  Scenario Outline: PT_VC02. variant confirm message with invalid confirmed should fail
    #    Test Patient: PT_VC02_VRUploaded, VR uploaded SEI_01, MOI_01, ANI_01
    Given retrieve patient: "PT_VC02_VRUploaded" from API
    Then find the first "snv_id" variant in variant report which has surgical_event_id: "SEI_01", molecular_id: "MOI_01" and analysis_id: "ANI_01"
    Then create variant confirm message with confirmed: "<confirmed>" and comment: "Tests" for this variant
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |confirmed                        |message                                                  |
      |                                 |not of a minimum string length of 1                      |
      |null                             |NilClass did not match the following type: string        |
      |not_true_or_false                |not exist                                                |

  Scenario: PT_VC03. variant_confirmed message will not be accepted if it is using a variant uuid that belongs to a rejected variant report (uuid should be only ones in current pending variant list)
#    Test Patient: PT_VC03_VRUploadedAfterRejected, VR rejected: SEI_01, MOI_01, ANI_01, VR uploaded SEI_01, MOI_01, ANI_02
    Given retrieve patient: "PT_VC03_VRUploadedAfterRejected" from API
    Then find the first "snv_id" variant in variant report which has surgical_event_id: "SEI_01", molecular_id: "MOI_01" and analysis_id: "ANI_01"
    Then create variant confirm message with confirmed: "false" and comment: "Tests" for this variant
    When posted to MATCH patient trigger service, returns a message that includes "TBD" with status "Failure"

#  comment: should not be null or empty if confirmed is false --- DON'T test, this will be UI work


  Scenario: PT_VC04. when variant get confirmed again after it get un-confirmed, the comment value should be cleared
    #    Test Patient: PT_VC04_VRUploaded, VR uploaded SEI_01, MOI_01, ANI_01
    Given retrieve patient: "PT_VC04_VRUploaded" from API
    Then find the first "snv_id" variant in variant report which has surgical_event_id: "SEI_01", molecular_id: "MOI_01" and analysis_id: "ANI_01"
    Then create variant confirm message with confirmed: "false" and comment: "TEST" for this variant
    When posted to MATCH patient trigger service, returns a message that includes "TBD" with status "Success"
    Then wait for "10" seconds
    Then retrieve patient: "PT_VC04_VRUploaded" from API
    Then this variant has confirmed field: "false" and comment field: "TEST"
    Then create variant confirm message with confirmed: "true" and comment: "" for this variant
    When posted to MATCH patient trigger service, returns a message that includes "TBD" with status "Success"
    Then wait for "10" seconds
    Then retrieve patient: "PT_VC04_VRUploaded" from API
    Then this variant has confirmed field: "true" and comment field: ""


  Scenario: PT_VC05. confirmed fields should be "true" as default
    #    Test Patient: PT_VC05_VRUploaded, VR uploaded SEI_01, MOI_01, ANI_01
    Given retrieve patient: "PT_VC05_VRUploaded" from API
    Then variants in variant report (surgical_event_id: "SEI_01", molecular_id: "MOI_01", analysis_id: "ANI_01") has confirmed: "true"


## we don't have status_date in variant level
#  Scenario: PT_VC06. status_date can be generated correctly
#    #    Test Patient: PT_VC06_VRUploaded, VR uploaded SEI_01, MOI_01, ANI_01
#    Given retrieve patient: "PT_VC04_VRUploaded" from API
#    Then find the first "gf" variant in variant report which has surgical_event_id: "SEI_01", molecular_id: "MOI_01" and analysis_id: "ANI_01"
#    Then create variant confirm message with confirmed: "false" and comment: "TEST" for this variant
#    When posted to MATCH patient trigger service, returns a message that includes "TBD" with status "Success"
#    Then wait for "10" seconds
#    Then retrieve patient: "PT_VC04_VRUploaded" from API
#    Then this variant has correct status_date value

#  variant_file_confirmed:
  Scenario Outline: PT_VC06. variant report confirm message with invalid patient_id should fail
    Given template variant report confirm message for patient: "<value>", it has molecular_id: "MOI_01", analysis_id: "ANI_01" and status: "CONFIRMED"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |value          |message                                                  |
      |               |not of a minimum string length of 1                      |
      |null           |NilClass did not match the following type: string        |
      |nonPatient     |not exist                                                |

#    surgical_event_id has been removed from variant report confirm message
#  Scenario Outline: PT_VC07. variant report confirm message with invalid surgical_event_id should fail
#    Given template variant report confirm message for patient: "PT_VC07_VRUploaded", it has molecular_id: "MOI_01", analysis_id: "ANI_01" and status: "CONFIRMED"
#    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
#    Examples:
#      |SEI            |message                                                  |
#      |               |empty string                                             |
#      |null           |NilClass did not match the following type: string        |
#      |other          |not exist                                                |

  Scenario Outline: PT_VC08. variant report confirm message with invalid molecular_id should fail
    Given template variant report confirm message for patient: "PT_VC08_VRUploaded", it has molecular_id: "<MOI>", analysis_id: "ANI_01" and status: "CONFIRMED"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |MOI            |message                                                  |
      |               |not of a minimum string length of 1                      |
      |null           |NilClass did not match the following type: string        |
      |other          |not exist                                                |

  Scenario Outline: PT_VC09. variant report confirm message with invalid analysis_id should fail
    Given template variant report confirm message for patient: "PT_VC09_VRUploaded", it has molecular_id: "MOI_01", analysis_id: "<ANI>" and status: "CONFIRMED"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |ANI            |message                                                  |
      |               |not of a minimum string length of 1                      |
      |null           |NilClass did not match the following type: string        |
      |other          |not exist                                                |
# data cannot be prepared
#  Scenario Outline: PT_VC10. variant report confirm message using non-current specimen should fail
###  Test patient: PT_VC10_VRUploaded_DiffSEI_DiffMOI: surgical_event_id: SEI_01, molecular_id: MOI_01, analysis_id: ANI_01 vr uploaded;
###                                                    surgical_event_id: SEI_02, molecular_id: MOI_02, analysis_id: ANI_02 vr uploaded;
###  Test patient: PT_VC10_VRUploaded_DiffSEI_SameMOI: surgical_event_id: SEI_01, molecular_id: MOI_01, analysis_id: ANI_01 vr uploaded;
###                                                    surgical_event_id: SEI_02, molecular_id: MOI_01, analysis_id: ANI_01 vr uploaded;
#
#    Given template variant report confirm message for patient: "PT_VC10_VRUploaded", it has molecular_id: "MOI_01", analysis_id: "ANI_01" and status: "CONFIRMED"
#    When posted to MATCH patient trigger service, returns a message that includes "TBD" with status "Failure"
#    Examples:
#    |patient_id                           |
#    |PT_VC10_VRUploaded_DiffSEI_DiffMOI   |
#    |PT_VC10_VRUploaded_DiffSEI_SameMOI   |

  Scenario Outline: PT_VC11. variant report confirm message with invalid status should fail
    Given template variant report confirm message for patient: "PT_VC11_VRUploaded", it has molecular_id: "MOI_01", analysis_id: "ANI_01" and status: "<status>"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |status         |message                                                  |
      |               |not of a minimum string length of 1                      |
      |null           |NilClass did not match the following type: string        |
      |other          |not exist                                                |

  Scenario Outline: PT_VC12. after accepting variant_file_confirmed message, patient should be set to correct status, comment, user and date
#  Test patient: PT_VC12_VRUploaded_1: surgical_event_id: SEI_01, molecular_id: MOI_01, analysis_id: ANI_01 vr uploaded, to be confirmed
#  Test patient: PT_VC12_VRUploaded_2: surgical_event_id: SEI_01, molecular_id: MOI_01, analysis_id: ANI_02 vr uploaded, to be rejected
    Given template variant report confirm message for patient: "<patient_id>", it has molecular_id: "<moi>", analysis_id: "<ani>" and status: "<status>"
    Then set patient message field: "comment" to value: "<comment>"
    Then set patient message field: "comment_user" to value: "<user>"
    When posted to MATCH patient trigger service, returns a message that includes "TBD" with status "Success"
    Then retrieve patient: "<patient_id>" from API
    Then returned patient has variant report (surgical_event_id: "<sei>", molecular_id: "<moi>", analysis_id: "<ani>")
    And this variant report has value: "<status>" in field: "status"
    And this variant report has value: "<comment>" in field: "comment"
    And this variant report has value: "<user>" in field: "comment_user"
    And this variant report has correct status_date
    Examples:
    |patient_id            |sei      |moi      |ani      |status     |comment                          |user         |
    |PT_VC12_VRUploaded_1  |SEI_01   |MOI_01   |ANI_01   |CONFIRMED  |                                 |user1        |
    |PT_VC12_VRUploaded_2  |SEI_01   |MOI_01   |ANI_02   |REJECTED   |this variant report is rejected  |user2        |

  Scenario: PT_VC13. if variant report rejected, comment values for variants that are in this variant report should be cleared
#    Test patient PT_VC13_VRUploaded: surgical_event_id: SEI_01, molecular_id: MOI_01, analysis_id: ANI_01 vr uploaded
#    first snv variant has confirmed=false, comment="TEST"
    Given retrieve patient: "PT_VC13_VRUploaded" from API
    Then find the first "snv_id" variant in variant report which has surgical_event_id: "SEI_01", molecular_id: "MOI_01" and analysis_id: "ANI_01"
    Then create variant confirm message with confirmed: "false" and comment: "Tests" for this variant
    When posted to MATCH patient trigger service, returns a message that includes "TBD" with status "Success"
    Then template variant report confirm message for patient: "PT_VC13_VRUploaded", it has molecular_id: "MOI_01", analysis_id: "ANI_01" and status: "REJECTED"
    Then set patient message field: "comment" to value: "TEST"
    When posted to MATCH patient trigger service, returns a message that includes "TBD" with status "Success"
    Then retrieve patient: "PT_VC13_VRUploaded" from API
    Then find the first "snv_id" variant in variant report which has surgical_event_id: "SEI_01", molecular_id: "MOI_01" and analysis_id: "ANI_01"
    Then this variant has confirmed field: "false" and comment field: ""
    
  Scenario: PT_VC14. confirming blood variant report will not trigger patient assignment process
  #Test patient PT_VC14_BdVRUploadedTsVRUploadedOtherReady assay and pathology are ready,
  #tissue(MOI_TR_01, ANI_TR_01) and blood(MOI_BR_01, ANI_BR_01) variant report are uploaded
    Given template variant report confirm message for patient: "PT_VC14_BdVRUploadedTsVRUploadedOtherReady", it has molecular_id: "MOI_BR_01", analysis_id: "ANI_BR_01" and status: "CONFIRMED"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "20" seconds
    Then retrieve patient: "PT_VC14_BdVRUploadedTsVRUploadedOtherReady" from API
    Then returned patient has value: "BLOOD_VARIANT_REPORT_RECEIVED" in field: "status"

#  Data not ready yet
#  Scenario Outline: PT_VC15. variant file confirmation will not trigger patient assignment process unless patient has COMPLETE_MDA_DATA_SET status
#  #Test patient PT_VC15_AssayNotDone VR uploaded (SEI_01, MOI_01, ANI_01), Pathology confirmed (SEI_01), Assay result is not received yet
#  #             PT_VC15_PathologyNotDone VR uploaded (SEI_01, MOI_01, ANI_01), Assay result received (SEI_01), Pathology is not confirmed yet
#  #             PT_VC15_MDADataDonePlanToConfirm VR uploaded (SEI_01, MOI_01, ANI_01), Assay result received (SEI_01), Pathology is confirmed (SEI_01)
#  #             PT_VC15_MDADataDonePlanToReject VR uploaded (SEI_01, MOI_01, ANI_01), Assay result received (SEI_01), Pathology is confirmed (SEI_01)
#    Given template variant report confirm message for patient: "<patient_id>", it has molecular_id: "MOI_01", analysis_id: "ANI_01" and status: "<vr_status>"
#    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"
#    Then wait for "20" seconds
#    Then retrieve patient: "<patient_id>" from API
#    Then returned patient has value: "<patient_status>" in field: "status"
#    Examples:
#    |patient_id                           |vr_status    |patient_status                     |
##    |PT_VC15_AssayNotDone                 |CONFIRMED    |TISSUE_VARIANT_REPORT_CONFIRMED    |
##    |PT_VC15_PathologyNotDone             |CONFIRMED    |TISSUE_VARIANT_REPORT_CONFIRMED    |
##    |PT_VC15_MDADataDonePlanToConfirm     |CONFIRMED    |PENDING_CONFIRMATION               |
##    |PT_VC15_MDADataDonePlanToReject      |REJECTED     |TISSUE_VARIANT_REPORT_REJECTED     |


#  cannot confirm blood variant file using previous molecular_id (confirmed)
#  blood variant file can be confirmed when when patient is in next step number (from 1.0 to 2.0)
