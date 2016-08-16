#encoding: utf-8
@patients @patients_reg
Feature: Register a new patient in PEDMatchbox:
  Scenario: PT_RG01. New patient can be registered successfully
    Given template patient registration message for patient: "PT_RG01_New" on date: "2016-08-16T14:52:58.000+00:00"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "10" seconds
    Then retrieve patient: "PT_RG01_New" from API
    Then returned patient has value: "2016-08-16T14:52:58.000+00:00" in field: "registration_date"
    Then returned patient has value: "REGISTRATION" in field: "current_status"
    Then returned patient has value: "APEC1621" in field: "study_id"
    Then returned patient has value: "1.0" in field: "current_step_number"
    Then returned patient has value: "PT_RG01_New" in field: "patient_id"

  Scenario Outline: PT_RG02. patient registration with invalid patient_id should fail
    Given template patient registration message for patient: "<patient_id>" on date: "current"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
    |patient_id             |message                                                                      |
    |                       |was not of a minimum string length of 1                                      |
    |null                   |NilClass did not match the following type: string                            |
    |PT_RG02_ExistingPatient|This patient has already been registered and cannot be registered again      |


  Scenario Outline: PT_RG03. patient registration with study_id which is not 'APEC1621' should fail
    Given template patient registration message for patient: "<patient_id>" on date: "current"
    Then set patient message field: "study_id" to value: "<study_id>"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |patient_id               |study_id           |message                                                      |
      |PT_RG03_EmptyStudyID     |                   |was not of a minimum string length of 1                      |
      |PT_RG03_NullStudyID      |null               |NilClass did not match the following type: string            |
      |PT_RG03_OtherStudyID     |Other              |APEC1621                                                     |
      |PT_RG03_WrongCaseStudyID |Apec1621           |APEC1621                                                     |
      |PT_RG03_GoodIDPlusBad    |APEC1621x1         |APEC1621                                                     |

   Scenario Outline: PT_RG04. patient registration with invalid step_number should fail
     Given template patient registration message for patient: "<patient_id>" on date: "current"
     Then set patient message field: "step_number" to value: "<step_number>"
     When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
     Examples:
       |patient_id               |step_number        |message                                                 |
       |PT_RG04_EmptyStpNum      |                   |was not of a minimum string length of 1                 |
       |PT_RG04_NullStpNum       |null               |NilClass did not match the following type: string       |
       |PT_RG04_StringStpNum     |Other              |1.0                                                     |
       |PT_RG04_WrongStpNum1     |1.1                |1.0                                                     |
       |PT_RG04_WrongStpNum2     |2.0                |1.0                                                     |
       |PT_RG04_WrongStpNum3     |8.0                |1.0                                                     |
       |PT_RG04_WrongStpNum4     |1.5                |1.0                                                     |

  Scenario Outline: PT_RG05. patient registration with invalid registration_date should fail
    Given template patient registration message for patient: "<patient_id>" on date: "<registration_date>"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |patient_id             |registration_date        |message                                                 |
      |PT_RG05_EmptyDate      |                         |was not of a minimum string length of 1                 |
      |PT_RG05_NullDate       |null                     |NilClass did not match the following type: string       |
      |PT_RG05_StringDate     |Other                    |not a date                                              |
      |PT_RG05_FutureDate     |future                   |future                                                  |
      |PT_RG05_TimeStampDate  |1471360795               |not a date                                              |