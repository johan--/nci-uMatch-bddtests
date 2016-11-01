#encoding: utf-8
Feature: Patients request assignment tests

  @patients_p1
  Scenario Outline: PT_RA01. patient can be set to request assignment (rebiopsy=N) properly
#    patient: PT_ETE16_PendingApproval is on 1.0 now
#    patient: PT_ETE16_OnTreatmentArm is on 1.1 now
    Given template request assignment message for patient: "<patient_id>" with re-biopsy: "N", step number: "<next_step_number>"
    When post to MATCH patients service, returns a message that includes "processed successfully" with status "Success"
    Then patient field: "current_status" should have value: "PENDING_CONFIRMATION" within 30 seconds
    Then patient field: "current_step_number" should have value: "<next_step_number>" within 30 seconds
    Then patient should have selected treatment arm: "<ta_id>" with stratum id: "<ta_stratum_id>" within 15 seconds
    Examples:
      | patient_id               | next_step_number | ta_id          | ta_stratum_id |
      | PT_ETE16_PendingApproval | 1.0              | APEC1621-ETE-A | 100           |
      | PT_ETE16_OnTreatmentArm  | 2.0              | APEC1621-ETE-A | 100           |

  @patients_p2
  Scenario Outline: PT_RA02. patient can only be set to request assignment(rebiopsy=N) when patient is on certain status
    Given template request assignment message for patient: "<patient_id>" with re-biopsy: "N", step number: "<next_step_number>"
    When post to MATCH patients service, returns a message that includes "<message>" with status "<post_status>"
    Then patient field: "current_status" should have value: "<next_status>" within 30 seconds
    Examples:
      | patient_id                   | current_step_number | next_step_number | message | post_status | next_status                     |
      | PT_ETE17_PendingApproval     | 1.0                 | 1.0              |         | Success     | PENDING_CONFIRMATION            |
      | PT_ETE17_OnTreatmentArm      | 1.1                 | 2.0              |         | Success     | PENDING_CONFIRMATION            |
      | PT_ETE17_RequestNoAssignment | 1.1                 | 1.1              |         | Success     | PENDING_CONFIRMATION            |
      | PT_ETE17_RequestAssignment   | 1.0                 | 1.0              |         | Failure     | REQUEST_ASSIGNMENT              |
      | PT_ETE17_Registered          | 1.0                 | 1.0              |         | Failure     | REGISTRATION                    |
      | PT_ETE17_TsReceived          | 1.0                 | 1.0              |         | Failure     | TISSUE_SPECIMEN_RECEIVED        |
      | PT_ETE17_TsShipped           | 2.0                 | 2.0              |         | Failure     | TISSUE_NUCLEIC_ACID_SHIPPED     |
      | PT_ETE17_slideShipped        | 2.0                 | 2.0              |         | Failure     | TISSUE_SLIDE_SPECIMEN_SHIPPED   |
      | PT_ETE17_AssayReceived       | 1.0                 | 1.0              |         | Failure     | ASSAY_RESULTS_RECEIVED          |
      | PT_ETE17_TsVrReceived        | 2.0                 | 2.0              |         | Failure     | TISSUE_VARIANT_REPORT_RECEIVED  |
      | PT_ETE17_TsVrConfirmed       | 1.0                 | 1.0              |         | Failure     | TISSUE_VARIANT_REPORT_CONFIRMED |
      | PT_ETE17_TsVrRejected        | 1.0                 | 1.0              |         | Failure     | TISSUE_VARIANT_REPORT_REJECTED  |
    #there is no “PATHOLOGY_REVIEWED” status anymore
#      | PT_ETE17_PathoConfirmed      | PATHOLOGY_REVIEWED              | 2.0                 | 2.0              |         | Failure     | PATHOLOGY_REVIEWED              |

  @patients_p2
  Scenario Outline: PT_RA03. patient can only be set to request assignment(rebiopsy=Y) when patient is on certain status
    Given template request assignment message for patient: "<patient_id>" with re-biopsy: "Y", step number: "<next_step_number>"
    When post to MATCH patients service, returns a message that includes "<message>" with status "<post_status>"
    Then patient field: "current_status" should have value: "<next_status>" within 30 seconds
    Examples:
      | patient_id                   | current_step_number | next_step_number | message | post_status | next_status                     |
      | PT_ETE18_PendingApproval     | 1.0                 | 1.0              |         | Success     | REQUEST_ASSIGNMENT              |
      | PT_ETE18_OnTreatmentArm      | 1.1                 | 2.0              |         | Success     | REQUEST_ASSIGNMENT              |
      | PT_ETE18_RequestAssignment   | 1.0                 | 1.0              |         | Success     | REQUEST_ASSIGNMENT              |
      | PT_ETE18_RequestNoAssignment | 1.1                 | 1.1              |         | Success     | REQUEST_ASSIGNMENT              |
      | PT_ETE18_Registered          | 1.0                 | 1.0              |         | Failure     | REGISTRATION                    |
      | PT_ETE18_TsReceived          | 1.0                 | 1.0              |         | Failure     | TISSUE_SPECIMEN_RECEIVED        |
      | PT_ETE18_TsShipped           | 2.0                 | 2.0              |         | Failure     | TISSUE_NUCLEIC_ACID_SHIPPED     |
      | PT_ETE18_slideShipped        | 2.0                 | 2.0              |         | Failure     | TISSUE_SLIDE_SPECIMEN_SHIPPED   |
      | PT_ETE18_AssayReceived       | 1.0                 | 1.0              |         | Failure     | ASSAY_RESULTS_RECEIVED          |
      | PT_ETE18_TsVrReceived        | 2.0                 | 2.0              |         | Failure     | TISSUE_VARIANT_REPORT_RECEIVED  |
      | PT_ETE18_TsVrConfirmed       | 1.0                 | 1.0              |         | Failure     | TISSUE_VARIANT_REPORT_CONFIRMED |
      | PT_ETE18_TsVrRejected        | 1.0                 | 1.0              |         | Failure     | TISSUE_VARIANT_REPORT_REJECTED  |
    #there is no “PATHOLOGY_REVIEWED” status anymore
#      | PT_ETE18_PathoConfirmed      | PATHOLOGY_REVIEWED              | 2.0                 | 2.0              |         | Failure     | PATHOLOGY_REVIEWED              |

  @patients_p2
  Scenario: PT_RA04. any message should be rejected if patient is on "REQUEST_NO_ASSIGNMENT" status
#    patient: "PT_ETE19_RequestNoAssignment" with status: "REQUEST_NO_ASSIGNMENT" on step: "2.0"
#    this patients's active "TISSUE" molecular_id is "PT_ETE19_MOI2"
#    this patients's active "TISSUE" analysis_id is "PT_ETE19_ANI2"
    Given template variant report confirm message for patient: "PT_ETE19_RequestNoAssignment", it has analysis_id: "PT_ETE19_ANI2" and status: "confirm"
    When post to MATCH patients service, returns a message that includes "assignment" with status "Failure"
    Then template specimen received message in type: "TISSUE" for patient: "PT_ETE19_RequestNoAssignment", it has surgical_event_id: "PT_ETE19_SEI3"
    When post to MATCH patients service, returns a message that includes "assignment" with status "Failure"
    Then template specimen shipped message in type: "TISSUE" for patient: "PT_ETE19_RequestNoAssignment", it has surgical_event_id: "PT_ETE19_SEI2", molecular_id or slide_barcode: "PT_ETE19_MOI3"
    When post to MATCH patients service, returns a message that includes "assignment" with status "Failure"
    Then template variant file uploaded message for patient: "PT_ETE19_RequestNoAssignment", it has molecular_id: "PT_ETE19_MOI2" and analysis_id: "PT_ETE19_ANI4" and need files in S3 Y or N: "Y"
    When post to MATCH patients service, returns a message that includes "assignment" with status "Failure"
    Then template assay message with surgical_event_id: "PT_ETE19_SEI2" for patient: "PT_ETE19_RequestNoAssignment"
    When post to MATCH patients service, returns a message that includes "assignment" with status "Failure"


  @patients_p3
  Scenario: PT_RA05. request assignment message with rebiopsy = N will fail if the current biopsy is expired
#   patient: "PT_ETE10" with status: "ON_TREATMENT_ARM" on step: "1.1" the specimen received date is over 6 months ago
    Given template request assignment message for patient: "PT_ETE10" with re-biopsy: "N", step number: "2.0"
    When post to MATCH patients service, returns a message that includes "expired" with status "Failure"

  @patients_p1
  Scenario Outline: PT_RA06. assignment process should not be triggered if assignment request has rebiopsy = Y
    Given template request assignment message for patient: "<patient_id>" with re-biopsy: "Y", step number: "2.0"
    When post to MATCH patients service, returns a message that includes "processed successfully" with status "Success"
    Then patient field: "current_status" should have value: "REQUEST_ASSIGNMENT" after 30 seconds
    Examples:
      | patient_id              | current_step_number |
      | PT_ETE11_OnTreatmentArm | 1.1                 |
      | PT_ETE11_PendingAproval | 1.0                 |

#    not required anymore
#  Scenario Outline: PT_RA07. assignment request will fail if patient is on step 4.1
#    Given patient: "<patient_id>" with status: "ON_TREATMENT_ARM" on step: "4.1"
#    Given patient is currently on treatment arm: "APEC1621-A", stratum: "100"
#    Then requests assignment for this patient with re-biopsy: "<rebiopsy>", step number: "5.0"
#    Then API returns a message that includes "4" with status "Failure"
#    Examples:
#    |patient_id     |rebiopsy |
#    |PT_ETE13_OnTA1 |Y        |
#    |PT_ETE13_OnTA2 |N        |