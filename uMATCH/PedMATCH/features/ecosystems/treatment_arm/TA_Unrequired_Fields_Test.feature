#encoding: utf-8

@treatment_arm
Feature: Treatment Arm API Tests that focus on Unrequired fields

  Scenario Outline: New Treatment Arm with unrequired field that has different kinds of value should pass
    Given template json with a new unique id
    And set template json field: "<field>" to string value: "<value>"
    And set template json field: "version" to string value: "V0000001"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm with id: "saved_id" and version: "V0000001" return from API has value: "<returned_value>" in field: "<returned_field>"
    Examples:
      |field                |value                  |returned_field     |returned_value     |
      |targetId             |                       |target_id          |                   |
      |gene                 |null                   |gene               |                   |
      |targetName           |(&^$@HK                |target_name        |(&^$@HK            |


  Scenario Outline: New Treatment Arm without unrequired field should pass
    Given template json with a new unique id
    And remove field: "<field>" from template json
    And set template json field: "version" to string value: "V0000001"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm with id: "saved_id" and version: "V0000001" return from API has value: "" in field: "<returned_field>"
    Examples:
      |field                |returned_field     |
      |targetName           |target_name        |

#  Scenario Outline: New Treatment Arm with undefined fields should pass
#  Scenario Outline: Update Treatment Arm with empty unrequired field should pass
#  Scenario Outline: Update Treatment Arm with unrequired field: null should pass
#  Scenario Outline: Update Treatment Arm without unrequired field should pass
#  Scenario Outline: Update Treatment Arm with special character in unrequired field should pass
#  Scenario Outline: Update Treatment Arm with unrequired field which has improper data type values should fail
#  Scenario Outline: Update Treatment Arm with undefined fields should pass