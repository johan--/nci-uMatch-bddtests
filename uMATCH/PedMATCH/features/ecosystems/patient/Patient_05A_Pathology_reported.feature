#encoding: utf-8
@patients @pathology
Feature: Pathology Messages

  Scenario Outline: PT_PR01. Pathology report with invalid patient_id(empty, non-existing, null) should fail
    Given template pathology report with surgical_event_id: "PT_PR01_SEI1" for patient: "<value>"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |value     |message                      |
      |          |can't be blank               |
      |nonPatient|as not been registered       |
      |null      |can't be blank               |

  Scenario Outline: PT_PR02. Pathology report with invalid study_id(empty, non-existing, null) should fail
    Given template pathology report with surgical_event_id: "PT_PR02_TissueReceived_SEI1" for patient: "PT_PR02_TissueReceived"
    Then set patient message field: "study_id" to value: "<value>"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |value     |message                |
      |          |can't be blank         |
      |other     |not a valid study_id   |
      |null      |can't be blank         |

  Scenario Outline: PT_PR03. Pathology report with invalid surgical_event_id(empty, non-existing, null) should fail
#		Test data: Patient=PT_PR03_TissueReceived, with surgical_event_id=PT_PR03_TissueReceived_SEI1
    Given template pathology report with surgical_event_id: "<value>" for patient: "PT_PR03_TissueReceived"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |value     |message                |
      |          |can't be blank         |
      |SEI_NON   |surgical event_id      |
      |null      |can't be blank         |
  Scenario Outline: PT_PR04. Pathology report with invalid reported_date(empty, non-date, null) should fail
    Given template pathology report with surgical_event_id: "PT_PR04_TissueReceived_SEI1" for patient: "PT_PR04_TissueReceived"
    Then set patient message field: "reported_date" to value: "<value>"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |value     |message          |
      |          |can't be blank   |
      |nonDate   |date             |
      |null      |can't be blank   |
  Scenario Outline: PT_PR05. Pathology report with invalid result(other than Y, N or U) should fail
    Given template pathology report with surgical_event_id: "PT_PR05_TissueReceived_SEI1" for patient: "PT_PR05_TissueReceived"
    Then set patient message field: "status" to value: "<value>"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |value     |message                                   |
      |          |can't be blank                            |
      |other     |is not a valid pathology review status    |
      |null      |can't be blank                            |
#Field tests:
  Scenario: PT_PR06. Pathology report can be sent on TISSUE_SPECIMEN_RECEIVED status
    Given template pathology report with surgical_event_id: "PT_PR06_TissueReceived_SEI1" for patient: "PT_PR06_TissueReceived"
    Then set patient message field: "status" to value: "Y"
    Then set patient message field: "reported_date" to value: "2016-08-18T18:42:13+00:00"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "10" seconds
    Then retrieve patient: "PT_PR06_TissueReceived" from API
    Then returned patient has value: "PATHOLOGY_REVIEWED" in field: "current_status"
    Then returned patient has specimen (surgical_event_id: "PT_PR06_TissueReceived_SEI1")
    Then this specimen has value: "pathology_status" in field: "Y"
    And this specimen has value: "reported_date" in field: "2016-08-18T18:42:13+00:00"
  
  Scenario: PT_PR07. Pathology report can be sent on TISSUE_NUCLEIC_ACID_SHIPPED status
    Given template pathology report with surgical_event_id: "PT_PR07_TissueShipped_SEI1" for patient: "PT_PR07_TissueShipped"
    Then set patient message field: "status" to value: "N"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "10" seconds
    Then retrieve patient: "PT_PR06_TissueReceived" from API
    Then returned patient has value: "PATHOLOGY_REVIEWED" in field: "current_status"

  Scenario: PT_PR08. Pathology report can be sent on TISSUE_SLIDE_SHIPPED status but will not change patient status if status is U
    Given template pathology report with surgical_event_id: "PT_PR08_SlideShipped_SEI1" for patient: "PT_PR08_SlideShipped"
    Then set patient message field: "status" to value: "U"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "10" seconds
    Then retrieve patient: "PT_PR06_TissueReceived" from API
    Then returned patient has value: "TISSUE_SLIDE_SPECIMEN_SHIPPED" in field: "current_status"


  Scenario Outline: PT_PR09. Pathology report received using an non-existing surgical event id should fail
#		Test data: Patient=PT_PR09_Registered, without tissue
#       Patient=PT_PR09_SEI1HasTissue surgical_event_id=_SEI1 has tissue received, has no tissue using surgical_event_id=SEI_02 received
    Given template pathology report with surgical_event_id: "<sei>" for patient: "<patient_id>"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |patient_id                            |sei                            |message                                                       |
      |PT_PR09_Registered                    |PT_PR09_Registered_SEI1        |TBD                                                           |
      |PT_PR09_SEI1HasTissue                 |PT_PR09_SEI1HasTissue_SEI2     |surgical event_id PT_PR09_SEI1HasTissue_SEI2 doesn't exist    |

  Scenario: PT_PR10. Pathology report reported_date is older than tissue received date should fail
#  Test data: Patient=PT_PR10TissueReceived, surgical_event_id=PT_PR10TissueReceived_SEI1, received_dttm: 2016-04-25T16:17:11+00:00,
    Given template pathology report with surgical_event_id: "PT_PR10TissueReceived_SEI1" for patient: "PT_PR10TissueReceived"
    Then set patient message field: "reported_date" to value: "2010-04-25T16:17:11+00:00"
    When posted to MATCH patient trigger service, returns a message that includes "cannot transition from" with status "Failure"

  Scenario: PT_PR11. Pathology report received for old surgical_event_id should fail
#  Test data: Patient=PT_PR11TissueReceived, old surgical_event_id=PT_PR11TissueReceived_SEI1, has tissue received, new surgical_event_id=PT_PR11TissueReceived_SEI2, has tissue received
    Given template pathology report with surgical_event_id: "PT_PR11TissueReceived_SEI1" for patient: "PT_PR11TissueReceived"
    When posted to MATCH patient trigger service, returns a message that includes "is not the currently active specimen" with status "Failure"

  #if Y received, can receive new specimen(covered by specimen received test), no more pathology
  #if N received, no more pathology received, wait for either new specimen(covered by specimen received test) or patient off_study
  #if U received, either new pathology received to update this to Y or N, or received new specimen(covered by specimen received test), or patient off_study
  Scenario Outline: PT_PR12. Pathology result (in current latest surgical_event_id) can only be received again if last pathology's result is U
#  Test data: Patient=PT_PR12TissueReceived, surgical_event_id=_SEI1, has tissue received
    Given template pathology report with surgical_event_id: "<sei>" for patient: "<patientID>"
    Then set patient message field: "reported_date" to value: "<date>"
    Then set patient message field: "status" to value: "<status>"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "<postStatus>"
  Examples:
  |patientID                  |sei                              |status    |date                             |postStatus  |message                                             |
  |PT_PR12_PathologyYReceived |PT_PR12_PathologyYReceived_SEI1  |U         |2016-05-18T10:42:13+00:00        |Failure     |already has a valid pathology status                |
  |PT_PR12_PathologyYReceived |PT_PR12_PathologyYReceived_SEI1  |Y         |2016-05-18T11:42:13+00:00        |Failure     |already has a valid pathology status                |
  |PT_PR12_PathologyYReceived |PT_PR12_PathologyYReceived_SEI1  |N         |2016-05-18T12:42:13+00:00        |Failure     |already has a valid pathology status                |
  |PT_PR12_PathologyNReceived |PT_PR12_PathologyNReceived_SEI1  |U         |2016-05-18T13:42:13+00:00        |Failure     |already has a valid pathology status                |
  |PT_PR12_PathologyNReceived |PT_PR12_PathologyNReceived_SEI1  |Y         |2016-05-18T14:42:13+00:00        |Failure     |already has a valid pathology status                |
  |PT_PR12_PathologyNReceived |PT_PR12_PathologyNReceived_SEI1  |N         |2016-05-18T15:42:13+00:00        |Failure     |already has a valid pathology status                |
  |PT_PR12_PathologyUReceived1|PT_PR12_PathologyUReceived1_SEI1 |U         |2016-05-18T16:42:13+00:00        |Success     |Message has been processed successfully             |
  |PT_PR12_PathologyUReceived2|PT_PR12_PathologyUReceived2_SEI1 |Y         |2016-05-18T17:42:13+00:00        |Success     |Message has been processed successfully             |
  |PT_PR12_PathologyUReceived3|PT_PR12_PathologyUReceived3_SEI1 |N         |current                          |Success     |Message has been processed successfully             |

  Scenario Outline: PT_PR13. pathology confirmation will not trigger patient assignment process unless patient has assay and VR ready
#  #Test patient PT_PR13_VRConfirmedNoAssay VR confirmed PT_PR13_VRConfirmedNoAssay(_SEI1, _MOI1, _ANI1), Assay result is not received yet
#  #             PT_PR13_AssayReceivedVRNotConfirmed VR uploaded PT_PR13_AssayReceivedVRNotConfirmed(_SEI1, _MOI1, _ANI1) but not confirmed, Assay result received (_SEI1)
#  #             PT_PR13_AssayAndVRDonePlanToY VR confirmed PT_PR13_AssayAndVRDonePlanToY(_SEI1, _MOI1, _ANI1), Assay result received (_SEI1)
#  #             PT_PR13_AssayAndVRDonePlanToN VR confirmed PT_PR13_AssayAndVRDonePlanToN(_SEI1, _MOI1, _ANI1), Assay result received (_SEI1)
#  #             PT_PR13_AssayAndVRDonePlanToU VR confirmed PT_PR13_AssayAndVRDonePlanToU(_SEI1, _MOI1, _ANI1), Assay result received (_SEI1)
    Given template pathology report with surgical_event_id: "<sei>" for patient: "<patient_id>"
    Then set patient message field: "status" to value: "<confirm_status>"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "60" seconds
    Then retrieve patient: "<patient_id>" from API
    Then returned patient has value: "<patient_status>" in field: "current_status"
    Examples:
      |patient_id                           |sei                                      |confirm_status    |patient_status         |
      |PT_PR13_VRConfirmedNoAssay           |PT_PR13_VRConfirmedNoAssay_SEI1          |Y                 |PATHOLOGY_REVIEWED     |
      |PT_PR13_AssayReceivedVRNotConfirmed  |PT_PR13_AssayReceivedVRNotConfirmed_SEI1 |Y                 |PATHOLOGY_REVIEWED     |
      |PT_PR13_AssayAndVRDonePlanToY        |PT_PR13_AssayAndVRDonePlanToY_SEI1       |Y                 |PENDING_CONFIRMATION   |
      |PT_PR13_AssayAndVRDonePlanToN        |PT_PR13_AssayAndVRDonePlanToN_SEI1       |N                 |PENDING_CONFIRMATION   |
      |PT_PR13_AssayAndVRDonePlanToU        |PT_PR13_AssayAndVRDonePlanToU_SEI1       |U                 |PATHOLOGY_REVIEWED     |
