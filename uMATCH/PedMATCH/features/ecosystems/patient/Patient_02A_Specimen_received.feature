#encoding: utf-8
@specimen_received #@patients
Feature: Receive NCH specimen messages and consume the message within MATCH:

  Scenario: PT_SR01. Consume a specimen_received message for type "Blood" for a patient already registered in Match
    Given template specimen received message in type: "BLOOD" for patient: "PT_SR01_Registered"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"

  Scenario: PT_SR02. Consume a specimen_received message for type "Tissue" for a patient already registered in Match
    Given template specimen received message in type: "TISSUE" for patient: "PT_SR02_Registered"
    Then set patient message field: "surgical_event_id" to value: "PT-SpecimenTest_SE_1"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"

  Scenario: PT_SR03. "Blood" specimen received message with surgical_event_id should fail
    Given template specimen received message in type: "BLOOD" for patient: "PT_SR03_Registered"
    Then set patient message field: "surgical_event_id" to value: "SEI-001"
    When posted to MATCH patient trigger service, returns a message that includes "TBD" with status "Failure"

  Scenario: PT_SR04. "Tissue" specimen received message without surgical_event_id should fail
    Given template specimen received message in type: "TISSUE" for patient: "PT_SR04_Registered"
    Then remove field: "surgical_event_id" from patient message
    When posted to MATCH patient trigger service, returns a message that includes "cannot transition from" with status "Failure"

  Scenario: PT_SR05. Return error message when collection date is older than patient registration date
    Given template specimen received message in type: "TISSUE" for patient: "PT_SR05_Registered"
    Then set patient message field: "surgical_event_id" to value: "PT-SpecimenTest_SE_2"
    Then set patient message field: "collected_dttm" to value: "1990-04-25T15:17:11+00:00"
    When posted to MATCH patient trigger service, returns a message that includes "date" with status "Failure"

  Scenario: PT_SR06. Return error message when received date is older than collection date
    Given template specimen received message in type: "TISSUE" for patient: "PT_SR06_Registered"
    Then set patient message field: "surgical_event_id" to value: "PT-SpecimenTest_SE_2"
    Then set patient message field: "collected_dttm" to value: "2016-04-25T15:17:11+00:00"
    Then set patient message field: "received_dttm" to value: "2016-04-23T15:17:11+00:00"
    When posted to MATCH patient trigger service, returns a message that includes "date" with status "Failure"

  Scenario: PT_SR07. Return error when specimen received message is received for non-existing patient
    Given template specimen received message in type: "TISSUE" for patient: "PT_NonExistingPatient"
    When posted to MATCH patient trigger service, returns a message that includes "cannot transition from" with status "Failure"


  Scenario Outline: PT_SR08. Return error message when invalid type (other than BLOOD or TISSUE) is received
    Given template specimen received message in type: "<specimen_type>" for patient: "PT_SR08_Registered"
    Then set patient message field: "type" to value: "<specimen_type_value>"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
    |specimen_type      |specimen_type_value|message                                                            |
    |TISSUE             |Tissue             |did not match one of the following values: BLOOD, TISSUE           |
    |BLOOD              |blood              |did not match one of the following values: BLOOD, TISSUE           |
    |TISSUE             |                   |was not of a minimum string length of 1                            |
    |BLOOD              |SLIDE              |did not match one of the following values: BLOOD, TISSUE           |

  Scenario Outline: PT_SR09. tissue can be received with new surgical event id but not with existing one
#  One possible scenario: specimen using same surgical_event_id with new received_date can be received again.
    Given template specimen received message in type: "TISSUE" for patient: "PT_SR09_Registered"
    Then set patient message field: "surgical_event_id" to value: "<SEI>"
    Then set patient message field: "collected_dttm" to value: "<collectTime>"
    Then set patient message field: "received_dttm" to value: "<receivedTime>"
    Then wait for "<waitTime>" seconds
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "<status>"
    Examples:
    |SEI            |collectTime              |receivedTime             |waitTime |status |message                                                                |
    |SEI_TR_1       |2016-04-28T15:17:11+00:00|2016-04-29T15:17:11+00:00|0        |Success|Message has been processed successfully                                |
    |SEI_TR_1       |2016-04-30T15:17:11+00:00|2016-05-01T15:17:11+00:00|10       |Failure|cannot transition from                                                 |
    |SEI_TR_2       |2016-04-30T15:17:11+00:00|2016-05-01T15:17:11+00:00|10       |Success|Message has been processed successfully                                |

  Scenario Outline: PT_SR10a. tissue specimen_received message can only be accepted when patient is in certain status
    #all test patients are using surgical event id SEI_01
    Given template specimen received message in type: "TISSUE" for patient: "<patient_id>"
    Then set patient message field: "surgical_event_id" to value: "SEI_02"
    Then set patient message field: "collected_dttm" to value: "current"
    Then set patient message field: "received_dttm" to value: "current"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "<status>"
    Examples:
    |patient_id             |specimen_type  |status     |message                                                                        |
    |PT_SR10_BdReceived     |TISSUE          |Success    |Message has been processed successfully                                      |
    |PT_SR10_UPathoReceived |TISSUE          |Success    |Message has been processed successfully                                       |
    |PT_SR10_NPathoReceived |TISSUE          |Success    |Message has been processed successfully                                       |
    |PT_SR10_YPathoReceived |TISSUE          |Success    |Message has been processed successfully                                       |
    |PT_SR10_TsVrReceived   |TISSUE          |Success    |Message has been processed successfully                                       |
    |PT_SR10_TsVRRejected   |TISSUE          |Success    |Message has been processed successfully                                      |
#    |PT_SR10_OnTreatmentArm |TISSUE          |Failure    |cannot transition from                                                       |
#    |PT_SR10_ProgressReBioY |TISSUE          |Success    |Message has been processed successfully                                      |
#    |PT_SR10_ProgressReBioN |TISSUE          |Failure    |cannot transition from                                                       |
#    |PT_SR10_OffStudy       |TISSUE          |Failure    |cannot transition from                                                       |


  Scenario Outline: PT_SR10b. blood specimen_received message can only be accepted when patient is in certain status
    Given template specimen received message in type: "BLOOD" for patient: "<patient_id>"
    Then set patient message field: "collected_dttm" to value: "current"
    Then set patient message field: "received_dttm" to value: "current"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "<status>"
    Examples:
    |patient_id             |status     |message                                                                        |
    |PT_SR10_TsReceived     |Success    |Message has been processed successfully                                      |
    |PT_SR10_BdVRReceived   |Success    |Message has been processed successfully                                      |
    |PT_SR10_BdVRRejected   |Success    |Message has been processed successfully                                      |
    |PT_SR10_BdVRConfirmed  |Failure    |cannot transition from                                                       |
#    |PT_SR10_WaitingPtData  |Success    |Message has been processed successfully                                      |
#    |PT_SR10_PendingApproval|Success    |Message has been processed successfully                                      |
#    |PT_SR10_ProgressReBioY2|TISSUE          |Success    |Message has been processed successfully                                      |
#    |PT_SR10_ProgressReBioN2|TISSUE          |Failure    |cannot transition from                                                       |
#    |PT_SR10_OffStudy       |Failure    |cannot transition from                                                       |

  Scenario Outline: PT_SR11. Return error message when study_id is invalid
    Given template specimen received message in type: "<specimen_type>" for patient: "PT_SR11_Registered"
    Then set patient message field: "<field>" to value: "<value>"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
    |specimen_type  |field              |value            |message                                                        |
    |TISSUE         |study_id           |                 |was not of a minimum string length of 1                        |
    |BLOOD          |study_id           |                 |was not of a minimum string length of 1                        |
    |TISSUE         |study_id           |OTHER            |did not match one of the following values: APEC1621            |


Scenario: PT_SR12. new tissue cannot be received when there is one tissue variant report get "CONFIRMED"
#  Test patient: PT_SR12_VariantReportConfirmed: VR confirmed SEI_01, MOI_01, ANI_01
  Given template specimen received message in type: "TISSUE" for patient: "PT_SR12_VariantReportConfirmed"
  Then set patient message field: "surgical_event_id" to value: "SEI_02"
  When posted to MATCH patient trigger service, returns a message that includes "cannot transition from" with status "Failure"

Scenario: PT_SR14. new specimen using new SEI will push all pending variant report from old SEI to "REJECT"
#    Test patient: PT_SR14_VariantReportUploaded; variant report files uploaded: surgical_event_id: SEI_01, molecular_id: MOI_01, analysis_id: ANI_01
#          Plan to receive new specimen surgical_event_id: SEI_02
  Given template specimen received message in type: "TISSUE" for patient: "PT_SR14_VariantReportUploaded"
  Then set patient message field: "surgical_event_id" to value: "SEI_02"
  When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"
  Then retrieve patient: "PT_SR14_VariantReportUploaded" from API
  Then returned patient has variant report (surgical_event_id: "SEI_01", molecular_id: "MOI_01", analysis_id: "ANI_01")
  And this variant report has value: "REJECTED" in field: "status"

Scenario: PT_SR15. new specimen using new MOI in same SEI will push all pending variant report from old MOI to "REJECT"
#    Test patient: PT_SR15_VariantReportUploaded; variant report files uploaded: surgical_event_id: SEI_01, molecular_id: MOI_01, analysis_id: ANI_01
#          Plan to receive new specimen using same surgical_event_id: SEI_01
  Given template specimen received message in type: "TISSUE" for patient: "PT_SR15_VariantReportUploaded"
  Then set patient message field: "surgical_event_id" to value: "SEI_01"
  When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"
  Then retrieve patient: "PT_SR15_VariantReportUploaded" from API
  Then returned patient has variant report (surgical_event_id: "SEI_01", molecular_id: "MOI_01", analysis_id: "ANI_01")
  And this variant report has value: "REJECTED" in field: "status"
