#encoding: utf-8
@patients @variant_file_uploaded
Feature: Variant files uploaded message
  Scenario: PT_VU01. if patient_id and molecular_id don't match the variant files upload message should fail
#    Test patients: PT_VU01_TissueShipped1 has tissue shipped with moi PT_VU01_TissueShipped1_MOI1
  #                 PT_VU01_TissueShipped2 has tissue shipped with moi PT_VU01_TissueShipped2_MOI1
    Given template "tsv_vcf" uploaded message for patient: "PT_VU01_TissueShipped1", it has molecular_id: "PT_VU01_TissueShipped2_MOI1" and analysis_id: "PT_VU01_ANI1"
    When post to MATCH patients service, returns a message that includes "molecular" with status "Failure"
    Given template "dna" uploaded message for patient: "PT_VU01_TissueShipped1", it has molecular_id: "PT_VU01_TissueShipped2_MOI1" and analysis_id: "PT_VU01_ANI1"
    When post to MATCH patients service, returns a message that includes "molecular" with status "Failure"
    Given template "cdna" uploaded message for patient: "PT_VU01_TissueShipped1", it has molecular_id: "PT_VU01_TissueShipped2_MOI1" and analysis_id: "PT_VU01_ANI1"
    When post to MATCH patients service, returns a message that includes "molecular" with status "Failure"

    #surgical_event_id has been removed from variant file upload message
#  Scenario Outline: PT_VU02. variant files uploaded message with invalid surgical_event_id should fail
#    Given template variant uploaded message for patient: "PT_VU02_TissueShipped", it has surgical_event_id: "<SEI>", molecular_id: "MOI_01" and analysis_id: "ANI_01"
#    When post to MATCH patients service, returns a message that includes "<message>" with status "Failure"
#    Examples:
#      |SEI            |message                                                                            |
#      |               |was not of a minimum string length of 1                                            |
#      |null           |NilClass did not match the following type: string                                  |
#      |other          |cannot transition from 'TISSUE_NUCLEIC_ACID_SHIPPED'                               |
  Scenario Outline: PT_VU02. variant files uploaded message with invalid site should fail
    Given template "tsv_vcf" uploaded message for patient: "PT_VU02_TissueShipped", it has molecular_id: "PT_VU02_TissueShipped_MOI1" and analysis_id: "PT_VU02_TissueShipped_ANI1"
    Then set patient message field: "site" to value: "<site_value>"
    When post to MATCH patients service, returns a message that includes "<message>" with status "Failure"
    Given template "dna" uploaded message for patient: "PT_VU02_TissueShipped", it has molecular_id: "PT_VU02_TissueShipped_MOI1" and analysis_id: "PT_VU02_TissueShipped_ANI1"
    Then set patient message field: "site" to value: "<site_value>"
    When post to MATCH patients service, returns a message that includes "<message>" with status "Failure"
    Given template "cdna" uploaded message for patient: "PT_VU02_TissueShipped", it has molecular_id: "PT_VU02_TissueShipped_MOI1" and analysis_id: "PT_VU02_TissueShipped_ANI1"
    Then set patient message field: "site" to value: "<site_value>"
    When post to MATCH patients service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |site_value     |message          |
      |               |can't be blank   |
      |null           |can't be blank   |
      |other          |site             |

  Scenario Outline: PT_VU03. variant files uploaded message with invalid molecular_id should fail
    Given template "tsv_vcf" uploaded message for patient: "PT_VU03_TissueShipped", it has molecular_id: "<MOI>" and analysis_id: "PT_VU03_TissueShipped_ANI1"
    When post to MATCH patients service, returns a message that includes "<message>" with status "Failure"
    Given template "dna" uploaded message for patient: "PT_VU03_TissueShipped", it has molecular_id: "<MOI>" and analysis_id: "PT_VU03_TissueShipped_ANI1"
    When post to MATCH patients service, returns a message that includes "<message>" with status "Failure"
    Given template "cdna" uploaded message for patient: "PT_VU03_TissueShipped", it has molecular_id: "<MOI>" and analysis_id: "PT_VU03_TissueShipped_ANI1"
    When post to MATCH patients service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |MOI            |message                                                                            |
      |               |can't be blank                                                                     |
      |null           |can't be blank                                                                     |
      |other          |Molecular id doesn't exist                                                         |

  Scenario Outline: PT_VU04. variant files uploaded message with invalid analysis_id should fail
    Given template "tsv_vcf" uploaded message for patient: "PT_VU04_TissueShipped", it has molecular_id: "PT_VU04_TissueShipped_MOI1" and analysis_id: "<ANI>"
    When post to MATCH patients service, returns a message that includes "<message>" with status "Failure"
    Given template "dna" uploaded message for patient: "PT_VU04_TissueShipped", it has molecular_id: "PT_VU04_TissueShipped_MOI1" and analysis_id: "<ANI>"
    When post to MATCH patients service, returns a message that includes "<message>" with status "Failure"
    Given template "cdna" uploaded message for patient: "PT_VU04_TissueShipped", it has molecular_id: "PT_VU04_TissueShipped_MOI1" and analysis_id: "<ANI>"
    When post to MATCH patients service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |ANI            |message                                                                            |
      |               |can't be blank                                                                     |
      |null           |can't be blank                                                                     |

  Scenario Outline: PT_VU05. variant files uploaded message using old molecular_id should fail
#  Test patient: PT_VU05_TissueShipped: surgical_event_id: PT_VU05_TissueShipped_SEI1,
#                                        molecular_id: PT_VU05_TissueShipped_MOI1 tissue shipped;
    #                                    molecular_id: PT_VU05_TissueShipped_MOI2 tissue shipped;
#  Test patient: PT_VU05_BloodShipped:  molecular_id: PT_VU05_BloodShipped_BD_MOI1 tissue shipped;
    #                                    molecular_id: PT_VU05_BloodShipped_BD_MOI2 tissue shipped;
  Given template "tsv_vcf" uploaded message for patient: "<patient_id>", it has molecular_id: "<moi>" and analysis_id: "<ani>"
  When post to MATCH patients service, returns a message that includes "Molecular id doesn't exist or is not currently active" with status "Failure"
  Given template "dna" uploaded message for patient: "<patient_id>", it has molecular_id: "<moi>" and analysis_id: "<ani>"
  When post to MATCH patients service, returns a message that includes "Molecular id doesn't exist or is not currently active" with status "Failure"
  Given template "cdna" uploaded message for patient: "<patient_id>", it has molecular_id: "<moi>" and analysis_id: "<ani>"
  When post to MATCH patients service, returns a message that includes "Molecular id doesn't exist or is not currently active" with status "Failure"
  Examples:
    |patient_id             |moi                                        |ani                                          |
    |PT_VU05_TissueShipped  |PT_VU05_TissueShipped_MOI1                 |PT_VU05_TissueShipped_ANI1                   |
    |PT_VU05_BloodShipped   |PT_VU05_BloodShipped_BD_MOI1               |PT_VU05_BloodShipped_ANI1                    |

  Scenario: PT_VU06. tsv vcf files uploaded message using new analysis_id can be accepted when patient has TISSUE_NUCLEIC_ACID_SHIPPED status and new uploaded variant files should has PENDING as default status
#  Test patient: PT_VU06_TissueShipped: surgical_event_id: PT_VU06_TissueShipped_SEI1, molecular_id: PT_VU06_TissueShipped_MOI1 tissue shipped;
    Given template "tsv_vcf" uploaded message for patient: "PT_VU06_TissueShipped", it has molecular_id: "PT_VU06_TissueShipped_MOI1" and analysis_id: "PT_VU06_TissueShipped_ANI1"
    When post to MATCH patients service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "15" seconds
    Then retrieve patient: "PT_VU06_TissueShipped" from API
    Then returned patient has variant report (surgical_event_id: "PT_VU06_TissueShipped_SEI1", molecular_id: "PT_VU06_TissueShipped_MOI1", analysis_id: "PT_VU06_TissueShipped_ANI1")
    Then this variant report has value: "PENDING" in field: "status"
    Then this variant report has value: "test1.tsv" in field: "tsv_file_name"
    Then this variant report has value: "test1.vcf" in field: "vcf_file_name"

  Scenario: PT_VU06a. dna files uploaded message using new analysis_id can be accepted when patient has TISSUE_NUCLEIC_ACID_SHIPPED status
#  Test patient: PT_VU06_TissueShipped: PT_VU06_TissueShipped(_SEI1,_MOI1)
    Given template "dna" uploaded message for patient: "PT_VU06_TissueShipped", it has molecular_id: "PT_VU06_TissueShipped_MOI1" and analysis_id: "PT_VU06_TissueShipped_ANI1"
    When post to MATCH patients service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "15" seconds
    Then retrieve patient: "PT_VU06_TissueShipped" from API
    Then returned patient has variant report (surgical_event_id: "PT_VU06_TissueShipped_SEI1", molecular_id: "PT_VU06_TissueShipped_MOI1", analysis_id: "PT_VU06_TissueShipped_ANI1")
    Then this variant report has value: "dna.bam" in field: "dna_bam_name"
    Then this variant report has value: "dna.bam.bai" in field: "dna_bai_name"

  Scenario: PT_VU06b. cdna files uploaded message using new analysis_id can be accepted when patient has TISSUE_NUCLEIC_ACID_SHIPPED status
#  Test patient: PT_VU06_TissueShipped: PT_VU06_TissueShipped(_SEI1,_MOI1)
    Given template "cdna" uploaded message for patient: "PT_VU06_TissueShipped", it has molecular_id: "PT_VU06_TissueShipped_MOI1" and analysis_id: "PT_VU06_TissueShipped_ANI1"
    When post to MATCH patients service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "15" seconds
    Then retrieve patient: "PT_VU06_TissueShipped" from API
    Then returned patient has variant report (surgical_event_id: "PT_VU06_TissueShipped_SEI1", molecular_id: "PT_VU06_TissueShipped_MOI1", analysis_id: "PT_VU06_TissueShipped_ANI1")
    Then this variant report has value: "cdna.bam" in field: "cdna_bam_name"
    Then this variant report has value: "cdna.bam.bai" in field: "cdna_bai_name"


  Scenario: PT_VU07. variant files uploaded with new analysis_id cannot be accepted when patient has only TISSUE_SLIDE_SPECIMEN_SHIPPED status but has no TISSUE_NUCLEIC_ACID_SHIPPED status
#  Test patient: PT_VU07_SlideShippedNoTissueShipped: surgical_event_id: SEI_01 slide shipped, tissue not shipped;
    Given template "tsv_vcf" uploaded message for patient: "PT_VU07_SlideShippedNoTissueShipped", it has molecular_id: "PT_VU07_SlideShippedNoTissueShipped_MOI1" and analysis_id: "PT_VU07_SlideShippedNoTissueShipped_ANI1"
    When post to MATCH patients service, returns a message that includes "Molecular id doesn't exist or is not currently active" with status "Failure"
    Given template "dna" uploaded message for patient: "PT_VU07_SlideShippedNoTissueShipped", it has molecular_id: "PT_VU07_SlideShippedNoTissueShipped_MOI1" and analysis_id: "PT_VU07_SlideShippedNoTissueShipped_ANI1"
    When post to MATCH patients service, returns a message that includes "Molecular id doesn't exist or is not currently active" with status "Failure"
    Given template "cdna" uploaded message for patient: "PT_VU07_SlideShippedNoTissueShipped", it has molecular_id: "PT_VU07_SlideShippedNoTissueShipped_MOI1" and analysis_id: "PT_VU07_SlideShippedNoTissueShipped_ANI1"
    When post to MATCH patients service, returns a message that includes "Molecular id doesn't exist or is not currently active" with status "Failure"


  Scenario: PT_VU09. tsv vcf files uploaded with new analysis_id make all pending old files rejected
#    Test patient: PT_VU09_VariantReportUploaded; variant report files uploaded: surgical_event_id: _SEI1, molecular_id: _MOI1, analysis_id: _ANI1
#          Plan to uploaded surgical_event_id: _SEI1, molecular_id: _MOI1, analysis_id: _ANI2
    Given template "tsv_vcf" uploaded message for patient: "PT_VU09_VariantReportUploaded", it has molecular_id: "PT_VU09_VariantReportUploaded_MOI1" and analysis_id: "PT_VU09_VariantReportUploaded_ANI2"
    When post to MATCH patients service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "15" seconds
    Then retrieve patient: "PT_VU09_VariantReportUploaded" from API
    Then returned patient has variant report (surgical_event_id: "PT_VU09_VariantReportUploaded_SEI1", molecular_id: "PT_VU09_VariantReportUploaded_MOI1", analysis_id: "PT_VU09_VariantReportUploaded_ANI2")
    And this variant report has value: "PENDING" in field: "status"
    Then returned patient has variant report (surgical_event_id: "PT_VU09_VariantReportUploaded_SEI1", molecular_id: "PT_VU09_VariantReportUploaded_MOI1", analysis_id: "PT_VU09_VariantReportUploaded_ANI1")
    And this variant report has value: "REJECTED" in field: "status"
#       For this scenario:
#         SEI_1 MOI_1 shipped->SEI_1 MOI_1 AID_1 uploaded->SEI_1 MOI_1 AID_1 V_UUID_1 confirmed->SEI_2 received->SEI_2 MOI_1 shipped->SEI_2 MOI_1 AID_1 uploaded ==> SEI_1 MOI_1 AID_1 rejected
#         it's covered by specimen received tests, please check PT_SR14 and PT_SR15.

  Scenario: PT_VU10. variant files uploaded with same analysis_id cannot be accepted when patient has TISSUE_VARIANT_REPORT_RECEIVED status
#    Test patient: PT_VU10_VariantReportUploaded; VR uploaded: _SEI1, _MOI1, _ANI1, is PENDING
#      Plan to use _SEI1, _MOI1, _ANI1 again
    Given template "tsv_vcf" uploaded message for patient: "PT_VU10_VariantReportUploaded", it has molecular_id: "PT_VU10_VariantReportUploaded_MOI1" and analysis_id: "PT_VU10_VariantReportUploaded_ANI1"
    When post to MATCH patients service, returns a message that includes "Patient already has a variant report with the same molecular id PT_VU10_VariantReportUploaded_MOI1 and analysis id PT_VU10_VariantReportUploaded_ANI1" with status "Failure"
    Given template "dna" uploaded message for patient: "PT_VU10_VariantReportUploaded", it has molecular_id: "PT_VU10_VariantReportUploaded_MOI1" and analysis_id: "PT_VU10_VariantReportUploaded_ANI1"
    When post to MATCH patients service, returns a message that includes "Patient already has a variant report with the same molecular id PT_VU10_VariantReportUploaded_MOI1 and analysis id PT_VU10_VariantReportUploaded_ANI1" with status "Failure"
    Given template "cdna" uploaded message for patient: "PT_VU10_VariantReportUploaded", it has molecular_id: "PT_VU10_VariantReportUploaded_MOI1" and analysis_id: "PT_VU10_VariantReportUploaded_ANI1"
    When post to MATCH patients service, returns a message that includes "Patient already has a variant report with the same molecular id PT_VU10_VariantReportUploaded_MOI1 and analysis id PT_VU10_VariantReportUploaded_ANI1" with status "Failure"

  Scenario: PT_VU11. variant files uploaded with new analysis_id can be accepted when patient has TISSUE_VARIANT_REPORT_REJECTED status
#    Test patient: PT_VU11_VariantReportRejected; VR rejected: _SEI1, _MOI1, _ANI1
#      Plan to use _SEI1, _MOI1, _ANI2
    Given template "tsv_vcf" uploaded message for patient: "PT_VU11_VariantReportRejected", it has molecular_id: "PT_VU11_VariantReportRejected_MOI1" and analysis_id: "PT_VU11_VariantReportRejected_ANI2"
    When post to MATCH patients service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "15" seconds
    Then retrieve patient: "PT_VU11_VariantReportRejected" from API
    Then returned patient has variant report (surgical_event_id: "PT_VU11_VariantReportRejected_SEI1", molecular_id: "PT_VU11_VariantReportRejected_MOI1", analysis_id: "PT_VU11_VariantReportRejected_ANI2")
    And this variant report has value: "PENDING" in field: "status"

  Scenario Outline: PT_VU12. variant files uploaded with existing(including the one just get rejected) analysis_id cannot be accepted when patient has TISSUE_VARIANT_REPORT_REJECTED status
#    Test patient: PT_VU12_VariantReportRejected; VR rejected: _SEI1, _MOI1, _ANI1, VR rejected _SEI1, _MOI1, _ANI2
    Given template "tsv_vcf" uploaded message for patient: "PT_VU12_VariantReportRejected", it has molecular_id: "<moi>" and analysis_id: "<ani>"
    When post to MATCH patients service, returns a message that includes "Patient already has a variant report" with status "Failure"
    Given template "dna" uploaded message for patient: "PT_VU12_VariantReportRejected", it has molecular_id: "<moi>" and analysis_id: "<ani>"
    When post to MATCH patients service, returns a message that includes "Patient already has a variant report" with status "Failure"
    Given template "cdna" uploaded message for patient: "PT_VU12_VariantReportRejected", it has molecular_id: "<moi>" and analysis_id: "<ani>"
    When post to MATCH patients service, returns a message that includes "Patient already has a variant report" with status "Failure"
    Examples:
      |moi                                |ani                                |
      |PT_VU12_VariantReportRejected_MOI1 |PT_VU12_VariantReportRejected_ANI1 |
      |PT_VU12_VariantReportRejected_MOI1 |PT_VU12_VariantReportRejected_ANI2 |

  Scenario: PT_VU13. variant files uploaded will not be accepted after a patient has TISSUE_VARIANT_REPORT_CONFIRMED status
  #    Test patient: PT_VU13_VariantReportConfirmed; VR confirmed _SEI1, _MOI1, _ANI1
    Given template "tsv_vcf" uploaded message for patient: "PT_VU13_VariantReportConfirmed", it has molecular_id: "PT_VU13_VariantReportConfirmed_MOI1" and analysis_id: "PT_VU13_VariantReportConfirmed_ANI2"
    When post to MATCH patients service, returns a message that includes "Patient already has a confirmed  variant report" with status "Failure"
    Given template "dna" uploaded message for patient: "PT_VU13_VariantReportConfirmed", it has molecular_id: "PT_VU13_VariantReportConfirmed_MOI1" and analysis_id: "PT_VU13_VariantReportConfirmed_ANI2"
    When post to MATCH patients service, returns a message that includes "Patient already has a confirmed  variant report" with status "Failure"
    Given template "cdna" uploaded message for patient: "PT_VU13_VariantReportConfirmed", it has molecular_id: "PT_VU13_VariantReportConfirmed_MOI1" and analysis_id: "PT_VU13_VariantReportConfirmed_ANI2"
    When post to MATCH patients service, returns a message that includes "Patient already has a confirmed  variant report" with status "Failure"

  Scenario: PT_VU14. variant file uploaded to blood specimen should has correct result
#    Test patient: PT_VU14_TissueAndBloodShipped; Tissue shipped: _SEI1, _MOI1; Blood shipped: BD_MOI1
    Given template "tsv_vcf" uploaded message for patient: "PT_VU14_TissueAndBloodShipped", it has molecular_id: "PT_VU14_TissueAndBloodShipped_BD_MOI1" and analysis_id: "PT_VU14_TissueAndBloodShipped_ANI1"
    When post to MATCH patients service, returns a message that includes "Message has been processed successfully" with status "Success"
    Given template "dna" uploaded message for patient: "PT_VU14_TissueAndBloodShipped", it has molecular_id: "PT_VU14_TissueAndBloodShipped_BD_MOI1" and analysis_id: "PT_VU14_TissueAndBloodShipped_ANI1"
    When post to MATCH patients service, returns a message that includes "Message has been processed successfully" with status "Success"
    Given template "cdna" uploaded message for patient: "PT_VU14_TissueAndBloodShipped", it has molecular_id: "PT_VU14_TissueAndBloodShipped_BD_MOI1" and analysis_id: "PT_VU14_TissueAndBloodShipped_ANI1"
    When post to MATCH patients service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "15" seconds
    Then retrieve patient: "PT_VU14_TissueAndBloodShipped" from API
    Then returned patient has value: "BLOOD_VARIANT_REPORT_RECEIVED" in field: "current_status"
    Then returned patient has variant report (surgical_event_id: "null", molecular_id: "PT_VU14_TissueAndBloodShipped_BD_MOI1", analysis_id: "PT_VU14_TissueAndBloodShipped_ANI1")
    And this variant report has value: "BLOOD" in field: "variant_report_type"
    Then this variant report has value: "test1.tsv" in field: "tsv_file_name"
    Then this variant report has value: "test1.vcf" in field: "vcf_file_name"

#    molecular_id is globally unique now, so this test case is not necessary anymore
#  Scenario: PT_VU15. tissue variant file uploaded should generate variants for latest surgical event (not older one which use the same molecular_id)
##    Test patient: PT_VU15_TissueReceivedAndShippedTwice: Tissue shipped: _SEI1, _MOI1, and _SEI2, _MOI1
#    Given template variant uploaded message for patient: "PT_VU15_TissueReceivedAndShippedTwice", it has molecular_id: "MOI_01" and analysis_id: "ANI_01"
#    When post to MATCH patients service, returns a message that includes "Message has been processed successfully" with status "Success"
#    Then wait for "15" seconds
#    Then retrieve patient: "PT_VU15_TissueReceivedAndShippedTwice" from API
#    Then returned patient has variant report (surgical_event_id: "SEI_02", molecular_id: "MOI_01", analysis_id: "ANI_01")

  Scenario: PT_VU16. blood variant files uploaded with new analysis_id make all pending old files rejected
#    Test patient: PT_VU16_BdVRUploaded; variant report files uploaded: molecular_id: _BR_MOI1, analysis_id: _ANI1
#          Plan to uploaded molecular_id: _BR_MOI1, analysis_id: _ANI2
    Given template "tsv_vcf" uploaded message for patient: "PT_VU16_BdVRUploaded", it has molecular_id: "PT_VU16_BdVRUploaded_BD_MOI1" and analysis_id: "PT_VU16_BdVRUploaded_ANI2"
    When post to MATCH patients service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "15" seconds
    Then retrieve patient: "PT_VU16_BdVRUploaded" from API
    Then returned patient has variant report (surgical_event_id: "null", molecular_id: "PT_VU16_BdVRUploaded_BD_MOI1", analysis_id: "PT_VU16_BdVRUploaded_ANI2")
    And this variant report has value: "PENDING" in field: "status"
    Then returned patient has variant report (surgical_event_id: "null", molecular_id: "PT_VU16_BdVRUploaded_BD_MOI1", analysis_id: "PT_VU16_BdVRUploaded_ANI1")
    And this variant report has value: "REJECTED" in field: "status"

Scenario Outline: PT_VU17. blood variant files cannot be uploaded if patient has BLOOD_VARIANT_REPORT_CONFIRMED status, but tissue files can be
#    Test patient: PT_VU17_BdVRConfirmed; blood variant report files confirmed: molecular_id: _BR_MOI1, analysis_id: _ANI1
#                                        tissue specimen has been shipped: molecular_id: _MOI1
  Given template "tsv_vcf" uploaded message for patient: "PT_VU17_BdVRConfirmed", it has molecular_id: "<moi>" and analysis_id: "<ani>"
  When post to MATCH patients service, returns a message that includes "<message>" with status "<post_status>"
  Then wait for "15" seconds
  Then retrieve patient: "PT_VU17_BdVRConfirmed" from API
  Then returned patient has variant report (surgical_event_id: "<sei>", molecular_id: "<moi>", analysis_id: "<query_ani>")
  And this variant report has value: "<vr_status>" in field: "status"
  Examples:
  |sei                        |moi                            |ani                        |query_ani                  |vr_status|message                                 |post_status|
  |                           |PT_VU17_BdVRConfirmed_BD_MOI1  |PT_VU17_BdVRConfirmed_ANI2 |PT_VU17_BdVRConfirmed_ANI1 |CONFIRMED|confirmed                               |Failure    |
  |PT_VU17_BdVRConfirmed_SEI1 |PT_VU17_BdVRConfirmed_MOI1     |PT_VU17_BdVRConfirmed_ANI3 |PT_VU17_BdVRConfirmed_ANI3 |PENDING  |Message has been processed successfully |Success    |