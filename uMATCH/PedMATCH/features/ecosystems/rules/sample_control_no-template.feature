@rules_p2
Feature: Sample control tests for no template control

  Scenario: SC-NT_01: Verify that when the variant report contains variants then the status of the NTC variant report is set to FAILED
    Given a tsv variant report file "NTC_variantReport-Failed" and treatment arms file "MultiTAs.json"
    When the no_template service is called
    Then the report status return is "FAILED"
    Then moi report is returned with the snv variant "COSM6224"

  Scenario: SC-NT_02: Verify that when the variant report contains no variants (none passes the filters) then the status of the NTC variant report is set to PASSED
    Given a tsv variant report file "NTC_variantReport-Passed" and treatment arms file "MultiTAs.json"
    When the no_template service is called
    Then the report status return is "PASSED"
    Then moi report is returned with 0 snv variants
    Then moi report is returned with 0 cnv variants
    Then moi report is returned with 0 indel variants
    Then moi report is returned with 0 ugf variants


  Scenario: SC-NT_03: Verify that when use vcf version 5.2 oncomine summary is generated
    Given a tsv variant report file "samplecontrol_vcf52" and treatment arms file "MultiTAs.json"
    And remove quality control json from S3
    When the no_template service is called
    Then quality control json file should be generated
    Then the variant report contains poolsum in oncomine panel summary with
      | pool1Sum | 181787.0 |
      | pool2Sum | 558403.0 |
    Then the variant report contains exprControl in oncomine panel summary with
      | POOL1 | 181482.0 |
      | POOL2 | 557781.0 |
    Then the variant report contains geneExpression in oncomine panel summary with
      | POOL1 | 105.0 |
      | POOL2 | 472.0 |
    Then the variant report contains fusion in oncomine panel summary with
      | POOL1 | 200.0 |
      | POOL2 | 150.0 |
    And the variant report contains the following values
      | torrent_variant_caller_version | 5.2-25  |
      | mapd                           | 0.280   |
      | mappedFusionPanelReads         | 1406678 |

