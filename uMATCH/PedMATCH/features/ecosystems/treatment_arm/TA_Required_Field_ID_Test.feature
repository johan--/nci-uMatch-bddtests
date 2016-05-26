#encoding: utf-8

@TA_Post_Tests
Feature: Treatment Arm API Tests that focus on "id" field
  Scenario: New Treatment Arm with emtpy "id" field should fail
  Scenario: New Treatment Arm with "id": null should fail
  Scenario: New Treatment Arm without "id" field should fail
  Scenario Outline: New Treatment Arm with special character in "id" field should pass
  Scenario: Update Treatment Arm with empty "id" field should fail
  Scenario: Update Treatment Arm with "id": null should fail
  Scenario: Update Treatment Arm without "id" field should fail
  Scenario Outline: Update Treatment Arm with special character in "id" field should pass