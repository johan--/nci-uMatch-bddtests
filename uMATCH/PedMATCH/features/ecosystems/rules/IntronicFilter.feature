Feature: Matchbox should only filter in variants that are exonic.
  @rules_p1
  Scenario: Filter out variants whose location is not exonic
    Given a tsv variant report file "intronicfilter2" and treatment arms file "APEC1621-B.json"
    When call the amoi rest service
    Then quality control json file should be generated
    Then moi report is returned with the snv variant "MAN105"
    Then moi report is returned with the snv variant "COSM3972885"
    And following variants can be found in quality control json
      | category   | identifier | variant_type | position  |
      | snv_indels | intest1    | snp          | 120471857 |
      | snv_indels | intest2    | snp          | 21968199  |
      | snv_indels | OMINDEL630 | del          | 116411882 |
      | snv_indels | OMINDEL651 | del          | 116412031 |