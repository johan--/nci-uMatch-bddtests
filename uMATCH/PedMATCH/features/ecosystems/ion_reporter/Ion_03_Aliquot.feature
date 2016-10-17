#encoding: utf-8
@ion_reporter_reporters
Feature: Tests for aliquot service in ion ecosystem

  @ion_reporter_p1
  Scenario: ION_AQ01. for sample control specimen, aliquot service will generate tsv and bai files and upload to S3, then update database
    Given molecular id is "SC_OAFXP"
    Then add field: "analysis_id" value: "SC_OAFXP_ANI1" to message body
    Then add field: "site" value: "mda" to message body
    Then add field: "ion_reporter_id" value: "IR_TCWEV" to message body
    Then add field: "vcf_name" value: "IR_TCWEV/SC_OAFXP/SC_OAFXP_ANI1/test1.vcf" to message body
    Then add field: "dna_bam_name" value: "IR_TCWEV/SC_OAFXP/SC_OAFXP_ANI1/dna.bam" to message body
    Then add field: "cdna_bam_name" value: "IR_TCWEV/SC_OAFXP/SC_OAFXP_ANI1/cdna.bam" to message body
    Then add field: "qc_name" value: "IR_TCWEV/SC_OAFXP/SC_OAFXP_ANI1/QA.pdf" to message body
    Then call aliquot PUT service, returns a message that includes "Item updated" with status "Success"
    Then wait for "30" seconds
    Then call aliquot GET service, returns a message that includes "" with status "Success"
    Then field: "tsv_name" for this aliquot should be: "IR_TCWEV/SC_OAFXP/SC_OAFXP_ANI1/test1.tsv"
    Then field: "dna_bai_name" for this aliquot should be: "IR_TCWEV/SC_OAFXP/SC_OAFXP_ANI1/dna.bai"
    Then field: "cdna_bai_name" for this aliquot should be: "IR_TCWEV/SC_OAFXP/SC_OAFXP_ANI1/cdna.bai"
    Then field: "status" for this aliquot variant_report should be: "PASSED"
    Then field: "analysis_id" for this aliquot variant_report should be: "SC_OAFXP_ANI1"
    Then field: "ion_reporter_id" for this aliquot variant_report should be: "IR_TCWEV"
    Then field: "filename" for this aliquot variant_report should be: "test1"
    Then field: "molecular_id" for this aliquot variant_report should be: "SC_OAFXP"
    And file: "IR_TCWEV/SC_OAFXP/SC_OAFXP_ANI1/test1.tsv" should be available in S3
    And file: "IR_TCWEV/SC_OAFXP/SC_OAFXP_ANI1/test1.json" should be available in S3
    And file: "IR_TCWEV/SC_OAFXP/SC_OAFXP_ANI1/dna.bai" should be available in S3
    And file: "IR_TCWEV/SC_OAFXP/SC_OAFXP_ANI1/cdna.bai" should be available in S3

  @ion_reporter_p1
  Scenario: ION_AQ02. for patient tissue specimen, aliquot service will generate tsv and bai files and upload to S3, then send variant files uploaded message to patient ecosystem once process done
    Given molecular id is "ION_AQ02_TsShipped_MOI1"
    Given patient id is "ION_AQ02_TsShipped"
    Then add field: "analysis_id" value: "ION_AQ02_TsShipped_ANI1" to message body
    Then add field: "site" value: "mda" to message body
    Then add field: "ion_reporter_id" value: "IR_TCWEV" to message body
    Then add field: "vcf_name" value: "IR_TCWEV/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI1/test1.vcf" to message body
    Then add field: "dna_bam_name" value: "IR_TCWEV/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI1/dna.bam" to message body
    Then add field: "cdna_bam_name" value: "IR_TCWEV/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI1/cdna.bam" to message body
    Then add field: "qc_name" value: "IR_TCWEV/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI1/10-10-2016.pdf" to message body
    Then call aliquot PUT service, returns a message that includes "Item updated" with status "Success"
    Then patient should have variant report (analysis_id: "ION_AQ02_TsShipped_ANI1") within 30 seconds
    And this variant report has value: "test1.tsv" in field: "tsv_file_name"
    And file: "IR_TCWEV/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI1/test1.tsv" should be available in S3
    And file: "IR_TCWEV/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI1/dna.bai" should be available in S3
    And file: "IR_TCWEV/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI1/cdna.bai" should be available in S3
    Then add field: "analysis_id" value: "ION_AQ02_TsShipped_ANI2" to message body
    Then add field: "site" value: "mda" to message body
    Then add field: "ion_reporter_id" value: "IR_TCWEV" to message body
    Then add field: "vcf_name" value: "IR_TCWEV/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI2/test1.vcf" to message body
    Then add field: "dna_bam_name" value: "IR_TCWEV/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI2/dna.bam" to message body
    Then add field: "cdna_bam_name" value: "IR_TCWEV/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI2/cdna.bam" to message body
    Then add field: "qc_name" value: "IR_TCWEV/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI2/10-10-2016.pdf" to message body
    Then call aliquot PUT service, returns a message that includes "ION_AQ02_TsShipped_ANI2" with status "Success"
    Then patient should have variant report (analysis_id: "ION_AQ02_TsShipped_ANI2") within 30 seconds
    And this variant report has value: "test1.tsv" in field: "tsv_file_name"
    And file: "IR_TCWEV/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI2/test1.tsv" should be available in S3
    And file: "IR_TCWEV/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI2/dna.bai" should be available in S3
    And file: "IR_TCWEV/ION_AQ02_TsShipped_MOI1/ION_AQ02_TsShipped_ANI2/cdna.bai" should be available in S3

  @ion_reporter_p1
  Scenario: ION_AQ03. for patient blood specimen, aliquot service will generate tsv and bai files and upload to S3, then send variant files uploaded message to patient ecosystem once process done
    Given molecular id is "ION_AQ03_BdShipped_BD_MOI1"
    Given patient id is "ION_AQ03_BdShipped"
    Then add field: "analysis_id" value: "ION_AQ03_BdShipped_ANI1" to message body
    Then add field: "site" value: "mda" to message body
    Then add field: "ion_reporter_id" value: "IR_TCWEV" to message body
    Then add field: "vcf_name" value: "IR_TCWEV/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI1/test1.vcf" to message body
    Then add field: "dna_bam_name" value: "IR_TCWEV/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI1/dna.bam" to message body
    Then add field: "cdna_bam_name" value: "IR_TCWEV/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI1/cdna.bam" to message body
    Then add field: "qc_name" value: "IR_TCWEV/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI1/10-10-2016.pdf" to message body
    Then call aliquot PUT service, returns a message that includes "Item updated" with status "Success"
    Then patient should have variant report (analysis_id: "ION_AQ03_BdShipped_ANI1") within 30 seconds
    And this variant report has value: "test1.tsv" in field: "tsv_file_name"
    And file: "IR_TCWEV/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI1/test1.tsv" should be available in S3
    And file: "IR_TCWEV/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI1/dna.bai" should be available in S3
    And file: "IR_TCWEV/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI1/cdna.bai" should be available in S3
    Then add field: "analysis_id" value: "ION_AQ03_BdShipped_ANI2" to message body
    Then add field: "site" value: "mda" to message body
    Then add field: "ion_reporter_id" value: "IR_TCWEV" to message body
    Then add field: "vcf_name" value: "IR_TCWEV/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI2/test1.vcf" to message body
    Then add field: "dna_bam_name" value: "IR_TCWEV/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI2/dna.bam" to message body
    Then add field: "cdna_bam_name" value: "IR_TCWEV/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI2/cdna.bam" to message body
    Then add field: "qc_name" value: "IR_TCWEV/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI2/10-10-2016.pdf" to message body
    Then call aliquot PUT service, returns a message that includes "ION_AQ03_BdShipped_ANI2" with status "Success"
    Then patient should have variant report (analysis_id: "ION_AQ03_BdShipped_ANI2") within 30 seconds
    And this variant report has value: "test1.tsv" in field: "tsv_file_name"
    And file: "IR_TCWEV/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI2/test1.tsv" should be available in S3
    And file: "IR_TCWEV/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI2/dna.bai" should be available in S3
    And file: "IR_TCWEV/ION_AQ03_BdShipped_BD_MOI1/ION_AQ03_BdShipped_ANI2/cdna.bai" should be available in S3

  @ion_reporter_p3
  Scenario Outline: ION_AQ04. aliquot service will return error if any file value(vcf, bam, qc) is missing
    Given molecular id is "<moi>"
    Then add field: "analysis_id" value: "<ani>" to message body
    Then add field: "site" value: "mda" to message body
    Then add field: "ion_reporter_id" value: "IR_TCWEV" to message body
    Then add field: "vcf_name" value: "<vcf>" to message body
    Then add field: "dna_bam_name" value: "<dna_bam>" to message body
    Then call aliquot PUT service, returns a message that includes "missing" with status "Failure"
    Examples:
      | moi                     | ani                     | vcf                                       | dna_bam                                                          |
      | SC_LGUXF                | SC_LGUXF_ANI1           | IR_TCWEV/SC_LGUXF/SC_LGUXF_ANI1/test1.vcf |                                                                  |
      | ION_AQ04_TsShipped_MOI1 | ION_AQ04_TsShipped_ANI1 |                                           | IR_TCWEV/ION_AQ04_TsShipped_MOI1/ION_AQ04_TsShipped_ANI1/dna.bam |

  @ion_reporter_p3
  Scenario: ION_AQ05. extra key-value pair in the message body should NOT fail
    Given molecular id is "SC_BKWJR"
    Then add field: "analysis_id" value: "SC_BKWJR_ANI1" to message body
    Then add field: "site" value: "mda" to message body
    Then add field: "ion_reporter_id" value: "IR_TCWEV" to message body
    Then add field: "vcf_name" value: "IR_TCWEV/SC_BKWJR/SC_BKWJR_ANI1/test1.vcf" to message body
    Then add field: "dna_bam_name" value: "IR_TCWEV/SC_BKWJR/SC_BKWJR_ANI1/dna.bam" to message body
    Then add field: "cdna_bam_name" value: "IR_TCWEV/SC_BKWJR/SC_BKWJR_ANI1/cdna.bam" to message body
    Then add field: "qc_name" value: "IR_TCWEV/SC_BKWJR/SC_BKWJR_ANI1/10-10-2016.pdf" to message body
    Then add field: "extra_info" value: "a comment" to message body
    Then call aliquot PUT service, returns a message that includes "Item updated" with status "Success"

  @ion_reporter_p2
  Scenario: ION_AQ20. for sample control specimen, if the files passed in are not in that path, aliquot service will not update database
    #there is no file in S3 for this sample control
    Given molecular id is "SC_Q5E0X"
    Then add field: "analysis_id" value: "SC_Q5E0X_ANI1" to message body
    Then add field: "site" value: "mda" to message body
    Then add field: "ion_reporter_id" value: "IR_TCWEV" to message body
    Then add field: "vcf_name" value: "IR_TCWEV/SC_Q5E0X/SC_Q5E0X_ANI1/test1.vcf" to message body
    Then add field: "dna_bam_name" value: "IR_TCWEV/SC_Q5E0X/SC_Q5E0X_ANI1/dna.bam" to message body
    Then add field: "cdna_bam_name" value: "IR_TCWEV/SC_Q5E0X/SC_Q5E0X_ANI1/cdna.bam" to message body
    Then add field: "qc_name" value: "IR_TCWEV/SC_Q5E0X/SC_Q5E0X_ANI1/10-10-2016.pdf" to message body
    Then call aliquot PUT service, returns a message that includes "Item updated" with status "Success"
    Then wait for "30" seconds
    Then call aliquot GET service, returns a message that includes "" with status "Success"
    Then field: "tsv_name" for this aliquot should be: "null"
    Then field: "dna_bai_name" for this aliquot should be: "null"
    Then field: "cdna_bai_name" for this aliquot should be: "null"

  @ion_reporter_p2
  Scenario: ION_AQ21. for sample control specimen, if the file conversion failed, aliquot service will not update database
    #the files in S3 for this patient are invalid files (random text files with fake name)
    Given molecular id is "SC_M4UAF"
    Then add field: "analysis_id" value: "SC_M4UAF_ANI1" to message body
    Then add field: "site" value: "mocha" to message body
    Then add field: "ion_reporter_id" value: "IR_TCWEV" to message body
    Then add field: "vcf_name" value: "IR_TCWEV/SC_M4UAF/SC_M4UAF_ANI1/test1.vcf" to message body
    Then add field: "dna_bam_name" value: "IR_TCWEV/SC_M4UAF/SC_M4UAF_ANI1/dna.bam" to message body
    Then add field: "cdna_bam_name" value: "IR_TCWEV/SC_M4UAF/SC_M4UAF_ANI1/cdna.bam" to message body
    Then add field: "qc_name" value: "IR_TCWEV/SC_M4UAF/SC_M4UAF_ANI1/10-10-2016.pdf" to message body
    Then call aliquot PUT service, returns a message that includes "Item updated" with status "Success"
    Then wait for "30" seconds
    Then call aliquot GET service, returns a message that includes "" with status "Success"
    #don't check tsv, because any text file can be converted to tsv file
#    Then field: "tsv_name" for this sample control should be: "null" within 1 seconds
    Then field: "dna_bai_name" for this aliquot should be: "null"
    Then field: "cdna_bai_name" for this aliquot should be: "null"

  @ion_reporter_p2
  Scenario: ION_AQ22. for sample control specimen, if the file uploading fails, aliquot service will not update database

  @ion_reporter_p2
  Scenario: ION_AQ23. for patient specimen, if the files passed in are not in that path, aliquot service will not send message to patient ecosystem
    #there is no file in S3 for this patient
    Given molecular id is "ION_AQ23_TsShipped_MOI1"
    Given patient id is "ION_AQ23_TsShipped"
    Then add field: "analysis_id" value: "ION_AQ23_TsShipped_ANI1" to message body
    Then add field: "site" value: "mocha" to message body
    Then add field: "ion_reporter_id" value: "IR_TCWEV" to message body
    Then add field: "vcf_name" value: "IR_TCWEV/ION_AQ23_TsShipped_MOI1/ION_AQ23_TsShipped_ANI1/test1.vcf" to message body
    Then add field: "dna_bam_name" value: "IR_TCWEV/ION_AQ23_TsShipped_MOI1/ION_AQ23_TsShipped_ANI1/dna.bam" to message body
    Then add field: "cdna_bam_name" value: "IR_TCWEV/ION_AQ23_TsShipped_MOI1/ION_AQ23_TsShipped_ANI1/cdna.bam" to message body
    Then add field: "qc_name" value: "IR_TCWEV/ION_AQ23_TsShipped_MOI1/ION_AQ23_TsShipped_ANI1/10-10-2016.pdf" to message body
    Then call aliquot PUT service, returns a message that includes "Item updated" with status "Success"
    Then patient field: "current_status" should have value: "TISSUE_NUCLEIC_ACID_SHIPPED" after 30 seconds

  @ion_reporter_p2
  Scenario: ION_AQ24. for patient specimen, if the file conversion failed, aliquot service will not send message to patient ecosystem
    #the files in S3 for this patient are invalid files (random text files with fake name)
    Given molecular id is "ION_AQ24_TsShipped_MOI1"
    Given patient id is "ION_AQ24_TsShipped"
    Then add field: "analysis_id" value: "ION_AQ24_TsShipped_ANI1" to message body
    Then add field: "site" value: "mocha" to message body
    Then add field: "ion_reporter_id" value: "IR_TCWEV" to message body
    Then add field: "vcf_name" value: "IR_TCWEV/ION_AQ24_TsShipped_MOI1/ION_AQ24_TsShipped_ANI1/test1.vcf" to message body
    Then add field: "dna_bam_name" value: "IR_TCWEV/ION_AQ24_TsShipped_MOI1/ION_AQ24_TsShipped_ANI1/dna.bam" to message body
    Then add field: "cdna_bam_name" value: "IR_TCWEV/ION_AQ24_TsShipped_MOI1/ION_AQ24_TsShipped_ANI1/cdna.bam" to message body
    Then add field: "qc_name" value: "IR_TCWEV/ION_AQ24_TsShipped_MOI1/ION_AQ24_TsShipped_ANI1/10-10-2016.pdf" to message body
    Then call aliquot PUT service, returns a message that includes "Item updated" with status "Success"
    Then patient field: "current_status" should have value: "TISSUE_NUCLEIC_ACID_SHIPPED" after 30 seconds

  @ion_reporter_p2
  Scenario: ION_AQ25. for patient specimen, if the file uploading fails, aliquot service will not send message to patient ecosystem

  @ion_reporter_p1
  Scenario: ION_AQ40. aliquot service can return correct result for sample control molecular_id
    Given molecular id is "SC_9LL0Q"
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
      | moi                        | field1       | field2        |
      | SC_6Y4FV                   | control_type | molecular_id  |
      | ION_AQ43_TsVrUploaded_MOI1 | patient_id   | shipment_type |

  @ion_reporter_p3
  Scenario: ION_AQ44. aliquot service should fail if an invalid key is projected
    Given molecular id is "SC_4CPNX"
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
      | SC_N44B1                |
      | ION_AQ80_TsShipped_MOI1 |

  @ion_reporter_p2
  Scenario Outline: ION_AQ81. aliquot service should fail when user want to delete item using DELETE
    Given molecular id is "<moi>"
    Then call aliquot DELETE service, returns a message that includes "The method is not allowed for the requested URL" with status "Failure"
    Examples:
      | moi                     |
      | SC_K7IO0                |
      | ION_AQ81_TsShipped_MOI1 |

