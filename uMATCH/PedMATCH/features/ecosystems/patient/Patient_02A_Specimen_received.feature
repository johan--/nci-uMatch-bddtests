#encoding: utf-8
@specimen_received
Feature: NCH specimen received messages

  Background:
    Given patient API user authorization role is "SPECIMEN_MESSAGE_SENDER"

  @patients_p3
  Scenario: PT_SR01. blood specimen received message can be processed properly
    Given patient id is "PT_SR01_Registered"
    And load template specimen type: "BLOOD" received message for this patient
    Then set patient message field: "collection_dt" to value: "today"
    Then set patient message field: "received_dttm" to value: "current"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then wait until patient specimen is updated
    Then patient should have 1 blood specimens
    #Patient just consume the message and has the new specimen, but do not change status to BLOOD_...
#    Then patient field: "current_status" should have value: "BLOOD_SPECIMEN_RECEIVED" within 15 seconds

  @patients_p1 @patients_need_queue
  Scenario: PT_SR02. tissue specimen received message can be proccessed properly
    Given patient id is "PT_SR02_Registered"
    And load template specimen type: "TISSUE" received message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_SR02_Registered_SEI1"
    Then set patient message field: "collection_dt" to value: "today"
    Then set patient message field: "received_dttm" to value: "current"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "TISSUE_SPECIMEN_RECEIVED"
    Then patient should have specimen (field: "surgical_event_id" is "PT_SR02_Registered_SEI1")

  @patients_p2 @patients_need_queue
  Scenario: PT_SR02b. specimen_received message should not be processed twice if sent twice quickly
    Given patient id is "PT_SR02b_Registered"
    And load template specimen type: "TISSUE" received message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_SR02b_Registered_SEI1"
    Then set patient message field: "collection_dt" to value: "today"
    Then set patient message field: "received_dttm" to value: "current"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    When POST to MATCH patients service
    Then patient status should change to "TISSUE_SPECIMEN_RECEIVED"
    Then wait for "30" seconds
    Then patient should have one specimen with surgical_event_id "PT_SR02b_Registered_SEI1"

  @patients_p3
  Scenario: PT_SR03. "Blood" specimen received message with surgical_event_id should fail
    Given patient id is "PT_SR03_Registered"
    And load template specimen type: "BLOOD" received message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_SR03_Registered_SEI1"
    When POST to MATCH patients service, response includes "surgical event id" with code "403"

  @patients_p2 @patients_queueless
  Scenario: PT_SR04. "Tissue" specimen received message without surgical_event_id should fail
    Given patient id is "PT_SR04_Registered"
    And load template specimen type: "TISSUE" received message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_SR04_Registered_SEI1"
    Then remove field: "surgical_event_id" from patient message
    When POST to MATCH patients service, response includes "can't be blank" with code "403"

#  this is not required anymore!!!!!!!!!!!!!!!
#  @patients_p2
#  Scenario: PT_SR05. Return error message when collection date is older than patient registration date
#    Given patient id is "PT_SR05_Registered"
#    And load template specimen type: "BLOOD" received message for this patient (type: "TISSUE", surgical_event_id: "PT_SR05_Registered_SEI1")
#    Then set patient message field: "collection_dt" to value: "1990-04-25"
#    When POST to MATCH patients service, response includes "date" with code "403"

    #this is not required anymore!!!!!!!!!!!!!!!
#  @patients_p2
#  Scenario: PT_SR06. Return error message when collection date is older than 6 months ago
#    Given patient id is "PT_SR06_Registered"
#    And load template specimen type: "BLOOD" received message for this patient (type: "TISSUE", surgical_event_id: "PT_SR06_Registered_SEI1")
#    Then set patient message field: "collection_dt" to value: "2016-04-25"
#    When POST to MATCH patients service, response includes "6 months" with code "403"

    #this is not required anymore!!!!!!!!!!!!!!!
#  Scenario: PT_SR06. Return error message when received date is older than collection date
#    And template specimen received message in type: "TISSUE" for patient: "PT_SR06_Registered"
#    Then set patient message field: "surgical_event_id" to value: "PT-SpecimenTest_SE_2"
#    Then set patient message field: "collection_dt" to value: "2016-04-25"
#    Then set patient message field: "received_dttm" to value: "2016-04-23T15:17:11+00:00"
#    When POST to MATCH patients service, response includes "date" with status "Failure"

  @patients_p2 @patients_queueless
  Scenario Outline: PT_SR07. Return error when specimen received message is received for non-existing patient
    Given patient id is "PT_NonExistingPatient"
    And load template specimen type: "<type>" received message for this patient
    Then set patient message field: "surgical_event_id" to value: "<sei>"
    When POST to MATCH patients service, response includes "not been registered" with code "403"
    Examples:
      | type   | sei                        |
      | TISSUE | PT_NonExistingPatient_SEI1 |
      | BLOOD  |                            |

  @patients_p3
  Scenario Outline: PT_SR08. Return error message when invalid type (other than BLOOD or TISSUE) is received
    Given patient id is "PT_SR08_Registered"
    And load template specimen type: "<specimen_type>" received message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_SR08_Registered_SEI1"
    Then set patient message field: "type" to value: "<specimen_type_value>"
    When POST to MATCH patients service, response includes "<message>" with code "403"
    Examples:
      | specimen_type | specimen_type_value | message               |
      | TISSUE        | Tissue              | is not a support type |
      | BLOOD         | blood               | is not a support type |
      | TISSUE        |                     | can't be blank        |
      | BLOOD         | SLIDE               | is not a support type |

  @patients_p2 @patients_queueless
  Scenario Outline: PT_SR09. existing surgical event id should not be used again
      #test patient: PT_SR09_TsReceivedTwice: (_SEI1, _SEI2) have been received
    #notice the response code 202 for PT_SR09_TsReceivedTwice_SEI2, it's NCH's requirement, they want to receive
    #multiple tissues with same surgical event id, but they don't care which one is taken, so that means we just
    #response 202 but don't process the new ones
    Given patient id is "<patient_id>"
    And load template specimen type: "TISSUE" received message for this patient
    Then set patient message field: "surgical_event_id" to value: "<sei>"
    Then set patient message field: "collection_dt" to value: "<collectTime>"
    Then set patient message field: "received_dttm" to value: "2016-04-30T15:17:11+00:00"
    When POST to MATCH patients service, response includes "<message>" with code "<code>"
    Examples:
      | patient_id              | sei                          | collectTime | message           | code |
      | PT_SR09_TsReceivedTwice | PT_SR09_TsReceivedTwice_SEI1 | 2016-04-30  | surgical_event_id | 403  |
      | PT_SR09_TsReceivedTwice | PT_SR09_TsReceivedTwice_SEI2 | 2016-04-30  | success           | 202  |
      | PT_SR09_Registered      | PT_SR09_TsReceivedTwice_SEI1 | 2016-04-30  | surgical_event_id | 403  |
      | PT_SR09_Registered      | PT_SR09_TsReceivedTwice_SEI2 | 2016-04-30  | surgical_event_id | 403  |

  @patients_p2 @patients_queueless
  Scenario Outline: PT_SR10a. tissue specimen_received message can only be accepted when patient is in certain status
      #all test patients are using surgical event id SEI_01
    Given patient id is "<patient_id>"
    And load template specimen type: "TISSUE" received message for this patient
    Then set patient message field: "surgical_event_id" to value: "<new_sei>"
    Then set patient message field: "collection_dt" to value: "today"
    Then set patient message field: "received_dttm" to value: "current"
    When POST to MATCH patients service, response includes "<message>" with code "<http_code>"
    Examples:
      | patient_id                  | new_sei                          | http_code | message                |
      | PT_SR10_BdReceived          | PT_SR10_BdReceived_SEI2          | 202       | processed successfully |
      | PT_SR10_TsVrReceived        | PT_SR10_TsVrReceived_SEI2        | 202       | processed successfully |
      | PT_SR10_TsVRRejected        | PT_SR10_TsVRRejected_SEI2        | 202       | processed successfully |
      | PT_SR10_PendingConfirmation | PT_SR10_PendingConfirmation_SEI2 | 403       | cannot transition from |
      | PT_SR10_PendingApproval2    | PT_SR10_PendingApproval2_SEI2    | 403       | cannot transition from |
      | PT_SR10_OnTreatmentArm      | PT_SR10_OnTreatmentArm_SEI2      | 403       | cannot transition from |
      | PT_SR10_ProgressReBioY      | PT_SR10_ProgressReBioY_SEI2      | 202       | processed successfully |
      | PT_SR10_OffStudy            | PT_SR10_OffStudy_SEI2            | 403       | cannot transition from |
      | PT_SR10_NoTaAvailable       | PT_SR10_NO_TA_AVAILABLE_SEI2     | 403       | cannot transition from |
      | PT_SR10_CompassionateCare   | PT_SR10_COMPASSIONATE_CARE_SEI2  | 403       | cannot transition from |
      #there is no “PATHOLOGY_REVIEWED” status anymore
#      | PT_SR10_UPathoReceived   | PT_SR10_UPathoReceived_SEI2   | Success | processed successfully |
#      | PT_SR10_NPathoReceived   | PT_SR10_NPathoReceived_SEI2   | Success | processed successfully |
#      | PT_SR10_YPathoReceived   | PT_SR10_YPathoReceived_SEI2   | Success | processed successfully |

  @patients_p2 @patients_queueless
  Scenario Outline: PT_SR10b. blood specimen_received message can only be accepted when patient is in certain status
    Given patient id is "<patient_id>"
    And load template specimen type: "BLOOD" received message for this patient
    Then set patient message field: "collection_dt" to value: "today"
    Then set patient message field: "received_dttm" to value: "current"
    When POST to MATCH patients service, response includes "<message>" with code "<http_code>"
    Examples:
      | patient_id                  | http_code | message                  |
      | PT_SR10_TsReceived          | 202       | success                  |
      | PT_SR10_BdVRReceived        | 202       | success                  |
      | PT_SR10_PendingConfirmation | 202       | success                  |
      | PT_SR10_PendingApproval     | 202       | success                  |
      | PT_SR10_OnTreatmentArm      | 202       | success                  |
      | PT_SR10_ProgressReBioY1     | 202       | success                  |
      | PT_SR10_OffStudy2           | 403       | cannot transition from   |
      | PT_SR10_BdVRRejected        | 202       | success                  |
      | PT_SR10_BdVRConfirmed       | 403       | confirmed variant report |
      | PT_SR10_NoTaAvailable       | 202       | success                  |
      | PT_SR10_CompassionateCare   | 202       | success                  |

  @patients_p2 @patients_queueless
  Scenario Outline: PT_SR11. Return error message when study_id is invalid
    Given patient id is "PT_SR11_Registered"
    And load template specimen type: "<specimen_type>" received message for this patient
    Then set patient message field: "surgical_event_id" to value: "<sei>"
    Then set patient message field: "<field>" to value: "<value>"
    When POST to MATCH patients service, response includes "<message>" with code "403"
    Examples:
      | specimen_type | field    | value | message                 | sei                     |
      | TISSUE        | study_id |       | can't be blank          | PT_SR11_Registered_SEI1 |
      | BLOOD         | study_id |       | can't be blank          |                         |
      | TISSUE        | study_id | OTHER | is not a valid study_id | PT_SR11_Registered_SEI1 |

  @patients_p1 @patients_queueless
  Scenario Outline: PT_SR12. new tissue specimen message cannot be received when there is one CONFIRMED tissue variant report
    #  Test patient: PT_SR12_VariantReportConfirmed: VR confirmed PT_SR12_VariantReportConfirmed_SEI1, PT_SR12_VariantReportConfirmed_MOI1, PT_SR12_VariantReportConfirmed_ANI1
    Given patient id is "<patient_id>"
    And load template specimen type: "TISSUE" received message for this patient
    Then set patient message field: "surgical_event_id" to value: "<patient_id>_SEI2"
    When POST to MATCH patients service, response includes "cannot transition from" with code "403"
    Examples:
      | patient_id                     |
      | PT_SR12_VariantReportConfirmed |
      | PT_SR12_RbRequested            | new

  @patients_p1 @patients_need_queue
  Scenario: PT_SR14a. When a new TISSUE specimen_received message is received,  the pending TISSUE variant report from the old Surgical event is set to "REJECTED" status
  #    Test patient: PT_SR14_TsVrUploaded; variant report files uploaded: PT_SR14_TsVrUploaded(_SEI1, _MOI1, _ANI1)
  #          Plan to receive new specimen surgical_event_id: PT_SR14_TsVrUploaded_SEI2
    Given patient id is "PT_SR14_TsVrUploaded"
    And load template specimen type: "TISSUE" received message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_SR14_TsVrUploaded_SEI2"
    Then set patient message field: "collection_dt" to value: "today"
    Then set patient message field: "received_dttm" to value: "current"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "TISSUE_SPECIMEN_RECEIVED"
    Then patient should have variant report (analysis_id: "PT_SR14_TsVrUploaded_ANI1")
    And this variant report field: "status" should be "REJECTED"

  @patients_p1 @patients_need_queue
  Scenario: PT_SR14b. When a new BLOOD specimen_received message is received,  the pending TISSUE variant report should not change status
  #    Test patient: PT_SR14_TsVrUploaded1; variant report files uploaded: PT_SR14_BdVrUploaded(_BD_MOI1, _ANI1)
    Given patient id is "PT_SR14_TsVrUploaded1"
    And load template specimen type: "BLOOD" received message for this patient
    Then set patient message field: "collection_dt" to value: "today"
    Then set patient message field: "received_dttm" to value: "current"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then wait for "30" seconds
    Then patient should have variant report (analysis_id: "PT_SR14_TsVrUploaded1_ANI1")
    And this variant report field: "status" should be "PENDING"

  @patients_p2 @patients_need_queue
  Scenario: PT_SR14c. When a new BLOOD specimen_received message is received,  the pending BLOOD variant report from the old Surgical event is set to "REJECTED" status
  #    Test patient: PT_SR14c_BdVrUploaded; variant report files uploaded: PT_SR14c_BdVrUploaded(_BD_MOI1, _ANI1)
    Given patient id is "PT_SR14c_BdVrUploaded"
    And load template specimen type: "BLOOD" received message for this patient
    Then set patient message field: "collection_dt" to value: "today"
    Then set patient message field: "received_dttm" to value: "current"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then wait until patient specimen is updated
    Then patient should have variant report (analysis_id: "PT_SR14c_BdVrUploaded_BD_ANI1")
    And this variant report field: "status" should be "REJECTED"

  @patients_p1 @patients_need_queue
  Scenario: PT_SR14d. When a new TISSUE specimen_received message is received,  the pending BLOOD variant report should not change status
    Given patient id is "PT_SR14d_BdVrUploaded"
    And load template specimen type: "TISSUE" received message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_SR14d_BdVrUploaded_SEI1"
    Then set patient message field: "collection_dt" to value: "today"
    Then set patient message field: "received_dttm" to value: "current"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "TISSUE_SPECIMEN_RECEIVED"
    Then patient should have variant report (analysis_id: "PT_SR14d_BdVrUploaded_BD_ANI1")
    And this variant report field: "status" should be "PENDING"

  @patients_p3
  Scenario Outline: PT_SR13. extra key-value pair in the message body should NOT fail
    Given patient id is "PT_SR13_Registered"
    And load template specimen type: "<type>" received message for this patient
    Then set patient message field: "surgical_event_id" to value: "<sei>"
    Then set patient message field: "extra_info" to value: "This is extra information"
    Then set patient message field: "collection_dt" to value: "today"
    Then set patient message field: "received_dttm" to value: "current"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Examples:
      | type   | sei                     |
      | TISSUE | PT_SR13_Registered_SEI1 |
      | BLOOD  |                         |

  @patients_p2 @patients_queueless
  Scenario: PT_SR14. new tissue specimen with a surgical_event_id that was used in previous step should fail
#    patient: "PT_SR14_RequestAssignment" with status: "REQUEST_ASSIGNMENT" on step: "2.0"
#    surgical_event_id PT_SR14_RequestAssignment_SEI1 has been used in step 1.0
    Given patient id is "PT_SR14_RequestAssignment"
    And load template specimen type: "TISSUE" received message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_SR14_RequestAssignment_SEI1"
    When POST to MATCH patients service, response includes "surgical_event_id" with code "403"

  @patients_p2 @patients_need_queue
  Scenario: PT_SR15. when a new tissue specimen is received before variant report confirmed, the failed_date of last specimen should be set properly
    Given patient id is "PT_SR15_TsShipped"
    And load template specimen type: "TISSUE" received message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_SR15_TsShipped_SEI2"
    Then set patient message field: "collection_dt" to value: "today"
    Then set patient message field: "received_dttm" to value: "current"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then wait until patient specimen is updated
    Then patient should have specimen (field: "surgical_event_id" is "PT_SR15_TsShipped_SEI2")
    Then patient should have specimen (field: "surgical_event_id" is "PT_SR15_TsShipped_SEI1")
    Then this specimen should have a correct failed_date


  @patients_p2 @patients_need_queue
  Scenario: PT_SR16. when a new tissue specimen is received after variant report confirmed, the failed_date of last specimen should not be set
    Given patient id is "PT_SR16_PendingApproval"
    And load template request assignment message for this patient
    Then set patient message field: "rebiopsy" to value: "Y"
    Then set patient message field: "step_number" to value: "1.0"
    Then patient API user authorization role is "PATIENT_MESSAGE_SENDER"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "REQUEST_ASSIGNMENT"
    And load template specimen type: "TISSUE" received message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_SR16_PendingApproval_SEI2"
    Then set patient message field: "collection_dt" to value: "today"
    Then set patient message field: "received_dttm" to value: "current"
    Then patient API user authorization role is "SPECIMEN_MESSAGE_SENDER"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "TISSUE_SPECIMEN_RECEIVED"
    Then patient should have specimen (field: "surgical_event_id" is "PT_SR16_PendingApproval_SEI2")
    Then patient should have specimen (field: "surgical_event_id" is "PT_SR16_PendingApproval_SEI1")
    And this specimen field: "failed_date" should be: "null"

  @patients_p2 @patients_need_queue
  Scenario: PT_SR17. Leading or ending whitespace in surgical event id value should be ignored
    Given patient id is "PT_SR17_Registered"
    And load template specimen type: "TISSUE" received message for this patient
    Then set patient message field: "surgical_event_id" to value: " PT_SR17_Registered_SEI1"
    Then set patient message field: "collection_dt" to value: "today"
    Then set patient message field: "received_dttm" to value: "current"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "TISSUE_SPECIMEN_RECEIVED"
    Then patient should have specimen (field: "surgical_event_id" is "PT_SR17_Registered_SEI1")
    Then set patient message field: "surgical_event_id" to value: "PT_SR17_Registered_SEI2 "
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then wait until patient specimen is updated
    Then patient should have specimen (field: "surgical_event_id" is "PT_SR17_Registered_SEI2")