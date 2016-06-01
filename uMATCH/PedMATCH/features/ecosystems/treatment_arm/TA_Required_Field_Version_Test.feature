#encoding: utf-8

@TA_Post_Tests
Feature: Treatment Arm API Tests that focus on "version" field

  Scenario: Prepare a new Treatment Arm for update tests
    Given template json with a new unique id
    And save id for later use
    And set template json field: "version" to string value: "TA_VERSION_TEST_V_000"
    When posted to MATCH newTreatmentArm
    Then success message is returned:

  Scenario Outline: Multiple Treatment Arms that have same "version" values but different "id" values should all pass
    Given template json with a new unique id
    And restore to saved id
    And add prefix: "<prefix>" to the value of template json field: "<field>"
    And set template json field: "version" to string value: "TA_VERSION_TEST_SAME_VERSION"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Examples:
    |field |prefix                   |
    |id    |TA_VERSION_TEST_ID_001   |
    |id    |TA_VERSION_TEST_ID_002   |
    |id    |TA_VERSION_TEST_ID_003   |
    |id    |TA_VERSION_TEST_ID_004   |
    |id    |TA_VERSION_TEST_ID_005   |

  Scenario: New Treatment Arm with emtpy "version" field should fail
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

  Scenario Outline: New Treatment Arm with special character in "version" field should pass
    Given template json with a new unique id
    And restore to saved id
    And add prefix: "<id_prefix>" to the value of template json field: "id"
    And set template json field: "version" to string value: "<version_value>"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Examples:
    |id_prefix                         |version_value      |
    |TA_VERSION_TEST_SPECIAL_CHAR_001  |(*&$%^(HKG         |

  Scenario: Update Treatment Arm with empty "version" field should fail
    Given template json with a new unique id
    And restore to saved id
    And set template json field: "version" to string value: ""
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario: Update Treatment Arm with "version": null should fail
    Given template json with a new unique id
    And restore to saved id
    And set template json field: "version" to string value: "null"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario: Update Treatment Arm without "version" field should fail
    Given template json with a new unique id
    And restore to saved id
    And remove field: "version" from template json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario Outline: Update Treatment Arm with special character in "version" field should pass
    Given template json with a new unique id
    And restore to saved id
    And set template json field: "<field>" to string value: "<value>"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Examples:
      |field      |value               |
      |version    |$^#$%$HDH           |


#  Scenario Outline: Update Treatment Arm with same "version" value should pass
#    Given template json with a new unique id
#    And restore to saved id
#    And set template json field: "version" to string value: "TA_VERSION_UPDATE_VERSION"
#    And set template json field: "<field>" to string value: "<value>"
#
#  Scenario Outline: Verify update Treatment Arm with same "version" value should not be taken