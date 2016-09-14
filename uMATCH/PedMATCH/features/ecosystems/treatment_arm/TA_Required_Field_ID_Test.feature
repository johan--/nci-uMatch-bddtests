#encoding: utf-8

@treatment_arm
Feature: Treatment Arm API Tests that focus on "id" field
  Scenario: TA_ID1. New Treatment Arm with empty "id" field should fail
     Given template treatment arm json with a random id
     And set template treatment arm json field: "id" to string value: ""
     When creating a new treatment arm using post request
     Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"


  Scenario Outline: TA_ID4. New Treatment Arm with special character in "id" field should pass
    Given template treatment arm json with an id: "<id>", stratum_id: "stratum1" and version: "2016-06-03"
    When creating a new treatment arm using post request
    Then success message is returned:
    Then retrieve treatment arm with id: "<encoded_id>", stratum_id: "stratum1" and version: "2016-06-03" from API
    Then the returned treatment arm has value: "<id>" in field: "name"
    Examples:
    |id                                   |encoded_id                                                                                     |
    |APEC1621-@$%#!^&*+={}[]\/?;'<>,Àü ī  |APEC1621-%40%24%25%23!%5E%26*%2B%3D%7B%7D%5B%5D%5C%2F%3F%3B%27%3C%3E%2C%C3%80%C3%BC%20%C4%AB   |
    |APEC1621.id                          |APEC1621%2Eid                                                                                  |
