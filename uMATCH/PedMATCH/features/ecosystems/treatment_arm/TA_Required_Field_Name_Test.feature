#encoding: utf-8

@treatment_arm
Feature: Treatment Arm API Tests that focus on "name" field

  Scenario: TA_NM1. New Treatment Arm with empty "name" field should fail
    Given template treatment arm json with a random id
    And set template treatment arm json field: "name" to string value: ""
    When creating a new treatment arm using post request
    Then a failure message is returned which contains: "did not contain a required property of 'name'"