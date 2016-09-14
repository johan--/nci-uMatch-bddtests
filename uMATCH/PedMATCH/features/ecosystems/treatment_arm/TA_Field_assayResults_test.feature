#encoding: utf-8

@treatment_arm
Feature: TA_AR1. Treatment Arm API Tests that focus on assay_rules
  Scenario Outline: assay_rules with valid values should pass
    Given template treatment arm json with an id: "<treatment_arm_id>"
    Then add assayResult with gene: "<gene>", type: "<type>", assay_result_status: "<status>", assay_variant: "<variant>", LOE: "<loe>" and description: "<description>"
    When creating a new treatment arm using post request
    Then a success message is returned
    Then retrieve the posted treatment arm from API
    Then the returned treatment arm has assayResult (gene: "<gene>", type: "<type>", assay_result_status: "<status>", assay_variant: "<variant>", LOE: "<loe>", description: "<description>")
    Examples:
      |treatment_arm_id     |gene  | type | status          |variant    |loe       |description           |
      |APEC1621-AR1-1       |PTEN  | IHC  |POSITIVE        |PRESENT    |2.0       |null                  |
      |APEC1621-AR1-2       |MSCH2 | IHC  |NEGATIVE        |NEGATIVE   |1.0       |description           |
      |APEC1621-AR1-3       |MLH1  | IHC  |INDETERMINATE   |EMPTY      |3.0       |the other description |

  Scenario Outline: TA_AR2. assay_rules with invalid values should fail
    Given template treatment arm json with a random id
    Then add assayResult with gene: "<gene>", type: "<type>", assay_result_status: "<status>", assay_variant: "<variant>", LOE: "<loe>" and description: "<description>"
    When creating a new treatment arm using post request
    Then a failure message is returned which contains: "<errorMessage>"
    Examples:
      |gene   | type |status          |variant    |loe       |description             |errorMessage                                        |
      |null   | IHC  |POSITIVE        |PRESENT    |2.0       |null gene               |Validation failed.                                  |
      |PTEN   | IHC  |negative        |NEGATIVE   |1.0       |lower case status       |did not match one of the following values           |
      |MLH1   | IHC  |INDETERMINATE   |Empty      |1.0       |mix case variant        |did not match one of the following values           |
      |PTEN   | IHC  |otherValue      |NEGATIVE   |3.0       |non-enum status         |did not match one of the following values           |
      |MLH1   | IHC  |INDETERMINATE   |null       |3.0       |null variant            |type NilClass did not match the following type: string|
      |MSCH2  | IHC  |NEGATIVE        |NEGATIVE   |-2.0      |minus loe               |Validation failed.                                  |