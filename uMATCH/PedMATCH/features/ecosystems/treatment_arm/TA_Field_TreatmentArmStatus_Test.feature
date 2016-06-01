#encoding: utf-8

@TA_Post_Tests
Feature: Treatment Arm API Tests that focus on "treatmentArmStatus" field

  Scenario: Prepare a new Treatment Arm for update tests
    Given template json with a new unique id
    And save id for later use
    And set template json field: "version" to string value: "TA_STATUS_TEST_V_000"
    And set template json field: "treatmentArmStatus" to string value: "OPEN"
    When posted to MATCH newTreatmentArm
    Then success message is returned:

  Scenario Outline: New Treatment Arm with invalid "treatmentArmStatus" value should fail (including empty string)
    Given template json with a new unique id
    And set template json field: "treatmentArmStatus" to string value: "<status>"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "<error_message>"
    Examples:
    |status   |error_message                                                          |
    |OTHER    |Validation failed.  !!!!!!!!!!!!!!need to be determined!!!!!!!!!!!!!!  |
    |XXX      |Validation failed.  !!!!!!!!!!!!!!need to be determined!!!!!!!!!!!!!!  |
    |         |Validation failed.  !!!!!!!!!!!!!!need to be determined!!!!!!!!!!!!!!  |
    |32       |Validation failed.  !!!!!!!!!!!!!!need to be determined!!!!!!!!!!!!!!  |
    |CLOSED   |Validation failed.  !!!!!!!!!!!!!!need to be determined!!!!!!!!!!!!!!  |
    |SUSPENDED|Validation failed.  !!!!!!!!!!!!!!need to be determined!!!!!!!!!!!!!!  |
    
  Scenario: New Treatment Arm with "treatmentArmStatus":null value should pass
    Given template json with a new unique id
    And add prefix: "NULL_STATUS" to the value of template json field: "id"
    And set template json field: "treatmentArmStatus" to string value: "null"
    When posted to MATCH newTreatmentArm
    Then success message is returned:

  Scenario: New Treatment Arm without "treatmentArmStatus" value should pass
    Given template json with a new unique id
    And add prefix: "MISSING_STATUS" to the value of template json field: "id"
    And remove field: "treatmentArmStatus" from template json
    When posted to MATCH newTreatmentArm
    Then success message is returned:

  Scenario Outline: Update Treatment Arm with invalid "treatmentArmStatus" value should fail
    Given template json with a new unique id
    And restore to saved id
    And set template json field: "treatmentArmStatus" to string value: "<status>"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "<error_message>"
    Examples:
    |status   |error_message                                                          |
    |OTHER    |Validation failed.  !!!!!!!!!!!!!!need to be determined!!!!!!!!!!!!!!  |
    |XXX      |Validation failed.  !!!!!!!!!!!!!!need to be determined!!!!!!!!!!!!!!  |
    |         |Validation failed.  !!!!!!!!!!!!!!need to be determined!!!!!!!!!!!!!!  |
    |32       |Validation failed.  !!!!!!!!!!!!!!need to be determined!!!!!!!!!!!!!!  |

  Scenario: Existing Treatment Arm with "treatmentArmStatus": OPEN can be updated to SUSPENDED
    Given template json with a new unique id
    And restore to saved id
    And set template json field: "version" to string value: "TA_STATUS_TEST_V_001"
    And set template json field: "treatmentArmStatus" to string value: "SUSPENDED"
    When posted to MATCH newTreatmentArm
    Then success message is returned:

  Scenario: Existing Treatment Arm with "treatmentArmStatus": SUSPENDED can be updated to OPEN
    Given template json with a new unique id
    And restore to saved id
    And set template json field: "version" to string value: "TA_STATUS_TEST_V_002"
    And set template json field: "treatmentArmStatus" to string value: "OPEN"
    When posted to MATCH newTreatmentArm
    Then success message is returned:

  Scenario: Existing Treatment Arm with "treatmentArmStatus": OPEN can be updated to CLOSED
    Given template json with a new unique id
    And restore to saved id
    And set template json field: "version" to string value: "TA_STATUS_TEST_V_003"
    And set template json field: "treatmentArmStatus" to string value: "CLOSED"
    When posted to MATCH newTreatmentArm
    Then success message is returned:

  Scenario: Existing Treatment Arm with "treatmentArmStatus": SUSPENDED can be updated to CLOSED
    Given template json with a new unique id
    And add prefix: "SP_TO_CL" to the value of template json field: "id"
    And set template json field: "treatmentArmStatus" to string value: "OPEN"
    And set template json field: "version" to string value: "SP_TO_CL_V_001"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    And set template json field: "treatmentArmStatus" to string value: "SUSPENDED"
    And set template json field: "version" to string value: "SP_TO_CL_V_002"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    And set template json field: "treatmentArmStatus" to string value: "CLOSED"
    And set template json field: "version" to string value: "SP_TO_CL_V_003"
    When posted to MATCH newTreatmentArm
    Then success message is returned:

#these are GET tests
#  Scenario: Existing Treatment Arm with "treatmentArmStatus": CLOSED can not be updated anymore
#  Scenario: Update Treatment Arm should have properly updated "statusLog" field
