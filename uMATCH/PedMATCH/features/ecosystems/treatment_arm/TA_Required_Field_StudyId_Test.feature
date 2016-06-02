#encoding: utf-8

@treatment_arm
Feature: Treatment Arm API Tests that focus on "study_id" field

  Scenario: New Treatment Arm with empty "study_id" field should fail
    Given template json with a new unique id
    And set template json field: "study_id" to string value: ""
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario: New Treatment Arm with "study_id": null should fail
    Given template json with a new unique id
    And set template json field: "study_id" to string value: "null"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario: New Treatment Arm without "study_id" field should fail
    Given template json with a new unique id
    And remove field: "study_id" from template json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario Outline: New Treatment Arm with special character in "study_id" field should pass
    Given template json with a new unique id
    And set template json field: "study_id" to string value: "<study_id_value>"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Examples:
      |study_id_value          |
      |@*$%sdga#               |
      |!^&*()-_+=              |
      |{}[]\/?                 |
      |;'<>,.                  |
      |?Àü ī                   |

  Scenario: Update Treatment Arm with empty "study_id" field should fail
    Given template json with a new unique id
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "version" to string value: "V0000002"
    And set template json field: "study_id" to string value: ""
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario: Update Treatment Arm with "study_id": null should fail
    Given template json with a new unique id
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "version" to string value: "V0000002"
    And set template json field: "study_id" to string value: "null"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario: Update Treatment Arm without "study_id" field should fail
    Given template json with a new unique id
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "version" to string value: "V0000002"
    And remove field: "study_id" from template json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario Outline: Update Treatment Arm with special character in "study_id" field should pass
    Given template json with a new unique id
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "version" to string value: "V0000002"
    And set template json field: "study_id" to string value: "<study_id_value>"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Examples:
      |study_id_value          |
      |@*$%sdga#               |
      |!^&*()-_+=              |
      |{}[]\/?                 |
      |;'<>,.                  |
      |?Àü ī                   |