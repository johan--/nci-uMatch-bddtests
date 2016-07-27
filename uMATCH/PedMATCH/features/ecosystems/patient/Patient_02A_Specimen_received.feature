#encoding: utf-8
@patients_not_implemented
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
    When posted to MATCH patient trigger service, returns a message that includes "specimen(s) collection date is older than patient registration date." with status "Failure"

  Scenario: PT_SR06. Return error message when received date is older than collection date
    Given template specimen received message in type: "TISSUE" for patient: "PT_SR06_Registered"
    Then set patient message field: "surgical_event_id" to value: "PT-SpecimenTest_SE_2"
    Then set patient message field: "collected_dttm" to value: "2016-04-25T15:17:11+00:00"
    Then set patient message field: "received_dttm" to value: "2016-04-23T15:17:11+00:00"
    When posted to MATCH patient trigger service, returns a message that includes "specimen(s) received date is older than collection date." with status "Failure"

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
    |SEI_TR_1       |2016-04-30T15:17:11+00:00|2016-05-01T15:17:11+00:00|10       |Failure|Tissue specimen using this surgical event id has already been received |
    |SEI_TR_2       |2016-04-30T15:17:11+00:00|2016-05-01T15:17:11+00:00|10       |Success|Message has been processed successfully                                |

  Scenario Outline: PT_SR10. specimen_received message can only be accepted when patient is in certain status
    Given template specimen received message in type: "<specimen_type>" for patient: "<patient_id>"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "<status>"
    Examples:
    |patient_id             |specimen_type  |status     |message                                                                        |
    |PT_SR10_Progression    |BLOOD          |Success    |specimen(s) received and saved.                                                |
    |PT_SR10_TsNuAdFailure  |TISSUE         |Success    |specimen(s) received and saved.                                                |
    |PT_SR10_BdNuAdFailure  |BLOOD          |Success    |specimen(s) received and saved.                                                |
    |PT_SR10_TsVrReceived   |BLOOD          |Success    |specimen(s) received and saved.                                                |
    |PT_SR10_OnTreatmentArm |TISSUE         |Failure    |TBD                                                                            |
    |PT_SR10_OffStudy       |TISSUE         |Failure    |TBD                                                                            |
#     need to be confrimed new specimen can be received when old one have pending variant report, if this is confirmed, this patient data should be prepared
#    |PT_SR10_TsVrReceived   |TISSUE          |Success    |specimen(s) received and saved.                                                |
#    |PT_SR10_BdVrReceived   |BLOOD           |Success    |specimen(s) received and saved.                                                |

  Scenario Outline: PT_SR11. Return error message when study_id is invalid
    Given template specimen received message in type: "<specimen_type>" for patient: "PT_SR11_Registered"
    Then set patient message field: "<field>" to value: "<value>"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
    |specimen_type  |field              |value            |message                                                        |
    |TISSUE         |study_id           |                 |TBD                                                            |
    |BLOOD          |study_id           |                 |TBD                                                            |
    |TISSUE         |study_id           |OTHER            |TBD                                                            |


#Scenario Outline: PT_SR12. new tissue cannot be received when there is one tissue variant report get "CONFIRMED" under any SEI
#Scenario Outline: PT_SR13. new blood cannot be received when there is one blood variant report get "CONFIRMED"
#Scenario Outline: PT_SR14. new specimen using new SEI will push all pending variant report from old SEI to "REJECT"
#Scenario Outline: PT_SR15. new specimen using new MOI in same SEI will push all pending variant report from old MOI to "REJECT"
