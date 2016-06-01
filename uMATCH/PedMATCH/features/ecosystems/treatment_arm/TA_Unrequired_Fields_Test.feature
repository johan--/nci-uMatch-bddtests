#encoding: utf-8

@TA_Post_Tests
Feature: Treatment Arm API Tests that focus on Unrequired fields
  Scenario: Prepare a new Treatment Arm for update tests
    Given template json with a new unique id
    And save id for later use
    And set template json field: "version" to string value: "TA_UNREQ_FIELD_TEST_V_000"
    When posted to MATCH newTreatmentArm
    Then success message is returned:

  Scenario Outline: New Treatment Arm with unrequired field that should pass
    Given template json with a new unique id
    And add prefix: "<id_prefix>" to the value of template json field: "id"
    And set template json field: "<field>" to string value: "<value>"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Examples:
    |id_prefix                  |field                |value                  |
    |EMPTY_UNREQ_FIELD_001      |targetId             |                       |
    |EMPTY_UNREQ_FIELD_002      |gene                 |null                   |
    |EMPTY_UNREQ_FIELD_003      |targetName           |(&^$@HK                |


  Scenario Outline: New Treatment Arm without unrequired field should pass
    Given template json with a new unique id
    And add prefix: "<id_prefix>" to the value of template json field: "id"
    And remove field: "<field>" from template json
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Examples:
      |id_prefix                  |field                |
      |EMPTY_UNREQ_FIELD_001      |targetName           |

#  Scenario Outline: New Treatment Arm with undefined fields should pass
#  Scenario Outline: Update Treatment Arm with empty unrequired field should pass
#  Scenario Outline: Update Treatment Arm with unrequired field: null should pass
#  Scenario Outline: Update Treatment Arm without unrequired field should pass
#  Scenario Outline: Update Treatment Arm with special character in unrequired field should pass
#  Scenario Outline: Update Treatment Arm with unrequired field which has improper data type values should fail
#  Scenario Outline: Update Treatment Arm with undefined fields should pass