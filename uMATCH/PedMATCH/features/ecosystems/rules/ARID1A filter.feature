@rules_p1
Feature: Filer out the variant COSM298325 if AF < 10%

  Scenario: COSM298325 is filtered in if AF >= 10%
    Given a tsv variant report file "COSM298325_filter" and treatment arms file "APEC1621-B.json"
    When call the amoi rest service
    Then quality control json file should be generated
    Then moi report is returned with the indel variant "COSM298325"

  Scenario: COSM298325 is filtered out if AF < 10%
    Given a tsv variant report file "COSM298325_filter_out" and treatment arms file "APEC1621-B.json"
    When call the amoi rest service
    Then quality control json file should be generated
    Then moi report is returned without the indel variant "COSM298325"