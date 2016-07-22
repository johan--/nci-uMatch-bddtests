#encoding: utf-8

Feature: Pathology Messages

  Scenario Outline: PT_PR01. Pathology report with invalid patient_id(empty, non-existing, null) should fail
    Given template pathology report with surgical_event_id: "SEI_01" for patient: "<value>"
    When posted to MATCH patient trigger service, returns a message that includes "cannot transition from" with status "Failure"
    Examples:
      |value     |
      |          |
      |nonPatient|
      |null      |
  Scenario Outline: PT_PR02. Pathology report with invalid study_id(empty, non-existing, null) should fail
    Given template pathology report with surgical_event_id: "SEI_01" for patient: "PT_PR02_TissueReceived"
    Then set patient message field: "study_id" to value: "<value>"
    When posted to MATCH patient trigger service, returns a message that includes "cannot transition from" with status "Failure"
    Examples:
      |value     |
      |          |
      |other     |
      |null      |
  Scenario Outline: PT_PR03. Pathology report with invalid surgical_event_id(empty, non-existing, null) should fail
#		Test data: Patient=PT_PR03_TissueReceived, with surgical_event_id=SEI_01 
    Given template pathology report with surgical_event_id: "<value>" for patient: "PT_PR03_TissueReceived"
    When posted to MATCH patient trigger service, returns a message that includes "cannot transition from" with status "Failure"
    Examples:
      |value     |
      |          |
      |SEI_NON   |
      |null      |
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
    Then set patient message field: "result" to value: "<value>"
    When posted to MATCH patient trigger service, returns a message that includes "cannot transition from" with status "Failure"
    Examples:
      |value     |
      |          |
      |other     |
      |null      |
#Field tests:
  Scenario: PT_PR06. Pathology report can be sent on TISSUE_SPECIMEN_RECEIVED status
    Given template pathology report with surgical_event_id: "SEI_01" for patient: "PT_PR06_TissueReceived"
    Then set patient message field: "result" to value: "Y"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"
  
  Scenario: PT_PR07. Pathology report can be sent on TISSUE_NUCLEIC_ACID_SHIPPED status
    Given template pathology report with surgical_event_id: "SEI_01" for patient: "PT_PR07_TissueShipped"
    Then set patient message field: "result" to value: "N"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"

  Scenario: PT_PR08. Pathology report can be sent on TISSUE_SLIDE_SHIPPED status
    Given template pathology report with surgical_event_id: "SEI_01" for patient: "PT_PR08_SlideShipped"
    Then set patient message field: "result" to value: "U"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"


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
    Then set patient message field: "received_dttm" to value: "2010-04-25T16:17:11+00:00"
    When posted to MATCH patient trigger service, returns a message that includes "cannot transition from" with status "Failure"

  Scenario: PT_PR11. Pathology report received for old surgical_event_id should fail
#  Test data: Patient=PT_PR11TissueReceived, old surgical_event_id=SEI_01, has tissue received, new surgical_event_id=SEI_02, has tissue received
    Given template pathology report with surgical_event_id: "SEI_01" for patient: "PT_PR11TissueReceived"
    When posted to MATCH patient trigger service, returns a message that includes "cannot transition from" with status "Failure"

  Scenario Outline: : PT_PR12. Pathology result (in current latest surgical_event_id) can only be received again if last pathology's result is U
#  Test data: Patient=PT_PR12TissueReceived, surgical_event_id=SEI_01, has tissue received
    Given template assay message with surgical_event_id: "SEI_01" for patient: "PT_PR12TissueReceived"
    Then set patient message field: "reported_date" to value: "<date>"
    Then set patient message field: "status" to value: "<status>"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "<postStatus>"
  Examples:
  |status    |date                             |postStatus  |message                                                              |
  |U         |2016-05-18T10:42:13+00:00        |Success     |Message has been processed successfully                              |
  |Y         |2016-05-18T11:42:13+00:00        |Success     |Message has been processed successfully                              |
  |N         |2016-05-18T12:42:13+00:00        |Failure     |TBD                                                                  |
  |U         |2016-05-18T13:42:13+00:00        |Failure     |TBD                                                                  |

#	pathology result cannot be received after patient has COMPLETE_MDA_DATA_SET status (in this step cycle) (not sure, actually it doesn't matter)
#	pathology result cannot be received when patient is in OFF_TRAIL status (not sure, actually it doesn't matter)


