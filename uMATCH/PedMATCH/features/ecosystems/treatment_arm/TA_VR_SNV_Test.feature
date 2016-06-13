#encoding: utf-8

@treatment_arm
Feature: Treatment Arm API Tests that focus on Single Nucleotide Variants Report
  Scenario: New treatment arm has correct inclusion/exclusion value
  Scenario: New treatment arm has correct armSpecific value
  Scenario: New treatment arm has full publicMedIds list
  Scenario: New treatment arm which contains SNVs with same ID should fail
  Scenario: New treatment arm which contains SNV without ID should fail
  Scenario: Update treatment arm has correct inclusion/exclusion value
  Scenario: Update treatment arm has correct armSpecific value
  Scenario: Update treatment arm has full publicMedIds list
  Scenario: Update treatment arm which contains SNVs with same ID should fail
  Scenario: Update treatment arm which contains SNV without ID should fail
