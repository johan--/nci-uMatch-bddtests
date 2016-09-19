#encoding: utf-8

@treatment_arm
Feature: pMATCH Treatment Arm API Tests that focus on num_patients_assigned and maxPatientAllowed fields

  Scenario Outline: TA_PC2. New Treatment Arm, float value in numPatientAssigned should be trimmed to int value
    Given template treatment arm json with an id: "<treatmentArmID>"
    And set template treatment arm json field: "num_patients_assigned" to value: "<floatValue>" in type: "float"
    When creating a new treatment arm using post request
    Then a success message is returned
    Then retrieve the posted treatment arm from API
    Then the returned treatment arm has value: "<intValue>" in field: "num_patients_assigned"
    Examples:
    |treatmentArmID|floatValue     |intValue    |
    |APEC1621-PC2-1|23.8           |23          |
    |APEC1621-PC2-2|0.6837         |0           |

  Scenario Outline: TA_PC3. New Treatment Arm, numPatientAssigned should not have limit
    Given template treatment arm json with an id: "<treatmentArmID>"
    And set template treatment arm json field: "num_patients_assigned" to value: "<value>" in type: "int"
    When creating a new treatment arm using post request
    Then a success message is returned
    Then retrieve the posted treatment arm from API
    Then the returned treatment arm has value: "<floatResult>" in field: "num_patients_assigned"
    Examples:
      |treatmentArmID|value          |floatResult  |
      |APEC1621-PC3-1|500            |500          |
      |APEC1621-PC3-2|13025          |13025        |
