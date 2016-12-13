#encoding: utf-8
Feature: Patients assignment tests

  @patients_p1
  Scenario Outline: PT_AM01. in proper situation, patient ecosystem can send correct status (other than PENDING_APPROVAL) to COG
#    patient: PT_AM01_TsVrReceived1 will not have TA available
#    patient: PT_AM01_TsVrReceived1 will have a closed TA available
    Given patient id is "<patient_id>"
    And template variant report confirm message for this patient (analysis_id: "<ani>", status: "confirm")
    When PUT to MATCH variant report confirm service, response includes "successfully" with code "200"
    Then patient status should change to "PENDING_CONFIRMATION"
    Then template assignment report confirm message for this patient (analysis_id: "<ani>" and status: "confirm")
    When PUT to MATCH assignment report confirm service, response includes "successfully" with code "200"
    Then patient status should change to "<patient_status>"
    Then COG received assignment status: "<patient_status>" for this patient
    Examples:
      | patient_id            | ani                        | patient_status     |
      | PT_AM01_TsVrReceived1 | PT_AM01_TsVrReceived1_ANI1 | NO_TA_AVAILABLE    |
      | PT_AM01_TsVrReceived2 | PT_AM01_TsVrReceived2_ANI1 | COMPASSIONATE_CARE |

  @patients_p2
  Scenario: PT_AM02. patient can reach PENDING_CONFIRMATION status even cog service collapses during assignment processing
#    patient: "PT_AM02_VrReceived" with status: "TISSUE_VARIANT_REPORT_RECEIVED" on step: "1.0", assays are ready
    #patient api will retry every 60 seconds
    Given patient id is "PT_AM02_VrReceived"
    And this patient is in mock service lost patient list, service will come back after "2" tries
    Then template variant report confirm message for this patient (analysis_id: "PT_AM02_VrReceived_ANI1", status: "confirm")
    When PUT to MATCH variant report confirm service, response includes "successfully" with code "200"
    Then wait for "180" seconds
    Then patient status should change to "PENDING_CONFIRMATION"

  @patients_p3
  Scenario: PT_AM03. on treatment arm message with wrong treatment arm information should fail
#    patient: "PT_AM03_PendingApproval" with status: "PENDING_APPROVAL" on step: "1.0"
#    patient is currently on treatment arm: "APEC1621-A", stratum: "100"
    Given patient id is "PT_AM03_PendingApproval"
    And template on treatment arm message for this patient (treatment arm id: "APEC1621-B", stratum id: "100", step number: "1.1")
    When POST to MATCH patients service, response includes "treatment arm id" with code "403"

  @patients_p1
  Scenario Outline: PT_AM04. treatment arm should be able to assign to multiple patients
    Given patient id is "<patient_id>"
    And template variant report confirm message for this patient (analysis_id: "<ani>", status: "confirm")
    When PUT to MATCH variant report confirm service, response includes "successfully" with code "200"
    Then patient status should change to "PENDING_CONFIRMATION"
    Then template assignment report confirm message for this patient (analysis_id: "<ani>" and status: "confirm")
    When PUT to MATCH assignment report confirm service, response includes "successfully" with code "200"
    Then template on treatment arm message for this patient (treatment arm id: "APEC1621-A", stratum id: "100", step number: "1.1")
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "ON_TREATMENT_ARM"
    Then patient field: "current_step_number" should have value: "1.1"
    Examples:
      | patient_id          | ani                      |
      | PT_AM04_TsReceived1 | PT_AM04_TsReceived1_ANI1 |
      | PT_AM04_TsReceived2 | PT_AM04_TsReceived2_ANI1 |

        #no blood status is used anymore
#  Scenario: PT_AM05. rejected blood variant report should not prevent api triggering assignment process
#    Given patient: "PT_AM05" with status: "TISSUE_VARIANT_REPORT_RECEIVED" on step: "1.0"
#    Given this patients's active "TISSUE" molecular_id is "PT_AM05_MOI1"
#    Given this patients's active "TISSUE" analysis_id is "PT_AM05_ANI1"
#    Given other background and comments for this patient: "assay and pathology are ready, blood variant report is rejected"
#    Then "TISSUE" variant report confirmed with status: "CONFIRMED"
#    Then COG approves patient on treatment arm: "APEC1621-A", stratum: "100" to step: "1.1"
#    Then patient status should be "ON_TREATMENT_ARM" within 15 seconds
#    Then patient step number should be "1.1" within 15 seconds