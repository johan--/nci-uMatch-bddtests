@patient_seed_data

#  we are going to use patient load script instead of using this feature file to prepare patient seed data.
#  So the patients in this feature file is just a reminder that what patients are going to be generated


Feature: Patient seed data creation
#  Scenario Outline: Successfully register patient seed data
#    Given that Patient StudyID "<studyId>" PatientSeqNumber "<patient_id>" StepNumber "<stepNumber>" PatientStatus "<patientStatus>" Message "<message>" with "current" dateCreated is received from EA layer
#    When posted to MATCH patient registration
#    Then a message "<returnMessage>" is returned with a "<status>"
#
#    Examples:
#      |studyId  |patient_id                     |stepNumber |patientStatus		     |message        					|returnMessage          	|status			|
#      |APEC1621 |PT-ExistingPT		            |1.0        |REGISTRATION			 |Patient registered in Study		|Saved to datastore.		|Success		|
#      |APEC1621 |PT-SpecimenTest                |1.0        |REGISTRATION            |Patient to recieve specimen		|Saved to datastore.		|Success		|
#      |APEC1621 |PT-SpecimenTest-Progression    |1.0        |REGISTRATION            |Patient to recieve specimen		|Saved to datastore.		|Success		|
#      |APEC1621 |PT-SpecimenTest-TsNuAdFailure  |1.0        |REGISTRATION            |Patient to recieve specimen		|Saved to datastore.		|Success		|
#      |APEC1621 |PT-SpecimenTest-BdNuAdFailure  |1.0        |REGISTRATION            |Patient to recieve specimen		|Saved to datastore.		|Success		|
#      |APEC1621 |PT-SpecimenTest-OnTreatmentArm |1.0        |REGISTRATION            |Patient to recieve specimen		|Saved to datastore.		|Success		|


  ################### wait for implementation #####################


#  Scenario: Create patient data which is in OFF_STUDY status
#    using id:  PT-SpecimenTest-OffStudy


#   Scenario Outline: Create patient data which is in ON_TREATMENT_ARM status
#     Given that Patient StudyID "<studyId>" PatientSeqNumber "<patient_id>" StepNumber "<stepNumber>" PatientStatus "<patientStatus>" Message "<message>" with "current" dateCreated is received from EA layer
#     When posted to MATCH patient registration
#     Then specimen received
#     Then specimen shipped
#     Then....
#     Then on treatment arm
#     Examples:
#       |studyId  |patient_id                     |stepNumber |patientStatus		     |message        					|
#       |APEC1621 |PT-SpecimenTest-OnTreatmentArm |1.0        |REGISTRATION            |Patient to recieve specimen		|

#  Scenario: Create patient data which is in PROGRESSION status
#    using id:  PT-SpecimenTest-Progression

#  Scenario: Create patient data which is in TISSUE_NUCLEIC_ACID_FAILURE status
#    using id:  PT-SpecimenTest-TsNuAdFailure

#  Scenario: Create patient data which is in BLOOD_NUCLEIC_ACID_FAILURE status
#    using id:  PT-SpecimenTest-BdNuAdFailure

#  Scenario: Create patient data which is in specimen received status (TISSUE_SPECIMEN_RECEIVED or BLOOD_SPECIMEN_RECEIVED)
