#encoding: utf-8
#@patients
@assay
Feature: Assay Messages
  Scenario Outline: PT_AS01. Assay result with invalid patient_id(empty, non-existing, null) should fail
    Given template assay message with surgical_event_id: "SEI_01" for patient: "<value>"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
    |value     |message                                                   |
    |          |not of a minimum string length of 1                       |
    |nonPatient|not exist                                                 |
    |null      |NilClass did not match the following type: string         |
  Scenario Outline: PT_AS02. Assay result with invalid study_id(empty, non-existing, null) should fail
#		Test data: Patient=PT_AS02_SlideShipped, with surgical_event_id=SEI_01, slide_barcode=BC_001
    Given template assay message with surgical_event_id: "SEI_01" for patient: "PT_AS02_SlideShipped"
    Then set patient message field: "study_id" to value: "<value>"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |value     |message                                                   |
      |          |not of a minimum string length of 1                       |
      |other     |ot match one of the following values: APEC1621            |
      |null      |NilClass did not match the following type: string         |
  Scenario Outline: PT_AS03. Assay result with invalid surgical_event_id(empty, non-existing, null) should fail
#		Test data: Patient=PT_AS03_SlideShipped, with surgical_event_id=SEI_01
    Given template assay message with surgical_event_id: "<value>" for patient: "PT_AS03_SlideShipped"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |value     |message                                                   |
      |          |not of a minimum string length of 1                       |
      |SEI_NON   |cannot transition from                                    |
      |null      |NilClass did not match the following type: string         |

#    type has been removed from assay message
#  Scenario Outline: PT_AS04. Assay result with invalid type(other than RESULT) should fail
#    Given template assay message with surgical_event_id: "SEI_01" for patient: "PT_AS04_SlideShipped"
#    Then set patient message field: "type" to value: "<value>"
#    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
#    Examples:
#      |value     |message                                                   |
#      |          |not of a minimum string length of 1                       |
#      |OTHER     |cannot transition from                                    |
#      |null      |NilClass did not match the following type: string         |
  Scenario Outline: PT_AS05. Assay result with invalid biomarker(other than ICCPTEN or MLH1) should fail
    Given template assay message with surgical_event_id: "SEI_01" for patient: "PT_AS05_SlideShipped"
    Then set patient message field: "biomarker" to value: "<value>"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |value     |message                                                   |
      |          |not of a minimum string length of 1                       |
      |OTHER     |cannot transition from                                    |
      |null      |NilClass did not match the following type: string         |
  Scenario Outline: PT_AS06. Assay result with invalid reported_date(empty, non-date, null) should fail
    Given template assay message with surgical_event_id: "SEI_01" for patient: "PT_AS06_SlideShipped"
    Then set patient message field: "reported_date" to value: "<value>"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |value     |message                                                   |
      |          |not of a minimum string length of 1                       |
      |nonDate   |cannot transition from                                    |
      |null      |NilClass did not match the following type: string         |
  Scenario Outline: PT_AS07. Assay result with invalid result(other than POSITIVE or NEGATIVE) should fail
    Given template assay message with surgical_event_id: "SEI_01" for patient: "PT_AS07_SlideShipped"
    Then set patient message field: "result" to value: "<value>"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |value      |message                                                   |
      |           |not of a minimum string length of 1                       |
      |otherResult|cannot transition from                                    |
      |null       |NilClass did not match the following type: string         |
#Logic tests:
  Scenario Outline: PT_AS08. Assay result received for patient who has no slide shipped (using same surgical_event_id) should fail
#		Test data: Patient=PT_AS08_Registered, without slide shipment
#		Patient=PT_AS08_TissueReceived, tissue received with surgical_event_id=SEI_01, without slide shipment
#       Patient=PT_AS08_SEI1HasSlideSEI2NoSlide, surgical_event_id=SEI_01 has slide shipped, surgical_event_id=SEI_02 has no slide shipment
    Given template assay message with surgical_event_id: "<sei>" for patient: "<patient_id>"
    When posted to MATCH patient trigger service, returns a message that includes "cannot transition from" with status "Failure"
    Examples:
      |patient_id                            |sei         |
      |PT_AS08_Registered                    |SEI_NON     |
      |PT_AS08_TissueReceived                |SEI_01      |
# data cannot be prepared due to current bug     |PT_AS08_SEI1HasSlideSEI2NoSlide       |SEI_02      |
  
  Scenario: PT_AS09. Assay result reported_date is older than earlist slide shipped date should fail
#  Test data: Patient=PT_AS09SlideShipped, surgical_event_id=SEI_01, shipped_dttm=2016-05-01T19:42:13+00:00
    Given template assay message with surgical_event_id: "SEI_01" for patient: "PT_AS09SlideShipped"
    Then set patient message field: "reported_date" to value: "2010-05-01T19:42:13+00:00"
    When posted to MATCH patient trigger service, returns a message that includes "cannot transition from" with status "Failure"

  Scenario: PT_AS10. Assay result received for old surgical_event_id should fail
#  Test data: Patient=PT_AS10SlideShipped, old surgical_event_id=SEI_01, has slide shipped, new surgical_event_id=SEI_02, has slide shipped
    Given template assay message with surgical_event_id: "SEI_01" for patient: "PT_AS10SlideShipped"
    When posted to MATCH patient trigger service, returns a message that includes "cannot transition from" with status "Failure"

  Scenario Outline: PT_AS11. Assay result can be received multiple times with same surgical_event_id (as long as this SEI is latest and has shipped slide)
#  Test data: Patient=PT_AS11SlideShipped, surgical_event_id=SEI_01, has slide shipped
    Given template assay message with surgical_event_id: "SEI_01" for patient: "PT_AS11SlideShipped"
    Then set patient message field: "reported_date" to value: "<date>"
    Then set patient message field: "<field>" to value: "<value>"
    Then wait for "15" seconds
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"
    Examples:
    |field              |value            |date                             |
    |biomarker          |MLH1             |2016-05-18T10:42:13+00:00        |
    |result             |NEGATIVE         |2016-05-18T11:42:13+00:00        |
    |biomarker          |ICCPTEN          |2016-05-18T12:42:13+00:00        |


  Scenario Outline: PT_AS12. assay result received will not trigger patient assignment process unless patient has pathology and VR ready
  #Test patient PT_AS12_VRConfirmedNoPatho VR uploaded (SEI_01, MOI_01, ANI_01), Pathology confirmed (SEI_01), Assay result is not received yet
  #             PT_AS12_PathoConfirmedNoVR VR uploaded (SEI_01, MOI_01, ANI_01), Assay result received (SEI_01), Pathology is not confirmed yet
  #             PT_AS12_VRAndPathoConfrimed VR uploaded (SEI_01, MOI_01, ANI_01), Assay result received (SEI_01), Pathology is confirmed (SEI_01)
    Given template assay message with surgical_event_id: "SEI_01" for patient: "<patient_id>"
    Then set patient message field: "biomarker" to value: "ICCPTENs"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then template assay message with surgical_event_id: "SEI_01" for patient: "<patient_id>"
    Then set patient message field: "biomarker" to value: "ICCMLH1s"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "20" seconds
    Then retrieve patient: "<patient_id>" from API
    Then returned patient has value: "<patient_status>" in field: "status"
    Examples:
      |patient_id                           |patient_status            |
      |PT_AS12_VRConfirmedNoPatho           |ASSAY_RESULTS_RECEIVED    |
      |PT_AS12_PathoConfirmedNoVR           |ASSAY_RESULTS_RECEIVED    |
      |PT_AS12_VRAndPathoConfrimed          |PENDING_CONFIRMATION      |

#  order date is older than slide shipment date should fail
#  report date is older than order date should fail
#	assay result cannot be received after patient has COMPLETE_MDA_DATA_SET status (in this step cycle) (not sure, actually it doesn't matter)
#	assay result cannot be received when patient is in OFF_TRAIL status (not sure, actually it doesn't matter)


