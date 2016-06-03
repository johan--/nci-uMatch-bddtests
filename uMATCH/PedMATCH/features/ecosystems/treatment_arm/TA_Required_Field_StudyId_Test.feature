#encoding: utf-8

@treatment_arm
Feature: Treatment Arm API Tests that focus on "study_id" field

  Scenario Outline: New Treatment Arm, values other than "APEC1621" and "EAY131" in "study_id" field should fail
    Given template json with a new unique id
    And set template json field: "study_id" to string value: "<study_id_value>"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed."
    Examples:
    |study_id_value     |
    |OTHER_STUDY        |
    |xxyyzz             |
    |null               |
    |                   |

  Scenario: New Treatment Arm without "study_id" field should fail
    Given template json with a new unique id
    And remove field: "study_id" from template json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario Outline: "study_id" field should not be updated to other value
    Given template json with a new unique id
    Then set template json field: "study_id" to string value: "<origin_study_id>"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "version" to string value: "2016-06-03"
    And set template json field: "study_id" to string value: "<new_study_id>"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed."
    Examples:
    |origin_study_id        |new_study_id     |
    |APEC1621               |EAY131           |
    |EAY131                 |APEC1621         |
    |APEC1621               |OTHER_STUDY      |
    |EAY131                 |xxyyzz           |
    |APEC1621               |null             |
    |EAY131                 |                 |

  Scenario: Update Treatment Arm without "study_id" field should fail
    Given template json with a new unique id
    Then set template json field: "study_id" to string value: "APEC1621"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "version" to string value: "2016-06-03"
    And remove field: "study_id" from template json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"
