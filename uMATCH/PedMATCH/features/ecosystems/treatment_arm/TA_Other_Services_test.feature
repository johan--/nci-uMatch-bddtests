#encoding: utf-8

@Treatment_Arm_API_Tests
Feature: Treatment Arm API Tests that focus on treatment arm api service other than /treatmentArms and /newTreatmentArm
  #the only one that return from /basicTreatmentArms should be the latest version, for example if latest version has different status, check it
  Scenario: TA_OS1. /basicTreatmentArms only return one record for a treatment arm that has multiple versions
    Given template json with an id: "APEC1621-OS1-1", stratum_id: "STRATUM1" and version: "version1"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then wait for "5" seconds
    Then set template json field: "version" to string value: "version2"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then wait for "5" seconds
    Then set template json field: "version" to string value: "version3"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then wait for "5" seconds
    Then set template json field: "version" to string value: "version4"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then There are "1" treatment arm with id: "APEC1621-OS1-1" and stratum_id: "STRATUM1" return from API /basicTreatmentArms

  Scenario: TA_OS2. /basicTreatmentArms return treatment arm with correct data
    Given template json with an id: "APEC1621-OS2-1", stratum_id: "STRATUM1" and version: "2016-06-03"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm return from /basciTreatmentArms has correct values, name: "APEC1621-OS2-1" and status: "OPEN"


    #more fields should have values in basicTreatmentArms result, including statusLog, stratum_id
  Scenario: TA_OS3. /basicTreatmentArms/id return treatment arm with correct data
    Given template json with an id: "APEC1621-OS3-1", stratum_id: "STRATUM1" and version: "2016-06-03"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm return from /basciTreatmentArms/id has correct values, name: "APEC1621-OS3-1" and status: "OPEN"

#  Scenario: TA_OS4. /basicTreatmentArms returns ONE treatment arm for EVERY combination of id-stratumID
