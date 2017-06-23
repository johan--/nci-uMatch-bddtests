@rules_p2
Feature: Sample control tests for proficiency and competency control

  Scenario: SC-PCC_01: Run the rules for proficiency and competency control  with a sample file with variants passing the filters
    Given a tsv variant report file "SNV_NO_PASS_filter" and treatment arms file "MultiTAs.json"
    When the proficiency_competency service is called
    Then the report status return is "PENDING"
    Then moi report is returned with the snv variant "match769.3.3"
    Then moi report is returned with the snv variant "match769.3.6"
    Then moi report is returned with the snv variant "match769.3.8"
    Then moi report is returned with the snv variant "match769.3.9"
    Then moi report is returned with the snv variant "match769.3.10"
    Then moi report is returned with the snv variant "match769.3.11"
    Then moi report is returned with the snv variant "match769.3.12"
    Then moi report is returned with the snv variant "match769.3.13"
    Then moi report is returned with the snv variant "match769.3.14"
    Then moi report is returned with the snv variant "match769.3.15"
    Then moi report is returned with the snv variant "match769.3.16"
    Then moi report is returned with the snv variant "match769.3.17"
    Then moi report is returned with the snv variant "match769.3.18"
    Then moi report is returned without the snv variant "match769.3.1"
    Then moi report is returned without the snv variant "match769.3.2"
    Then moi report is returned without the snv variant "match769.3.4"
    Then moi report is returned without the snv variant "match769.3.7"


  Scenario: SC-PCC_02: Run the rules for proficiency and competency control  with a sample file with variants failing the filters
    Given a tsv variant report file "SNV_Germline_filter" and treatment arms file "MultiTAs.json"
    When the proficiency_competency service is called
    Then the report status return is "PENDING"
    Then moi report is returned with 0 snv variants
    Then moi report is returned with 0 cnv variants
    Then moi report is returned with 0 indel variants
    Then moi report is returned with 0 ugf variants


  Scenario: SC-PCC_03: Run rules for proficiency and competency control with a sample file with non-hotspot variant that passes the filter.
    Given a tsv variant report file "SNV_nhr_filter" and treatment arms file "MultiTAs.json"
    When the proficiency_competency service is called
    Then the report status return is "PENDING"
    Then moi report is returned with the snv variant "moip-1"

  Scenario: SC-PCC_04: Run rules for proficiency and competency control with sample file containing CNV variants (CNV with copynumber threshold >= is filtered in)
    Given a tsv variant report file "cnv_v5_gene_filter" and treatment arms file "MultiTAs.json"
    When the proficiency_competency service is called
    Then the report status return is "PENDING"
    Then moi report is returned without the cnv variant "CDK4"
    Then moi report is returned with the cnv variant "MYCL"

  Scenario: SC-PCC_05: Run rules for proficiency and competency control  with sample file containing Indels
    Given a tsv variant report file "Indel_variants" and treatment arms file "MultiTAs.json"
    When the proficiency_competency service is called
    Then the report status return is "PENDING"
    Then moi report is returned with the indel variant "WILMA"
    Then moi report is returned with the indel variant "COSM97131"
    Then moi report is returned with the indel variant "NOONCOM"
    Then moi report is returned with the indel variant "NOEXON"
    Then moi report is returned with the indel variant "NOFUNCT"
    Then moi report is returned with the indel variant "NOLOC"
    Then moi report is returned with the indel variant "OVADELETERIOUS"
    Then moi report is returned without the indel variant "COSM250061"
    Then moi report is returned without the indel variant "COSM41596"
    Then moi report is returned without the indel variant "FRED"
    Then moi report is returned without the indel variant "NOPASS"


  Scenario: SC-PCC_06: Verify that when use vcf version 5.2 oncomine summary is generated
    Given a tsv variant report file "samplecontrol_vcf52" and treatment arms file "MultiTAs.json"
    And remove quality control json from S3
    When the proficiency_competency service is called
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