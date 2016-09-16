@rules
Feature: Test the functionality that filters the Gene Fusion variants based on specified filter criteria

  Scenario Outline: FIL-GF_01: Filter-in Genefusion with read_depth > 1000
    Given a tsv variant report file file "<tsvFile>" and treatment arms file "<TAFile>"
    When call the amoi rest service
    Then moi report is returned with the ugf variant "EGFR-EGFR.E1E8.DelPositive"
    Examples:
      |tsvFile                                |TAFile           |
      |GF_EGFR_read-depth_filter_gt1000   |APEC1621-B.json  |


  Scenario Outline: FIL-GF_02: Filter-out Genefusion with read_depth eq 1000
    Given a tsv variant report file file "<tsvFile>" and treatment arms file "<TAFile>"
    When call the amoi rest service
    Then moi report is returned without the ugf variant "EGFR-EGFR.E1E8.DelPositive"
    Examples:
      |tsvFile                                |TAFile           |
      |GF_EGFR_read-depth_filter_eq1000   |APEC1621-B.json  |

  Scenario Outline: FIL-GF_03: Filter-out Genefusion with FAIL filter
    Given a tsv variant report file file "<tsvFile>" and treatment arms file "<TAFile>"
    When call the amoi rest service
    Then moi report is returned without the ugf variant "EGFR-EGFR.E1E8.DelPositive"
    Examples:
      |tsvFile              |TAFile           |
      |GF_FAIL_filter   |APEC1621-B.json  |


  Scenario Outline: FIL-GF_04: If there is match to the treatment arm, the amoi service returns the matching treatment arm
    Given a tsv variant report file file "<tsvFile>" and treatment arms file "<TAFile>"
    When call the amoi rest service
    Then moi report is returned with the ugf variant "TPM3-ALK.T7A20" as an amoi
    """
    [{"version":"2015-08-06","exclusion":false,"treatment_arm_id":"APEC1621-A","stratum_id":"100","amoi_status":"CURRENT"}]
    """
    Examples:
      |tsvFile                  |TAFile           |
      |113re_gene-fusion    |APEC1621-A.json  |

