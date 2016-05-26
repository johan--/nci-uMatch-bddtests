@test
Feature: Register a new patient in PEDMatchbox

  Scenario Outline: Successfully register a patient in MATCH
    Given that Patient StudyID "<studyId>" PatientSeqNumber "<patientSequenceNumber>" StepNumber "<stepNumber>" PatientStatus "<patientStatus>" Message "<message>" AccrualGroupId "<accrualGroupId>" with "current" dateCreated is received from EA layer
    When posted to MATCH setPatientTrigger
    Then a message "<returnMessage>" is returned with a "<status>"

    Examples:
      |studyId  |patientSequenceNumber|stepNumber |patientStatus		   |message        					|accrualGroupId|returnMessage              												|status			|
      |APEC1621 |PT-SuccessTest		  |1.0        |REGISTRATION			   |Patient registered in Study		|22334a2sr     |Saved to datastore.														|success		|


  Scenario Outline: MATCH returns an error when a new patient trigger is received with an empty patientSequenceNumber
    Given that Patient StudyID "<studyId>" PatientSeqNumber "<patientSequenceNumber>" StepNumber "<stepNumber>" PatientStatus "<patientStatus>" Message "<message>" AccrualGroupId "<accrualGroupId>" with "current" dateCreated is received from EA layer
    When posted to MATCH setPatientTrigger
    Then a message "<returnMessage>" is returned with a "<status>"

    Examples:
      |studyId  |patientSequenceNumber|stepNumber |patientStatus		   |message        					|accrualGroupId|returnMessage              												|status			|
      |APEC1621 |					  |1.0		  |REGISTRATION			   |Patient registered in Study		|22334a2sr     |Patient id may not be empty.							|FAILURE		|


  Scenario Outline: MATCH returns an error when a new patient trigger is received with an empty stepNumber
    Given that Patient StudyID "<studyId>" PatientSeqNumber "<patientSequenceNumber>" StepNumber "<stepNumber>" PatientStatus "<patientStatus>" Message "<message>" AccrualGroupId "<accrualGroupId>" with "current" dateCreated is received from EA layer
    When posted to MATCH setPatientTrigger
    Then a message "<returnMessage>" is returned with a "<status>"

    Examples:
      |studyId  |patientSequenceNumber|stepNumber |patientStatus		   |message        					|accrualGroupId|returnMessage              												|status			|
      |APEC1621 |PT-Test1			  |			  |REGISTRATION			   |Patient registered in Study		|22334a2sr     |stepNumber may not be empty												|FAILURE		|

  Scenario Outline: MATCH returns an error when a new patient trigger is received with an INVALID stepNumber
    Given that Patient StudyID "<studyId>" PatientSeqNumber "<patientSequenceNumber>" StepNumber "<stepNumber>" PatientStatus "<patientStatus>" Message "<message>" AccrualGroupId "<accrualGroupId>" with "current" dateCreated is received from EA layer
    When posted to MATCH setPatientTrigger
    Then a message "<returnMessage>" is returned with a "<status>"

    Examples:
      |studyId  |patientSequenceNumber|stepNumber |patientStatus		   |message        					|accrualGroupId|returnMessage              												|status			|
      |APEC1621 |PT-Test1			  |1.1		  |REGISTRATION			   |Patient registered in Study		|22334a2sr     |stepNumber msut be 0	    											|FAILURE		|



  Scenario Outline: MATCH returns an error message when patient trigger is received from ECOG for an already registered patient
    Given that Patient StudyID "<studyId>" PatientSeqNumber "<patientSequenceNumber>" StepNumber "<stepNumber>" PatientStatus "<patientStatus>" Message "<message>" AccrualGroupId "<accrualGroupId>" with "current" dateCreated is received from EA layer
    When posted to MATCH setPatientTrigger
    Then a message "<returnMessage>" is returned with a "<status>"

    Examples:
      |studyId  |patientSequenceNumber|stepNumber |patientStatus		   |message        					|accrualGroupId|returnMessage              												|status			|
      |APEC1621 |PT-SuccessTest		  |1.0        |REGISTRATION			   |Patient registered in Study		|22334a2sr     |This patient (PSN:PT-SuccessTest) is already registered.				|FAILURE		|


  Scenario Outline: A Patient can go off-study at any time even when the patient is in stepNumber 0 and a patient trigger is received with DECEASED status.
    Given that Patient StudyID "<studyId>" PatientSeqNumber "<patientSequenceNumber>" StepNumber "<stepNumber>" PatientStatus "<patientStatus>" Message "<message>" AccrualGroupId "<accrualGroupId>" with "current" dateCreated is received from EA layer
    When posted to MATCH setPatientTrigger
    Then a message "<returnMessage>" is returned with a "<status>"

    Examples:
      |studyId  |patientSequenceNumber|stepNumber |patientStatus		   |message        					|accrualGroupId|returnMessage              												|status			|
      |APEC1621 |PT-SuccessTest		  |1.0        |OFF_TRIAL_DECEASED	   |Patient passed away				|22334a2sr     |Saved to datastore.														|SUCCESS		|



  Scenario Outline: Attempt to set a different off-trial status after the patient has already been updated with an off-trail status.
    Given that Patient StudyID "<studyId>" PatientSeqNumber "<patientSequenceNumber>" StepNumber "<stepNumber>" PatientStatus "<patientStatus>" Message "<message>" AccrualGroupId "<accrualGroupId>" with "current" dateCreated is received from EA layer
    When posted to MATCH setPatientTrigger
    Then a message "<returnMessage>" is returned with a "<status>"

    Examples:
      |studyId  |patientSequenceNumber    |stepNumber |patientStatus		   |message        					|accrualGroupId|returnMessage              							    |status			|
      |APEC1621 |PT-SuccessTest			  |1.0        |OFF_TRIAL_NOT_CONSENTED |Patient registered in Study		|22334a2sr     |This patient (PSN:PT-SuccessTest) is off-trial.			|FAILURE		|



  Scenario Outline: A Patient that had a patient trigger for OFF_TRIAL_DECEASED cannot successfully save a new setPatientTrigger with a different step or patientStatus.
    Given that Patient StudyID "<studyId>" PatientSeqNumber "<patientSequenceNumber>" StepNumber "<stepNumber>" PatientStatus "<patientStatus>" Message "<message>" AccrualGroupId "<accrualGroupId>" with "current" dateCreated is received from EA layer
    When posted to MATCH setPatientTrigger
    Then a message "<returnMessage>" is returned with a "<status>"

    Examples:
      |studyId  |patientSequenceNumber|stepNumber |patientStatus		   |message        					|accrualGroupId|returnMessage              												|status			|
      |APEC1621 |PT-OffTrial1		  |1.0        |REGISTRATION			   |Patient registered in Study		|22334a2sr     |Saved to datastore.														|SUCCESS		|
      |APEC1621 |PT-OffTrial1		  |1.0        |OFF_TRIAL_DECEASED	   |Patient passed away				|22334a2sr     |Saved to datastore.														|SUCCESS		|
      |APEC1621 |PT-OffTrial1		  |1.0        |OFF_TRIAL_NOT_CONSENTED |Patient passed away				|22334a2sr     |This patient (PSN:PT-OffTrial1) is off-trial.							|FAILURE		|
      |APEC1621 |PT-OffTrial1		  |1.1        |ON_TREATMENT_ARM        |Patient on TA     				|22334a2sr     |This patient (PSN:PT-OffTrial1) is off-trial.							|FAILURE		|


  Scenario Outline: MATCH returns a failure message when an invalid stepNumber is received from ECOG
    Given that Patient StudyID "<studyId>" PatientSeqNumber "<patientSequenceNumber>" StepNumber "<stepNumber>" PatientStatus "<patientStatus>" Message "<message>" AccrualGroupId "<accrualGroupId>" with "current" dateCreated is received from EA layer
    When posted to MATCH setPatientTrigger
    Then a message "<returnMessage>" is returned with a "<status>"

    Examples:
      |studyId  |patientSequenceNumber	|stepNumber |patientStatus		   	|message        					|accrualGroupId|returnMessage              												|status			|
      |APEC1621 |PT-Test4				|1.0        |REGISTRATION			|Patient trigger					|22334a2sr     |Saved to datastore.														|SUCCESS		|
      |APEC1621 |PT-Test4				|-2		  	|PROGRESSION            |Patient trigger					|22334a2sr     |stepNumber must match "[0-4]"											|FAILURE		|
      |APEC1621 |PT-Test4				|5.0	  	|PROGRESSION_REBIOPSY   |Patient trigger					|22334a2sr     |stepNumber must match "[0-4]"											|FAILURE		|



  Scenario Outline: A patient trigger will return an error message for PROGRESSION when the patient is not currently on a treatment arm.
    Given that Patient StudyID "<studyId>" PatientSeqNumber "<patientSequenceNumber>" StepNumber "<stepNumber>" PatientStatus "<patientStatus>" Message "<message>" AccrualGroupId "<accrualGroupId>" with "current" dateCreated is received from EA layer
    When posted to MATCH setPatientTrigger
    Then a message "<returnMessage>" is returned with a "<status>"

    Examples:
      |studyId|patientSequenceNumber	|stepNumber |patientStatus		   	|message        													|accrualGroupId|returnMessage              																				|status			|
      |APEC1621 |PT-Test5				|1.0        |REGISTRATION			|New patient.           											|22334a2sr     |Save to datastore.                                                                          			|SUCCESS   		|
      |APEC1621 |PT-Test5				|1.0        |PROGRESSION			|Patient has progressed.											|22334a2sr     |Must currently be on a treatment arm and have a successful biopsy to be moved to PROGRESSION.			|FAILURE		|



  Scenario Outline: Patient trigger with OFF_STUDY_NO_TA_AVAILABLE will be rejected by Match, when the patient is in step 0
    Given that Patient StudyID "<studyId>" PatientSeqNumber "<patientSequenceNumber>" StepNumber "<stepNumber>" PatientStatus "<patientStatus>" Message "<message>" AccrualGroupId "<accrualGroupId>" with "current" dateCreated is received from EA layer
    When posted to MATCH setPatientTrigger
    Then a message "<returnMessage>" is returned with a "<status>"

  Examples:
  |studyId|patientSequenceNumber	|stepNumber |patientStatus		   	            |message        													|accrualGroupId|returnMessage              																				|status			|
  |APEC1621 |PT-Test6				|1.0        |REGISTRATION			            |New patient.           											|22334a2sr     |Save to datastore.                                                                          			|SUCCESS   		|
  |APEC1621 |PT-Test6				|1.0        |OFF_TRIAL_NO_TA_AVAILABLE			|Patient has no TA      											|22334a2sr     |Patient (PSN:PT-Test6) cannot be moved to patient trigger status OFF_TRIAL_NO_TA_AVAILABLE. 			|FAILURE		|


  Scenario: When the incoming patient trigger's dateCreated is older than the previous trigger for the same patient MATCHbox rejects the trigger
    Given that Patient StudyID "APEC1621" PatientSeqNumber "PT-Test8" StepNumber "1.0" PatientStatus "REGISTRATION" Message "Patient REGISTERED" AccrualGroupId "22334a2sr" with "current" dateCreated is received from EA layer
    When posted to MATCH setPatientTrigger
    Then a message "Saved to datastore." is returned with a "success"
    Given that Patient StudyID "APEC1621" PatientSeqNumber "PT-Test8" StepNumber "1.0" PatientStatus "OFF_TRIAL" Message "Patient with OFF_TRIAL message" AccrualGroupId "22334a2sr" with "older" dateCreated is received from EA layer
    When posted to MATCH setPatientTrigger
    Then a message "Incoming OFF_TRIAL patient (PSN:PT-Test8) trigger has older date than the patient's registration date in the system" is returned with a "FAILURE"


  Scenario Outline: Date created cannot be a future date
    Given that Patient StudyID "<studyId>" PatientSeqNumber "<patientSequenceNumber>" StepNumber "<stepNumber>" PatientStatus "<patientStatus>" Message "<message>" AccrualGroupId "<accrualGroupId>" with "future" dateCreated is received from EA layer
    When posted to MATCH setPatientTrigger
    Then a message "<returnMessage>" is returned with a "<status>"

    Examples:
      |studyId|patientSequenceNumber|stepNumber |patientStatus		   |message        					|accrualGroupId|returnMessage              												|status			|
      |APEC1621 |PT-Test7			|1.0        |REGISTRATION		   |Patient registered in Study		|22334a2sr     |Incoming patient (PSN:PT-Test7) trigger date is after the current date.	|FAILURE		|
