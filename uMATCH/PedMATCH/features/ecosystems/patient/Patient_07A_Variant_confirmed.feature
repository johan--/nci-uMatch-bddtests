#encoding: utf-8
@patients_not_implemented
Feature: Variant files confirmed messages
#  BLOOD is not considered and implemented yet
#  variant_confirmed:
  Scenario Outline: PT_VC01. variant confirm message with invalid variant_uuid should fail
    Given template variant confirm message for variant: "<uuid>", it is confirmed: "true" with comment: "no comment"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
    |uuid                             |message                                                  |
    |                                 |                                                         |
    |null                             |                                                         |
    |non-existing_uuid                |                                                         |
  Scenario Outline: PT_VC02. variant confirm message with invalid confirmed should fail
    #    Test Patient: PT_VC02_VRUploaded, VR uploaded SEI_01, MOI_01, ANI_01
    Given retrieve patient: "PT_VC02_VRUploaded" from API
    Then find the first "snv_id" variant in variant report which has surgical_event_id: "SEI_01", molecular_id: "MOI_01" and analysis_id: "ANI_01"
    Then create variant confirm message with confirmed: "<confirmed>" and comment: "Tests" for this variant
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |confirmed                        |message                                                  |
      |                                 |                                                         |
      |null                             |                                                         |
      |not_true_or_false                |                                                         |

  Scenario: PT_VC03. variant_confirmed message will not be accepted if it is using a variant uuid that belongs to a rejected variant report (uuid should be only ones in current pending variant list)
#    Test Patient: PT_VC03_VRUploadedAfterRejected, VR rejected: SEI_01, MOI_01, ANI_01, VR uploaded SEI_01, MOI_01, ANI_02
    Given retrieve patient: "PT_VC03_VRUploadedAfterRejected" from API
    Then find the first "gf" variant in variant report which has surgical_event_id: "SEI_01", molecular_id: "MOI_01" and analysis_id: "ANI_01"
    Then create variant confirm message with confirmed: "false" and comment: "Tests" for this variant
    When posted to MATCH patient trigger service, returns a message that includes "TBD" with status "Failure"

#  comment: should not be null or empty if confirmed is false --- DON'T test, this will be UI work


  Scenario: PT_VC04. when variant get confirmed again after it get un-confirmed, the comment value should be cleared
    #    Test Patient: PT_VC04_VRUploaded, VR uploaded SEI_01, MOI_01, ANI_01
    Given retrieve patient: "PT_VC04_VRUploaded" from API
    Then find the first "cnv" variant in variant report which has surgical_event_id: "SEI_01", molecular_id: "MOI_01" and analysis_id: "ANI_01"
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
    #    Test Patient: PT_VC04_VRUploaded, VR uploaded SEI_01, MOI_01, ANI_01
    Given retrieve patient: "PT_VC04_VRUploaded" from API
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
    Given template variant report confirm message for patient: "<value>", it has surgical_event_id: "SEI_01", molecular_id: "MOI_01", analysis_id: "ANI_01" and status: "CONFIRMED"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |value          |message                                                                            |
      |               |                                                                                   |
      |null           |                                                                                   |
      |nonPatient     |                                                                                   |

  Scenario Outline: PT_VC07. variant report confirm message with invalid surgical_event_id should fail
    Given template variant report confirm message for patient: "PT_VC07_VariantReportUploaded", it has surgical_event_id: "<SEI>", molecular_id: "MOI_01", analysis_id: "ANI_01" and status: "CONFIRMED"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |SEI            |message                                                                            |
      |               |                                                                                   |
      |null           |                                                                                   |
      |other          |                                                                                   |

  Scenario Outline: PT_VC08. variant report confirm message with invalid molecular_id should fail
    Given template variant report confirm message for patient: "PT_VC08_VariantReportUploaded", it has surgical_event_id: "SEI_01", molecular_id: "<MOI>", analysis_id: "ANI_01" and status: "CONFIRMED"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |MOI            |message                                                                            |
      |               |                                                                                   |
      |null           |                                                                                   |
      |other          |                                                                                   |

  Scenario Outline: PT_VC09. variant report confirm message with invalid analysis_id should fail
    Given template variant report confirm message for patient: "PT_VC09_VariantReportUploaded", it has surgical_event_id: "SEI_01", molecular_id: "MOI_01", analysis_id: "<ANI>" and status: "CONFIRMED"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |ANI            |message                                                                            |
      |               |                                                                                   |
      |null           |                                                                                   |
      |other          |                                                                                   |

  Scenario: PT_VC10. variant report confirm message using non-current specimen should fail
#  Test patient: PT_VC10_VariantReportUploaded: surgical_event_id: SEI_01, molecular_id: MOI_01 vr uploaded;
#                                               surgical_event_id: SEI_02, molecular_id: MOI_02 vr uploaded;
    Given template variant report confirm message for patient: "PT_VC10_VariantReportUploaded", it has surgical_event_id: "SEI_01", molecular_id: "MOI_01", analysis_id: "ANI_01" and status: "CONFIRMED"
    When posted to MATCH patient trigger service, returns a message that includes "TBD" with status "Failure"

  Scenario Outline: PT_VC11. variant report confirm message with invalid status should fail
    Given template variant report confirm message for patient: "PT_VC11_VariantReportUploaded", it has surgical_event_id: "SEI_01", molecular_id: "MOI_01", analysis_id: "ANI_01" and status: "<status>"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |status         |message                                                                            |
      |               |                                                                                   |
      |null           |                                                                                   |
      |other          |                                                                                   |

  Scenario Outline: PT_VC12. after accepting variant_file_confirmed message, patient should be set to correct status, comment, user and date
#  Test patient: PT_VC12_VariantReportUploaded_1: surgical_event_id: SEI_01, molecular_id: MOI_01, analysis_id: ANI_01 vr uploaded, to be confirmed
#  Test patient: PT_VC12_VariantReportUploaded_2: surgical_event_id: SEI_01, molecular_id: MOI_01, analysis_id: ANI_02 vr uploaded, to be rejected
    Given template variant report confirm message for patient: "<patient_id>", it has surgical_event_id: "<sei>", molecular_id: "<moi>", analysis_id: "<ani>" and status: "<status>"
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
    |patient_id                       |sei      |moi      |ani      |status     |comment                          |user         |
    |PT_VC12_VariantReportUploaded_1  |SEI_01   |MOI_01   |ANI_01   |CONFIRMED  |this variant report is confirmed |user1        |
    |PT_VC12_VariantReportUploaded_2  |SEI_01   |MOI_01   |ANI_02   |REJECTED   |this variant report is rejected  |user2        |

  Scenario: PT_VC13. if variant report rejected, comment values for variants that are in this variant report should be cleared
#    Test patient PT_VC13_VariantReportUploaded: surgical_event_id: SEI_01, molecular_id: MOI_01, analysis_id: ANI_01 vr uploaded
#    first snv variant has confirmed=false, comment="TEST"
    Given template variant report confirm message for patient: "PT_VC13_VariantReportUploaded", it has surgical_event_id: "SEI_01", molecular_id: "MOI_01", analysis_id: "ANI_01" and status: "REJECTED"
    When posted to MATCH patient trigger service, returns a message that includes "TBD" with status "Success"
    Then retrieve patient: "<patient_id>" from API
    Then find the first "snv_id" variant in variant report which has surgical_event_id: "SEI_01", molecular_id: "MOI_01" and analysis_id: "ANI_01"
    Then this variant has confirmed field: "false" and comment field: ""