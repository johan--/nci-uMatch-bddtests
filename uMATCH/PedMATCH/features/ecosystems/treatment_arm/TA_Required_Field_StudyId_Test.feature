#encoding: utf-8

@TA_Post_Tests
Feature: Treatment Arm API Tests that focus on "study_id" field

  Scenario: Prepare a new Treatment Arm for update tests
    Given template json with a new unique id
    And save id for later use
    And set template json field: "version" to string value: "TA_STUDY_ID_TEST_V_000"
    When posted to MATCH newTreatmentArm
    Then success message is returned:

  Scenario: New Treatment Arm with emtpy "study_id" field should fail
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
    And restore to saved id
    And add prefix: "<id_prefix>" to the value of template json field: "id"
    And set template json field: "study_id" to string value: "<study_id_value>"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Examples:
      |id_prefix                          |study_id_value          |
      |TA_STUDYID_TEST_SPECIAL_CHAR_001   |OIG)))#*)$!&$&)%)*      |

  Scenario: Update Treatment Arm with empty "study_id" field should fail
    Given template json with a new unique id
    And restore to saved id
    And set template json unique version
    And set template json field: "study_id" to string value: ""
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario: Update Treatment Arm with "study_id": null should fail
    Given template json with a new unique id
    And restore to saved id
    And set template json unique version
    And set template json field: "study_id" to string value: "null"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario: Update Treatment Arm without "study_id" field should fail
    Given template json with a new unique id
    And restore to saved id
    And set template json unique version
    And remove field: "study_id" from template json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario Outline: Update Treatment Arm with special character in "study_id" field should pass
    Given template json with a new unique id
    And restore to saved id
    And set template json field: "version" to string value: "<version_value>"
    And set template json field: "study_id" to string value: "<study_id_value>"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Examples:
      |version_value             |study_id_value              |
      |TA_STUDY_ID_TEST_V_001    |$^#$%$HDH                   |