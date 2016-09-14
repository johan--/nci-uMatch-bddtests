#encoding: utf-8

@treatment_arm
Feature: Treatment Arm API common tests for all fields

  Scenario: New Treatment Arm happy test
    Given template treatment arm json with an id: "APEC1621-HappyTest6"
    When creating a new treatment arm using post request
    Then success message is returned:

  Scenario Outline: TA_CF1. New Treatment Arm with unrequired field that has different kinds of value should pass
    Given template treatment arm json with an id: "<treatment_arm_id>"
    And set template treatment arm json field: "<field>" to string value: "<value>"
    When creating a new treatment arm using post request
    Then success message is returned:
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
    Then success message is returned:
    Then retrieve the posted treatment arm from API
    Then the returned treatment arm has value: "" in field: "<field>"
    Examples:
      |treatment_arm_id     |field                |
      |APEC1621-CF2-1       |target_name          |

  Scenario Outline: TA_CF4. New Treatment Arm with unrequired field which has improper data type values should fail
    Given template treatment arm json with a random id
    And set template treatment arm json field: "<field>" to value: "<value>" in type: "<type>"
    When creating a new treatment arm using post request
    Then a failure message is returned which contains: "Validation failed."
    Examples:
    |field              |value              |type                 |
    |gene               |419                |int                  |
    |target_id          |false              |bool                 |

  Scenario: TA_CF6. "dateCreated" value can be generated properly
    Given template treatment arm json with an id: "APEC1621-CF6-1"
    When creating a new treatment arm using post request
    Then success message is returned:
    Then retrieve the posted treatment arm from API
    Then the returned treatment arm has correct date_created value

  Scenario Outline: TA_CF7. Treatment arm return correct values for single fields
    Given template treatment arm json with an id: "<treatment_arm_id>"
    And set template treatment arm json field: "<field_name>" to value: "<fieldValue>" in type: "<dataType>"
    When creating a new treatment arm using post request
    Then retrieve the posted treatment arm from API
    Then the returned treatment arm has "<dataType>" value: "<fieldValue>" in field: "<field_name>"
    Examples:
      |treatment_arm_id | field_name            | fieldValue                                | dataType |
      |APEC1621-CF7-1   | description           | This is a test that verify output values  | string   |
      |APEC1621-CF7-2   | target_id             | 3453546232                                | int      |
      |APEC1621-CF7-3   | target_id             | Trametinib in GNAQ or GNA11 mutation      | string   |
      |APEC1621-CF7-4   | target_name           | Trametinib                                | string   |
      |APEC1621-CF7-5   | gene                  | GNA                                       | string   |
      |APEC1621-CF7-6   | treatment_arm_status  | OPEN                                      | string   |
      |APEC1621-CF7-7   | study_id              | APEC1621                                  | string   |
      |APEC1621-CF7-8   | stratum_id            | kjg13gas                                  | string   |
      |APEC1621-CF7-9   | num_patients_assigned | 5                                         | int      |

#  This scenario has been taken out. We do not have exclusion criteria anymore.
#  Scenario Outline: TA_CF8. Treatment arm return correct values for ExclusionCriterias
#    Given template treatment arm json with an id: "<treatment_arm_id>"
#    Then add exclusionCriterias with id: "<exclusionCriteriaID>" and description: "<description>"
#    When creating a new treatment arm using post request
#    Then success message is returned:
#    Then retrieve the posted treatment arm from API
#    Then the returned treatment arm has exclusionCriteria (id: "<exclusionCriteriaID>", description: "<description>")
#    Examples:
#      |treatment_arm_id     |exclusionCriteriaID  |description  |
#      |APEC1621-CF8-1       |31                   |ASIAN        |
#      |APEC1621-CF8-2       |32                   |FEMALE       |

#  Scenario Outline: TA_CF3. New Treatment Arm should not take undefined fields
#    Given template json with an id: "<treatment_arm_id>"
#    And set template json field: "<field>" to value: "<value>" in type: "<type>"
#    When creating a new treatment arm using post request
#    Then success message is returned:
#    Then retrieve the posted treatment arm from API
#    Then the returned treatment arm should not have field: "<field>"
#    Examples:
#    |treatment_arm_id    |field        |value        |type           |
#    |APEC1621-CF-1       |newString    |stringValue  |string         |
#    |APEC1621-CF-2       |newInt       |25           |int            |
#    |APEC1621-CF-3       |newFloat     |4.593        |float          |
#    |APEC1621-CF-4       |newBool      |false        |bool           |

#  Scenario: TA_CF5. New Treatment Arm with "dateCreated" field should fail
#    Given template json with a random id
#    Then set template json field: "dateCreated" to string value: "2016-02-23T16:46:08.911Z"
#    When creating a new treatment arm using post request
#    Then a failure message is returned which contains: "Validation failed"

#  Scenario Outline: TA_CF7. Update Treatment Arm with unrequired field that has different kinds of value should pass
#    Given template json with an id: "<treatment_arm_id>" and version: "2015-03-25"
#    When creating a new treatment arm using post request
#    Then success message is returned:
#    Then set template json field: "<field>" to string value: "<value>"
#    And set template json field: "version" to string value: "2016-06-03"
#    When creating a new treatment arm using post request
#    Then success message is returned:
#    Then the treatment arm with id: "<treatment_arm_id>" and version: "2016-06-03" return from API has value: "<returned_value>" in field: "<returned_field>"
#    Examples:
#      |treatment_arm_id     |field                |value                  |returned_field     |returned_value     |
#      |APEC1621-CF7-1       |target_id             |                       |target_id          |                   |
#      |APEC1621-CF7-2       |gene                 |null                   |gene               |                   |
#      |APEC1621-CF7-3       |target_name           |(&^$@HK                |target_name        |(&^$@HK            |
#
#
#  Scenario Outline: TA_CF8. Update Treatment Arm without unrequired field should set the value of this field to empty
#    Given template json with an id: "<treatment_arm_id>" and version: "2015-03-25"
#    And set template json field: "<field>" to string value: "<initialValue>"
#    When creating a new treatment arm using post request
#    Then success message is returned:
#    Then remove field: "<field>" from template json
#    And set template json field: "version" to string value: "2016-06-03"
#    When creating a new treatment arm using post request
#    Then success message is returned:
#    Then the treatment arm with id: "<treatment_arm_id>" and version: "2016-06-03" return from API has value: "" in field: "<returned_field>"
#    Examples:
#      |treatment_arm_id     |field                |initialValue     |returned_field     |
#      |APEC1621-CF8-1       |target_name           |Afatinib         |target_name        |
#      |APEC1621-CF8-2       |gene                 |null             |gene               |
#      |APEC1621-CF8-3       |target_id             |                 |target_id          |
#
#
#  Scenario Outline: TA_CF9. Update Treatment Arm with unrequired field which has improper data type values should fail
#    Given template json with a random id
#    And set template json field: "version" to string value: "2015-06-03"
#    When creating a new treatment arm using post request
#    Then success message is returned:
#    Then set template json field: "<field>" to value: "<value>" in type: "<type>"
#    And set template json field: "version" to string value: "2016-06-03"
#    When creating a new treatment arm using post request
#    Then a failure message is returned which contains: "Validation failed."
#    Examples:
#      |field              |value              |type                 |
#      |gene               |419                |int                  |
#      |target_id           |false              |bool                 |
#      |variantReport      |23.6592            |float                |
#
#
#  Scenario Outline: TA_CF10. Update Treatment Arm should not take undefined fields
#    Given template json with an id: "<treatment_arm_id>" and version: "2015-03-25"
#    When creating a new treatment arm using post request
#    Then success message is returned:
#    Then set template json field: "<field>" to value: "<value>" in type: "<type>"
#    And set template json field: "version" to string value: "2016-06-03"
#    When creating a new treatment arm using post request
#    Then success message is returned:
#    Then the treatment arm with id: "<treatment_arm_id>" and version: "2016-06-03" return from API should not have field: "<field>"
#    Examples:
#      |treatment_arm_id     |field        |value        |type           |
#      |APEC1621-CF10-1       |newString    |stringValue  |string         |
#      |APEC1621-CF10-2       |newInt       |25           |int            |
#      |APEC1621-CF10-3       |newFloat     |4.593        |float          |
#      |APEC1621-CF10-4       |newBool      |false        |bool           |
#
#  Scenario: TA_CF11. Update Treatment Arm with "dateCreated" field should fail
#    Given template json with a random id
#    When creating a new treatment arm using post request
#    Then success message is returned:
#    Then set template json field: "dateCreated" to string value: "2016-02-23T16:46:08.911Z"
#    When creating a new treatment arm using post request
#    Then a failure message is returned which contains: "Validation failed"