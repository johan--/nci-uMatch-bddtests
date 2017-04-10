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


  Scenario: FIL-CNV_04When a new treatment arm list is available, the rules are run and a a new variant report with updated amois is generated.
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

  Scenario Outline: FIL-CNV_05: CNV without PASS filter not returned in variant report
    Given a tsv variant report file "<tsvFile>" and treatment arms file "<TAFile>"
    When call the amoi rest service
    Then moi report is returned without the cnv gene "AR"
    Then moi report is returned with the cnv gene "BCL9"
    Examples:
      | tsvFile    | TAFile          |
      | cnv_nocall | APEC1621-A.json |


  Scenario: FIL-CNV_06: Oncomine pannel summary
    Given a tsv variant report file "oncomine_panel_test" and treatment arms file "APEC1621-B.json"
    When call the amoi rest service
    Then the variant report contains poolsum in oncomine panel summary with
      | pool1Sum | 181742.0 |
      | pool2Sum | 558358.0 |
    Then the variant report contains exprControl in oncomine panel summary with
      | POOL1 | 181482.0 |
      | POOL2 | 557781.0 |
    Then the variant report contains geneExpression in oncomine panel summary with
      | POOL1 | 60.0  |
      | POOL2 | 427.0 |
    Then the variant report contains fusion in oncomine panel summary with
      | POOL1 | 200.0 |
      | POOL2 | 150.0 |

  Scenario: FIL-CNV_07: Verify the variant report based of the version 5.2 vcf
    Given a tsv variant report file "Sample-5922-19-DNA_Sample-5922-19-RNA_Non-Filtered_2017-03-16_07-46-49" and treatment arms file "APEC1621-B.json"
    When call the amoi rest service
    Then the parsed vcf genes should match the list "v5.2geneList.txt"
    And the variant report contains the following values
      | torrent_variant_caller_version | 5.2-25  |
      | mapd                           | 0.280   |
      | mappedFusionPanelReads         | 1406678 |

  Scenario: FIL-CNV_08: Oncomine panel summary when the fusion belongs to pool1 and pool2
    Given a tsv variant report file "oncomine_panel_test2" and treatment arms file "APEC1621-B.json"
    When call the amoi rest service
    Then the variant report contains poolsum in oncomine panel summary with
      | pool1Sum | 182992.0 |
      | pool2Sum | 559608.0 |
    Then the variant report contains exprControl in oncomine panel summary with
      | POOL1 | 181482.0 |
      | POOL2 | 557781.0 |
    Then the variant report contains geneExpression in oncomine panel summary with
      | POOL1 | 60.0  |
      | POOL2 | 427.0 |
    Then the variant report contains fusion in oncomine panel summary with
      | POOL1 | 1450.0 |
      | POOL2 | 1400.0 |

  Scenario: FIL-CNV_09: Oncomine panel summary when the gene expression belongs to pool1 and pool2
    Given a tsv variant report file "oncomine_panel_test3" and treatment arms file "APEC1621-B.json"
    When call the amoi rest service
    Then the variant report contains poolsum in oncomine panel summary with
      | pool1Sum | 181787.0 |
      | pool2Sum | 558403.0 |
    Then the variant report contains exprControl in oncomine panel summary with
      | POOL1 | 181482.0 |
      | POOL2 | 557781.0 |
    Then the variant report contains geneExpression in oncomine panel summary with
      | POOL1 | 105.0  |
      | POOL2 | 472.0 |
    Then the variant report contains fusion in oncomine panel summary with
      | POOL1 | 200.0 |
      | POOL2 | 150.0 |