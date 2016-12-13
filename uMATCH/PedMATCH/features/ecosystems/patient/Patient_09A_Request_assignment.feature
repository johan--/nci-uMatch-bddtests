#encoding: utf-8
Feature: Patients request assignment tests

  @patients_p1
  Scenario Outline: PT_RA01. patient can be set to request assignment (rebiopsy=N) properly
#    patient: PT_RA01_PendingApproval is on 1.0 now
#    patient: PT_RA01_OnTreatmentArm is on 1.1 now
    Given patient id is "<patient_id>"
    And template request assignment message for this patient (rebiopsy: "N", step number: "<next_step_number>")
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "PENDING_CONFIRMATION"
    Then patient field: "current_step_number" should have value: "<next_step_number>"
    Then patient should have selected treatment arm: "<ta_id>" with stratum id: "<ta_stratum_id>"
    Examples:
      | patient_id              | next_step_number | ta_id          | ta_stratum_id |
#      | PT_RA01_PendingApproval | 1.0              | APEC1621-ETE-A | 100           |
      | PT_RA01_OnTreatmentArm  | 2.0              | APEC1621-ETE-A | 100           |

  @patients_p2
  Scenario Outline: PT_RA02. patient can only be set to request assignment(rebiopsy=N) when patient is on certain status
    Given patient id is "<patient_id>"
    And template request assignment message for this patient (rebiopsy: "N", step number: "<next_step_number>")
    When POST to MATCH patients service, response includes "<message>" with code "<http_code>"
    Then patient status should change to "<next_status>"
    Examples:
      | patient_id                  | current_step_number | next_step_number | message | http_code | next_status                     |
      | PT_RA02_PendingConfirmation | 1.0                 | 1.0              |         | 403       | PENDING_CONFIRMATION            |
      | PT_RA02_PendingApproval     | 1.0                 | 1.0              |         | 202       | PENDING_CONFIRMATION            |
      | PT_RA02_OnTreatmentArm      | 1.1                 | 2.0              |         | 202       | PENDING_CONFIRMATION            |
      | PT_RA02_RequestNoAssignment | 1.1                 | 1.1              |         | 202       | PENDING_CONFIRMATION            |
      | PT_RA02_Registered          | 1.0                 | 1.0              |         | 403       | REGISTRATION                    |
      | PT_RA02_TsReceived          | 1.0                 | 1.0              |         | 403       | TISSUE_SPECIMEN_RECEIVED        |
      | PT_RA02_TsShipped           | 2.0                 | 2.0              |         | 403       | TISSUE_NUCLEIC_ACID_SHIPPED     |
      | PT_RA02_slideShipped        | 2.0                 | 2.0              |         | 403       | TISSUE_SLIDE_SPECIMEN_SHIPPED   |
      | PT_RA02_AssayReceived       | 1.0                 | 1.0              |         | 403       | ASSAY_RESULTS_RECEIVED          |
      | PT_RA02_TsVrReceived        | 2.0                 | 2.0              |         | 403       | TISSUE_VARIANT_REPORT_RECEIVED  |
      | PT_RA02_TsVrConfirmed       | 1.0                 | 1.0              |         | 403       | TISSUE_VARIANT_REPORT_CONFIRMED |
      | PT_RA02_TsVrRejected        | 1.0                 | 1.0              |         | 403       | TISSUE_VARIANT_REPORT_REJECTED  |
      | PT_RA02_NoTaAvailable       | 1.0                 | 1.0              |         | 202       | PENDING_CONFIRMATION            |
      | PT_RA02_CompassionateCare   | 1.0                 | 1.0              |         | 202       | PENDING_CONFIRMATION            |
#   for the case: OFF_STUDY and OFF_STUDY_BIOPSY_EXPIRED, please check test PT_OS04
#    for the case: current status REQUEST_ASSIGNMENT then receive request assignment(rebiopsy=N), please check test PT_RA02a
#      | PT_RA02_RequestAssignment   | 1.0                 | 1.0              |         | Failure     | REQUEST_ASSIGNMENT              |
    #there is no “PATHOLOGY_REVIEWED” status anymore
#      | PT_RA02_PathoConfirmed      | 2.0                 | 2.0              |         | Failure     | PATHOLOGY_REVIEWED              |

  @patients_p3
  Scenario: PT_RA02a. request assignment(rebiopsy=N) should trigger assignment again if patient is on REQUEST_ASSIGNMENT status
    Given patient id is "PT_RA02a_RequestAssignment"
    And template request assignment message for this patient (rebiopsy: "N", step number: "2.0")
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "PENDING_CONFIRMATION"
    Then patient field: "current_step_number" should have value: "2.0"
    Then patient should have selected treatment arm: "APEC1621-ETE-A" with stratum id: "100"

  @patients_p2
  Scenario Outline: PT_RA03. patient can only be set to request assignment(rebiopsy=Y) when patient is on certain status
#    if patient is REQUEST_ASSIGNMENT status then it make no sense to receive another same request assignment (rebiopsy=Y) message, so reject it
    Given patient id is "<patient_id>"
    And template request assignment message for this patient (rebiopsy: "Y", step number: "<next_step_number>")
    When POST to MATCH patients service, response includes "<message>" with code "<http_code>"
    Then patient status should change to "<next_status>"
    Examples:
      | patient_id                  | current_step_number | next_step_number | message | http_code | next_status                     |
      | PT_RA03_PendingConfirmation | 1.0                 | 1.0              |         | 403     | PENDING_CONFIRMATION            |
      | PT_RA03_PendingApproval     | 1.0                 | 1.0              |         | 202     | REQUEST_ASSIGNMENT              |
      | PT_RA03_OnTreatmentArm      | 1.1                 | 2.0              |         | 202     | REQUEST_ASSIGNMENT              |
      | PT_RA03_RequestAssignment   | 1.0                 | 1.0              |         | 403     | REQUEST_ASSIGNMENT              |
      | PT_RA03_RequestNoAssignment | 1.1                 | 1.1              |         | 202     | REQUEST_ASSIGNMENT              |
      | PT_RA03_Registered          | 1.0                 | 1.0              |         | 403     | REGISTRATION                    |
      | PT_RA03_TsReceived          | 1.0                 | 1.0              |         | 403     | TISSUE_SPECIMEN_RECEIVED        |
      | PT_RA03_TsShipped           | 2.0                 | 2.0              |         | 403     | TISSUE_NUCLEIC_ACID_SHIPPED     |
      | PT_RA03_slideShipped        | 2.0                 | 2.0              |         | 403     | TISSUE_SLIDE_SPECIMEN_SHIPPED   |
      | PT_RA03_AssayReceived       | 1.0                 | 1.0              |         | 403     | ASSAY_RESULTS_RECEIVED          |
      | PT_RA03_TsVrReceived        | 2.0                 | 2.0              |         | 403     | TISSUE_VARIANT_REPORT_RECEIVED  |
      | PT_RA03_TsVrConfirmed       | 1.0                 | 1.0              |         | 403     | TISSUE_VARIANT_REPORT_CONFIRMED |
      | PT_RA03_TsVrRejected        | 1.0                 | 1.0              |         | 403     | TISSUE_VARIANT_REPORT_REJECTED  |
      | PT_RA03_NoTaAvailable       | 1.0                 | 1.0              |         | 202     | REQUEST_ASSIGNMENT              |
      | PT_RA03_CompassionateCare   | 1.0                 | 1.0              |         | 202     | REQUEST_ASSIGNMENT              |
#   for the case: OFF_STUDY and OFF_STUDY_BIOPSY_EXPIRED, please check test PT_OS04
    #there is no “PATHOLOGY_REVIEWED” status anymore
#      | PT_RA03_PathoConfirmed      | PATHOLOGY_REVIEWED              | 2.0                 | 2.0              |         | Failure     | PATHOLOGY_REVIEWED              |

  @patients_p2
  Scenario: PT_RA04. any message other than request assignment(Rebiopsy=Y) and off study should be rejected if patient is on "REQUEST_NO_ASSIGNMENT" status
#    patient: "PT_RA04_ReqNoAssignment" with status: "REQUEST_NO_ASSIGNMENT" on step: "2.0"
    Given patient id is "PT_RA04_ReqNoAssignment"
    And template variant report confirm message for this patient (analysis_id: "PT_RA04_ReqNoAssignment_ANI2", status: "confirm")
    When POST to MATCH patients service, response includes "assignment" with code "403"
    Then template specimen received message for this patient (type: "TISSUE", surgical_event_id: "PT_RA04_ReqNoAssignment_SEI3")
    When POST to MATCH patients service, response includes "assignment" with code "403"
    Then template specimen shipped message for this patient (type: "PT_RA04_ReqNoAssignment", surgical_event_id: "PT_RA04_ReqNoAssignment_SEI2", molecular_id or slide_barcode: "PT_RA04_ReqNoAssignment_MOI3")
    When POST to MATCH patients service, response includes "assignment" with code "403"
    Then template variant file uploaded message for this patient (molecular_id: "PT_RA04_ReqNoAssignment_MOI2", analysis_id: "PT_RA04_ReqNoAssignment_ANI4") and need files in S3 Y or N: "Y"
    When POST to MATCH patients service, response includes "assignment" with code "403"
    Then template assay message with surgical_event_id: "PT_RA04_ReqNoAssignment_SEI1" for patient: "PT_RA04_ReqNoAssignment"
    When POST to MATCH patients service, response includes "assignment" with code "403"

  @patients_p2
  Scenario Outline: PT_RA04a patient can be set to request no assignment only on certain status
    Given patient id is "PT_RA04_ReqNoAssignment"
    Given template request no assignment message for this patient with step number: "<next_step_number>"
    When POST to MATCH patients service, response includes "<message>" with code "<http_code>"
    Then patient status should change to "<next_status>"
    Examples:
      | patient_id                     | next_step_number | message | http_code | next_status                     |
      | PT_RA04a_PendingConfirmation   | 1.0              |         | 403     | PENDING_CONFIRMATION            |
      | PT_RA04a_PendingApproval       | 1.0              |         | 202     | REQUEST_NO_ASSIGNMENT           |
      | PT_RA04a_OnTreatmentArm        | 1.1              |         | 202     | REQUEST_NO_ASSIGNMENT           |
      | PT_RA04a_RequestAssignment     | 1.0              |         | 202     | REQUEST_NO_ASSIGNMENT           |
      | PT_RA04a_RequestNoAssignment   | 1.1              |         | 403     | REQUEST_NO_ASSIGNMENT           |
      | PT_RA04a_Registered            | 1.0              |         | 403     | REGISTRATION                    |
      | PT_RA04a_TsReceived            | 1.0              |         | 403     | TISSUE_SPECIMEN_RECEIVED        |
      | PT_RA04a_TsShipped             | 2.0              |         | 403     | TISSUE_NUCLEIC_ACID_SHIPPED     |
      | PT_RA04a_slideShipped          | 2.0              |         | 403     | TISSUE_SLIDE_SPECIMEN_SHIPPED   |
      | PT_RA04a_AssayReceived         | 1.0              |         | 403     | ASSAY_RESULTS_RECEIVED          |
      | PT_RA04a_TsVrReceived          | 2.0              |         | 403     | TISSUE_VARIANT_REPORT_RECEIVED  |
      | PT_RA04a_TsVrConfirmed         | 1.0              |         | 403     | TISSUE_VARIANT_REPORT_CONFIRMED |
      | PT_RA04a_TsVrRejected          | 1.0              |         | 403     | TISSUE_VARIANT_REPORT_REJECTED  |
      | PT_RA04a_NoTaAvailable         | 1.0              |         | 202     | REQUEST_NO_ASSIGNMENT           |
      | PT_RA04a_CompassionateCare     | 1.0              |         | 202     | REQUEST_NO_ASSIGNMENT           |
      | PT_RA04a_OffStudy              | 1.0              |         | 403     | OFF_STUDY                       |
      | PT_RA04a_OffStudyBiopsyExpired | 1.0              |         | 403     | OFF_STUDY_BIOPSY_EXPIRED        |

#  PT_RA04b off study and request assignment message should be accepted when patient is on request no assignment status
#    please check test PT_OS01 last example and PT_RA02 example 3, PT_RA03 example 4
#

  @patients_p3
  Scenario: PT_RA05. request assignment message with rebiopsy = N will fail if the current biopsy is expired
#   patient: "PT_RA05_OnTreatmentArm" with status: "ON_TREATMENT_ARM" on step: "1.1" the specimen received date is over 6 months ago
    Given patient id is "PT_RA05_OnTreatmentArm"
    And template request assignment message for this patient (rebiopsy: "N", step number: "2.0")
    When POST to MATCH patients service, response includes "expired" with code "403"

  @patients_p1
  Scenario Outline: PT_RA06. assignment process should not be triggered if assignment request has rebiopsy = Y
    Given patient id is "<patient_id>"
    And template request assignment message for this patient (rebiopsy: "Y", step number: "2.0")
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "REQUEST_ASSIGNMENT"
    Examples:
      | patient_id             | current_step_number |
      | PT_RA06_OnTreatmentArm | 1.1                 |
      | PT_RA06_PendingAproval | 1.0                 |

#    @patients_p1
#    Scenario: PT_RA07. request assignment with rebiopsy = N should generate assignment report properly
#      Given template variant report confirm message for patient: "PT_RA07_VrAndAssayReady", it has analysis_id: "PT_RA07_VrAndAssayReady_ANI1" and status: "confirm"
#      When put to MATCH variant report confirm service, returns a message that includes "processed successfully" with status "Success"
#      Then patient field: "current_status" should have value: "PENDING_CONFIRMATION" after 45 seconds
#      Then wait until patient has 1 assignment reports
#      Then patient should have assignment report (TA id: "APEC1621-A", stratum id: "100") with status "PENDING"
#      Then template assignment report confirm message for patient: "PT_RA07_VrAndAssayReady", it has analysis_id: "PT_RA07_VrAndAssayReady_ANI1" and status: "confirm"
#      When put to MATCH assignment report confirm service, returns a message that includes "processed successfully" with status "Success"
#      Then wait until patient assignment reports update
#      Then patient should have assignment report (TA id: "APEC1621-A", stratum id: "100") with status "CONFIRMED"
#      Then template request assignment message for patient: "PT_RA07_VrAndAssayReady" with re-biopsy: "N", step number: "1.0"
#      When POST to MATCH patients service, response includes "successfully" with code "202"
#      Then patient field: "current_status" should have value: "PENDING_CONFIRMATION" after 45 seconds
#      Then wait until patient has 2 assignment reports
#      Then patient should have assignment report (TA id: "APEC1621-A", stratum id: "100") with status "REJECTED"
#      Then patient should have assignment report (TA id: "APEC1621-ETE-A", stratum id: "100") with status "PENDING"
#      Then template assignment report confirm message for patient: "PT_RA07_VrAndAssayReady", it has analysis_id: "PT_RA07_VrAndAssayReady_ANI1" and status: "confirm"
#      When put to MATCH assignment report confirm service, returns a message that includes "processed successfully" with status "Success"
#      Then template request assignment message for patient: "PT_RA07_VrAndAssayReady" with re-biopsy: "N", step number: "1.0"
#      When POST to MATCH patients service, response includes "successfully" with code "202"
#      Then patient field: "current_status" should have value: "PENDING_CONFIRMATION" after 45 seconds
#      Then wait until patient has 3 assignment reports
#      Then patient should have assignment report (TA id: "APEC1621-A", stratum id: "100") with status "REJECTED"
#      Then patient should have assignment report (TA id: "APEC1621-ETE-A", stratum id: "100") with status "REJECTED"
#      Then patient should have assignment report (report status: "NO_TREATMENT_FOUND") with status "PENDING"
#      Then template assignment report confirm message for patient: "PT_RA07_VrAndAssayReady", it has analysis_id: "PT_RA07_VrAndAssayReady_ANI1" and status: "confirm"
#      When put to MATCH assignment report confirm service, returns a message that includes "processed successfully" with status "Success"
#      Then template request assignment message for patient: "PT_RA07_VrAndAssayReady" with re-biopsy: "N", step number: "1.0"
#      When POST to MATCH patients service, response includes "successfully" with code "202"
#      Then patient field: "current_status" should have value: "PENDING_CONFIRMATION" after 45 seconds
#      Then wait until patient has 4 assignment reports
#      Then patient should have assignment report (TA id: "APEC1621-A", stratum id: "100") with status "REJECTED"
#      Then patient should have assignment report (TA id: "APEC1621-ETE-A", stratum id: "100") with status "REJECTED"
#      Then patient should have assignment report (report status: "NO_TREATMENT_FOUND") with status "REJECTED"
#      Then patient should have assignment report (report status: "NO_TREATMENT_FOUND") with status "PENDING"



  @patients_p2
  Scenario Outline: PT_RA08. request assignment message with invalid rebiopsy field should fail
    Given patient id is "<patient_id>"
    And template request assignment message for this patient (rebiopsy: "<rebiopsy>", step number: "1.0")
    When POST to MATCH patients service, response includes "biopsy" with code "403"
    Examples:
      | patient_id                  | rebiopsy |
      | PT_RA08_PendingApproval     | y        |
      | PT_RA08_OnTreatmentArm      | n        |
      | PT_RA08_RequestNoAssignment | other    |

  @patients_p2
  Scenario Outline: PT_RA09. request assignment message without rebiopsy field should works as rebiospy = N
    Given patient id is "<patient_id>"
    And template request assignment message for this patient (rebiopsy: "Y", step number: "1.0")
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
    And template request assignment message for this patient (rebiopsy: "<rebiopsy>", step number: "1.0")
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

