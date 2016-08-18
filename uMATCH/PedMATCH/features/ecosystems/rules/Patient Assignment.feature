@rules
Feature: Ensure the rules are fired correctly and patients are assigned to the right treatment arm::

  Scenario: Matching inclusion gene fusion variant and inclusion disease - Assign to TA
    Given  the patient assignment json "patient_json_with_matching_inclusion_variant_inclusion_disease"
    And treatment arm json "Rules-Test1"
    When assignPatient service is called
    Then a patient assignment json is returned with reason category "SELECTED" for treatment arm "Rules-Test1"

  Scenario: Matching inclusion gene fusion variant but does not match inclusion disease - Do not assign
    Given  the patient assignment json "patient_json_with_matching_inclusion_variant_and_not_inclusion_disease"
    And treatment arm json "Rules-Test1"
    When assignPatient service is called
    Then a patient assignment json is returned with reason category "NO_VARIANT_MATCH" for treatment arm "Rules-Test1"

  Scenario: Matching inclusion disease but does not match inclusion variant - Do not assign
    Given  the patient assignment json "patient_json_with_non_matching_inclusion_variant_matching_inclusion_disease"
    And treatment arm json "Rules-Test1"
    When assignPatient service is called
    Then a patient assignment json is returned with reason category "NO_VARIANT_MATCH" for treatment arm "Rules-Test1"

  Scenario: Matching inclusion variant but treatment arm does not contain inclusion disease - Assign
    Given  the patient assignment json "patient_json_with_matching_inclusion_variant_inclusion_disease"
    And treatment arm json "Rules-Test1b"
    When assignPatient service is called
    Then a patient assignment json is returned with reason category "SELECTED" for treatment arm "Rules-Test1b"

  Scenario: Matching exclusion variant - Don't assign to TA
    Given  the patient assignment json "patient_json_with_matching_exclusion_variant_inclusion_disease"
    And treatment arm json "Rules-Test2"
    When assignPatient service is called
    Then a patient assignment json is returned with reason category "RECORD_BASED_EXCLUSION" for treatment arm "Rules-Test2"

  Scenario: Matching non-hotspot rule - oncomine variant class
    Given  the patient assignment json "patient_json_with_matching_non-hotspot-rules"
    And treatment arm json "Rules-Test3"
    When assignPatient service is called
    Then a patient assignment json is returned with reason category "SELECTED" for treatment arm "Rules-Test3"

  Scenario: Matching non-hotspot rule - function
    Given  the patient assignment json "patient_json_with_matching_non-hotspot-rules_function-match"
    And treatment arm json "Rules-Test4"
    When assignPatient service is called
    Then a patient assignment json is returned with reason category "SELECTED" for treatment arm "Rules-Test4"

  Scenario: Matching non-hotspot rule - gene and exon
    Given  the patient assignment json "patient_json_with_matching_non-hotspot-rules_gene-exon-match"
    And treatment arm json "Rules-Test5"
    When assignPatient service is called
    Then a patient assignment json is returned with reason category "SELECTED" for treatment arm "Rules-Test5"

  Scenario: Matching exclusion disease - Do not assign
    Given  the patient assignment json "patient_json_with_matching_inclusion_variant_exclusion_disease"
    And treatment arm json "Rules-Test1"
    When assignPatient service is called
    Then a patient assignment json is returned with reason category "RECORD_BASED_EXCLUSION" for treatment arm "Rules-Test1"

  Scenario: Matching exclusion drugs - DO not Assign
    Given  the patient assignment json "patient_json_with_matching_inclusion_variant_inclusion_disease_and_exclusion_drugs"
    And treatment arm json "Rules-Test1"
    When assignPatient service is called
    Then a patient assignment json is returned with reason category "RECORD_BASED_EXCLUSION" for treatment arm "Rules-Test1"

  Scenario: Matching inclusion and exclusion variant on the same treatment arm - Do not assign
    Given  the patient assignment json "patient_json_with_matching_inclusion_and_exclusion_variant_inclusion_disease"
    And treatment arm json "Rules-Test2"
    When assignPatient service is called
    Then a patient assignment json is returned with reason category "RECORD_BASED_EXCLUSION" for treatment arm "Rules-Test2"

  Scenario: Matching unconfirmed inclusion variant - Do not assign
    Given  the patient assignment json "patient_json_with_matching_unconfirmed_inclusion_variant_inclusion_disease"
    And treatment arm json "Rules-Test1"
    When assignPatient service is called
    Then a patient assignment json is returned with reason category "NO_VARIANT_MATCH" for treatment arm "Rules-Test1"

  Scenario: IHC:POS, Variant:PRE, Assay Result:POS, Matching Variant - Assign
    Given  the patient assignment json "Assay_rules_POS_PRE_POS_matching_variant"
    And treatment arm json "Rules-Test6"
    When assignPatient service is called
    Then a patient assignment json is returned with reason category "SELECTED" for treatment arm "Rules-Test6"

  Scenario: IHC:NEG, Variant:PRE, Assay Result:NEG, Matching Variant - Assign
    Given  the patient assignment json "Assay_rules_NEG_PRE_NEG_matching_variant"
    And treatment arm json "Rules-Test7"
    When assignPatient service is called
    Then a patient assignment json is returned with reason category "SELECTED" for treatment arm "Rules-Test7"

  Scenario: IHC:POS, Variant:EMP, Assay Result:POS, No Matching Variant - Assign
    Given  the patient assignment json "Assay_rules_POS_EMP_POS_no_matching_variant"
    And treatment arm json "Rules-Test8"
    When assignPatient service is called
    Then a patient assignment json is returned with reason category "SELECTED" for treatment arm "Rules-Test8"

  Scenario: IHC:POS, Variant:NEG, Assay Result:POS, Matching Variant - Do not Assign
    Given  the patient assignment json "Assay_rules_POS_NEG_POS_matching_variant"
    And treatment arm json "Rules-Test9"
    When assignPatient service is called
    Then a patient assignment json is returned with reason category "RECORD_BASED_EXCLUSION" for treatment arm "Rules-Test9"

  Scenario: IHC:POS, Variant:PRE, Assay Result:POS, No Matching Variant - Do not Assign
    Given  the patient assignment json "Assay_rules_POS_PRE_POS_no_matching_variant"
    And treatment arm json "Rules-Test6"
    When assignPatient service is called
    Then a patient assignment json is returned with reason category "NO_VARIANT_MATCH" for treatment arm "Rules-Test6"

  Scenario: IHC:POS, Variant:NEG, Assay Result:POS, No Matching Variant - Assign
    Given  the patient assignment json "Assay_rules_POS_NEG_POS_no_matching_variant"
    And treatment arm json "Rules-Test9"
    When assignPatient service is called
    Then a patient assignment json is returned with reason category "SELECTED" for treatment arm "Rules-Test9"

  Scenario: IHC:POS, Variant:EMP, Assay Result:POS, Matching Variant - Assign
    Given  the patient assignment json "Assay_rules_POS_EMP_POS_matching_variant"
    And treatment arm json "Rules-Test8"
    When assignPatient service is called
    Then a patient assignment json is returned with reason category "SELECTED" for treatment arm "Rules-Test8"

  Scenario: IHC:NEG, Variant:PRE, Assay Result:POS, Matching Variant - Assign
    Given  the patient assignment json "Assay_rules_NEG_PRE_POS_matching_variant"
    And treatment arm json "Rules-Test7"
    When assignPatient service is called
    Then a patient assignment json is returned with reason category "SELECTED" for treatment arm "Rules-Test7"

  Scenario: IHC:POS, Variant:PRE, Assay Result:NEG, Matching Variant - Assign
    Given  the patient assignment json "Assay_rules_POS_PRE_NEG_matching_variant"
    And treatment arm json "Rules-Test6"
    When assignPatient service is called
    Then a patient assignment json is returned with reason category "SELECTED" for treatment arm "Rules-Test6"

  Scenario: IHC:POS, Variant:EMP, Assay Result:NEG, Matching variant - assign
    Given  the patient assignment json "Assay_rules_POS_EMP_NEG_matching_variant"
    And treatment arm json "Rules-Test8"
    When assignPatient service is called
    Then a patient assignment json is returned with reason category "SELECTED" for treatment arm "Rules-Test8"

  Scenario: Matching exclusion non-hotspot variants - Do not assign
    Given  the patient assignment json "patient_json_with_matching_non-hotspot-rules_gene-exon-match"
    And treatment arm json "Rules-Test10"
    When assignPatient service is called
    Then a patient assignment json is returned with reason category "NO_VARIANT_MATCH" for treatment arm "Rules-Test10"

  Scenario: Matching both inclusion and exclusion non-hotspot variants - Do not assign
    Given  the patient assignment json "Matching_exclusion_non-hotspot_rule_and_inclusion_variant"
    And treatment arm json "Rules-Test11"
    When assignPatient service is called
    Then a patient assignment json is returned with reason category "NO_VARIANT_MATCH" for treatment arm "Rules-Test11"

  Scenario: Matching at least one exclusion non-hotspot variant - Do not assign
    Given  the patient assignment json "patient_json_with_matching_non-hotspot-rules_gene-exon-match"
    And treatment arm json "Rules-Test12"
    When assignPatient service is called
    Then a patient assignment json is returned with reason category "NO_VARIANT_MATCH" for treatment arm "Rules-Test12"

  Scenario: Matching on a closed TA puts the patient on compassionate care
    Given  the patient assignment json "patient_json_with_matching_inclusion_variant_inclusion_disease"
    And treatment arm json "Rules-Test1-CLOSED"
    When assignPatient service is called
    Then the patient assignment reason is "REQUESTED_COM_CARE"

  Scenario: Matching on a suspended TA puts the patient on compassionate care
    Given  the patient assignment json "patient_json_with_matching_inclusion_variant_inclusion_disease"
    And treatment arm json "Rules-Test1-SUSPENDED"
    When assignPatient service is called
    Then the patient assignment reason is "REQUESTED_COM_CARE"

  Scenario: Tie-breaker - Level of Evidence: the lower the value the greater the level of evidence tie-breaker  is applied to choose a treatment arm.
    Given  the patient assignment json "Patient_tie-breaker"
    And treatment arm json "tie-breaker_LOE_TA"
    When assignPatient service is called
    Then a patient assignment json is returned with reason category "LEVEL_OF_EVIDENCE_TIE_BREAKER" for treatment arm "TB_LOE_Rules-Test1a"
    Then a patient assignment json is returned with reason category "SELECTED" for treatment arm "TB_LOE_Rules-Test1b"

  Scenario: Tie-breaker - lesser accrued arm tie-breaker is applied to choose a treatment arm
    Given  the patient assignment json "Patient_tie-breaker"
    And treatment arm json "tie-breaker_lowest-accural_TA"
    When assignPatient service is called
    Then a patient assignment json is returned with reason category "SMALLEST_ACCRUED_NUMBER_TIE_BREAKER" for treatment arm "TB_LOE_Rules-Test1b"
    Then a patient assignment json is returned with reason category "SELECTED" for treatment arm "TB_LOE_Rules-Test1a"

  Scenario: Tie-breaker - maximum number of patients is not used to determine patient assignment to TA
    Given  the patient assignment json "Patient_tie-breaker"
    And treatment arm json "tie-breaker_maxNumPatients_TA"
    When assignPatient service is called
    Then a patient assignment json is returned with reason category "SMALLEST_ACCRUED_NUMBER_TIE_BREAKER" for treatment arm "TB_LOE_Rules-Test1b"
    Then a patient assignment json is returned with reason category "SELECTED" for treatment arm "TB_LOE_Rules-Test1a"

  Scenario: Tie-breaker - Allele frequency tie-breaker is applied to choose a treatment arm.
    Given  the patient assignment json "Patient_AF_tie-breaker"
    And treatment arm json "tie-breaker_AF_TA"
    When assignPatient service is called
    Then a patient assignment json is returned with reason category "ALLELE_FREQUENCY_TIE_BREAKER" for treatment arm "TB_LOE_Rules-Test1a"
    Then a patient assignment json is returned with reason category "SELECTED" for treatment arm "TB_LOE_Rules-Test1b"


  Scenario: Tie-breaker - Randomizer is applied to a choose a treatment arm
    Given  the patient assignment json "Patient_tie-breaker"
    And treatment arm json "tie-breaker_Randomizer_TA"
    When assignPatient service is called
    Then the patient assignment reason is "AVAILABLE"
#@rules
#  Scenario: Tie-breaker - patients with 2 variants one with readDepth >=450 and another variant with readDepth < 450, will be assigned to a treatment arm with matching variant with readDepth >=450
#    Given  the patient assignment json "Patient_read-depth_tie-breaker"
#    And treatment arm json "tie-breaker_read-depth_TA"
#    When assignPatient service is called
#    Then the patient assignment reason is "AVAILABLE"






