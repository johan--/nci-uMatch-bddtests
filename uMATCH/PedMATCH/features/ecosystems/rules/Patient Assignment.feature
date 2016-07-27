@rules
@demo
Feature: Ensure the rules are fired correctly and patients are assigned to the right treatment arm::

  Scenario: Matching inclusion gene fusion variant and inclusion disease - Assign to TA
    Given  the patient assignment json "patient_json_with_matching_inclusion_variant_inclusion_disease"
    And treatment arm json "Rules-Test1"
    When assignPatient service is called
    Then a patient assignment json is returned with patient_assignment_reason "SELECTED" for treatment arm "Rules-Test1"

  Scenario: Matching inclusion gene fusion variant but does not match inclusion disease - Do not assign
    Given  the patient assignment json "patient_json_with_matching_inclusion_variant_and_not_inclusion_disease"
    And treatment arm json "Rules-Test1"
    When assignPatient service is called
    Then a patient assignment json is returned with patient_assignment_reason "NO_VARIANT_MATCH" for treatment arm "Rules-Test1"

  Scenario: Matching inclusion disease but does not match inclusion variant - Do not assign
    Given  the patient assignment json "patient_json_with_non_matching_inclusion_variant_matching_inclusion_disease"
    And treatment arm json "Rules-Test1"
    When assignPatient service is called
    Then a patient assignment json is returned with patient_assignment_reason "NO_VARIANT_MATCH" for treatment arm "Rules-Test1"

  Scenario: Matching inclusion variant but treatment arm does not contain inclusion disease - Assign
    Given  the patient assignment json "patient_json_with_matching_inclusion_variant_inclusion_disease"
    And treatment arm json "Rules-Test1b"
    When assignPatient service is called
    Then a patient assignment json is returned with patient_assignment_reason "SELECTED" for treatment arm "Rules-Test1b"

  Scenario: Matching exclusion variant - Don't assign to TA
    Given  the patient assignment json "patient_json_with_matching_exclusion_variant_inclusion_disease"
    And treatment arm json "Rules-Test2"
    When assignPatient service is called
    Then a patient assignment json is returned with patient_assignment_reason "RECORD_BASED_EXCLUSION" for treatment arm "Rules-Test2"

  Scenario: Matching non-hotspot rule - oncomine variant class
    Given  the patient assignment json "patient_json_with_matching_non-hotspot-rules"
    And treatment arm json "Rules-Test3"
    When assignPatient service is called
    Then a patient assignment json is returned with patient_assignment_reason "SELECTED" for treatment arm "Rules-Test3"

  Scenario: Matching non-hotspot rule - function
    Given  the patient assignment json "patient_json_with_matching_non-hotspot-rules_function-match"
    And treatment arm json "Rules-Test4"
    When assignPatient service is called
    Then a patient assignment json is returned with patient_assignment_reason "SELECTED" for treatment arm "Rules-Test4"

  Scenario: Matching non-hotspot rule - gene and exon
    Given  the patient assignment json "patient_json_with_matching_non-hotspot-rules_gene-exon-match"
    And treatment arm json "Rules-Test5"
    When assignPatient service is called
    Then a patient assignment json is returned with patient_assignment_reason "SELECTED" for treatment arm "Rules-Test5"

  Scenario: Matching exclusion disease
    Given  the patient assignment json "patient_json_with_matching_inclusion_variant_exclusion_disease"
    And treatment arm json "Rules-Test1"
    When assignPatient service is called
    Then a patient assignment json is returned with patient_assignment_reason "RECORD_BASED_EXCLUSION" for treatment arm "Rules-Test1"

  Scenario: Matching exclusion drugs - DO not Assign
    Given  the patient assignment json "patient_json_with_matching_inclusion_variant_inclusion_disease_and_exclusion_drugs"
    And treatment arm json "Rules-Test1"
    When assignPatient service is called
    Then a patient assignment json is returned with patient_assignment_reason "RECORD_BASED_EXCLUSION" for treatment arm "Rules-Test1"

  Scenario: Matching inclusion and exclusion variant on the same treatment arm - Do not assign
    Given  the patient assignment json "patient_json_with_matching_inclusion_and_exclusion_variant_inclusion_disease"
    And treatment arm json "Rules-Test2"
    When assignPatient service is called
    Then a patient assignment json is returned with patient_assignment_reason "RECORD_BASED_EXCLUSION" for treatment arm "Rules-Test2"

  Scenario: Matching unconfirmed inclusion variant - Do not assign
    Given  the patient assignment json "patient_json_with_matching_unconfirmed_inclusion_variant_inclusion_disease"
    And treatment arm json "Rules-Test1"
    When assignPatient service is called
    Then a patient assignment json is returned with patient_assignment_reason "NO_VARIANT_MATCH" for treatment arm "Rules-Test1"

#
#  Scenario: Compasionate care (Patient eligible to be assigned but the treatment arm is closed

#  Scenario: Matching patient who has already taken the eligible arm and progressed




