#encoding: utf-8

@treatment_arm
Feature: TA_PR1. Treatment Arm API Tests that focus on ptenResults
  Scenario Outline: ptenIhcResult and ptenVariant with valid values should pass
    Given template json with an id: "<treatment_arm_id>" and version: "2016-06-03"
    Then add ptenResult with ptenIhcResult: "<ptenIhcResult>", ptenVariant: "<ptenVariant>" and description: "<description>"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm with id: "<treatment_arm_id>" and version: "2016-06-03" return from API has ptenResults (ptenIhcResult: "<ptenIhcResult>", ptenVariant: "<ptenVariant>", description: "<description>")
    Examples:
    |treatment_arm_id     |ptenIhcResult        |ptenVariant          |description                                  |
    |APEC1621-PR1-1       |POSITIVE             |PRESENT              |null                                         |
    |APEC1621-PR1-2       |NEGATIVE             |NEGATIVE             |description                                  |
    |APEC1621-PR1-3       |INDETERMINATE        |EMPTY                |the other description                        |

  Scenario Outline: TA_PR2. ptenIhcResult with invalid values should fail
    Given template json with a random id
    Then add ptenResult with ptenIhcResult: "<ptenIhcResult>", ptenVariant: "<ptenVariant>" and description: "<description>"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed."
    Examples:
      |ptenIhcResult        |ptenVariant          |description                                  |
      |positive             |PRESENT              |null                                         |
      |Negative             |NEGATIVE             |description                                  |
      |other value          |EMPTY                |the other description                        |

  Scenario Outline: TA_PR3. ptenVariant with invalid values should fail
    Given template json with a random id
    Then add ptenResult with ptenIhcResult: "<ptenIhcResult>", ptenVariant: "<ptenVariant>" and description: "<description>"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed."
    Examples:
      |ptenIhcResult        |ptenVariant          |description                                  |
      |positive             |present              |null                                         |
      |Negative             |Negative             |description                                  |
      |other value          |other value          |the other description                        |