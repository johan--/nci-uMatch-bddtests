@demo
@rules
Feature: Test the functionality that filters the CNV variants based on specified filter criteria


  Scenario:CNV with gene from the version 4 vcf list is filtered in
    Given a tsv variant report file file "cnv_v4_gene_filter.tsv" and treatment arms file "APEC1621-B.json"
    When call the amoi rest service
    Then moi report is returned with the cnv variant "DCUN1D1"

  Scenario:CNV with gene from the version 5 vcf list is filtered out
    Given a tsv variant report file file "cnv_v5_gene_filter.tsv" and treatment arms file "APEC1621-B.json"
    When call the amoi rest service
    Then moi report is returned without the cnv variant "DCUN1D1"

  Scenario: CNV with copy number threshold >=7 is filtered in
    Given a tsv variant report file file "cnv_v5_gene_filter.tsv" and treatment arms file "APEC1621-B.json"
    When call the amoi rest service
    Then moi report is returned without the cnv variant "CDK4"
    Then moi report is returned with the cnv variant "MYCL" as an amoi

  Scenario: CNV with NHR match to a treatment arm is filtered in and is marked as amoi
    Given a tsv variant report file file "cnv_v5_gene_filter.tsv" and treatment arms file "APEC1621-B.json"
    When call the amoi rest service
    Then moi report is returned with the cnv variant "TP53" as an amoi







