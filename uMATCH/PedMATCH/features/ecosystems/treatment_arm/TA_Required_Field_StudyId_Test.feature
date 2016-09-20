#encoding: utf-8

@treatment_arm
Feature: Treatment Arm API Tests that focus on "study_id" field

  Scenario: TA_SID2. New Treatment Arm without "study_id" field should fail
    Given template treatment arm json with a random id
    And remove field: "study_id" from template treatment arm json
    When creating a new treatment arm using post request
    Then a failure message is returned which contains: "did not contain a required property of 'study_id'"

  Scenario Outline: TA_SID3. "study_id" field should not be updated to other value
    Given template treatment arm json with an id: "<treatment_arm_id>", stratum_id: "stratum1" and version: "2015-03-25"
    Then set template treatment arm json field: "study_id" to string value: "<origin_study_id>"
    When creating a new treatment arm using post request
    Then a success message is returned
    Then wait for "5" seconds
    Then set the version of the treatment arm to "2016-06-03"
    And set template treatment arm json field: "study_id" to string value: "<new_study_id>"
    When updating an existing treatment arm using put request
    Then a failure message is returned which contains: "Validation failed."
    Examples:
      |treatment_arm_id     |origin_study_id        |new_study_id     |
      |APEC1621-SID3-1      |APEC1621               |EAY131           |
      |APEC1621-SID3-2      |EAY131                 |APEC1621         |


  Scenario: TA_SID3. New Treatment Arm with "study_id" as null should fail
    Given template treatment arm json with a random id
    And clear list field: "study_id" from template treatment arm json
    Then set template treatment arm json field: "study_id" to string value: "null"
    When creating a new treatment arm using post request
    Then a failure message is returned which contains: "study_id' of type NilClass did not match the following type"
