#encoding: utf-8

@TA_Post_Tests
Feature: Treatment Arm API Tests that focus on numPatientsAssigned and maxPatientAllowed fields
  Scenario: New Treatment Arm with numPatientsAssigned that has minus value should fail
  Scenario: New Treatment Arm with maxPatientAllowed that has minus value should fail
  Scenario: New Treatment Arm that numPatientsAssigned value larger than maxPatientAllowed value should fail
  Scenario: Update Treatment Arm with numPatientsAssigned that has minus value should fail
  Scenario: Update Treatment Arm with maxPatientAllowed that has minus value should fail
  Scenario: Update Treatment Arm that numPatientsAssigned value larger than maxPatientAllowed value should fail