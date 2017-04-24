#encoding: utf-8
@assay
Feature: Assay Messages

  Background:
    Given patient API user authorization role is "ASSAY_MESSAGE_SENDER"

  @patients_p1
  Scenario Outline: PT_AS00. Assay result message can be consumed successfully
    Given patient id is "<patient_id>"
    And load template assay message for this patient
    Then set patient message field: "surgical_event_id" to value: "<sei>"
    Then set patient message field: "biomarker" to value: "<biomarker>"
    Then set patient message field: "result" to value: "<result>"
    Then set patient message field: "reported_date" to value: "<reported_date>"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "ASSAY_RESULTS_RECEIVED"
    Then patient should have specimen (field: "surgical_event_id" is "<sei>")
    And this specimen has assay (biomarker: "<biomarker>", result: "<result>", reported_date: "<reported_date>")
    Examples:
      | patient_id            | sei                        | biomarker | result        | reported_date             |
      | PT_AS00_SlideShipped1 | PT_AS00_SlideShipped1_SEI1 | ICCPTENs  | POSITIVE      | 2016-08-18T10:42:13+00:00 |
      | PT_AS00_SlideShipped2 | PT_AS00_SlideShipped2_SEI1 | ICCBAF47s | NEGATIVE      | 2016-08-18T11:42:13+00:00 |
      | PT_AS00_SlideShipped3 | PT_AS00_SlideShipped3_SEI1 | ICCBRG1s  | NEGATIVE      | 2016-08-18T12:42:13+00:00 |
      | PT_AS00_SlideShipped4 | PT_AS00_SlideShipped4_SEI1 | ICCBAF47s | INDETERMINATE | 2016-08-18T13:42:13+00:00 |


  @patients_p2
  Scenario Outline: PT_AS01. Assay result with invalid patient_id(empty, non-existing, null) should fail
    Given patient id is "<patient_id>"
    And load template assay message for this patient
    Then set patient message field: "biomarker" to value: "ICCPTENs"
    Then set patient message field: "surgical_event_id" to value: "PT_AS01_SEI1"
    When POST to MATCH patients service, response includes "<message>" with code "403"
    Examples:
      | patient_id | message        |
  #    |          |can't be blank             |
      | nonPatient | NOT_REGISTERED |
#    |null      |can't be blank             |

  @patients_p2
  Scenario Outline: PT_AS02. Assay result with invalid study_id(empty, non-existing, null) should fail
  #		Test data: Patient=PT_AS02_SlideShipped, with surgical_event_id=PT_AS02_SlideShipped_SEI1, slide_barcode=PT_AS02_SlideShipped_BC1
    Given patient id is "PT_AS02_SlideShipped"
    And load template assay message for this patient
    Then set patient message field: "biomarker" to value: "ICCPTENs"
    Then set patient message field: "surgical_event_id" to value: "PT_AS02_SlideShipped_SEI1"
    Then set patient message field: "study_id" to value: "<value>"
    When POST to MATCH patients service, response includes "<message>" with code "403"
    Examples:
      | value | message              |
      |       | can't be blank       |
      | other | not a valid study_id |
      | null  | can't be blank       |

  @patients_p2
  Scenario Outline: PT_AS03. Assay result with invalid surgical_event_id(empty, non-existing, null) should fail
  #		Test data: Patient=PT_AS03_SlideShipped, with surgical_event_id=PT_AS03_SlideShipped_SEI1
    Given patient id is "PT_AS03_SlideShipped"
    And load template assay message for this patient
    Then set patient message field: "biomarker" to value: "ICCPTENs"
    Then set patient message field: "surgical_event_id" to value: "<sei>"
    When POST to MATCH patients service, response includes "<message>" with code "403"
    Examples:
      | sei     | message           |
      |         | can't be blank    |
      | SEI_NON | surgical event_id |
      | null    | can't be blank    |

#    type has been removed from assay message
#  Scenario Outline: PT_AS04. Assay result with invalid type(other than RESULT) should fail
#    Given template assay message with surgical_event_id: "SEI_01" for patient: "PT_AS04_SlideShipped"
#    Then set patient message field: "type" to value: "<value>"
#    When POST to MATCH patients service, response includes "<message>" with code "403"
#    Examples:
#      |value     |message                                                   |
#      |          |not of a minimum string length of 1                       |
#      |OTHER     |cannot transition from                                    |
#      |null      |NilClass did not match the following type: string         |

  @patients_p2
  Scenario Outline: PT_AS05. Assay result with invalid biomarker(other than ICCPTENs, ICCBRG1s or ICCBAF47s) should fail
    Given patient id is "PT_AS05_SlideShipped"
    And load template assay message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_AS05_SlideShipped_SEI1"
    Then set patient message field: "biomarker" to value: "<value>"
    When POST to MATCH patients service, response includes "<message>" with code "403"
    Examples:
      | value    | message        |
      |          | can't be blank |
      | OTHER    | biomarker      |
      | ICCMLH1s | biomarker      |

  @patients_p2
  Scenario Outline: PT_AS06. Assay result with invalid reported_date(empty, non-date, null) should fail
    Given patient id is "PT_AS06_SlideShipped"
    And load template assay message for this patient
    Then set patient message field: "biomarker" to value: "ICCPTENs"
    Then set patient message field: "surgical_event_id" to value: "PT_AS06_SlideShipped_SEI1"
    Then set patient message field: "reported_date" to value: "<value>"
    When POST to MATCH patients service, response includes "<message>" with code "400"
    Examples:
      | value   | message        |
      |         | can't be blank |
      | nonDate | date           |
      | null    | can't be blank |

  @patients_p2
  Scenario Outline: PT_AS07. Assay result with invalid result(other than POSITIVE, NEGATIVE or INDETERMINATE) should fail
    Given patient id is "PT_AS07_SlideShipped"
    And load template assay message for this patient
    Then set patient message field: "biomarker" to value: "ICCPTENs"
    Then set patient message field: "surgical_event_id" to value: "PT_AS07_SlideShipped_SEI1"
    Then set patient message field: "result" to value: "<value>"
    When POST to MATCH patients service, response includes "<message>" with code "403"
    Examples:
      | value       | message        |
      |             | can't be blank |
      | otherResult | result         |
      | null        | can't be blank |


#Logic tests:
  @patients_p2
  Scenario Outline: PT_AS08. Assay result received for patient who has no slide shipped (using same surgical_event_id) should fail
  #		Test data: Patient=PT_AS08_Registered, without slide shipment
  #		Patient=PT_AS08_TissueReceived, tissue received with surgical_event_id=PT_AS08_TissueReceived_SEI1, without slide shipment
  #       Patient=PT_AS08_SEI1HasSlideSEI2NoSlide, surgical_event_id=PT_AS08_SEI1HasSlideSEI2NoSlide_SEI1 has slide shipped, surgical_event_id=PT_AS08_SEI1HasSlideSEI2NoSlide_SEI2 has no slide shipment
    Given patient id is "<patient_id>"
    And load template assay message for this patient
    Then set patient message field: "biomarker" to value: "ICCPTENs"
    Then set patient message field: "surgical_event_id" to value: "<sei>"
    Then set patient message field: "reported_date" to value: "current"
    When POST to MATCH patients service, response includes "<message>" with code "403"
    Examples:
      | patient_id                      | sei                                  | message                       |
      | PT_AS08_Registered              | SEI_NON                              | surgical event_id             |
      | PT_AS08_TissueReceived          | PT_AS08_TissueReceived_SEI1          | doesn't have a slide shipment |
      | PT_AS08_SEI1HasSlideSEI2NoSlide | PT_AS08_SEI1HasSlideSEI2NoSlide_SEI2 | doesn't have a slide shipment |
      | PT_AS08_TsReceivedStep2         | PT_AS08_TsReceivedStep2_SEI2         | doesn't have a slide shipment |

  @patients_p3
  Scenario Outline: PT_AS09. Patient on some status shouldn't be able to receive assay result
    Given patient id is "<patient_id>"
    And load template assay message for this patient
    Then set patient message field: "biomarker" to value: "<biomarker>"
    Then set patient message field: "surgical_event_id" to value: "<sei>"
    When POST to MATCH patients service, response includes "<message>" with code "403"
    Examples:
      | patient_id                    | biomarker | sei                                | message |
      | PT_AS09_ReqNoAssignment       | ICCPTENs  | PT_AS09_ReqNoAssignment_SEI1       | status  |
      | PT_AS09_OffStudy              | ICCPTENs  | PT_AS09_OffStudy_SEI1              | status  |
      | PT_AS09_OffStudyBiopsyExpired | ICCPTENs  | PT_AS09_OffStudyBiopsyExpired_SEI1 | status  |
#  Scenario: PT_AS09a. Assay result report date is older than order date should fail
##  Test data: Patient=PT_AS09aSlideShipped, surgical_event_id=PT_AS09aSlideShipped_SEI1, ordered_date=2016-05-02T12:13:09.071-05:00
#    Given template assay message with surgical_event_id: "PT_AS09aSlideShipped_SEI1" for patient: "PT_AS09aSlideShipped"
#    Then set patient message field: "ordered_date" to value: "2016-05-05T12:13:09.071-05:00"
#    Then set patient message field: "reported_date" to value: "2016-05-03T12:13:09.071-05:00"
#    When POST to MATCH patients service, response includes "Assay ordered date later than result reported date" with status "Failure"

  @patients_p3
  Scenario: PT_AS10. Assay result received for old surgical_event_id should PASS (new requirement)
  #  Test data: Patient=PT_AS10SlideShipped, old surgical_event_id=PT_AS10SlideShipped_SEI1, has slide shipped, new surgical_event_id=PT_AS10SlideShipped_SEI2, has slide shipped
    Given patient id is "PT_AS10SlideShipped"
    And load template assay message for this patient
    Then set patient message field: "biomarker" to value: "ICCBRG1s"
    Then set patient message field: "result" to value: "NEGATIVE"
    Then set patient message field: "surgical_event_id" to value: "PT_AS10SlideShipped_SEI1"
    Then set patient message field: "reported_date" to value: "2016-05-18T11:42:13+00:00"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then wait until patient specimen is updated
    Then patient should have specimen (field: "surgical_event_id" is "PT_AS10SlideShipped_SEI1")
    And this specimen has assay (biomarker: "ICCBRG1s", result: "NEGATIVE", reported_date: "2016-05-18T11:42:13+00:00")

  @patients_p2
  Scenario: PT_AS10a. Assay result received for active surgical_event_id but doesn't belong to this patient should fail
  #  Test data: Patient=PT_AS10aSlideShipped1, sei=PT_AS10aSlideShipped1_SEI1,
  #             Patient=PT_AS10aSlideShipped2, sei=PT_AS10aSlideShipped2_SEI1,
    Given patient id is "PT_AS10aSlideShipped1"
    And load template assay message for this patient
    Then set patient message field: "biomarker" to value: "ICCPTENs"
    Then set patient message field: "surgical_event_id" to value: "PT_AS10bSlideShipped2_SEI1"
    When POST to MATCH patients service, response includes "surgical" with code "403"

  @patients_p1
  Scenario Outline: PT_AS11. Assay result can be received multiple times with same surgical_event_id and the latest assay should be used
  #  Test data: Patient=PT_AS11SlideShipped, surgical_event_id=PT_AS11SlideShipped_SEI1, has slide shipped
    Given patient id is "PT_AS11SlideShipped"
    And load template assay message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_AS11SlideShipped_SEI1"
    Then set patient message field: "reported_date" to value: "<date>"
    Then set patient message field: "biomarker" to value: "<biomarker>"
    Then set patient message field: "result" to value: "<result>"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then wait until patient specimen is updated
    Then patient should have specimen (field: "surgical_event_id" is "PT_AS11SlideShipped_SEI1")
    And this specimen has assay (biomarker: "<biomarker>", result: "<result>", reported_date: "<date>")
    And patient active tissue specimen field "<biomarker>_received_date" should be "<date>"
    And patient active tissue specimen field "<biomarker>" should be "<result>"
    Examples:
      | biomarker | result        | date                      |
      | ICCPTENs  | POSITIVE      | 2016-05-18T10:42:13+00:00 |
      | ICCBAF47s | NEGATIVE      | 2016-05-18T11:42:13+00:00 |
      | ICCBRG1s  | POSITIVE      | 2016-05-18T12:42:13+00:00 |
      | ICCPTENs  | NEGATIVE      | 2016-05-18T13:42:13+00:00 |
      | ICCBAF47s | INDETERMINATE | 2016-05-18T14:42:13+00:00 |
      | ICCBRG1s  | INDETERMINATE | 2016-05-18T15:42:13+00:00 |

  @patients_p2
  Scenario Outline: PT_AS12. assay result received message can be processed properly
    Given patient id is "<patient_id>"
    And load template assay message for this patient
    Then set patient message field: "surgical_event_id" to value: "<sei>"
    Then set patient message field: "biomarker" to value: "ICCPTENs"
    Then set patient message field: "reported_date" to value: "current"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then wait until patient is updated
    Then set patient message field: "biomarker" to value: "ICCBAF47s"
    Then set patient message field: "reported_date" to value: "current"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then wait until patient is updated
    Then set patient message field: "biomarker" to value: "ICCBRG1s"
    Then set patient message field: "reported_date" to value: "current"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then wait until patient is updated
    Then wait for "5" seconds
    Then patient status should change to "<patient_status>"
    Examples:
      | patient_id          | patient_status         | sei                      |
      | PT_AS12_VrConfirmed | PENDING_CONFIRMATION   | PT_AS12_VrConfirmed_SEI1 |
      | PT_AS12_VrReceived  | ASSAY_RESULTS_RECEIVED | PT_AS12_VrReceived_SEI1  |

  @patients_p2
  Scenario Outline: PT_AS12a. assay result can be received and updated properly after assignment
    Given patient id is "<patient_id>"
    And load template assay message for this patient
    Then set patient message field: "surgical_event_id" to value: "<sei>"
    Then set patient message field: "biomarker" to value: "ICCPTENs"
    Then set patient message field: "reported_date" to value: "current"
    Then set patient message field: "result" to value: "POSITIVE"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then wait until patient is updated
    Then set patient message field: "biomarker" to value: "ICCBAF47s"
    Then set patient message field: "reported_date" to value: "current"
    Then set patient message field: "result" to value: "POSITIVE"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then wait until patient is updated
    Then set patient message field: "biomarker" to value: "ICCBRG1s"
    Then set patient message field: "reported_date" to value: "current"
    Then set patient message field: "result" to value: "POSITIVE"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then wait until patient is updated
    Then patient status should change to "<status>"
    And patient active tissue specimen field "ICCPTENs" should be "POSITIVE"
    And patient active tissue specimen field "ICCBAF47s" should be "POSITIVE"
    And patient active tissue specimen field "ICCBRG1s" should be "POSITIVE"
    Examples:
      | patient_id                  | sei                              | status               |
      | PT_AS12_PendingConfirmation | PT_AS12_PendingConfirmation_SEI1 | PENDING_CONFIRMATION |
      | PT_AS12_PendingApproval     | PT_AS12_PendingApproval_SEI1     | PENDING_APPROVAL     |
      | PT_AS12_OnTreatmentArm      | PT_AS12_OnTreatmentArm_SEI1      | ON_TREATMENT_ARM     |

  @patients_p3
  Scenario: PT_AS13. extra key-value pair in the message body should NOT fail
    Given patient id is "PT_AS13_SlideShipped"
    And load template assay message for this patient
    Then set patient message field: "biomarker" to value: "ICCPTENs"
    Then set patient message field: "surgical_event_id" to value: "PT_AS13_SlideShipped_SEI1"
    Then set patient message field: "extra_info" to value: "This is extra information"
    When POST to MATCH patients service, response includes "successfully" with code "202"

  @patients_p3
  Scenario Outline: PT_AS14. assay use same report date should be accepted
    Given patient id is "PT_AS14_SlideShipped"
    And load template assay message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_AS14_SlideShipped_SEI1"
    Then set patient message field: "reported_date" to value: "<date>"
    Then set patient message field: "biomarker" to value: "<biomarker>"
    Then set patient message field: "result" to value: "<result>"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then wait until patient specimen is updated
    Then patient should have specimen (field: "surgical_event_id" is "PT_AS14_SlideShipped_SEI1")
    And this specimen has assay (biomarker: "<biomarker>", result: "<result>", reported_date: "<date>")
    And patient active tissue specimen field "<biomarker>_received_date" should be "<date>"
    And patient active tissue specimen field "<biomarker>" should be "<result>"
    Examples:
      | biomarker | result   | date                      |
      | ICCPTENs  | POSITIVE | 2016-12-01T10:42:13+00:00 |
      | ICCPTENs  | NEGATIVE | 2016-12-01T10:42:13+00:00 |
      | ICCBAF47s | POSITIVE | 2016-12-01T11:42:13+00:00 |
      | ICCBAF47s | NEGATIVE | 2016-12-01T11:42:13+00:00 |
      | ICCBRG1s  | POSITIVE | 2016-12-01T11:42:13+00:00 |
      | ICCBRG1s  | NEGATIVE | 2016-12-01T11:42:13+00:00 |
