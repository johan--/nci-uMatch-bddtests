
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
  Scenario: Checking the filtered values in the SNVs/MNVs/Indels table of the variant report
    When I go to the patient "PT_VC00_CnvVrReceived" with variant report "PT_VC00_CnvVrReceived_ANI1"
    And I collect information about the assignment
    Then I can see the "SNVs/MNVs/Indels" table heading
    And I can see the columns in "SNVs/MNVs/Indels" table
    And I collect "snv_indels" variant data from the backend using using the first row of table as reference
    And I verify the data in the SNV table
    And I verify that all "identifier" are "COSM" Links
    And I verify that all "func_gene" are "Gene" Links

  @ui_p2
  Scenario: Checking the filtered values in the CNV table of the variant report
    When I go to the patient "PT_VC00_CnvVrReceived" with variant report "PT_VC00_CnvVrReceived_ANI1"
    And I collect information about the assignment
    Then I can see the "Copy Number Variants" table heading
    And I can see the columns in "Copy Number Variants" table
    And I collect "copy_number_variants" variant data from the backend using using the first row of table as reference
    And I verify the data in the CNV table
    And I verify that all "identifier" are "Gene" Links

  @ui_p2
  Scenario: Checking the filtered values in the Gene Fusion table of the variant report
    When I go to the patient "PT_VC00_CnvVrReceived" with variant report "PT_VC00_CnvVrReceived_ANI1"
    And I collect information about the assignment
    Then I can see the "Gene Fusions" table heading
    And I can see the columns in "Gene Fusions" table
    And I collect "gene_fusions" variant data from the backend using using the first row of table as reference
    And I verify the data in the Gene Fusions table
    And I verify that all "identifier" are "COSF" Links
    And I verify that all "partner_gene" are "Gene" Links
    And I verify that all "driver_gene" are "Gene" Links


  @ui_p2
  Scenario Outline: Patient with variant report of torrent version <torent_version> will <have_or_not> pool-total values
    When I go to the patient "<patient_id>" with variant report "<variant_report>"
    And I collect information about the assignment
    Then I expect to see the Torrent Variant Caller Version as "<torrent_version>"
    And I expect to see the Pool 1 Total as "<pool1>"
    And I expect to see the Pool 2 Total as "<pool2>"
    Examples:
    | patient_id             | variant_report               | torrent_version | pool1     | pool2     |
    | UI_PA09_TsVr52Uploaded | UI_PA09_TsVr52Uploaded_ANI1  | 5.2-25          | 449632.5  | 957045.5  |

  @ui_p2
  Scenario: Checking the QC values in the SNVs/MNVs/Indels table of the variant report
    When I go to the patient "PT_VC00_CnvVrReceived" with variant report "PT_VC00_CnvVrReceived_ANI1"
    And I collect information about the patient QC
    And I click on the "QC Report" label
    Then I can see the "SNVs/MNVs/Indels" table heading
    And I can see the columns in "SNVs/MNVs/Indels" table for QC
    And I collect "snv_indels" data from the backend using using the first row of table as reference
    And I verify the data in the SNV table of QC Report
    And I verify that all "identifier" are "COSM" Links
    And I verify that all "func_gene" are "Gene" Links
    And I can see the "Copy Number Variants" table heading
    And I can see the columns in "Copy Number Variants" table for QC
    And I collect "copy_number_variants" data from the backend using using the first row of table as reference
    And I verify the data in the CNV table of QC Report
    And I verify that all "identifier" are "Gene" Links
    And I can see the "Gene Fusions" table heading
    And I can see the columns in "Gene Fusions" table for QC
    And I collect "gene_fusions" data from the backend using using the first row of table as reference
    And I verify the data in the Gene Fusions table of QC Report
    And I verify that all "identifier" are "COSF" Links
    And I verify that all "partner_gene" are "Gene" Links
    And I verify that all "driver_gene" are "Gene" Links
