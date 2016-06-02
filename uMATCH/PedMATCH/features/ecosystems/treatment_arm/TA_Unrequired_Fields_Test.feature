#encoding: utf-8

@Treatment_Arm_API_Tests
Feature: Treatment Arm API Tests that focus on Unrequired fields

  Scenario Outline: New Treatment Arm with unrequired field that has different kinds of value should pass
    Given template json with a new unique id
    And set template json field: "<field>" to string value: "<value>"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
#    Then check result
    Examples:
      |field                |value                  |
      |targetId             |                       |
      |gene                 |null                   |
      |targetName           |(&^$@HK                |


  Scenario Outline: New Treatment Arm without unrequired field should pass
    Given template json with a new unique id
    And remove field: "<field>" from template json
    When posted to MATCH newTreatmentArm
    Then success message is returned:
#    Then check result
    Examples:
      |field                |
      |targetName           |

#  Scenario Outline: New Treatment Arm with undefined fields should pass
#  Scenario Outline: Update Treatment Arm with empty unrequired field should pass
#  Scenario Outline: Update Treatment Arm with unrequired field: null should pass
#  Scenario Outline: Update Treatment Arm without unrequired field should pass
#  Scenario Outline: Update Treatment Arm with special character in unrequired field should pass
#  Scenario Outline: Update Treatment Arm with unrequired field which has improper data type values should fail
#  Scenario Outline: Update Treatment Arm with undefined fields should pass