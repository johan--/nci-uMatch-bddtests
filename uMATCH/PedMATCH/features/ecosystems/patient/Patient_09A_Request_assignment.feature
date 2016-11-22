#encoding: utf-8
Feature: Patients request assignment tests

  @patients_p1
  Scenario Outline: PT_RA01. patient can be set to request assignment (rebiopsy=N) properly
#    patient: PT_RA01_PendingApproval is on 1.0 now
#    patient: PT_RA01_OnTreatmentArm is on 1.1 now
    Given template request assignment message for patient: "<patient_id>" with re-biopsy: "N", step number: "<next_step_number>"
    When post to MATCH patients service, returns a message that includes "processed successfully" with status "Success"
    Then patient field: "current_status" should have value: "PENDING_CONFIRMATION" within 30 seconds
    Then patient field: "current_step_number" should have value: "<next_step_number>" within 30 seconds
    Then patient should have selected treatment arm: "<ta_id>" with stratum id: "<ta_stratum_id>" within 15 seconds
    Examples:
      | patient_id              | next_step_number | ta_id          | ta_stratum_id |
      | PT_RA01_PendingApproval | 1.0              | APEC1621-ETE-A | 100           |
      | PT_RA01_OnTreatmentArm  | 2.0              | APEC1621-ETE-A | 100           |

  @patients_p2
  Scenario Outline: PT_RA02. patient can only be set to request assignment(rebiopsy=N) when patient is on certain status
    Given template request assignment message for patient: "<patient_id>" with re-biopsy: "N", step number: "<next_step_number>"
    When post to MATCH patients service, returns a message that includes "<message>" with status "<post_status>"
    Then patient field: "current_status" should have value: "<next_status>" within 30 seconds
    Examples:
      | patient_id                  | current_step_number | next_step_number | message | post_status | next_status                     |
      | PT_RA02_PendingConfirmation | 1.0                 | 1.0              |         | Failure     | PENDING_CONFIRMATION            |
      | PT_RA02_PendingApproval     | 1.0                 | 1.0              |         | Success     | PENDING_CONFIRMATION            |
      | PT_RA02_OnTreatmentArm      | 1.1                 | 2.0              |         | Success     | PENDING_CONFIRMATION            |
      | PT_RA02_RequestNoAssignment | 1.1                 | 1.1              |         | Success     | PENDING_CONFIRMATION            |
      | PT_RA02_Registered          | 1.0                 | 1.0              |         | Failure     | REGISTRATION                    |
      | PT_RA02_TsReceived          | 1.0                 | 1.0              |         | Failure     | TISSUE_SPECIMEN_RECEIVED        |
      | PT_RA02_TsShipped           | 2.0                 | 2.0              |         | Failure     | TISSUE_NUCLEIC_ACID_SHIPPED     |
      | PT_RA02_slideShipped        | 2.0                 | 2.0              |         | Failure     | TISSUE_SLIDE_SPECIMEN_SHIPPED   |
      | PT_RA02_AssayReceived       | 1.0                 | 1.0              |         | Failure     | ASSAY_RESULTS_RECEIVED          |
      | PT_RA02_TsVrReceived        | 2.0                 | 2.0              |         | Failure     | TISSUE_VARIANT_REPORT_RECEIVED  |
      | PT_RA02_TsVrConfirmed       | 1.0                 | 1.0              |         | Failure     | TISSUE_VARIANT_REPORT_CONFIRMED |
      | PT_RA02_TsVrRejected        | 1.0                 | 1.0              |         | Failure     | TISSUE_VARIANT_REPORT_REJECTED  |
      | PT_RA02_NoTaAvailable       | 1.0                 | 1.0              |         | Failure     | NO_TA_AVAILABLE                 |
      | PT_RA02_CompassionateCare   | 1.0                 | 1.0              |         | Failure     | COMPASSIONATE_CARE              |
#   for the case: OFF_STUDY and OFF_STUDY_BIOPSY_EXPIRED, please check test PT_OS04
#    for the case: current status REQUEST_ASSIGNMENT then receive request assignment(rebiopsy=N), please check test PT_RA02a
#      | PT_RA02_RequestAssignment   | 1.0                 | 1.0              |         | Failure     | REQUEST_ASSIGNMENT              |
    #there is no “PATHOLOGY_REVIEWED” status anymore
#      | PT_RA02_PathoConfirmed      | 2.0                 | 2.0              |         | Failure     | PATHOLOGY_REVIEWED              |

  @patients_p3
  Scenario: PT_RA02a. request assignment(rebiopsy=N) should trigger assignment again if patient is on REQUEST_ASSIGNMENT status
    Given template request assignment message for patient: "PT_RA02a_RequestAssignment" with re-biopsy: "N", step number: "2.0"
    When post to MATCH patients service, returns a message that includes "processed successfully" with status "Success"
    Then patient field: "current_status" should have value: "PENDING_CONFIRMATION" within 30 seconds
    Then patient field: "current_step_number" should have value: "2.0" within 30 seconds
    Then patient should have selected treatment arm: "APEC1621-ETE-A" with stratum id: "100" within 15 seconds

  @patients_p2
  Scenario Outline: PT_RA03. patient can only be set to request assignment(rebiopsy=Y) when patient is on certain status
#    if patient is REQUEST_ASSIGNMENT status then it make no sense to receive another same request assignment (rebiopsy=Y) message, so reject it
    Given template request assignment message for patient: "<patient_id>" with re-biopsy: "Y", step number: "<next_step_number>"
    When post to MATCH patients service, returns a message that includes "<message>" with status "<post_status>"
    Then patient field: "current_status" should have value: "<next_status>" within 30 seconds
    Examples:
      | patient_id                  | current_step_number | next_step_number | message | post_status | next_status                     |
      | PT_RA03_PendingConfirmation | 1.0                 | 1.0              |         | Failure     | PENDING_CONFIRMATION            |
      | PT_RA03_PendingApproval     | 1.0                 | 1.0              |         | Success     | REQUEST_ASSIGNMENT              |
      | PT_RA03_OnTreatmentArm      | 1.1                 | 2.0              |         | Success     | REQUEST_ASSIGNMENT              |
      | PT_RA03_RequestAssignment   | 1.0                 | 1.0              |         | Failure     | REQUEST_ASSIGNMENT              |
      | PT_RA03_RequestNoAssignment | 1.1                 | 1.1              |         | Success     | REQUEST_ASSIGNMENT              |
      | PT_RA03_Registered          | 1.0                 | 1.0              |         | Failure     | REGISTRATION                    |
      | PT_RA03_TsReceived          | 1.0                 | 1.0              |         | Failure     | TISSUE_SPECIMEN_RECEIVED        |
      | PT_RA03_TsShipped           | 2.0                 | 2.0              |         | Failure     | TISSUE_NUCLEIC_ACID_SHIPPED     |
      | PT_RA03_slideShipped        | 2.0                 | 2.0              |         | Failure     | TISSUE_SLIDE_SPECIMEN_SHIPPED   |
      | PT_RA03_AssayReceived       | 1.0                 | 1.0              |         | Failure     | ASSAY_RESULTS_RECEIVED          |
      | PT_RA03_TsVrReceived        | 2.0                 | 2.0              |         | Failure     | TISSUE_VARIANT_REPORT_RECEIVED  |
      | PT_RA03_TsVrConfirmed       | 1.0                 | 1.0              |         | Failure     | TISSUE_VARIANT_REPORT_CONFIRMED |
      | PT_RA03_TsVrRejected        | 1.0                 | 1.0              |         | Failure     | TISSUE_VARIANT_REPORT_REJECTED  |
      | PT_RA03_NoTaAvailable       | 1.0                 | 1.0              |         | Failure     | NO_TA_AVAILABLE                 |
      | PT_RA03_CompassionateCare   | 1.0                 | 1.0              |         | Failure     | COMPASSIONATE_CARE              |
#   for the case: OFF_STUDY and OFF_STUDY_BIOPSY_EXPIRED, please check test PT_OS04
    #there is no “PATHOLOGY_REVIEWED” status anymore
#      | PT_RA03_PathoConfirmed      | PATHOLOGY_REVIEWED              | 2.0                 | 2.0              |         | Failure     | PATHOLOGY_REVIEWED              |

  @patients_p2
  Scenario: PT_RA04. any message other than request assignment(Rebiopsy=Y) and off study should be rejected if patient is on "REQUEST_NO_ASSIGNMENT" status
#    patient: "PT_RA04_ReqNoAssignment" with status: "REQUEST_NO_ASSIGNMENT" on step: "2.0"
    Given template variant report confirm message for patient: "PT_RA04_ReqNoAssignment", it has analysis_id: "PT_RA04_ReqNoAssignment_ANI2" and status: "confirm"
    When post to MATCH patients service, returns a message that includes "assignment" with status "Failure"
    Then template specimen received message in type: "TISSUE" for patient: "PT_RA04_ReqNoAssignment", it has surgical_event_id: "PT_RA04_ReqNoAssignment_SEI3"
    When post to MATCH patients service, returns a message that includes "assignment" with status "Failure"
    Then template specimen shipped message in type: "TISSUE" for patient: "PT_RA04_ReqNoAssignment", it has surgical_event_id: "PT_RA04_ReqNoAssignment_SEI2", molecular_id or slide_barcode: "PT_RA04_ReqNoAssignment_MOI3"
    When post to MATCH patients service, returns a message that includes "assignment" with status "Failure"
    Then template variant file uploaded message for patient: "PT_RA04_ReqNoAssignment", it has molecular_id: "PT_RA04_ReqNoAssignment_MOI2" and analysis_id: "PT_RA04_ReqNoAssignment_ANI4" and need files in S3 Y or N: "Y"
    When post to MATCH patients service, returns a message that includes "assignment" with status "Failure"
    Then template assay message with surgical_event_id: "PT_RA04_ReqNoAssignment_SEI1" for patient: "PT_RA04_ReqNoAssignment"
    When post to MATCH patients service, returns a message that includes "assignment" with status "Failure"

  @patients_p2
  Scenario Outline: PT_RA04a patient can be set to request no assignment only on certain status
    Given template request no assignment message for patient: "<patient_id>" with step number: "<next_step_number>"
    When post to MATCH patients service, returns a message that includes "<message>" with status "<post_status>"
    Then patient field: "current_status" should have value: "<next_status>" within 30 seconds
    Examples:
      | patient_id                     | next_step_number | message | post_status | next_status                     |
      | PT_RA04a_PendingConfirmation   | 1.0              |         | Failure     | PENDING_CONFIRMATION            |
      | PT_RA04a_PendingApproval       | 1.0              |         | Success     | REQUEST_NO_ASSIGNMENT           |
      | PT_RA04a_OnTreatmentArm        | 1.1              |         | Success     | REQUEST_NO_ASSIGNMENT           |
      | PT_RA04a_RequestAssignment     | 1.0              |         | Success     | REQUEST_NO_ASSIGNMENT           |
      | PT_RA04a_RequestNoAssignment   | 1.1              |         | Failure     | REQUEST_NO_ASSIGNMENT           |
      | PT_RA04a_Registered            | 1.0              |         | Failure     | REGISTRATION                    |
      | PT_RA04a_TsReceived            | 1.0              |         | Failure     | TISSUE_SPECIMEN_RECEIVED        |
      | PT_RA04a_TsShipped             | 2.0              |         | Failure     | TISSUE_NUCLEIC_ACID_SHIPPED     |
      | PT_RA04a_slideShipped          | 2.0              |         | Failure     | TISSUE_SLIDE_SPECIMEN_SHIPPED   |
      | PT_RA04a_AssayReceived         | 1.0              |         | Failure     | ASSAY_RESULTS_RECEIVED          |
      | PT_RA04a_TsVrReceived          | 2.0              |         | Failure     | TISSUE_VARIANT_REPORT_RECEIVED  |
      | PT_RA04a_TsVrConfirmed         | 1.0              |         | Failure     | TISSUE_VARIANT_REPORT_CONFIRMED |
      | PT_RA04a_TsVrRejected          | 1.0              |         | Failure     | TISSUE_VARIANT_REPORT_REJECTED  |
      | PT_RA04a_NoTaAvailable         | 1.0              |         | Success     | REQUEST_NO_ASSIGNMENT           |
      | PT_RA04a_CompassionateCare     | 1.0              |         | Success     | REQUEST_NO_ASSIGNMENT           |
      | PT_RA04a_OffStudy              | 1.0              |         | Failure     | OFF_STUDY                       |
      | PT_RA04a_OffStudyBiopsyExpired | 1.0              |         | Failure     | OFF_STUDY_BIOPSY_EXPIRED        |

#  PT_RA04b off study and request assignment message should be accepted when patient is on request no assignment status
#    please check test PT_OS01 last example and PT_RA02 example 3, PT_RA03 example 4
#

  @patients_p3
  Scenario: PT_RA05. request assignment message with rebiopsy = N will fail if the current biopsy is expired
#   patient: "PT_RA05_OnTreatmentArm" with status: "ON_TREATMENT_ARM" on step: "1.1" the specimen received date is over 6 months ago
    Given template request assignment message for patient: "PT_RA05_OnTreatmentArm" with re-biopsy: "N", step number: "2.0"
    When post to MATCH patients service, returns a message that includes "expired" with status "Failure"

  @patients_p1
  Scenario Outline: PT_RA06. assignment process should not be triggered if assignment request has rebiopsy = Y
    Given template request assignment message for patient: "<patient_id>" with re-biopsy: "Y", step number: "2.0"
    When post to MATCH patients service, returns a message that includes "processed successfully" with status "Success"
    Then patient field: "current_status" should have value: "REQUEST_ASSIGNMENT" after 30 seconds
    Examples:
      | patient_id             | current_step_number |
      | PT_RA06_OnTreatmentArm | 1.1                 |
      | PT_RA06_PendingAproval | 1.0                 |
