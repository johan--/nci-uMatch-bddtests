#encoding: utf-8
@ion_reporter_reporters
Feature: Tests for files service in ion ecosystem

  @ion_reporter_p1_not_ready
  Scenario: ION_FL01. files service can return correct result for sample control molecular_id
    #not completed, should call aliquot for this sc to prepare all files
    Given molecular id is "SC_J6RDR"
    Given file name for files service is: "test1.vcf"
    When call files GET service, returns a message that includes "https://pedmatch-dev.s3.amazonaws.com" with status "Success"

  @ion_reporter_p2
  Scenario: ION_FL02. files service should fail if a patient molecular_id is passed in
    Given molecular id is "PT_VC08_VRUploaded_MOI1"
    Given file name for files service is: "qc_name"
    When call files GET service, returns a message that includes "PT_VC08_VRUploaded_MOI1 was not found" with status "Failure"

  @ion_reporter_p2
  Scenario: ION_FL03. files service should fail if an non-existing molecular_id is passed in
    Given molecular id is "SC_NON_EXISTING"
    Given file name for files service is: "qc_name"
    When call files GET service, returns a message that includes "SC_NON_EXISTING was not found" with status "Failure"

  @ion_reporter_p2
  Scenario: ION_FL04. files service should fail if an non-existing file_name is passed in
    Given molecular id is "SC_ZO9VD"
    Given file name for files service is: "extra_file"
    When call files GET service, returns a message that includes "does not exist" with status "Failure"

  @ion_reporter_p2
  Scenario: ION_FL06. returned file path should be reachable S3 path

  @ion_reporter_p3
  Scenario Outline: ION_FL07. files service should fail if no molecular_id and/or file_name is passed in
    Given molecular id is "<moi>"
    Given file name for files service is: "<file_name>"
    When call files GET service, returns a message that includes "<result>" with status "Failure"
    Examples:
      | moi      | file_name | result       |
      |          | qc_name   | molecular id |
      | SC_76HQS |           | file name    |
      |          |           | all files    |

  @ion_reporter_p2
  Scenario: ION_FL08. files service should return 404 error if no result for current query
    Given molecular id is "SC_4Y49T"
    Given file name for files service is: "vcf_name"
    Then call files GET service, returns a message that includes "Failed to get download url" with status "Failure"


  @ion_reporter_p2
  Scenario: ION_FL80. files service should fail when user want to create new item using POST
    Given molecular id is "SC_D8ZTD"
    Given file name for files service is: "qc_name"
    Then call files POST service, returns a message that includes "The method is not allowed for the requested URL" with status "Failure"

  @ion_reporter_p2
  Scenario: ION_FL81. files service should fail when user want to delete item using DELETE
    Given molecular id is "SC_QSQTO"
    Given file name for files service is: "dna_bam_name"
    Then call files DELETE service, returns a message that includes "The method is not allowed for the requested URL" with status "Failure"

  @ion_reporter_p2
  Scenario: ION_FL82. files service should fail when user want to update item using PUT
    Given molecular id is "SC_X9FR1"
    Given file name for files service is: "vcf_name"
    Then call files PUT service, returns a message that includes "The method is not allowed for the requested URL" with status "Failure"



