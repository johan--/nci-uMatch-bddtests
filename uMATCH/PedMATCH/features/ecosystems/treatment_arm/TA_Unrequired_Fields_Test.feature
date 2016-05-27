#encoding: utf-8

@TA_Post_Tests
Feature: Treatment Arm API Tests that focus on Unrequired fields
  Scenario Outline: New Treatment Arm with emtpy unrequired field should pass
  Scenario Outline: New Treatment Arm with unrequired field: null should pass
  Scenario Outline: New Treatment Arm without unrequired field should pass
  Scenario Outline: New Treatment Arm with special character in unrequired field should pass
  Scenario Outline: New Treatment Arm with undefined fields should pass
  Scenario Outline: Update Treatment Arm with empty unrequired field should pass
  Scenario Outline: Update Treatment Arm with unrequired field: null should pass
  Scenario Outline: Update Treatment Arm without unrequired field should pass
  Scenario Outline: Update Treatment Arm with special character in unrequired field should pass
  Scenario Outline: Update Treatment Arm with unrequired field which has improper data type values should fail
  Scenario Outline: Update Treatment Arm with undefined fields should pass