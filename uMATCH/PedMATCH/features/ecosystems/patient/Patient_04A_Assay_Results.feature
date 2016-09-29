#encoding: utf-8
@patients @assay
Feature: Assay Messages
  Scenario Outline: PT_AS01. Assay result with invalid patient_id(empty, non-existing, null) should fail
    Given template assay message with surgical_event_id: "PT_AS01_SEI1" for patient: "<value>"
    When post to MATCH patients service, returns a message that includes "<message>" with status "Failure"
    Examples:
    |value     |message                    |
#    |          |can't be blank             |
    |nonPatient|has not been registered    |
#    |null      |can't be blank             |
  Scenario Outline: PT_AS02. Assay result with invalid study_id(empty, non-existing, null) should fail
#		Test data: Patient=PT_AS02_SlideShipped, with surgical_event_id=PT_AS02_SlideShipped_SEI1, slide_barcode=PT_AS02_SlideShipped_BC1
    Given template assay message with surgical_event_id: "PT_AS02_SlideShipped_SEI1" for patient: "PT_AS02_SlideShipped"
    Then set patient message field: "study_id" to value: "<value>"
    When post to MATCH patients service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |value     |message                |
      |          |can't be blank         |
      |other     |not a valid study_id   |
      |null      |can't be blank         |
  Scenario Outline: PT_AS03. Assay result with invalid surgical_event_id(empty, non-existing, null) should fail
#		Test data: Patient=PT_AS03_SlideShipped, with surgical_event_id=PT_AS03_SlideShipped_SEI1
    Given template assay message with surgical_event_id: "<value>" for patient: "PT_AS03_SlideShipped"
    When post to MATCH patients service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |value     |message                |
      |          |can't be blank         |
      |SEI_NON   |surgical event_id      |
      |null      |can't be blank         |

#    type has been removed from assay message
#  Scenario Outline: PT_AS04. Assay result with invalid type(other than RESULT) should fail
#    Given template assay message with surgical_event_id: "SEI_01" for patient: "PT_AS04_SlideShipped"
#    Then set patient message field: "type" to value: "<value>"
#    When post to MATCH patients service, returns a message that includes "<message>" with status "Failure"
#    Examples:
#      |value     |message                                                   |
#      |          |not of a minimum string length of 1                       |
#      |OTHER     |cannot transition from                                    |
#      |null      |NilClass did not match the following type: string         |
  Scenario Outline: PT_AS05. Assay result with invalid biomarker(other than ICCPTENs or ICCMLH1s) should fail
    Given template assay message with surgical_event_id: "PT_AS05_SlideShipped_SEI1" for patient: "PT_AS05_SlideShipped"
    Then set patient message field: "biomarker" to value: "<value>"
    When post to MATCH patients service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |value     |message          |
      |          |can't be blank   |
      |OTHER     |biomarker        |
      |null      |can't be blank   |
  Scenario Outline: PT_AS06. Assay result with invalid reported_date(empty, non-date, null) should fail
    Given template assay message with surgical_event_id: "PT_AS06_SlideShipped_SEI1" for patient: "PT_AS06_SlideShipped"
    Then set patient message field: "reported_date" to value: "<value>"
    When post to MATCH patients service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |value     |message          |
      |          |can't be blank   |
      |nonDate   |date             |
      |null      |can't be blank   |
  Scenario Outline: PT_AS07. Assay result with invalid result(other than POSITIVE, NEGATIVE or INDETERMINATE) should fail
    Given template assay message with surgical_event_id: "PT_AS07_SlideShipped_SEI1" for patient: "PT_AS07_SlideShipped"
    Then set patient message field: "result" to value: "<value>"
    When post to MATCH patients service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |value      |message          |
      |           |can't be blank   |
      |otherResult|result           |
      |null       |can't be blank   |
#Logic tests:
  Scenario Outline: PT_AS08. Assay result received for patient who has no slide shipped (using same surgical_event_id) should fail
#		Test data: Patient=PT_AS08_Registered, without slide shipment
#		Patient=PT_AS08_TissueReceived, tissue received with surgical_event_id=PT_AS08_TissueReceived_SEI1, without slide shipment
#       Patient=PT_AS08_SEI1HasSlideSEI2NoSlide, surgical_event_id=PT_AS08_SEI1HasSlideSEI2NoSlide_SEI1 has slide shipped, surgical_event_id=PT_AS08_SEI1HasSlideSEI2NoSlide_SEI2 has no slide shipment
    Given template assay message with surgical_event_id: "<sei>" for patient: "<patient_id>"
    Then set patient message field: "reported_date" to value: "current"
    When post to MATCH patients service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |patient_id                            |sei                                       |message                          |
      |PT_AS08_Registered                    |SEI_NON                                   |surgical event_id                |
      |PT_AS08_TissueReceived                |PT_AS08_TissueReceived_SEI1               |doesn't have a slide shipment    |
      |PT_AS08_SEI1HasSlideSEI2NoSlide       |PT_AS08_SEI1HasSlideSEI2NoSlide_SEI2      |doesn't have a slide shipment    |
  
  Scenario: PT_AS09. Assay result ordered_date is older than earlist slide shipped date should fail
#  Test data: Patient=PT_AS09SlideShipped, surgical_event_id=PT_AS09SlideShipped_SEI1, shipped_dttm=2016-05-01T19:42:13+00:00
    Given template assay message with surgical_event_id: "PT_AS09SlideShipped_SEI1" for patient: "PT_AS09SlideShipped"
    Then set patient message field: "ordered_date" to value: "2010-01-01T19:42:13+00:00"
    When post to MATCH patients service, returns a message that includes "Assay ordered date earlier than slide shipment date" with status "Failure"

  Scenario: PT_AS09a. Assay result report date is older than order date should fail
#  Test data: Patient=PT_AS09aSlideShipped, surgical_event_id=PT_AS09aSlideShipped_SEI1, ordered_date=2016-05-02T12:13:09.071-05:00
    Given template assay message with surgical_event_id: "PT_AS09aSlideShipped_SEI1" for patient: "PT_AS09aSlideShipped"
    Then set patient message field: "ordered_date" to value: "2016-05-05T12:13:09.071-05:00"
    Then set patient message field: "reported_date" to value: "2016-05-03T12:13:09.071-05:00"
    When post to MATCH patients service, returns a message that includes "Assay ordered date later than result reported date" with status "Failure"

  Scenario: PT_AS10. Assay result received for old surgical_event_id should fail
#  Test data: Patient=PT_AS10SlideShipped, old surgical_event_id=PT_AS10SlideShipped_SEI1, has slide shipped, new surgical_event_id=PT_AS10SlideShipped_SEI2, has slide shipped
    Given template assay message with surgical_event_id: "PT_AS10SlideShipped_SEI1" for patient: "PT_AS10SlideShipped"
    When post to MATCH patients service, returns a message that includes " not the currently active specimen" with status "Failure"

  Scenario: PT_AS10a. Assay result received for active surgical_event_id but doesn't belong to this patient should fail
#  Test data: Patient=PT_AS10aSlideShipped1, sei=PT_AS10aSlideShipped1_SEI1,
#             Patient=PT_AS10aSlideShipped2, sei=PT_AS10aSlideShipped2_SEI1,
    Given template assay message with surgical_event_id: "PT_AS10bSlideShipped2_SEI1" for patient: "PT_AS10aSlideShipped1"
    When post to MATCH patients service, returns a message that includes "surgical" with status "Failure"

  Scenario Outline: PT_AS11. Assay result can be received multiple times with same surgical_event_id (as long as this SEI is latest and has shipped slide)
#  Test data: Patient=PT_AS11SlideShipped, surgical_event_id=PT_AS11SlideShipped_SEI1, has slide shipped
    Given template assay message with surgical_event_id: "PT_AS11SlideShipped_SEI1" for patient: "PT_AS11SlideShipped"
    Then set patient message field: "reported_date" to value: "<date>"
    Then set patient message field: "biomarker" to value: "<biomarker>"
    Then set patient message field: "result" to value: "<result>"
    When post to MATCH patients service, returns a message that includes "processed successfully" with status "Success"
    Then patient should have specimen (surgical_event_id: "PT_AS11SlideShipped_SEI1") within 15 seconds
    And this specimen has assay (biomarker: "<biomarker>", result: "<result>", reported_date: "<date>")

    Examples:
    |biomarker          |result            |date                             |
    |ICCPTENs           |POSITIVE          |2016-05-18T10:42:13+00:00        |
    |ICCMLH1s           |NEGATIVE          |2016-05-18T11:42:13+00:00        |
    |ICCPTENs           |NEGATIVE          |2016-05-18T12:42:13+00:00        |
    |ICCMLH1s           |INDETERMINATE     |2016-05-18T13:42:13+00:00        |


  Scenario Outline: PT_AS12. assay result received will not trigger patient assignment process unless patient has pathology and VR ready
  #Test patient PT_AS12_VRConfirmedNoPatho VR confirmed ids: PT_AS12_VRConfirmedNoPatho_(SEI1, MOI1, ANI1), Pathology is not confirmed yet
  #             PT_AS12_PathoConfirmedNoVR VR uploaded ids: PT_AS12_PathoConfirmedNoVR_(SEI1, MOI1, ANI1), but not confirmed, Pathology is confirmed (PT_AS12_PathoConfirmedNoVR_SEI1)
  #             PT_AS12_VRAndPathoConfirmed VR confirmed ids: PT_AS12_VRAndPathoConfirmed_(SEI1, MOI1, ANI1), Pathology is confirmed (PT_AS12_VRAndPathoConfirmed_SEI1)
    Given template assay message with surgical_event_id: "<sei>" for patient: "<patient_id>"
    Then set patient message field: "biomarker" to value: "ICCPTENs"
    When post to MATCH patients service, returns a message that includes "processed successfully" with status "Success"
    Then wait for "5" seconds
    Then template assay message with surgical_event_id: "<sei>" for patient: "<patient_id>"
    Then set patient message field: "biomarker" to value: "ICCMLH1s"
    Then set patient message field: "reported_date" to value: "2016-07-18T13:42:13+00:00"
    When post to MATCH patients service, returns a message that includes "processed successfully" with status "Success"
    Then patient field: "current_status" should have value: "<patient_status>" after 30 seconds
    Examples:
      |patient_id                           |patient_status            |sei                                                     |
      |PT_AS12_VRAndPathoConfirmed          |PENDING_CONFIRMATION      |PT_AS12_VRAndPathoConfirmed_SEI1                        |
      |PT_AS12_VRConfirmedNoPatho           |ASSAY_RESULTS_RECEIVED    |PT_AS12_VRConfirmedNoPatho_SEI1                         |
      |PT_AS12_PathoConfirmedNoVR           |ASSAY_RESULTS_RECEIVED    |PT_AS12_PathoConfirmedNoVR_SEI1                         |


  Scenario: PT_AS13. extra key-value pair in the message body should NOT fail
    Given template assay message with surgical_event_id: "PT_AS13_SlideShipped_SEI1" for patient: "PT_AS13_SlideShipped"
    Then set patient message field: "extra_info" to value: "This is extra information"
    When post to MATCH patients service, returns a message that includes "processed successfully" with status "Success"


