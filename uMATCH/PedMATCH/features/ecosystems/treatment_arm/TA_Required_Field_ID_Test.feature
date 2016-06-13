#encoding: utf-8

@Treatment_Arm_API_Tests
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
    And set template json field: "id" to string value: "<id>"
    And set template json field: "version" to string value: "2016-06-03"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm with id: "<encoded_id>" and version: "2016-06-03" should return from database
    Examples:
    |id                  |encoded_id                                  |
    |APEC1621-@*$%sdga#  |APEC1621-%40*%24%25sdga%23                  |
    |APEC1621-!^&*()-_+= |APEC1621-!%APEC1621-5E%26*()-_%2B%3D        |
    |APEC1621-{}[]\/?    |APEC1621-%7B%7D%5B%5D%5C%2F%3F              |
    |APEC1621-;'<>,      |APEC1621-%3B%27%3C%3E%2C                    |
    |APEC1621-?Àü ī      |APEC1621-%3F%C3%80%C3%BC%20%C4%AB           |
    |APEC1621.id         |APEC1621%2Eid                               |

  #if dot(.) cannot be used in URL, then id should not accept dot, then add this scenario:
  #Scenario: New Treatement Arm with dot "." in "id" field should fail