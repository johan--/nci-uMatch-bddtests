#encoding: utf-8

@treatment_arm
Feature: Treatment Arm API Tests that focus on "study_id" field

  Scenario: TA_SID2. New Treatment Arm without "study_id" field should fail
    Given template treatment arm json with a random id
    And remove field: "study_id" from template treatment arm json
    When creating a new treatment arm using post request
    Then a failure message is returned which contains: "did not contain a required property of 'study_id'"

  Scenario Outline: TA_SID3. "study_id" value other than APEC1621 should fail
    Given template treatment arm json with an id: "APEC1621-SID3-1 ", stratum_id: "stratum1" and version: "2015-03-25"
    Then set template treatment arm json field: "study_id" to string value: "EAY131"
    When creating a new treatment arm using post request
    Then a failure response code of "500" is returned
    And a failure message is returned which contains: "did not match one of the following values: APEC1621"


  Scenario: TA_SID3. New Treatment Arm with "study_id" as null should fail
    Given template treatment arm json with a random id
    And clear list field: "study_id" from template treatment arm json
    Then set template treatment arm json field: "study_id" to string value: "null"
    When creating a new treatment arm using post request
    Then a failure message is returned which contains: "study_id' of type NilClass did not match the following type"
