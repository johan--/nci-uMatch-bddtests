#encoding: utf-8

@treatment_arm
Feature: Treatment Arm API Tests that focus on Single Nucleotide Variants
  Scenario Outline: SNV should return correct inclusion/exclusion value
    Given template json with a new unique id
    Then set template json field: "version" to string value: "2016-06-03"
    Then clear template json's SNV
    Then create a template SNV
    And set template SNV variant field: "identifier" to string value: "<identifier>"
    And set template SNV variant field: "inclusion" to bool value: "<inclusionValue>"
    Then add template SNV to template json
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm with id: "saved_id" and version: "2016-06-03" return from API has SNV variant (id: "<identifier>": "inclusion", value: "<inclusionValue>")
    Examples:
    |identifier             |inclusionValue   |
    |COSM1686998            |true             |
    |COSM583                |false            |

  Scenario Outline: SNV should return correct armSpecific value
    Given template json with a new unique id
    Then set template json field: "version" to string value: "2016-06-03"
    Then clear template json's SNV
    Then create a template SNV
    And set template SNV variant field: "identifier" to string value: "<identifier>"
    And set template SNV variant field: "<inputField>" to bool value: "<inputValue>"
    Then add template SNV to template json
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm with id: "saved_id" and version: "2016-06-03" return from API has SNV variant (id: "<identifier>": "<outputField>", value: "<inputValue>")
    Examples:
      |identifier             |inputField       |inputValue   |outputField      |
      |COSM1686998            |armSpecific      |true         |arm_specific     |
      |COSM583                |armSpecific      |false        |arm_specific     |
#  Scenario Outline: SNV should return full publicMedIds list
#    Examples:
#  Scenario: Treatment arm which contains SNVs with same ID should fail
#  Scenario: Treatment arm which contains SNV without ID should fail
#  Scenario: SNV with Hotspot Oncomine Variant Class value should pass
#  Scenario Outline: SNV with non-Hotspot Oncomine Variant Class value should pass
#    Examples:
#  Scenario Outline: SNV with non-snv type value should fail
#    Examples: