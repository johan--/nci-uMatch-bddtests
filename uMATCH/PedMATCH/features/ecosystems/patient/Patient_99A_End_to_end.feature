#encoding: utf-8
#@patients
@patients_end_to_end
Feature: Patients end to end tests

  @patients_p1_off
  Scenario: PT_ETE01. patient can reach step 4.1 successfully
#    Given patient: "PT_ETE01" with status: "BLOOD_VARIANT_REPORT_RECEIVED" on step: "3.0"
#    Given this patients's active "TISSUE" molecular_id is "PT_ETE01_MOI2"
#    Given this patients's active "BLOOD" molecular_id is "PT_ETE01_BD_MOI2"
#    Given this patients's active "TISSUE" analysis_id is "PT_ETE01_ANI3"
#    Given this patients's active "BLOOD" analysis_id is "PT_ETE01_ANI4"
    Given reset COG patient data: "PT_ETE01"
    Given patient: "PT_ETE01" is registered
    Then tissue specimen received with surgical_event_id: "PT_ETE01_SEI1"
#    Then blood specimen received
    Then "TISSUE" specimen shipped to "MDA" with molecular_id or slide_barcode: "PT_ETE01_MOI1"
    Then "SLIDE" specimen shipped to "MDA" with molecular_id or slide_barcode: "PT_ETE01_BC1"
#    Then "BLOOD" specimen shipped to "MDA" with molecular_id or slide_barcode: "PT_ETE01_BD_MOI1"
    Then "ICCPTENs" assay result received result: "NEGATIVE"
    Then "ICCMLH1s" assay result received result: "NEGATIVE"
    Then "TISSUE" variant report uploaded with analysis_id: "PT_ETE01_ANI1"
#    Then "BLOOD" variant report uploaded with analysis_id: "PT_ETE01_ANI2"
    Then "TISSUE" variant report confirmed with status: "CONFIRMED"
    Then patient status should be "PENDING_CONFIRMATION" within 30 seconds
    Then patient should have selected treatment arm: "APEC1621-ETE-A" with stratum id: "100" within 15 seconds
    Then assignment report is confirmed
    Then COG approves patient on treatment arm: "APEC1621-ETE-A", stratum: "100" to step: "1.1"
    Then patient status should be "ON_TREATMENT_ARM" within 15 seconds
    Then patient step number should be "1.1" within 15 seconds
    Then COG requests assignment for this patient with re-biopsy: "N", step number: "2.0"
    Then patient status should be "PENDING_CONFIRMATION" within 30 seconds
    Then patient step number should be "2.0" within 15 seconds
    Then patient should have selected treatment arm: "APEC1621-ETE-C" with stratum id: "100" within 15 seconds
    Then assignment report is confirmed
    Then COG approves patient on treatment arm: "APEC1621-ETE-C", stratum: "100" to step: "2.1"
    Then patient status should be "ON_TREATMENT_ARM" within 15 seconds
    Then patient step number should be "2.1" within 15 seconds
    Then COG requests assignment for this patient with re-biopsy: "Y", step number: "3.0"
    Then patient status should be "REQUEST_ASSIGNMENT" within 15 seconds
    Then patient step number should be "3.0" within 15 seconds
    Then tissue specimen received with surgical_event_id: "PT_ETE01_SEI2"
#    Then blood specimen received
    Then "TISSUE" specimen shipped to "MoCha" with molecular_id or slide_barcode: "PT_ETE01_MOI2"
    Then "SLIDE" specimen shipped to "MDA" with molecular_id or slide_barcode: "PT_ETE01_BC2"
#    Then "BLOOD" specimen shipped to "MoCha" with molecular_id or slide_barcode: "PT_ETE01_BD_MOI2"
    Then "ICCPTENs" assay result received result: "POSITIVE"
    Then "ICCMLH1s" assay result received result: "INDETERMINATE"
    Then "TISSUE" variant report uploaded with analysis_id: "PT_ETE01_ANI3"
#    Then "BLOOD" variant report uploaded with analysis_id: "PT_ETE01_ANI4"
    Then "TISSUE" variant(type: "fusion", field: "identifier", value: "FGFR2-OFD1.F17O3") is "unchecked"
    Then "TISSUE" variant(type: "fusion", field: "identifier", value: "CCDC6-RET.C1R12.COSF1271") is "unchecked"
    Then "TISSUE" variant report confirmed with status: "CONFIRMED"
    Then wait for "2" seconds
    Then patient status should be "PENDING_CONFIRMATION" within 30 seconds
    Then patient should have selected treatment arm: "APEC1621-ETE-B" with stratum id: "100" within 15 seconds
    Then assignment report is confirmed
    Then COG approves patient on treatment arm: "APEC1621-ETE-B", stratum: "100" to step: "3.1"
    Then patient status should be "ON_TREATMENT_ARM" within 15 seconds
    Then patient step number should be "3.1" within 15 seconds
    Then COG requests assignment for this patient with re-biopsy: "N", step number: "4.0"
    Then patient status should be "PENDING_CONFIRMATION" within 30 seconds
    Then patient step number should be "4.0" within 15 seconds
    Then patient should have selected treatment arm: "APEC1621-ETE-D" with stratum id: "100" within 15 seconds
    Then assignment report is confirmed
    Then COG approves patient on treatment arm: "APEC1621-ETE-D", stratum: "100" to step: "4.1"
    Then patient status should be "ON_TREATMENT_ARM" within 15 seconds
    Then patient step number should be "4.1" within 15 seconds





  #variant_reports table should be capable to store many variant reports (more than 150 big tsv)
