@ete
Feature: Workflow scenarios that exercises the entire PedMATCH system from registering a patient all the way to patient assignment firing different type of rules based on the patients unique biology and available treatment arm


  Scenario Outline: Load Treatment Arms into Pediatric MATCHbox
    Given a treatment arm json file "<taFileName>" with id "<id>", stratum "<stratum>" and version "<version>" is submitted to treatment_arm service
    Then the treatment_arm "<id>" with stratum "<stratum>" is created in MatchBox with status as "<status>"
    Examples:
      | taFileName                    | id                       | stratum     | version    | status |
      | APEC1621-A.json               | APEC1621-A               | 100         | 2016-10-12 | OPEN   |
      | APEC1621-B.json               | APEC1621-B               | 100         | 2016-10-12 | OPEN   |
      | APEC1621-C.json               | APEC1621-C               | 100         | 2016-10-12 | OPEN   |
      | APEC1621-D.json               | APEC1621-D               | 100         | 2016-10-12 | OPEN   |
      | SNV_location_intronic_TA.json | SNV_location_intronic    | 100         | 2015-08-06 | OPEN   |
      | CukeTest-122-1-SUSPENDED.json | CukeTest-122-1-SUSPENDED | stratum122a | 2017-08-06 | OPEN   |
      | APEC1621-E.json               | APEC1621-E               | 100         | 2016-10-12 | OPEN   |
      | APEC1621-F.json               | APEC1621-F               | 100         | 2016-10-12 | OPEN   |

  Scenario: Patient matches on an inclusion variant and is assigned to the treatment arm
    Given patient: "PT_ETE01" is registered
    Then tissue specimen received with surgical_event_id: "PT_ETE01_SEI1"
    Then "TISSUE" specimen shipped to "MDA" with molecular_id or slide_barcode: "PT_ETE01_MOI1"
    Then "SLIDE" specimen shipped to "MDA" with molecular_id or slide_barcode: "PT_ETE01_BC1"
    Then "ICCPTENs" assay result received result: "NEGATIVE"
    Then "ICCBAF47s" assay result received result: "NEGATIVE"
    Then "ICCBRG1s" assay result received result: "NEGATIVE"
    Then "TISSUE" variant report "ETE01.vcf" uploaded with analysis id: "PT_ETE01_ANI1"
    Then "TISSUE" variant report confirmed with status: "CONFIRMED"
    Then patient status should be "PENDING_CONFIRMATION"
    Then treatment arm: "APEC1621-A" with stratum id: "100" is selected
    Then the current assignment reason is "A match was found for inclusion variant FGFR2-OFD1.F17O3."
    Then assignment report is confirmed
    Then COG approves patient on treatment arm: "APEC1621-A", stratum: "100" to step: "1.1"
    Then patient status should be "ON_TREATMENT_ARM"

  Scenario: Patient does not have a matching variant to any treatment arm
    Given patient: "PT_ETE02" is registered
    Then tissue specimen received with surgical_event_id: "PT_ETE02_SEI1"
    Then "TISSUE" specimen shipped to "MDA" with molecular_id or slide_barcode: "PT_ETE02_MOI1"
    Then "SLIDE" specimen shipped to "MDA" with molecular_id or slide_barcode: "PT_ETE02_BC1"
    Then "ICCPTENs" assay result received result: "NEGATIVE"
    Then "ICCBAF47s" assay result received result: "NEGATIVE"
    Then "ICCBRG1s" assay result received result: "NEGATIVE"
    Then "TISSUE" variant report "ETE02.vcf" uploaded with analysis id: "PT_ETE02_ANI1"
    Then "TISSUE" variant report confirmed with status: "CONFIRMED"
    Then patient status should be "PENDING_CONFIRMATION"
    Then current assignment report_status: "NO_TREATMENT_FOUND"
    Then assignment report is confirmed
    Then patient status should be "NO_TA_AVAILABLE"

  Scenario: Patient is assigned to an arm only when there is a inclusion variant match and inclusion disease match
    Given patient: "PT_ETE03" is registered
    Then tissue specimen received with surgical_event_id: "PT_ETE03_SEI1"
    Then "TISSUE" specimen shipped to "MDA" with molecular_id or slide_barcode: "PT_ETE03_MOI1"
    Then "SLIDE" specimen shipped to "MDA" with molecular_id or slide_barcode: "PT_ETE03_BC1"
    Then "ICCPTENs" assay result received result: "NEGATIVE"
    Then "ICCBAF47s" assay result received result: "NEGATIVE"
    Then "ICCBRG1s" assay result received result: "NEGATIVE"
    Then "TISSUE" variant report "ETE03.vcf" uploaded with analysis id: "PT_ETE03_ANI1"
    Then "TISSUE" variant report confirmed with status: "CONFIRMED"
    Then patient status should be "PENDING_CONFIRMATION"
    Then treatment arm: "APEC1621-B" with stratum id: "100" is selected
    Then the current assignment reason is "A match was found for inclusion variant MYCL. A match was found for inclusion disease Papillary thyroid carcinoma (10033701) and it's required."
    Then assignment report is confirmed
    Then COG approves patient on treatment arm: "APEC1621-B", stratum: "100" to step: "1.1"
    Then patient status should be "ON_TREATMENT_ARM"


#  Scenario: Patient matches to a treatment arm but COG deems it not eligible


  Scenario: Patient is excluded from the arm that has a matching exclusion variant and inclusion variant
    Given patient: "PT_ETE04" is registered
    Then tissue specimen received with surgical_event_id: "PT_ETE04_SEI1"
    Then "TISSUE" specimen shipped to "MDA" with molecular_id or slide_barcode: "PT_ETE04_MOI1"
    Then "SLIDE" specimen shipped to "MDA" with molecular_id or slide_barcode: "PT_ETE04_BC1"
    Then "ICCPTENs" assay result received result: "NEGATIVE"
    Then "ICCBAF47s" assay result received result: "NEGATIVE"
    Then "ICCBRG1s" assay result received result: "NEGATIVE"
    Then "TISSUE" variant report "ETE04.vcf" uploaded with analysis id: "PT_ETE04_ANI1"
    Then "TISSUE" variant report confirmed with status: "CONFIRMED"
    Then patient status should be "PENDING_CONFIRMATION"
    Then current assignment report_status: "NO_TREATMENT_FOUND"
    Then treatment assignment results for treatment arm is "APEC1621-B" is "A match was found for exclusion variant TPM3-ROS1.T7R35.COSF1273"
    Then treatment assignment results for treatment arm is "APEC1621-B" is "A match was found for inclusion variant TPM3-NTRK1.T7N10.COSF1318."
    Then assignment report is confirmed
    Then patient status should be "NO_TA_AVAILABLE"

  Scenario: Patient is assigned to the treatment arm based on non-hotspot variant match (Gene and exon)
    Given patient: "PT_ETE05" is registered
    Then tissue specimen received with surgical_event_id: "PT_ETE05_SEI1"
    Then "TISSUE" specimen shipped to "MDA" with molecular_id or slide_barcode: "PT_ETE05_MOI1"
    Then "SLIDE" specimen shipped to "MDA" with molecular_id or slide_barcode: "PT_ETE05_BC1"
    Then "ICCPTENs" assay result received result: "NEGATIVE"
    Then "ICCBAF47s" assay result received result: "NEGATIVE"
    Then "ICCBRG1s" assay result received result: "NEGATIVE"
    Then "TISSUE" variant report "ETE05.vcf" uploaded with analysis id: "PT_ETE05_ANI1"
    Then "TISSUE" variant report confirmed with status: "CONFIRMED"
    Then patient status should be "PENDING_CONFIRMATION"
    Then treatment arm: "SNV_location_intronic" with stratum id: "100" is selected
    Then the current assignment reason is "A match was found for inclusion nonhotspot variant (GENE: KIT, FUNC: -, EXON: 12, OVA: -"
    Then assignment report is confirmed
    Then COG approves patient on treatment arm: "SNV_location_intronic", stratum: "100" to step: "1.1"
    Then patient status should be "ON_TREATMENT_ARM"

  Scenario: Verify that the patient is not assigned to the arm where a variant matches the exclusion non-hotspot rule
    Given patient: "PT_ETE06" is registered
    Then tissue specimen received with surgical_event_id: "PT_ETE06_SEI1"
    Then "TISSUE" specimen shipped to "MDA" with molecular_id or slide_barcode: "PT_ETE06_MOI1"
    Then "SLIDE" specimen shipped to "MDA" with molecular_id or slide_barcode: "PT_ETE06_BC1"
    Then "ICCPTENs" assay result received result: "NEGATIVE"
    Then "ICCBAF47s" assay result received result: "NEGATIVE"
    Then "ICCBRG1s" assay result received result: "NEGATIVE"
    Then "TISSUE" variant report "ETE06.vcf" uploaded with analysis id: "PT_ETE06_ANI1"
    Then "TISSUE" variant report confirmed with status: "CONFIRMED"
    Then patient status should be "PENDING_CONFIRMATION"
    Then current assignment report_status: "NO_TREATMENT_FOUND"
    Then assignment report is confirmed
    Then patient status should be "NO_TA_AVAILABLE"
    Then treatment assignment results for treatment arm is "APEC1621-B" is "A match was found for exclusion nonhotspot variant (GENE: TP53, FUNC: Refallele, EXON: -, OVA: -"

  Scenario: When a Patient does not have any disease(s) then he or she should not be assigned to a TA
    Given patient: "PT_ETE07" is registered
    Then tissue specimen received with surgical_event_id: "PT_ETE07_SEI1"
    Then "TISSUE" specimen shipped to "MDA" with molecular_id or slide_barcode: "PT_ETE07_MOI1"
    Then "SLIDE" specimen shipped to "MDA" with molecular_id or slide_barcode: "PT_ETE07_BC1"
    Then "ICCPTENs" assay result received result: "NEGATIVE"
    Then "ICCBAF47s" assay result received result: "NEGATIVE"
    Then "ICCBRG1s" assay result received result: "NEGATIVE"
    Then "TISSUE" variant report "ETE07.vcf" uploaded with analysis id: "PT_ETE07_ANI1"
    Then "TISSUE" variant report confirmed with status: "CONFIRMED"
    Then patient status should be "PENDING_CONFIRMATION"

  Scenario: Patient is assigned to a treatment arm based on non-hotspot rules.
    Given patient: "PT_ETE08" is registered
    Then tissue specimen received with surgical_event_id: "PT_ETE08_SEI1"
    Then "TISSUE" specimen shipped to "MDA" with molecular_id or slide_barcode: "PT_ETE08_MOI1"
    Then "SLIDE" specimen shipped to "MDA" with molecular_id or slide_barcode: "PT_ETE08_BC1"
    Then "ICCPTENs" assay result received result: "NEGATIVE"
    Then "ICCBAF47s" assay result received result: "NEGATIVE"
    Then "ICCBRG1s" assay result received result: "NEGATIVE"
    Then "TISSUE" variant report "ETE08.vcf" uploaded with analysis id: "PT_ETE08_ANI1"
    Then "TISSUE" variant report confirmed with status: "CONFIRMED"
    Then patient status should be "PENDING_CONFIRMATION"
    Then treatment arm: "APEC1621-D" with stratum id: "100" is selected
    Then the current assignment reason is "A match was found for inclusion nonhotspot variant (GENE: KRAS, FUNC: -, EXON: -, OVA: -, PROTEIN: p.A416BC"
    Then assignment report is confirmed
    Then COG approves patient on treatment arm: "APEC1621-D", stratum: "100" to step: "1.1"
    Then patient status should be "ON_TREATMENT_ARM"

#  Scenario: Patient on a TA when receives REQUEST_ASSIGNMENT message with rebiopsy flag 'N' is put back in queue and reassigned to a new TA
#
#
#  Scenario: Patient on a TA when receives REQUEST_ASSIGNMENT message with rebiopsy flag 'Y' receives new specimen messages, shipment messages, variant report and is reassigned to a new TA
#
#  Scenario: When a patient has a prior drug that matches the exclusion drug, the patient is not assigned to the TA
#
#  Scenario: When the patient receives an off_trial message from ECOG, and the patient is in PENDING_CONFIRMATION status, the TA counter must be decremented.
#
#  Scenario: When the patient receives an off_trial message from ECOG, and the patient is in PENDING_APPROVAL status, the TA counter must be decremented.
#
#  Scenario: Patient when matches to an arm that is in SUSPENDED or CLOSED state goes in to COMPASSIOANTE CARE

  Scenario: Patient on arm gets assay result and then progresses. the new assay result should be used for assignment.
    Given patient: "PT_ETE09" is registered
    Then tissue specimen received with surgical_event_id: "PT_ETE09_SEI1"
    Then "TISSUE" specimen shipped to "MDA" with molecular_id or slide_barcode: "PT_ETE09_MOI1"
    Then "SLIDE" specimen shipped to "MDA" with molecular_id or slide_barcode: "PT_ETE09_BC1"
    Then "ICCPTENs" assay result received result: "POSITIVE"
    Then "ICCBAF47s" assay result received result: "NEGATIVE"
    Then "ICCBRG1s" assay result received result: "NEGATIVE"
    Then "TISSUE" variant report "ETE09.vcf" uploaded with analysis id: "PT_ETE09_ANI1"
    Then "TISSUE" variant report confirmed with status: "CONFIRMED"
    Then patient status should be "PENDING_CONFIRMATION"
    Then treatment arm: "APEC1621-E" with stratum id: "100" is selected
    Then the current assignment reason is "A match was found for assay rule (GENE: PTEN, RESULT: POSITIVE, VARIANT: PRESENT). A match was found for inclusion variant pedmatch-1."
    Then assignment report is confirmed
    Then COG approves patient on treatment arm: "APEC1621-E", stratum: "100" to step: "1.1"
    Then patient status should be "ON_TREATMENT_ARM"
    Then "ICCPTENs" assay result received result: "NEGATIVE"
    Then COG requests assignment for this patient with re-biopsy: "N", step number: "2.0"
    Then patient status should be "PENDING_CONFIRMATION"
    Then treatment arm: "APEC1621-F" with stratum id: "100" is selected
    Then the current assignment reason is "A match was found for assay rule (GENE: PTEN, RESULT: NEGATIVE, VARIANT: PRESENT). A match was found for inclusion variant pedmatch-2."
    Then assignment report is confirmed
    Then COG approves patient on treatment arm: "APEC1621-F", stratum: "100" to step: "2.1"
    Then patient status should be "ON_TREATMENT_ARM"


