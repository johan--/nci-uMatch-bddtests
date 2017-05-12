
Feature: As a valid user I can access the variant report for a patient and navigate around

  Background:
    Given I stay logged in as "read_only" user

  @ui_p2
  Scenario Outline: I can sort Variant Report tables by clicking column headers
    When I go to the patient "PT_AM05_TsVrReceived1" with variant report "PT_AM05_TsVrReceived1_ANI1"
    And I scroll to the bottom of the page
    Then I can see the "<table>" table
    And I remember order of elements in column "<columnNumber>" of the "<table>" table
    And I click on "<columnNumber>" column header of the "<table>" table
    Then I should see the data in the column to be sorted properly
    Examples:
      | table            | columnNumber |
      | SNVs/MNVs/Indels | 11           |

  @ui_p2
  Scenario: Surgical Event link in the variant report should link back to the Surgical Event
    When I go to the patient "UI_PA08_PendingConfirmation" with variant report "UI_PA08_PendingConfirmation_ANI1"
    And I click on the Surgical Event Id Link
    Then I should go to the surgical event page of the patient

  @ui_p2
  Scenario: Molecular Id link in the variant report should link back to the  Molecular Id Section
    When I go to the patient "UI_PA08_PendingConfirmation" with variant report "UI_PA08_PendingConfirmation_ANI1"
    And I click on the Molecular ID link
    Then I should go to the molecular id section of the surgical event page

  @ui_p2
  Scenario: Checking for the presence of tables on the variant report
    When I go to the patient "UI_PA08_PendingConfirmation" with variant report "UI_PA08_PendingConfirmation_ANI1"
    Then I can see the "SNVs/MNVs/Indels" table heading
    And I can see the "Copy Number Variants" table heading
    And I can see the "Gene Fusions" table heading
    And I can see the columns in "SNVs/MNVs/Indels" table
    And I can see the columns in "Copy Number Variants" table
    And I can see the columns in "Gene Fusions" table

  @ui_p2
  Scenario: Checking the amois values in the Gene Fusion table of the variant report
    When I go to the patient "UI_PA08_PendingConfirmation" with variant report "UI_PA08_PendingConfirmation_ANI1"
    And I collect information about the patient amois
    And I verify the "identifier" in the Gene Fusions table
    And I verify that "identifier" are proper cosmic links under "Gene Fusions"
#    And I verify the "amois" in the Gene Fusions table
    And I verify the "driver_gene" in the Gene Fusions table
    And I verify that "driver_gene" is a proper Gene link under "Gene Fusions"
    And I verify the "partner_gene" in the Gene Fusions table
    And I verify that "partner_gene" is a proper Gene link under "Gene Fusions"
    And I verify the "annotation" in the Gene Fusions table
    And I verify the "read_depth" in the Gene Fusions table

  @ui_p3
  Scenario: Checking the amois values in the SNVs/MNVs/Indels table of the variant report
    When I go to the patient "UI_PA08_PendingConfirmation" with variant report "UI_PA08_PendingConfirmation_ANI1"
    And I collect information about the patient amois
    And I verify the "identifier" in the SNVs/MNVs/Indels table
    And I verify that "identifier" are proper cosmic links under "SNVs/MNVs/Indels"
    And I verify the "chromosome" in the SNVs/MNVs/Indels table
    And I verify the "position" in the SNVs/MNVs/Indels table
    And I verify the "ocp_reference" in the SNVs/MNVs/Indels table
    And I verify the "ocp_alternative" in the SNVs/MNVs/Indels table
    And I verify the "allele_frequency" in the SNVs/MNVs/Indels table
    And I verify the "read_depth" in the SNVs/MNVs/Indels table
#    And I verify the "amois" in the Gene Fusions table
    And I verify the "func_gene" in the SNVs/MNVs/Indels table
    And I verify that "func_gene" is a proper Gene link under "SNVs/MNVs/Indels"
    And I verify the "transcript" in the SNVs/MNVs/Indels table
    And I verify the "hgvs" in the SNVs/MNVs/Indels table
    And I verify the "protein" in the SNVs/MNVs/Indels table
    And I verify the "exon" in the SNVs/MNVs/Indels table
    And I verify the "function" in the SNVs/MNVs/Indels table
    And I verify the "oncomine_variant_class" in the SNVs/MNVs/Indels table

  @ui_p3
  Scenario: Checking the amois values in the Copy Number Variants table of the variant report
    When I go to the patient "UI_PA08_PendingConfirmation" with variant report "UI_PA08_PendingConfirmation_ANI1"
    And I collect information about the patient amois
    And I verify the "identifier" in the Copy Number Variants table
    And I verify that "identifier" are proper cosmic links under "Copy Number Variants"
#    And I verify the "amois" in the Gene Fusions table
    And I verify the "chromosome" in the Copy Number Variants table
    And I verify the "raw_copy_number" in the Copy Number Variants table
    And I verify that "confidence_interval_5percent" is a proper Gene link under "Gene Fusions"
    And I verify the "copy_number" in the Copy Number Variants table
    And I verify the "confidence_interval_95percent" in the Copy Number Variants table


  @ui_p2
  Scenario Outline: Patient with variant report of torrent version <torent_version> will <have_or_not> pool-total values
    When I go to the patient "<patient_id>" with variant report "<variant_report>"
    Then I expect to see the Torrent Variant Caller Version as "<torrent_version>"
    And I expect to see the Pool 1 Total as "<pool1>"
    And I expect to see the Pool 2 Total as "<pool2>"
    Examples:
    | patient_id             | variant_report               | torrent_version | pool1     | pool2     |
    | UI_PA09_TsVr52Uploaded | UI_PA09_TsVr52Uploaded_ANI1  | 5.2-25          | 449632.5  | 957045.5  |

  @ui_p3
  Scenario: Checking the QC values in the SNVs/MNVs/Indels table of the variant report
    When I go to the patient "UI_PA08_PendingConfirmation" with variant report "UI_PA08_PendingConfirmation_ANI1"
    And I click on the "QC Report" label
    And I wait for "30" seconds
    And I collect information about the patient QC
    And I verify the "identifier" in the SNVs/MNVs/Indels table
    And I verify that "identifier" are proper cosmic links under "SNVs/MNVs/Indels"
    And I verify the "chromosome" in the SNVs/MNVs/Indels table
    And I verify the "position" in the SNVs/MNVs/Indels table
    And I verify the "ocp_reference" in the SNVs/MNVs/Indels table
    And I verify the "ocp_alternative" in the SNVs/MNVs/Indels table
    And I verify the "allele_frequency" in the SNVs/MNVs/Indels table
    And I verify the "read_depth" in the SNVs/MNVs/Indels table
#    And I verify the "amois" in the Gene Fusions table
    And I verify the "func_gene" in the SNVs/MNVs/Indels table
    And I verify that "func_gene" is a proper Gene link under "SNVs/MNVs/Indels"
    And I verify the "transcript" in the SNVs/MNVs/Indels table
    And I verify the "hgvs" in the SNVs/MNVs/Indels table
    And I verify the "protein" in the SNVs/MNVs/Indels table
    And I verify the "exon" in the SNVs/MNVs/Indels table
    And I verify the "function" in the SNVs/MNVs/Indels table
    And I verify the "oncomine_variant_class" in the SNVs/MNVs/Indels table
    And I verify the "identifier" in the Copy Number Variants table
    And I verify that "identifier" are proper cosmic links under "Copy Number Variants"
#    And I verify the "amois" in the Gene Fusions table
    And I verify the "chromosome" in the Copy Number Variants table
    And I verify the "raw_copy_number" in the Copy Number Variants table
    And I verify that "confidence_interval_5percent" is a proper Gene link under "Gene Fusions"
    And I verify the "copy_number" in the Copy Number Variants table
    And I verify the "confidence_interval_95percent" in the Copy Number Variants table
    And I verify the "identifier" in the Gene Fusions table
    And I verify that "identifier" are proper cosmic links under "Gene Fusions"
#    And I verify the "amois" in the Gene Fusions table
    And I verify the "driver_gene" in the Gene Fusions table
    And I verify that "driver_gene" is a proper Gene link under "Gene Fusions"
    And I verify the "partner_gene" in the Gene Fusions table
    And I verify that "partner_gene" is a proper Gene link under "Gene Fusions"
    And I verify the "annotation" in the Gene Fusions table
    And I verify the "read_depth" in the Gene Fusions table