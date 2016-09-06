@rules
Feature: Sample control tests for proficiency and competency control

  Scenario: Run the rules for proficiency and competency control  with a sample file with variants passing the filters
    Given a tsv variant report file file "SNV_NO_PASS_filter.tsv" and treatment arms file "MultiTAs.json"
    When the proficiency_competency service is called
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


  Scenario: Run the rules for proficiency and competency control  with a sample file with variants failing the filters
    Given a tsv variant report file file "SNV_Germline_filter.tsv" and treatment arms file "MultiTAs.json"
    When the proficiency_competency service is called
    Then moi report is returned with 0 snv variants
    Then moi report is returned with 0 cnv variants
    Then moi report is returned with 0 indel variants
    Then moi report is returned with 0 ugf variants


  Scenario: Run rules for proficiency and competency control with a sample file with non-hotspot variant that passes the filter.
    Given a tsv variant report file file "SNV_nhr_filter.tsv" and treatment arms file "MultiTAs.json"
    When the proficiency_competency service is called
    Then moi report is returned with the snv variant "moip-1"

  Scenario: Run rules for proficiency and competency control with sample file containing CNV variants (CNV with copynumber threshold >= is filtered in)
    Given a tsv variant report file file "cnv_v5_gene_filter.tsv" and treatment arms file "MultiTAs.json"
    When the proficiency_competency service is called
    Then moi report is returned without the cnv variant "CDK4"
    Then moi report is returned with the cnv variant "MYCL"

  Scenario: Run rules for proficiency and competency control  with sample file containing Indels
    Given a tsv variant report file file "Indel_variants.tsv" and treatment arms file "MultiTAs.json"
    When the proficiency_competency service is called
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