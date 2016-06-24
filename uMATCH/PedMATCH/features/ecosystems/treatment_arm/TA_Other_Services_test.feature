#encoding: utf-8

@Treatment_Arm_API_Tests
Feature: Treatment Arm API Tests that focus on treatment arm api service other than /treatmentArms and /newTreatmentArm
  Scenario: TA_OS1. /basicTreatmentArms only return one record for a treatment arm that has multiple versions
    Given template json with an id: "APEC1621-OS12-1" and version: "version1"
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
    Then There are "1" treatment arm with id: "APEC1621-OS12-1" return from API /basicTreatmentArms