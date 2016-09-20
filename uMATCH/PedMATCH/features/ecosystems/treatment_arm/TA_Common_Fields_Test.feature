#encoding: utf-8

@treatment_arm
Feature: Treatment Arm API common tests for all fields

  Scenario: New Treatment Arm happy test
    Given template treatment arm json with an id: "APEC1621-HappyTest6"
    When creating a new treatment arm using post request
    Then a success message is returned

  Scenario Outline: TA_CF1. New Treatment Arm with unrequired field that has different kinds of value should pass
    Given template treatment arm json with an id: "<treatment_arm_id>"
    And set template treatment arm json field: "<field>" to string value: "<value>"
    When creating a new treatment arm using post request
    Then a success message is returned
    Then retrieve the posted treatment arm from API
    Then the returned treatment arm has value: "<returned_value>" in field: "<field>"
    Examples:
      | treatment_arm_id     | field       | value   | returned_value |
      | APEC1621-CF1-1       | target_id   |         |                |
      | APEC1621-CF1-2       | gene        | null    |                |
      | APEC1621-CF1-3       | target_name | (&^$@HK | (&^$@HK        |


  Scenario Outline: TA_CF2. New Treatment Arm without unrequired field should set the value of this field to empty
    Given template treatment arm json with an id: "<treatment_arm_id>"
    And remove field: "<field>" from template treatment arm json
    When creating a new treatment arm using post request
    Then a success message is returned
    Then retrieve the posted treatment arm from API
    Then the returned treatment arm has value: "" in field: "<field>"
    Examples:
      |treatment_arm_id     |field                |
      |APEC1621-CF2-1       |target_name          |

  Scenario Outline: TA_CF4. New Treatment Arm with unrequired field which has improper data type values should fail
    Given template treatment arm json with a random id
    And set template treatment arm json field: "<field>" to value: "<value>" in type: "<type>"
    When creating a new treatment arm using post request
    Then a failure message is returned which contains: "<validation_message>"
    Examples:
    | field      | value  | type  | validation_message |
    | gene       | 419    | int   | Fixnum did not match one or more of the required schemas     |
    | target_id  | false  | bool  | FalseClass did not match one or more of the required schemas |

  Scenario: TA_CF6. "date_created" value can be generated properly
    Given template treatment arm json with an id: "APEC1621-CF6-1"
    When creating a new treatment arm using post request
    Then a success message is returned
    Then retrieve the posted treatment arm from API
    Then the returned treatment arm has correct date_created value

  Scenario Outline: TA_CF7. Treatment arm return correct values for single fields
    Given template treatment arm json with an id: "<treatment_arm_id>"
    And set template treatment arm json field: "<field_name>" to value: "<fieldValue>" in type: "<dataType>"
    When creating a new treatment arm using post request
    Then a success message is returned
    Then retrieve the posted treatment arm from API
    Then the returned treatment arm has "<dataType>" value: "<fieldValue>" in field: "<field_name>"
    Examples:
      |treatment_arm_id | field_name            | fieldValue                                | dataType |
      |APEC1621-CF7-1   | description           | This is a test that verify output values  | string   |
      |APEC1621-CF7-2   | target_id             | 3453546232                                | string   |
      |APEC1621-CF7-3   | target_id             | Trametinib in GNAQ or GNA11 mutation      | string   |
      |APEC1621-CF7-4   | target_name           | Trametinib                                | string   |
      |APEC1621-CF7-5   | gene                  | GNA                                       | string   |
      |APEC1621-CF7-7   | study_id              | APEC1621                                  | string   |
      |APEC1621-CF7-8   | stratum_id            | kjg13gas                                  | string   |
