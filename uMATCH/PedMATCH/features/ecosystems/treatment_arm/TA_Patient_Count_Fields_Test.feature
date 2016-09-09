#encoding: utf-8

@treatment_arm
Feature: pMATCH Treatment Arm API Tests that focus on num_patients_assigned and maxPatientAllowed fields

  Scenario: TA_PC1. New Treatment Arm with num_patients_assigned field that has minus value should fail
    Given template treatment arm json with a random id
    And set template treatment arm json field: "num_patients_assigned" to value: "-30" in type: "int"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed."
    @fling
  Scenario Outline: TA_PC2. New Treatment Arm, float value in numPatientAssigned should be trimmed to int value
    Given template treatment arm json with an id: "<treatmentArmID>"
    And set template treatment arm json field: "num_patients_assigned" to value: "<floatValue>" in type: "float"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then retrieve the posted treatment arm from API
    Then the returned treatment arm has value: "<intValue>" in field: "num_patients_assigned"
    Examples:
    |treatmentArmID|floatValue     |intValue    |
    |APEC1621-PC2-1|23.8           |23          |
    |APEC1621-PC2-2|0.6837         |0           |

  Scenario Outline: TA_PC3. New Treatment Arm, numPatientAssigned should not have limit
    Given template treatment arm json with an id: "<treatmentArmID>"
    And set template treatment arm json field: "num_patients_assigned" to value: "<value>" in type: "int"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then retrieve the posted treatment arm from API
    Then the returned treatment arm has value: "<floatResult>" in field: "num_patients_assigned"
    Examples:
      |treatmentArmID|value          |floatResult    |
      |APEC1621-PC3-1|500            |500.0          |
      |APEC1621-PC3-2|13025          |13025.0        |


#  Scenario: TA_PC5. Update Treatment Arm with num_patients_assigned that has minus value should fail
#    Given template treatment arm json with an id: "APEC1621-PC5-1" and version: "2015-03-25"
#    When posted to MATCH newTreatmentArm
#    Then success message is returned:
#    Then set the version of the treatment arm to "2016-06-03"
#    And set template treatment arm json field: "num_patients_assigned" to value: "-73" in type: "int"
#    When posted to MATCH newTreatmentArm
#    Then a failure message is returned which contains: "Validation failed."
#
#
#  Scenario Outline: TA_PC6. Update Treatment Arm, float value in numPatientAssigned should be trimmed to int value
#    Given template treatment arm json with an id: "<treatment_arm_id>" and version: "2015-03-25"
#    When posted to MATCH newTreatmentArm
#    Then success message is returned:
#    Then set template treatment arm json field: "num_patients_assigned" to value: "<floatValue>" in type: "float"
#    And set the version of the treatment arm to "2016-06-03"
#    When posted to MATCH newTreatmentArm
#    Then success message is returned:
#    Then the treatment arm with id: "<treatment_arm_id>" and version: "2016-06-03" return from API has value: "<intValue>" in field: "num_patients_assigned"
#    Examples:
#      |treatment_arm_id   |floatValue     |intValue       |
#      |APEC1621-PC6-1     |23.8           |23.0           |
#      |APEC1621-PC6-2     |0.6837         |0.0            |
#
#  Scenario Outline: TA_PC7. Update Treatment Arm, numPatientAssigned should not have limit
#    Given template treatment arm json with an id: "<treatment_arm_id>" and version: "2015-03-25"
#    When posted to MATCH newTreatmentArm
#    Then success message is returned:
#    Then set template treatment arm json field: "num_patients_assigned" to value: "<value>" in type: "int"
#    And set the version of the treatment arm to "2016-06-03"
#    When posted to MATCH newTreatmentArm
#    Then success message is returned:
#    Then the treatment arm with id: "<treatment_arm_id>" and version: "2016-06-03" return from API has value: "<floatResult>" in field: "num_patients_assigned"
#    Examples:
#      |treatment_arm_id   |value          |floatResult    |
#      |APEC1621-PC7-1     |500            |500.0          |
#      |APEC1621-PC7-2     |13025          |13025.0        |
#
#  Scenario Outline: TA_PC8. Update pMATCH Treatment Arm with maxPatientAllowed field should fail
#    Given template treatment arm json with an id: "<treatment_arm_id>" and version: "2015-03-25"
#    And set template treatment arm json field: "study_id" to string value: "APEC1621"
#    When posted to MATCH newTreatmentArm
#    Then success message is returned:
#    Then set the version of the treatment arm to "2016-06-03"
#    And set template treatment arm json field: "maxPatientsAllowed" to value: "<value>" in type: "int"
#    When posted to MATCH newTreatmentArm
#    Then a failure message is returned which contains: "Validation failed."
#    Examples:
#      |treatment_arm_id   |value    |
#      |APEC1621-PC8-1     |-5       |
#      |APEC1621-PC8-2     |35       |
#      |APEC1621-PC8-3     |0        |
#      |APEC1621-PC8-4     |null     |
    
#These are uMATCH test cases:
#  Scenario: New Treatment Arm with zero maxPatientAllowed should fail
#    Given template treatment arm json with a new unique id
#    And set template treatment arm json field: "maxPatientAllowed" to value: "0" in type: "int"
#    When posted to MATCH newTreatmentArm
#    Then a failure message is returned which contains: "Validation failed."
#
#  Scenario: New Treatment Arm with maxPatientAllowed field that has minus value should fail
#    Given template treatment arm json with a new unique id
#    And set template treatment arm json field: "maxPatientAllowed" to value: "-529" in type: "int"
#    When posted to MATCH newTreatmentArm
#    Then a failure message is returned which contains: "Validation failed."
#
#  Scenario: New Treatment Arm that num_patients_assigned value larger than maxPatientAllowed value should fail
#    Given template treatment arm json with a new unique id
#    And set template treatment arm json field: "num_patients_assigned" to value: "75" in type: "int"
#    And set template treatment arm json field: "maxPatientAllowed" to value: "35" in type: "int"
#    When posted to MATCH newTreatmentArm
#    Then a failure message is returned which contains: "Validation failed."


#  Scenario: Update Treatment Arm with zero maxPatientAllowed should fail
#    Given template treatment arm json with a new unique id
#    When posted to MATCH newTreatmentArm
#    Then success message is returned:
#    Then set the version of the treatment arm to "V0000002"
#    And set template treatment arm json field: "maxPatientAllowed" to value: "0" in type: "int"
#    When posted to MATCH newTreatmentArm
#    Then a failure message is returned which contains: "Validation failed."
#
#  Scenario: Update Treatment Arm with maxPatientAllowed that has minus value should fail
#    Given template treatment arm json with a new unique id
#    When posted to MATCH newTreatmentArm
#    Then success message is returned:
#    Then set the version of the treatment arm to "V0000002"
#    And set template treatment arm json field: "maxPatientAllowed" to value: "-5" in type: "int"
#    When posted to MATCH newTreatmentArm
#    Then a failure message is returned which contains: "Validation failed."
#
#  Scenario: Update Treatment Arm that num_patients_assigned value larger than maxPatientAllowed value should fail
#    Given template treatment arm json with a new unique id
#    When posted to MATCH newTreatmentArm
#    Then success message is returned:
#    Then set the version of the treatment arm to "V0000002"
#    And set template treatment arm json field: "num_patients_assigned" to value: "246" in type: "int"
#    And set template treatment arm json field: "maxPatientAllowed" to value: "12" in type: "int"
#    When posted to MATCH newTreatmentArm
#    Then a failure message is returned which contains: "Validation failed."