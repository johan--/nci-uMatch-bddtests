#encoding: utf-8
@sample_control_reporters
Feature: Tests for sample_controls service in ion ecosystem

  @sample_control_p1
  Scenario Outline: ION_SC01. new sample_control can be created successfully(all control_types)
    Given site is "<site>"
    Given control_type is "<control_type>"
    When call sample_controls POST service, returns a message that includes "New sample control created" with status "Success"
    Then field: "site" for generated sample_control should be: "<site>"
    Then field: "control_type" for generated sample_control should be: "<control_type>"
    Examples:
      | site  | control_type           |
      | mda   | positive               |
      | mocha | no_template            |
      | mda   | proficiency_competency |

  Scenario: ION_SC02. sample control service should generate unique molecular_id
    Given site is "mda"
    Given control_type is "positive"
    When call sample_controls POST service, returns a message that includes "New sample control created" with status "Success"
    Then generated sample_control molecular id should have 1 record

  Scenario: ION_SC03. sample control service should fail if site is invalid
    Given site is "non_existing_site"
    Given control_type is "positive"
    When call sample_controls POST service, returns a message that includes "site" with status "Failure"


  Scenario: ION_SC04. sample control service should fail if control_type is invalid
    Given site is "mda"
    Given control_type is "non_existing_type"
    When call sample_controls POST service, returns a message that includes "control type" with status "Failure"

  Scenario: ION_SC05. sample_control POST service can take any message body but should not store it (no-related values, molecular_id, site...)
    Given site is "mocha"
    Given control_type is "no_template"
    Then add field: "control_type" value: "IR_O2YIA" to message body
    Then add field: "site" value: "yale" to message body
    Then add field: "molecular_id" value: "SC_S5ONQ" to message body
    When call sample_controls POST service, returns a message that includes "New sample control created" with status "Success"
    Then generated sample_control should have 4 field-value pairs
    Then generated sample_control should have field: "control_type"
    Then generated sample_control should have field: "molecular_id"
    Then generated sample_control should have field: "site"
    Then generated sample_control should have field: "date_molecular_id_created"
    Then field: "control_type" for generated sample_control should be: "no_template"
    Then field: "site" for generated sample_control should be: "mocha"

  Scenario: ION_SC06. date_molecular_id_created should be generated properly
    Given site is "mocha"
    Given control_type is "positive"
    When call sample_controls POST service, returns a message that includes "New sample control created" with status "Success"
    Then generated sample_control should have correct date_molecular_id_created

  Scenario Outline: ION_IR07. ion_reporter service should fail if parameters other than "site" and "control_type" are passed in
    Given site is "mocha"
    Given control_type is "positive"
    Then add field: "<field>" value: "<value>" to url
    When call sample_controls POST service, returns a message that includes "<field> was passed in request" with status "Failure"
    Examples:
      | field                     | value      |
      | date_molecular_id_created | 2010-01-07 |
      | molecular_id              | IR_O2YIA   |


  Scenario: ION_SC20. sample_control can be updated successfully
    Given molecular id is "SC_RZJ2M"
    Then add field: "ion_reporter_id" value: "IR_WAO85" to message body
    Then add field: "analysis_id" value: "SC_RZJ2M_a888_v1" to message body
    Then add field: "site" value: "mocha" to message body
    Then add field: "vcf_name" value: "SC_RZJ2M/SC_RZJ2M_a888_v1/SC_RZJ2M_a888_v1.vcf" to message body
    Then add field: "dna_bam_name" value: "SC_RZJ2M/SC_RZJ2M_a888_v1/SC_RZJ2M_a888_v1_DNA_v1.bam" to message body
    Then add field: "cdna_bam_name" value: "SC_RZJ2M/SC_RZJ2M_a888_v1/SC_RZJ2M_a888_v1_RNA_v1.bam" to message body
    Then add field: "qc_name" value: "SC_RZJ2M/SC_RZJ2M_a888_v1/SC_RZJ2M_a888_v1_QC.pdf" to message body
    When call sample_controls PUT service, returns a message that includes "updated" with status "Success"
    Then field: "analysis_id" for this ion_reporter should be: "SC_RZJ2M_a888_v1"
    Then field: "site" for this ion_reporter should be: "mocha"
    Then field: "vcf_name" for this ion_reporter should be: "SC_RZJ2M/SC_RZJ2M_a888_v1/SC_RZJ2M_a888_v1.vcf"
    Then field: "dna_bam_name" for this ion_reporter should be: "SC_RZJ2M/SC_RZJ2M_a888_v1/SC_RZJ2M_a888_v1_DNA_v1.bam"
    Then field: "cdna_bam_name" for this ion_reporter should be: "SC_RZJ2M/SC_RZJ2M_a888_v1/SC_RZJ2M_a888_v1_RNA_v1.bam"
    Then field: "qc_name" for this ion_reporter should be: "SC_RZJ2M/SC_RZJ2M_a888_v1/SC_RZJ2M_a888_v1_QC.pdf"

  Scenario: ION_SC21. sample_control update request with non-existing molecular_id should fail
    Given molecular id is "SC_NON_EXISTING"
    Then add field: "analysis_id" value: "SC_NON_EXISTING_ANI" to message body
    When call sample_controls PUT service, returns a message that includes "exist" with status "Failure"


  Scenario: ION_SC22. sample_control update request with patient molecular_id should fail
    Given molecular id is "ION_SC22_TsShipped_MOI1"
    Then add field: "analysis_id" value: "ION_SC22_TsShipped_ANI1" to message body
    When call sample_controls PUT service, returns a message that includes "exist" with status "Failure"

  Scenario: ION_SC23. sample_control service should fail if site-ion_reporter_id pair in message body is invalid
    Given molecular id is "SC_RZJ2M"
    Then add field: "ion_reporter_id" value: "IR_WAO85" to message body
    Then add field: "site" value: "mda" to message body
    When call sample_controls PUT service, returns a message that includes "site" with status "Failure"

  Scenario: ION_SC24. sample_control service should fail if existing analysis_id is used
    #SC_JQFX5_ANI is in seed data, used by sample control SC_JQFX5
    Given molecular id is "SC_83OZJ"
    Then add field: "analysis_id" value: "SC_JQFX5_ANI" to message body
    When call sample_controls PUT service, returns a message that includes "analysis id" with status "Failure"

  Scenario: ION_SC25. sample_control update request should not fail if extra key-value pair in message body, but doesn't store them
    Given molecular id is "SC_RZJ2M"
    Then add field: "extra_information" value: "other" to message body
    When call sample_controls PUT service, returns a message that includes "updated" with status "Success"
    Then updated sample_control should not have field: "extra_information"

  Scenario: ION_SC26. sample_control update request should not remove existing fields that are not in PUT message body


  Scenario: ION_SC40. sample_control with specific molecular_id can be deleted successfully
    Given molecular id is "SC_TIBZY"
    Then call sample_controls DELETE service, returns a message that includes "Item deleted" with status "Success"
    Then call sample_controls GET service, returns a message that includes "No ABCMeta" with status "Failure"

  Scenario: ION_SC41. sample_controls can be batch deleted using parameters
    Given molecular id is ""
    Then add field: "date_molecular_id_created" value: "2016-10-11 00:49:59.937464" to url
    Then call sample_controls GET service, returns a message that includes "" with status "Success"
    Then there are|is 1 sample_control returned
    Then call sample_controls DELETE service, returns a message that includes "Batch deletion request placed on queue to be processed" with status "Success"
    Then wait for "5" seconds
    Then call sample_controls GET service, returns a message that includes "No ABCMeta" with status "Failure"


  Scenario: ION_SC41. sample_controls cannot be batch deleted without parameters
    Given molecular id is ""
    Then record total sample_controls count
    Then call sample_controls DELETE service, returns a message that includes "Cannot use batch delete to delete all records" with status "Failure"
    Then wait for "5" seconds
    Then new and old total sample_controls counts should have 0 difference

  Scenario Outline: ION_SC42. sample_control service should fail if the specified molecular_id doesn't exist (including existing patient molecular_id), and no sample_control is deleted
    Given molecular id is "<moi>"
    Then record total sample_controls count
    Then call sample_controls DELETE service, returns a message that includes "molecular id" with status "Failure"
    Then wait for "5" seconds
    Then new and old total ion_reporters counts should have 0 difference
    Examples:
      | moi                     |
      | SC_NON_EXISTING         |
      | ION_SC42_TsShipped_MOI1 |

  Scenario: ION_SC43. sample_control service should fail if no sample_control meet batch delete parameters, and no sample_control is deleted
    Given molecular id is ""
    Then add field: "site" value: "invalid_site" to url
    Then record total sample_controls count
    Then call sample_controls DELETE service, returns a message that includes "site" with status "Failure"
    Then wait for "5" seconds
    Then new and old total sample_controls counts should have 0 difference


  Scenario: ION_SC60. sample_control service can list all existing sample_controls
    Given molecular id is ""
    Then call sample_controls GET service, returns a message that includes "molecular_id" with status "Success"

  Scenario: ION_SC61. sample_control service can list all sample_controls that meet query parameters
    Given molecular id is ""
    Then add field: "date_molecular_id_created" value: "2016-10-04 14:29:43.780998" to url
    Then field: "site" for this sample_control should be: "mocha"


  Scenario: ION_SC62. sample_control service can return single sample_control with specified molecular_id
    Given molecular id is "SC_S5ONQ"
    Then field: "site" for this sample_control should be: "mocha"
    Then field: "control_type" for this sample_control should be: "no_template"
    Then field: "date_molecular_id_created" for this sample_control should be: "2016-10-11 00:28:35.657860"


  Scenario Outline: ION_SC63. sample_control service should only return projected key-value pair
    Given molecular id is "<moi>"
    Then add projection: "<field1>" to url
    Then add projection: "<field2>" to url
    Then add projection: "bad_projection" to url
    Then call sample_controls GET service, returns a message that includes "" with status "Success"
    Then each returned sample_control should have 2 fields
    Then each returned sample_control should have field "<field1>"
    Then each returned sample_control should have field "<field2>"
    Examples:
      | moi      | field1                    | field2       |
      | SC_83OZJ | control_type              | molecular_id |
      |          | date_molecular_id_created | site         |

  Scenario: ION_SC64. sample_control service should fail(or just not return this field?) if an invalid key is projected
    Given molecular id is ""
    Then add projection: "non_existing_key" to url
    Then call sample_controls GET service, returns a message that includes "No ABCMeta" with status "Failure"
#    Then call sample_controls GET service, returns a message that includes "" with status "Success"

  Scenario: ION_SC65. sample_control service should return 404 error if query a non-existing sample_control
    Given molecular id is ""
    Then add field: "site" value: "non_existing_site" to url
    Then call ion_reporters GET service, returns a message that includes "No records meet the query parameters" with status "Failure"



