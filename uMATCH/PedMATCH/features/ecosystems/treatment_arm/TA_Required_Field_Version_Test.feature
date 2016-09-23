#encoding: utf-8
@treatment_arm
Feature: Treatment Arm API Tests that focus on "version" field

  Scenario: TA_VS10. Update Treatment Arm with same "version" value should not be taken
    Given template treatment arm json with an id: "APEC1621-VS10-1", stratum_id: "stratum100" and version: "2016-06-03"
    And set template treatment arm json field: "gene" to value: "EGFR" in type: "string"
    When creating a new treatment arm using post request
    Then a success message is returned
    Then wait for processor to complete request in "10" seconds
    Then set template treatment arm json field: "gene" to value: "xxyyyy" in type: "string"
    When creating a new treatment arm using post request
    Then a success message is returned
    Then wait for processor to complete request in "10" seconds
    Then retrieve the posted treatment arm from API
    Then the returned treatment arm has value: "EGFR" in field: "gene"


