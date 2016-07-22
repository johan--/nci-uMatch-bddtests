#encoding: utf-8
@patients_need_to_be_updated
Feature: NCH Specimen received messages:
  Receive NCH specimen messages and consume the message within MATCH::


  Scenario: Consume a specimen_received message for type "Blood" for a patient already registered in Match
    Given patient "SuccessfulSpecimenTest" exist in "PEDMatch"
    And that a specimen is received from NCH:
	"""
	{
		"header": {
			"msg_guid": "0f8fad5b-d9cb-469f-al65-80067728950e",
			"msg_dttm": "2016-05-09T22:06:33+00:00"
		},
		"specimen_received": {
			"study_id": "APEC1621",
			"patient_id": "SuccessfulSpecimenTest",
			"type": "BLOOD",
			"surgical_event_id": "bsn-SuccessfulSpecimenTest",
			"received_datetime": "2016-07-01T14:46:57-04:00",
			"collected_datetime": "2016-07-01T14:46:57-04:00",
			"internal_use_only": {
				"stars_patient_id": "ABCXYZ",
				"star_specimen_id": "ABCXYZ-ABC123",
				"star_specimen_type": "Fresh Blood",
				"received_ts": "2016-04-25T15:17:11+00:00",
				"qc_datetime": "2016-04-25T16:21:34+00:00"
			}
		}
	}
	"""
    When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "specimen(s) received and saved." with status "Success"

  Scenario: Consume a specimen_received message for type "Tissue" for a patient already registered in Match
#	Given patient "SuccessfulSpecimenTest" exist in "PEDMatch"
	And that a specimen is received from NCH:
	"""
	{
		"header": {
			"msg_guid": "0f8fad5b-d9cb-469f-al65-80067728950e",
			"msg_dttm": "2016-05-09T22:06:33+00:00"
		},
		"specimen_received" :
		{
			"study_id": "APEC1621",
			"patient_id": "SuccessfulSpecimenTest",
			"surgical_event_id":"bsn-SuccessfulSpecimenTest",
			"type": "TISSUE",
			"received_datetime": "2016-04-25T15:17:11+00:00",
			"collected_datetime": "2016-04-25T14:17:11+00:00",
			"internal_use_only": {
				"stars_patient_id": "ABCXYZ",
				"star_specimen_id": "ABCXYZ-ABC123",
				"star_specimen_type": "Fresh Blood",
				"qc_datetime": "2016-04-25T16:21:34+00:00"
			}
		}
	}
	"""
	When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "specimen(s) received and saved." with status "Success"


  Scenario: Return error message when collection date is older than patient registration date
	Given patient "SpecimenTest" exist in "PEDMatch"
	And that a specimen is received from NCH with older collection date:
	"""
	{
		"header": {
			"msg_guid": "0f8fad5b-d9cb-469f-al65-80067728950e",
			"msg_dttm": "2016-05-09T22:06:33+00:00"
		},
		"specimen_received" :
		{
			"study_id": "APEC1621",
			"patient_id": "SpecimenTest",
			"type": "TISSUE",
			"received_datetime": "2016-04-25T15:17:11+00:00",
			"collected_datetime": "2016-04-25T14:17:11+00:00",
			"internal_use_only": {
				"stars_patient_id": "ABCXYZ",
				"star_specimen_id": "ABCXYZ-ABC123",
				"star_specimen_type": "Fresh Blood",
				"qc_datetime": "2016-04-25T16:21:34+00:00"
			}
		}
	}
	"""
	When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "specimen(s) collection date is older than patient registration date." with status "Failure"

  Scenario: Return error message when received date is older than collection date
	Given that Patient StudyID "APEC1621" PatientSeqNumber "SpecimenTest1" StepNumber "1.0" PatientStatus "REGISTRATION" Message "Patient REGISTERED" with "older" dateCreated is received from EA layer
	When posted to MATCH patient registration
	Then a message "Saved to datastore." is returned with a "Success"
	And that a specimen is received from NCH with received date older than collection date:
	"""
	{
		"header": {
			"msg_guid": "0f8fad5b-d9cb-469f-al65-80067728950e",
			"msg_dttm": "2016-05-09T22:06:33+00:00"
		},
		"specimen_received" :
		{
			"study_id": "APEC1621",
			"patient_id": "SpecimenTest1",
			"type": "TISSUE",
			"collected_datetime": "2016-04-25T14:17:11+00:00",
			"received_datetime": "2016-04-25T15:17:11+00:00",
			"internal_use_only": {
				"stars_patient_id": "ABCXYZ",
				"star_specimen_id": "ABCXYZ-ABC123",
				"star_specimen_type": "Fresh Blood",
				"qc_datetime": "2016-04-25T16:21:34+00:00"
			}
		}
	}
	"""
	When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "specimen(s) received date is older than collection date." with status "Failure"


  Scenario: Return error message when specimen received message for type "TISSUE" is received without surgical_event_id
	Given that Patient StudyID "APEC1621" PatientSeqNumber "SpecimenTest2" StepNumber "1.0" PatientStatus "REGISTRATION" Message "Patient REGISTERED" with "current" dateCreated is received from EA layer
	When posted to MATCH patient registration
	Then a message "Saved to datastore." is returned with a "Success"
	And that a specimen is received from NCH:
	"""
	{
		"header": {
			"msg_guid": "0f8fad5b-d9cb-469f-al65-80067728950e",
			"msg_dttm": "2016-05-09T22:06:33+00:00"
		},
		"specimen_received" :
		{
			"study_id": "APEC1621",
			"patient_id": "SpecimenTest2",
			"type": "TISSUE",
			"collected_datetime": "2016-04-25T14:17:11+00:00",
			"received_datetime": "2016-04-25T15:17:11+00:00",
			"internal_use_only": {
				"stars_patient_id": "ABCXYZ",
				"star_specimen_id": "ABCXYZ-ABC123",
				"star_specimen_type": "Fresh Blood",
				"qc_datetime": "2016-04-25T16:21:34+00:00"
			}
		}
	}
	"""
	When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "specimen(s) received message is missing surgical_event_id." with status "Failure"

  Scenario: Return error when specimen received message is received for non-existing patient
	Given that a specimen is received from NCH:
	"""
	{
		"header": {
			"msg_guid": "0f8fad5b-d9cb-469f-al65-80067728950e",
			"msg_dttm": "2016-05-09T22:06:33+00:00"
		},
		"specimen_received" :
		{
			"study_id": "APEC1621",
			"patient_id": "SpecimenTest3",
			"type": "TISSUE",
			"surgical_event_id":"bsn-SpecimenTest2\3",
			"collected_datetime": "2016-04-25T14:17:11+00:00",
			"received_datetime": "2016-04-25T15:17:11+00:00",
			"internal_use_only": {
				"stars_patient_id": "ABCXYZ",
				"star_specimen_id": "ABCXYZ-ABC123",
				"star_specimen_type": "Fresh Blood",
				"qc_datetime": "2016-04-25T16:21:34+00:00"
			}
		}
	}
	"""
	When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "Patient (patient_id: SpecimenTest3) does not exist" with status "Failure"


  Scenario: Return error message when invalid type (other than BLOOD or TISSUE) is received
	Given patient "SpecimenTest3" exist in "PEDMatch"
	Given that a specimen is received from NCH:
	"""
	{
		"header": {
			"msg_guid": "0f8fad5b-d9cb-469f-al65-80067728950e",
			"msg_dttm": "2016-05-09T22:06:33+00:00"
		},
		"specimen_received" :
		{
			"study_id": "APEC1621",
			"patient_id": "SpecimenTest3",
			"type": "Tissue",
			"surgical_event_id":"bsn-SpecimenTest2\3",
			"collected_datetime": "2016-04-25T14:17:11+00:00",
			"received_datetime": "2016-04-25T15:17:11+00:00",
			"internal_use_only": {
				"stars_patient_id": "ABCXYZ",
				"star_specimen_id": "ABCXYZ-ABC123",
				"star_specimen_type": "Fresh Blood",
				"qc_datetime": "2016-04-25T16:21:34+00:00"
			}
		}
	}
	"""
	When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "Specimen type (Tissue) is not valid" with status "Failure"


