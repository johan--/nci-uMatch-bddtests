#encoding: utf-8
@ion_reporter_files
Feature: Tests for files service in ion ecosystem

  @ion_reporter_p1
  Scenario Outline: ION_FL01. files service can return correct result for sample control molecular_id
    Given molecular id is "<moi>"
    Given file name for files service is: "qc_name"
    When GET from files service, response includes "<message>" with code "<code>"
    Examples:
      | moi      | message                                                     | code |
      | SC_J6RDR | s3.amazonaws.com/IR_TCWEV/SC_J6RDR/SC_J6RDR_ANI1/10-10-2016 | 200  |

  @ion_reporter_p2
  Scenario: ION_FL02. files service should fail if a patient molecular_id is passed in
    Given molecular id is "PT_VC08_VRUploaded_MOI1"
    Given file name for files service is: "qc_name"
    When GET from files service, response includes "PT_VC08_VRUploaded_MOI1 was not found" with code "404"

  @ion_reporter_p2
  Scenario: ION_FL03. files service should fail if an non-existing molecular_id is passed in
    Given molecular id is "SC_NON_EXISTING"
    Given file name for files service is: "qc_name"
    When GET from files service, response includes "SC_NON_EXISTING was not found" with code "404"

  @ion_reporter_p2
  Scenario: ION_FL04. files service should fail if an non-existing file_name is passed in
    Given molecular id is "SC_ZO9VD"
    Given file name for files service is: "extra_file"
    When GET from files service, response includes "does not exist" with code "404"

#  @ion_reporter_p2
#  Scenario: ION_FL06. returned file path should be reachable S3 path

  @ion_reporter_p3
  Scenario Outline: ION_FL07. files service should fail if no molecular_id and/or file_name is passed in
    Given molecular id is "<moi>"
    Given file name for files service is: "<file_name>"
    When GET from files service, response includes "<result>" with code "<code>"
    Examples:
      | moi      | file_name | result                          |code |
      |          | qc_name   | molecular id                    |404  |
      | SC_76HQS |           | file name                       |404  |
      |          |           | No ABCMeta with id: files found |404  |

  @ion_reporter_p2
  Scenario: ION_FL08. files service should return 404 error if no result for current query
    Given molecular id is "SC_4Y49T"
    Given file name for files service is: "vcf_name"
    When GET from files service, response includes "Key does not exist" with code "404"


  @ion_reporter_p2
  Scenario: ION_FL80. files service should fail when user want to create new item using POST
    Given molecular id is "SC_D8ZTD"
    Given file name for files service is: "qc_name"
    When POST to files service, response includes "The method is not allowed" with code "405"

  @ion_reporter_p2
  Scenario: ION_FL81. files service should fail when user want to delete item using DELETE
    Given molecular id is "SC_QSQTO"
    Given file name for files service is: "dna_bam_name"
    When DELETE to files service, response includes "The method is not allowed" with code "405"

  @ion_reporter_p2
  Scenario: ION_FL82. files service should fail when user want to update item using PUT
    Given molecular id is "SC_X9FR1"
    Given file name for files service is: "vcf_name"
    When PUT to files service, response includes "The method is not allowed" with code "405"



