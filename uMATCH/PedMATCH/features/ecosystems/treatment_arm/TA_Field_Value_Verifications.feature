#encoding: utf-8

@treatment_arm
Feature: Make sure Treatment Arm API can store and return all fields correctly

  Scenario Outline: TA_VV1. Treatment arm return correct values for single fields
    Given template json with an id: "<treatment_arm_id>" and version: "2016-06-03"
    And set template json field: "<inputFieldName>" to value: "<fieldValue>" in type: "<dataType>"
    When posted to MATCH newTreatmentArm
    Then the treatment arm with id: "<treatment_arm_id>" and version: "2016-06-03" return from API has "<dataType>" value: "<fieldValue>" in field: "<outputFieldName>"
    Examples:
      |treatment_arm_id     |inputFieldName                  |outputFieldName                  |fieldValue                                         |dataType     |
      |APEC1621-VV1-1       |description                     |description                      |This is a test that verify output values           |string       |
      |APEC1621-VV1-2       |targetId                        |target_id                        |3453546232                                         |int          |
      |APEC1621-VV1-3       |targetId                        |target_id                        |Trametinib in GNAQ or GNA11 mutation               |string       |
      |APEC1621-VV1-4       |targetName                      |target_name                      |Trametinib                                         |string       |
      |APEC1621-VV1-5       |gene                            |gene                             |GNA                                                |string       |
      |APEC1621-VV1-6       |treatmentArmStatus              |treatment_arm_status             |OPEN                                               |string       |
      |APEC1621-VV1-7       |studyId                         |study_id                         |APEC1621                                           |string       |
      |APEC1621-VV1-8       |stratumId                       |stratum_id                       |kjg13gas                                           |string       |
      |APEC1621-VV1-9       |numPatientsAssigned             |num_patients_assigned            |5                                                  |int          |

  Scenario Outline: TA_VV2. Treatment arm return correct values for ExclusionCriterias
    Given template json with an id: "<treatment_arm_id>" and version: "2016-06-03"
    Then add exclusionCriterias with id: "<exclusionCriteriaID>" and description: "<description>"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm with id: "<treatment_arm_id>" and version: "2016-06-03" return from API has exclusionCriteria (id: "<exclusionCriteriaID>", description: "<description>")
    Examples:
      |treatment_arm_id     |exclusionCriteriaID  |description  |
      |APEC1621-VV2-1       |31                   |ASIAN        |
      |APEC1621-VV2-2       |32                   |FEMALE       |