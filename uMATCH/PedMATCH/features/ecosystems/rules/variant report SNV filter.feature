Feature: Test the functionality that filters the SNV variants based on specified filter criteria

  @rules_p1
  Scenario Outline: FIL-SNV_01: Filter-out a SNV variant that has a location value as 'intronic' when the ova, function and exon are missing
    #   If snv has the location annotated (not guaranteed) and that
    #   annotation states that it is intronic, reject the snv as those should
    #   not be in the variant report.

    #  Some variants are not annotated with location and if this is the case
    #  check the identifier, ova, exon, and function. If all of those are
    #  missing than the location is intronic and we filter it out.

    Given a tsv variant report file "<tsvFile>" and treatment arms file "<TAFile>"
    When call the amoi rest service
    Then moi report is returned with the snv variant "match769.2" as an amoi
    And amoi treatment arm names for snv variant "match769.2" include:
    """
    [{"version":"2015-08-06", "exclusion":false, "treatment_arm_id":"SNV_location_intronic", "stratum_id":"100", "amoi_status":"CURRENT"}]
    """
    Then moi report is returned with the snv variant "." as an amoi
    Examples:
      | tsvFile               | TAFile                        | ta                           |
      | SNV_location_intronic | SNV_location_intronic_TA.json | ["SNV_location_intronic100"] |

  @rules_p1
  Scenario Outline: FIL-SNV_02: Filter-out a SNV variant that does not have a PASS filter
    Given a tsv variant report file "<tsvFile>" and treatment arms file "<TAFile>"
    When call the amoi rest service
    Then moi report is returned without the snv variant "match769.3.1"
    Examples:
      | tsvFile            | TAFile                        |
      | SNV_NO_PASS_filter | SNV_location_intronic_TA.json |

  @rules_p1
  Scenario Outline: FIL-SNV_03: Filter out SVN variants with allele frequency less than 0.05%
    Given a tsv variant report file "<tsvFile>" and treatment arms file "<TAFile>"
    When call the amoi rest service
    Then moi report is returned without the snv variant "match769.3.2"
    Examples:
      | tsvFile            | TAFile                        |
      | SNV_NO_PASS_filter | SNV_location_intronic_TA.json |

  @rules_p1
  Scenario Outline: FIL-SNV_04: Filter out SVN variants with FAO less than 25
    Given a tsv variant report file "<tsvFile>" and treatment arms file "<TAFile>"
    When call the amoi rest service
    Then moi report is returned without the snv variant "match769.3.4"
    Examples:
      | tsvFile            | TAFile                        |
      | SNV_NO_PASS_filter | SNV_location_intronic_TA.json |

  @rules_p1
  Scenario Outline: FIL-SNV_05: Filter-out SVN variants with function 'synonymous'
    Given a tsv variant report file "<tsvFile>" and treatment arms file "<TAFile>"
    When call the amoi rest service
    Then moi report is returned without the snv variant "match769.3.7"
    Examples:
      | tsvFile            | TAFile                        |
      | SNV_NO_PASS_filter | SNV_location_intronic_TA.json |

  @rules_p1
  Scenario Outline: FIL-SNV_06: Filter-in SVN variants with valid function name
  -refallele
  -unknown
  -missense
  -nonsense
  -frameshiftinsertion
  -frameshiftdeletion
  -nonframeshiftinsertion
  -nonframeshiftdeletion
  -stoploss
  -frameshiftblocksubstitution
  -nonframeshiftblocksubstitution
    Given a tsv variant report file "<tsvFile>" and treatment arms file "<TAFile>"
    When call the amoi rest service
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
    Examples:
      | tsvFile            | TAFile                        |
      | SNV_NO_PASS_filter | SNV_location_intronic_TA.json |

  @rules_p1
  Scenario Outline: FIL-SNV_07: Filter-out all Germline SNV variants
    Given a tsv variant report file "<tsvFile>" and treatment arms file "<TAFile>"
    When call the amoi rest service
    Then moi report is returned with 0 snv variants
    Examples:
      | tsvFile             | TAFile                        |
      | SNV_Germline_filter | SNV_location_intronic_TA.json |

  @rules_p1
  Scenario Outline: FIL-SNV_08: Filter-in SNVs if oncomine variant class has the value deleterious
    Given a tsv variant report file "<tsvFile>" and treatment arms file "<TAFile>"
    When call the amoi rest service
    Then moi report is returned with 1 snv variants
    Examples:
      | tsvFile                    | TAFile                        |
      | SNV_OVA_deleterious_filter | SNV_location_intronic_TA.json |

  @rules_p1
  Scenario Outline: FIL-SNV_09: Filter-in SNVs if oncomine variant class has the value hotspot
    Given a tsv variant report file "<tsvFile>" and treatment arms file "<TAFile>"
    When call the amoi rest service
    Then moi report is returned with 1 snv variants
    Examples:
      | tsvFile                | TAFile                        |
      | SNV_OVA_hotspot_filter | SNV_location_intronic_TA.json |

  @rules_p1
  Scenario Outline: FIL-SNV_10a: Filter-in SNVs if the variant matches a non-hotspot rule of a treatment arm
    Given a tsv variant report file "<tsvFile>" and treatment arms file "<TAFile>"
    When call the amoi rest service
    Then moi report is returned with the snv variant "<id>" as an amoi
    Examples:
      | tsvFile             | TAFile          | id     |
      | SNV_nhr_filter      | APEC1621-B.json | moip-1 |
      | FIL-SNV_10a_dot_snp | FIL-SNV_10.json | .      |
      | FIL-SNV_10a_dot_mnp | FIL-SNV_10.json | .      |
      | FIL-SNV_10a_dot_ins | FIL-SNV_10.json | .      |
      | FIL-SNV_10a_dot_del | FIL-SNV_10.json | .      |

  @rules_p1
  Scenario Outline: FIL-SNV_10b: Filter-out "." SNV if the variant doesn't match non-hotspot rule of treatment arm
    Given a tsv variant report file "<tsvFile>" and treatment arms file "<TAFile>"
    When call the amoi rest service
    Then returned moi report should not have snv variant "<id>"
    Examples:
      | tsvFile             | TAFile          | id |
#      | SNV_nhr_filter      | APEC1621-B.json | moip-2 |
      | FIL-SNV_10b_dot_snp | FIL-SNV_10.json | .  |
      | FIL-SNV_10b_dot_mnp | FIL-SNV_10.json | .  |
      | FIL-SNV_10b_dot_ins | FIL-SNV_10.json | .  |
      | FIL-SNV_10b_dot_del | FIL-SNV_10.json | .  |

  @rules_p1
  Scenario Outline: FIL-SNV_11: Remove duplicate hotspot variants
    Given a tsv variant report file "<tsvFile>" and treatment arms file "<TAFile>"
    When call the amoi rest service
    Then moi report is returned with the snv variant "COSM893813"
    Examples:
      | tsvFile                 | TAFile          |
      | vcfWithDuplicateHotspot | APEC1621-B.json |

  @rules_p3
  Scenario Outline: FIL-SNV_12: Rule can map snv(snp) and mnv(mnp) variant types properly
    #in tsv file, 769.2 is mnp, . is snp
    #in treatment arm a json, 769.2 is mnv, . is snv
    #in treatment arm b json, 769.2 is snv, . is mnv
    #in treatment arm c json, 769.2 is ins, . is fusion
    Given a tsv variant report file "FIL-SNV_12" and treatment arms file "<TAFile>"
    When call the amoi rest service
    Then in moi report the snv variant "match769.2" has "<amoi_count1>" amois
    And in moi report the snv variant "match769.2" type is "mnp"
    Then in moi report the snv variant "." has "<amoi_count2>" amois
    And in moi report the snv variant "." type is "snp"
    Examples:
      | TAFile              | amoi_count1 | amoi_count2 |
      | FIL_SNV_12a_TA.json | 1           | 1           |
      | FIL_SNV_12b_TA.json | 1           | 1           |
      | FIL_SNV_12c_TA.json | 0           | 0           |