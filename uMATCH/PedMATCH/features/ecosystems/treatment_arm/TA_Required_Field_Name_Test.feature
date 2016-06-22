#encoding: utf-8

@treatment_arm
Feature: Treatment Arm API Tests that focus on "name" field

  Scenario: TA_NM1. New Treatment Arm with empty "name" field should fail
    Given template json with a random id
    And set template json field: "name" to string value: ""
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario: TA_NM2. New Treatment Arm with "name": null should fail
    Given template json with a random id
    And set template json field: "name" to string value: "null"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario: TA_NM3. New Treatment Arm without "name" field should fail
    Given template json with a random id
    And remove field: "name" from template json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"


  Scenario Outline: TA_NM4. New Treatment Arm with special character in "name" field should pass
    Given template json with an id: "<treatment_arm_id>" and version: "2016-06-03"
    And set template json field: "name" to string value: "<name_value>"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm with id: "<treatment_arm_id>" and version: "2016-06-03" return from API has value: "<name_value>" in field: "name"
    Examples:
      |treatment_arm_id     |name_value              |
      |APEC1621-NM4-1       |@*$%sdga#               |
      |APEC1621-NM4-2       |!^&*()-_+=              |
      |APEC1621-NM4-3       |{}[]\/?                 |
      |APEC1621-NM4-4       |;'<>,.                  |
      |APEC1621-NM4-5       |?Àü ī                   |

#  Scenario: TA_NM5. Update Treatment Arm with empty "name" field should fail
#    Given template json with a random id
#    When posted to MATCH newTreatmentArm
#    Then success message is returned:
#    Then set template json field: "version" to string value: "2016-06-03"
#    And set template json field: "name" to string value: ""
#    When posted to MATCH newTreatmentArm
#    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"
#
#
#  Scenario: TA_NM6. Update Treatment Arm with "name": null should fail
#    Given template json with a random id
#    When posted to MATCH newTreatmentArm
#    Then success message is returned:
#    Then set template json field: "version" to string value: "2016-06-03"
#    And set template json field: "name" to string value: "null"
#    When posted to MATCH newTreatmentArm
#    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"
#
#  Scenario: TA_NM7. Update Treatment Arm without "name" field should fail
#    Given template json with a random id
#    When posted to MATCH newTreatmentArm
#    Then success message is returned:
#    Then set template json field: "version" to string value: "2016-06-03"
#    And remove field: "name" from template json
#    When posted to MATCH newTreatmentArm
#    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"
#
#
#  Scenario Outline: TA_NM8. Update Treatment Arm with special character in "name" field should pass
#    Given template json with an id: "<treatment_arm_id>" and version: "2015-03-25"
#    When posted to MATCH newTreatmentArm
#    Then success message is returned:
#    Then set template json field: "version" to string value: "2016-06-03"
#    And set template json field: "name" to string value: "<name_value>"
#    When posted to MATCH newTreatmentArm
#    Then success message is returned:
#    Then the treatment arm with id: "<treatment_arm_id>" and version: "2016-06-03" return from API has value: "<name_value>" in field: "name"
#    Examples:
#    |treatment_arm_id     |name_value              |
#    |APEC1621-NM8-1       |@*$%sdga#               |
#    |APEC1621-NM8-2       |!^&*()-_+=              |
#    |APEC1621-NM8-3       |{}[]\/?                 |
#    |APEC1621-NM8-4       |;'<>,.                  |
#    |APEC1621-NM8-5       |?Àü ī                   |