#encoding: utf-8

@treatment_arm
Feature: Treatment Arm API Tests that focus on Single Nucleotide Variants
  Scenario Outline : SNV should return correct inclusion/exclusion value
    Examples:
  Scenario Outline: SNV should return correct armSpecific value
    Examples:
  Scenario Outline: SNV should return full publicMedIds list
    Examples:
  Scenario: Duplicated SNV should be ignored
  Scenario: Treatment arm which contains SNVs with same ID should fail
  Scenario: Treatment arm which contains SNV without ID should fail
  Scenario: SNV with Hotspot Oncomine Variant Class value should pass
  Scenario Outline: SNV with non-Hotspot Oncomine Variant Class value should pass
    Examples:
  Scenario Outline: SNV with non-snv type value should fail
    Examples:

