@rules_p2
Feature: Sample control tests for positive control

  Scenario: SC-PC_01: Verify that when the variant report matches the positive controls, the status returned is PASSED
    Given a tsv variant report file "samplecontrol_all-matched_v2" and treatment arms file "MultiTAs.json"
    When the positive_control service is called
    Then the report status return is "PASSED"

  Scenario: SC-PC_02: Verify that when the variant report matches the positive controls, there are no variants in the false positives
    Given a tsv variant report file "samplecontrol_all-matched_v2" and treatment arms file "MultiTAs.json"
    When the positive_control service is called
    Then false positive variants is returned with 0 variants
    And match is true for "all" variants in the positive variants

  Scenario: SC-PC_03: Verify that when the variant report matches the positive controls, the match value returned is true
    Given a tsv variant report file "samplecontrol_all-matched_v2" and treatment arms file "MultiTAs.json"
    When the positive_control service is called
    And match is true for "all" variants in the positive variants

  Scenario: SC-PC_04: Verify that when the variant report matches the positive controls, there are 12 variants in the positive_variants
    Given a tsv variant report file "samplecontrol_all-matched_v2" and treatment arms file "MultiTAs.json"
    When the positive_control service is called
    Then positive variants is returned with 12 variants

  Scenario: SC-PC_05: Verify that when the variants don't match the positive controls the status returned is FAILED
    Given a tsv variant report file "with-negative-variants2" and treatment arms file "MultiTAs.json"
    When the positive_control service is called
    Then the report status return is "FAILED"

  Scenario: SC-PC_06: Verify that the variants that don't match the positive controls are in the false positives
    Given a tsv variant report file "with-negative-variants2" and treatment arms file "MultiTAs.json"
    When the positive_control service is called
    Then false positive variants is returned with 3 variants
    Then variant type "CNV" with "MET" is found in the False positives table
    Then variant type "CNV" with "ATM" is found in the False positives table
    Then variant type "SNP" with "COSM11356" is found in the False positives table


  Scenario: SC-PC_07: Verify that when the variant report does not match the positive controls the status returned is FAILED
    Given a tsv variant report file "MATCHControl_v1_MATCHControl_RNA_v1" and treatment arms file "MultiTAs.json"
    When the positive_control service is called
    Then the report status return is "FAILED"

  Scenario: SC-PC_08: Verify that when the variant report does not match the positive controls the unmatching variants are marked as false
    Given a tsv variant report file "MATCHControl_v1_MATCHControl_RNA_v1" and treatment arms file "MultiTAs.json"
    When the positive_control service is called
    And match is false for "ALK-PTPN3" variants in the positive variants
    And match is false for "MET-MET" variants in the positive variants

  Scenario: SC-PC_09: Verify that when the variant report (vcf version 5.2) matches the positive controls (version 5.2) and the RAD51* and CDK12 genes are filtered out, and the status returned is PASSED
    Given a tsv variant report file "RAD51-Filter" and treatment arms file "MultiTAs.json"
    When the positive_control service is called
    Then the report status return is "PASSED"
    Then the gene "CDK12" is filtered out from the positive control variant report
    Then the gene "RAD51B" is filtered out from the positive control variant report
    Then the gene "RAD51" is filtered out from the positive control variant report
    Then the gene "RAD51C" is filtered out from the positive control variant report

