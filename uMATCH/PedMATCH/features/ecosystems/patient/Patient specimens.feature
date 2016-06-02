#encoding: utf-8
Feature: NCH Specimen received messages
  Receive NCH specimen messages and consume the message within MATCH


  Scenario: Consume a specimen_received message for a patient already registered in Match
    Given patient "SuccessfulSpecimenTest" exist in "PEDMatch"
    And that a specimen is received from NCH:
	"""
	{
		"header": {
			"msg_guid": "0f8fad5b-d9cb-469f-al65-80067728950e",
			"msg_dttm": "2016-05-09T22:06:33+00:00"
		},
		"specimens_received" : [
			{
				"study_id": "APEC1621",
				"patient_id": "SuccessfulSpecimenTest",
				"collection_grouping_id": "CGID-SuccessfulSpecimenTest",
				"type": "Blood",
				"disease_status": "Normal",
				"collection_ts": "2016-04-25T14:17:11+00:00",
				"received_ts": "2016-04-25T15:17:11+00:00",
				"internal_use_only": {
					"stars_patient_id": "ABCXYZ",
					"star_specimen_id": "ABCXYZ-ABC123",
					"star_specimen_type": "Fresh Blood",
					"qc_tx": "2016-04-25T16:21:34+00:00"
				}
			}
		]
	}
	"""
    When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "specimen(s) received and saved."

##!!!!!!!!!!!!!!!!!!May be an invalid scenario!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#
  Scenario: Return a failure message when the same specimen message is received by MATCH
    Given that a specimen is received from NCH:
	"""
	{
		"header": {
			"msg_guid": "0f8fad5b-d9cb-469f-al65-80067728950e",
			"msg_dttm": "2016-05-09T22:06:33+00:00"
		},
		"specimens_received" : [
			{
				"study_id": "APEC1621",
				"patient_id": "SuccessfulSpecimenTest",
				"collection_grouping_id": "CGID-SuccessfulSpecimenTest",
				"type": "Blood",
				"disease_status": "Normal",
				"collection_ts": "2016-04-25T14:17:11+00:00",
				"received_ts": "2016-04-25T15:17:11+00:00",
				"internal_use_only": {
					"stars_patient_id": "ABCXYZ",
					"star_specimen_id": "ABCXYZ-ABC123",
					"star_specimen_type": "Fresh Blood",
					"qc_tx": "2016-04-25T16:21:34+00:00"
				}
			}
		]
	}
	"""
    When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "Duplicate specimen message received for patient (PSN:SuccessfulSpecimenTest)"

  Scenario: Consume specimen received message for multiple tissue types collected on the same date
	Given patient "MultipleSpecimenTest" exist in "PEDMatch"
	And that a specimen is received from NCH:
	"""
	{
		"header": {
			"msg_guid": "0f8fad5b-d9cb-469f-al65-80067728950e",
			"msg_dttm": "2016-05-09T22:06:33+00:00"
		},
		"specimens_received" : [
			{
				"study_id": "APEC1621",
				"patient_id": "MultipleSpecimenTest",
				"collection_grouping_id": "CGID-MultipleSpecimenTest-blood",
				"type": "Blood",
				"disease_status": "Normal",
				"collection_ts": "2016-04-25T14:17:11+00:00",
				"received_ts": "2016-04-25T15:17:11+00:00",
				"internal_use_only": {
					"stars_patient_id": "ABCXYZ",
					"star_specimen_id": "ABCXYZ-ABC123",
					"star_specimen_type": "Fresh Blood",
					"qc_tx": "2016-04-25T16:21:34+00:00"
				}
			},
			{
				"study_id": "APEC1621",
				"patient_id": "MultipleSpecimenTest",
				"collection_grouping_id": "CGID-MultipleSpecimenTest-tissue",
				"type": "Tissue",
				"disease_status": "Normal",
				"collection_ts": "2016-04-25T14:17:11+00:00",
				"received_ts": "2016-04-25T15:17:11+00:00",
				"internal_use_only": {
					"stars_patient_id": "ABCXYZ",
					"star_specimen_id": "ABCXYZ-ABC123",
					"star_specimen_type": "Fresh Blood",
					"qc_tx": "2016-04-25T16:21:34+00:00"
				}
			}
		]
	}
	"""
	When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "specimen(s) received and saved."

  Scenario: Consume multiple specimen received messages for same tissue type collected on the same date
	Given patient "MultipleSpecimenOfSameTypeTest" exist in "PEDMatch"
	And that a specimen is received from NCH:
	"""
	{
		"header": {
			"msg_guid": "0f8fad5b-d9cb-469f-al65-80067728950e",
			"msg_dttm": "2016-05-09T22:06:33+00:00"
		},
		"specimens_received" : [
			{
				"study_id": "APEC1621",
				"patient_id": "MultipleSpecimenOfSameTypeTest",
				"collection_grouping_id": "CGID-MultipleSpecimenOfSameTypeTest-blood",
				"type": "Blood",
				"disease_status": "Normal",
				"collection_ts": "2016-04-25T14:17:11+00:00",
				"received_ts": "2016-04-25T15:17:11+00:00",
				"internal_use_only": {
					"stars_patient_id": "ABCXYZ",
					"star_specimen_id": "ABCXYZ-ABC123",
					"star_specimen_type": "Fresh Blood",
					"qc_tx": "2016-04-25T16:21:34+00:00"
				}
			}
		]
	}
	"""
	When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "specimen(s) received and saved."
	Then that a specimen is received from NCH:
	"""
	{
		"header": {
			"msg_guid": "0f8fad5b-d9cb-469f-al65-80067728950e",
			"msg_dttm": "2016-05-09T22:06:33+00:00"
		},
		"specimens_received" : [
			{
				"study_id": "APEC1621",
				"patient_id": "MultipleSpecimenOfSameTypeTest",
				"collection_grouping_id": "CGID-MultipleSpecimenOfSameTypeTest-blood",
				"type": "Blood",
				"disease_status": "Normal",
				"collection_ts": "2016-04-25T14:17:11+00:00",
				"received_ts": "2016-04-25T15:17:11+00:00",
				"internal_use_only": {
					"stars_patient_id": "ABCXYZ",
					"star_specimen_id": "ABCXYZ-ABC123",
					"star_specimen_type": "Fresh Blood",
					"qc_tx": "2016-04-25T16:21:34+00:00"
				}
			}
		]
	}
	"""
	When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "specimen(s) received and saved."


  Scenario: Consume multiple specimen received messages for same tissue type collected on different dates
	Given that Patient StudyID "APEC1621" PatientSeqNumber "MultipleSpecimenOfSameTypeTest1" StepNumber "1.0" PatientStatus "REGISTRATION" Message "Patient REGISTERED" AccrualGroupId "22334a2sr" with "older" dateCreated is received from EA layer
	When posted to MATCH setPatientTrigger
	Then a message "Saved to datastore." is returned with a "success"
	And that multiple specimens of same type are received from NCH with different collection dates:
	"""
	{
		"header": {
			"msg_guid": "0f8fad5b-d9cb-469f-al65-80067728950e",
			"msg_dttm": "2016-05-09T22:06:33+00:00"
		},
		"specimens_received" : [
			{
				"study_id": "APEC1621",
				"patient_id": "MultipleSpecimenOfSameTypeTest1",
				"collection_grouping_id": "CGID-MultipleSpecimenOfSameTypeTest1-blood-1",
				"type": "Blood",
				"disease_status": "Normal",
				"collection_ts": "2016-04-25T14:17:11+00:00",
				"received_ts": "2016-04-25T15:17:11+00:00",
				"internal_use_only": {
					"stars_patient_id": "ABCXYZ",
					"star_specimen_id": "ABCXYZ-ABC123",
					"star_specimen_type": "Fresh Blood",
					"qc_tx": "2016-04-25T16:21:34+00:00"
				}
			},
			{
				"study_id": "APEC1621",
				"patient_id": "MultipleSpecimenTest",
				"collection_grouping_id": "CGID-MultipleSpecimenOfSameTypeTest1-blood-2",
				"type": "blood",
				"disease_status": "Normal",
				"collection_ts": "2016-04-25T14:17:11+00:00",
				"received_ts": "2016-04-25T15:17:11+00:00",
				"internal_use_only": {
					"stars_patient_id": "ABCXYZ",
					"star_specimen_id": "ABCXYZ-ABC123",
					"star_specimen_type": "Fresh Blood",
					"qc_tx": "2016-04-25T16:21:34+00:00"
				}
			}
		]
	}
	"""
	When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "specimen(s) received and saved."

  Scenario: Consume specimen received message for multiple patient_ids
	Given that Patient StudyID "APEC1621" PatientSeqNumber "SpecimenMessageForMultiplePatientsTest1" StepNumber "1.0" PatientStatus "REGISTRATION" Message "Patient REGISTERED" AccrualGroupId "22334a2sr" with "current" dateCreated is received from EA layer
	Given that Patient StudyID "APEC1621" PatientSeqNumber "SpecimenMessageForMultiplePatientsTest2" StepNumber "1.0" PatientStatus "REGISTRATION" Message "Patient REGISTERED" AccrualGroupId "22334a2sr" with "current" dateCreated is received from EA layer
	When posted to MATCH setPatientTrigger
	Then a message "Saved to datastore." is returned with a "success"
	And that a specimen is received from NCH:
	"""
	{
		"header": {
			"msg_guid": "0f8fad5b-d9cb-469f-al65-80067728950e",
			"msg_dttm": "2016-05-09T22:06:33+00:00"
		},
		"specimens_received" : [
			{
				"study_id": "APEC1621",
				"patient_id": "SpecimenMessageForMultiplePatientsTest1",
				"collection_grouping_id": "CGID-SpecimenMessageForMultiplePatientsTest1-blood",
				"type": "Blood",
				"disease_status": "Normal",
				"collection_ts": "2016-04-25T14:17:11+00:00",
				"received_ts": "2016-04-25T15:17:11+00:00",
				"internal_use_only": {
					"stars_patient_id": "ABCXYZ",
					"star_specimen_id": "ABCXYZ-ABC123",
					"star_specimen_type": "Fresh Blood",
					"qc_tx": "2016-04-25T16:21:34+00:00"
				}
			},
			{
				"study_id": "APEC1621",
				"patient_id": "SpecimenMessageForMultiplePatientsTest2",
				"collection_grouping_id": "CGID-SpecimenMessageForMultiplePatientsTest2-tissue",
				"type": "tissue",
				"disease_status": "Normal",
				"collection_ts": "2016-04-25T14:17:11+00:00",
				"received_ts": "2016-04-25T15:17:11+00:00",
				"internal_use_only": {
					"stars_patient_id": "ABCXYZ",
					"star_specimen_id": "ABCXYZ-ABC123",
					"star_specimen_type": "Fresh Blood",
					"qc_tx": "2016-04-25T16:21:34+00:00"
				}
			}
		]
	}
	"""
	When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "specimen(s) received and saved."

  Scenario: Return error message when collection date is older than patient registration date
	Given patient "SpecimenTest" exist in "PEDMatch"
	And that a specimen is received from NCH with older collection date:
	"""
	{
		"header": {
			"msg_guid": "0f8fad5b-d9cb-469f-al65-80067728950e",
			"msg_dttm": "2016-05-09T22:06:33+00:00"
		},
		"specimens_received" : [
			{
				"study_id": "APEC1621",
				"patient_id": "SpecimenTest",
				"collection_grouping_id": "CGID-MultipleSpecimenOfSameTypeTest-blood",
				"type": "Blood",
				"disease_status": "Normal",
				"collection_ts": "2016-04-25T14:17:11+00:00",
				"received_ts": "2016-04-25T15:17:11+00:00",
				"internal_use_only": {
					"stars_patient_id": "ABCXYZ",
					"star_specimen_id": "ABCXYZ-ABC123",
					"star_specimen_type": "Fresh Blood",
					"qc_tx": "2016-04-25T16:21:34+00:00"
				}
			}
		]
	}
	"""
	When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "specimen(s) collection date is older than patient registration date."

  Scenario: Return error message when received date is older than collection date
	Given that Patient StudyID "APEC1621" PatientSeqNumber "SpecimenTest1" StepNumber "1.0" PatientStatus "REGISTRATION" Message "Patient REGISTERED" AccrualGroupId "22334a2sr" with "older" dateCreated is received from EA layer
	And that a specimen is received from NCH with received date older collection date:
	"""
	{
		"header": {
			"msg_guid": "0f8fad5b-d9cb-469f-al65-80067728950e",
			"msg_dttm": "2016-05-09T22:06:33+00:00"
		},
		"specimens_received" : [
			{
				"study_id": "APEC1621",
				"patient_id": "SpecimenTest1",
				"collection_grouping_id": "CGID-MultipleSpecimenOfSameTypeTest-blood",
				"type": "Blood",
				"disease_status": "Normal",
				"collection_ts": "2016-04-25T14:17:11+00:00",
				"received_ts": "2016-04-25T15:17:11+00:00",
				"internal_use_only": {
					"stars_patient_id": "ABCXYZ",
					"star_specimen_id": "ABCXYZ-ABC123",
					"star_specimen_type": "Fresh Blood",
					"qc_tx": "2016-04-25T16:21:34+00:00"
				}
			}
		]
	}
	"""
	When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "specimen(s) collection date is older than patient registration date."
