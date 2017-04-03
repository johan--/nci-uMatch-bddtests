#encoding: utf-8
@ion_reporter_aliquots
Feature: Tests for aliquot service in ion ecosystem

  @ion_reporter_p1
  Scenario: ION_AQ01. for sample control specimen, aliquot service will generate tsv and bai files and upload to S3, then update database
    Given molecular id is "NTC_MDA_OAFXP"
    And ir user authorization role is "SYSTEM"
    And file: "IR_TCWEV/NTC_MDA_OAFXP/SC_OAFXP_ANI1/test1.tsv" has been removed from S3 bucket
    And file: "IR_TCWEV/NTC_MDA_OAFXP/SC_OAFXP_ANI1/test1.json" has been removed from S3 bucket
    And file: "IR_TCWEV/NTC_MDA_OAFXP/SC_OAFXP_ANI1/dna.bai" has been removed from S3 bucket
    And file: "IR_TCWEV/NTC_MDA_OAFXP/SC_OAFXP_ANI1/cdna.bai" has been removed from S3 bucket
    Then add field: "analysis_id" value: "SC_OAFXP_ANI1" to message body
    Then add field: "site" value: "mda" to message body
    Then add field: "ion_reporter_id" value: "IR_TCWEV" to message body
    Then add field: "vcf_name" value: "test1.vcf" to message body
    Then add field: "dna_bam_name" value: "dna.bam" to message body
    Then add field: "cdna_bam_name" value: "cdna.bam" to message body
    Then add field: "qc_name" value: "QA.pdf" to message body
    When PUT to aliquot service, response includes "Item updated" with code "200"
    Then wait for "90" seconds
    When GET from aliquot service, response "" with code "200"
    Then field: "tsv_name" for this aliquot should be: "IR_TCWEV/NTC_MDA_OAFXP/SC_OAFXP_ANI1/test1.tsv"
    Then field: "dna_bai_name" for this aliquot should be: "IR_TCWEV/NTC_MDA_OAFXP/SC_OAFXP_ANI1/dna.bai"
    Then field: "cdna_bai_name" for this aliquot should be: "IR_TCWEV/NTC_MDA_OAFXP/SC_OAFXP_ANI1/cdna.bai"
    Then field: "analysis_id" for this aliquot should be: "SC_OAFXP_ANI1"
    Then field: "ion_reporter_id" for this aliquot should be: "IR_TCWEV"
    Then field: "filename" for this aliquot should be: "test1"
    Then field: "molecular_id" for this aliquot should be: "NTC_MDA_OAFXP"
    Then field: "report_status" for this aliquot should be: "FAILED"
    Then sample_control should not have field: "comments"
    And file: "IR_TCWEV/NTC_MDA_OAFXP/SC_OAFXP_ANI1/test1.tsv" should be available in S3
    And file: "IR_TCWEV/NTC_MDA_OAFXP/SC_OAFXP_ANI1/test1.json" should be available in S3
    And file: "IR_TCWEV/NTC_MDA_OAFXP/SC_OAFXP_ANI1/dna.bai" should be available in S3
    And file: "IR_TCWEV/NTC_MDA_OAFXP/SC_OAFXP_ANI1/cdna.bai" should be available in S3

  @ion_reporter_p1
  Scenario: ION_AQ02. for patient tissue specimen, aliquot service will generate tsv and bai files and upload to S3, then send variant files uploaded message to patient ecosystem once process done
    Given molecular id is "ION_AQ02_TsShipped_MOI1"
    Given patient id is "ION_AQ02_TsShipped"
    And ir user authorization role is "MDA_VARIANT_REPORT_SENDER"
    And file: "IR_TCWEV/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI1/test1.tsv" has been removed from S3 bucket
    And file: "IR_TCWEV/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI1/test1.json" has been removed from S3 bucket
    And file: "IR_TCWEV/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI1/dna.bai" has been removed from S3 bucket
    And file: "IR_TCWEV/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI1/cdna.bai" has been removed from S3 bucket
    And file: "IR_TCWEV/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI2/test1.tsv" has been removed from S3 bucket
    And file: "IR_TCWEV/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI2/test1.json" has been removed from S3 bucket
    And file: "IR_TCWEV/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI2/dna.bai" has been removed from S3 bucket
    And file: "IR_TCWEV/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI2/cdna.bai" has been removed from S3 bucket
    Then add field: "analysis_id" value: "ION_AQ02_TsShipped_ANI1" to message body
    Then add field: "site" value: "mda" to message body
    Then add field: "ion_reporter_id" value: "IR_TCWEV" to message body
    Then add field: "vcf_name" value: "test1.vcf" to message body
    Then add field: "dna_bam_name" value: "dna.bam" to message body
    Then add field: "cdna_bam_name" value: "cdna.bam" to message body
    Then add field: "qc_name" value: "10-10-2016.pdf" to message body
    When PUT to aliquot service, response includes "Item updated" with code "200"
    Then wait until patient variant report is updated
    Then wait for "15" seconds
    Then patient should have variant report (analysis_id: "ION_AQ02_TsShipped_ANI1")
    And this variant report field: "tsv_file_name" should be "test1.tsv"
    And file: "IR_TCWEV/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI1/test1.tsv" should be available in S3
    And file: "IR_TCWEV/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI1/dna.bai" should be available in S3
    And file: "IR_TCWEV/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI1/cdna.bai" should be available in S3
    Then add field: "analysis_id" value: "ION_AQ02_TsShipped_ANI2" to message body
    Then add field: "site" value: "mda" to message body
    Then add field: "ion_reporter_id" value: "IR_TCWEV" to message body
    Then add field: "vcf_name" value: "test1.vcf" to message body
    Then add field: "dna_bam_name" value: "dna.bam" to message body
    Then add field: "cdna_bam_name" value: "cdna.bam" to message body
    Then add field: "qc_name" value: "10-10-2016.pdf" to message body
    When PUT to aliquot service, response includes "Item updated" with code "200"
    Then wait until patient variant report is updated
    Then wait for "15" seconds
    Then patient should have variant report (analysis_id: "ION_AQ02_TsShipped_ANI2")
    And this variant report field: "tsv_file_name" should be "test1.tsv"
    And file: "IR_TCWEV/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI2/test1.tsv" should be available in S3
    And file: "IR_TCWEV/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI2/test1.json" should be available in S3
    And file: "IR_TCWEV/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI2/dna.bai" should be available in S3
    And file: "IR_TCWEV/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI2/cdna.bai" should be available in S3

  @ion_reporter_p1
  Scenario: ION_AQ03. for patient blood specimen, aliquot service will generate tsv and bai files and upload to S3, then send variant files uploaded message to patient ecosystem once process done
    Given molecular id is "ION_AQ03_BdShipped_BD_MOI1"
    Given patient id is "ION_AQ03_BdShipped"
    And ir user authorization role is "SYSTEM"
    And file: "IR_TCWEV/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI1/test1.tsv" has been removed from S3 bucket
    And file: "IR_TCWEV/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI1/test1.json" has been removed from S3 bucket
    And file: "IR_TCWEV/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI1/dna.bai" has been removed from S3 bucket
    And file: "IR_TCWEV/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI1/cdna.bai" has been removed from S3 bucket
    And file: "IR_TCWEV/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI2/test1.tsv" has been removed from S3 bucket
    And file: "IR_TCWEV/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI2/test1.json" has been removed from S3 bucket
    And file: "IR_TCWEV/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI2/dna.bai" has been removed from S3 bucket
    And file: "IR_TCWEV/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI2/cdna.bai" has been removed from S3 bucket
    Then add field: "analysis_id" value: "ION_AQ03_BdShipped_ANI1" to message body
    Then add field: "site" value: "mda" to message body
    Then add field: "ion_reporter_id" value: "IR_TCWEV" to message body
    Then add field: "vcf_name" value: "test1.vcf" to message body
    Then add field: "dna_bam_name" value: "dna.bam" to message body
    Then add field: "cdna_bam_name" value: "cdna.bam" to message body
    Then add field: "qc_name" value: "10-10-2016.pdf" to message body
    When PUT to aliquot service, response includes "Item updated" with code "200"
    Then wait until patient variant report is updated
    Then wait for "15" seconds
    Then patient should have variant report (analysis_id: "ION_AQ03_BdShipped_ANI1")
    And this variant report field: "tsv_file_name" should be "test1.tsv"
    And file: "IR_TCWEV/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI1/test1.tsv" should be available in S3
    And file: "IR_TCWEV/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI1/dna.bai" should be available in S3
    And file: "IR_TCWEV/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI1/cdna.bai" should be available in S3
    Then add field: "analysis_id" value: "ION_AQ03_BdShipped_ANI2" to message body
    Then add field: "site" value: "mda" to message body
    Then add field: "ion_reporter_id" value: "IR_TCWEV" to message body
    Then add field: "vcf_name" value: "test1.vcf" to message body
    Then add field: "dna_bam_name" value: "dna.bam" to message body
    Then add field: "cdna_bam_name" value: "cdna.bam" to message body
    Then add field: "qc_name" value: "10-10-2016.pdf" to message body
    When PUT to aliquot service, response includes "Item updated" with code "200"
    Then wait until patient variant report is updated
    Then wait for "15" seconds
    Then patient should have variant report (analysis_id: "ION_AQ03_BdShipped_ANI2")
    And this variant report field: "tsv_file_name" should be "test1.tsv"
    And file: "IR_TCWEV/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI2/test1.tsv" should be available in S3
    And file: "IR_TCWEV/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI2/test1.json" should be available in S3
    And file: "IR_TCWEV/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI2/dna.bai" should be available in S3
    And file: "IR_TCWEV/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI2/cdna.bai" should be available in S3

  @ion_reporter_p2
  Scenario: ION_AQ04.  if no vcf file passed in, patient status will not change to TISSUE_VARIANT_REPORT_STATUS_RECEIVED
    Given molecular id is "ION_AQ04_TsShipped_MOI1"
    Given patient id is "ION_AQ04_TsShipped"
    Then add field: "analysis_id" value: "ION_AQ04_TsShipped_ANI1" to message body
    Then add field: "site" value: "mda" to message body
    Then add field: "ion_reporter_id" value: "IR_TCWEV" to message body
    Then add field: "vcf_name" value: "" to message body
    Then add field: "dna_bam_name" value: "IR_TCWEV/ION_AQ04_TsShipped_MOI1/ION_AQ04_TsShipped_ANI1/dna.bam" to message body
    When PUT to aliquot service, response includes "Item updated" with code "200"
    Then wait for "30" seconds
    Then patient status should change to "TISSUE_NUCLEIC_ACID_SHIPPED"

  @ion_reporter_p3
  Scenario: ION_AQ05. extra key-value pair in the message body should NOT fail
    Given molecular id is "NTC_MDA_BKWJR"
    Then add field: "analysis_id" value: "SC_BKWJR_ANI1" to message body
    Then add field: "site" value: "mda" to message body
    Then add field: "ion_reporter_id" value: "IR_TCWEV" to message body
    Then add field: "vcf_name" value: "test1.vcf" to message body
    Then add field: "dna_bam_name" value: "dna.bam" to message body
    Then add field: "cdna_bam_name" value: "cdna.bam" to message body
    Then add field: "qc_name" value: "10-10-2016.pdf" to message body
    Then add field: "extra_info" value: "a comment" to message body
    When PUT to aliquot service, response includes "Item updated" with code "200"

  @ion_reporter_p1
  Scenario: ION_AQ06. aliquot service can process zip vcf properly
    Given molecular id is "ION_AQ06_TsShipped_MOI1"
    Given patient id is "ION_AQ06_TsShipped"
    And ir user authorization role is "MDA_VARIANT_REPORT_SENDER"
    And file: "IR_TCWEV/ION_AQ06_TsShipped_MOI1/ION_AQ06_TsShipped_ANI1/test1.vcf" has been removed from S3 bucket
    And file: "IR_TCWEV/ION_AQ06_TsShipped_MOI1/ION_AQ06_TsShipped_ANI1/test1.tsv" has been removed from S3 bucket
    And file: "IR_TCWEV/ION_AQ06_TsShipped_MOI1/ION_AQ06_TsShipped_ANI1/test1.json" has been removed from S3 bucket
    Then add field: "analysis_id" value: "ION_AQ06_TsShipped_ANI1" to message body
    Then add field: "site" value: "mda" to message body
    Then add field: "ion_reporter_id" value: "IR_TCWEV" to message body
    Then add field: "zip_name" value: "test1.zip" to message body
    When PUT to aliquot service, response includes "Item updated" with code "200"
    Then wait until patient is updated
    Then patient status should change to "TISSUE_VARIANT_REPORT_RECEIVED"
    Then patient should have variant report (analysis_id: "ION_AQ06_TsShipped_ANI1")
    And this variant report field: "tsv_file_name" should be "test1.tsv"
    And file: "IR_TCWEV/ION_AQ06_TsShipped_MOI1/ION_AQ06_TsShipped_ANI1/test1.vcf" should be available in S3
    And file: "IR_TCWEV/ION_AQ06_TsShipped_MOI1/ION_AQ06_TsShipped_ANI1/test1.tsv" should be available in S3
    And file: "IR_TCWEV/ION_AQ06_TsShipped_MOI1/ION_AQ06_TsShipped_ANI1/test1.json" should be available in S3

  @ion_reporter_p2
  Scenario Outline: ION_AQ07. aliquot service can handle ":" in file name properly
    Given patient id is "<patient_id>"
    Given molecular id is "<patient_id>_MOI1"
    And ir user authorization role is "MDA_VARIANT_REPORT_SENDER"
    And file: "IR_TCWEV/<patient_id>_MOI1/<patient_id>_ANI1/<vcf_name_for_deletion>" has been removed from S3 bucket
    And file: "IR_TCWEV/<patient_id>_MOI1/<patient_id>_ANI1/<file_name>.tsv" has been removed from S3 bucket
    And file: "IR_TCWEV/<patient_id>_MOI1/<patient_id>_ANI1/<file_name>.json" has been removed from S3 bucket
    Then add field: "analysis_id" value: "<patient_id>_ANI1" to message body
    Then add field: "site" value: "mda" to message body
    Then add field: "ion_reporter_id" value: "IR_TCWEV" to message body
    Then add field: "<vcf_name_field>" value: "<vcf_name>" to message body
    When PUT to aliquot service, response includes "Item updated" with code "200"
    Then wait until patient is updated
    Then patient status should change to "TISSUE_VARIANT_REPORT_RECEIVED"
    Then patient should have variant report (analysis_id: "<patient_id>_ANI1")
    And this variant report field: "tsv_file_name" should be "<file_name>.tsv"
    And file: "IR_TCWEV/<patient_id>_MOI1/<patient_id>_ANI1/<file_name>.vcf" should be available in S3
    And file: "IR_TCWEV/<patient_id>_MOI1/<patient_id>_ANI1/<file_name>.tsv" should be available in S3
    And file: "IR_TCWEV/<patient_id>_MOI1/<patient_id>_ANI1/<file_name>.json" should be available in S3
    Examples:
      | patient_id          | file_name           | vcf_name_field | vcf_name                | vcf_name_for_deletion   |
      | ION_AQ07_TsShipped1 | 2017-02-07_09:18:25 | vcf_name       | 2017-02-07_09:18:25.vcf | no_need_delete          |
      | ION_AQ07_TsShipped2 | 2017-02-07_10:18:25 | zip_name       | 2017-02-07_10:18:25.zip | 2017-02-07_10:18:25.vcf |

  @ion_reporter_p2
  Scenario Outline: ION_AQ08. aliquot and patient services can handle patient variant report properly when bam file come before vcf file
#  Example 1: No ani => bam with new ani | Has ani but no pending vr => vcf with same ani
#  Example 2: Has ani but no pending vr => bam with same ani | Has ani but no pending vr => vcf with new ani
#  Example 3: Has ani but no pending vr => bam with new ani
#  Example 4: Has pending vr => bam with same ani
#  Example 5: Has pending vr => bam with new ani
    Given patient id is "<patient_id>"
    Given molecular id is "<patient_id>_MOI1"
    And ir user authorization role is "SYSTEM"
    Then add field: "analysis_id" value: "<ani1>" to message body
    Then add field: "site" value: "mda" to message body
    Then add field: "ion_reporter_id" value: "IR_TCWEV" to message body
    Then add field: "dna_bam_name" value: "dna.bam" to message body
    Then add field: "patient_id" value: "<patient_id>" to message body
    When PUT to aliquot service, response includes "Item updated" with code "200"
    Then wait until patient event is updated
    Then wait for "5" seconds
    Then patient status should change to "<status1>"
    And patient should "<have>" variant report (analysis_id: "<ani1>")
    And patient should have variant file received event with file_name "dna.bam" analysis_id "<ani1>"
    Then remove field: "dna_bam_name" from message body
    And add field: "zip_name" value: "test1.zip" to message body
    Then add field: "analysis_id" value: "<ani2>" to message body
    When PUT to aliquot service, response includes "Item updated" with code "200"
    Then wait until patient is updated
    Then patient status should change to "TISSUE_VARIANT_REPORT_RECEIVED"
    Then patient should have variant report (analysis_id: "<ani2>")
    And this variant report field: "tsv_file_name" should be "test1.tsv"
    And this variant report field: "dna_bam_name" should be "<bam_name>"
    Examples:
      | patient_id             | ani1                        | status1                        | have     | ani2                        | bam_name |
      | ION_AQ08_TsShipped     | ION_AQ08_TsShipped_ANI1     | TISSUE_NUCLEIC_ACID_SHIPPED    | not have | ION_AQ08_TsShipped_ANI1     | dna.bam  |
      | ION_AQ08_CdnaUploaded1 | ION_AQ08_CdnaUploaded1_ANI1 | TISSUE_NUCLEIC_ACID_SHIPPED    | not have | ION_AQ08_CdnaUploaded1_ANI2 | null     |
      | ION_AQ08_CdnaUploaded2 | ION_AQ08_CdnaUploaded2_ANI2 | TISSUE_NUCLEIC_ACID_SHIPPED    | not have | ION_AQ08_CdnaUploaded2_ANI2 | dna.bam  |
      | ION_AQ08_TsVrUploaded1 | ION_AQ08_TsVrUploaded1_ANI1 | TISSUE_VARIANT_REPORT_RECEIVED | have     | ION_AQ08_TsVrUploaded1_ANI1 | dna.bam  |
      | ION_AQ08_TsVrUploaded2 | ION_AQ08_TsVrUploaded2_ANI2 | TISSUE_VARIANT_REPORT_RECEIVED | not have | ION_AQ08_TsVrUploaded2_ANI2 | dna.bam  |

  @ion_reporter_p1
  Scenario: ION_AQ09a aliquot service can handle vcf version 5.2 properly for patient
    Given patient id is "ION_AQ09_TsShipped"
    Given molecular id is "ION_AQ09_TsShipped_MOI1"
    And ir user authorization role is "MDA_VARIANT_REPORT_SENDER"
    Then add field: "analysis_id" value: "ION_AQ09_TsShipped_ANI1" to message body
    Then add field: "site" value: "mda" to message body
    Then add field: "ion_reporter_id" value: "IR_TCWEV" to message body
    Then add field: "vcf_name" value: "test1.vcf" to message body
    When PUT to aliquot service, response includes "Item updated" with code "200"
    Then wait until patient is updated
    Then patient status should change to "TISSUE_VARIANT_REPORT_RECEIVED"
    Then patient should have variant report (analysis_id: "ION_AQ09_TsShipped_ANI1")
    And this variant report field: "torrent_variant_caller_version" should be "5.2-25"
    And this variant report field: "mappedFusionPanelReads" should be "1406678.0"
    And this variant report oncomine_control pool "1" sum should be "449632.5"
    And this variant report oncomine_control pool "2" sum should be "957045.5"

  Scenario: ION_AQ09b aliquot service can handle vcf version 5.2 properly for sample control
    Given molecular id is "NTC_MDA_VNTE5"
    And ir user authorization role is "SYSTEM"
    Then add field: "analysis_id" value: "NTC_MDA_VNTE5_ANI1" to message body
    Then add field: "site" value: "mda" to message body
    Then add field: "ion_reporter_id" value: "IR_TCWEV" to message body
    Then add field: "vcf_name" value: "test1.vcf" to message body
    When PUT to aliquot service, response includes "Item updated" with code "200"
    Then wait for "90" seconds
    When GET from aliquot service, response "" with code "200"
    Then field: "tsv_name" for this aliquot should be: "IR_TCWEV/NTC_MDA_VNTE5/NTC_MDA_VNTE5_ANI1/test1.tsv"
    Then field: "torrent_variant_caller_version" for this aliquot should be: "5.2-25"
    Then field: "mappedFusionPanelReads" for this aliquot should be: "1406678"
    Then field: "pool1Sum" for this aliquot should be: "449632.5"
    Then field: "pool2Sum" for this aliquot should be: "957045.5"


  @ion_reporter_p2
  Scenario: ION_AQ20. for sample control specimen, if the files passed in are not in that path, aliquot service will not update database
    #there is no file in S3 for this sample control
    Given molecular id is "NTC_MDA_Q5E0X"
    Then add field: "analysis_id" value: "SC_Q5E0X_ANI1" to message body
    Then add field: "site" value: "mda" to message body
    Then add field: "ion_reporter_id" value: "IR_TCWEV" to message body
    Then add field: "vcf_name" value: "test1.vcf" to message body
    Then add field: "dna_bam_name" value: "dna.bam" to message body
    Then add field: "cdna_bam_name" value: "cdna.bam" to message body
    Then add field: "qc_name" value: "10-10-2016.pdf" to message body
    When PUT to aliquot service, response includes "Item updated" with code "200"
    Then wait for "30" seconds
    When GET from aliquot service, response "" with code "200"
    Then field: "tsv_name" for this aliquot should be: "null"
    Then field: "dna_bai_name" for this aliquot should be: "null"
    Then field: "cdna_bai_name" for this aliquot should be: "null"

  @ion_reporter_p2
  Scenario: ION_AQ21. for sample control specimen, if the file conversion failed, aliquot service will not update database
    #the files in S3 for this patient are invalid files (random text files with fake name)
    Given molecular id is "SC_MOCHA_M4UAF"
    Then add field: "analysis_id" value: "SC_M4UAF_ANI1" to message body
    Then add field: "site" value: "mocha" to message body
    Then add field: "ion_reporter_id" value: "IR_TCWEV" to message body
    Then add field: "vcf_name" value: "test1.vcf" to message body
    Then add field: "dna_bam_name" value: "dna.bam" to message body
    Then add field: "cdna_bam_name" value: "cdna.bam" to message body
    Then add field: "qc_name" value: "10-10-2016.pdf" to message body
    When PUT to aliquot service, response includes "Item updated" with code "200"
    Then wait for "30" seconds
    When GET from aliquot service, response "" with code "200"
    #don't check tsv, because any text file can be converted to tsv file
#    Then field: "tsv_name" for this sample control should be: "null" within 1 seconds
    Then field: "dna_bai_name" for this aliquot should be: "null"
    Then field: "cdna_bai_name" for this aliquot should be: "null"

#  @ion_reporter_p2
#  Scenario: ION_AQ22. for sample control specimen, if the file uploading fails, aliquot service will not update database

  @ion_reporter_p2
  Scenario: ION_AQ23. for patient specimen, if the files passed in are not in that path, aliquot service will not send message to patient ecosystem
    #there is no file in S3 for this patient
    Given molecular id is "ION_AQ23_TsShipped_MOI1"
    Given patient id is "ION_AQ23_TsShipped"
    Then add field: "analysis_id" value: "ION_AQ23_TsShipped_ANI1" to message body
    Then add field: "site" value: "mocha" to message body
    Then add field: "ion_reporter_id" value: "IR_TCWEV" to message body
    Then add field: "vcf_name" value: "test1.vcf" to message body
    Then add field: "dna_bam_name" value: "dna.bam" to message body
    Then add field: "cdna_bam_name" value: "cdna.bam" to message body
    Then add field: "qc_name" value: "10-10-2016.pdf" to message body
    When PUT to aliquot service, response includes "Item updated" with code "200"
    Then wait for "30" seconds
    Then patient status should change to "TISSUE_NUCLEIC_ACID_SHIPPED"

#  @ion_reporter_p2
#  Scenario: ION_AQ24. for patient specimen, if the file conversion failed, aliquot service will not send message to patient ecosystem
#    #the files in S3 for this patient are invalid files (random text files with fake name)
#    Given molecular id is "ION_AQ24_TsShipped_MOI1"
#    Given patient id is "ION_AQ24_TsShipped"
#    Then add field: "analysis_id" value: "ION_AQ24_TsShipped_ANI1" to message body
#    Then add field: "site" value: "mocha" to message body
#    Then add field: "ion_reporter_id" value: "IR_TCWEV" to message body
#    Then add field: "vcf_name" value: "IR_TCWEV/ION_AQ24_TsShipped_MOI1/ION_AQ24_TsShipped_ANI1/test1.vcf" to message body
#    Then add field: "dna_bam_name" value: "IR_TCWEV/ION_AQ24_TsShipped_MOI1/ION_AQ24_TsShipped_ANI1/dna.bam" to message body
#    Then add field: "cdna_bam_name" value: "IR_TCWEV/ION_AQ24_TsShipped_MOI1/ION_AQ24_TsShipped_ANI1/cdna.bam" to message body
#    Then add field: "qc_name" value: "IR_TCWEV/ION_AQ24_TsShipped_MOI1/ION_AQ24_TsShipped_ANI1/10-10-2016.pdf" to message body
#    Then call aliquot PUT service, returns a message that includes "Item updated" with status "Success"
#    Then patient field: "current_status" should have value: "TISSUE_NUCLEIC_ACID_SHIPPED" after 30 seconds

#  @ion_reporter_p2
#  Scenario: ION_AQ25. for patient specimen, if the file uploading fails, aliquot service will not send message to patient ecosystem

  @ion_reporter_p3
  Scenario: ION_AQ26. if the molecular id is neither a sample control nor patient molecular id, aliquot PUT service should fail
    Given molecular id is "NON_EXISTING_MOI"
    Then add field: "analysis_id" value: "NON_EXISTING_MOI_ANI1" to message body
    Then add field: "site" value: "mda" to message body
    Then add field: "ion_reporter_id" value: "IR_TCWEV" to message body
    Then add field: "vcf_name" value: "test1.vcf" to message body
    Then add field: "dna_bam_name" value: "dna.bam" to message body
    Then add field: "cdna_bam_name" value: "cdna.bam" to message body
    Then add field: "qc_name" value: "10-10-2016.pdf" to message body
    When PUT to aliquot service, response includes "not found" with code "404"


  @ion_reporter_p1
  Scenario: ION_AQ40. aliquot service can return correct result for sample control molecular_id
    Given molecular id is "SC_MOCHA_9LL0Q"
    Then call aliquot GET service, field: "site" for this sample_control should be: "mocha"
    Then call aliquot GET service, field: "control_type" for this sample_control should be: "positive"
    Then call aliquot GET service, field: "date_molecular_id_created" for this sample_control should be: "2016-10-12 21:19:50.001799"

  @ion_reporter_p1
  Scenario: ION_AQ41. aliquot service can return correct result for patient tissue molecular_id
    Given molecular id is "ION_AQ41_TsVrUploaded_MOI1"
    Then call aliquot GET service, field: "patient_id" for this sample_control should be: "ION_AQ41_TsVrUploaded"
    Then call aliquot GET service, field: "molecular_id" for this sample_control should be: "ION_AQ41_TsVrUploaded_MOI1"

  @ion_reporter_p1
  Scenario: ION_AQ42. aliquot service can return correct result for patient blood molecular_id
    Given molecular id is "ION_AQ42_BdVrUploaded_BD_MOI1"
    Then call aliquot GET service, field: "patient_id" for this sample_control should be: "ION_AQ42_BdVrUploaded"
    Then call aliquot GET service, field: "molecular_id" for this sample_control should be: "ION_AQ42_BdVrUploaded_BD_MOI1"

  @ion_reporter_p2
  Scenario Outline: ION_AQ43. aliquot service should only return VALID projected key-value pair and "molecular_id_type" field
    Given molecular id is "<moi>"
    Then add projection: "<field1>" to url
    Then add projection: "<field2>" to url
    Then add projection: "bad_projection" to url
    When GET from aliquot service, response "" with code "200"
    Then each returned aliquot result should have 4 fields
    Then each returned aliquot result should have field "<field1>"
    Then each returned aliquot result should have field "<field2>"
    Then each returned aliquot result should have field "molecular_id_type"
    Then each returned aliquot result should have field "editable"
    Examples:
      | moi            | field1       | field2       |
      | SC_MOCHA_6Y4FV | control_type | molecular_id |
      #projection is not supported when query patient molecular id
#      | ION_AQ43_TsVrUploaded_MOI1 | patient_id   | shipment_type |

  @ion_reporter_p3
  Scenario: ION_AQ44. aliquot service should fail if an invalid key is projected
    Given molecular id is "NTC_MDA_4CPNX"
    Then add projection: "non_existing_key" to url
    When GET from aliquot service, response "invalid projection key" with code "404"

  @ion_reporter_p3
  Scenario: ION_AQ45. aliquot service should return 404 error if query a non-existing molecular_id
    Given molecular id is "NON_EXISTING_MOI"
    When GET from aliquot service, response "not found" with code "404"

  @ion_reporter_p3
  Scenario: ION_AQ46. aliquot service should fail if no molecular_id and parameter is provided
    Given molecular id is ""
    When GET from aliquot service, response "not found" with code "404"


  ############## aliquot/file tests ###########
  ########## Note 1: Though aliquot/file doesn't check if analysis id exist, these test will not use existing analysis_id
  ##########         because both UI uploader and Match uploader forbid upload file for existing analysis id
  ########## Note 2: Though aliquot/file doesn't check if ion_reporter_id and molecular_id belong to same site
  ##########         these test will not use ion_reporter_id and molecular_id which belong to different site
  ##########         because both UI uploader and Match uploader do site check
  ########## Note 3: Though aliquot/file doesn't check if ion_reporter_id exist, test will not use non existing ion_reporter_id
  ##########         because neither UI uploader nor Match uploader will use non existing ion_reporter_id
  ########## Note 4: Though aliquot/file doesn't check if uploader try to send vcf file with new name to ani which have variant report uploaded
  ##########         it will not be tested, because UI uploader only allow upload file to NEW analysis id,
  ##########         Match Uploader alway use same file name for same analysis id
  @ion_reporter_p1
  Scenario Outline: ION_AQ61. aliquot/file service return 409 if file exists or variant report confirmed
    Given ion_reporter_id is "<ion_id>"
    And molecular id is "<moi>"
    And analysis id is "<ani>"
    And aliquot file name is "<file>"
    When POST to aliquot file service with request_presigned_url "true", response code is "409"
    When POST to aliquot file service with request_presigned_url "false", response code is "409"
    Examples:
      | ion_id                | moi                           | ani                        | file      |
      | IR_TCWEV              | NTC_MDA_NPID3                 | SC_NPID3_ANI1              | test1.vcf |
      | bdd_test_ion_reporter | ION_AQ41_TsVrUploaded_MOI1    | ION_AQ41_TsVrUploaded_ANI1 | test1.vcf |
      | bdd_test_ion_reporter | ION_AQ42_BdVrUploaded_BD_MOI1 | ION_AQ42_BdVrUploaded_ANI1 | test1.vcf |
      | bdd_test_ion_reporter | ION_AQ61_VrConfirmed_MOI1     | ION_AQ61_VrConfirmed_ANI1  | test1.vcf |

  @ion_reporter_p2
  Scenario Outline: ION_AQ62. aliquot/file service return 404 if information in url is not correct
    Given ion_reporter_id is "<ion_id>"
    And molecular id is "<moi>"
    And analysis id is "<ani>"
    And aliquot file name is "<file>"
    When POST to aliquot file service with request_presigned_url "true", response code is "404"
    When POST to aliquot file service with request_presigned_url "false", response code is "404"
    Examples:
      | ion_id                | moi       | ani                        | file      |
      | bdd_test_ion_reporter | non_exist | ION_AQ41_TsVrUploaded_ANI2 | test2.vcf |

  @ion_reporter_p1
  Scenario Outline: ION_AQ63. aliquot/file service return correct result if file doesn't exist
    Given ion_reporter_id is "<ion_id>"
    And molecular id is "<moi>"
    And analysis id is "<ani>"
    And aliquot file name is "<file>"
    When POST to aliquot file service with request_presigned_url "true", response code is "200"
    Then returned aliquot file message should has correct presigned information
    When POST to aliquot file service with request_presigned_url "false", response code is "200"
    Then returned aliquot file message should has field "<rpu_false_field>"
    Examples:
      | ion_id   | moi                           | ani                        | file      | rpu_false_field                 |
      | IR_TCWEV | PCC_MDA_GP6TQ                 | SC_GP6TQ_ANI1              | test2.vcf | control_type                    |
      | IR_TCWEV | ION_AQ63_TsShipped_MOI1       | ION_AQ63_TsShipped_ANI1    | test2.vcf | patient_id                      |
      | IR_TCWEV | ION_AQ41_TsVrUploaded_MOI1    | ION_AQ41_TsVrUploaded_ANI2 | test2.vcf | eligible_for_new_variant_report |
      | IR_TCWEV | ION_AQ63_BdShipped_BD_MOI1    | ION_AQ63_BdShipped_ANI2    | test2.vcf | analysis_ids                    |
      | IR_TCWEV | ION_AQ42_BdVrUploaded_BD_MOI1 | ION_AQ42_BdVrUploaded_ANI2 | test2.vcf | molecular_id                    |

  @ion_reporter_p2
  Scenario Outline: ION_AQ80. aliquot service should fail when user want to create new item using POST
    Given molecular id is "<moi>"
    When POST to aliquot service, response includes "The method is not allowed" with code "405"
    Examples:
      | moi                     |
      | SC_MOCHA_N44B1          |
      | ION_AQ80_TsShipped_MOI1 |

  @ion_reporter_p2
  Scenario Outline: ION_AQ81. aliquot service should fail when user want to delete item using DELETE
    Given molecular id is "<moi>"
    When DELETE to aliquot service, response includes "The method is not allowed" with code "405"
    Examples:
      | moi                     |
      | SC_MOCHA_K7IO0          |
      | ION_AQ81_TsShipped_MOI1 |

  @ion_reporter_p1_not_done
  Scenario Outline: ION_AQ90. adult match aliquot service can gerneate bai file for bam file properly
    #notice the test data must come from adult match not from ped match, this will make sure this
    #adult match aliquot service do NOT check ped match database for id existence
    Given molecular id is "<moi>"
    And file: "BDD/<moi>/<ani>/dna.bai" has been removed from adult match S3 bucket
    And file: "BDD/<moi>/<ani>/cdna.bai" has been removed from adult match S3 bucket
    Then add field: "analysis_id" value: "<ani>" to message body
    Then add field: "site" value: "<site>" to message body
    Then add field: "ion_reporter_id" value: "BDD" to message body
    Then add field: "dna_bam_name" value: "dna.bam" to message body
    Then add field: "cdna_bam_name" value: "cdna.bam" to message body
    When PUT to adult match aliquot service, response includes "Item updated" with code "200"
    Then wait for "30" seconds
    And file: "BDD/<moi>/<ani>/dna.bai" should be available in adult match S3
    And file: "BDD/<moi>/<ani>/cdna.bai" should be available in adult match S3
    Examples:
      | moi                 | ani                     | site  |
      | Sample-1749-18-DNA  | Sample-1749-18-DNA_ANI1 | mocha |
      | SampleControl_MoCha_30 | SampleControl_MoCha_30_ANI                     | mocha |

  @ion_reporter_p2_not_done
  Scenario Outline: ION_AQ91. adult match aliquot service should return error if bam file does not exist
    #
    Given molecular id is "<moi>"
    Then add field: "analysis_id" value: "<ani>" to message body
    Then add field: "site" value: "<site>" to message body
    Then add field: "ion_reporter_id" value: "BDD" to message body
    Then add field: "dna_bam_name" value: "dna.bam" to message body
    Then add field: "cdna_bam_name" value: "cdna.bam" to message body
    When PUT to adult match aliquot service, response includes "Item updated" with code "400"
    Examples:
      | moi                  | ani | site |
      | one_file_doesnt_exis |     |      |
      | two_files_dont_exist |     |      |