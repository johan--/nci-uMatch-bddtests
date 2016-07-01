@patients
Feature: Register a new patient in PEDMatchbox

  Scenario Outline: Successfully register a patient in MATCH
    Given that Patient StudyID "<studyId>" PatientSeqNumber "<patient_id>" StepNumber "<stepNumber>" PatientStatus "<patientStatus>" Message "<message>" with "current" dateCreated is received from EA layer
    When posted to MATCH patient registration
    Then a message "<returnMessage>" is returned with a "<status>"

    Examples:
      |studyId  |patient_id           |stepNumber |patientStatus		   |message        					|returnMessage          	|status			|
      |APEC1621 |PT-SuccessTest		  |1.0        |REGISTRATION			   |Patient registered in Study		|Saved to datastore.		|Success		|


  Scenario Outline: MATCH returns an error when a new patient trigger is received with an empty patient_id
    Given that Patient StudyID "<studyId>" PatientSeqNumber "<patient_id>" StepNumber "<stepNumber>" PatientStatus "<patientStatus>" Message "<message>" with "current" dateCreated is received from EA layer
    When posted to MATCH patient registration
    Then a message "<returnMessage>" is returned with a "<status>"

    Examples:
      |studyId  |patient_id|stepNumber |patientStatus		   |message        					|returnMessage						|status			|
      |APEC1621 |		   |1.0		  |REGISTRATION			   |Patient registered in Study		|Patient id may not be empty.		|Failure		|


  Scenario Outline: MATCH returns an error when a new patient trigger is received with an empty stepNumber
    Given that Patient StudyID "<studyId>" PatientSeqNumber "<patient_id>" StepNumber "<stepNumber>" PatientStatus "<patientStatus>" Message "<message>" with "current" dateCreated is received from EA layer
    When posted to MATCH patient registration
    Then a message "<returnMessage>" is returned with a "<status>"

    Examples:
      |studyId  |patient_id|stepNumber  |patientStatus		    |message        					|returnMessage                  |status			|
      |APEC1621 |PT-Test1  |		    |REGISTRATION			|Patient registered in Study		|stepNumber may not be empty    |Failure		|

  Scenario Outline: MATCH returns an error when a new patient trigger is received with an INVALID stepNumber
    Given that Patient StudyID "<studyId>" PatientSeqNumber "<patient_id>" StepNumber "<stepNumber>" PatientStatus "<patientStatus>" Message "<message>" with "current" dateCreated is received from EA layer
    When posted to MATCH patient registration
    Then a message "<returnMessage>" is returned with a "<status>"

    Examples:
      |studyId  |patient_id |stepNumber   |patientStatus		   |message        					|returnMessage			|status			|
      |APEC1621 |PT-Test1   |1.1		  |REGISTRATION			   |Patient registered in Study		|stepNumber must be 1.0	|Failure		|



  Scenario Outline: MATCH returns an error message when new patient trigger is received from COG for an already registered patient
    Given that Patient StudyID "<studyId>" PatientSeqNumber "<patient_id>" StepNumber "<stepNumber>" PatientStatus "<patientStatus>" Message "<message>" with "current" dateCreated is received from EA layer
    When posted to MATCH patient registration
    Then a message "<returnMessage>" is returned with a "<status>"

    Examples:
      |studyId  |patient_id     |stepNumber |patientStatus  		   |message        					|returnMessage              											|status			|
      |APEC1621 |PT-SuccessTest	|1.0        |REGISTRATION			   |Patient registered in Study		|This patient (Patient Id:PT-SuccessTest) is already registered.		|Failure		|


  Scenario Outline: A Patient can go off-study at any time even when the patient is in stepNumber 1.0 and a patient trigger is received with OFF_STUDY_DECEASED status.
    Given that Patient StudyID "<studyId>" PatientSeqNumber "<patient_id>" StepNumber "<stepNumber>" PatientStatus "<patientStatus>" Message "<message>" with "current" dateCreated is received from EA layer
    When posted to MATCH patient registration
    Then a message "<returnMessage>" is returned with a "<status>"

    Examples:
      |studyId  |patient_id     |stepNumber |patientStatus		   |message        		|returnMessage        |status	    |
      |APEC1621 |PT-SuccessTest	|1.0        |OFF_STUDY_DECEASED    |Patient passed away	|Saved to datastore.  |Success		|



  Scenario Outline: Attempt to set a different off-study status after the patient has already been updated with an off-study status.
    Given that Patient StudyID "<studyId>" PatientSeqNumber "<patient_id>" StepNumber "<stepNumber>" PatientStatus "<patientStatus>" Message "<message>" with "current" dateCreated is received from EA layer
    When posted to MATCH patient registration
    Then a message "<returnMessage>" is returned with a "<status>"

    Examples:
      |studyId  |patient_id     |stepNumber |patientStatus   |message        	    |returnMessage              							    |status			|
      |APEC1621 |PT-SuccessTest	|1.0        |OFF_STUDY       |Patient off-study		|This patient (PSN:PT-SuccessTest) is off-study.			|Failure		|



  Scenario Outline: A Patient that had a patient trigger for OFF_STUDY_DECEASED cannot successfully save a new setPatientTrigger with a different step or patientStatus.
    Given that Patient StudyID "<studyId>" PatientSeqNumber "<patient_id>" StepNumber "<stepNumber>" PatientStatus "<patientStatus>" Message "<message>" with "current" dateCreated is received from EA layer
    When posted to MATCH patient registration
    Then a message "<returnMessage>" is returned with a "<status>"

    Examples:
      |studyId  |patient_id           |stepNumber |patientStatus		   |message        					|returnMessage                  			    |status			|
      |APEC1621 |PT-OffTrial1		  |1.0        |REGISTRATION			   |Patient registered in Study		|Saved to datastore.    						|Success		|
      |APEC1621 |PT-OffTrial1		  |1.0        |OFF_STUDY_DECEASED  	   |Patient passed away				|Saved to datastore.							|Success		|
      |APEC1621 |PT-OffTrial1		  |1.0        |REGISTRATION            |Patient registered again     	|This patient (PSN:PT-OffTrial1) is off-study.	|Failure		|


  Scenario Outline: MATCH returns a failure message when an invalid stepNumber is received from COG
    Given that Patient StudyID "<studyId>" PatientSeqNumber "<patient_id>" StepNumber "<stepNumber>" PatientStatus "<patientStatus>" Message "<message>" with "current" dateCreated is received from EA layer
    When posted to MATCH patient registration
    Then a message "<returnMessage>" is returned with a "<status>"

    Examples:
      |studyId  |patient_id	|stepNumber |patientStatus		   	|message        					|returnMessage                                                                  |status			|
      |APEC1621 |PT-Test4	|1.0        |REGISTRATION			|Patient trigger					|Saved to datastore.	                                                        |Success		|
      |APEC1621 |PT-Test4	|2.0		|PROGRESSION            |Patient trigger					|Cannot move from step 1.0 to step 2.0                                          |Failure		|
      |APEC1621 |PT-Test4   |1.1        |PROGRESSION            |Patient progression                |Cannot receive a progression status when the patient is still in registration  |Failure        |




  Scenario Outline: A patient trigger will return an error message for PROGRESSION when the patient is not currently on a treatment arm.
    Given that Patient StudyID "<studyId>" PatientSeqNumber "<patient_id>" StepNumber "<stepNumber>" PatientStatus "<patientStatus>" Message "<message>" with "current" dateCreated is received from EA layer
    When posted to MATCH patient registration
    Then a message "<returnMessage>" is returned with a "<status>"

    Examples:
      |studyId|patient_id	|stepNumber |patientStatus		   	|message        													|accrualGroupId|returnMessage              																				|status			|
      |APEC1621 |PT-Test5				|1.0        |REGISTRATION			|New patient.           											|22334a2sr     |Save to datastore.                                                                          			|Success   		|
      |APEC1621 |PT-Test5				|1.0        |PROGRESSION			|Patient has progressed.											|22334a2sr     |Must currently be on a treatment arm and have a successful biopsy to be moved to PROGRESSION.			|Failure		|


  Scenario: When the incoming patient trigger's dateCreated is older than the previous trigger for the same patient MATCHbox rejects the trigger
    Given that Patient StudyID "<studyId>" PatientSeqNumber "<patient_id>" StepNumber "<stepNumber>" PatientStatus "<patientStatus>" Message "<message>" with "current" dateCreated is received from EA layer
    When posted to MATCH patient registration
    Then a message "Saved to datastore." is returned with a "Success"
    Given that Patient StudyID "APEC1621" PatientSeqNumber "PT-Test8" StepNumber "1.0" PatientStatus "OFF_STUDY" Message "Patient with OFF_TRIAL message" with "older" dateCreated is received from EA layer
    When posted to MATCH patient registration
    Then a message "Incoming OFF_STUDY patient (PSN:PT-Test8) trigger has older date than the patient's registration date in the system" is returned with a "Failure"


  Scenario Outline: Date created cannot be a future date
    Given that Patient StudyID "<studyId>" PatientSeqNumber "<patient_id>" StepNumber "<stepNumber>" PatientStatus "<patientStatus>" Message "<message>" with "future" dateCreated is received from EA layer
    When posted to MATCH patient registration
    Then a message "<returnMessage>" is returned with a "<status>"

    Examples:
      |studyId|patient_id   |stepNumber |patientStatus		   |message        					|returnMessage              												|status			|
      |APEC1621 |PT-Test7	|1.0        |REGISTRATION		   |Patient registered in Study		|Incoming patient (PSN:PT-Test7) trigger date is after the current date.	|Failure		|
