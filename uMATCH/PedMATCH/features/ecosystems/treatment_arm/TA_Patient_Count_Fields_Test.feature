#encoding: utf-8

@treatment_arm
Feature: pMATCH Treatment Arm API Tests that focus on numPatientsAssigned and maxPatientAllowed fields

  Scenario: New Treatment Arm with numPatientsAssigned field that has minus value should fail
    Given template json with a new unique id
    And set template json field: "numPatientsAssigned" to value: "-30" in type: "int"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed."
    
  Scenario Outline: New Treatment Arm, float value in numPatientAssigned should be trimmed to int value
    Given template json with a new unique id
    And set template json field: "numPatientsAssigned" to value: "<floatValue>" in type: "float"
    And set template json field: "version" to string value: "V0000001"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm with id: "saved_id" and version: "V0000001" return from API has value: "<intValue>" in field: "num_patients_assigned"
    Examples:
    |floatValue     |intValue       |
    |23.8           |23.0           |
    |0.6837         |0.0            |

  Scenario Outline: New Treatment Arm, numPatientAssigned should not have limit
    Given template json with a new unique id
    And set template json field: "numPatientsAssigned" to value: "<value>" in type: "int"
    And set template json field: "version" to string value: "V0000001"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm with id: "saved_id" and version: "V0000001" return from API has value: "<floatResult>" in field: "num_patients_assigned"
    Examples:
      |value          |floatResult    |
      |500            |500.0          |
      |13025          |13025.0        |

  Scenario Outline: New pMATCH Treatment Arm with maxPatientAllowed field should fail
    Given template json with a new unique id
    And set template json field: "study_id" to string value: "APEC1621"
    And set template json field: "maxPatientsAllowed" to value: "<value>" in type: "int"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed."
    Examples:
    |value    |
    |-5       |
    |35       |
    |0        |
    |null     |

  Scenario: Update Treatment Arm with numPatientsAssigned that has minus value should fail
    Given template json with a new unique id
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "version" to string value: "V0000002"
    And set template json field: "numPatientsAssigned" to value: "-73" in type: "int"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed."


  Scenario Outline: Update Treatment Arm, float value in numPatientAssigned should be trimmed to int value
    Given template json with a new unique id
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "numPatientsAssigned" to value: "<floatValue>" in type: "float"
    And set template json field: "version" to string value: "V0000002"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm with id: "saved_id" and version: "V0000002" return from API has value: "<intValue>" in field: "num_patients_assigned"
    Examples:
      |floatValue     |intValue       |
      |23.8           |23.0           |
      |0.6837         |0.0            |

  Scenario Outline: Update Treatment Arm, numPatientAssigned should not have limit
    Given template json with a new unique id
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "numPatientsAssigned" to value: "<value>" in type: "int"
    And set template json field: "version" to string value: "V0000002"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm with id: "saved_id" and version: "V0000002" return from API has value: "<floatResult>" in field: "num_patients_assigned"
    Examples:
      |value          |floatResult    |
      |500            |500.0          |
      |13025          |13025.0        |

  Scenario Outline: Update pMATCH Treatment Arm with maxPatientAllowed field should fail
    Given template json with a new unique id
    And set template json field: "study_id" to string value: "APEC1621"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "version" to string value: "V0000002"
    And set template json field: "maxPatientsAllowed" to value: "<value>" in type: "int"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed."
    Examples:
      |value    |
      |-5       |
      |35       |
      |0        |
      |null     |
    
#These are uMATCH test cases:
#  Scenario: New Treatment Arm with zero maxPatientAllowed should fail
#    Given template json with a new unique id
#    And set template json field: "maxPatientAllowed" to value: "0" in type: "int"
#    When posted to MATCH newTreatmentArm
#    Then a failure message is returned which contains: "Validation failed."
#
#  Scenario: New Treatment Arm with maxPatientAllowed field that has minus value should fail
#    Given template json with a new unique id
#    And set template json field: "maxPatientAllowed" to value: "-529" in type: "int"
#    When posted to MATCH newTreatmentArm
#    Then a failure message is returned which contains: "Validation failed."
#
#  Scenario: New Treatment Arm that numPatientsAssigned value larger than maxPatientAllowed value should fail
#    Given template json with a new unique id
#    And set template json field: "numPatientsAssigned" to value: "75" in type: "int"
#    And set template json field: "maxPatientAllowed" to value: "35" in type: "int"
#    When posted to MATCH newTreatmentArm
#    Then a failure message is returned which contains: "Validation failed."


#  Scenario: Update Treatment Arm with zero maxPatientAllowed should fail
#    Given template json with a new unique id
#    When posted to MATCH newTreatmentArm
#    Then success message is returned:
#    Then set template json field: "version" to string value: "V0000002"
#    And set template json field: "maxPatientAllowed" to value: "0" in type: "int"
#    When posted to MATCH newTreatmentArm
#    Then a failure message is returned which contains: "Validation failed."
#
#  Scenario: Update Treatment Arm with maxPatientAllowed that has minus value should fail
#    Given template json with a new unique id
#    When posted to MATCH newTreatmentArm
#    Then success message is returned:
#    Then set template json field: "version" to string value: "V0000002"
#    And set template json field: "maxPatientAllowed" to value: "-5" in type: "int"
#    When posted to MATCH newTreatmentArm
#    Then a failure message is returned which contains: "Validation failed."
#
#  Scenario: Update Treatment Arm that numPatientsAssigned value larger than maxPatientAllowed value should fail
#    Given template json with a new unique id
#    When posted to MATCH newTreatmentArm
#    Then success message is returned:
#    Then set template json field: "version" to string value: "V0000002"
#    And set template json field: "numPatientsAssigned" to value: "246" in type: "int"
#    And set template json field: "maxPatientAllowed" to value: "12" in type: "int"
#    When posted to MATCH newTreatmentArm
#    Then a failure message is returned which contains: "Validation failed."