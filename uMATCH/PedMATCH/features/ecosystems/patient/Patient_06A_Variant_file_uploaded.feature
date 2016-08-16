#encoding: utf-8
@patients @variant_file_uploaded
Feature: Variant files uploaded message
  Scenario Outline: PT_VU01. variant files uploaded message with invalid patient_id should fail
    Given template variant uploaded message for patient: "<value>", it has molecular_id: "MOI_01" and analysis_id: "ANI_01"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
    |value          |message                                                                            |
    |               |was not of a minimum string length of 1                                            |
    |null           |NilClass did not match the following type: string                                  |
    |nonPatient     |patient does not exist                                                             |

    #surgical_event_id has been removed from variant file upload message
#  Scenario Outline: PT_VU02. variant files uploaded message with invalid surgical_event_id should fail
#    Given template variant uploaded message for patient: "PT_VU02_TissueShipped", it has surgical_event_id: "<SEI>", molecular_id: "MOI_01" and analysis_id: "ANI_01"
#    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
#    Examples:
#      |SEI            |message                                                                            |
#      |               |was not of a minimum string length of 1                                            |
#      |null           |NilClass did not match the following type: string                                  |
#      |other          |cannot transition from 'TISSUE_NUCLEIC_ACID_SHIPPED'                               |

  Scenario Outline: PT_VU03. variant files uploaded message with invalid molecular_id should fail
    Given template variant uploaded message for patient: "PT_VU03_TissueShipped", it has molecular_id: "<MOI>" and analysis_id: "ANI_01"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |MOI            |message                                                                            |
      |               |was not of a minimum string length of 1                                            |
      |null           |NilClass did not match the following type: string                                  |
      |other          |cannot transition from 'TISSUE_NUCLEIC_ACID_SHIPPED'                               |

  Scenario Outline: PT_VU04. variant files uploaded message with invalid analysis_id should fail
    Given template variant uploaded message for patient: "PT_VU04_TissueShipped", it has molecular_id: "MOI_01" and analysis_id: "<ANI>"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |ANI            |message                                                                            |
      |               |was not of a minimum string length of 1                                            |
      |null           |NilClass did not match the following type: string                                  |
      |other          |cannot transition from 'TISSUE_NUCLEIC_ACID_SHIPPED'                               |

  Scenario: PT_VU05. variant files uploaded message using non-current specimen should fail
#  Test patient: PT_VU05_TissueShipped: surgical_event_id: SEI_01, molecular_id: MOI_01 tissue shipped;
#                                       surgical_event_id: SEI_02, molecular_id: MOI_02 tissue shipped;
  Given template variant uploaded message for patient: "PT_VU05_TissueShipped", it has molecular_id: "MOI_01" and analysis_id: "ANI_01"
  When posted to MATCH patient trigger service, returns a message that includes "TBD" with status "Failure"

  Scenario: PT_VU06. variant files uploaded message using new analysis_id can be accepted when patient has TISSUE_NUCLEIC_ACID_SHIPPED status
#  Test patient: PT_VU06_TissueShipped: surgical_event_id: SEI_01, molecular_id: MOI_01 tissue shipped;
    Given template variant uploaded message for patient: "PT_VU06_TissueShipped", it has molecular_id: "MOI_01" and analysis_id: "ANI_01"
    When posted to MATCH patient trigger service, returns a message that includes "TBD" with status "Success"


  Scenario: PT_VU07. variant files uploaded with new analysis_id cannot be accepted when patient has only TISSUE_SLIDE_SPECIMEN_SHIPPED status but has no TISSUE_NUCLEIC_ACID_SHIPPED status
#  Test patient: PT_VU07_SlideShippedNoTissueShipped: surgical_event_id: SEI_01 slide shipped, tissue not shipped;
    Given template variant uploaded message for patient: "PT_VU07_SlideShippedNoTissueShipped", it has molecular_id: "MOI_01" and analysis_id: "ANI_01"
    When posted to MATCH patient trigger service, returns a message that includes "cannot transition from 'TISSUE_SPECIMEN_RECEIVED'" with status "Failure"

  Scenario: PT_VU08. new uploaded variant files should has PENDING as default status
    Given template variant uploaded message for patient: "PT_VU08_TissueShipped", it has molecular_id: "MOI_01" and analysis_id: "ANI_01"
    When posted to MATCH patient trigger service, returns a message that includes "TBD" with status "Success"
    Then retrieve patient: "PT_VU08_TissueShipped" from API
    Then returned patient has variant report (surgical_event_id: "SEI_01", molecular_id: "MOI_01", analysis_id: "ANI_01")
    And this variant report has value: "PENDING" in field: "status"

  Scenario: PT_VU09. variant files uploaded with new analysis_id make all pending old files rejected
#    Test patient: PT_VU09_VariantReportUploaded; variant report files uploaded: surgical_event_id: SEI_01, molecular_id: MOI_01, analysis_id: ANI_01
#          Plan to uploaded surgical_event_id: SEI_01, molecular_id: MOI_01, analysis_id: ANI_02
    Given template variant uploaded message for patient: "PT_VU09_VariantReportUploaded", it has molecular_id: "MOI_01" and analysis_id: "ANI_02"
    When posted to MATCH patient trigger service, returns a message that includes "TBD" with status "Success"
    Then retrieve patient: "PT_VU09_VariantReportUploaded" from API
    Then returned patient has variant report (surgical_event_id: "SEI_01", molecular_id: "MOI_01", analysis_id: "ANI_02")
    And this variant report has value: "PENDING" in field: "status"
    Then returned patient has variant report (surgical_event_id: "SEI_01", molecular_id: "MOI_01", analysis_id: "ANI_01")
    And this variant report has value: "REJECTED" in field: "status"
#       For this scenario:
#         SEI_1 MOI_1 shipped->SEI_1 MOI_1 AID_1 uploaded->SEI_1 MOI_1 AID_1 V_UUID_1 confirmed->SEI_2 received->SEI_2 MOI_1 shipped->SEI_2 MOI_1 AID_1 uploaded ==> SEI_1 MOI_1 AID_1 rejected
#         it's covered by specimen received tests, please check PT_SR14 and PT_SR15.
#
  Scenario: PT_VU10. variant files uploaded with same analysis_id cannot be accepted when patient has TISSUE_VARIANT_REPORT_RECEIVED status
#    Test patient: PT_VU10_VariantReportUploaded; VR uploaded: SEI_01, MOI_01, ANI_01, is PENDING
#      Plan to use SEI_01, MOI_01, ANI_01 again
    Given template variant uploaded message for patient: "PT_VU10_VariantReportUploaded", it has molecular_id: "MOI_01" and analysis_id: "ANI_01"
    When posted to MATCH patient trigger service, returns a message that includes "TBD" with status "Failure"
    
  Scenario: PT_VU11. variant files uploaded with new analysis_id can be accepted when patient has TISSUE_VARIANT_REPORT_REJECTED status
#    Test patient: PT_VU11_VariantReportRejected; VR rejected: SEI_01, MOI_01, ANI_01
#      Plan to use SEI_01, MOI_01, ANI_02
    Given template variant uploaded message for patient: "PT_VU11_VariantReportRejected", it has molecular_id: "MOI_01" and analysis_id: "ANI_02"
    When posted to MATCH patient trigger service, returns a message that includes "TBD" with status "Success"

  Scenario Outline: PT_VU12. variant files uploaded with existing(including the one just get rejected) analysis_id cannot be accepted when patient has TISSUE_VARIANT_REPORT_REJECTED status
#    Test patient: PT_VU12_VariantReportRejected; VR rejected: SEI_01, MOI_01, ANI_01, VR rejected SEI_01, MOI_01, ANI_02
#      Plan to use SEI_01, MOI_01, ANI_01 again
    Given template variant uploaded message for patient: "PT_VU12_VariantReportRejected", it has molecular_id: "<moi>" and analysis_id: "<ani>"
    When posted to MATCH patient trigger service, returns a message that includes "TBD" with status "Success"
    Examples:
      |moi                |ani                |
      |MOI_01             |ANI_01             |
      |MOI_01             |ANI_02             |

  Scenario: PT_VU13. variant files uploaded will not be accepted after a patient has TISSUE_VARIANT_REPORT_CONFIRMED status
  #    Test patient: PT_VU13_VariantReportConfirmed; VR confirmed SEI_01, MOI_01, ANI_01
    Given template variant uploaded message for patient: "PT_VU13_VariantReportConfirmed", it has molecular_id: "MOI_01" and analysis_id: "ANI_01"
    When posted to MATCH patient trigger service, returns a message that includes "TBD" with status "Failure"

  Scenario: PT_VU14. variant file uploaded to blood specimen should has correct result
#    Test patient: PT_VU14_TissueAndBloodShipped; Tissue shipped: SEI_01, MOI_TR_01; Blood shipped: MOI_BR_01
    Given template variant uploaded message for patient: "PT_VU14_TissueAndBloodShipped", it has molecular_id: "MOI_BR_01" and analysis_id: "ANI_BR_01"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "15" seconds
    Then retrieve patient: "PT_VU14_TissueAndBloodShipped" from API
    Then returned patient has variant report (surgical_event_id: "null", molecular_id: "MOI_BR_01", analysis_id: "ANI_BR_01")
    And this variant report has value: "type" in field: "BLOOD"

  Scenario: PT_VU15. tissue variant file uploaded should generate variants for latest surgical event (not older one which use the same molecular_id)
#    Test patient: PT_VU15_TissueReceivedAndShippedTwice: Tissue shipped: SEI_01, MOI_01, and SEI_02, MOI_01
    Given template variant uploaded message for patient: "PT_VU15_TissueReceivedAndShippedTwice", it has molecular_id: "MOI_01" and analysis_id: "ANI_01"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "15" seconds
    Then retrieve patient: "PT_VU15_TissueReceivedAndShippedTwice" from API
    Then returned patient has variant report (surgical_event_id: "SEI_01", molecular_id: "MOI_01", analysis_id: "ANI_01")

  Scenario: PT_VU16. blood variant files uploaded with new analysis_id make all pending old files rejected
#    Test patient: PT_VU16_BdVRUploaded; variant report files uploaded: molecular_id: MOI_BR_01, analysis_id: ANI_BR_01
#          Plan to uploaded molecular_id: MOI_BR_01, analysis_id: ANI_BR_02
    Given template variant uploaded message for patient: "PT_VU16_BdVRUploaded", it has molecular_id: "MOI_BR_01" and analysis_id: "ANI_BR_02"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then retrieve patient: "PT_VU16_BdVRUploaded" from API
    Then returned patient has variant report (surgical_event_id: "null", molecular_id: "MOI_BR_01", analysis_id: "ANI_BR_02")
    And this variant report has value: "PENDING" in field: "status"
    Then returned patient has variant report (surgical_event_id: "null", molecular_id: "MOI_BR_01", analysis_id: "ANI_BR_01")
    And this variant report has value: "REJECTED" in field: "status"
#  variants should be generated properly in patient json after variant files uploaded message is accepted
#      run rule service using the variant tsv file, a variant list will be output, then run variant files uploaded message, then retrieve patient, check it's variant part with the list comes from rule engin

#  cannot upload blood variant file using previous molecular_id (confirmed)
#  blood variant file can be uploaded when when patient is in next step number (from 1.0 to 2.0)
