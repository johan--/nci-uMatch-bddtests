#encoding: utf-8

@TA_Post_Tests
Feature: Treatment Arm API Tests that focus on "name" field
  Scenario: New Treatment Arm with emtpy "name" field should fail
  Scenario: New Treatment Arm with "name": null should fail
  Scenario: New Treatment Arm without "name" field should fail
  Scenario Outline: New Treatment Arm with special character in "name" field should pass
  Scenario: Update Treatment Arm with empty "name" field should fail
  Scenario: Update Treatment Arm with "name": null should fail
  Scenario: Update Treatment Arm without "name" field should fail
  Scenario Outline: Update Treatment Arm with special character in "name" field should pass