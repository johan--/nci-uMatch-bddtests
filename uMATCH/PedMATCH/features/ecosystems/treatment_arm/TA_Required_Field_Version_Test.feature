#encoding: utf-8

@TA_Post_Tests
Feature: Treatment Arm API Tests that focus on "version" field
  Scenario: Two Treatment Arms that have same "version" values but different "id" values should both pass
  Scenario: New Treatment Arm with emtpy "version" field should fail
  Scenario: New Treatment Arm with "version": null should fail
  Scenario: New Treatment Arm without "version" field should fail
  Scenario Outline: New Treatment Arm with special character in "version" field should pass
  Scenario: Update Treatment Arm with empty "version" field should fail
  Scenario: Update Treatment Arm with "version": null should fail
  Scenario: Update Treatment Arm without "version" field should fail
  Scenario Outline: Update Treatment Arm with old "version" value should not be taken
  Scenario Outline: Update Treatment Arm with special character in "version" field should pass