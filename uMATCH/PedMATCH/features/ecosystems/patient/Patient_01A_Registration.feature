#encoding: utf-8
@patients_reg
Feature: Register a new patient in PEDMatchbox:

  @patients_p1
  Scenario: PT_RG01. New patient can be registered successfully
    Given template patient registration message for patient: "PT_RG01_Newa" on date: "2016-08-16T14:52:58.000+00:00"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient field: "current_status" should have value: "REGISTRATION" within 10 seconds
    And patient field: "registration_date" should have value: "2016-08-16T14:52:58+00:00" within 10 seconds
    And patient field: "study_id" should have value: "APEC1621" within 10 seconds
    And patient field: "current_step_number" should have value: "1.0" within 10 seconds
    And patient field: "patient_id" should have value: "PT_RG01_Newa" within 10 seconds

  @patients_p2
  Scenario: PT_RG02. patient registration with invalid patient_id should fail
    Given template patient registration message for patient: "PT_RG02_ExistingPatient" on date: "current"
    When POST to MATCH patients service, response includes "already been registered" with code "403"

  @patients_p2
  Scenario Outline: PT_RG03. patient registration with invalid study_id
    Given template patient registration message for patient: "<patient_id>" on date: "current"
    Then set patient message field: "study_id" to value: "<study_id>"
    When POST to MATCH patients service, response includes "<message>" with code "403"
    Examples:
      | patient_id               | study_id   | message              |
      | PT_RG03_EmptyStudyID     |            | can't be blank       |
      | PT_RG03_NullStudyID      | null       | can't be blank       |
      | PT_RG03_OtherStudyID     | Other      | not a valid study_id |
      | PT_RG03_WrongCaseStudyID | Apec1621   | not a valid study_id |
      | PT_RG03_GoodIDPlusBad    | APEC1621x1 | not a valid study_id |

  @patients_p3
  Scenario Outline: PT_RG04. patient registration with invalid step_number should fail
    Given template patient registration message for patient: "<patient_id>" on date: "current"
    Then set patient message field: "step_number" to value: "<step_number>"
    When POST to MATCH patients service, response includes "<message>" with code "403"
    Examples:
      | patient_id           | step_number | message        |
      | PT_RG04_EmptyStpNum  |             | can't be blank |
      | PT_RG04_NullStpNum   | null        | can't be blank |
      | PT_RG04_StringStpNum | Other       | 1.0            |
      | PT_RG04_WrongStpNum1 | 1.1         | 1.0            |
      | PT_RG04_WrongStpNum2 | 2.0         | 1.0            |
      | PT_RG04_WrongStpNum3 | 8.0         | 1.0            |
      | PT_RG04_WrongStpNum4 | 1.5         | 1.0            |

  @patients_p2
  Scenario Outline: PT_RG05. patient registration with invalid status_date should fail
    Given template patient registration message for patient: "<patient_id>" on date: "<status_date>"
    When POST to MATCH patients service, response includes "<message>" with code "403"
    Examples:
      | patient_id            | status_date | message        |
      | PT_RG05_EmptyDate     |             | can't be blank |
      | PT_RG05_NullDate      | null        | can't be blank |
      | PT_RG05_StringDate    | Other       | invalid date   |
      | PT_RG05_FutureDate    | future      | current date   |
      | PT_RG05_TimeStampDate | 1471360795  | invalid date   |

  @patients_p3
  Scenario: PT_RG06. extra key-value pair in the message body should NOT fail
    Given template patient registration message for patient: "PT_RG06" on date: "current"
    Then set patient message field: "extra_info" to value: "This is extra information"
    When POST to MATCH patients service, response includes "successfully" with code "202"
