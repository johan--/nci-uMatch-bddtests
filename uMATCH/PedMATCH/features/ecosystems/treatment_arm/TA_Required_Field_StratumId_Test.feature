#encoding: utf-8
  
@treatment_arm

Feature: Treatment Arm API Tests that focus on "stratumId" field
  
  Scenario Outline: TA_SI1. Treatment arm with empty or null stratumID should fail
    Given template treatment arm json with an id: "APEC1621-SI1-1", stratum_id: "<stratumID>" and version: "2016-06-03"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "<error>"
    Examples: 
    |stratumID        |error                                                                                      |
    |null             |The property '#/stratum_id' of type NilClass did not match the following type: string      |
    |                 |Validation failed.  Please check all required fields are present                           |
    
  Scenario: TA_SI2. Treatment arm without stratumID field should fail
    Given template treatment arm json with an id: "APEC1621-SI2-1", stratum_id: "straID" and version: "2016-06-03"
    Then remove field: "stratumId" from template treatment arm json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "The property '#/' did not contain a required property of 'stratum_id'"


  Scenario: TA_SI3. treatmentArms/:id/:stratum_id service doesn't return treatment arms that have same id but different stratum_id
    Given template treatment arm json with an id: "APEC1621-SI3-1", stratum_id: "STRATUM1" and version: "2016-06-03"
    Then posted to MATCH newTreatmentArm
    Then success message is returned:
    Then wait for "5" seconds
    Then template treatment arm json with an id: "APEC1621-SI3-1", stratum_id: "STRATUM1" and version: "2016-06-15"
    Then posted to MATCH newTreatmentArm
    Then success message is returned:
    Then wait for "5" seconds
    Then template treatment arm json with an id: "APEC1621-SI3-1", stratum_id: "STRATUM2" and version: "2016-06-15"
    Then posted to MATCH newTreatmentArm
    Then success message is returned:
    Then retrieve treatment arms with id: "APEC1621-SI3-1" and stratum_id: "STRATUM1" from API
    Then there are "2" treatment arms in returned list
    Then retrieve treatment arms with id: "APEC1621-SI3-1" and stratum_id: "STRATUM2" from API
    Then there are "1" treatment arms in returned list


  Scenario: TA_SI4. treatmentArms/:id/:stratum_id service doesn't return treatment arms that have same stratum_id but different id
    Given template treatment arm json with an id: "APEC1621-SI4-1", stratum_id: "STRATUM1" and version: "2016-06-03"
    Then posted to MATCH newTreatmentArm
    Then success message is returned:
    Then wait for "5" seconds
    Then template treatment arm json with an id: "APEC1621-SI4-1", stratum_id: "STRATUM1" and version: "2016-06-15"
    Then posted to MATCH newTreatmentArm
    Then success message is returned:
    Then wait for "5" seconds
    Then template treatment arm json with an id: "APEC1621-SI4-2", stratum_id: "STRATUM1" and version: "2016-06-15"
    Then posted to MATCH newTreatmentArm
    Then success message is returned:
    Then retrieve treatment arms with id: "APEC1621-SI4-1" and stratum_id: "STRATUM1" from API
    Then there are "2" treatment arms in returned list
    Then retrieve treatment arms with id: "APEC1621-SI4-2" and stratum_id: "STRATUM1" from API
    Then there are "1" treatment arms in returned list

  Scenario: TA_SI5. treatmentArms/:id service should return all treatment arms with same id but different stratum_id
    Given template treatment arm json with an id: "APEC1621-SI5-1", stratum_id: "STRATUM1" and version: "2016-06-03"
    Then posted to MATCH newTreatmentArm
    Then success message is returned:
    Then wait for "5" seconds
    Then template treatment arm json with an id: "APEC1621-SI5-1", stratum_id: "STRATUM1" and version: "2016-06-15"
    Then posted to MATCH newTreatmentArm
    Then success message is returned:
    Then wait for "5" seconds
    Then template treatment arm json with an id: "APEC1621-SI5-1", stratum_id: "STRATUM2" and version: "2016-06-15"
    Then posted to MATCH newTreatmentArm
    Then success message is returned:
    Then retrieve treatment arms with id: "APEC1621-SI5-1" from API
    Then there are "3" treatment arms in returned list
  