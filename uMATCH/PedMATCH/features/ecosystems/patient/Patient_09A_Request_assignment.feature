#encoding: utf-8
Feature: Patients request assignment tests
  Background:
    Given patient API user authorization role is "PATIENT_MESSAGE_SENDER"

  @patients_p1
  Scenario Outline: PT_RA01. patient can be set to request assignment (rebiopsy=N) properly
#    patient: PT_RA01_PendingApproval is on 1.0 now
#    patient: PT_RA01_OnTreatmentArm is on 1.1 now
    Given patient id is "<patient_id>"
    And load template request assignment message for this patient
    Then set patient message field: "rebiopsy" to value: "N"
    And set patient message field: "step_number" to value: "<next_step_number>"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "PENDING_CONFIRMATION"
    Then patient field: "current_step_number" should have value: "<next_step_number>"
    Then patient should have selected treatment arm: "<ta_id>" with stratum id: "<ta_stratum_id>"
    Examples:
      | patient_id              | next_step_number | ta_id          | ta_stratum_id |
      | PT_RA01_PendingApproval | 1.0              | APEC1621-ETE-A | 100           |
      | PT_RA01_OnTreatmentArm  | 2.0              | APEC1621-ETE-A | 100           |

  @patients_p2
  Scenario Outline: PT_RA02. patient can only be set to request assignment(rebiopsy=N) when patient is on certain status
    Given patient id is "<patient_id>"
    And load template request assignment message for this patient
    Then set patient message field: "rebiopsy" to value: "N"
    And set patient message field: "step_number" to value: "<next_step_number>"
    When POST to MATCH patients service, response includes "<message>" with code "<http_code>"
    Then patient status should change to "<next_status>"
    Examples:
      | patient_id                  | step_number | next_step_number | message | http_code | next_status                     |
      | PT_RA02_PendingConfirmation | 1.0         | 1.0              |         | 403       | PENDING_CONFIRMATION            |
      | PT_RA02_PendingApproval     | 1.0         | 1.0              |         | 202       | PENDING_CONFIRMATION            |
      | PT_RA02_OnTreatmentArm      | 1.1         | 2.0              |         | 202       | PENDING_CONFIRMATION            |
      | PT_RA02_RequestNoAssignment | 1.1         | 1.1              |         | 202       | PENDING_CONFIRMATION            |
      | PT_RA02_Registered          | 1.0         | 1.0              |         | 403       | REGISTRATION                    |
      | PT_RA02_TsReceived          | 1.0         | 1.0              |         | 403       | TISSUE_SPECIMEN_RECEIVED        |
      | PT_RA02_TsShipped           | 2.0         | 2.0              |         | 403       | TISSUE_NUCLEIC_ACID_SHIPPED     |
      | PT_RA02_slideShipped        | 2.0         | 2.0              |         | 403       | TISSUE_SLIDE_SPECIMEN_SHIPPED   |
      | PT_RA02_AssayReceived       | 1.0         | 1.0              |         | 403       | ASSAY_RESULTS_RECEIVED          |
      | PT_RA02_TsVrReceived        | 2.0         | 2.0              |         | 403       | TISSUE_VARIANT_REPORT_RECEIVED  |
      | PT_RA02_TsVrConfirmed       | 1.0         | 1.0              |         | 403       | TISSUE_VARIANT_REPORT_CONFIRMED |
      | PT_RA02_TsVrRejected        | 1.0         | 1.0              |         | 403       | TISSUE_VARIANT_REPORT_REJECTED  |
      | PT_RA02_NoTaAvailable       | 1.0         | 1.0              |         | 202       | PENDING_CONFIRMATION            |
      | PT_RA02_CompassionateCare   | 1.0         | 1.0              |         | 202       | PENDING_CONFIRMATION            |
#   for the case: OFF_STUDY and OFF_STUDY_BIOPSY_EXPIRED, please check test PT_OS04
#    for the case: current status REQUEST_ASSIGNMENT then receive request assignment(rebiopsy=N), please check test PT_RA02a
#      | PT_RA02_RequestAssignment   | 1.0                 | 1.0              |         | Failure     | REQUEST_ASSIGNMENT              |
    #there is no “PATHOLOGY_REVIEWED” status anymore
#      | PT_RA02_PathoConfirmed      | 2.0                 | 2.0              |         | Failure     | PATHOLOGY_REVIEWED              |

  @patients_p3
  Scenario: PT_RA02a. request assignment(rebiopsy=N) should trigger assignment again if patient is on REQUEST_ASSIGNMENT status
    Given patient id is "PT_RA02a_RequestAssignment"
    And load template request assignment message for this patient
    Then set patient message field: "rebiopsy" to value: "N"
    And set patient message field: "step_number" to value: "2.0"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "PENDING_CONFIRMATION"
    Then patient field: "current_step_number" should have value: "2.0"
    Then patient should have selected treatment arm: "APEC1621-ETE-A" with stratum id: "100"

  @patients_p2
  Scenario Outline: PT_RA03. patient can only be set to request assignment(rebiopsy=Y) when patient is on certain status
#    if patient is REQUEST_ASSIGNMENT status then it make no sense to receive another same request assignment (rebiopsy=Y) message, so reject it
    Given patient id is "<patient_id>"
    And load template request assignment message for this patient
    Then set patient message field: "rebiopsy" to value: "Y"
    And set patient message field: "step_number" to value: "<next_step_number>"
    When POST to MATCH patients service, response includes "<message>" with code "<http_code>"
    Then patient status should change to "<next_status>"
    Examples:
      | patient_id                  | step_number | next_step_number | message | http_code | next_status                     |
      | PT_RA03_PendingConfirmation | 1.0         | 1.0              |         | 403       | PENDING_CONFIRMATION            |
      | PT_RA03_PendingApproval     | 1.0         | 1.0              |         | 202       | REQUEST_ASSIGNMENT              |
      | PT_RA03_OnTreatmentArm      | 1.1         | 2.0              |         | 202       | REQUEST_ASSIGNMENT              |
      | PT_RA03_RequestAssignment   | 1.0         | 1.0              |         | 403       | REQUEST_ASSIGNMENT              |
      | PT_RA03_RequestNoAssignment | 1.1         | 1.1              |         | 202       | REQUEST_ASSIGNMENT              |
      | PT_RA03_Registered          | 1.0         | 1.0              |         | 403       | REGISTRATION                    |
      | PT_RA03_TsReceived          | 1.0         | 1.0              |         | 403       | TISSUE_SPECIMEN_RECEIVED        |
      | PT_RA03_TsShipped           | 2.0         | 2.0              |         | 403       | TISSUE_NUCLEIC_ACID_SHIPPED     |
      | PT_RA03_slideShipped        | 2.0         | 2.0              |         | 403       | TISSUE_SLIDE_SPECIMEN_SHIPPED   |
      | PT_RA03_AssayReceived       | 1.0         | 1.0              |         | 403       | ASSAY_RESULTS_RECEIVED          |
      | PT_RA03_TsVrReceived        | 2.0         | 2.0              |         | 403       | TISSUE_VARIANT_REPORT_RECEIVED  |
      | PT_RA03_TsVrConfirmed       | 1.0         | 1.0              |         | 403       | TISSUE_VARIANT_REPORT_CONFIRMED |
      | PT_RA03_TsVrRejected        | 1.0         | 1.0              |         | 403       | TISSUE_VARIANT_REPORT_REJECTED  |
      | PT_RA03_NoTaAvailable       | 1.0         | 1.0              |         | 202       | REQUEST_ASSIGNMENT              |
      | PT_RA03_CompassionateCare   | 1.0         | 1.0              |         | 202       | REQUEST_ASSIGNMENT              |
#   for the case: OFF_STUDY and OFF_STUDY_BIOPSY_EXPIRED, please check test PT_OS04
    #there is no “PATHOLOGY_REVIEWED” status anymore
#      | PT_RA03_PathoConfirmed      | PATHOLOGY_REVIEWED              | 2.0                 | 2.0              |         | Failure     | PATHOLOGY_REVIEWED              |

  @patients_p3
  Scenario: PT_RA04. any message other than request assignment(Rebiopsy=Y) and off study should be rejected if patient is on "REQUEST_NO_ASSIGNMENT" status
#    patient: "PT_RA04_ReqNoAssignment" with status: "REQUEST_NO_ASSIGNMENT" on step: "2.0"
    Given patient id is "PT_RA04_ReqNoAssignment"
    Then patient API user authorization role is "MDA_VARIANT_REPORT_REVIEWER"
    And load template variant report confirm message for analysis id: "PT_RA04_ReqNoAssignment_ANI2"
    When PUT to MATCH variant report "confirm" service, response includes "assignment" with code "403"
    Then patient API user authorization role is "SPECIMEN_MESSAGE_SENDER"
    Then load template specimen type: "TISSUE" received message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_RA04_ReqNoAssignment_SEI3"
    When POST to MATCH patients service, response includes "assignment" with code "403"
    Then load template specimen type: "TISSUE" shipped message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_RA04_ReqNoAssignment_SEI2"
    Then set patient message field: "molecular_id" to value: "PT_RA04_ReqNoAssignment_MOI3"
    When POST to MATCH patients service, response includes "assignment" with code "403"
    Then patient API user authorization role is "SYSTEM"
    Then load template variant file uploaded message for molecular id: "PT_RA04_ReqNoAssignment_MOI2"
    Then set patient message field: "analysis_id" to value: "PT_RA04_ReqNoAssignment_ANI4"
    Then files for molecular_id "PT_RA04_ReqNoAssignment_MOI2" and analysis_id "PT_RA04_ReqNoAssignment_ANI4" are in S3
    When POST to MATCH variant report upload service, response includes "assignment" with code "403"
    Then patient API user authorization role is "ASSAY_MESSAGE_SENDER"
    Then load template assay message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_RA04_ReqNoAssignment_SEI1"
    When POST to MATCH patients service, response includes "assignment" with code "403"

  @patients_p2
  Scenario Outline: PT_RA04a patient can be set to request no assignment only on certain status
    Given patient id is "<patient_id>"
    And load template request no assignment message for this patient
    And set patient message field: "step_number" to value: "<next_step_number>"
    When POST to MATCH patients service, response includes "<message>" with code "<http_code>"
    Then patient status should change to "<next_status>"
    Examples:
      | patient_id                     | next_step_number | message | http_code | next_status                     |
      | PT_RA04a_PendingConfirmation   | 1.0              |         | 403       | PENDING_CONFIRMATION            |
      | PT_RA04a_PendingApproval       | 1.0              |         | 202       | REQUEST_NO_ASSIGNMENT           |
      | PT_RA04a_OnTreatmentArm        | 1.1              |         | 202       | REQUEST_NO_ASSIGNMENT           |
      | PT_RA04a_RequestAssignment     | 1.0              |         | 202       | REQUEST_NO_ASSIGNMENT           |
      | PT_RA04a_RequestNoAssignment   | 1.1              |         | 403       | REQUEST_NO_ASSIGNMENT           |
      | PT_RA04a_Registered            | 1.0              |         | 403       | REGISTRATION                    |
      | PT_RA04a_TsReceived            | 1.0              |         | 403       | TISSUE_SPECIMEN_RECEIVED        |
      | PT_RA04a_TsShipped             | 2.0              |         | 403       | TISSUE_NUCLEIC_ACID_SHIPPED     |
      | PT_RA04a_slideShipped          | 2.0              |         | 403       | TISSUE_SLIDE_SPECIMEN_SHIPPED   |
      | PT_RA04a_AssayReceived         | 1.0              |         | 403       | ASSAY_RESULTS_RECEIVED          |
      | PT_RA04a_TsVrReceived          | 2.0              |         | 403       | TISSUE_VARIANT_REPORT_RECEIVED  |
      | PT_RA04a_TsVrConfirmed         | 1.0              |         | 403       | TISSUE_VARIANT_REPORT_CONFIRMED |
      | PT_RA04a_TsVrRejected          | 1.0              |         | 403       | TISSUE_VARIANT_REPORT_REJECTED  |
      | PT_RA04a_NoTaAvailable         | 1.0              |         | 202       | REQUEST_NO_ASSIGNMENT           |
      | PT_RA04a_CompassionateCare     | 1.0              |         | 202       | REQUEST_NO_ASSIGNMENT           |
      | PT_RA04a_OffStudy              | 1.0              |         | 403       | OFF_STUDY                       |
      | PT_RA04a_OffStudyBiopsyExpired | 1.0              |         | 403       | OFF_STUDY_BIOPSY_EXPIRED        |

#  PT_RA04b off study and request assignment message should be accepted when patient is on request no assignment status
#    please check test PT_OS01 last example and PT_RA02 example 3, PT_RA03 example 4
#

      #this is not required anymore!!!!!!!!!!!!!!!
#  @patients_p3
#  Scenario: PT_RA05. request assignment message with rebiopsy = N will fail if the current biopsy is expired
##   patient: "PT_RA05_OnTreatmentArm" with status: "ON_TREATMENT_ARM" on step: "1.1" the specimen received date is over 6 months ago
#    Given patient id is "PT_RA05_OnTreatmentArm"
#    And template request assignment message for this patient (rebiopsy: "N", step number: "2.0")
#    When POST to MATCH patients service, response includes "expired" with code "403"

  @patients_p1
  Scenario Outline: PT_RA06. assignment process should not be triggered if assignment request has rebiopsy = Y
    Given patient id is "<patient_id>"
    And load template request assignment message for this patient
    And set patient message field: "rebiopsy" to value: "Y"
    And set patient message field: "step_number" to value: "2.0"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "REQUEST_ASSIGNMENT"
    Examples:
      | patient_id             | current_step_number |
      | PT_RA06_OnTreatmentArm | 1.1                 |
      | PT_RA06_PendingAproval | 1.0                 |

  @patients_p1
  Scenario: PT_RA07. request assignment with rebiopsy = N should generate assignment report properly
    Given patient id is "PT_RA07_VrAndAssayReady"
    Then patient API user authorization role is "MDA_VARIANT_REPORT_REVIEWER"
    Then load template variant report confirm message for analysis id: "PT_RA07_VrAndAssayReady_ANI1"
    When PUT to MATCH variant report "confirm" service, response includes "successfully" with code "200"
    Then patient status should change to "PENDING_CONFIRMATION"
    And analysis_id "PT_RA07_VrAndAssayReady_ANI1" should have 1 PENDING 0 REJECTED 0 CONFIRMED assignment reports
    And patient pending assignment report selected treatment arm is "APEC1621-A" with stratum_id "100"
    Then patient API user authorization role is "ASSIGNMENT_REPORT_REVIEWER"
    Then load template assignment report confirm message for analysis id: "PT_RA07_VrAndAssayReady_ANI1"
    When PUT to MATCH assignment report "confirm" service, response includes "successfully" with code "200"
    Then patient status should change to "PENDING_APPROVAL"
    Then patient API user authorization role is "PATIENT_MESSAGE_SENDER"
    Then load template request assignment message for this patient
    And set patient message field: "rebiopsy" to value: "N"
    And set patient message field: "step_number" to value: "1.0"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "PENDING_CONFIRMATION"
    And analysis_id "PT_RA07_VrAndAssayReady_ANI1" should have 1 PENDING 0 REJECTED 1 CONFIRMED assignment reports
    And patient pending assignment report selected treatment arm is "APEC1621-ETE-A" with stratum_id "100"
    Then patient API user authorization role is "ASSIGNMENT_REPORT_REVIEWER"
    When PUT to MATCH assignment report "confirm" service, response includes "successfully" with code "200"
    Then patient status should change to "PENDING_APPROVAL"
    Then load template request assignment message for this patient
    And set patient message field: "rebiopsy" to value: "N"
    And set patient message field: "step_number" to value: "1.0"
    Then patient API user authorization role is "PATIENT_MESSAGE_SENDER"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "PENDING_CONFIRMATION"
    And analysis_id "PT_RA07_VrAndAssayReady_ANI1" should have 1 PENDING 0 REJECTED 2 CONFIRMED assignment reports
    And patient pending assignment report selected treatment arm is "APEC1621-ETE-C" with stratum_id "100"
    Then patient API user authorization role is "ASSIGNMENT_REPORT_REVIEWER"
    When PUT to MATCH assignment report "confirm" service, response includes "successfully" with code "200"
    Then patient status should change to "PENDING_APPROVAL"
    Then load template request assignment message for this patient
    And set patient message field: "rebiopsy" to value: "N"
    And set patient message field: "step_number" to value: "1.0"
    Then patient API user authorization role is "PATIENT_MESSAGE_SENDER"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "PENDING_CONFIRMATION"
    And analysis_id "PT_RA07_VrAndAssayReady_ANI1" should have 1 PENDING 0 REJECTED 3 CONFIRMED assignment reports
    And patient pending assignment report field "report_status" should be "NO_TREATMENT_FOUND"
    Then patient API user authorization role is "ASSIGNMENT_REPORT_REVIEWER"
    When PUT to MATCH assignment report "confirm" service, response includes "successfully" with code "200"
    Then patient status should change to "NO_TA_AVAILABLE"
    Then load template request assignment message for this patient
    And set patient message field: "rebiopsy" to value: "N"
    And set patient message field: "step_number" to value: "1.0"
    Then patient API user authorization role is "PATIENT_MESSAGE_SENDER"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "PENDING_CONFIRMATION"
    And analysis_id "PT_RA07_VrAndAssayReady_ANI1" should have 1 PENDING 0 REJECTED 4 CONFIRMED assignment reports
    And patient pending assignment report field "report_status" should be "NO_TREATMENT_FOUND"

  @patients_p2
  Scenario Outline: PT_RA08. request assignment message with invalid rebiopsy field should fail
    Given patient id is "<patient_id>"
    Then load template request assignment message for this patient
    And set patient message field: "rebiopsy" to value: "<rebiopsy>"
    And set patient message field: "step_number" to value: "1.0"
    When POST to MATCH patients service, response includes "biopsy" with code "403"
    Examples:
      | patient_id                  | rebiopsy |
      | PT_RA08_PendingApproval     | y        |
      | PT_RA08_OnTreatmentArm      | n        |
      | PT_RA08_RequestNoAssignment | other    |

  @patients_p2
  Scenario Outline: PT_RA09. request assignment message without rebiopsy field should works as rebiospy = N
    Given patient id is "<patient_id>"
    Then load template request assignment message for this patient
    And set patient message field: "step_number" to value: "1.0"
    Then remove field: "rebiopsy" from patient message
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "PENDING_CONFIRMATION"
    Examples:
      | patient_id                  |
      | PT_RA09_PendingApproval     |
      | PT_RA09_OnTreatmentArm      |
      | PT_RA09_RequestNoAssignment |

  @patients_p2
  Scenario Outline: PT_RA10. request assignment message with rebiopsy is "" or null should works as rebiospy = N
    Given patient id is "<patient_id>"
    Then load template request assignment message for this patient
    And set patient message field: "rebiopsy" to value: "<rebiopsy>"
    And set patient message field: "step_number" to value: "1.0"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "PENDING_CONFIRMATION"
    Examples:
      | patient_id                   | rebiopsy |
      | PT_RA10_PendingApproval      |          |
      | PT_RA10_OnTreatmentArm       |          |
      | PT_RA10_RequestNoAssignment  |          |
      | PT_RA10_PendingApproval1     | null     |
      | PT_RA10_OnTreatmentArm1      | null     |
      | PT_RA10_RequestNoAssignment1 | null     |

