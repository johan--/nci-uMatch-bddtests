#encoding: utf-8
@patients_not_implemented
Feature: Receive NCH specimen messages and consume the message within MATCH::


  Scenario: Consume a specimen_received message for type "Blood" for a patient already registered in Match
    Given template specimen received message in type: "BLOOD" for patient: "PT-SpecimenTest"
    When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "specimen(s) received and saved." with status "Success"

  Scenario: Consume a specimen_received message for type "Tissue" for a patient already registered in Match
    Given template specimen received message in type: "TISSUE" for patient: "PT-SpecimenTest"
    Then set patient message field: "surgical_event_id" to "PT-SpecimenTest_SE_1"
    When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "specimen(s) received and saved." with status "Success"

  Scenario: "Blood" specimen received message without surgical_event_id can be consumed
    Given template specimen received message in type: "BLOOD" for patient: "PT-SpecimenTest"
    Then remove field: "surgical_event_id" from patient message
    When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "specimen(s) received and saved." with status "Success"

  Scenario: "Tissue" specimen received message without surgical_event_id should fail
    Given template specimen received message in type: "BLOOD" for patient: "PT-SpecimenTest"
    Then remove field: "surgical_event_id" from patient message
    When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "specimen(s) received message is missing surgical_event_id." with status "Failure"

  Scenario: Return error message when collection date is older than patient registration date
    Given template specimen received message in type: "TISSUE" for patient: "PT-SpecimenTest"
    Then set patient message field: "surgical_event_id" to "PT-SpecimenTest_SE_2"
    Then set patient message field: "collected_dttm" to "1990-04-25T15:17:11+00:00"
    When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "specimen(s) collection date is older than patient registration date." with status "Failure"

  Scenario: Return error message when received date is older than collection date
    Given template specimen received message in type: "TISSUE" for patient: "PT-SpecimenTest"
    Then set patient message field: "surgical_event_id" to "PT-SpecimenTest_SE_2"
    Then set patient message field: "collected_dttm" to "2016-04-25T15:17:11+00:00"
    Then set patient message field: "received_dttm" to "2016-04-23T15:17:11+00:00"
    When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "specimen(s) received date is older than collection date." with status "Failure"

  Scenario: Return error when specimen received message is received for non-existing patient
    Given template specimen received message in type: "TISSUE" for patient: "PT-SpecimenTest-NonExistingPatient"
    When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "Patient (patient_id: PT-SpecimenTest-NonExistingPatient) does not exist" with status "Failure"


  Scenario Outline: Return error message when invalid type (other than BLOOD or TISSUE) is received
    Given template specimen received message in type: "<specimen_type>" for patient: "PT-SpecimenTest"
    When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "Specimen type (Tissue) is not valid" with status "Failure"
    Examples:
    |specimen_type      |
    |Tissue             |
    |blood              |
    |                   |
    |other              |

  Scenario Outline: Only ONE tissue and One blood specimen can be received using same surgical event id
    Given template specimen received message in type: "<specimen_type>" for patient: "PT-SpecimenTest"
    Then set patient message field: "surgical_event_id" to "PT-SpecimenTest_SE_3"
    Then set patient message field: "collected_dttm" to "<collectTime>"
    Then set patient message field: "received_dttm" to "<receivedTime>"
    When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "<message>" with status "<status>"
    Examples:
    |specimen_type  |collectTime              |receivedTime             |status |message                                                                |
    |TISSUE         |2016-04-28T15:17:11+00:00|2016-04-29T15:17:11+00:00|Success|specimen(s) received and saved.                                        |
    |BLOOD          |2016-04-29T15:17:11+00:00|2016-04-30T15:17:11+00:00|Success|specimen(s) received and saved.                                        |
    |TISSUE         |2016-04-30T15:17:11+00:00|2016-05-01T15:17:11+00:00|Failure|Ttissue specimen using this surgical event id has already been received|
    |BLOOD          |2016-05-01T15:17:11+00:00|2016-05-02T15:17:11+00:00|Failure|Ttissue specimen using this surgical event id has already been received|

  Scenario Outline: specimen_received message can only be accepted when patient is in certain status
    Given template specimen received message in type: "<specimen_type>" for patient: "<patient_id>"
    When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "<message>" with status "<status>"
    Examples:
    |patient_id                     |specimen_type  |status     |message                                                                        |
    |PT-SpecimenTest-Progression    |BLOOD          |Success    |specimen(s) received and saved.                                                |
    |PT-SpecimenTest-TsNuAdFailure  |TISSUE         |Success    |specimen(s) received and saved.                                                |
    |PT-SpecimenTest-BdNuAdFailure  |BLOOD          |Success    |specimen(s) received and saved.                                                |
    |PT-SpecimenTest-OnTreatmentArm |TISSUE         |Failure    |TBD                                                |
    |PT-SpecimenTest-OffStudy       |TISSUE         |Failure    |TBD                                                |
