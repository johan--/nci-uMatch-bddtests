#encoding: utf-8

@treatment_arm
Feature: Make sure Treatment Arm API can store and return all fields correctly

  Scenario Outline: Treatment arm return correct values for single fields
    Given template json with a new unique id
    And set template json field: "version" to string value: "2016-06-03"
    And set template json field: "<inputFieldName>" to value: "<fieldValue>" in type: "<dataType>"
    When posted to MATCH newTreatmentArm
    Then the treatment arm with id: "saved_id" and version: "2016-06-03" return from API has value: "<outputFieldName>" in field: "<fieldName>"
    Examples:
    |inputFieldName                  |outputFieldName                  |fieldValue                                         |dataType     |
    |id                              |name                             |APEC1621-ValueVerifications                        |string       |
    |description                     |description                      |This is a test that verify output values           |string       |
    |targetId                        |target_id                        |3453546232                                         |int          |
    |targetId                        |target_id                        |Trametinib in GNAQ or GNA11 mutation               |string       |
    |targetName                      |target_name                      |Trametinib                                         |string       |
    |gene                            |gene                             |GNA                                                |string       |
    |treatmentArmStatus              |treatment_arm_status             |OPEN                                               |string       |
    |studyId                         |study_id                         |APEC1621                                           |string       |
    |stratumId                       |stratum_id                       |kjg13gas                                           |string       |
    |numPatientsAssigned             |num_patients_assigned            |5                                                  |int          |

    
  