#encoding: utf-8
Feature: Patients assignment tests

  Scenario Outline: PT_AM01. in proper situation, patient ecosystem can send correct status (other than PENDING_APPROVAL) to COG
    Given patient: "<patient_id>" with status: "TISSUE_VARIANT_REPORT_RECEIVED" on step: "1.0"
    Given this patients's active "TISSUE" molecular_id is "<moi>"
    Given this patients's active "TISSUE" analysis_id is "<ani>"
    Given other background and comments for this patient: "All data is ready, there will <description>"
    Then "TISSUE" variant report confirmed with status: "CONFIRMED"
    Then wait for "60" seconds
    Then COG received assignment status: "<assignment_status>" for this patient
    Examples:
      | patient_id             | moi                         | ani                         | description                | assignment_status  |
      | PT_ETE02_TsVrReceived1 | PT_ETE02_TsVrReceived1_MOI1 | PT_ETE02_TsVrReceived1_ANI1 | not have TA available      | NO_TA_AVAILABLE    |
      | PT_ETE02_TsVrReceived2 | PT_ETE02_TsVrReceived2_MOI1 | PT_ETE02_TsVrReceived2_ANI1 | have a closed TA available | COMPASSIONATE_CARE |

  Scenario: PT_AM02. patient can reach PENDING_CONFIRMATION status even cog service collapses during assignment processing
    Given patient: "PT_ETE03" with status: "TISSUE_VARIANT_REPORT_RECEIVED" on step: "1.0"
    Given patient: "PT_ETE03" in mock service lost patient list, service will come back after "5" tries
    Given this patients's active "TISSUE" molecular_id is "PT_ETE03_MOI1"
    Given this patients's active "TISSUE" analysis_id is "PT_ETE03_ANI1"
    Given other background and comments for this patient: "assays are ready"
    Then "TISSUE" variant report confirmed with status: "CONFIRMED"
    Then patient status should be "PENDING_CONFIRMATION" within 350 seconds

  @patients_p3
  Scenario: PT_AM03. on treatment arm message with wrong treatment arm information should fail
    Given patient: "PT_ETE14" with status: "PENDING_APPROVAL" on step: "1.0"
    Given patient is currently on treatment arm: "APEC1621-A", stratum: "100"
    Then COG approves patient on treatment arm: "APEC1621-B", stratum: "100" to step: "1.1"
    Then API returns a message that includes "treatment arm" with status "Failure"

  @patients_p1
  Scenario Outline: PT_AM04. treatment arm should be able to assign to multiple patients
    Given patient: "<patient_id>" with status: "TISSUE_VARIANT_REPORT_RECEIVED" on step: "1.0"
    Given this patients's active "TISSUE" molecular_id is "<moi>"
    Given this patients's active "TISSUE" analysis_id is "<ani>"
    Given other background and comments for this patient: "assays are ready"
    Then "TISSUE" variant report confirmed with status: "CONFIRMED"
    Then wait for "10" seconds
    Then assignment report is confirmed
    Then COG approves patient on treatment arm: "APEC1621-A", stratum: "100" to step: "1.1"
    Then patient status should be "ON_TREATMENT_ARM" within 15 seconds
    Then patient step number should be "1.1" within 15 seconds
    Examples:
      | patient_id           | moi                       | ani                       |
      | PT_ETE15_TsReceived1 | PT_ETE15_TsReceived1_MOI1 | PT_ETE15_TsReceived1_ANI1 |
      | PT_ETE15_TsReceived2 | PT_ETE15_TsReceived2_MOI1 | PT_ETE15_TsReceived2_ANI1 |

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