#encoding: utf-8
#@patients
@pathology
Feature: Pathology Messages

  Scenario Outline: PT_PR01. Pathology report with invalid patient_id(empty, non-existing, null) should fail
    Given template pathology report with surgical_event_id: "SEI_01" for patient: "<value>"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |value     |message                                               |
      |          |was not of a minimum string length of 1               |
      |nonPatient|not existing                                          |
      |null      |type NilClass did not match the following type: string|

    #!!!!!!!!!!!!!!! study_id has been taken off from pathology message
#  Scenario Outline: PT_PR02. Pathology report with invalid study_id(empty, non-existing, null) should fail
#    Given template pathology report with surgical_event_id: "SEI_01" for patient: "PT_PR02_TissueReceived"
#    Then set patient message field: "study_id" to value: "<value>"
#    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
#    Examples:
#      |value     |message                                               |
#      |          |was not of a minimum string length of 1               |
#      |other     |not existing                                          |
#      |null      |type NilClass did not match the following type: string|
  Scenario Outline: PT_PR03. Pathology report with invalid surgical_event_id(empty, non-existing, null) should fail
#		Test data: Patient=PT_PR03_TissueReceived, with surgical_event_id=SEI_01 
    Given template pathology report with surgical_event_id: "<value>" for patient: "PT_PR03_TissueReceived"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |value     |message                                             |
      |          |not of a minimum string length of 1                 |
      |SEI_NON   |not exist                                           |
      |null      |NilClass did not match the following type: string   |
  Scenario Outline: PT_PR04. Pathology report with invalid reported_date(empty, non-date, null) should fail
    Given template pathology report with surgical_event_id: "SEI_01" for patient: "PT_PR04_TissueReceived"
    Then set patient message field: "reported_date" to value: "<value>"
    When posted to MATCH patient trigger service, returns a message that includes "cannot transition from" with status "Failure"
    Examples:
      |value     |
      |          |
      |nonDate   |
      |null      |
  Scenario Outline: PT_PR05. Pathology report with invalid result(other than Y, N or U) should fail
    Given template pathology report with surgical_event_id: "SEI_01" for patient: "PT_PR05_TissueReceived"
    Then set patient message field: "status" to value: "<value>"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |value     |message                                           |
      |          |not of a minimum string length of 1               |
      |other     |not match one of the following values: Y, N, U    |
      |null      |NilClass did not match the following type: string |
#Field tests:
  Scenario: PT_PR06. Pathology report can be sent on TISSUE_SPECIMEN_RECEIVED status
    Given template pathology report with surgical_event_id: "SEI_01" for patient: "PT_PR06_TissueReceived"
    Then set patient message field: "status" to value: "Y"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "10" seconds
    Then retrieve patient: "PT_PR06_TissueReceived" from API
    Then returned patient has value: "PATHOLOGY_REVIEWED" in field: "current_status"
  
  Scenario: PT_PR07. Pathology report can be sent on TISSUE_NUCLEIC_ACID_SHIPPED status
    Given template pathology report with surgical_event_id: "SEI_01" for patient: "PT_PR07_TissueShipped"
    Then set patient message field: "status" to value: "N"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "10" seconds
    Then retrieve patient: "PT_PR06_TissueReceived" from API
    Then returned patient has value: "PATHOLOGY_REVIEWED" in field: "current_status"

  Scenario: PT_PR08. Pathology report can be sent on TISSUE_SLIDE_SHIPPED status but will not change patient status if status is U
    Given template pathology report with surgical_event_id: "SEI_01" for patient: "PT_PR08_SlideShipped"
    Then set patient message field: "status" to value: "U"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "10" seconds
    Then retrieve patient: "PT_PR06_TissueReceived" from API
    Then returned patient has value: "TISSUE_SLIDE_SPECIMEN_SHIPPED" in field: "current_status"


  Scenario Outline: PT_PR09. Pathology report received for patient who has no tissue received(using same surgical_event_id) should fail
#		Test data: Patient=PT_PR09_Registered, without tissue
#       Patient=PT_PR09_SEI1HasTissueSEI2NoTissue, surgical_event_id=SEI_01 has tissue received, has no tissue using surgical_event_id=SEI_02 received
    Given template pathology report with surgical_event_id: "<sei>" for patient: "<patient_id>"
    When posted to MATCH patient trigger service, returns a message that includes "cannot transition from" with status "Failure"
    Examples:
      |patient_id                            |sei         |
      |PT_PR09_Registered                    |SEI_NON     |
      |PT_PR09_SEI1HasTissueSEI2NoTissue     |SEI_02      |

  Scenario: PT_PR10. Pathology report reported_date is older than tissue received date should fail
#  Test data: Patient=PT_PR10TissueReceived, surgical_event_id=SEI_01, received_dttm: 2016-04-25T16:17:11+00:00,
    Given template pathology report with surgical_event_id: "SEI_01" for patient: "PT_PR10TissueReceived"
    Then set patient message field: "reported_date" to value: "2010-04-25T16:17:11+00:00"
    When posted to MATCH patient trigger service, returns a message that includes "cannot transition from" with status "Failure"

  Scenario: PT_PR11. Pathology report received for old surgical_event_id should fail
#  Test data: Patient=PT_PR11TissueReceived, old surgical_event_id=SEI_01, has tissue received, new surgical_event_id=SEI_02, has tissue received
    Given template pathology report with surgical_event_id: "SEI_01" for patient: "PT_PR11TissueReceived"
    When posted to MATCH patient trigger service, returns a message that includes "cannot transition from" with status "Failure"

  #if Y received, can receive new specimen(covered by specimen received test), no more pathology
  #if N received, no more pathology received, wait for either new specimen(covered by specimen received test) or patient off_study
  #if U received, either new pathology received to update this to Y or N, or received new specimen(covered by specimen received test), or patient off_study
  Scenario Outline: PT_PR12. Pathology result (in current latest surgical_event_id) can only be received again if last pathology's result is U
#  Test data: Patient=PT_PR12TissueReceived, surgical_event_id=SEI_01, has tissue received
    Given template pathology report with surgical_event_id: "SEI_01" for patient: "<patientID>"
    Then set patient message field: "reported_date" to value: "<date>"
    Then set patient message field: "status" to value: "<status>"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "<postStatus>"
  Examples:
  |patientID                  |status    |date                             |postStatus  |message                                             |
  |PT_PR12_PathologyYReceived |U         |2016-05-18T10:42:13+00:00        |Failure     |cannot transition from                              |
  |PT_PR12_PathologyYReceived |Y         |2016-05-18T11:42:13+00:00        |Failure     |cannot transition from                              |
  |PT_PR12_PathologyYReceived |N         |2016-05-18T12:42:13+00:00        |Failure     |cannot transition from                              |
  |PT_PR12_PathologyNReceived |U         |2016-05-18T13:42:13+00:00        |Failure     |cannot transition from                              |
  |PT_PR12_PathologyNReceived |Y         |2016-05-18T14:42:13+00:00        |Failure     |cannot transition from                              |
  |PT_PR12_PathologyNReceived |N         |2016-05-18T15:42:13+00:00        |Failure     |cannot transition from                              |
  |PT_PR12_PathologyUReceived1|U         |2016-05-18T16:42:13+00:00        |Success     |Message has been processed successfully             |
  |PT_PR12_PathologyUReceived2|Y         |2016-05-18T17:42:13+00:00        |Success     |Message has been processed successfully             |
  |PT_PR12_PathologyUReceived3|N         |2016-05-18T18:42:13+00:00        |Success     |Message has been processed successfully             |

#  Data not ready yet
#  Scenario Outline: PT_PR13. pathology confirmation will not trigger patient assignment process unless patient has assay and VR ready
#  #Test patient PT_PR13_AssayNotDone VR confirmed (SEI_01, MOI_01, ANI_01), Assay result is not received yet
#  #             PT_PR13_VRNotDone VR uploaded (SEI_01, MOI_01, ANI_01) but not confirmed, Assay result received (SEI_01)
#  #             PT_PR13_AllDonePlanToY VR confirmed (SEI_01, MOI_01, ANI_01), Assay result received (SEI_01)
#  #             PT_PR13_AllDonePlanToN VR confirmed (SEI_01, MOI_01, ANI_01), Assay result received (SEI_01)
#    Given template pathology report with surgical_event_id: "SEI_01" for patient: "<patientID>"
#    Then set patient message field: "status" to value: "<confirm_status>"
#    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"
#    Then wait for "20" seconds
#    Then retrieve patient: "<patient_id>" from API
#    Then returned patient has value: "<patient_status>" in field: "status"
#    Examples:
#      |patient_id                 |confirm_status    |patient_status         |
##      |PT_PR13_AssayNotDone       |Y                 |PATHOLOGY_REVIEWED     |
##      |PT_PR13_VRNotDone          |Y                 |PATHOLOGY_REVIEWED     |
##      |PT_PR13_AllDonePlanToY     |Y                 |PENDING_CONFIRMATION   |
##      |PT_PR13_AllDonePlanToN     |N                 |PATHOLOGY_REVIEWED     |

#	pathology result cannot be received after patient has COMPLETE_MDA_DATA_SET status (in this step cycle) (not sure, actually it doesn't matter)
#	pathology result cannot be received when patient is in OFF_TRAIL status (not sure, actually it doesn't matter)


