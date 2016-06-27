#encoding: utf-8

@treatment_arm
Feature: TA_AR1. Treatment Arm API Tests that focus on assayResults
  Scenario Outline: assayResults with valid values should pass
    Given template json with an id: "<treatment_arm_id>" and version: "2016-06-03"
    Then add assayResult with gene: "<gene>", assayResultStatus: "<status>", assayVariant: "<variant>", LOE: "<loe>" and description: "<description>"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm with id: "<treatment_arm_id>" and version: "2016-06-03" return from API has assayResult (gene: "<gene>", assayResultStatus: "<status>", assayVariant: "<variant>", LOE: "<loe>", description: "<description>")
    Examples:
      |treatment_arm_id     |gene             |status          |variant    |loe       |description                                  |
      |APEC1621-PR1-1       |PTEN             |POSITIVE        |PRESENT    |2.0       |null                                         |
      |APEC1621-PR1-2       |MSCH2            |NEGATIVE        |NEGATIVE   |1.5       |description                                  |
      |APEC1621-PR1-3       |MLH1             |INDETERMINATE   |EMPTY      |3.0       |the other description                        |

  Scenario Outline: TA_AR2. assayResults with invalid values should fail
    Given template json with a random id
    Then add assayResult with gene: "<gene>", assayResultStatus: "<status>", assayVariant: "<variant>", LOE: "<loe>" and description: "<description>"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "<errorMessage>"
    Examples:
      |gene             |status          |variant    |loe       |description             |errorMessage                                        |
      |null             |POSITIVE        |PRESENT    |2.0       |null gene               |Validation failed.                                  |
      |PTEN             |negative        |NEGATIVE   |1.0       |lower case status       |did not match one of the following values           |
      |MLH1             |INDETERMINATE   |Empty      |1.0       |mix case variant        |did not match one of the following values           |
      |PTEN             |otherValue      |NEGATIVE   |3.0       |non-enum status         |did not match one of the following values           |
      |PTEN             |null            |NEGATIVE   |2.0       |null status             |type NilClass did not match the following type: string|
      |MLH1             |INDETERMINATE   |null       |3.0       |null variant            |type NilClass did not match the following type: string|
      |MSCH2            |NEGATIVE        |NEGATIVE   |-2.0      |minus loe               |Validation failed.                                  |