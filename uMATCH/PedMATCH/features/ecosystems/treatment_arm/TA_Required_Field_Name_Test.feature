#encoding: utf-8

@treatment_arm
Feature: Treatment Arm API Tests that focus on "name" field

  Scenario: New Treatment Arm with empty "name" field should fail
    Given template json with a new unique id
    And set template json field: "name" to string value: ""
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario: New Treatment Arm with "name": null should fail
    Given template json with a new unique id
    And set template json field: "name" to string value: "null"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario: New Treatment Arm without "name" field should fail
    Given template json with a new unique id
    And remove field: "name" from template json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"


  Scenario Outline: New Treatment Arm with special character in "name" field should pass
    Given template json with a new unique id
    And set template json field: "name" to string value: "<name_value>"
    And set template json field: "version" to string value: "V0000001"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm with id: "saved_id" and version: "V0000001" return from API has value: "<name_value>" in field: "name"
    Examples:
      |name_value              |
      |@*$%sdga#               |
      |!^&*()-_+=              |
      |{}[]\/?                 |
      |;'<>,.                  |
      |?Àü ī                   |

  Scenario: Update Treatment Arm with empty "name" field should fail
    Given template json with a new unique id
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "version" to string value: "V0000002"
    And set template json field: "name" to string value: ""
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"


  Scenario: Update Treatment Arm with "name": null should fail
    Given template json with a new unique id
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "version" to string value: "V0000002"
    And set template json field: "name" to string value: "null"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario: Update Treatment Arm without "name" field should fail
    Given template json with a new unique id
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "version" to string value: "V0000002"
    And remove field: "name" from template json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"


  Scenario Outline: Update Treatment Arm with special character in "name" field should pass
    Given template json with a new unique id
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "version" to string value: "V0000002"
    And set template json field: "name" to string value: "<name_value>"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm with id: "saved_id" and version: "V0000002" return from API has value: "<name_value>" in field: "name"
    Examples:
    |name_value              |
    |@*$%sdga#               |
    |!^&*()-_+=              |
    |{}[]\/?                 |
    |;'<>,.                  |
    |?Àü ī                   |