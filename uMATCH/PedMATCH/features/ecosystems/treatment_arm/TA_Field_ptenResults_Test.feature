#encoding: utf-8

@treatment_arm
Feature: Treatment Arm API Tests that focus on ptenResults
  Scenario Outline: ptenIhcResult and ptenVariant with valid values should pass
    Given template json with a new unique id
    Then set template json field: "version" to string value: "2016-06-03"
    Then add ptenResult with ptenIhcResult: "<ptenIhcResult>", ptenVariant: "<ptenVariant>" and description: "<description>"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm with id: "saved_id" and version: "2016-06-03" return from API has ptenResults (ptenIhcResult: "<ptenIhcResult>", ptenVariant: "<ptenVariant>", description: "<description>")
    Examples:
    |ptenIhcResult        |ptenVariant          |description                                  |
    |POSITIVE             |PRESENT              |null                                         |
    |NEGATIVE             |NEGATIVE             |description                                  |
    |INDETERMINATE        |EMPTY                |the other description                        |

  Scenario Outline: ptenIhcResult with invalid values should fail
    Given template json with a new unique id
    Then add ptenResult with ptenIhcResult: "<ptenIhcResult>", ptenVariant: "<ptenVariant>" and description: "<description>"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed."
    Examples:
      |ptenIhcResult        |ptenVariant          |description                                  |
      |positive             |PRESENT              |null                                         |
      |Negative             |NEGATIVE             |description                                  |
      |other value          |EMPTY                |the other description                        |

  Scenario Outline: ptenVariant with invalid values should fail
    Given template json with a new unique id
    Then add ptenResult with ptenIhcResult: "<ptenIhcResult>", ptenVariant: "<ptenVariant>" and description: "<description>"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed."
    Examples:
      |ptenIhcResult        |ptenVariant          |description                                  |
      |positive             |present              |null                                         |
      |Negative             |Negative             |description                                  |
      |other value          |other value          |the other description                        |