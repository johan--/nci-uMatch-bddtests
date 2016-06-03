#encoding: utf-8

@treatment_arm
Feature: Treatment Arm API Tests that focus on "treatmentArmDrugs" and "exclusionDrugs" field
  Scenario: New Treatment Arm with empty "treatmentArmDrugs" field should fail
    Given template json with a new unique id
    And clear list field: "treatmentArmDrugs" from template json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario: New Treatment Arm with "treatmentArmDrugs": null should fail
    Given template json with a new unique id
    And set template json field: "treatmentArmDrugs" to string value: "null"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario: New Treatment Arm without "treatmentArmDrugs" field should fail
    Given template json with a new unique id
    And remove field: "treatmentArmDrugs" from template json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario: New Treatment Arm with duplicated drug entities should fail (or duplicated entities should be ignored)
    Given template json with a new unique id
    And clear list field: "treatmentArmDrugs" from template json
    And add drug with name: "AZD9291" pathway: "EGFR" and id: "781254" to template json
    And add drug with name: "AZD9291" pathway: "EGFR" and id: "781254" to template json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed."

  Scenario: New Treatment Arm with same drug in both "treatmentArmDrugs" and "exclusionDrugs" field should fail
    Given template json with a new unique id
    And clear list field: "treatmentArmDrugs" from template json
    And clear list field: "exclusionDrugs" from template json
    And add drug with name: "AZD9291" pathway: "EGFR" and id: "781254" to template json
    And add exclusion drug with name: "AZD9291" and id: "781254" to template json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed."

  Scenario Outline: New Treatment Arm with uncompleted drug entity should fail
    Given template json with a new unique id
    And clear list field: "treatmentArmDrugs" from template json
    And add drug with name: "<drugName>" pathway: "<drugPathway>" and id: "<drugId>" to template json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed."
    Examples:
    |drugName       |drugPathway        |drugId         |
    |AZD9291        |EGFR               |null           |
    |AZD9291        |null               |781254         |
    |null           |EGFR               |781254         |
    |null           |null               |null           |
  
  
  Scenario: Update Treatment Arm with empty "treatmentArmDrugs" field should fail
    Given template json with a new unique id
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "version" to string value: "2016-06-03"
    And clear list field: "treatmentArmDrugs" from template json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario: Update Treatment Arm with "treatmentArmDrugs": null should fail
    Given template json with a new unique id
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "version" to string value: "2016-06-03"
    And set template json field: "treatmentArmDrugs" to string value: "null"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario: Update Treatment Arm without "treatmentArmDrugs" field should fail
    Given template json with a new unique id
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then set template json field: "version" to string value: "2016-06-03"
    And remove field: "treatmentArmDrugs" from template json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario: Update Treatment Arm with duplicated drug entities should fail (or duplicated entities should be ignored)
    Given template json with a new unique id
    And set template json field: "version" to string value: "2010-01-01"
    And clear list field: "treatmentArmDrugs" from template json
    And add drug with name: "AZD9291" pathway: "EGFR" and id: "781254" to template json
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    And set template json field: "version" to string value: "2016-06-03"
    Then add drug with name: "AZD9291" pathway: "EGFR" and id: "781254" to template json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed."

  Scenario Outline: Update Treatment Arm with uncompleted drug entity should fail
    Given template json with a new unique id
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    And add drug with name: "<drugName>" pathway: "<drugPathway>" and id: "<drugId>" to template json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed."
    Examples:
    |drugName       |drugPathway        |drugId         |
    |AZD9291        |EGFR               |null           |
    |AZD9291        |null               |781254         |
    |null           |EGFR               |781254         |
    |null           |null               |null           |

#  Scenario: Update Treatment Arm with same drug in both "treatmentArmDrugs" and "exclusionDrugs" field should fail
#  Scenario: Update Treatment Arm with extended "treatmentArmDrugs" list should pass
#  Scenario: Update Treatment Arm with shortened "treatmentArmDrugs" list should pass
#  Scenario: Update Treatment Arm with replaced "treatmentArmDrugs" list should pass
#  Scenario Outline: Unrelated fields in "treatmentArmDrugs" should be ignored
#  Scenario Outline: Unrelated fields in drug entity should be ignored