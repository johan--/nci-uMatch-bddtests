#encoding: utf-8

@treatment_arm
Feature: Treatment Arm API Tests that focus on treatment arm api service other than /treatmentArms and /newTreatmentArm

  Scenario: TA_OS1. basic version of treatment arm only return one record for active treatment arm that has multiple versions
    Given template treatment arm json with an id: "APEC1621-OS1-1", stratum_id: "STRATUM1" and version: "version1"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then wait for "5" seconds
    Then set the version of the treatment arm to "version2"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then wait for "5" seconds
    Then set the version of the treatment arm to "version3"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then wait for "5" seconds
    Then set the version of the treatment arm to "version4"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    When calling with basic "true" and active "true"
    Then should return "1" of the records
    When calling with basic "true" and active "false"
    Then should return "3" of the records
    When calling with basic "true" and active "null"
    Then should return "4" of the records


  Scenario: TA_OS2. basic version of treatment arm return treatment arm with correct data
    Given template treatment arm json with an id: "APEC1621-OS2-1", stratum_id: "STRATUM1" and version: "2016-06-03"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then treatment arm return from basic treatment arms has correct status: "OPEN"


    #more fields should have values in basicTreatmentArms result, including statusLog,
  Scenario: TA_OS3. /basicTreatmentArms/id return treatment arm with correct data
    Given template treatment arm json with an id: "APEC1621-OS3-1", stratum_id: "STRATUM1" and version: "2016-06-03"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm return from /basciTreatmentArms/id has correct values, name: "APEC1621-OS3-1" and status: "OPEN"

  Scenario: TA_OS4. /basicTreatmentArms returns ONE treatment arm for EVERY combination of id-stratumID
    Given retrieve all treatment arms from /treatmentArms
    Then retrieve all basic treatment arms from /basicTreatmentArms
    Then every id-stratumID combination from /treatmentArms should have "1" result in /basicTreatmentArms

  Scenario: TA_OS5. every result from /basicTreatmentArms should exist in /treatmentArms
    Given retrieve all treatment arms from /treatmentArms
    Then retrieve all basic treatment arms from /basicTreatmentArms
    Then every result from /basicTreatmentArms should exist in /treatmentArms

  Scenario: TA_OS7. /treatmentArm/id/stratum_id returns all the versions of the treatment arm in reverse chronological order.
    Given template treatment arm json with an id: "APEC1621-OS7-1", stratum_id: "STRATUM1" and version: "2016-06-03"
    Then posted to MATCH newTreatmentArm
    Then success message is returned:
    Then wait for "5" seconds
    Then template treatment arm json with an id: "APEC1621-OS7-1", stratum_id: "STRATUM1" and version: "2016-06-15"
    Then posted to MATCH newTreatmentArm
    Then success message is returned:
    Then wait for "5" seconds
    Then template treatment arm json with an id: "APEC1621-OS7-1", stratum_id: "STRATUM2" and version: "2016-06-15"
    Then posted to MATCH newTreatmentArm
    Then success message is returned:
    Then retrieve all treatment arms from /treatmentArms
    Then the returned treatment arm has value: "APEC1621-OS7-1" in field: "name"
    Then the returned treatment arm has value: "STRATUM1" in field: "stratum_id"
    Then the returned treatment arm has value: "2016-06-15" in field: "version"