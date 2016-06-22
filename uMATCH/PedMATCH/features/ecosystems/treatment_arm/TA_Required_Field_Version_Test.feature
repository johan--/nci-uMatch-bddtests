#encoding: utf-8

@Treatment_Arm_API_Tests
Feature: Treatment Arm API Tests that focus on "version" field

  Scenario Outline: TA_VS1. Multiple Treatment Arms that have same "version" values but different "id" values should all pass
    Given template json with an id: "<treatment_arm_id>" and version: "TA_VERSION_TEST_SAME_VERSION"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm with id: "<treatment_arm_id>" and version: "TA_VERSION_TEST_SAME_VERSION" return from API has value: "TA_VERSION_TEST_SAME_VERSION" in field: "version"
    Examples:
    |treatment_arm_id   |
    |APEC1621-VS1-1     |
    |APEC1621-VS1-2     |
    |APEC1621-VS1-3     |

  Scenario: TA_VS2. New Treatment Arm with empty "version" field should fail
    Given template json with an id: "APEC1621-VS2-1" and version: ""
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario: TA_VS3. New Treatment Arm with "version": null should fail
    Given template json with an id: "APEC1621-VS3-1" and version: "null"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario: TA_VS4. New Treatment Arm without "version" field should fail
    Given template json with an id: "APEC1621-VS4-1" and version: "2016-06-03"
    And remove field: "version" from template json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario Outline: TA_VS5. New Treatment Arm, version should take any string value
    Given template json with an id: "<treatment_arm_id>" and version: "<version_value>"
    When posted to MATCH newTreatmentArm
    Then the treatment arm with id: "<treatment_arm_id>" and version: "<version_value>" return from API has value: "<version_value>" in field: "version"
    Examples:
      |treatment_arm_id   |version_value           |
      |APEC1621-VS5-1     |@*$%sdga#               |
      |APEC1621-VS5-2     |!^&*()-_+=              |
      |APEC1621-VS5-3     |{}[]\/?                 |
      |APEC1621-VS5-4     |;'<>,.                  |
      |APEC1621-VS5-5     |?Àü ī                   |
      |APEC1621-VS5-6     |2016-MM-4D              |
      |APEC1621-VS5-7     |2013-04-10 15:32        |

  Scenario: TA_VS6. Update Treatment Arm with empty "version" field should fail
    Given template json with an id: "APEC1621-VS6-1" and version: "2016-06-03"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "version" to string value: ""
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario: TA_VS7. Update Treatment Arm with "version": null should fail
    Given template json with an id: "APEC1621-VS7-1" and version: "2016-06-03"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "version" to string value: "null"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario: TA_VS8. Update Treatment Arm without "version" field should fail
    Given template json with an id: "APEC1621-VS8-1" and version: "2016-06-03"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then remove field: "version" from template json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

#  Scenario Outline: TA_VS9. Update Treatment Arm, version take any string value
#    Given template json with an id: "<treatment_arm_id>" and version: "2015-03-25"
#    When posted to MATCH newTreatmentArm
#    Then success message is returned:
#    Then set template json field: "version" to string value: "<version_value>"
#    When posted to MATCH newTreatmentArm
#    Then the treatment arm with id: "<treatment_arm_id>" and version: "<version_value>" return from API has value: "<version_value>" in field: "version"
#    Examples:
#      |treatment_arm_id   |version_value           |
#      |APEC1621-VS9-1     |@*$%sdga#               |
#      |APEC1621-VS9-2     |!^&*()-_+=              |
#      |APEC1621-VS9-3     |{}[]\/?                 |
#      |APEC1621-VS9-4     |;'<>,.                  |
#      |APEC1621-VS9-5     |?Àü ī                   |
#      |APEC1621-VS9-6     |2016-MM-4D              |
#      |APEC1621-VS9-7     |2013-04-10 15:32        |


  Scenario Outline: TA_VS10. Update Treatment Arm with same "version" value should not be taken
    Given template json with an id: "<treatment_arm_id>" and version: "2016-06-03"
    And set template json field: "<field>" to value: "<value_v1>" in type: "<type>"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "<field>" to value: "<value_v2>" in type: "<type>"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm with id: "<treatment_arm_id>" and version: "2016-06-03" return from API has value: "<value_v1>" in field: "<field>"
    Examples:
      |treatment_arm_id   |field              |value_v1             |value_v2              |type                 |
      |APEC1621-VS10-1    |gene               |EGFR                 |xxyyzz                |string               |

  Scenario: TA_VS11. Multiple versions of one treatment arm id should return in dateCreated descending order
    Given template json with an id: "APEC1621-VS11-1" and version: "2016-06-03"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "version" to string value: "2005-01-24"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "version" to string value: "APEC1621_V000"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "version" to string value: "24.6"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm with id: "APEC1621-VS11-1" and version: "2016-06-03" return from API is in the place: "1"
    Then the treatment arm with id: "APEC1621-VS11-1" and version: "2005-01-24" return from API is in the place: "2"
    Then the treatment arm with id: "APEC1621-VS11-1" and version: "APEC1621_V000" return from API is in the place: "3"
    Then the treatment arm with id: "APEC1621-VS11-1" and version: "24.6" return from API is in the place: "4"


