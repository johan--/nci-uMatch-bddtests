#encoding: utf-8

@treatment_arm
Feature: Treatment Arm API Tests that focus on "treatment_arm_drugs" and "exclusion_drugs" field
  @treatment_arm_p2
  Scenario: TA_DG1. New Treatment Arm with empty "treatment_arm_drugs" field should fail
    Given template treatment arm json with a random id
    And clear list field: "treatment_arm_drugs" from template treatment arm json
    When creating a new treatment arm using post request
#    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"
    Then a failure message is returned which contains: "The property '#/treatment_arm_drugs' did not contain a minimum number of items 1"

  @treatment_arm_p2
  Scenario: TA_DG2. New Treatment Arm with "treatment_arm_drugs": null should fail
    Given template treatment arm json with a random id
    And set template treatment arm json field: "treatment_arm_drugs" to string value: "null"
    When creating a new treatment arm using post request
    Then a failure message is returned which contains: "The property '#/treatment_arm_drugs' of type NilClass did not match the following type: array"

  @treatment_arm_p2
  Scenario: TA_DG3. New Treatment Arm without "treatment_arm_drugs" field should fail
    Given template treatment arm json with a random id
    And remove field: "treatment_arm_drugs" from template treatment arm json
    When creating a new treatment arm using post request
    Then a failure message is returned which contains: "The property '#/' did not contain a required property of 'treatment_arm_drugs'"

  @treatment_arm_p2
  Scenario: TA_DG4. New Treatment Arm with duplicated drug entities should fail
    Given template treatment arm json with an id: "APEC1621-DG4-1"
    And clear list field: "treatment_arm_drugs" from template treatment arm json
    And add drug with name: "AZD9291" pathway: "EGFR" and id: "781254" to template treatment arm json
    And add drug with name: "AZD9291" pathway: "EGFR" and id: "781254" to template treatment arm json
    When creating a new treatment arm using post request
    Then a failure response code of "500" is returned

  @treatment_arm_p2
  Scenario: TA_DG5. New Treatment Arm with same drug in both "treatment_arm_drugs" and "exclusion_drugs" field should pass
    Given template treatment arm json with a random id
    And clear list field: "treatment_arm_drugs" from template treatment arm json
    And clear list field: "exclusion_drugs" from template treatment arm json
    And add drug with name: "AZD9291" pathway: "EGFR" and id: "781254" to template treatment arm json
    And add PedMATCH exclusion drug with name: "AZD9291" and id: "781254" to template treatment arm json
    When creating a new treatment arm using post request
    Then a success message is returned

  @treatment_arm_p2
  Scenario Outline: TA_DG6. New Treatment Arm with incomplete drug entity should fail
    Given template treatment arm json with a random id
    And clear list field: "treatment_arm_drugs" from template treatment arm json
    And add drug with name: "<drugName>" pathway: "<drugPathway>" and id: "<drugId>" to template treatment arm json
    When creating a new treatment arm using post request
    Then a failure message is returned which contains: "<validation_message>"
    Examples:
    |drugName       |drugPathway |drugId  | validation_message        |
    |AZD9291        |EGFR        |null    | drug_id' of type NilClass |
    |null           |EGFR        |781254  | name' of type NilClass    |

  @treatment_arm_p2
  Scenario Outline: TA_DG7 New Treatment Arm with null or empty drug pathway should pass
    Given template treatment arm json with a random id
    And clear list field: "treatment_arm_drugs" from template treatment arm json
    And add drug with name: "AZD9291" pathway: "<drug_pathway>" and id: "781254" to template treatment arm json
    When creating a new treatment arm using post request
    Then a success message is returned
    Examples:
    | drug_pathway |
    | null         |
    |              |