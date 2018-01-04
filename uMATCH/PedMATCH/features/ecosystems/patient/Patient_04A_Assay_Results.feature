#encoding: utf-8
@assay
Feature: Assay Messages

  Background:
    Given patient API user authorization role is "ASSAY_MESSAGE_SENDER"

  @patients_p1 @patients_need_queue
  Scenario Outline: PT_AS00. Assay result message can be consumed successfully
    Given patient id is "<patient_id>"
    And load template assay message for this patient
    Then set patient message field: "surgical_event_id" to value: "<sei>"
    Then set patient message field: "biomarker" to value: "<biomarker>"
    Then set patient message field: "result" to value: "<result>"
    Then set patient message field: "reported_date" to value: "current"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "ASSAY_RESULTS_RECEIVED"
    Then patient should have specimen (field: "surgical_event_id" is "<sei>")
    And this specimen has following assay
      | biomarker   | result   | reported_date    | active |
      | <biomarker> | <result> | saved_time_value | true   |
    Examples:
      | patient_id            | sei                        | biomarker | result        |
      | PT_AS00_SlideShipped1 | PT_AS00_SlideShipped1_SEI1 | ICCPTENs  | POSITIVE      |
      | PT_AS00_SlideShipped2 | PT_AS00_SlideShipped2_SEI1 | ICCBAF47s | NEGATIVE      |
      | PT_AS00_SlideShipped4 | PT_AS00_SlideShipped4_SEI1 | ICCBRG1s  | INDETERMINATE |


@patients_p1 @patients_need_queue
  Scenario Outline: PT_AS00a. RB Assay message should be rejected before Variant Report is Uploaded
    Given patient id is "<patient_id>"
    And load template assay message for this patient
    Then set patient message field: "surgical_event_id" to value: "<sei>"
    Then set patient message field: "biomarker" to value: "<biomarker>"
    Then set patient message field: "result" to value: "<result>"
    Then set patient message field: "reported_date" to value: "current"
    When POST to MATCH patients service, response includes "rejected because it was not previously requested" with code "403"
    Examples:
      | patient_id            | sei                        | biomarker | result        |
      | PT_AS00a_SlideShipped | PT_AS00a_SlideShipped_SEI1 | ICCRBs    | NEGATIVE      |
      | PT_SC04d_NoAssay      | PT_SC04d_NoAssay_SEI1      | ICCRBs    | POSITIVE      |
      | PT_AS11SlideShipped   | PT_AS11SlideShipped_SEI1   | ICCRBs    | INDETERMINATE |


  @patients_p2 @patients_queueless
  Scenario Outline: PT_AS01. Assay result with invalid patient_id(empty, non-existing, null) should fail validation
    Given patient id is "<patient_id>"
    And load template assay message for this patient
    Then set patient message field: "biomarker" to value: "ICCPTENs"
    Then set patient message field: "surgical_event_id" to value: "PT_AS01_SEI1"
    When POST to MATCH patients service, response includes "<message>" with code "<status_code>"
    Examples:
      | patient_id  | message                            | status_code |
    #  |             | can't be blank                     | 500         |
    #  | null        | can't be blank                     | 500         |
      | abcd        | has not been registered with Match | 403         |


  @patients_p2 @patients_queueless
  Scenario Outline: PT_AS02. Assay result with invalid study_id(empty, non-existing, null) should fail
  #		Test data: Patient=PT_AS02_SlideShipped, with surgical_event_id=PT_AS02_SlideShipped_SEI1, slide_barcode=PT_AS02_SlideShipped_BC1
    Given patient id is "PT_AS02_SlideShipped"
    And load template assay message for this patient
    Then set patient message field: "biomarker" to value: "<biomarker>"
    Then set patient message field: "surgical_event_id" to value: "PT_AS02_SlideShipped_SEI1"
    Then set patient message field: "study_id" to value: "<value>"
    When POST to MATCH patients service, response includes "<message>" with code "403"
    Examples:
      | biomarker | value | message              |
      | ICCPTENs  |       | can't be blank       |
      | ICCBAF47s | other | not a valid study_id |
      | ICCRBs    | null  | can't be blank       |

  @patients_p2 @patients_queueless
  Scenario Outline: PT_AS03. Assay result with invalid surgical_event_id(empty, non-existing, non-active, from other patient, null) should fail
  #		Test data: Patient=PT_AS03_SlideShipped, with surgical_event_id=PT_AS03_SlideShipped_SEI1 and PT_AS03_SlideShipped_SEI2
    Given patient id is "PT_AS03_SlideShipped"
    And load template assay message for this patient
    Then set patient message field: "biomarker" to value: "<biomarker>"
    Then set patient message field: "surgical_event_id" to value: "<sei>"
    When POST to MATCH patients service, response includes "<message>" with code "403"
    Examples:
      | biomarker | sei                        | message           |
      | ICCPTENs  |                            | can't be blank    |
      | ICCPTENs  | SEI_NON                    | surgical event_id |
      | ICCBAF47s | PT_AS03_SlideShipped_SEI1  | surgical event_id |
      | ICCRBs    | PT_AS00_SlideShipped1_SEI1 | surgical event_id |
      | ICCBRG1s  | null                       | can't be blank    |

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

  @patients_p2 @patients_queueless
  Scenario Outline: PT_AS05. Assay result with invalid biomarker(other than ICCPTENs, ICCBRG1s, ICCRBs or ICCBAF47s) should fail
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

  @patients_p2 @patients_queueless
  Scenario Outline: PT_AS06. Assay result with invalid reported_date(empty, non-date, null) should fail
    Given patient id is "PT_AS06_SlideShipped"
    And load template assay message for this patient
    Then set patient message field: "biomarker" to value: "<biomarker>"
    Then set patient message field: "surgical_event_id" to value: "PT_AS06_SlideShipped_SEI1"
    Then set patient message field: "reported_date" to value: "<value>"
    When POST to MATCH patients service, response includes "<message>" with code "<code>"
    Examples:
      | biomarker | value                     | message        | code |
      | ICCPTENs  |                           | can't be blank | 403  |
      | ICCBRG1s  | nonDate                   | date           | 400  |
      | ICCBAF47s | null                      | can't be blank | 403  |
      | ICCRBs    | 2117-06-06T10:42:13+00:00 | before         | 403  |
#      #we don't check this
#      | 1997-06-06T10:42:13+00:00 | slide         | 403  |


  @patients_p2 @patients_queueless
  Scenario Outline: PT_AS07. Assay result with invalid result(other than POSITIVE, NEGATIVE or INDETERMINATE) should fail
    Given patient id is "PT_AS07_SlideShipped"
    And load template assay message for this patient
    Then set patient message field: "biomarker" to value: "<biomarker>"
    Then set patient message field: "surgical_event_id" to value: "PT_AS07_SlideShipped_SEI1"
    Then set patient message field: "result" to value: "<value>"
    When POST to MATCH patients service, response includes "<message>" with code "<code>"
    Examples:
      | biomarker | value       | message        | code |
      | ICCPTENs  |             | can't be blank | 403  |
      | ICCBRG1s  | otherResult | result         | 403  |
      | ICCBAF47s | null        | can't be blank | 403  |


#Logic tests:
  @patients_p2 @patients_queueless
  Scenario Outline: PT_AS08. Assay result received for patient who has no slide shipped (using same surgical_event_id) should fail
  #		Test data: Patient=PT_AS08_Registered, without slide shipment
  #		Patient=PT_AS08_TissueReceived, tissue received with surgical_event_id=PT_AS08_TissueReceived_SEI1, without slide shipment
  #       Patient=PT_AS08_SEI1HasSlideSEI2NoSlide, surgical_event_id=PT_AS08_SEI1HasSlideSEI2NoSlide_SEI1 has slide shipped, surgical_event_id=PT_AS08_SEI1HasSlideSEI2NoSlide_SEI2 has no slide shipment
    Given patient id is "<patient_id>"
    And load template assay message for this patient
    Then set patient message field: "biomarker" to value: "<biomarker>"
    Then set patient message field: "surgical_event_id" to value: "<sei>"
    Then set patient message field: "reported_date" to value: "current"
    When POST to MATCH patients service, response includes "<message>" with code "403"
    Examples:
      | patient_id                      | biomarker | sei                                  | message                       |
      | PT_AS08_Registered              | ICCPTENs  | SEI_NON                              | surgical event_id             |
      | PT_AS08_TissueReceived          | ICCBRG1s  | PT_AS08_TissueReceived_SEI1          | doesn't have a slide shipment |
      | PT_AS08_SEI1HasSlideSEI2NoSlide | ICCBAF47s | PT_AS08_SEI1HasSlideSEI2NoSlide_SEI2 | doesn't have a slide shipment |
      | PT_AS08_TsReceivedStep2         | ICCRBs    | PT_AS08_TsReceivedStep2_SEI2         | doesn't have a slide shipment |

  @patients_p3
  Scenario Outline: PT_AS09. Patient on some status shouldn't be able to receive assay result
    Given patient id is "<patient_id>"
    And load template assay message for this patient
    Then set patient message field: "biomarker" to value: "<biomarker>"
    Then set patient message field: "surgical_event_id" to value: "<sei>"
    When POST to MATCH patients service, response includes "<message>" with code "403"
    Examples:
      | patient_id              | biomarker | sei                          | message |
      | PT_AS09_ReqNoAssignment | ICCPTENs  | PT_AS09_ReqNoAssignment_SEI1 | status  |
      | PT_AS09_OffStudy        | ICCRBs    | PT_AS09_OffStudy_SEI1        | status  |
    #no bio expired any more
#      | PT_AS09_OffStudyBiopsyExpired | ICCPTENs  | PT_AS09_OffStudyBiopsyExpired_SEI1 | status  |
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
    Then set patient message field: "reported_date" to value: "current"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then wait until patient specimen is updated
    Then patient should have specimen (field: "surgical_event_id" is "PT_AS10SlideShipped_SEI1")
    And this specimen has following assay
      | biomarker | result   | reported_date    |
      | ICCBRG1s  | NEGATIVE | saved_time_value |

  @patients_p2 @patients_queueless
  Scenario: PT_AS10a. Assay result received for active surgical_event_id but doesn't belong to this patient should fail
  #  Test data: Patient=PT_AS10aSlideShipped1, sei=PT_AS10aSlideShipped1_SEI1,
  #             Patient=PT_AS10aSlideShipped2, sei=PT_AS10aSlideShipped2_SEI1,
    Given patient id is "PT_AS10aSlideShipped1"
    And load template assay message for this patient
    Then set patient message field: "biomarker" to value: "ICCPTENs"
    Then set patient message field: "surgical_event_id" to value: "PT_AS10bSlideShipped2_SEI1"
    When POST to MATCH patients service, response includes "surgical" with code "403"

  @patients_p1 @patients_need_queue
  Scenario Outline: PT_AS11. Assay result can be received multiple times with same surgical_event_id and the latest assay should be used
  #  Test data: Patient=PT_AS11SlideShipped, surgical_event_id=PT_AS11SlideShipped_SEI1, has slide shipped
    Given patient id is "PT_AS11SlideShipped"
    And load template assay message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_AS11SlideShipped_SEI1"
    Then set patient message field: "reported_date" to value: "current"
    Then set patient message field: "biomarker" to value: "<biomarker>"
    Then set patient message field: "result" to value: "<result>"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then wait until patient specimen is updated
    Then patient should have specimen (field: "surgical_event_id" is "PT_AS11SlideShipped_SEI1")
    And this specimen has following assay
      | biomarker   | result   | reported_date    |
      | <biomarker> | <result> | saved_time_value |
    And patient active tissue specimen field "<biomarker>_received_date" should be "saved_time_value"
    And patient active tissue specimen field "<biomarker>" should be "<result>"
    Examples:
      | biomarker | result        |
      | ICCPTENs  | POSITIVE      |
      | ICCBAF47s | NEGATIVE      |
      | ICCBRG1s  | POSITIVE      |
      | ICCPTENs  | NEGATIVE      |
      | ICCBAF47s | INDETERMINATE |
      | ICCBRG1s  | INDETERMINATE |


  @patients_p2 @demo_p1 @patients_need_queue
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
      | patient_id                   | patient_status         | sei                               |
      | PT_AS12_VrConfirmed          | PENDING_CONFIRMATION   | PT_AS12_VrConfirmed_SEI1          |
      | PT_AS12_VrReceived           | ASSAY_RESULTS_RECEIVED | PT_AS12_VrReceived_SEI1           |
      | PT_AS12_RbRequested          | ASSAY_RESULTS_RECEIVED | PT_AS12_RbRequested_SEI1          |
      | PT_AS12_RbRequestAndReceived | PENDING_CONFIRMATION   | PT_AS12_RbRequestAndReceived_SEI1 |

  @patients_p2 @demo_p1 @patients_need_queue
  Scenario Outline: PT_AS12a. assay result can be received and updated properly after assignment
    Given patient id is "<patient_id>"
    And load template assay message for this patient
    Then set patient message field: "surgical_event_id" to value: "<patient_id>_SEI1"
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
    Then set patient message field: "biomarker" to value: "ICCRBs"
    Then set patient message field: "reported_date" to value: "current"
    Then set patient message field: "result" to value: "POSITIVE"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then wait until patient is updated
    Then patient status should change to "<status>"
    And patient active tissue specimen field "ICCPTENs" should be "POSITIVE"
    And patient active tissue specimen field "ICCBAF47s" should be "POSITIVE"
    And patient active tissue specimen field "ICCBRG1s" should be "POSITIVE"
    And patient active tissue specimen field "ICCRBs" should be "POSITIVE"
    Then load template request assignment message for this patient
    And set patient message field: "rebiopsy" to value: "N"
    And set patient message field: "step_number" to value: "<step_number>"
    And patient API user authorization role is "PATIENT_MESSAGE_SENDER"
    When POST to MATCH patients service, response includes "<message>" with code "<code>"
    Then patient status should change to "PENDING_CONFIRMATION"
    Examples:
      | patient_id                  | status               | step_number | message          | code |
      | PT_AS12_PendingConfirmation | PENDING_CONFIRMATION | 1.0         | state validation | 403  |
      | PT_AS12_PendingApproval     | PENDING_APPROVAL     | 1.0         | successful       | 202  |
      | PT_AS12_OnTreatmentArm      | ON_TREATMENT_ARM     | 2.0         | successful       | 202  |

  @patients_p1 @patients_need_queue
  Scenario Outline: PT_AS12b. RB assay can be processed properly
    Given patient id is "<patient_id>"
    And load template assay message for this patient
    Then set patient message field: "surgical_event_id" to value: "<patient_id>_SEI1"
    Then set patient message field: "biomarker" to value: "ICCRBs"
    Then set patient message field: "reported_date" to value: "current"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then wait until patient is updated
    Then wait for "5" seconds
    Then patient status should change to "<patient_status>"
    Examples:
      | patient_id                  | patient_status         |
      | PT_AS12b_NoVr3Assay         | ASSAY_RESULTS_RECEIVED |
      | PT_AS12b_VrReceived3Assay   | ASSAY_RESULTS_RECEIVED |
      | PT_AS12b_VrConfirmed3Assay  | PENDING_CONFIRMATION   |
      | PT_AS12b_RbRequestedNoAssay | ASSAY_RESULTS_RECEIVED |
      | PT_AS12b_RbRequested2Assay  | ASSAY_RESULTS_RECEIVED |
      | PT_AS12b_RbRequest3Assay    | PENDING_CONFIRMATION   |

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
    And this specimen has following assay
      | biomarker   | result   | reported_date |
      | <biomarker> | <result> | <date>        |
    And patient active tissue specimen field "<biomarker>_received_date" should be "<date>"
    And patient active tissue specimen field "<biomarker>" should be "<result>"
    Examples:
      | biomarker | result   | date                      |
      | ICCPTENs  | POSITIVE | 2017-06-06T10:42:13+00:00 |
      | ICCPTENs  | NEGATIVE | 2017-06-06T10:42:13+00:00 |
      | ICCBAF47s | POSITIVE | 2017-06-06T11:42:13+00:00 |
      | ICCBAF47s | NEGATIVE | 2017-06-06T11:42:13+00:00 |
      | ICCBRG1s  | POSITIVE | 2017-06-06T11:42:13+00:00 |
      | ICCBRG1s  | NEGATIVE | 2017-06-06T11:42:13+00:00 |
      | ICCRBs    | POSITIVE | 2017-06-06T11:42:13+00:00 |
      | ICCRBs    | NEGATIVE | 2017-06-06T11:42:13+00:00 |

  @patients_p2 @demo_p1 @patients_need_queue
  Scenario Outline: PT_AS15. assay with older report date should be considered as old assay
    Given patient id is "PT_AS15_AssayReceived"
    And load template assay message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_AS15_AssayReceived_SEI1"
    Then set patient message field: "reported_date" to value: "<date2>"
    Then set patient message field: "biomarker" to value: "<biomarker>"
    Then set patient message field: "result" to value: "NEGATIVE"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then wait until patient specimen is updated
    Then patient should have specimen (field: "surgical_event_id" is "PT_AS15_AssayReceived_SEI1")
    And this specimen has following assay
      | biomarker   | result   | reported_date | active |
      | <biomarker> | POSITIVE | <date1>       | true   |
      | <biomarker> | NEGATIVE | <date2>       | false  |
    And patient active tissue specimen field "<biomarker>_received_date" should be "<date1>"
    And patient active tissue specimen field "<biomarker>" should be "POSITIVE"
    Examples:
      | biomarker | date2                     | date1                     |
      | ICCPTENs  | 2017-05-06T10:42:13+00:00 | 2017-08-06T10:42:13+00:00 |
      | ICCBAF47s | 2017-05-06T10:43:13+00:00 | 2017-08-06T10:43:13+00:00 |
      | ICCBRG1s  | 2017-05-06T10:44:13+00:00 | 2017-08-06T10:44:13+00:00 |
      | ICCRBs    | 2017-05-06T10:45:13+00:00 | 2017-08-06T10:45:13+00:00 |
