#encoding: utf-8

@treatment_arm
Feature: Treatment Arm API Tests that focus on numPatientsAssigned and maxPatientAllowed fields

  Scenario: New Treatment Arm with numPatientsAssigned field that has minus value should fail
    Given template json with a new unique id
    And set template json field: "numPatientsAssigned" to value: "-30" in type: "int"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed."

  Scenario: New Treatment Arm with zero maxPatientAllowed should fail
    Given template json with a new unique id
    And set template json field: "maxPatientAllowed" to value: "0" in type: "int"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed."

  Scenario: New Treatment Arm with maxPatientAllowed field that has minus value should fail
    Given template json with a new unique id
    And set template json field: "maxPatientAllowed" to value: "-529" in type: "int"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed."

  Scenario: New Treatment Arm that numPatientsAssigned value larger than maxPatientAllowed value should fail
    Given template json with a new unique id
    And set template json field: "numPatientsAssigned" to value: "75" in type: "int"
    And set template json field: "maxPatientAllowed" to value: "35" in type: "int"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed."

  Scenario: Update Treatment Arm with numPatientsAssigned that has minus value should fail
    Given template json with a new unique id
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "version" to string value: "V0000002"
    And set template json field: "numPatientsAssigned" to value: "-73" in type: "int"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed."

  Scenario: Update Treatment Arm with zero maxPatientAllowed should fail
    Given template json with a new unique id
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "version" to string value: "V0000002"
    And set template json field: "maxPatientAllowed" to value: "0" in type: "int"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed."

  Scenario: Update Treatment Arm with maxPatientAllowed that has minus value should fail
    Given template json with a new unique id
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "version" to string value: "V0000002"
    And set template json field: "maxPatientAllowed" to value: "-5" in type: "int"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed."

  Scenario: Update Treatment Arm that numPatientsAssigned value larger than maxPatientAllowed value should fail
    Given template json with a new unique id
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "version" to string value: "V0000002"
    And set template json field: "numPatientsAssigned" to value: "246" in type: "int"
    And set template json field: "maxPatientAllowed" to value: "12" in type: "int"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed."