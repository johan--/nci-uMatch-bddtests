#encoding: utf-8

@treatment_arm
Feature: Treatment Arm API Tests that focus on "study_id" field

  Scenario Outline: TA_SID1. New Treatment Arm, values other than "APEC1621" and "EAY131" in "study_id" field should fail
    Given template treatment arm json with a random id
    And set template treatment arm json field: "study_id" to string value: "<study_id_value>"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed."
    Examples:
    |study_id_value     |
    |OTHER_STUDY        |
    |xxyyzz             |
    |null               |
    |                   |

  Scenario: TA_SID2. New Treatment Arm without "study_id" field should fail
    Given template treatment arm json with a random id
    And remove field: "study_id" from template treatment arm json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario Outline: TA_SID3. "study_id" field should not be updated to other value
    Given template treatment arm json with an id: "<treatment_arm_id>", stratum_id: "stratum1" and version: "2015-03-25"
    Then set template treatment arm json field: "study_id" to string value: "<origin_study_id>"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then wait for "5" seconds
    Then set template treatment arm json field: "version" to string value: "2016-06-03"
    And set template treatment arm json field: "study_id" to string value: "<new_study_id>"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed."
    Examples:
      |treatment_arm_id     |origin_study_id        |new_study_id     |
      |APEC1621-SID3-1      |APEC1621               |EAY131           |
      |APEC1621-SID3-2      |EAY131                 |APEC1621         |

#  Scenario: TA_SID4. Update Treatment Arm without "study_id" field should fail
#    Given template treatment arm json with an id: "APEC1621-SID4-1" and version: "2015-03-25"
#    Then set template treatment arm json field: "study_id" to string value: "APEC1621"
#    When posted to MATCH newTreatmentArm
#    Then success message is returned:
#    Then set template treatment arm json field: "version" to string value: "2016-06-03"
#    And remove field: "study_id" from template treatment arm json
#    When posted to MATCH newTreatmentArm
#    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"
