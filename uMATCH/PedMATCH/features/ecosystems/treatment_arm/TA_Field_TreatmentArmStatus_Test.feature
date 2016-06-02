#encoding: utf-8

@treatment_arm
Feature: Treatment Arm API Tests that focus on "treatmentArmStatus" field

  Scenario Outline: New Treatment Arm with invalid "treatmentArmStatus" value should fail (including empty string)
    Given template json with a new unique id
    And set template json field: "treatmentArmStatus" to string value: "<status>"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "<error_message>"
    Examples:
    |status   |error_message                  |
    |OTHER    |Validation failed.             |
    |XXX      |Validation failed.             |
    |         |Validation failed.             |
    |32       |Validation failed.             |
    |CLOSED   |Validation failed.             |
    |SUSPENDED|Validation failed.             |
    
  Scenario: New Treatment Arm with "treatmentArmStatus":null value should pass
    Given template json with a new unique id
    And set template json field: "treatmentArmStatus" to string value: "null"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    #Then check get result using saved id

  Scenario: New Treatment Arm without "treatmentArmStatus" value should pass
    Given template json with a new unique id
    And remove field: "treatmentArmStatus" from template json
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    #Then check get result using saved id

  Scenario Outline: Update Treatment Arm with invalid "treatmentArmStatus" value should fail
    Given template json with a new unique id
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "version" to string value: "V0000002"
    And set template json field: "treatmentArmStatus" to string value: "<status>"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "<error_message>"
    Examples:
    |status   |error_message            |
    |OTHER    |Validation failed.       |
    |XXX      |Validation failed.       |
    |         |Validation failed.       |
    |32       |Validation failed.       |

  Scenario: Existing Treatment Arm with "treatmentArmStatus": OPEN can be updated to SUSPENDED
    Given template json with a new unique id
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "version" to string value: "V0000002"
    And set template json field: "treatmentArmStatus" to string value: "SUSPENDED"
    When posted to MATCH newTreatmentArm
    Then success message is returned:

  Scenario: Existing Treatment Arm with "treatmentArmStatus": SUSPENDED can be updated to OPEN
    Given template json with a new unique id
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "version" to string value: "V0000002"
    And set template json field: "treatmentArmStatus" to string value: "SUSPENDED"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "version" to string value: "V0000003"
    And set template json field: "treatmentArmStatus" to string value: "OPEN"
    When posted to MATCH newTreatmentArm
    Then success message is returned:

  Scenario: Existing Treatment Arm with "treatmentArmStatus": OPEN can be updated to CLOSED
    Given template json with a new unique id
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "version" to string value: "V0000002"
    And set template json field: "treatmentArmStatus" to string value: "CLOSED"
    When posted to MATCH newTreatmentArm
    Then success message is returned:

  Scenario: Existing Treatment Arm with "treatmentArmStatus": SUSPENDED can be updated to CLOSED
    Given template json with a new unique id
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "version" to string value: "V0000002"
    And set template json field: "treatmentArmStatus" to string value: "SUSPENDED"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "version" to string value: "V0000003"
    And set template json field: "treatmentArmStatus" to string value: "CLOSED"
    When posted to MATCH newTreatmentArm
    Then success message is returned:

#to be done
#  Scenario: Existing Treatment Arm with "treatmentArmStatus": CLOSED can not be updated anymore
#  Scenario: Update Treatment Arm should have properly updated "statusLog" field
