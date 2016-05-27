#encoding: utf-8

@TA_Post_Tests
Feature: Treatment Arm API Tests that focus on "treatmentArmStatus" field

  Scenario Outline: New Treatment Arm with invalid "treatmentArmStatus" value should fail (including empty string)
  Scenario: New Treatment Arm with "treatmentArmStatus":null value should pass
  Scenario: New Treatment Arm without "treatmentArmStatus" value should pass
  Scenario: New Treatment Arm with "treatmentArmStatus": CLOSED should fail
  Scenario: New Treatment Arm with "treatmentArmStatus": SUSPENDED should fail
  Scenario: Update Treatment Arm with invalid "treatmentArmStatus" value should fail
  Scenario: Update Treatment Arm should have properly updated "statusLog" field
  Scenario: Update Treatment Arm with invalid "treatmentArmStatus" value should fail
  Scenario: Existing Treatment Arm with "treatmentArmStatus": CLOSED can not be updated anymore
  Scenario: Existing Treatment Arm with "treatmentArmStatus": OPEN can be updated to SUSPENDED
  Scenario: Existing Treatment Arm with "treatmentArmStatus": OPEN can be updated to CLOSED
  Scenario: Existing Treatment Arm with "treatmentArmStatus": SUSPENDED can be updated to OPEN
  Scenario: Existing Treatment Arm with "treatmentArmStatus": SUSPENDED can be updated to CLOSED
