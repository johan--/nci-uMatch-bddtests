@rules
Feature: Test the functionality that filters the Gene Fusion variants based on specified filter criteria

  Scenario Outline: Filter-in Genefusion with read_depth > 1000
    Given a tsv variant report file file "<tsvFile>" and treatment arms file "<TAFile>"
    When call the amoi rest service
    Then moi report is returned with the ugf variant "EGFR-EGFR.E1E8.DelPositive"
    Examples:
      |tsvFile                                |TAFile           |
      |GF_EGFR_read-depth_filter_gt1000.tsv   |APEC1621-B.json  |


  Scenario Outline: Filter-out Genefusion with read_depth eq 1000
    Given a tsv variant report file file "<tsvFile>" and treatment arms file "<TAFile>"
    When call the amoi rest service
    Then moi report is returned without the ugf variant "EGFR-EGFR.E1E8.DelPositive"
    Examples:
      |tsvFile                                |TAFile           |
      |GF_EGFR_read-depth_filter_eq1000.tsv   |APEC1621-B.json  |

  Scenario Outline: Filter-out Genefusion with FAIL filter
    Given a tsv variant report file file "<tsvFile>" and treatment arms file "<TAFile>"
    When call the amoi rest service
    Then moi report is returned without the ugf variant "EGFR-EGFR.E1E8.DelPositive"
    Examples:
      |tsvFile              |TAFile           |
      |GF_FAIL_filter.tsv   |APEC1621-B.json  |


  Scenario Outline: If there is match to the treatment arm, the amoi service returns the matching treatment arm
    Given a tsv variant report file file "<tsvFile>" and treatment arms file "<TAFile>"
    When call the amoi rest service
    Then moi report is returned with the ugf variant "TPM3-ALK.T7A20" as an amoi
    Examples:
      |tsvFile                  |TAFile           |
      |113re_gene-fusion.tsv    |APEC1621-A.json  |

  Scenario Outline: IFilter-in the GF variant when there is a variant match to the non-hotspot rule of a treatment arm
    Given a tsv variant report file file "<tsvFile>" and treatment arms file "<TAFile>"
    When call the amoi rest service
    Then moi report is returned with the ugf variant "TMPRSS2-ETV5a.T1E2.EU314929" as an amoi
    Examples:
      |tsvFile                  |TAFile           |
      |GF_nhr_filter.tsv        |APEC1621-C.json  |