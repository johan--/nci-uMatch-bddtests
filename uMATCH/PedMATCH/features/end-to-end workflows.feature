Feature: Workflow scenarios that exercises the entire PedMATCH system from registering a patient all the way to patient assignment firing different type of rules based on the patients unique biology and available treatment arm

  @e2e
  Scenario Outline: Load Treatment Arms into Pediatric MATCHbox
    Given a treatment arm json file "<taFileName>" with id "<id>", stratum "<stratum>" and version "<version>" is submitted to treatment_arm service
    Then the treatment_arm "<id>" with stratum "<stratum>" is created in MatchBox with status as "<status>"
    Examples:
      | taFileName                    | id                       | stratum     | version    | status |
      | APEC1621-A.json               | APEC1621-A               | 100         | 2016-10-12 | OPEN   |
      | APEC1621-B.json               | APEC1621-B               | 100         | 2016-10-12 | OPEN   |
      | APEC1621-C.json               | APEC1621-C               | 100         | 2016-10-12 | OPEN   |
      | SNV_location_intronic_TA.json | SNV_location_intronic    | 100         | 2015-08-06 | OPEN   |
      | CukeTest-122-1-SUSPENDED.json | CukeTest-122-1-SUSPENDED | stratum122a | 2017-08-06 | OPEN   |

  @e2e
  Scenario: Patient matches on an inclusion variant and is assigned to the treatment arm
    Given patient: "PT_ETE01" is registered
    Then tissue specimen received with surgical_event_id: "PT_ETE01_SEI1"
    Then "TISSUE" specimen shipped to "MDA" with molecular_id or slide_barcode: "PT_ETE01_MOI1"
    Then "SLIDE" specimen shipped to "MDA" with molecular_id or slide_barcode: "PT_ETE01_BC1"
    Then "ICCPTENs" assay result received result: "NEGATIVE"
    Then "ICCBAF47s" assay result received result: "NEGATIVE"
    Then "ICCBRG1s" assay result received result: "NEGATIVE"
    Then "TISSUE" variant report "test1.vcf" uploaded with analysis id: "PT_ETE01_ANI1"
    Then "TISSUE" variant report confirmed with status: "CONFIRMED"
    Then patient status should be "PENDING_CONFIRMATION"
    Then treatment arm: "APEC1621-A" with stratum id: "100" is selected
    Then assignment report is confirmed
    Then COG approves patient on treatment arm: "APEC1621-A", stratum: "100" to step: "1.1"
    Then patient status should be "ON_TREATMENT_ARM"
  @e2e
  Scenario: Patient does not have a matching variant to any treatment arm
    Given patient: "PT_ETE02" is registered
    Then tissue specimen received with surgical_event_id: "PT_ETE02_SEI1"
    Then "TISSUE" specimen shipped to "MDA" with molecular_id or slide_barcode: "PT_ETE02_MOI1"
    Then "SLIDE" specimen shipped to "MDA" with molecular_id or slide_barcode: "PT_ETE02_BC1"
    Then "ICCPTENs" assay result received result: "NEGATIVE"
    Then "ICCBAF47s" assay result received result: "NEGATIVE"
    Then "ICCBRG1s" assay result received result: "NEGATIVE"
    Then "TISSUE" variant report "test2.vcf" uploaded with analysis id: "PT_ETE02_ANI1"
    Then "TISSUE" variant report confirmed with status: "CONFIRMED"
    Then patient status should be "PENDING_CONFIRMATION"
    Then current assignment report_status: "NO_TREATMENT_FOUND"
    Then assignment report is confirmed
    Then patient status should be "NO_TA_AVAILABLE"

  Scenario: Patient matches to a treatment arm but COG deems it not eligible

  Scenario: Patient is assigned to an arm only when there is a inclusion variant match and inclusion disease match

  Scenario: Patient is excluded fom the arm that has a matching exclusion variant and inclusion variant

  Scenario: Patient is assigned to the treatment arm based on non-hotspot variant match

  Scenario: Verify that the inclusion non-hotspot rule FUNC comparison is not case-sensitive

  Scenario: When a Patient does not have any disease(s) then he or she should not be assigned to a TA

  Scenario: Patient on a TA when receives REQUEST_ASSIGNMENT message with rebiopsy flag 'N' is put back in queue and reassigned to a new TA

  Scenario: Patient on a TA when receives REQUEST_ASSIGNMENT message with rebiopsy flag 'Y' receives new specimen messages, shipment messages, variant report and is reassigned to a new TA

  Scenario: When a patient has a prior drug that matches the exclusion drug, the patient is not assigned to the TA

  Scenario: When the patient receives an off_trial message from ECOG, and the patient is in PENDING_CONFIRMATION status, the TA counter must be decremented.

  Scenario: When the patient receives an off_trial message from ECOG, and the patient is in PENDING_APPROVAL status, the TA counter must be decremented.

  Scenario: Patient when matches to an arm that is in SUSPENDED or CLOSED state goes in to COMPASSIOANTE CARE

  Scenario: Patient on arm gets assay result and then progresses. the new assay result should be used for assignment.



