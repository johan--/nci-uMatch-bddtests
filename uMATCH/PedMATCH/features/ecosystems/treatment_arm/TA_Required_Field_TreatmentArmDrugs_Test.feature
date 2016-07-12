#encoding: utf-8

@treatment_arm
Feature: Treatment Arm API Tests that focus on "treatmentArmDrugs" and "exclusionDrugs" field
  Scenario: TA_DG1. New Treatment Arm with empty "treatmentArmDrugs" field should fail
    Given template treatment arm json with a random id
    And clear list field: "treatmentArmDrugs" from template treatment arm json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario: TA_DG2. New Treatment Arm with "treatmentArmDrugs": null should fail
    Given template treatment arm json with a random id
    And set template treatment arm json field: "treatmentArmDrugs" to string value: "null"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "The property '#/treatment_arm_drugs' of type NilClass did not match the following type: array"

  Scenario: TA_DG3. New Treatment Arm without "treatmentArmDrugs" field should fail
    Given template treatment arm json with a random id
    And remove field: "treatmentArmDrugs" from template treatment arm json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "The property '#/' did not contain a required property of 'treatment_arm_drugs'"

  Scenario: TA_DG4. New Treatment Arm with duplicated drug entities should be ignored
    Given template treatment arm json with an id: "APEC1621-DG4-1"
    And clear list field: "treatmentArmDrugs" from template treatment arm json
    And add drug with name: "AZD9291" pathway: "EGFR" and id: "781254" to template treatment arm json
    And add drug with name: "AZD9291" pathway: "EGFR" and id: "781254" to template treatment arm json
    When posted to MATCH newTreatmentArm
    Then retrieve the posted treatment arm from API
    Then the returned treatment arm has "1" drug (name:"AZD9291" pathway: "EGFR" and id: "781254")

  Scenario: TA_DG5. New Treatment Arm with same drug in both "treatmentArmDrugs" and "exclusionDrugs" field should fail
    Given template treatment arm json with a random id
    And clear list field: "treatmentArmDrugs" from template treatment arm json
    And clear list field: "exclusionDrugs" from template treatment arm json
    And add drug with name: "AZD9291" pathway: "EGFR" and id: "781254" to template treatment arm json
    And add PedMATCH exclusion drug with name: "AZD9291" and id: "781254" to template treatment arm json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed."

  Scenario Outline: TA_DG6. New Treatment Arm with uncompleted drug entity should fail
    Given template treatment arm json with a random id
    And clear list field: "treatmentArmDrugs" from template treatment arm json
    And add drug with name: "<drugName>" pathway: "<drugPathway>" and id: "<drugId>" to template treatment arm json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed."
    Examples:
    |drugName       |drugPathway        |drugId         |
    |AZD9291        |EGFR               |null           |
    |AZD9291        |null               |781254         |
    |null           |EGFR               |781254         |
    |null           |null               |null           |
  
  
#  Scenario: TA_DG7. Update Treatment Arm with empty "treatmentArmDrugs" field should fail
#    Given template treatment arm json with a random id
#    When posted to MATCH newTreatmentArm
#    Then success message is returned:
#    Then set template treatment arm json field: "version" to string value: "2016-06-03"
#    And clear list field: "treatmentArmDrugs" from template treatment arm json
#    When posted to MATCH newTreatmentArm
#    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"
#
#  Scenario: TA_DG8. Update Treatment Arm with "treatmentArmDrugs": null should fail
#    Given template treatment arm json with a random id
#    When posted to MATCH newTreatmentArm
#    Then success message is returned:
#    Then set template treatment arm json field: "version" to string value: "2016-06-03"
#    And set template treatment arm json field: "treatmentArmDrugs" to string value: "null"
#    When posted to MATCH newTreatmentArm
#    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"
#
#  Scenario: TA_DG9. Update Treatment Arm without "treatmentArmDrugs" field should fail
#    Given template treatment arm json with a random id
#    When posted to MATCH newTreatmentArm
#    Then success message is returned:
#    Then set template treatment arm json field: "version" to string value: "2016-06-03"
#    And remove field: "treatmentArmDrugs" from template treatment arm json
#    When posted to MATCH newTreatmentArm
#    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

#  Scenario: TA_DG10. Update Treatment Arm with duplicated drug entities should be ignored
#    Given template treatment arm json with an id: "APEC1621-DG10-1" and version: "2015-03-25"
#    And clear list field: "treatmentArmDrugs" from template treatment arm json
#    And add drug with name: "AZD9291" pathway: "EGFR" and id: "781254" to template treatment arm json
#    When posted to MATCH newTreatmentArm
#    Then success message is returned:
#    And set template treatment arm json field: "version" to string value: "2016-06-03"
#    Then add drug with name: "AZD9291" pathway: "EGFR" and id: "781254" to template treatment arm json
#    When posted to MATCH newTreatmentArm
#    Then the treatment arm with id: "APEC1621-DG10-1" and version: "2016-06-03" return from API has "1" drug (name:"AZD9291" pathway: "EGFR" and id: "781254")

#  Scenario Outline: TA_DG11. Update Treatment Arm with uncompleted drug entity should fail
#    Given template treatment arm json with an id: "APEC1621-DG11-1" and version: "2015-03-25"
#    When posted to MATCH newTreatmentArm
#    Then success message is returned:
#    And set template treatment arm json field: "version" to string value: "2016-06-03"
#    And add drug with name: "<drugName>" pathway: "<drugPathway>" and id: "<drugId>" to template treatment arm json
#    When posted to MATCH newTreatmentArm
#    Then a failure message is returned which contains: "Validation failed."
#    Examples:
#    |drugName       |drugPathway        |drugId         |
#    |AZD9291        |EGFR               |null           |
#    |AZD9291        |null               |781254         |
#    |null           |EGFR               |781254         |
#    |null           |null               |null           |

#  Scenario: TA_DG12. Update Treatment Arm with add same drug from "treatmentArmDrugs" to "exclusionDrugs" field should fail
#    Given template treatment arm json with an id: "APEC1621-DG12-1" and version: "2015-03-25"
#    And clear list field: "treatmentArmDrugs" from template treatment arm json
#    And clear list field: "exclusionDrugs" from template treatment arm json
#    And add drug with name: "AZD9291" pathway: "EGFR" and id: "781254" to template treatment arm json
#    When posted to MATCH newTreatmentArm
#    Then success message is returned:
#    Then set template treatment arm json field: "version" to string value: "2016-06-03"
#    And add PedMATCH exclusion drug with name: "AZD9291" and id: "781254" to template treatment arm json
#    When posted to MATCH newTreatmentArm
#    Then a failure message is returned which contains: "Validation failed."
#
#  Scenario: TA_DG13. Update Treatment Arm with add same drug from "exclusionDrugs" to "treatmentArmDrugs" field should fail
#    Given template treatment arm json with an id: "APEC1621-DG12-1" and version: "2015-03-25"
#    And clear list field: "treatmentArmDrugs" from template treatment arm json
#    And clear list field: "exclusionDrugs" from template treatment arm json
#    And add PedMATCH exclusion drug with name: "AZD9291" and id: "781254" to template treatment arm json
#    When posted to MATCH newTreatmentArm
#    Then success message is returned:
#    Then set template treatment arm json field: "version" to string value: "2016-06-03"
#    And add drug with name: "AZD9291" pathway: "EGFR" and id: "781254" to template treatment arm json
#    When posted to MATCH newTreatmentArm
#    Then a failure message is returned which contains: "Validation failed."
