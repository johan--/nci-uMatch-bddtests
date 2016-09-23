@rules_p1
Feature: Test the functionality that filters the CNV variants based on specified filter criteria


  Scenario: FIL-CNV_01: CNV with gene from the version 4 vcf list is filtered in
    Given a tsv variant report file "cnv_v4_gene_filter" and treatment arms file "APEC1621-B.json"
    When call the amoi rest service
    Then moi report is returned with the cnv variant "DCUN1D1"

  Scenario: FIL-CNV_02: CNV with gene from the version 5 vcf list is filtered out
    Given a tsv variant report file "cnv_v5_gene_filter" and treatment arms file "APEC1621-B.json"
    When call the amoi rest service
    Then moi report is returned without the cnv variant "DCUN1D1"

  Scenario: FIL-CNV_03: CNV with copy number threshold >=7 is filtered in
    Given a tsv variant report file "cnv_v5_gene_filter" and treatment arms file "APEC1621-B.json"
    When call the amoi rest service
    Then moi report is returned without the cnv variant "CDK4"
    Then moi report is returned with the cnv variant "MYCL" as an amoi
    """
    [{"version":"2015-08-06","exclusion":false,"treatment_arm_id":"APEC1621-B","stratum_id":"100","amoi_status":"CURRENT"}]
    """


  Scenario: When a new treatment arm list is available, the rules are run and a a new variant report with updated amois is generated.
    Given a tsv variant report file "cnv_v5_gene_filter" and treatment arms file "APEC1621-B.json"
    When call the amoi rest service
    Then moi report is returned without the cnv variant "CDK4"
    Then moi report is returned with the cnv variant "MYCL" as an amoi
    """
    [{"version":"2015-08-06","exclusion":false,"treatment_arm_id":"APEC1621-B","stratum_id":"100","amoi_status":"CURRENT"}]
    """
    When a new treatment arm list "newTAList.json" is received by the rules amoi service for the above variant report
    Then moi report is returned with the cnv variant "MYCL" as an amoi
    """
    [{
          "treatment_arm_id": "APEC1621-D",
          "stratum_id": "100",
          "version": "2015-08-06",
          "amoi_status": "CURRENT",
          "exclusion": false
     },
    {
      "treatment_arm_id": "APEC1621-B",
      "stratum_id": "100",
      "version": "2015-08-06",
      "amoi_status": "CURRENT",
      "exclusion": false
    }]
    """









