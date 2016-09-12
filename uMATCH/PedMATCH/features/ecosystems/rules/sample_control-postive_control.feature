@rules
Feature: Sample control tests for positive control

  Scenario:Verify that when the variant report matches the positive controls, the status returned is PASSED
    Given a tsv variant report file file "samplecontrol_all-matched_v2.tsv" and treatment arms file "MultiTAs.json"
    When the positive_control service is called
    Then the report status return is "PASSED"

  Scenario:Verify that when the variant report matches the positive controls, there are no variants in the false positives
    Given a tsv variant report file file "samplecontrol_all-matched_v2.tsv" and treatment arms file "MultiTAs.json"
    When the positive_control service is called
    Then false positive variants is returned with 0 variants
    And match is true for "all" variants in the positive variants

  Scenario:Verify that when the variant report matches the positive controls, the match value returned is true
    Given a tsv variant report file file "samplecontrol_all-matched_v2.tsv" and treatment arms file "MultiTAs.json"
    When the positive_control service is called
    And match is true for "all" variants in the positive variants

  Scenario:Verify that when the variant report matches the positive controls, there are 12 variants in the positive_variants
    Given a tsv variant report file file "samplecontrol_all-matched_v2.tsv" and treatment arms file "MultiTAs.json"
    When the positive_control service is called
    Then positive variants is returned with 12 variants

  Scenario: Verify that when the variants don't match the positive controls the status returned is FAILED
    Given a tsv variant report file file "with-negative-variants2.tsv" and treatment arms file "MultiTAs.json"
    When the positive_control service is called
    Then the report status return is "FAILED"

  Scenario: Verify that the variants that don't match the positive controls are in the false positives
    Given a tsv variant report file file "with-negative-variants2.tsv" and treatment arms file "MultiTAs.json"
    When the positive_control service is called
    Then false positive variants is returned with 3 variants
    Then variant type "CNV" with "MET" is found in the False positives table
    Then variant type "CNV" with "ATM" is found in the False positives table
    Then variant type "SNP" with "COSM11356" is found in the False positives table


  Scenario: Verify that when the variant report does not match the positive controls the status returned is FAILED
    Given a tsv variant report file file "MATCHControl_v1_MATCHControl_RNA_v1.tsv" and treatment arms file "MultiTAs.json"
    When the positive_control service is called
    Then the report status return is "FAILED"

  Scenario: Verify that when the variant report does not match the positive controls the unmatching variants are marked as false
    Given a tsv variant report file file "MATCHControl_v1_MATCHControl_RNA_v1.tsv" and treatment arms file "MultiTAs.json"
    When the positive_control service is called
    And match is false for "ALK-PTPN3" variants in the positive variants
    And match is false for "MET-MET" variants in the positive variants
