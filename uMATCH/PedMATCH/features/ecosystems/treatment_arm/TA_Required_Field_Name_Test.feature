#encoding: utf-8

@TA_Post_Tests
Feature: Treatment Arm API Tests that focus on "name" field
  Background:
    Given template json with a new unique id
    And set template json field: "id" to string value: "TA_NAME_FIELD_UPDATE"
    When posted to MATCH newTreatmentArm

  Scenario: New Treatment Arm with emtpy "name" field should fail
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
    And set template json field: "<field>" to string value: "<value>"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Examples:
    |field  |value              |
    |name   |OIG)))#*)$!&$&)%)* |

  Scenario: Update Treatment Arm with empty "name" field should fail
    Given template json with a new unique id
    And set template json field: "id" to string value: "TA_NAME_FIELD_UPDATE"
    And set template json unique version
    And set template json field: "name" to string value: ""
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"


  Scenario: Update Treatment Arm with "name": null should fail
    Given template json with a new unique id
    And set template json field: "id" to string value: "TA_NAME_FIELD_UPDATE"
    And set template json unique version
    And set template json field: "name" to string value: "null"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario: Update Treatment Arm without "name" field should fail
    Given template json with a new unique id
    And set template json field: "id" to string value: "TA_NAME_FIELD_UPDATE"
    And set template json unique version
    And remove field: "name" from template json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"


  Scenario Outline: Update Treatment Arm with special character in "name" field should pass
    Given template json with a new unique id
    And set template json field: "id" to string value: "TA_NAME_FIELD_UPDATE"
    And set template json unique version
    And set template json field: "<field>" to string value: "<value>"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Examples:
    |field  |value              |
    |name   |$^#$%$HDH          |