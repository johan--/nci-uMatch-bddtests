#encoding: utf-8

@treatment_arm
Feature: Treatment Arm API Tests that focus on treatment arm api service other than /treatmentArms and /newTreatmentArm

  Scenario: TA_OS1. basic version of treatment arm only return one record for active treatment arm that has multiple versions
    Given template treatment arm json with an id: "APEC1621-OS1-1", stratum_id: "STRATUM1" and version: "version1"
    When creating a new treatment arm using post request
    Then a success message is returned
    Then wait for "5" seconds
    Then set the version of the treatment arm to "version2"
    When updating an existing treatment arm using put request
    Then a success message is returned
    Then wait for "5" seconds
    Then set the version of the treatment arm to "version3"
    When updating an existing treatment arm using put request
    Then a success message is returned
    Then wait for "5" seconds
    Then set the version of the treatment arm to "version4"
    When updating an existing treatment arm using put request
    Then a success message is returned
    When calling with basic "true" and active "true"
    Then should return "1" of the records
    When calling with basic "true" and active "false"
    Then should return "3" of the records
    When calling with basic "true" and active "null"
    Then should return "4" of the records

  Scenario: TA_OS5. every result from /basicTreatmentArms should exist in /treatmentArms
    Given retrieve all treatment arms from /treatmentArms
    Then retrieve basic list of treatment arms
    Then every result from basic treatment arms should exist in regular call

  Scenario: TA_OS7. /treatmentArm/id/stratum_id returns all the versions of the treatment arm in reverse chronological order.
    Given template treatment arm json with an id: "APEC1621-OS7-1", stratum_id: "STRATUM1" and version: "2016-06-03"
    Then creating a new treatment arm using post request
    Then a success message is returned
    Then wait for "5" seconds
    Then template treatment arm json with an id: "APEC1621-OS7-1", stratum_id: "STRATUM1" and version: "2016-06-15"
    Then creating a new treatment arm using post request
    Then a success message is returned
    Then wait for "5" seconds
    Then template treatment arm json with an id: "APEC1621-OS7-1", stratum_id: "STRATUM2" and version: "2016-06-15"
    Then creating a new treatment arm using post request
    Then a success message is returned
    Then retrieve treatment arms with id: "APEC1621-OS7-1" and stratum_id: "STRATUM1" from API
    Then the first returned treatment arm has value: "APEC1621-OS7-1" in field: "id"
    Then the first returned treatment arm has value: "STRATUM1" in field: "stratum_id"
    Then the first returned treatment arm has value: "2016-06-15" in field: "version"