#encoding: utf-8

@TA_Post_Tests
Feature: Treatment Arm API Tests that focus on "name" field
  Scenario: Prepare a new Treatment Arm for update tests
    Given template json with a new unique id
    And save id for later use
    And set template json field: "version" to string value: "TA_NAME_TEST_V_000"
    When posted to MATCH newTreatmentArm
    Then success message is returned:

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
    And restore to saved id
    And add prefix: "<id_prefix>" to the value of template json field: "id"
    And set template json field: "name" to string value: "<name_value>"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Examples:
    |id_prefix                       |name_value              |
    |TA_NAME_TEST_SPECIAL_CHAR_001   |OIG)))#*)$!&$&)%)*      |

  Scenario: Update Treatment Arm with empty "name" field should fail
    Given template json with a new unique id
    And restore to saved id
    And set template json unique version
    And set template json field: "name" to string value: ""
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"


  Scenario: Update Treatment Arm with "name": null should fail
    Given template json with a new unique id
    And restore to saved id
    And set template json unique version
    And set template json field: "name" to string value: "null"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario: Update Treatment Arm without "name" field should fail
    Given template json with a new unique id
    And restore to saved id
    And set template json unique version
    And remove field: "name" from template json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"


  Scenario Outline: Update Treatment Arm with special character in "name" field should pass
    Given template json with a new unique id
    And restore to saved id
    And set template json field: "version" to string value: "<version_value>"
    And set template json field: "name" to string value: "<name_value>"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Examples:
    |version_value                |name_value         |
    |TA_NAME_FIELD_UPDATE_V_001   |$^#$%$HDH          |