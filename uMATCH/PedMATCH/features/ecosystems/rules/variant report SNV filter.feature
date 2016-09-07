@rules
Feature: Test the functionality that filters the SNV variants based on specified filter criteria


  Scenario Outline: Filter-out a SNV variant that has a location value as 'intronic' when the ova, function and exon are missing
    #   If snv has the location annotated (not guaranteed) and that
    #   annotation states that it is intronic, reject the snv as those should
    #   not be in the variant report.

    #  Some variants are not annotated with location and if this is the case
    #  check the identifier, ova, exon, and function. If all of those are
    #  missing than the location is intronic and we filter it out.

    Given a tsv variant report file file "<tsvFile>" and treatment arms file "<TAFile>"
    When call the amoi rest service
    Then moi report is returned with the snv variant "match769.2" as an amoi
    And amoi treatment arm names for snv variant "match769.2" include:
    """
    [{"version":"2015-08-06", "exclusion":false, "treatment_arm_id":"SNV_location_intronic", "stratum_id":"100", "amoi_status":"CURRENT"}]
    """
    Then moi report is returned with the snv variant "." as an amoi
    Examples:
      |tsvFile                                    |TAFile                         |ta                           |
      |SNV_location_intronic.tsv                  |SNV_location_intronic_TA.json  |["SNV_location_intronic100"] |


  Scenario Outline: Filter-out a SNV variant that does not have a PASS filter
    Given a tsv variant report file file "<tsvFile>" and treatment arms file "<TAFile>"
    When call the amoi rest service
    Then moi report is returned without the snv variant "match769.3.1"
    Examples:
      |tsvFile                                    |TAFile                         |
      |SNV_NO_PASS_filter.tsv                     |SNV_location_intronic_TA.json  |


  Scenario Outline: Filter out SVN variants with allele frequency less than 0.05%
    Given a tsv variant report file file "<tsvFile>" and treatment arms file "<TAFile>"
    When call the amoi rest service
    Then moi report is returned without the snv variant "match769.3.2"
    Examples:
      |tsvFile                                    |TAFile                         |
      |SNV_NO_PASS_filter.tsv                     |SNV_location_intronic_TA.json  |


  Scenario Outline: Filter out SVN variants with FAO less than 25
    Given a tsv variant report file file "<tsvFile>" and treatment arms file "<TAFile>"
    When call the amoi rest service
    Then moi report is returned without the snv variant "match769.3.4"
    Examples:
      |tsvFile                                    |TAFile                         |
      |SNV_NO_PASS_filter.tsv                     |SNV_location_intronic_TA.json  |


  Scenario Outline: Filter-out SVN variants with function 'synonymous'
    Given a tsv variant report file file "<tsvFile>" and treatment arms file "<TAFile>"
    When call the amoi rest service
    Then moi report is returned without the snv variant "match769.3.7"
    Examples:
      |tsvFile                                    |TAFile                         |
      |SNV_NO_PASS_filter.tsv                     |SNV_location_intronic_TA.json  |


  Scenario Outline: Filter-in SVN variants with valid function name
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
    Given a tsv variant report file file "<tsvFile>" and treatment arms file "<TAFile>"
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
      |tsvFile                                    |TAFile                         |
      |SNV_NO_PASS_filter.tsv                     |SNV_location_intronic_TA.json  |

  Scenario Outline: Filter-out all Germline SNV variants
    Given a tsv variant report file file "<tsvFile>" and treatment arms file "<TAFile>"
    When call the amoi rest service
    Then moi report is returned with 0 snv variants
    Examples:
      |tsvFile                                    |TAFile                         |
      |SNV_Germline_filter.tsv                    |SNV_location_intronic_TA.json  |


  Scenario Outline: Filter-in SNVs if oncomine variant class has the value deleterious
    Given a tsv variant report file file "<tsvFile>" and treatment arms file "<TAFile>"
    When call the amoi rest service
    Then moi report is returned with 1 snv variants
    Examples:
      |tsvFile                                    |TAFile                         |
      |SNV_OVA_deleterious_filter.tsv             |SNV_location_intronic_TA.json  |


  Scenario Outline: Filter-in SNVs if oncomine variant class has the value hotspot
    Given a tsv variant report file file "<tsvFile>" and treatment arms file "<TAFile>"
    When call the amoi rest service
    Then moi report is returned with 1 snv variants
    Examples:
      |tsvFile                                    |TAFile                         |
      |SNV_OVA_hotspot_filter.tsv                 |SNV_location_intronic_TA.json  |


  Scenario Outline: Filter-in SNVs if the variant matches a non-hotspot rule of a treatment arm
    Given a tsv variant report file file "<tsvFile>" and treatment arms file "<TAFile>"
    When call the amoi rest service
    Then moi report is returned with the snv variant "moip-1" as an amoi
    Examples:
      |tsvFile                        |TAFile           |
      |SNV_nhr_filter.tsv             |APEC1621-B.json  |

