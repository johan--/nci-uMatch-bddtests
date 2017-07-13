@admin_api_p1
Feature: Treatment arm validation
  As an admin user
  I want to make sure that when I post a file
  Validations are performed on that file

  Background:
    Given I am a user of type "ADMIN"

  Scenario: Validate01: A valid treatment should pass all the validations
    Given I retrieve the template for treatment arm
    And I substitute "APEC1621-test" for the "treatment_arm_id"
    And I substitute "stratum100" for the "stratum_id"
    And I substitute "2_1_0" for the "version"
    When I issue a post request for validation at level "all" with the treatment arm
    Then I "should" see a "Success" message

  Scenario Outline: A treatment arm with an empty drug id in exclusion drug should not fail validation
    Given I retrieve the template for treatment arm
    And I update "<test_field>" under "<parent_field>" to "<value>" for index "<test_field_index>"
    When I issue a post request for validation at level "all" with the treatment arm
    Then I "should" see a "Success" message
    And I "should" see "<passed_status>" value under the "passed" field
    Examples:
      | Sno | test_field | parent_field    | test_field_index | value | passed_status |
      | 1   | drug_id    | exclusion_drugs | 0                |       | true          |
      | 2   | drug_id    | exclusion_drugs | 1                |       | true          |

  Scenario: A treatment arm with no drug name in exclusion drug should fail validation
    Given I retrieve the template for treatment arm
    And I remove "name" under "exclusion_drugs" index "0"
    When I issue a post request for validation at level "all" with the treatment arm
    Then I "should" see a "Success" message
    And I "should" see "false" value under the "passed" field

  Scenario: A treatment arm with an empty value in treatment_arm_drugs should fail validation
    Given I retrieve the template for treatment arm
    And I update "drug_id" under "treatment_arm_drugs" to "" for index "0"
    When I issue a post request for validation at level "all" with the treatment arm
    Then I "should" see a "Success" message
    And I "should" see "false" value under the "passed" field
    And I should see the reason of rejection on "treatment_arm_drugs 0 drug_id" as "The treatment_arm_drug drug_id at index 0 is in an invalid format"

  Scenario: A treatment arm with no drug name in treatment arm drugs should fail validation
    Given I retrieve the template for treatment arm
    And I remove "name" under "treatment_arm_drugs" index "0"
    When I issue a post request for validation at level "all" with the treatment arm
    Then I "should" see a "Success" message
    And I "should" see "false" value under the "passed" field
    And I should see the reason of rejection on "treatment_arm_drugs 0 name" as "The treatment_arm_drug at index 0 must have a drug name."

  Scenario Outline: Validate02_<sno>:  A treatment arm with any of the important fields missing should fail validation
    Given I retrieve the template for treatment arm
    And I remove the field "<field>" from the template
    When I issue a post request for validation at level "<validation_level>" with the treatment arm
    Then I "should" see a "Success" message
    And I should see the reason of rejection on "<field>" as "<reason>"
    And I "should" see "false" value under the "passed" field
    Examples:
      | sno | field               | validation_level | reason                                                                                |
      | 1   | treatment_arm_id    | all              | The field treatment_arm_id must exist within the treatment arm.                       |
      | 2   | name                | all              | The field name must exist within the treatment arm.                                   |
      | 3   | version             | all              | The field version must exist within the treatment arm.                                |
      | 4   | stratum_id          | all              | The field stratum_id must exist.                                                      |
      | 5   | study_id            | all              | The field study_id must exist and it must be set to the value APEC1621.               |
      | 6   | treatment_arm_drugs | all              | The field treatment arm drugs must exist and contain at least one treatment arm drug. |


  Scenario Outline: Validate03_<sno>: A treatment Arm with certain missing top level fields should not fail validation
    Given I retrieve the template for treatment arm
    And I remove the field "<field>" from the template
    When I issue a post request for validation at level "<validation_level>" with the treatment arm
    Then I "should" see a "Success" message
    And I "should" see "true" value under the "passed" field
    Examples:
      | sno | field                | validation_level |
      | 1   | gene                 | all              |
      | 2   | assay_rules          | all              |
      | 3   | snv_indels           | all              |
      | 4   | non_hotspot_rules    | all              |
      | 5   | copy_number_variants | all              |
      | 6   | gene_fusions         | all              |
      | 7   | diseases             | all              |
      | 8   | exclusion_drugs      | all              |


  Scenario: A treatment arm with empty Treatment arm Id should fail
    Given I retrieve the template for treatment arm
    And I substitute "" for the "treatment_arm_id"
    When I issue a post request for validation at level "all" with the treatment arm
    Then I should see the reason of rejection on "treatment_arm_id" as "The field treatment_arm_id must exist within the treatment arm."

  Scenario: A treatment arm with non string treatment arm id should fail
    Given I retrieve the template for treatment arm
    And I enter a hash "{name: 'APEC1621SC'}" for the treatment_arm_id
    When I issue a post request for validation at level "all" with the treatment arm
    Then I should see the reason of rejection on "treatment_arm_id" as "The field treatment_arm_id must be a string. (i.e APEC1621A1)"

  Scenario Outline: Validation should raise and inform the user about the ordinal of snv_indels that has the error
    Given I retrieve the template for treatment arm
    And I add a duplicate of the object to "<top_level>"
    And I set "identifier" to "COSM11"
    And I set "<key>" to "<value>"
    And I add it to the treatment arm
    When I issue a post request for validation at level "<top_level>" with the treatment arm
    Then I "should" see a "Success" message
    And I "should" see "false" value under the "passed" field
    Then I should see the reason of rejection on "<combination>" as "<reason>"
    Examples:
      | top_level  | key               | value      | reason                                                                                                            | combination                    |
      | snv_indels | variant_type      |            | within snv_indels located at index 1, must have the proper variant type.                                          | snv_indels 1 variant_type      |
      | snv_indels | identifier        |            | within snv_indels located at index 1, must have an identifier, and that identifier must be a string.              | snv_indels 1 identifier        |
      | snv_indels | level_of_evidence |            | within snv_indels located at index 1, must have a level_of_evidence, and that level_of_evidence must be a number. | snv_indels 1 level_of_evidence |
      | snv_indels | inclusion         |            | within snv_indels located at index 1, must be defined as either an inclusion or exclusion variant                 | snv_indels 1 inclusion         |
      | snv_indels | identifier        | COSM462592 | There are two variants with the same identifier in this treatment arm.                                            | snv_indels                     |

  Scenario Outline: Validation should raise and inform the user about the ordinal of assay_rules that has the error
    Given I retrieve the template for treatment arm
    And I add a duplicate of the object to "<top_level>"
    And I set "<key>" to "<value>"
    And I add it to the treatment arm
    When I issue a post request for validation at level "all" with the treatment arm
    Then I "should" see a "Success" message
    And I "should" see "false" value under the "passed" field
    Then I should see the reason of rejection on "<combination>" as "<reason>"
    Examples:
      | top_level   | key                 | value | combination                      | reason                                                                                                                                       |
      | assay_rules | assay_result_status |       | assay_rule 1 assay_result_status | assay_result_status, within assay rules, must exist and it must be set to one of the following values: POSITIVE, NEGATIVE, or INDETERMINATE. |
      | assay_rules | assay_variant       |       | assay_rule 1 assay_variant       | assay_variant, within assay rules, must exist and it must be set to one of the following values: EMPTY, PRESENT, or NEGATIVE.                |
      | assay_rules | level_of_evidence   |       | assay_rule 1 level_of_evidence   | level_of_evidence, within assay rules, must be a number.                                                                                     |
      | assay_rules | type                |       | assay_rule 1 type                | type, within assay rules, must exist and it must be set to "IHC".                                                                            |
      | assay_rules | type                | XXX   | assay_rule 1 type                | type, within assay rules, must be set to "IHC".                                                                                              |

  Scenario Outline: Validation should raise and inform the user about the ordinal of cnv that has the error
    Given I retrieve the template for treatment arm
    And I add a duplicate of the object to "<top_level>"
    And I set "<key>" to "<value>"
    And I add it to the treatment arm
    When I issue a post request for validation at level "all" with the treatment arm
    Then I "should" see a "Success" message
    And I "should" see "false" value under the "passed" field
    Then I should see the reason of rejection on "<combination>" as "<reason>"
    Examples:
      | top_level            | key               | value | combination                              | reason                                                                                                                      |
      | copy_number_variants | variant_type      |       | copy_number_variants 0 variant_type      | within copy_number_variants located at index 0, must have a type.                                                           |
      | copy_number_variants | variant_type      | xxx   | copy_number_variants 0 variant_type      | within copy_number_variants located at index 0, must have the proper type.                                                  |
      | copy_number_variants | identifier        |       | copy_number_variants 0 identifier        | within copy_number_variants located at index 0, must have an identifier.                                                    |
      | copy_number_variants | level_of_evidence |       | copy_number_variants 0 level_of_evidence | within copy_number_variants located at index 0, must have a level_of_evidence, and that level_of_evidence must be a number. |
      | copy_number_variants | level_of_evidence | z     | copy_number_variants 0 level_of_evidence | within copy_number_variants located at index 0, must have a level_of_evidence, and that level_of_evidence must be a number. |

  Scenario Outline: Validation should raise and inform the user about the ordinal of gene fusions that has the error
    Given I retrieve the template for treatment arm
    And I add a duplicate of the object to "<top_level>"
    And I set "identifier" to "NTRK1"
    And I set "<key>" to "<value>"
    And I add it to the treatment arm
    When I issue a post request for validation at level "all" with the treatment arm
    Then I "should" see a "Success" message
    And I "should" see "false" value under the "passed" field
    Then I should see the reason of rejection on "<combination>" as "<reason>"
    Examples:
      | top_level    | key               | value                | combination                      | reason                                                                                                              |
      | gene_fusions | variant_type      |                      | gene_fusions 1 variant_type      | within gene_fusions located at index 1, must have a type.                                                           |
      | gene_fusions | variant_type      | asdf                 | gene_fusions 1 variant_type      | within gene_fusions located at index 1, must have the proper type.                                                  |
      | gene_fusions | identifier        | ARHGEF2-NTRK1.A21N10 | gene_fusions                     | There are two variants with the same identifier in this treatment arm.                                              |
      | gene_fusions | identifier        |                      | gene_fusions 1 identifier        | identifier for the gene_fusion at index, 1 must exist                                                               |
      | gene_fusions | identifier        | ARHGEF2              | gene_fusions 1 identifier        | gene_fusion at index, 1 must be in the proper format. It must be gene hyphen gene period string.                    |
      | gene_fusions | identifier        | ARorBF2-NTRK1        | gene_fusions 1 identifier        | gene_fusion at index, 1 must be in the proper format. It must be gene hyphen gene period string.                    |
      | gene_fusions | level_of_evidence |                      | gene_fusions 1 level_of_evidence | within gene_fusions located at index 1, must have a level_of_evidence, and that level_of_evidence must be a number. |
      | gene_fusions | level_of_evidence | asdf                 | gene_fusions 1 level_of_evidence | within gene_fusions located at index 1, must have a level_of_evidence, and that level_of_evidence must be a number. |

  Scenario Outline: Validation should raise and inform the user about the ordinal of NHR that has the error
    Given I retrieve the template for treatment arm
    And I add a duplicate of the object to "<top_level>"
    And I set "<key>" to "<value>"
    And I add it to the treatment arm
    When I issue a post request for validation at level "all" with the treatment arm
    Then I "should" see a "Success" message
    And I "should" see "false" value under the "passed" field
    Then I should see the reason of rejection on "<combination>" as "<reason>"
    Examples:
      | top_level         | key               | value    | combination                           | reason                                                                                                                             |
      | non_hotspot_rules | inclusion         |          | non_hotspot_rules 1 inclusion         | non_hotspot_rules located at index 1, must be defined as either an inclusion or exclusion variant                                  |
      | non_hotspot_rules | inclusion         | asdf     | non_hotspot_rules 1 inclusion         | non_hotspot_rules located at index 1, must be defined as either an inclusion or exclusion variant                                  |
      | non_hotspot_rules | level_of_evidence |          | non_hotspot_rules 1 level_of_evidence | non_hotspot_rules located at index 1, must have a level_of_evidence, and that level_of_evidence must be a number.                  |
      | non_hotspot_rules | level_of_evidence | asdsa    | non_hotspot_rules 1 level_of_evidence | non_hotspot_rules located at index 1, must have a level_of_evidence, and that level_of_evidence must be a number                   |
      | non_hotspot_rules | func_gene         | 31231    | non_hotspot_rules 1 gene              | The field gene within non_hotspot_rules at index 1 must be alphanumeric only.                                                      |
      | non_hotspot_rules | inclusion         | sdfasdfs | non_hotspot_rules 1 inclusion         | non_hotspot_rules located at index 1, must be defined as either an inclusion or exclusion variant                                  |
      | non_hotspot_rules | domain_range      | abc-def  | non_hotspot_rules 1 domain_range      | valid range where the second number is greater than the first number, and both numbers must be separated by a hyphen with no space |
      | non_hotspot_rules | domain_range      | 622-412  | non_hotspot_rules 1 domain_range      | valid range where the second number is greater than the first number, and both numbers must be separated by a hyphen with no space |

  Scenario: NHR should have at least one value in the variant
    Given I retrieve the template for treatment arm
    And I add a duplicate of the object to "non_hotspot_rules"
    And I set "func_gene" to ""
    And I set "function" to ""
    And I set "oncomine_variant_class" to ""
    And I set "exon" to ""
    And I add it to the treatment arm
    When I issue a post request for validation at level "all" with the treatment arm
    Then I should see the reason of rejection on "non_hotspot_rules" as "non_hotspot_rules at index 1 needs to contain one of the following fields to be considered valid: func_gene, function, oncomine_variant_class, exon"
    And I "should" see "false" value under the "passed" field

  Scenario Outline: IF LOE is present in an exclusion variant it should not be an issue
    Given I retrieve the template for treatment arm
    And I add a duplicate of the object to "<variant_type>"
    And I set "identifier" to "<variant_value>"
    And I set "inclusion" to "false"
    And I set "level_of_evidence" to "3.0"
    And I add it to the treatment arm
    When I issue a post request for validation at level "all" with the treatment arm
    And I "should" see "true" value under the "passed" field
    Examples:
      | variant_type         | variant_value |
      | gene_fusions         | ARHGEF1-NTRK2 |
      | snv_indels           | COSM1111      |
      | copy_number_variants | TEM           |


  @broken
  Scenario: A treatent arm with multiple errors should see all the errors
    Given I retrieve the template for treatment arm
    And I remove the field "treeatment_arm_id" from the template
    And I remove the field "name" from the template
    When I issue a post request for validation at level "all" with the treatment arm
    Then I "should" see a "Success" message
    And I "should" see "false" value under the "passed" field
