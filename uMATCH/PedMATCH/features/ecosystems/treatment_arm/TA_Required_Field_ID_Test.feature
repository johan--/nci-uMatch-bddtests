#encoding: utf-8

@TA_Post_Tests
Feature: Treatment Arm API Tests that focus on "id" field
  Scenario: New Treatment Arm with emtpy "id" field should fail
     Given template json with a new unique id
     And set template json field: "id" to string value: ""
     When posted to MATCH newTreatmentArm
     Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario: New Treatment Arm with "id": null should fail
    Given template json with a new unique id
    And set template json field: "id" to string value: "null"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario: New Treatment Arm without "id" field should fail
    Given template json with a new unique id
    And remove field: "id" from template json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"


  Scenario Outline: New Treatment Arm with special character in "id" field should pass
    Given template json with a new unique id
    And set template json field: "<field>" to string value: "<value>"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Examples:
    |field    |value      |
    |id       |@*$%sdga#  |