#encoding: utf-8
@specimen_received
Feature: Receive NCH specimen messages and consume the message within MATCH:

  @patients_p3
  Scenario: PT_SR01. Consume a specimen_received message for type "Blood" for a patient already registered in Match
    Given template specimen received message in type: "BLOOD" for patient: "PT_SR01_Registered", it has surgical_event_id: ""
    When post to MATCH patients service, returns a message that includes "processed successfully" with status "Success"
    Then patient should have a blood specimen within 15 seconds
    #Patient just consume the message and has the new specimen, but do not change status to BLOOD_...
#    Then patient field: "current_status" should have value: "BLOOD_SPECIMEN_RECEIVED" within 15 seconds

  @patients_p1
  Scenario: PT_SR02. Consume a specimen_received message for type "Tissue" for a patient already registered in Match
    Given template specimen received message in type: "TISSUE" for patient: "PT_SR02_Registered", it has surgical_event_id: "PT_SR02_Registered_SEI1"
    When post to MATCH patients service, returns a message that includes "processed successfully" with status "Success"
    Then patient field: "current_status" should have value: "TISSUE_SPECIMEN_RECEIVED" within 15 seconds
    Then patient should have specimen (field: "surgical_event_id" is "PT_SR02_Registered_SEI1") within 15 seconds
    Then this specimen has pathology status: "Y"

  @patients_p3
  Scenario: PT_SR03. "Blood" specimen received message with surgical_event_id should fail
    Given template specimen received message in type: "BLOOD" for patient: "PT_SR03_Registered", it has surgical_event_id: ""
    Then set patient message field: "surgical_event_id" to value: "PT_SR03_Registered_SEI1"
    When post to MATCH patients service, returns a message that includes "surgical event id" with status "Failure"

  @patients_p2
  Scenario: PT_SR04. "Tissue" specimen received message without surgical_event_id should fail
    Given template specimen received message in type: "TISSUE" for patient: "PT_SR04_Registered", it has surgical_event_id: "PT_SR04_Registered_SEI1"
    Then remove field: "surgical_event_id" from patient message
    When post to MATCH patients service, returns a message that includes "can't be blank" with status "Failure"

  @patients_p2
  Scenario: PT_SR05. Return error message when collection date is older than patient registration date
    Given template specimen received message in type: "TISSUE" for patient: "PT_SR05_Registered", it has surgical_event_id: "PT_SR05_Registered_SEI1"
    Then set patient message field: "collection_dt" to value: "1990-04-25"
    When post to MATCH patients service, returns a message that includes "date" with status "Failure"

    #this is not required anymore!!!!!!!!!!!!!!!
#  Scenario: PT_SR06. Return error message when received date is older than collection date
#    Given template specimen received message in type: "TISSUE" for patient: "PT_SR06_Registered"
#    Then set patient message field: "surgical_event_id" to value: "PT-SpecimenTest_SE_2"
#    Then set patient message field: "collection_dt" to value: "2016-04-25"
#    Then set patient message field: "received_dttm" to value: "2016-04-23T15:17:11+00:00"
#    When post to MATCH patients service, returns a message that includes "date" with status "Failure"

  @patients_p2
  Scenario: PT_SR07. Return error when specimen received message is received for non-existing patient
    Given template specimen received message in type: "TISSUE" for patient: "PT_NonExistingPatient", it has surgical_event_id: "PT_NonExistingPatient_SEI1"
    When post to MATCH patients service, returns a message that includes "not been registered" with status "Failure"

  @patients_p2
  Scenario Outline: PT_SR08. Return error message when invalid type (other than BLOOD or TISSUE) is received
    Given template specimen received message in type: "<specimen_type>" for patient: "PT_SR08_Registered", it has surgical_event_id: "PT_SR08_Registered_SEI1"
    Then set patient message field: "type" to value: "<specimen_type_value>"
    When post to MATCH patients service, returns a message that includes "<message>" with status "Failure"
    Examples:
      | specimen_type | specimen_type_value | message               |
      | TISSUE        | Tissue              | is not a support type |
      | BLOOD         | blood               | is not a support type |
      | TISSUE        |                     | can't be blank        |
      | BLOOD         | SLIDE               | is not a support type |

  @patients_p2
  Scenario Outline: PT_SR09. existing surgical event id should not be used again
      #test patient: PT_SR09_TsReceivedTwice: (_SEI1, _SEI2) have been received
    Given template specimen received message in type: "TISSUE" for patient: "PT_SR09_TsReceivedTwice", it has surgical_event_id: "<SEI>"
    Then set patient message field: "collection_dt" to value: "<collectTime>"
    When post to MATCH patients service, returns a message that includes "<message>" with status "<status>"
    Examples:
      | SEI                          | collectTime               | status  | message                |
      | PT_SR09_TsReceivedTwice_SEI1 | 2016-04-30 | Failure | same surgical event id |
      | PT_SR09_TsReceivedTwice_SEI2 | 2016-04-30 | Failure | same surgical event id |

  @patients_p2
  Scenario Outline: PT_SR10a. tissue specimen_received message can only be accepted when patient is in certain status
      #all test patients are using surgical event id SEI_01
    Given template specimen received message in type: "TISSUE" for patient: "<patient_id>", it has surgical_event_id: "<new_sei>"
    Then set patient message field: "collection_dt" to value: "2016-08-02"
    When post to MATCH patients service, returns a message that includes "<message>" with status "<status>"
    Examples:
      | patient_id               | new_sei                       | status  | message                |
      | PT_SR10_BdReceived       | PT_SR10_BdReceived_SEI2       | Success | processed successfully |
      | PT_SR10_TsVrReceived     | PT_SR10_TsVrReceived_SEI2     | Success | processed successfully |
      | PT_SR10_TsVRRejected     | PT_SR10_TsVRRejected_SEI2     | Success | processed successfully |
      | PT_SR10_PendingApproval2 | PT_SR10_PendingApproval2_SEI2 | Failure | cannot transition from |
      | PT_SR10_OnTreatmentArm   | PT_SR10_OnTreatmentArm_SEI2   | Failure | cannot transition from |
      | PT_SR10_ProgressReBioY   | PT_SR10_ProgressReBioY_SEI2   | Success | processed successfully |
      | PT_SR10_OffStudy         | PT_SR10_OffStudy_SEI2         | Failure | cannot transition from |
      #there is no “PATHOLOGY_REVIEWED” status anymore
#      | PT_SR10_UPathoReceived   | PT_SR10_UPathoReceived_SEI2   | Success | processed successfully |
#      | PT_SR10_NPathoReceived   | PT_SR10_NPathoReceived_SEI2   | Success | processed successfully |
#      | PT_SR10_YPathoReceived   | PT_SR10_YPathoReceived_SEI2   | Success | processed successfully |

  @patients_p3
  Scenario Outline: PT_SR10b. blood specimen_received message can only be accepted when patient is in certain status
    Given template specimen received message in type: "BLOOD" for patient: "<patient_id>", it has surgical_event_id: ""
    Then set patient message field: "collection_dt" to value: "today"
    When post to MATCH patients service, returns a message that includes "<message>" with status "<status>"
    Examples:
      | patient_id              | status  | message                |
      | PT_SR10_TsReceived      | Success | processed successfully |
      | PT_SR10_BdVRReceived    | Success | processed successfully |
      | PT_SR10_PendingApproval | Success | processed successfully |
      | PT_SR10_ProgressReBioY1 | Success | processed successfully |
      | PT_SR10_OffStudy2       | Failure | cannot transition from |
        #we don't confirm or reject BLOOD variant report anymore
#      | PT_SR10_BdVRRejected    | Success | processed successfully   |
#      | PT_SR10_BdVRConfirmed   | Failure | confirmed variant report |

  @patients_p2
  Scenario Outline: PT_SR11. Return error message when study_id is invalid
    Given template specimen received message in type: "<specimen_type>" for patient: "PT_SR11_Registered", it has surgical_event_id: "PT_SR11_Registered_SEI1"
    Then set patient message field: "<field>" to value: "<value>"
    When post to MATCH patients service, returns a message that includes "<message>" with status "Failure"
    Examples:
      | specimen_type | field    | value | message                 |
      | TISSUE        | study_id |       | can't be blank          |
      | BLOOD         | study_id |       | can't be blank          |
      | TISSUE        | study_id | OTHER | is not a valid study_id |

  @patients_p1
  Scenario: PT_SR12. new tissue specimen message cannot be received when there is one CONFIRMED tissue variant report
    #  Test patient: PT_SR12_VariantReportConfirmed: VR confirmed PT_SR12_VariantReportConfirmed_SEI1, PT_SR12_VariantReportConfirmed_MOI1, PT_SR12_VariantReportConfirmed_ANI1
    Given template specimen received message in type: "TISSUE" for patient: "PT_SR12_VariantReportConfirmed", it has surgical_event_id: "PT_SR12_VariantReportConfirmed_SEI2"
    When post to MATCH patients service, returns a message that includes "cannot transition from" with status "Failure"

  @patients_p1
  Scenario: PT_SR14a. When a new TISSUE specimen_received message is received,  the pending TISSUE variant report from the old Surgical event is set to "REJECTED" status
  #    Test patient: PT_SR14_TsVrUploaded; variant report files uploaded: PT_SR14_TsVrUploaded(_SEI1, _MOI1, _ANI1)
  #          Plan to receive new specimen surgical_event_id: PT_SR14_TsVrUploaded_SEI2
    Given template specimen received message in type: "TISSUE" for patient: "PT_SR14_TsVrUploaded", it has surgical_event_id: "PT_SR14_TsVrUploaded_SEI2"
    Then set patient message field: "collection_dt" to value: "2016-08-21"
    When post to MATCH patients service, returns a message that includes "processed successfully" with status "Success"
    Then patient field: "current_status" should have value: "TISSUE_SPECIMEN_RECEIVED" within 15 seconds
    Then patient should have variant report (analysis_id: "PT_SR14_TsVrUploaded_ANI1") within 15 seconds
    And this variant report has value: "REJECTED" in field: "status"

  @patients_p1
  Scenario: PT_SR14b. When a new BLOOD specimen_received message is received,  the pending TISSUE variant report should not change status
  #    Test patient: PT_SR14_TsVrUploaded1; variant report files uploaded: PT_SR14_BdVrUploaded(_BD_MOI1, _ANI1)
    Given template specimen received message in type: "BLOOD" for patient: "PT_SR14_TsVrUploaded1", it has surgical_event_id: ""
    Then set patient message field: "collection_dt" to value: "2016-08-21"
    When post to MATCH patients service, returns a message that includes "processed successfully" with status "Success"
    Then wait for "30" seconds
    Then patient should have variant report (analysis_id: "PT_SR14_TsVrUploaded1_ANI1") within 15 seconds
    And this variant report has value: "PENDING" in field: "status"

  @patients_p3
  Scenario: PT_SR14c. When a new BLOOD specimen_received message is received,  the pending BLOOD variant report from the old Surgical event is set to "REJECTED" status
  #    Test patient: PT_SR14_BdVrUploaded; variant report files uploaded: PT_SR14_BdVrUploaded(_BD_MOI1, _ANI1)
    Given template specimen received message in type: "BLOOD" for patient: "PT_SR14_BdVrUploaded", it has surgical_event_id: ""
    Then set patient message field: "collection_dt" to value: "2016-08-21"
    When post to MATCH patients service, returns a message that includes "processed successfully" with status "Success"
    Then wait for "30" seconds
    Then patient should have variant report (analysis_id: "PT_SR14_BdVrUploaded_ANI1") within 15 seconds
    And this variant report has value: "REJECTED" in field: "status"

  @patients_p1
  Scenario: PT_SR14d. When a new TISSUE specimen_received message is received,  the pending BLOOD variant report should not change status
    Given template specimen received message in type: "TISSUE" for patient: "PT_SR14_BdVrUploaded1", it has surgical_event_id: "PT_SR14_BdVrUploaded1_SEI1"
    Then set patient message field: "collection_dt" to value: "2016-08-21"
    When post to MATCH patients service, returns a message that includes "processed successfully" with status "Success"
    Then patient field: "current_status" should have value: "TISSUE_SPECIMEN_RECEIVED" within 15 seconds
    Then patient should have variant report (analysis_id: "PT_SR14_BdVrUploaded1_ANI1") within 15 seconds
    And this variant report has value: "PENDING" in field: "status"

  @patients_p3
  Scenario Outline: PT_SR13. extra key-value pair in the message body should NOT fail
    Given template specimen received message in type: "<type>" for patient: "PT_SR13_Registered", it has surgical_event_id: "<sei>"
    Then set patient message field: "extra_info" to value: "This is extra information"
    When post to MATCH patients service, returns a message that includes "processed successfully" with status "Success"
    Examples:
      | type   | sei                     |
      | TISSUE | PT_SR13_Registered_SEI1 |
      | BLOOD  |                         |

  @patients_p2
  Scenario: PT_SR14. new tissue specimen with a surgical_event_id that was used in previous step should fail
#    patient: "PT_SR14_RequestAssignment" with status: "REQUEST_ASSIGNMENT" on step: "2.0"
#    surgical_event_id PT_SR14_RequestAssignment_SEI1 has been used in step 1.0
    Given template specimen received message in type: "TISSUE" for patient: "PT_SR14_RequestAssignment", it has surgical_event_id: "PT_SR14_RequestAssignment_SEI1"
    When post to MATCH patients service, returns a message that includes "same surgical event id" with status "Failure"