@demo
Feature: Feature for end-to-end test demo



  Scenario: Patient in registration
    Given that Patient StudyID "APEC1621" PatientSeqNumber "00001" StepNumber "1.0" PatientStatus "REGISTRATION" Message "Patient registration trigger" with "current" dateCreated is received from EA layer
    When posted to MATCH patient registration
    Then a message "Message has been processed successfully" is returned with a "Success"

  Scenario: Patient's Blood specimen is received
    Given template specimen received message in type: "BLOOD" for patient: "00001"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"

  Scenario: Patient's Tissue specimen is received
    Given template specimen received message in type: "TISSUE" for patient: "00001"
    Then set patient message field: "surgical_event_id" to value: "00001-Tissue_Specimen_1"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"


  Scenario: Patient's Blood specimen shipment is received
    Given template specimen shipped message in type: "BLOOD" for patient: "00001"
    When posted to MATCH patient trigger service, returns a message that includes "specimen shipped message received and saved." with status "Success"


  Scenario: Patient's Tissue specimen shipment is received
    Given template specimen shipped message in type: "TISSUE" for patient: "00001"
    Then set patient message field: "surgical_event_id" to value: "00001-Tissue_Specimen_1"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"


  Scenario: Patient's SLIDE specimen shipment is received
    Given template specimen shipped message in type: "SLIDE" for patient: "00001"
    Then set patient message field: "surgical_event_id" to value: "00001-Tissue_Specimen_1"
    When posted to MATCH patient trigger service, returns a message that includes "specimen shipped message received and saved." with status "Success"


  Scenario: Patient's ICCPTENs assay message is received
    Given that assay result is received from MDA:
    """
	{
	 "patient_id":"00001",
	 "study_id": "APEC1621",
	 "surgical_event_id":"00001-Tissue_Specimen_1",
	 "biomarker":"ICCPTENs",
	 "type":"Result"
	 "result":"POSITIVE",
	 "reported_date":"2014-09-16 15:33:22.42"
	}
	"""
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"

  Scenario: Patient's ICCMLH1s assay message is received
    Given that assay result is received from MDA:
    """
	{
	 "patient_id":"00001",
	 "study_id": "APEC1621",
	 "surgical_event_id":"00001-Tissue_Specimen_1",
	 "biomarker":"ICCMLH1s",
	 "type":"Result"
	 "result":"NEGATIVE",
	 "reported_date":"2014-09-16 15:33:22.42"
	}
	"""
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"

  Scenario: Patient's pathology report confirmation is received
    Given template pathology report with surgical_event_id: "00001-Tissue_Specimen_1" for patient: "00001"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"





