#encoding: utf-8

@TA_Post_Tests
Feature: Treatment Arm API Tests that focus on "study_id" field
  Scenario: New Treatment Arm with emtpy "study_id" field should fail
  Scenario: New Treatment Arm with "study_id": null should fail
  Scenario: New Treatment Arm without "study_id" field should fail
  Scenario Outline: New Treatment Arm with special character in "study_id" field should pass
  Scenario: Update Treatment Arm with empty "study_id" field should fail
  Scenario: Update Treatment Arm with "study_id": null should fail
  Scenario: Update Treatment Arm without "study_id" field should fail
  Scenario Outline: Update Treatment Arm with special character in "study_id" field should pass