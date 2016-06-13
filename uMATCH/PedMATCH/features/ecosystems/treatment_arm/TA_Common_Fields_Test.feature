#encoding: utf-8

@treatment_arm
Feature: Treatment Arm API Tests that focus on Unrequired fields

  Scenario Outline: New Treatment Arm with unrequired field that has different kinds of value should pass
    Given template json with a new unique id
    And set template json field: "<field>" to string value: "<value>"
    And set template json field: "version" to string value: "2015-06-03"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm with id: "saved_id" and version: "2015-06-03" return from API has value: "<returned_value>" in field: "<returned_field>"
    Examples:
      |field                |value                  |returned_field     |returned_value     |
      |targetId             |                       |target_id          |                   |
      |gene                 |null                   |gene               |                   |
      |targetName           |(&^$@HK                |target_name        |(&^$@HK            |


  Scenario Outline: New Treatment Arm without unrequired field should set the value of this field to empty
    Given template json with a new unique id
    And remove field: "<field>" from template json
    And set template json field: "version" to string value: "2015-06-03"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm with id: "saved_id" and version: "2015-06-03" return from API has value: "" in field: "<returned_field>"
    Examples:
      |field                |returned_field     |
      |targetName           |target_name        |

  Scenario Outline: New Treatment Arm should not take undefined fields
    Given template json with a new unique id
    And set template json field: "<field>" to value: "<value>" in type: "<type>"
    And set template json field: "version" to string value: "2015-06-03"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm with id: "saved_id" and version: "2015-06-03" return from API should not have field: "<field>"
    Examples:
    |field        |value        |type           |
    |newString    |stringValue  |string         |
    |newInt       |25           |int            |
    |newFloat     |4.593        |float          |
    |newBool      |false        |bool           |

  Scenario Outline: New Treatment Arm with unrequired field which has improper data type values should fail
    Given template json with a new unique id
    And set template json field: "<field>" to value: "<value>" in type: "<type>"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed."
    Examples:
    |field              |value              |type                 |
    |gene               |419                |int                  |
    |targetId           |false              |bool                 |
    |variantReport      |23.6592            |float                |



  Scenario Outline: Update Treatment Arm with unrequired field that has different kinds of value should pass
    Given template json with a new unique id
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "<field>" to string value: "<value>"
    And set template json field: "version" to string value: "2016-06-03"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm with id: "saved_id" and version: "2016-06-03" return from API has value: "<returned_value>" in field: "<returned_field>"
    Examples:
      |field                |value                  |returned_field     |returned_value     |
      |targetId             |                       |target_id          |                   |
      |gene                 |null                   |gene               |                   |
      |targetName           |(&^$@HK                |target_name        |(&^$@HK            |


  Scenario Outline: Update Treatment Arm without unrequired field should set the value of this field to empty
    Given template json with a new unique id
    And set template json field: "<field>" to string value: "<initialValue>"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then remove field: "<field>" from template json
    And set template json field: "version" to string value: "2016-06-03"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm with id: "saved_id" and version: "2016-06-03" return from API has value: "" in field: "<returned_field>"
    Examples:
      |field                |initialValue     |returned_field     |
      |targetName           |Afatinib         |target_name        |
      |gene                 |null             |gene               |
      |targetId             |                 |target_id          |


  Scenario Outline: Update Treatment Arm with unrequired field which has improper data type values should fail
    Given template json with a new unique id
    And set template json field: "version" to string value: "2015-06-03"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "<field>" to value: "<value>" in type: "<type>"
    And set template json field: "version" to string value: "2016-06-03"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed."
    Examples:
      |field              |value              |type                 |
      |gene               |419                |int                  |
      |targetId           |false              |bool                 |
      |variantReport      |23.6592            |float                |
    
    
  Scenario Outline: Update Treatment Arm should not take undefined fields
    Given template json with a new unique id
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "<field>" to value: "<value>" in type: "<type>"
    And set template json field: "version" to string value: "2016-06-03"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm with id: "saved_id" and version: "2016-06-03" return from API should not have field: "<field>"
    Examples:
      |field        |value        |type           |
      |newString    |stringValue  |string         |
      |newInt       |25           |int            |
      |newFloat     |4.593        |float          |
      |newBool      |false        |bool           |

  Scenario: New Treatment Arm with "dateCreated" field should fail
    Given template json with a new unique id
    Then set template json field: "dateCreated" to string value: "2016-02-23T16:46:08.911Z"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed"

  Scenario: Update Treatment Arm with "dateCreated" field should fail
    Given template json with a new unique id
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "dateCreated" to string value: "2016-02-23T16:46:08.911Z"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed"

  Scenario: "dateCreated" value can be generated properly
    Given template json with a new unique id
    And set template json field: "version" to string value: "2016-06-03"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm with id: "saved_id" and version: "2016-06-03" return from API has correct dateCreated value