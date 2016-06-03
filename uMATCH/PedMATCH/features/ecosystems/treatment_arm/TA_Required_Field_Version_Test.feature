#encoding: utf-8

@Treatment_Arm_API_Tests
Feature: Treatment Arm API Tests that focus on "version" field

  Scenario Outline: Multiple Treatment Arms that have same "version" values but different "id" values should all pass
    Given template json with a new unique id
    And add suffix: "<suffix>" to the value of template json field: "id"
    And set template json field: "version" to string value: "TA_VERSION_TEST_SAME_VERSION"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Examples:
    |suffix             |
    |VERSION_TEST_001   |
    |VERSION_TEST_002   |
    |VERSION_TEST_003   |
    |VERSION_TEST_004   |
    |VERSION_TEST_005   |

  Scenario: New Treatment Arm with empty "version" field should fail
    Given template json with a new unique id
    And set template json field: "version" to string value: ""
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario: New Treatment Arm with "version": null should fail
    Given template json with a new unique id
    And set template json field: "version" to string value: "null"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario: New Treatment Arm without "version" field should fail
    Given template json with a new unique id
    And remove field: "version" from template json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario Outline: New Treatment Arm, version with any string value other than date string "YYYY-MM-DD" should fail
    Given template json with a new unique id
    And set template json field: "version" to string value: "<version_value>"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed."
    Examples:
      |version_value           |
      |@*$%sdga#               |
      |YYYY-MM-DD              |
      |2016-MM-4D              |
      |2012-85-99              |
      |2013-04-10 15:32        |

  Scenario: Update Treatment Arm with empty "version" field should fail
    Given template json with a new unique id
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "version" to string value: ""
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario: Update Treatment Arm with "version": null should fail
    Given template json with a new unique id
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "version" to string value: "null"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario: Update Treatment Arm without "version" field should fail
    Given template json with a new unique id
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then remove field: "version" from template json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario Outline: Update Treatment Arm, version with any string value other than date string "YYYY-MM-DD" should fail
    Given template json with a new unique id
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "version" to string value: "<version_value>"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed."
    Examples:
      |version_value           |
      |@*$%sdga#               |
      |YYYY-MM-DD              |
      |2016-MM-4D              |
      |2012-85-99              |
      |2013-04-10 15:32        |


  Scenario Outline: Update Treatment Arm with same "version" value should not be taken
    Given template json with a new unique id
    And set template json field: "version" to string value: "2016-06-03"
    And set template json field: "<field>" to value: "<value_v1>" in type: "<type>"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "<field>" to value: "<value_v2>" in type: "<type>"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm with id: "saved_id" and version: "2016-06-03" return from API has value: "<value_v1>" in field: "<field>"
    Examples:
    |field              |value_v1             |value_v2              |type                 |
    |gene               |EGFR                 |xxyyzz                |string               |




## Version field cannot accept random string
#  Scenario Outline: New Treatment Arm with special character in "version" field should pass
#    Given template json with a new unique id
#    And set template json field: "version" to string value: "<version_value>"
#    When posted to MATCH newTreatmentArm
#    Then success message is returned:
#    Then the treatment arm with id: "saved_id" and version: "<version_value>" should return from database
#    Examples:
#    |version_value           |
#    |@*$%sdga#               |
#    |!^&*()-_+=              |
#    |{}[]\/?                 |
#    |;'<>,.                  |
#    |?Àü ī                   |

#  Scenario Outline: Update Treatment Arm with special character in "version" field should pass
#    Given template json with a new unique id
#    When posted to MATCH newTreatmentArm
#    Then success message is returned:
#    Then set template json field: "version" to string value: "<version_value>"
#    When posted to MATCH newTreatmentArm
#    Then success message is returned:
#    Then the treatment arm with id: "saved_id" and version: "<version_value>" should return from database
#    Examples:
#      |version_value           |
#      |@*$%sdga#               |
#      |!^&*()-_+=              |
#      |{}[]\/?                 |
#      |;'<>,.                  |
#      |?Àü ī                   |