#encoding: utf-8
@treatment_arm
Feature: Treatment Arm API Tests that focus on "version" field

  Scenario Outline: TA_VS1. Multiple Treatment Arms that have same "version" values but different "id" values should all pass
    Given template treatment arm json with an id: "<treatment_arm_id>", stratum_id: "stratum1" and version: "TA_VERSION_TEST_SAME_VERSION"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then retrieve the posted treatment arm from API
    Then the returned treatment arm has value: "TA_VERSION_TEST_SAME_VERSION" in field: "version"
    Examples:
    |treatment_arm_id   |
    |APEC1621-VS1-1     |
    |APEC1621-VS1-2     |
    |APEC1621-VS1-3     |

  Scenario: TA_VS2. New Treatment Arm with empty "version" field should fail
    Given template treatment arm json with an id: "APEC1621-VS2-1", stratum_id: "stratum1" and version: ""
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario: TA_VS3. New Treatment Arm with "version": null should fail
    Given template treatment arm json with an id: "APEC1621-VS3-1", stratum_id: "stratum1" and version: "null"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "The property '#/version' of type NilClass did not match the following type: string"

  Scenario: TA_VS4. New Treatment Arm without "version" field should fail
    Given template treatment arm json with an id: "APEC1621-VS4-1"
    And remove field: "version" from template treatment arm json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "did not contain a required property of 'version'"

#  Scenario Outline: TA_VS5. New Treatment Arm, version should take any string value
#    Given template treatment arm json with an id: "<treatment_arm_id>", stratum_id: "stratum1" and version: "<version_value>"
#    When posted to MATCH newTreatmentArm
#    Then retrieve treatment arm with id: "<treatment_arm_id>", stratum_id: "stratum1" and version: "<encoded_version>" from API
#    Then the returned treatment arm has value: "<version_value>" in field: "version"
#    Examples:
#      |treatment_arm_id   |version_value           |encoded_version                                           |
#      |APEC1621-VS5-1     |@*$%#!^&*()-_+=         |%40*%24%25%23!%5E%26*()-_%2B%3D                           |
#      |APEC1621-VS5-2     |{}[]\/?;'<>,Àü ī        |%7B%7D%5B%5D%5C%2F%3F%3B%27%3C%3E%2C%C3%80%C3%BC%20%C4%AB |
#      |APEC1621-VS5-3     |2013-04-10 15:32        |2013-04-10%2015%3A32                                      |
#      |APEC1621-VS5-4     |55.27                   |55.27                                                     |

  Scenario: TA_VS6. Update Treatment Arm with empty "version" field should fail
    Given template treatment arm json with an id: "APEC1621-VS6-1", stratum_id: "stratum1" and version: "2016-06-03"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then wait for "5" seconds
    Then set the version of the treatment arm to ""
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario: TA_VS7. Update Treatment Arm with "version": null should fail
    Given template treatment arm json with an id: "APEC1621-VS7-1", stratum_id: "stratum1" and version: "2016-06-03"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then wait for "5" seconds
    Then set the version of the treatment arm to "null"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "The property '#/version' of type NilClass did not match the following type: string"

  Scenario: TA_VS8. Update Treatment Arm without "version" field should fail
    Given template treatment arm json with an id: "APEC1621-VS8-1", stratum_id: "stratum1" and version: "2016-06-03"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then wait for "5" seconds
    Then remove field: "version" from template treatment arm json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "did not contain a required property of 'version'"

#  Scenario Outline: TA_VS9. Update Treatment Arm, version take any string value
#    Given template treatment arm json with an id: "<treatment_arm_id>" and version: "2015-03-25"
#    When posted to MATCH newTreatmentArm
#    Then success message is returned:
#    Then set the version of the treatment arm to "<version_value>"
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
    Given template treatment arm json with an id: "<treatment_arm_id>", stratum_id: "STRATUM1" and version: "2016-06-03"
    And set template treatment arm json field: "<field>" to value: "<value_v1>" in type: "<type>"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then wait for "5" seconds
    Then set template treatment arm json field: "<field>" to value: "<value_v2>" in type: "<type>"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then retrieve the posted treatment arm from API
    Then the returned treatment arm has value: "<value_v1>" in field: "<field>"
    Examples:
      |treatment_arm_id   |field              |value_v1             |value_v2              |type                 |
      |APEC1621-VS10-1    |gene               |EGFR                 |xxyyzz                |string               |

  Scenario: TA_VS11. Multiple versions of one treatment arm id should return in dateCreated descending order
    Given template treatment arm json with an id: "APEC1621-VS11-1", stratum_id: "STRATUM1" and version: "2016-06-03"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then wait for "5" seconds
    Then set the version of the treatment arm to "2005-01-24"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then wait for "5" seconds
    Then set the version of the treatment arm to "APEC1621_V000"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then wait for "5" seconds
    Then set the version of the treatment arm to "24.6"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then retrieve treatment arms with id: "APEC1621-VS11-1" and stratum_id: "STRATUM1" from API
    Then the treatment arm with version: "2016-06-03" is in the place: "4" of returned treatment arm list
    Then the treatment arm with version: "2005-01-24" is in the place: "3" of returned treatment arm list
    Then the treatment arm with version: "APEC1621_V000" is in the place: "2" of returned treatment arm list
    Then the treatment arm with version: "24.6" is in the place: "1" of returned treatment arm list



