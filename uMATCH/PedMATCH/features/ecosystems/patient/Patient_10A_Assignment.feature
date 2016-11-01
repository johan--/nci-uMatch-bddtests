#encoding: utf-8
Feature: Patients assignment tests

  Scenario Outline: PT_AM01. in proper situation, patient ecosystem can send correct status (other than PENDING_APPROVAL) to COG
#    patient: PT_ETE02_TsVrReceived1 will not have TA available
#    patient: PT_ETE02_TsVrReceived1 will have a closed TA available
    Given template variant report confirm message for patient: "<patient_id>", it has analysis_id: "<ani>" and status: "confirm"
    Then wait for "60" seconds
    Then COG received assignment status: "<assignment_status>" for this patient
    When put to MATCH variant report confirm service, returns a message that includes "processed successfully" with status "Success"
    Examples:
      | patient_id             | ani                         | assignment_status  |
      | PT_ETE02_TsVrReceived1 | PT_ETE02_TsVrReceived1_ANI1 | NO_TA_AVAILABLE    |
      | PT_ETE02_TsVrReceived2 | PT_ETE02_TsVrReceived2_ANI1 | COMPASSIONATE_CARE |

  @patients_p2
  Scenario: PT_AM02. patient can reach PENDING_CONFIRMATION status even cog service collapses during assignment processing
#    patient: "PT_ETE03" with status: "TISSUE_VARIANT_REPORT_RECEIVED" on step: "1.0", assays are ready
    Given patient: "PT_ETE03" in mock service lost patient list, service will come back after "2" tries
    Given template variant report confirm message for patient: "PT_ETE03", it has analysis_id: "PT_ETE03_ANI1" and status: "confirm"
    When put to MATCH variant report confirm service, returns a message that includes "processed successfully" with status "Success"
    Then wait for "60" seconds
    Then patient field: "current_status" should have value: "PENDING_CONFIRMATION" within 15 seconds

  @patients_p3
  Scenario: PT_AM03. on treatment arm message with wrong treatment arm information should fail
#    patient: "PT_ETE14" with status: "PENDING_APPROVAL" on step: "1.0"
#    patient is currently on treatment arm: "APEC1621-A", stratum: "100"
    Given template on treatment arm message for patient: "PT_ETE14" with treatment arm id: "APEC1621-B", stratum id: "100" and step number: "1.1"
    When post to MATCH patients service, returns a message that includes "treatment arm id" with status "Failure"

  @patients_p1
  Scenario Outline: PT_AM04. treatment arm should be able to assign to multiple patients
    Given template variant report confirm message for patient: "<patient_id>", it has analysis_id: "<ani>" and status: "confirm"
    When put to MATCH variant report confirm service, returns a message that includes "processed successfully" with status "Success"
    Then wait for "10" seconds
    Then template assignment report confirm message for patient: "<patient_id>", it has analysis_id: "<ani>" and status: "confirm"
    When put to MATCH assignment report confirm service, returns a message that includes "processed successfully" with status "Success"
    Then template on treatment arm message for patient: "<patient_id>" with treatment arm id: "APEC1621-A", stratum id: "100" and step number: "1.1"
    When post to MATCH patients service, returns a message that includes "processed successfully" with status "Success"
    Then patient field: "current_status" should have value: "ON_TREATMENT_ARM" within 30 seconds
    Then patient field: "current_step_number" should have value: "1.1" within 30 seconds
    Examples:
      | patient_id           | ani                       |
      | PT_ETE15_TsReceived1 | PT_ETE15_TsReceived1_ANI1 |
      | PT_ETE15_TsReceived2 | PT_ETE15_TsReceived2_ANI1 |

        #no blood status is used anymore
#  Scenario: PT_AM05. rejected blood variant report should not prevent api triggering assignment process
#    Given patient: "PT_ETE07" with status: "TISSUE_VARIANT_REPORT_RECEIVED" on step: "1.0"
#    Given this patients's active "TISSUE" molecular_id is "PT_ETE07_MOI1"
#    Given this patients's active "TISSUE" analysis_id is "PT_ETE07_ANI1"
#    Given other background and comments for this patient: "assay and pathology are ready, blood variant report is rejected"
#    Then "TISSUE" variant report confirmed with status: "CONFIRMED"
#    Then COG approves patient on treatment arm: "APEC1621-A", stratum: "100" to step: "1.1"
#    Then patient status should be "ON_TREATMENT_ARM" within 15 seconds
#    Then patient step number should be "1.1" within 15 seconds