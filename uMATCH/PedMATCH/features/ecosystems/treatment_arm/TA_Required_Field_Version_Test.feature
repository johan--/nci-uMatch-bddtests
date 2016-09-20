#encoding: utf-8
@treatment_arm
Feature: Treatment Arm API Tests that focus on "version" field

  Scenario: TA_VS10. Update Treatment Arm with same "version" value should not be taken
    Given template treatment arm json with an id: "APEC1621-VS10-1", stratum_id: "STRATUM1" and version: "2016-06-03"
    And set template treatment arm json field: "gene" to value: "EGFR" in type: "string"
    When creating a new treatment arm using post request
    Then a success message is returned
    Then wait for "5" seconds
    Then set template treatment arm json field: "gene" to value: "xxyyyy" in type: "string"
    When creating a new treatment arm using post request
    Then a success message is returned
    Then retrieve the posted treatment arm from API
    Then the returned treatment arm has value: "EGFR" in field: "gene"

  Scenario: TA_VS11. Multiple versions of one treatment arm id should return in dateCreated descending order
    Given template treatment arm json with an id: "APEC1621-VS11-1", stratum_id: "STRATUM1" and version: "2016-06-03"
    When creating a new treatment arm using post request
    Then a success message is returned
    Then wait for "5" seconds
    Then set the version of the treatment arm to "2005-01-24"
    When creating a new treatment arm using post request
    Then a success message is returned
    Then wait for "5" seconds
    Then set the version of the treatment arm to "APEC1621_V000"
    When creating a new treatment arm using post request
    Then a success message is returned
    Then wait for "5" seconds
    Then set the version of the treatment arm to "24.6"
    When creating a new treatment arm using post request
    Then a success message is returned
    Then retrieve treatment arms with id: "APEC1621-VS11-1" and stratum_id: "STRATUM1" from API
    Then the treatment arm with version: "2016-06-03" is in the place: "4" of returned treatment arm list
    Then the treatment arm with version: "2005-01-24" is in the place: "3" of returned treatment arm list
    Then the treatment arm with version: "APEC1621_V000" is in the place: "2" of returned treatment arm list
    Then the treatment arm with version: "24.6" is in the place: "1" of returned treatment arm list



