#encoding: utf-8
Feature: Patients request assignment tests

  @patients_p1
  Scenario Outline: PT_RA01. patient can be set to request assignment (rebiopsy=N) properly
    Given patient: "<patient_id>" with status: "<current_status>" on step: "<current_step_number>"
    Then requests assignment for this patient with re-biopsy: "N", step number: "<next_step_number>"
    Then patient status should be "PENDING_CONFIRMATION" within 30 seconds
    Then patient step number should be "<next_step_number>" within 15 seconds
    Then patient should have selected treatment arm: "<ta_id>" with stratum id: "<ta_stratum_id>" within 15 seconds
    Examples:
      | patient_id               | current_status   | current_step_number | next_step_number | ta_id          | ta_stratum_id |
      | PT_ETE16_PendingApproval | PENDING_APPROVAL | 1.0                 | 1.0              | APEC1621-ETE-A | 100           |
      | PT_ETE16_OnTreatmentArm  | ON_TREATMENT_ARM | 1.1                 | 2.0              | APEC1621-ETE-A | 100           |

  @patients_p2
  Scenario Outline: PT_RA02. patient can only be set to request assignment(rebiopsy=N) when patient is on certain status
    Given patient: "<patient_id>" with status: "<current_status>" on step: "<current_step_number>"
    Then requests assignment for this patient with re-biopsy: "N", step number: "<next_step_number>"
    Then API returns a message that includes "<message>" with status "<post_status>"
    Then patient status should be "<next_status>" within 30 seconds
    Examples:
      | patient_id                   | current_status                  | current_step_number | next_step_number | message | post_status | next_status                     |
      | PT_ETE17_PendingApproval     | PENDING_APPROVAL                | 1.0                 | 1.0              |         | Success     | PENDING_CONFIRMATION            |
      | PT_ETE17_OnTreatmentArm      | ON_TREATMENT_ARM                | 1.1                 | 2.0              |         | Success     | PENDING_CONFIRMATION            |
      | PT_ETE17_RequestNoAssignment | REQUEST_NO_ASSIGNMENT           | 1.1                 | 1.1              |         | Success     | PENDING_CONFIRMATION            |
      | PT_ETE17_RequestAssignment   | REQUEST_ASSIGNMENT              | 1.0                 | 1.0              |         | Failure     | REQUEST_ASSIGNMENT              |
      | PT_ETE17_Registered          | REGISTRATION                    | 1.0                 | 1.0              |         | Failure     | REGISTRATION                    |
      | PT_ETE17_TsReceived          | TISSUE_SPECIMEN_RECEIVED        | 1.0                 | 1.0              |         | Failure     | TISSUE_SPECIMEN_RECEIVED        |
      | PT_ETE17_TsShipped           | TISSUE_NUCLEIC_ACID_SHIPPED     | 2.0                 | 2.0              |         | Failure     | TISSUE_NUCLEIC_ACID_SHIPPED     |
      | PT_ETE17_slideShipped        | TISSUE_SLIDE_SPECIMEN_SHIPPED   | 2.0                 | 2.0              |         | Failure     | TISSUE_SLIDE_SPECIMEN_SHIPPED   |
      | PT_ETE17_AssayReceived       | ASSAY_RESULTS_RECEIVED          | 1.0                 | 1.0              |         | Failure     | ASSAY_RESULTS_RECEIVED          |
      | PT_ETE17_TsVrReceived        | TISSUE_VARIANT_REPORT_RECEIVED  | 2.0                 | 2.0              |         | Failure     | TISSUE_VARIANT_REPORT_RECEIVED  |
      | PT_ETE17_TsVrConfirmed       | TISSUE_VARIANT_REPORT_CONFIRMED | 1.0                 | 1.0              |         | Failure     | TISSUE_VARIANT_REPORT_CONFIRMED |
      | PT_ETE17_TsVrRejected        | TISSUE_VARIANT_REPORT_REJECTED  | 1.0                 | 1.0              |         | Failure     | TISSUE_VARIANT_REPORT_REJECTED  |
    #there is no “PATHOLOGY_REVIEWED” status anymore
#      | PT_ETE17_PathoConfirmed      | PATHOLOGY_REVIEWED              | 2.0                 | 2.0              |         | Failure     | PATHOLOGY_REVIEWED              |

  @patients_p2
  Scenario Outline: PT_RA03. patient can only be set to request assignment(rebiopsy=Y) when patient is on certain status
    Given patient: "<patient_id>" with status: "<current_status>" on step: "<current_step_number>"
    Then requests assignment for this patient with re-biopsy: "Y", step number: "<next_step_number>"
    Then API returns a message that includes "<message>" with status "<post_status>"
    Then patient status should be "<next_status>" within 30 seconds
    Examples:
      | patient_id                   | current_status                  | current_step_number | next_step_number | message | post_status | next_status                     |
      | PT_ETE18_PendingApproval     | PENDING_APPROVAL                | 1.0                 | 1.0              |         | Success     | REQUEST_ASSIGNMENT              |
      | PT_ETE18_OnTreatmentArm      | ON_TREATMENT_ARM                | 1.1                 | 2.0              |         | Success     | REQUEST_ASSIGNMENT              |
      | PT_ETE18_RequestAssignment   | REQUEST_ASSIGNMENT              | 1.0                 | 1.0              |         | Success     | REQUEST_ASSIGNMENT              |
      | PT_ETE18_RequestNoAssignment | REQUEST_NO_ASSIGNMENT           | 1.1                 | 1.1              |         | Failure     | REQUEST_ASSIGNMENT              |
      | PT_ETE18_Registered          | REGISTRATION                    | 1.0                 | 1.0              |         | Failure     | REGISTRATION                    |
      | PT_ETE18_TsReceived          | TISSUE_SPECIMEN_RECEIVED        | 1.0                 | 1.0              |         | Failure     | TISSUE_SPECIMEN_RECEIVED        |
      | PT_ETE18_TsShipped           | TISSUE_NUCLEIC_ACID_SHIPPED     | 2.0                 | 2.0              |         | Failure     | TISSUE_NUCLEIC_ACID_SHIPPED     |
      | PT_ETE18_slideShipped        | TISSUE_SLIDE_SPECIMEN_SHIPPED   | 2.0                 | 2.0              |         | Failure     | TISSUE_SLIDE_SPECIMEN_SHIPPED   |
      | PT_ETE18_AssayReceived       | ASSAY_RESULTS_RECEIVED          | 1.0                 | 1.0              |         | Failure     | ASSAY_RESULTS_RECEIVED          |
      | PT_ETE18_TsVrReceived        | TISSUE_VARIANT_REPORT_RECEIVED  | 2.0                 | 2.0              |         | Failure     | TISSUE_VARIANT_REPORT_RECEIVED  |
      | PT_ETE18_TsVrConfirmed       | TISSUE_VARIANT_REPORT_CONFIRMED | 1.0                 | 1.0              |         | Failure     | TISSUE_VARIANT_REPORT_CONFIRMED |
      | PT_ETE18_TsVrRejected        | TISSUE_VARIANT_REPORT_REJECTED  | 1.0                 | 1.0              |         | Failure     | TISSUE_VARIANT_REPORT_REJECTED  |
    #there is no “PATHOLOGY_REVIEWED” status anymore
#      | PT_ETE18_PathoConfirmed      | PATHOLOGY_REVIEWED              | 2.0                 | 2.0              |         | Failure     | PATHOLOGY_REVIEWED              |

  @patients_p2
  Scenario: PT_RA04. any message should be rejected if patient is on "REQUEST_NO_ASSIGNMENT" status
    Given patient: "PT_ETE19_RequestNoAssignment" with status: "REQUEST_NO_ASSIGNMENT" on step: "2.0"
    Given this patients's active "TISSUE" molecular_id is "PT_ETE19_MOI2"
    Given this patients's active "TISSUE" analysis_id is "PT_ETE19_ANI2"
    Given this patients's active "BLOOD" molecular_id is "PT_ETE19_BD_MOI1"
    #    Then "BLOOD" variant report uploaded with analysis_id: "PT_ETE19_ANI3"
    #    Then API returns a message that includes "assignment" with status "Failure"
    Then "TISSUE" variant report confirmed with status: "CONFIRMED"
    Then API returns a message that includes "assignment" with status "Failure"
    Then tissue specimen received with surgical_event_id: "PT_ETE19_SEI3"
    Then API returns a message that includes "assignment" with status "Failure"
    Then "TISSUE" specimen shipped to "MDA" with molecular_id or slide_barcode: "PT_ETE19_MOI3"
    Then API returns a message that includes "assignment" with status "Failure"
    Then "TISSUE" variant report uploaded with analysis_id: "PT_ETE19_ANI4"
    Then API returns a message that includes "assignment" with status "Failure"
    Then "ICCMLH1s" assay result received result: "NEGATIVE"
    Then API returns a message that includes "assignment" with status "Failure"


  @patients_p3
  Scenario: PT_RA05. request assignment message with rebiopsy = N will fail if the current biopsy is expired
    Given patient: "PT_ETE10" with status: "ON_TREATMENT_ARM" on step: "1.1"
    Given other background and comments for this patient: "the specimen received date is over 6 months ago"
    Given patient is currently on treatment arm: "APEC1621-A", stratum: "100"
    Then requests assignment for this patient with re-biopsy: "N", step number: "2.0"
    Then API returns a message that includes "expired" with status "Failure"

  @patients_p1
  Scenario Outline: PT_RA06. assignment process should not be triggered if assignment request has rebiopsy = Y
    Given patient: "<patient_id>" with status: "<patient_status>" on step: "<step_number>"
    Given patient is currently on treatment arm: "APEC1621-A", stratum: "100"
    Then requests assignment for this patient with re-biopsy: "Y", step number: "2.0"
    Then patient status should be "REQUEST_ASSIGNMENT" after 30 seconds
    Examples:
      | patient_id              | patient_status   | step_number |
      | PT_ETE11_OnTreatmentArm | ON_TREATMENT_ARM | 1.1         |
      | PT_ETE11_PendingAproval | PENDING_APPROVAL | 1.0         |

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