#encoding: utf-8

@treatment_arm
Feature: TA_OS. Treatment Arm API Tests that focus on treatment arm api service other than /treatmentArms and /newTreatmentArm

  @treatment_arm_p2
  Scenario: TA_OS1. basic version of treatment arm only return one record for active treatment arm that has multiple versions
    Given template treatment arm json with an id: "APEC1621-OS1-1", stratum_id: "STRATUM1" and version: "version1"
    When creating a new treatment arm using post request
    Then a success message is returned
    Then wait for processor to complete request in "10" attempts
    Then set the version of the treatment arm to "version2"
    When creating a new treatment arm using post request
    Then a success message is returned
    Then wait for processor to complete request in "10" attempts
    Then set the version of the treatment arm to "version3"
    When creating a new treatment arm using post request
    Then a success message is returned
    Then wait for processor to complete request in "10" attempts
    Then set the version of the treatment arm to "version4"
    When creating a new treatment arm using post request
    Then a success message is returned
    Then wait for processor to complete request in "10" attempts
    When calling uploaded treatment arm with basic "true" and active "true"
    Then should return "1" of the records
    And the returned treatment arm has "version4" as the version
    When calling uploaded treatment arm with basic "true" and active "false"
    Then should return "3" of the records
    When calling uploaded treatment arm with basic "true" and active "null"
    Then should return "4" of the records

  @treatment_arm_p2
  Scenario: TA_OS2. every result from /basicTreatmentArms should exist in /treatmentArms
    Given retrieve all treatment arms from /treatmentArms
    Then retrieve basic list of treatment arms
    Then every result from basic treatment arms should exist in regular call

  @treatment_arm_p2
  Scenario: TA_OS3. /treatmentArm/id/stratum_id returns all the versions of the treatment arm in reverse chronological order.
    Given template treatment arm json with an id: "APEC1621-OS7-1", stratum_id: "STRATUM1" and version: "2016-06-03"
    Then creating a new treatment arm using post request
    Then a success message is returned
    Then wait for processor to complete request in "10" attempts
    Then template treatment arm json with an id: "APEC1621-OS7-1", stratum_id: "STRATUM1" and version: "2016-06-15"
    Then creating a new treatment arm using post request
    Then a success message is returned
    Then wait for processor to complete request in "10" attempts
    Then retrieve treatment arms with id: "APEC1621-OS7-1" and stratum_id: "STRATUM1" from API
    Then the first returned treatment arm has value: "APEC1621-OS7-1" in field: "treatment_arm_id"
    Then the first returned treatment arm has value: "STRATUM1" in field: "stratum_id"
    Then the first returned treatment arm has value: "2016-06-15" in field: "version"