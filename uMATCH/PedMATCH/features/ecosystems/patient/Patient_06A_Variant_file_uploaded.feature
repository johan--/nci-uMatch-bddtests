#encoding: utf-8
@variant_file_uploaded
Feature: Variant files uploaded message
  Background: 
    Given patient API user authorization role is "SYSTEM"

#  not required
#  @patients_p2
#  Scenario: PT_VU01. if patient_id and molecular_id don't match the variant files upload message should fail
##    Test patients: PT_VU01_TissueShipped1 has tissue shipped with moi PT_VU01_TissueShipped1_MOI1
#  #                 PT_VU01_TissueShipped2 has tissue shipped with moi PT_VU01_TissueShipped2_MOI1
#    Given template variant file uploaded message for patient: "PT_VU01_TissueShipped1", it has molecular_id: "PT_VU01_TissueShipped2_MOI1" and analysis_id: "PT_VU01_TissueShipped2_ANI1" and need files in S3 Y or N: "Y"
#    When POST to MATCH patients service, response includes "molecular" with status "Failure"

    #surgical_event_id has been removed from variant file upload message
#  Scenario Outline: PT_VU02. variant files uploaded message with invalid surgical_event_id should fail
#    Given template variant uploaded message for patient: "PT_VU02_TissueShipped", it has surgical_event_id: "<SEI>", molecular_id: "MOI_01" and analysis_id: "ANI_01"
#    When POST to MATCH patients service, response includes "<message>" with code "403"
#    Examples:
#      |SEI            |message                                                                            |
#      |               |was not of a minimum string length of 1                                            |
#      |null           |NilClass did not match the following type: string                                  |
#      |other          |cannot transition from 'TISSUE_NUCLEIC_ACID_SHIPPED'                               |
  @patients_p2
  Scenario Outline: PT_VU02. variant files uploaded message with invalid ion_reporter_id should fail
    Given patient id is "PT_VU02_TissueShipped"
    And load template variant file uploaded message for this patient
    Then set patient message field: "molecular_id" to value: "PT_VU02_TissueShipped_MOI1"
    Then set patient message field: "analysis_id" to value: "PT_VU02_TissueShipped_ANI1"
    Then set patient message field: "ion_reporter_id" to value: "<site_value>"
    When POST to MATCH patients service, response includes "<message>" with code "403"
    Examples:
      | site_value | message        |
      |            | can't be blank |
      | null       | can't be blank |

#    site has been replaced by ion_reporter, and we don't verify the value
#  Scenario Outline: PT_VU02a. variant files can be uploaded from both MDA and MoCha successfully
#    Given template variant file uploaded message for patient: "<patient_id>", it has molecular_id: "<patient_id>_MOI1" and analysis_id: "<patient_id>_ANI1"
#    Then set patient message field: "site" to value: "<site>"
#    When POST to MATCH patients service, response includes "successfully" with code "202"
#    Then wait for "15" seconds
#    Then retrieve patient: "<patient_id>" from API
#    Then returned patient has variant report (surgical_event_id: "<patient_id>_SEI1", molecular_id: "<patient_id>_MOI1", analysis_id: "<patient_id>_ANI1")
#    Then this variant report has value: "PENDING" in field: "status"
#    Examples:
#    |patient_id                   |site   |
#    |PT_VU02a_TissueShippedToMDA  |MDA    |
#    |PT_VU02a_TissueShippedToMoCha|MoCha  |

  @patients_p2_off
  Scenario Outline: PT_VU03. variant files uploaded message with invalid molecular_id should fail
    Given patient id is "PT_VU03_TissueShipped"
    And load template variant file uploaded message for this patient
    Then set patient message field: "molecular_id" to value: "<MOI>"
    Then set patient message field: "analysis_id" to value: "PT_VU03_TissueShipped_ANI1"
    When POST to MATCH patients service, response includes "<message>" with code "403"
    Examples:
      | MOI   | message                                   |
      |       | can't be blank                            |
      | null  | can't be blank                            |
      | other | Unable to find shipment with molecular id |

  @patients_p2
  Scenario Outline: PT_VU04. variant files uploaded message with invalid analysis_id should fail
    Given patient id is "PT_VU04_TissueShipped"
    And load template variant file uploaded message for this patient
    Then set patient message field: "molecular_id" to value: "PT_VU04_TissueShipped_MOI1"
    Then set patient message field: "analysis_id" to value: "<ANI>"
    When POST to MATCH patients service, response includes "<message>" with code "403"
    Examples:
      | ANI  | message        |
      |      | can't be blank |
      | null | can't be blank |

  @patients_p2
  Scenario Outline: PT_VU05. variant files uploaded message using old molecular_id should fail
#  Test patient: PT_VU05_TissueShipped: surgical_event_id: PT_VU05_TissueShipped_SEI1,
#                                        molecular_id: PT_VU05_TissueShipped_MOI1 tissue shipped;
    #                                    molecular_id: PT_VU05_TissueShipped_MOI2 tissue shipped;
#  Test patient: PT_VU05_BloodShipped:  molecular_id: PT_VU05_BloodShipped_BD_MOI1 tissue shipped;
    #                                    molecular_id: PT_VU05_BloodShipped_BD_MOI2 tissue shipped;
    Given patient id is "<patient_id>"
    And load template variant file uploaded message for this patient
    Then set patient message field: "molecular_id" to value: "<moi>"
    Then set patient message field: "analysis_id" to value: "<ani>"
    Then files for molecular_id "<moi>" and analysis_id "<ani>" are in S3
    When POST to MATCH patients service, response includes "Molecular id doesn't exist" with code "403"
    Examples:
      | patient_id            | moi                          | ani                        |
      | PT_VU05_TissueShipped | PT_VU05_TissueShipped_MOI1   | PT_VU05_TissueShipped_ANI1 |
      | PT_VU05_BloodShipped  | PT_VU05_BloodShipped_BD_MOI1 | PT_VU05_BloodShipped_ANI1  |

  @patients_p1
  Scenario: PT_VU06. tsv vcf files uploaded message using new analysis_id can be accepted when patient has TISSUE_NUCLEIC_ACID_SHIPPED status and new uploaded variant files should has PENDING as default status
#  Test patient: PT_VU06_TissueShipped: surgical_event_id: PT_VU06_TissueShipped_SEI1, molecular_id: PT_VU06_TissueShipped_MOI1 tissue shipped;
    Given patient id is "PT_VU06_TissueShipped"
    And load template variant file uploaded message for this patient
    Then set patient message field: "molecular_id" to value: "PT_VU06_TissueShipped_MOI1"
    Then set patient message field: "analysis_id" to value: "PT_VU06_TissueShipped_ANI1"
    Then files for molecular_id "PT_VU06_TissueShipped_MOI1" and analysis_id "PT_VU06_TissueShipped_ANI1" are in S3
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "TISSUE_VARIANT_REPORT_RECEIVED"
    Then patient should have variant report (analysis_id: "PT_VU06_TissueShipped_ANI1")
    Then this variant report field: "status" should be "PENDING"
    Then this variant report field: "tsv_file_name" should be "test1.tsv"

  @patients_p2_off
  Scenario: PT_VU07. variant files uploaded with new analysis_id cannot be accepted when patient has only TISSUE_SLIDE_SPECIMEN_SHIPPED status but has no TISSUE_NUCLEIC_ACID_SHIPPED status
#  Test patient: PT_VU07_SlideShippedNoTissueShipped: surgical_event_id: SEI_01 slide shipped, tissue not shipped;
    Given patient id is "PT_VU07_SlideShippedNoTissueShipped"
    And load template variant file uploaded message for this patient
    Then set patient message field: "molecular_id" to value: "PT_VU07_SlideShippedNoTissueShipped_MOI1"
    Then set patient message field: "analysis_id" to value: "PT_VU07_SlideShippedNoTissueShipped_ANI1"
    Then files for molecular_id "PT_VU07_SlideShippedNoTissueShipped_MOI1" and analysis_id "PT_VU07_SlideShippedNoTissueShipped_ANI1" are in S3
    When POST to MATCH patients service, response includes "Unable to find shipment with molecular id" with code "403"

  @patients_p2
  Scenario: PT_VU09. tsv vcf files uploaded with new analysis_id make all pending old files rejected
#    Test patient: PT_VU09_VariantReportUploaded; variant report files uploaded: surgical_event_id: _SEI1, molecular_id: _MOI1, analysis_id: _ANI1
#          Plan to uploaded surgical_event_id: _SEI1, molecular_id: _MOI1, analysis_id: _ANI2
    Given patient id is "PT_VU09_VariantReportUploaded"
    And load template variant file uploaded message for this patient
    Then set patient message field: "molecular_id" to value: "PT_VU09_VariantReportUploaded_MOI1"
    Then set patient message field: "analysis_id" to value: "PT_VU09_VariantReportUploaded_ANI2"
    Then files for molecular_id "PT_VU09_VariantReportUploaded_MOI1" and analysis_id "PT_VU09_VariantReportUploaded_ANI2" are in S3
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then wait until patient is updated
    Then patient should have variant report (analysis_id: "PT_VU09_VariantReportUploaded_ANI2")
    And this variant report field: "status" should be "PENDING"
    Then patient should have variant report (analysis_id: "PT_VU09_VariantReportUploaded_ANI1")
    And this variant report field: "status" should be "REJECTED"
#       For this scenario:
#         SEI_1 MOI_1 shipped->SEI_1 MOI_1 AID_1 uploaded->SEI_1 MOI_1 AID_1 V_UUID_1 confirmed->SEI_2 received->SEI_2 MOI_1 shipped->SEI_2 MOI_1 AID_1 uploaded ==> SEI_1 MOI_1 AID_1 rejected
#         it's covered by specimen received tests, please check PT_SR14 and PT_SR15.

  @patients_p2
  Scenario: PT_VU10. variant files uploaded with same analysis_id cannot be accepted when patient has TISSUE_VARIANT_REPORT_RECEIVED status
#    Test patient: PT_VU10_VariantReportUploaded; VR uploaded: _SEI1, _MOI1, _ANI1, is PENDING
#      Plan to use _SEI1, _MOI1, _ANI1 again
    Given patient id is "PT_VU10_VariantReportUploaded"
    And load template variant file uploaded message for this patient
    Then set patient message field: "molecular_id" to value: "PT_VU10_VariantReportUploaded_MOI1"
    Then set patient message field: "analysis_id" to value: "PT_VU10_VariantReportUploaded_ANI1"
    Then files for molecular_id "PT_VU10_VariantReportUploaded_MOI1" and analysis_id "PT_VU10_VariantReportUploaded_ANI1" are in S3
    When POST to MATCH patients service, response includes "same molecular id" with code "403"

  @patients_p2
  Scenario: PT_VU11. variant files uploaded with new analysis_id can be accepted when patient has TISSUE_VARIANT_REPORT_REJECTED status
#    Test patient: PT_VU11_VariantReportRejected; VR rejected: _SEI1, _MOI1, _ANI1
#      Plan to use _SEI1, _MOI1, _ANI2
    Given patient id is "PT_VU11_VariantReportRejected"
    And load template variant file uploaded message for this patient
    Then set patient message field: "molecular_id" to value: "PT_VU11_VariantReportRejected_MOI1"
    Then set patient message field: "analysis_id" to value: "PT_VU11_VariantReportRejected_ANI2"
    Then files for molecular_id "PT_VU11_VariantReportRejected_MOI1" and analysis_id "PT_VU11_VariantReportRejected_ANI2" are in S3
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "TISSUE_VARIANT_REPORT_RECEIVED"
    Then patient should have variant report (analysis_id: "PT_VU11_VariantReportRejected_ANI2")
    And this variant report field: "status" should be "PENDING"

  @patients_p2
  Scenario Outline: PT_VU12. variant files uploaded with existing(including the one just get rejected) analysis_id cannot be accepted when patient has TISSUE_VARIANT_REPORT_REJECTED status
#    Test patient: PT_VU12_VariantReportRejected; VR rejected: _SEI1, _MOI1, _ANI1, VR rejected _SEI1, _MOI1, _ANI2
    Given patient id is "PT_VU12_VariantReportRejected"
    And load template variant file uploaded message for this patient
    Then set patient message field: "molecular_id" to value: "<moi>"
    Then set patient message field: "analysis_id" to value: "<ani>"
    Then files for molecular_id "<moi>" and analysis_id "<ani>" are in S3
    When POST to MATCH patients service, response includes "already has a variant report" with code "403"
    Examples:
      | moi                                | ani                                |
      | PT_VU12_VariantReportRejected_MOI1 | PT_VU12_VariantReportRejected_ANI1 |
      | PT_VU12_VariantReportRejected_MOI1 | PT_VU12_VariantReportRejected_ANI2 |

  @patients_p2
  Scenario: PT_VU13. variant files uploaded will not be accepted after a patient has TISSUE_VARIANT_REPORT_CONFIRMED status
  #    Test patient: PT_VU13_VariantReportConfirmed; VR confirmed _SEI1, _MOI1, _ANI1
    Given patient id is "PT_VU13_VariantReportConfirmed"
    And load template variant file uploaded message for this patient
    Then set patient message field: "molecular_id" to value: "PT_VU13_VariantReportConfirmed_MOI1"
    Then set patient message field: "analysis_id" to value: "PT_VU13_VariantReportConfirmed_ANI2"
    Then files for molecular_id "PT_VU13_VariantReportConfirmed_MOI1" and analysis_id "PT_VU13_VariantReportConfirmed_ANI2" are in S3
    When POST to MATCH patients service, response includes "already has a confirmed  variant report" with code "403"

  @patients_p3
  Scenario: PT_VU14. variant file uploaded to blood specimen should has correct result
#    Test patient: PT_VU14_TissueAndBloodShipped; Tissue shipped: _SEI1, _MOI1; Blood shipped: BD_MOI1
    Given patient id is "PT_VU14_TissueAndBloodShipped"
    And load template variant file uploaded message for this patient
    Then set patient message field: "molecular_id" to value: "PT_VU14_TissueAndBloodShipped_BD_MOI1"
    Then set patient message field: "analysis_id" to value: "PT_VU14_TissueAndBloodShipped_ANI1"
    Then files for molecular_id "PT_VU14_TissueAndBloodShipped_BD_MOI1" and analysis_id "PT_VU14_TissueAndBloodShipped_ANI1" are in S3
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then wait until patient variant report is updated
    Then patient should have variant report (analysis_id: "PT_VU14_TissueAndBloodShipped_ANI1")
    And this variant report field: "variant_report_type" should be "BLOOD"
    And this variant report field: "tsv_file_name" should be "test1.tsv"

#    molecular_id is globally unique now, so this test case is not necessary anymore
#  Scenario: PT_VU15. tissue variant file uploaded should generate variants for latest surgical event (not older one which use the same molecular_id)
##    Test patient: PT_VU15_TissueReceivedAndShippedTwice: Tissue shipped: _SEI1, _MOI1, and _SEI2, _MOI1
#    Given template variant uploaded message for patient: "PT_VU15_TissueReceivedAndShippedTwice", it has molecular_id: "MOI_01" and analysis_id: "ANI_01"
#    When POST to MATCH patients service, response includes "successfully" with code "202"
#    Then wait for "15" seconds
#    Then retrieve patient: "PT_VU15_TissueReceivedAndShippedTwice" from API
#    Then returned patient has variant report (surgical_event_id: "SEI_02", molecular_id: "MOI_01", analysis_id: "ANI_01")

  @patients_p3
  Scenario: PT_VU16. blood variant files uploaded with new analysis_id make all pending old files rejected
#    Test patient: PT_VU16_BdVRUploaded; variant report files uploaded: molecular_id: _BR_MOI1, analysis_id: _ANI1
#          Plan to uploaded molecular_id: _BR_MOI1, analysis_id: _ANI2
    Given patient id is "PT_VU16_BdVRUploaded"
    And load template variant file uploaded message for this patient
    Then set patient message field: "molecular_id" to value: "PT_VU16_BdVRUploaded_BD_MOI1"
    Then set patient message field: "analysis_id" to value: "PT_VU16_BdVRUploaded_ANI2"
    Then files for molecular_id "PT_VU16_BdVRUploaded_BD_MOI1" and analysis_id "PT_VU16_BdVRUploaded_ANI2" are in S3
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then wait until patient variant report is updated
    Then patient should have variant report (analysis_id: "PT_VU16_BdVRUploaded_ANI2")
    And this variant report field: "status" should be "PENDING"
    Then patient should have variant report (analysis_id: "PT_VU16_BdVRUploaded_ANI1")
    And this variant report field: "status" should be "REJECTED"


    #no blood status is used anymore
#  Scenario Outline: PT_VU17. blood variant files cannot be uploaded if patient has BLOOD_VARIANT_REPORT_CONFIRMED status, but still can upload tissue variant files
##    Test patient: PT_VU17_BdVRConfirmed; blood variant report files confirmed: molecular_id: _BR_MOI1, analysis_id: _ANI1
##                                        tissue specimen has been shipped: molecular_id: _MOI1
#    Given template variant file uploaded message for patient: "PT_VU17_BdVRConfirmed", it has molecular_id: "<moi>" and analysis_id: "<ani>"
#    When POST to MATCH patients service, response includes "<message>" with status "<post_status>"
#    Then patient should have variant report (analysis_id: "<query_ani>") within 15 seconds
#    And this variant report has value: "<vr_status>" in field: "status"
#    Examples:
#      | moi                           | ani                        | query_ani                  | vr_status | message                | post_status |
#      | PT_VU17_BdVRConfirmed_BD_MOI1 | PT_VU17_BdVRConfirmed_ANI2 | PT_VU17_BdVRConfirmed_ANI1 | CONFIRMED | confirmed              | Failure     |
#      | PT_VU17_BdVRConfirmed_MOI1    | PT_VU17_BdVRConfirmed_ANI3 | PT_VU17_BdVRConfirmed_ANI3 | PENDING   | processed successfully | Success     |
