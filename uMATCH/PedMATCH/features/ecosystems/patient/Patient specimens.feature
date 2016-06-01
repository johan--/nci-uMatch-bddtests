#encoding: utf-8
Feature: NCH Specimen received messages
  Receive NCH specimen messages and consume the message within MATCH

@test
  Scenario: Consume a specimen_received message for a patient already registered in Match
#    Given patient "SuccessfulSpecimenTest" exist in "PEDMatch"
    And that a new specimen is received from NCH:
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
#    When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "Patient (PSN:SuccessfulSpecimenTest) specimen received and saved."



  Scenario: Return a failure message when the same MDA message is received by MATCH
    Given that a new specimen is received from NCH:
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

  @non-critical-functional
  Scenario: 9.3.1 Receive an MDA Biopsy Details Message with reportedDate before SPECIMEN_RECEIVED message reportedDate for the same biopsy
    Given patient "SpecimenTest" exist in "PEDMatch"
    And a new specimen is received from NCH with future received date:
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
				"collection_grouping_id": "CGID-SpecimenTest",
				"type": "tumor",
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

    When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "Message reported date is set before SPECIMEN_RECEIVED reported date for biopsy (BSN:BSN-BiopsyTest4-1)."


  @non-critical-functional
  Scenario: 9.3.2 Receive an MDA Biopsy Details Message with reportedDate before SPECIMEN_RECEIVED message reportedDate for another biopsy
    Given that a new specimen biopsy details message is received from the MDA layer:
	"""
	{
	 "patientSequenceNumber":"BiopsyTEST4",
	 "biopsySequenceNumber":"BSN-BiopsyTest4-2",
	 "reportedDate":"2014-03-30 15:33:22.49",
	 "message":"SPECIMEN_RECEIVED"
	}
	"""
    When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "Message SPECIMEN_RECEIVED biopsy (BSN:BSN-BiopsyTest4-2) reported date cannot be earlier than the patient registration date or the latest biopsy date."


  @non-critical-functional
  Scenario: 9.4 Verify that an update to MDA Biopsy Details Message is consumed
    Given that a new specimen biopsy details message is received from the MDA layer:
	"""
	{
	 "patientSequenceNumber":"BiopsyTEST1",
	 "biopsySequenceNumber":"BSN-BiopsyTest1-1",
	 "reportedDate":"2014-04-30 15:33:22.49",
	 "message":"PATHOLOGY_CONFIRMATION"
	}
	"""
    When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "MD Anderson biopsy specimen detail message for patient (PSN:BiopsyTEST1) received and saved."


  @non-critical-functional
  Scenario: 9.5 Verify that system returns a failure message when a MDA mesage NUCLEIC_ACID_SENDOUT is received before receiving SPECIMEN_RECEIVED message
    Given patient "BiopsyTEST2" exist in MATCH
    And that a new specimen biopsy details message is received from the MDA layer:
	"""
	{
	 "patientSequenceNumber":"BiopsyTEST2",
	 "biopsySequenceNumber":"BSN-BiopsyTest2-1",
	 "reportedDate":"2014-04-30 15:33:22.49",
	 "message":"NUCLEIC_ACID_SENDOUT"
	}
	"""
    When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "No previous biopsy records for biopsy (BSN:BSN-BiopsyTest2-1) for this patient."


  @non-critical-functional
  Scenario: 9.6 Verify that a failure message is returned by MATCH when a MDA Biopsy Details SPECIMEN_FAILURE message is received for a paitent before SPECIMEN_RECEIVED message
    Given that a new specimen biopsy details message is received from the MDA layer:
	"""
	{
	 "patientSequenceNumber":"BiopsyTEST2",
	 "biopsySequenceNumber":"BSN-BiopsyTest2-1",
	 "reportedDate":"2014-04-30 15:33:22.42",
	 "message":"SPECIMEN_FAILURE"
	}
	"""
    When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "No previous biopsy records for biopsy (BSN:BSN-BiopsyTest2-1) for this patient."



  @non-critical-functional
  Scenario: 9.7 Verify that a failure message is returned by MATCH when MDA Specimen Biopsy Details message is received for a patient that is not registered in MATCH
    Given that a new specimen biopsy details message is received from the MDA layer:
	"""
	{
	 "patientSequenceNumber":"BiopsyTEST3",
	 "biopsySequenceNumber":"BSN-BiopsyTest3-1",
	 "reportedDate":"2014-04-30 15:33:22.42",
	 "message":"SPECIMEN_RECEIVED"
	}
	"""
    When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "This patient (PSN:BiopsyTEST3) has not been registered in MATCH."


  @non-critical-functional
  Scenario: 9.8 Verify that a failure message is returned by MATCH when a MDA Biopsy Details Message is received for a patient with an empty Biopsy Sequence Number.
    Given that a new specimen biopsy details message is received from the MDA layer:
	"""
	{
	"patientSequenceNumber":"BiopsyTEST3",
	"biopsySequenceNumber":"",
	"reportedDate":"2014-04-30 15:33:22.42",
	"message":"SPECIMEN_RECEIVED"
	}
	"""
    When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "biopsySequenceNumber may not be empty"


  @non-critical-functional
  Scenario: 9.9 Return the MDA Specimen details for a patient when quering the datastore giving the patientSequenceNumber and biopsySequenceNumber
    When I make a query to the getMdAndersonMessageDetails webservice giving the psn "BiopsyTEST1" and bsn "BSN-BiopsyTest1-1"
    Then MDA Specimen details is retuned in JSON format
 	"""
    [
        {
        	"studyId":null,
            "patientSequenceNumber": "BiopsyTEST1",
            "biopsySequenceNumber": "BSN-BiopsyTest1-1",
            "status": null,
            "comment": null,
            "message": "SPECIMEN_RECEIVED"
        },
        {
        	"studyId":null,
            "patientSequenceNumber": "BiopsyTEST1",
            "biopsySequenceNumber": "BSN-BiopsyTest1-1",
            "status": null,
            "comment": null,
            "message": "PATHOLOGY_CONFIRMATION"
        }
    ]
 	"""

  @non-critical-functional
  Scenario: 9.10 Ensure an infinite number of BIOPSIES with SPECIMEN_FAILURE can be associated with a patient
    Given patient "SpecimenFailureMessageTEST1" exist in MATCH
    And that a new specimen biopsy details message is received from the MDA layer:
	"""
	{
	 "patientSequenceNumber":"SpecimenFailureMessageTEST1",
	 "biopsySequenceNumber":"BSN-SpecimenFailureMessage1-1",
	 "reportedDate":"",
	 "message":"SPECIMEN_RECEIVED"
	}
	"""

    When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "MD Anderson biopsy specimen detail message for patient (PSN:SpecimenFailureMessageTEST1) received and saved."
    And that a new specimen biopsy details message is received from the MDA layer:
	"""
	{
	 "patientSequenceNumber":"SpecimenFailureMessageTEST1",
	 "biopsySequenceNumber":"BSN-SpecimenFailureMessage1-1",
	 "reportedDate":"",
	 "message":"SPECIMEN_FAILURE"
	}
	"""
    When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "MD Anderson biopsy specimen detail message for patient (PSN:SpecimenFailureMessageTEST1) received and saved."
    And that a new specimen biopsy details message is received from the MDA layer:
	"""
	{
	 "patientSequenceNumber":"SpecimenFailureMessageTEST1",
	 "biopsySequenceNumber":"BSN-SpecimenFailureMessage1-2",
	 "reportedDate":"",
	 "message":"SPECIMEN_RECEIVED"
	}
	"""
    When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "MD Anderson biopsy specimen detail message for patient (PSN:SpecimenFailureMessageTEST1) received and saved."
    And that a new specimen biopsy details message is received from the MDA layer:
	"""
	{
	 "patientSequenceNumber":"SpecimenFailureMessageTEST1",
	 "biopsySequenceNumber":"BSN-SpecimenFailureMessage1-2",
	 "reportedDate":"",
	 "message":"SPECIMEN_FAILURE"
	}
	"""
    When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "MD Anderson biopsy specimen detail message for patient (PSN:SpecimenFailureMessageTEST1) received and saved."
    And that a new specimen biopsy details message is received from the MDA layer:
	"""
	{
	 "patientSequenceNumber":"SpecimenFailureMessageTEST1",
	 "biopsySequenceNumber":"BSN-SpecimenFailureMessage1-3",
	 "reportedDate":"",
	 "message":"SPECIMEN_RECEIVED"
	}
	"""
    When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "MD Anderson biopsy specimen detail message for patient (PSN:SpecimenFailureMessageTEST1) received and saved."
    And that a new specimen biopsy details message is received from the MDA layer:
	"""
	{
	 "patientSequenceNumber":"SpecimenFailureMessageTEST1",
	 "biopsySequenceNumber":"BSN-SpecimenFailureMessage1-3",
	 "reportedDate":"",
	 "message":"SPECIMEN_FAILURE"
	}
	"""
    When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "MD Anderson biopsy specimen detail message for patient (PSN:SpecimenFailureMessageTEST1) received and saved."


  @non-critical-functional
  Scenario: 9.11 Verify that a failure message is returned by MATCH when receiving a MDA biopsy message SPECIMEN_RECEIVED for patient with biopsy that already has a failure message.

    Given that a new specimen biopsy details message is received from the MDA layer:
	"""
	{
	 "patientSequenceNumber":"SpecimenFailureMessageTEST1",
	 "biopsySequenceNumber":"BSN-SpecimenFailureMessage1-3",
	 "reportedDate":"",
	 "message":"SPECIMEN_RECEIVED"
	}
	"""
    When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "Biopsy (BSN:BSN-SpecimenFailureMessage1-3) of Patient (PSN:SpecimenFailureMessageTEST1) already has a failure status. Ensure that your biopsy sequence number is correct."




  @non-critical-functional
  Scenario: 9.12 Ensure that Match returns a failure message when Assay messages are received after a BIOPSY with SPECIMEN_FAILURE is received for a patient
    Given patient "SpecimenFailureMessageTEST2" exist in MATCH
    And that a new specimen biopsy details message is received from the MDA layer:
	"""
	{
	 "patientSequenceNumber":"SpecimenFailureMessageTEST2",
	 "biopsySequenceNumber":"BSN-SpecimenFailureMessageTest2-1",
	 "reportedDate":"",
	 "message":"SPECIMEN_RECEIVED"
	}
	"""

    When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "MD Anderson biopsy specimen detail message for patient (PSN:SpecimenFailureMessageTEST2) received and saved."
    And that a new Assay Order is received from MDA:
	"""
	{
	 "patientSequenceNumber":"SpecimenFailureMessageTEST2",
	 "biopsySequenceNumber":"BSN-SpecimenFailureMessageTest2-1",
	 "biomarker":"ICCPTENs",
	 "orderedDate":""
	}
	"""
    When posted to MATCH assayMessage, returns a message "Saved to datastore."
    And that a new specimen biopsy details message is received from the MDA layer:
	"""
	{
	 "patientSequenceNumber":"SpecimenFailureMessageTEST2",
	 "biopsySequenceNumber":"BSN-SpecimenFailureMessageTest2-1",
	 "reportedDate":"",
	 "message":"SPECIMEN_FAILURE"
	}
	"""
    When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "MD Anderson biopsy specimen detail message for patient (PSN:SpecimenFailureMessageTEST2) received and saved."
    Given that assay result is received from MDA
	"""
	{
	 "patientSequenceNumber":"SpecimenFailureMessageTEST2",
	 "biopsySequenceNumber":"BSN-SpecimenFailureMessageTest2-1",
	 "biomarker":"ICCPTENs",
	 "result":"POSITIVE"
	}
	"""
    When posted to MATCH assayMessage, returns a message "Biopsy (BSN:BSN-SpecimenFailureMessageTest2-1) of Patient (PSN:SpecimenFailureMessageTEST2) already has a failure status. Ensure that your biopsy sequence number is correct."


  @non-critical-functional
  Scenario: 9.13 Ensure that only off-trial trigger from ECOG can be processed for a patient whose biopsy received a SPECIMEN_FAILURE message.
    Given existing patients Status is "OFF_TRIAL" and PSN is "SpecimenFailureMessageTEST2"
    And that a new specimen biopsy details message is received from the MDA layer:
	"""
	{
	 "patientSequenceNumber":"SpecimenFailureMessageTEST2",
	 "biopsySequenceNumber":"BSN-SpecimenFailureMessage3",
	 "reportedDate":"",
	 "message":"SPECIMEN_RECEIVED"
	}
	"""
    When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "This patient (PSN:SpecimenFailureMessageTEST2) is off-trial."



  @non-critical-functional
  Scenario: 9.15 Ensure that PATHOLOGY_CONFIRMATION can only be recevied after SPECIMEN_RECEIVED message
    Given patient "PathologyReceivedMessageTEST1" exist in MATCH
    And that a new specimen biopsy details message is received from the MDA layer:
	"""
	{
	 "patientSequenceNumber":"PathologyReceivedMessageTEST1",
	 "biopsySequenceNumber":"BSN-PathologyReceivedMessage1",
	 "reportedDate":"",
	 "message":"PATHOLOGY_CONFIRMATION"
	}
	"""
    When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "No previous biopsy records for biopsy (BSN:BSN-PathologyReceivedMessage1) for this patient."

  @non-critical-functional
  Scenario: 9.16 Biopsy cannot be received with a older date than the patient registration date
    Given patient "BiopsyTEST5" exist in MATCH
    And that a new specimen biopsy details message is received from the MDA layer with earlier date:
	"""
	{
	 "patientSequenceNumber":"BiopsyTEST5",
	 "biopsySequenceNumber":"BSN-BiopsyTest5",
	 "reportedDate":"2014-04-30 15:33:22.49",
	 "message":"SPECIMEN_RECEIVED"
	}
	"""
    When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "Message SPECIMEN_RECEIVED biopsy (BSN:BSN-BiopsyTest5) reported date cannot be earlier than the patient registration date or the latest biopsy date."


  @non-critical-functional
  Scenario: 9.17 Verify that the collectedDate is optional
    Given patient "BiopsyTEST6" exist in MATCH
    And that a new specimen biopsy details message is received from the MDA layer without collectedDate:
	"""
	{
	 "patientSequenceNumber":"BiopsyTEST6",
	 "biopsySequenceNumber":"BSN-BiopsyTest6",
	 "reportedDate":"2014-04-30 15:33:22.49",
	 "message":"SPECIMEN_RECEIVED"
	}
	"""
    When posted to MATCH setBiopsySpecimenDetailsMessage, returns a message "MD Anderson biopsy specimen detail message for patient (PSN:BiopsyTEST6) received and saved."
