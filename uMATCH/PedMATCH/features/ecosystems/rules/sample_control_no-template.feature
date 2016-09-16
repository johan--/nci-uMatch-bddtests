@rules
Feature: Sample control tests for no template control

  Scenario: SC-NT_01: Verify that when the variant report contains variants then the status of the NTC variant report is set to FAILED
    Given a tsv variant report file file "NTC_variantReport-Failed" and treatment arms file "MultiTAs.json"
    When the no_template service is called
    Then the report status return is "FAILED"
    Then moi report is returned with the snv variant "COSM6224"

  Scenario: SC-NT_02: Verify that when the variant report contains no variants (none passes the filters) then the status of the NTC variant report is set to PASSED
    Given a tsv variant report file file "NTC_variantReport-Passed" and treatment arms file "MultiTAs.json"
    When the no_template service is called
    Then the report status return is "PASSED"
    Then moi report is returned with 0 snv variants
    Then moi report is returned with 0 cnv variants
    Then moi report is returned with 0 indel variants
    Then moi report is returned with 0 ugf variants