#encoding: utf-8

Feature: Assay Messages
  Receive Assay data from MDA layer in JSON format unique for a patient-biopsy


  Scenario Outline: Consume an Assay Order for a patient already registered in Match
	Given patient "<patient_id>" exist in "PEDMatch"
	And specimen is received for "<patient_id>" for type "TISSUE"
    Given that a new Assay Order is received from MDA:
	"""
	{
	 "patient_id":"<patient_id>",
	 "specimen_id":"<specimen_id>",
	 "type":"<type>",
	 "biomarker":"<marker>",
	 "ordered_date":"2014-04-30 15:33:22.42"
	}
	"""
    When posted to MATCH assayMessage, returns a message "Assay Order message received and saved for patient <patient_id>"
    Examples:
      |marker		|patient_id			|specimen_id		|type			|
      |ICCPTENs		|assayOrderTEST		|BSN-AssayOrderTest |Order			|


  Scenario: Return error message when assay order is received for patient who is not registered yet in MATCH
    Given that a new Assay Order is received from MDA:
	"""
	{
	 "patient_id":"NCI1003",
	 "specimen_id":"N-14-000005",
	 "type":"Order",
	 "biomarker":"ICCPTENs",
	 "ordered_date":"2014-04-30 15:33:22.42"
	}
	"""
    When posted to MATCH assayMessage, returns a message "This patient (patient_id:NCI1003) has not been registered in MATCH."



  Scenario Outline: Return a failure message when the Assay Order is received again for the same patient
	Given that a new Assay Order is received from MDA:
	"""
	{
	 "patient_id":"<patient_id>",
	 "specimen_id":"<specimen_id>",
	 "type":"<type>",
	 "biomarker":"<marker>",
	 "ordered_date":"2014-04-30 15:33:22.42"
	}
	"""
	When posted to MATCH assayMessage, returns a message "Assay (BIOMID:<marker>) for patient (PSN:<psn>) has already been recorded for this biopsy (specimen_id:<specimen_id>)."
	Examples:
	  |marker		|patient_id			|specimen_id		|type			|
	  |ICCPTENs		|assayOrderTEST		|BSN-AssayOrderTest |Order			|




  Scenario Outline: Consume Assay results for a patient whose assay is already ordered
    Given that assay result is received from MDA:
	"""
	{
	 "patient_id":"<patient_id>",
	 "specimen_id":"<specimen_id>",
	 "biomarker":"<marker>",
	 "type":"<type>"
	 "result":"POSITIVE",
	 "reported_date":"2014-09-16 15:33:22.42"
	}
	"""
	When posted to MATCH assayMessage, returns a message "Assay Result message received and saved for patient <patient_id>"
    Examples:
      |marker		|patient_id			|specimen_id		|type		|
      |ICCPTENs		|assayOrderTEST		|BSN-AssayOrderTest	|Result		|


  Scenario Outline: Return a failure message when the assay result is received in duplicate.
    Given that assay result is received from MDA:
	"""
	{
	 "patient_id":"<patient_id>",
	 "specimen_id":"<specimen_id>",
	 "biomarker":"<marker>",
	 "type":"<type>"
	 "result":"NEGATIVE",
	 "reported_date":"2014-09-16 15:33:22.42"
	}
	"""
    When posted to MATCH assayMessage, returns a message "Assay (BIOMID:<marker>) for patient (patient_id:<patient_id>) and Specimen (specimen_id:<specimen_id>) result (Result:POSITIVE) has already been recorded. This result cannot be changed."
    Examples:
	  |marker		|patient_id			|specimen_id		|type		|
	  |ICCPTENs		|assayOrderTEST		|BSN-AssayOrderTest	|Result		|



  Scenario Outline: Receive an Assay result from MDA for a patient registered in MATCH and who's assay was not ordered
	Given patient "<patient_id>" exist in "PEDMatch"
	And specimen is received for "<patient_id>" for type "TISSUE"
    Given that assay result is received from MDA:
	"""
	{
	 "patient_id":"<patient_id>",
	 "specimen_id":"<specimen_id>",
	 "biomarker":"<marker>",
	 "type":"<type>"
	 "result":"NEGATIVE",
	 "reported_date":"2014-09-16 15:33:22.42"
	}
	"""
    When posted to MATCH assayMessage, returns a message "Assay (BIOMID:<marker>) was not ordered for this patient (patient_id:<patient_id>)."
	Examples:
	  |marker		|patient_id			|specimen_id		|type		|
	  |ICCPTENs		|assayOrderTEST1	|BSN-AssayOrderTest1|Result		|


  Scenario Outline: Return a failure message when assay order is received for a patient in status OFF_TRIAL_NOT_CONSENTED
	Given patient "<patient_id>" exist in "PEDMatch"
	Given that Patient StudyID "APEC1621" PatientSeqNumber "<patient_id>" StepNumber "0.0" PatientStatus "OFF_TRIAL_NOT_CONSENTED" Message "patient did not consent" AccrualGroupId "123" with "current" dateCreated is received from EA layer
	When posted to MATCH setPatientTrigger
	Then a message "Saved to datastore." is returned with a "SUCCESS"
	And specimen is received for "<patient_id>" for type "TISSUE"
    Given that a new Assay Order is received from MDA:
	"""
	{
	 "patient_id":"<patient_id>",
	 "specimen_id":"<specimen_id>",
	 "biomarker":"<marker>",
	 "type":"<type>"
	 "ordered_date":"2014-09-16 15:33:22.42"
	}
	"""
    When posted to MATCH assayMessage, returns a message "This patient (patient_id:<patient_id>) is off-trial."

    Examples:
      |marker	|patient_id			|specimen_id		|type	|
      |ICCPTENs	|assayOrderTEST2	|BSN-AssayOrderTest2|Order	|

  Scenario Outline: Return a failure message if patientStatus is OFF_TRIAL_DECEASED
	Given patient "<patient_id>" exist in "PEDMatch"
	Given that Patient StudyID "APEC1621" PatientSeqNumber "<patient_id>" StepNumber "0.0" PatientStatus "OFF_TRIAL_NOT_DECEASED" Message "patient passed on" AccrualGroupId "123" with "current" dateCreated is received from EA layer
	When posted to MATCH setPatientTrigger
	Then a message "Saved to datastore." is returned with a "SUCCESS"
	And specimen is received for "<patient_id>" for type "TISSUE"
	Given that a new Assay Order is received from MDA:
	"""
	{
	 "patient_id":"<patient_id>",
	 "specimen_id":"<specimen_id>",
	 "biomarker":"<marker>",
	 "type":"<type>"
	 "ordered_date":"2014-09-16 15:33:22.42"
	}
	"""
	When posted to MATCH assayMessage, returns a message "This patient (patient_id:<patient_id>) is off-trial."

	Examples:
	  |marker	|patient_id			|specimen_id		|type	|
	  |ICCPTENs	|assayOrderTEST3	|BSN-AssayOrderTest3|Order	|


  Scenario Outline: Return a failure message when assay result date is older than assay order date
	Given that Patient StudyID "APEC1621" PatientSeqNumber "<patient_id>" StepNumber "0.0" PatientStatus "REGISTRATION" Message "patient passed on" AccrualGroupId "123" with "a few days older" dateCreated is received from EA layer
	When posted to MATCH setPatientTrigger
	Then a message "Saved to datastore." is returned with a "SUCCESS"
	And specimen is received for "<patient_id>" for type "TISSUE" with older dates
    Given that a new Assay Order is received from MDA:
	"""
	{
	 "patient_id":"<patient_id>",
	 "specimen_id":"<specimen_id>",
	 "biomarker":"<marker>",
	 "type":"Order"
	 "ordered_date":"2014-09-16 15:33:22.42"
	}
	"""
    When posted to MATCH assayMessage, returns a message "Assay Order message received and saved for patient <patient_id>"
    When assay result is received from MDA with an earlier date than order date
	"""
	{
	 "patient_id":"<patient_id>",
	 "specimen_id":"<specimen_id>",
	 "biomarker":"<marker>",
	 "type":"Result"
	 "result":"NEGATIVE",
	 "reported_date":"2014-09-16 15:33:22.42"
	}
	"""
    When posted to MATCH assayMessage, returns a message "Assay (BIOMID:<marker>) for patient (patient_id:<patient_id>) and (Specimen:<specimen_id>) result date is earlier than the assay ordered date."
    Examples:
      |marker			|patient_id			|specimen_id	|
      |ICCPTENs			|assayOrderTEST4	|BSN-AssayOrderTest4|


  Scenario Outline: Return a failure message when a assay result is received with null results.
	Given patient "<patient_id>" exist in "PEDMatch"
	And specimen is received for "<patient_id>" for type "TISSUE"
	Given that a new Assay Order is received from MDA:
	"""
	{
	 "patient_id":"<patient_id>",
	 "specimen_id":"<specimen_id>",
	 "biomarker":"<marker>",
	 "type":"Order"
	 "ordered_date":"2014-09-16 15:33:22.42"
	}
	"""
	When posted to MATCH assayMessage, returns a message "Assay Order message received and saved for patient <patient_id>"
	When that assay result is received from MDA:
	"""
	{
	 "patient_id":"<patient_id>",
	 "specimen_id":"<specimen_id>",
	 "biomarker":"<marker>",
	 "type":"Result"
	 "result":"",
	 "reported_date":"2014-09-16 15:33:22.42"
	}
	"""
	When posted to MATCH assayMessage, returns a message "Invalid result is received for Assay (BIOMID:<marker>) for patient (patient_id:<patient_id>) and (Specimen:<specimen_id>)."
	Examples:
	  |marker			|patient_id			|specimen_id		|
	  |ICCPTENs			|assayOrderTEST5	|BSN-AssayOrderTest5|



  Scenario Outline: Verify that assay order message cannot be received with an older date than the specimen_received date
	Given patient "<patient_id>" exist in "PEDMatch"
	And specimen is received for "<patient_id>" for type "TISSUE"
	Given that a new Assay Order is received from MDA with older date:
	"""
	{
	 "patient_id":"<patient_id>",
	 "specimen_id":"<specimen_id>",
	 "biomarker":"<marker>",
	 "type":"Order"
	 "ordered_date":"2014-09-16 15:33:22.42"
	}
	"""
	When posted to MATCH assayMessage, returns a message "Assay (BIOMID:<marker>) for patient (patient_id:<patient_id>) and (Specimen:<specimen_id>) ordered date is earlier than the specimen received date."
  Examples:
  |marker			|patient_id			|specimen_id		|
  |ICCPTENs			|assayOrderTEST6	|BSN-AssayOrderTest6|
