#encoding: utf-8
@patients @specimen_received
Feature: Receive NCH specimen messages and consume the message within MATCH:

  Scenario: PT_SR01. Consume a specimen_received message for type "Blood" for a patient already registered in Match
    Given template specimen received message in type: "BLOOD" for patient: "PT_SR01_Registered", it has surgical_event_id: ""
    When post to MATCH patients service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "10" seconds
    Then retrieve patient: "PT_SR01_Registered" from API
    Then returned patient has value: "BLOOD_SPECIMEN_RECEIVED" in field: "current_status"

  Scenario: PT_SR02. Consume a specimen_received message for type "Tissue" for a patient already registered in Match
    Given template specimen received message in type: "TISSUE" for patient: "PT_SR02_Registered", it has surgical_event_id: "PT_SR02_Registered_SEI1"
    When post to MATCH patients service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "10" seconds
    Then retrieve patient: "PT_SR02_Registered" from API
    Then returned patient has value: "TISSUE_SPECIMEN_RECEIVED" in field: "current_status"

  Scenario: PT_SR03. "Blood" specimen received message with surgical_event_id should fail
    Given template specimen received message in type: "BLOOD" for patient: "PT_SR03_Registered", it has surgical_event_id: ""
    Then set patient message field: "surgical_event_id" to value: "PT_SR03_Registered_SEI1"
    When post to MATCH patients service, returns a message that includes "surgical event id" with status "Failure"

  Scenario: PT_SR04. "Tissue" specimen received message without surgical_event_id should fail
    Given template specimen received message in type: "TISSUE" for patient: "PT_SR04_Registered", it has surgical_event_id: "PT_SR04_Registered_SEI1"
    Then remove field: "surgical_event_id" from patient message
    When post to MATCH patients service, returns a message that includes "can't be blank" with status "Failure"

  Scenario: PT_SR05. Return error message when collection date is older than patient registration date
    Given template specimen received message in type: "TISSUE" for patient: "PT_SR05_Registered", it has surgical_event_id: "PT_SR05_Registered_SEI1"
    Then set patient message field: "collected_dttm" to value: "1990-04-25T15:17:11+00:00"
    When post to MATCH patients service, returns a message that includes "date" with status "Failure"

    #this is not required anymore!!!!!!!!!!!!!!!
#  Scenario: PT_SR06. Return error message when received date is older than collection date
#    Given template specimen received message in type: "TISSUE" for patient: "PT_SR06_Registered"
#    Then set patient message field: "surgical_event_id" to value: "PT-SpecimenTest_SE_2"
#    Then set patient message field: "collected_dttm" to value: "2016-04-25T15:17:11+00:00"
#    Then set patient message field: "received_dttm" to value: "2016-04-23T15:17:11+00:00"
#    When post to MATCH patients service, returns a message that includes "date" with status "Failure"

  Scenario: PT_SR07. Return error when specimen received message is received for non-existing patient
    Given template specimen received message in type: "TISSUE" for patient: "PT_NonExistingPatient", it has surgical_event_id: "PT_NonExistingPatient_SEI1"
    When post to MATCH patients service, returns a message that includes "not been registered" with status "Failure"


  Scenario Outline: PT_SR08. Return error message when invalid type (other than BLOOD or TISSUE) is received
    Given template specimen received message in type: "<specimen_type>" for patient: "PT_SR08_Registered", it has surgical_event_id: "PT_SR08_Registered_SEI1"
    Then set patient message field: "type" to value: "<specimen_type_value>"
    When post to MATCH patients service, returns a message that includes "<message>" with status "Failure"
    Examples:
    |specimen_type      |specimen_type_value|message                                                            |
    |TISSUE             |Tissue             |is not a support type           |
    |BLOOD              |blood              |is not a support type           |
    |TISSUE             |                   |can't be blank                  |
    |BLOOD              |SLIDE              |is not a support type           |

  Scenario Outline: PT_SR09. tissue can be received with new surgical event id but not with existing one
#  One possible scenario: specimen using same surgical_event_id with new received_date can be received again.
    Given template specimen received message in type: "TISSUE" for patient: "PT_SR09_Registered", it has surgical_event_id: "<SEI>"
    Then set patient message field: "collected_dttm" to value: "<collectTime>"
    Then wait for "<waitTime>" seconds
    When post to MATCH patients service, returns a message that includes "<message>" with status "<status>"
    Examples:
    |SEI                      |collectTime              |waitTime |status |message                                                                |
    |PT_SR09_Registered_SEI1  |2016-04-28T15:17:11+00:00|0        |Success|Message has been processed successfully                                |
    |PT_SR09_Registered_SEI1  |2016-04-30T15:17:11+00:00|10       |Failure|same surgical event id                                                 |
    |PT_SR09_Registered_SEI2  |2016-04-30T15:17:11+00:00|10       |Success|Message has been processed successfully                                |
    |PT_SR09_Registered_SEI1  |2016-05-02T15:17:11+00:00|10       |Failure|same surgical event id                                                 |

  Scenario Outline: PT_SR10a. tissue specimen_received message can only be accepted when patient is in certain status
    #all test patients are using surgical event id SEI_01
    Given template specimen received message in type: "TISSUE" for patient: "<patient_id>", it has surgical_event_id: "<new_sei>"
    Then set patient message field: "collected_dttm" to value: "2016-08-02T15:17:11+00:00"
    When post to MATCH patients service, returns a message that includes "<message>" with status "<status>"
    Examples:
    |patient_id              |new_sei                      |status     |message                                                                        |
    |PT_SR10_BdReceived      |PT_SR10_BdReceived_SEI2      |Success    |Message has been processed successfully                                      |
    |PT_SR10_UPathoReceived  |PT_SR10_UPathoReceived_SEI2  |Success    |Message has been processed successfully                                       |
    |PT_SR10_NPathoReceived  |PT_SR10_NPathoReceived_SEI2  |Success    |Message has been processed successfully                                       |
    |PT_SR10_YPathoReceived  |PT_SR10_YPathoReceived_SEI2  |Success    |Message has been processed successfully                                       |
    |PT_SR10_TsVrReceived    |PT_SR10_TsVrReceived_SEI2    |Success    |Message has been processed successfully                                       |
    |PT_SR10_TsVRRejected    |PT_SR10_TsVRRejected_SEI2    |Success    |Message has been processed successfully                                      |
#    |PT_SR10_OnTreatmentArm   |PT_SR10_OnTreatmentArm_SEI2  |Failure    |cannot transition from                                                       |
#    |PT_SR10_ProgressReBioY   |PT_SR10_ProgressReBioY_SEI2  |Success    |Message has been processed successfully                                      |
#    |PT_SR10_ProgressReBioN   |PT_SR10_ProgressReBioN_SEI2  |Failure    |cannot transition from                                                       |
#    |PT_SR10_OffStudy         |PT_SR10_OffStudy_SEI2        |Failure    |cannot transition from                                                       |


  Scenario Outline: PT_SR10b. blood specimen_received message can only be accepted when patient is in certain status
    Given template specimen received message in type: "BLOOD" for patient: "<patient_id>", it has surgical_event_id: ""
    Then set patient message field: "collected_dttm" to value: "current"
    When post to MATCH patients service, returns a message that includes "<message>" with status "<status>"
    Examples:
    |patient_id             |status     |message                                                                        |
    |PT_SR10_TsReceived     |Success    |Message has been processed successfully                                      |
    |PT_SR10_BdVRReceived   |Success    |Message has been processed successfully                                      |
    |PT_SR10_BdVRRejected   |Success    |Message has been processed successfully                                      |
    |PT_SR10_BdVRConfirmed  |Failure    |confirmed variant report                                                     |
#    |PT_SR10_PendingApproval|Success    |Message has been processed successfully                                      |
#    |PT_SR10_ProgressReBioY2|TISSUE          |Success    |Message has been processed successfully                                      |
#    |PT_SR10_ProgressReBioN2|TISSUE          |Failure    |cannot transition from                                                       |
#    |PT_SR10_OffStudy       |Failure    |cannot transition from                                                       |

  Scenario Outline: PT_SR11. Return error message when study_id is invalid
    Given template specimen received message in type: "<specimen_type>" for patient: "PT_SR11_Registered", it has surgical_event_id: "PT_SR11_Registered_SEI1"
    Then set patient message field: "<field>" to value: "<value>"
    When post to MATCH patients service, returns a message that includes "<message>" with status "Failure"
    Examples:
    |specimen_type  |field              |value            |message                                                        |
    |TISSUE         |study_id           |                 |can't be blank                        |
    |BLOOD          |study_id           |                 |can't be blank                        |
    |TISSUE         |study_id           |OTHER            |is not a valid study_id            |


Scenario: PT_SR12. new tissue cannot be received when there is one tissue variant report get "CONFIRMED"
#  Test patient: PT_SR12_VariantReportConfirmed: VR confirmed PT_SR12_VariantReportConfirmed_SEI1, PT_SR12_VariantReportConfirmed_MOI1, PT_SR12_VariantReportConfirmed_ANI1
  Given template specimen received message in type: "TISSUE" for patient: "PT_SR12_VariantReportConfirmed", it has surgical_event_id: "PT_SR12_VariantReportConfirmed_SEI2"
  When post to MATCH patients service, returns a message that includes "cannot transition from" with status "Failure"

Scenario: PT_SR14. new specimen using new SEI will push all pending variant report from old SEI to "REJECT"
#    Test patient: PT_SR14_VariantReportUploaded; variant report files uploaded: surgical_event_id: PT_SR14_VariantReportUploaded_SEI1, molecular_id: PT_SR14_VariantReportUploaded_MOI1, analysis_id: PT_SR14_VariantReportUploaded_ANI1
#          Plan to receive new specimen surgical_event_id: SEI_02
  Given template specimen received message in type: "TISSUE" for patient: "PT_SR14_VariantReportUploaded", it has surgical_event_id: "PT_SR14_VariantReportUploaded_SEI2"
  Then set patient message field: "collected_dttm" to value: "2016-08-21T14:20:02-04:00"
  When post to MATCH patients service, returns a message that includes "Message has been processed successfully" with status "Success"
  Then wait for "15" seconds
  Then retrieve patient: "PT_SR14_VariantReportUploaded" from API
  Then returned patient has value: "TISSUE_SPECIMEN_RECEIVED" in field: "current_status"
  Then returned patient has variant report (surgical_event_id: "PT_SR14_VariantReportUploaded_SEI1", molecular_id: "PT_SR14_VariantReportUploaded_MOI1", analysis_id: "PT_SR14_VariantReportUploaded_ANI1")
  And this variant report has value: "REJECTED" in field: "status"

  #data not ready
#Scenario: PT_SR13. new tissue with a surgical_event_id that was used in previous step should fail
## Test patient: PT_SR13_Step2Started: surgical event id: PT_SR13_Step2Started_SEI1 has been used in step 1
#  Given template specimen received message in type: "TISSUE" for patient: "PT_SR13_Step2Started", it has surgical_event_id: "PT_SR13_Step2Started_SEI1"
#  Then set patient message field: "collected_dttm" to value: "current"
#  When post to MATCH patients service, returns a message that includes "same surgical event id" with status "Failure"