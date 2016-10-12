#encoding: utf-8
@ion_reporter_reporters
Feature: Tests for aliquot service in ion ecosystem

  @ion_reporter_p1
  Scenario: ION_AQ01. for sample control specimen, aliquot service will generate tsv and bai files and upload to S3, then update database
    Given molecular id is "SC_KK44M"
    Then add field: "analysis_id" value: "SC_KK44M_ANI1" to message body
    Then add field: "site" value: "mocha" to message body
    Then add field: "ion_reporter_id" value: "IR_WAO85" to message body
    Then add field: "vcf_name" value: "ion_api_test_data/SC_KK44M/SC_KK44M_ANI1/test1.vcf" to message body
    Then add field: "dna_bam_name" value: "ion_api_test_data/SC_KK44M/SC_KK44M_ANI1/dna.bam" to message body
    Then add field: "cdna_bam_name" value: "ion_api_test_data/SC_KK44M/SC_KK44M_ANI1/cdna.bam" to message body
    Then add field: "qc_name" value: "ion_api_test_data/SC_KK44M/SC_KK44M_ANI1/SC_KK44M_ANI1_QA.pdf" to message body
    Then call aliquot PUT service, returns a message that includes "Item updated" with status "Success"
    Then field: "tsv_name" for this sample control should be: "IR_WAO85/SC_KK44M/SC_KK44M_ANI1/SC_KK44M_ANI1.tsv" within 15 seconds
    Then field: "dna_bai_name" for this sample control should be: "IR_WAO85/SC_KK44M/SC_KK44M_ANI1/SC_KK44M_ANI1_DNA.bam.bai" within 15 seconds
    Then field: "cdna_bai_name" for this sample control should be: "IR_WAO85/SC_KK44M/SC_KK44M_ANI1/SC_KK44M_ANI1_RNA.bam.bai" within 15 seconds
    And file: "ion_api_test_data/SC_KK44M/SC_KK44M_ANI1/SC_KK44M_ANI1.tsv" should be available in S3
    And file: "ion_api_test_data/SC_KK44M/SC_KK44M_ANI1/SC_KK44M_ANI1_DNA.bam.bai" should be available in S3
    And file: "ion_api_test_data/SC_KK44M/SC_KK44M_ANI1/SC_KK44M_ANI1_RNA.bam.bai" should be available in S3

  @ion_reporter_p1
  Scenario: ION_AQ02. for patient tissue specimen, aliquot service will generate tsv and bai files and upload to S3, then send variant files uploaded message to patient ecosystem once process done
    Given molecular id is "ION_AQ02_TsShipped_MOI1"
    Given patient id is "ION_AQ02_TsShipped"
    Then add field: "analysis_id" value: "ION_AQ02_TsShipped_ANI1" to message body
    Then add field: "site" value: "mda" to message body
    Then add field: "ion_reporter_id" value: "IR_Y1TKW" to message body
    Then add field: "vcf_name" value: "ion_api_test_data/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI1/test1.vcf" to message body
    Then add field: "dna_bam_name" value: "ion_api_test_data/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI1/dna.bam" to message body
    Then add field: "cdna_bam_name" value: "ion_api_test_data/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI1/cdna.bam" to message body
    Then add field: "qc_name" value: "ion_api_test_data/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI1/PT_PR07_TissueShipped_ANI1_QC.pdf" to message body
    Then call aliquot PUT service, returns a message that includes "Item updated" with status "Success"
    Then patient should have variant report (analysis_id: "ION_AQ02_TsShipped_ANI1") within 30 seconds
    And this variant report has value: "ion_api_test_data/PT_PR07_TissueShipped_MOI1/ION_AQ02_TsShipped_ANI1/test1.tsv" in field: "tsv_file_name"
    And file: "ion_api_test_data/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI1/test1.tsv" should be available in S3
    And file: "ion_api_test_data/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI1/dna.bam.bai" should be available in S3
    And file: "ion_api_test_data/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI1/cdna.bam.bai" should be available in S3
    Then add field: "analysis_id" value: "ION_AQ02_TsShipped_ANI2" to message body
    Then add field: "site" value: "mda" to message body
    Then add field: "ion_reporter_id" value: "IR_Y1TKW" to message body
    Then add field: "vcf_name" value: "ion_api_test_data/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI2/test1.vcf" to message body
    Then add field: "dna_bam_name" value: "ion_api_test_data/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI2/dna.bam" to message body
    Then add field: "cdna_bam_name" value: "ion_api_test_data/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI2/cdna.bam" to message body
    Then add field: "qc_name" value: "ion_api_test_data/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI2/ION_AQ02_TsShipped_ANI2_QC.pdf" to message body
    Then call aliquot PUT service, returns a message that includes "Item updated" with status "Success"
    Then patient should have variant report (analysis_id: "ION_AQ02_TsShipped_ANI2") within 30 seconds
    And this variant report has value: "ion_api_test_data/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI2/test1.tsv" in field: "tsv_file_name"
    And file: "ion_api_test_data/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI2/test1.tsv" should be available in S3
    And file: "ion_api_test_data/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI2/dna.bam.bai" should be available in S3
    And file: "ion_api_test_data/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI2/cdna.bam.bai" should be available in S3

  @ion_reporter_p1
  Scenario: ION_AQ03. for patient blood specimen, aliquot service will generate tsv and bai files and upload to S3, then send variant files uploaded message to patient ecosystem once process done
    Given molecular id is "ION_AQ03_BdShipped_BD_MOI1"
    Given patient id is "ION_AQ03_BdShipped"
    Then add field: "analysis_id" value: "ION_AQ03_BdShipped_ANI1" to message body
    Then add field: "site" value: "mda" to message body
    Then add field: "ion_reporter_id" value: "IR_Y1TKW" to message body
    Then add field: "vcf_name" value: "ion_api_test_data/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI1/test1.vcf" to message body
    Then add field: "dna_bam_name" value: "ion_api_test_data/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI1/dna.bam" to message body
    Then add field: "cdna_bam_name" value: "ion_api_test_data/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI1/cdna.bam" to message body
    Then add field: "qc_name" value: "ion_api_test_data/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI1/PT_PR07_TissueShipped_ANI1_QC.pdf" to message body
    Then call aliquot PUT service, returns a message that includes "Item updated" with status "Success"
    Then patient should have variant report (analysis_id: "ION_AQ03_BdShipped_ANI1") within 30 seconds
    And this variant report has value: "ion_api_test_data/PT_PR07_TissueShipped_MOI1/ION_AQ03_BdShipped_ANI1/test1.tsv" in field: "tsv_file_name"
    And file: "ion_api_test_data/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI1/test1.tsv" should be available in S3
    And file: "ion_api_test_data/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI1/dna.bam.bai" should be available in S3
    And file: "ion_api_test_data/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI1/cdna.bam.bai" should be available in S3
    Then add field: "analysis_id" value: "ION_AQ03_BdShipped_ANI2" to message body
    Then add field: "site" value: "mda" to message body
    Then add field: "ion_reporter_id" value: "IR_Y1TKW" to message body
    Then add field: "vcf_name" value: "ion_api_test_data/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI2/test1.vcf" to message body
    Then add field: "dna_bam_name" value: "ion_api_test_data/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI2/dna.bam" to message body
    Then add field: "cdna_bam_name" value: "ion_api_test_data/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI2/cdna.bam" to message body
    Then add field: "qc_name" value: "ion_api_test_data/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI2/ION_AQ03_BdShipped_ANI2_QC.pdf" to message body
    Then call aliquot PUT service, returns a message that includes "Item updated" with status "Success"
    Then patient should have variant report (analysis_id: "ION_AQ03_BdShipped_ANI2") within 30 seconds
    And this variant report has value: "ion_api_test_data/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI2/test1.tsv" in field: "tsv_file_name"
    And file: "ion_api_test_data/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI2/test1.tsv" should be available in S3
    And file: "ion_api_test_data/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI2/dna.bam.bai" should be available in S3
    And file: "ion_api_test_data/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI2/cdna.bam.bai" should be available in S3

  @ion_reporter_p3
  Scenario Outline: ION_AQ04. aliquot service will return error if any file value(vcf, bam, qc) is missing
    Given molecular id is "<moi>"
    Then add field: "analysis_id" value: "<ani>" to message body
    Then add field: "site" value: "mocha" to message body
    Then add field: "ion_reporter_id" value: "IR_WAO85" to message body
    Then add field: "vcf_name" value: "<vcf>" to message body
    Then add field: "dna_bam_name" value: "<dna_bam>" to message body
    Then call aliquot PUT service, returns a message that includes "missing" with status "Failure"
    Examples:
      | moi                     | ani                     | vcf                                                | dna_bam                                                                   |
      | SC_S5ONQ                | SC_S5ONQ_ANI1           | ion_api_test_data/SC_S5ONQ/SC_S5ONQ_ANI1/test1.vcf |                                                                           |
      | ION_AQ04_TsShipped_MOI1 | ION_AQ04_TsShipped_ANI1 |                                                    | ion_api_test_data/ION_AQ04_TsShipped_MOI1/ION_AQ04_TsShipped_ANI1/dna.bam |

  @ion_reporter_p3
  Scenario: ION_AQ05. extra key-value pair in the message body should NOT fail
    Given molecular id is "SC_TIBZY"
    Then add field: "analysis_id" value: "SC_TIBZY_ANI1" to message body
    Then add field: "site" value: "mocha" to message body
    Then add field: "ion_reporter_id" value: "IR_WAO85" to message body
    Then add field: "vcf_name" value: "ion_api_test_data/SC_TIBZY/SC_TIBZY_ANI1/test1.vcf" to message body
    Then add field: "dna_bam_name" value: "ion_api_test_data/SC_TIBZY/SC_TIBZY_ANI1/dna.bam" to message body
    Then add field: "cdna_bam_name" value: "ion_api_test_data/SC_TIBZY/SC_TIBZY_ANI1/cdna.bam" to message body
    Then add field: "qc_name" value: "ion_api_test_data/SC_TIBZY/SC_TIBZY_ANI1/SC_TIBZY_ANI1_QA.pdf" to message body
    Then add field: "extra_info" value: "a comment" to message body
    Then call aliquot PUT service, returns a message that includes "Item updated" with status "Success"

  @ion_reporter_p2
  Scenario: ION_AQ20. for sample control specimen, if the files passed in are not in that path, aliquot service will not update database
    #there is no file in S3 for this sample control
    Given molecular id is "SC_RQTL5"
    Then add field: "analysis_id" value: "SC_RQTL5_ANI1" to message body
    Then add field: "site" value: "mocha" to message body
    Then add field: "ion_reporter_id" value: "IR_WAO85" to message body
    Then add field: "vcf_name" value: "ion_api_test_data/SC_RQTL5/SC_RQTL5_ANI1/test1.vcf" to message body
    Then add field: "dna_bam_name" value: "ion_api_test_data/SC_RQTL5/SC_RQTL5_ANI1/dna.bam" to message body
    Then add field: "cdna_bam_name" value: "ion_api_test_data/SC_RQTL5/SC_RQTL5_ANI1/cdna.bam" to message body
    Then add field: "qc_name" value: "ion_api_test_data/SC_RQTL5/SC_RQTL5_ANI1/SC_RQTL5_ANI1_QA.pdf" to message body
    Then call aliquot PUT service, returns a message that includes "Item updated" with status "Success"
    Then wait for "30" seconds
    Then field: "tsv_name" for this sample control should be: "null" within 1 seconds
    Then field: "dna_bai_name" for this sample control should be: "null" within 1 seconds
    Then field: "cdna_bai_name" for this sample control should be: "null" within 1 seconds

  @ion_reporter_p2
  Scenario: ION_AQ21. for sample control specimen, if the file conversion failed, aliquot service will not update database
    #the files in S3 for this patient are invalid files (random text files with fake name)
    Given molecular id is "SC_TMBE6"
    Then add field: "analysis_id" value: "SC_TMBE6_ANI1" to message body
    Then add field: "site" value: "mocha" to message body
    Then add field: "ion_reporter_id" value: "IR_WAO85" to message body
    Then add field: "vcf_name" value: "ion_api_test_data/SC_TMBE6_MOI1/SC_TMBE6_ANI1/test1.vcf" to message body
    Then add field: "dna_bam_name" value: "ion_api_test_data/SC_TMBE6_MOI1/SC_TMBE6_ANI1/dna.bam" to message body
    Then add field: "cdna_bam_name" value: "ion_api_test_data/SC_TMBE6_MOI1/SC_TMBE6_ANI1/cdna.bam" to message body
    Then add field: "qc_name" value: "ion_api_test_data/SC_TMBE6_MOI1/SC_TMBE6_ANI1/SC_TMBE6_ANI1_QA.pdf" to message body
    Then call aliquot PUT service, returns a message that includes "Item updated" with status "Success"
    Then wait for "30" seconds
    Then field: "tsv_name" for this sample control should be: "null" within 1 seconds
    Then field: "dna_bai_name" for this sample control should be: "null" within 1 seconds
    Then field: "cdna_bai_name" for this sample control should be: "null" within 1 seconds

  @ion_reporter_p2
  Scenario: ION_AQ22. for sample control specimen, if the file uploading fails, aliquot service will not update database

  @ion_reporter_p2
  Scenario: ION_AQ23. for patient specimen, if the files passed in are not in that path, aliquot service will not send message to patient ecosystem
    #there is no file in S3 for this patient
    Given molecular id is "ION_AQ23_TsShipped_MOI1"
    Then add field: "analysis_id" value: "ION_AQ23_TsShipped_ANI1" to message body
    Then add field: "site" value: "mocha" to message body
    Then add field: "ion_reporter_id" value: "IR_WAO85" to message body
    Then add field: "vcf_name" value: "ion_api_test_data/ION_AQ23_TsShipped_MOI1/ION_AQ23_TsShipped_ANI1/test1.vcf" to message body
    Then add field: "dna_bam_name" value: "ion_api_test_data/ION_AQ23_TsShipped_MOI1/ION_AQ23_TsShipped_ANI1/dna.bam" to message body
    Then add field: "cdna_bam_name" value: "ion_api_test_data/ION_AQ23_TsShipped_MOI1/ION_AQ23_TsShipped_ANI1/cdna.bam" to message body
    Then add field: "qc_name" value: "ion_api_test_data/ION_AQ23_TsShipped_MOI1/ION_AQ23_TsShipped_ANI1/ION_AQ23_TsShipped_ANI1_QA.pdf" to message body
    Then call aliquot PUT service, returns a message that includes "Item updated" with status "Success"
    Then patient field: "current_status" should have value: "TISSUE_NUCLEIC_ACID_SHIPPED" after 30 seconds

  @ion_reporter_p2
  Scenario: ION_AQ24. for patient specimen, if the file conversion failed, aliquot service will not send message to patient ecosystem    #there is no file in S3 for this patient
    #the files in S3 for this patient are invalid files (random text files with fake name)
    Given molecular id is "ION_AQ24_TsShipped_MOI1"
    Then add field: "analysis_id" value: "ION_AQ24_TsShipped_ANI1" to message body
    Then add field: "site" value: "mocha" to message body
    Then add field: "ion_reporter_id" value: "IR_WAO85" to message body
    Then add field: "vcf_name" value: "ion_api_test_data/ION_AQ24_TsShipped_MOI1/ION_AQ24_TsShipped_ANI1/test1.vcf" to message body
    Then add field: "dna_bam_name" value: "ion_api_test_data/ION_AQ24_TsShipped_MOI1/ION_AQ24_TsShipped_ANI1/dna.bam" to message body
    Then add field: "cdna_bam_name" value: "ion_api_test_data/ION_AQ24_TsShipped_MOI1/ION_AQ24_TsShipped_ANI1/cdna.bam" to message body
    Then add field: "qc_name" value: "ion_api_test_data/ION_AQ24_TsShipped_MOI1/ION_AQ24_TsShipped_ANI1/ION_AQ24_TsShipped_ANI1_QA.pdf" to message body
    Then call aliquot PUT service, returns a message that includes "Item updated" with status "Success"
    Then patient field: "current_status" should have value: "TISSUE_NUCLEIC_ACID_SHIPPED" after 30 seconds

  @ion_reporter_p2
  Scenario: ION_AQ25. for patient specimen, if the file uploading fails, aliquot service will not send message to patient ecosystem

  @ion_reporter_p1
  Scenario: ION_AQ40. aliquot service can return correct result for sample control molecular_id
    Given molecular id is "SC_FKIRT"
    Then call aliquot GET service, field: "site" for this sample_control should be: "mocha"
    Then call aliquot GET service, field: "control_type" for this sample_control should be: "no_template"
    Then call aliquot GET service, field: "date_molecular_id_created" for this sample_control should be: "2016-10-04 14:29:43.726768"

  @ion_reporter_p1
  Scenario: ION_AQ41. aliquot service can return correct result for patient tissue molecular_id
    Given molecular id is "ION_AQ41_TsVrUploaded_MOI1"
    Then call aliquot GET service, field: "patient_id" for this sample_control should be: "ION_AQ41_TsVrUploaded"
    Then call aliquot GET service, field: "molecular_id" for this sample_control should be: "ION_AQ41_TsVrUploaded_MOI1"

  @ion_reporter_p1
  Scenario: ION_AQ42. aliquot service can return correct result for patient blood molecular_id
    Given molecular id is "ION_AQ42_BdVrUploaded_MOI1"
    Then call aliquot GET service, field: "patient_id" for this sample_control should be: "ION_AQ42_BdVrUploaded"
    Then call aliquot GET service, field: "molecular_id" for this sample_control should be: "ION_AQ42_BdVrUploaded_MOI1"

  @ion_reporter_p2
  Scenario Outline: ION_AQ43. aliquot service should only return VALID projected key-value pair
    Given molecular id is "<moi>"
    Then add projection: "<field1>" to url
    Then add projection: "<field2>" to url
    Then add projection: "bad_projection" to url
    Then call aliquot GET service, returns a message that includes "" with status "Success"
    Then each returned aliquot result should have 2 fields
    Then each returned aliquot result should have field "<field1>"
    Then each returned aliquot result should have field "<field2>"
    Examples:
      | moi                      | field1       | field2       |
      | SC_83OZJ                 | control_type | molecular_id |
      | ION_AQ43_TsUploaded_MOI1 | patient_id   | type         |

  @ion_reporter_p3
  Scenario: ION_AQ44. aliquot service should fail if an invalid key is projected
    Given molecular id is "SC_83OZJ"
    Then add projection: "non_existing_key" to url
    Then call aliquot GET service, returns a message that includes "No ABCMeta" with status "Failure"
#    Then all aliquot GET service, returns a message that includes "" with status "Success"

  @ion_reporter_p2
  Scenario: ION_AQ45. aliquot service should return 404 error if query a non-existing molecular_id
    Given molecular id is "NON_EXISTING_MOI"
    Then call aliquot GET service, returns a message that includes "Resource not found" with status "Failure"

  @ion_reporter_p3
  Scenario: ION_AQ46. aliquot service should fail if no molecular_id and parameter is provided
    Given molecular id is ""
    Then call aliquot GET service, returns a message that includes "all" with status "Failure"

  @ion_reporter_p2
  Scenario Outline: ION_AQ80. aliquot service should fail when user want to create new item using POST
    Given molecular id is "<moi>"
    Then call aliquot POST service, returns a message that includes "The method is not allowed for the requested URL" with status "Failure"
    Examples:
      | moi                     |
      | SC_GX4WV                |
      | ION_AQ80_TsShipped_MOI1 |

  @ion_reporter_p2
  Scenario Outline: ION_AQ81. aliquot service should fail when user want to delete item using DELETE
    Given molecular id is "<moi>"
    Then call aliquot DELETE service, returns a message that includes "The method is not allowed for the requested URL" with status "Failure"
    Examples:
      | moi                     |
      | SC_GX4WV                |
      | ION_AQ81_TsShipped_MOI1 |


