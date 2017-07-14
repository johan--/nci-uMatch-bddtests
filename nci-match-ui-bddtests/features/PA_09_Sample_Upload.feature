
Feature: MATCHKB-542. Users can upload patient sample files.
  The user is able to upload a large sample file, such as BAM file.
  A file can be as large as 20 GB or more.
  @ui_p1
  Scenario: As a privileged MDA Sender I can upload a sample file
    Given I clear the file from S3 under reporter "IR_MDA05", mol_id "PT_AU04_MdaTsShipped1_MOI1", analysis_id "PT_AU04_MdaTsShipped1_An123"
    And I am logged in as a "VR_Sender_mda" user
    When I go to patient "PT_AU04_MdaTsShipped1" with surgical event "PT_AU04_MdaTsShipped1_SEI1"
    And I scroll to the bottom of the page
    And I can see that some files have not been uploaded for the Surgical Event
    Then The "Upload new sample file" link is "visible"
    And The "Upload new sample file" link is "enabled"
    And I can click on the "Upload new sample file" link
    And I can see the "Upload BAM files and Variant ZIP files" dialog
    And The "Start Upload" button looks "disabled"
    Then I select an Ion Reporter "mda - IR_MDA05"
    And I enter Analysis ID "PT_AU04_MdaTsShipped1_An123"
    And I make all elements visible
    And I press "Select Variant ZIP File" file button to upload "vcf_sample.zip" file
    And I press "Select DNA BAM File" file button to upload "dna_sample.bam" file
    And I press "Select cDNA BAM File" file button to upload "rna_sample.bam" file
    Then The "Start Upload" button looks "enabled"
    Then I can click on the "Start Upload" button
    And I wait for "5" seconds
    And I verify that file "vcf_sample.zip" has completed upload
    And I verify that file "dna_sample.bam" has completed upload
    And I verify that file "rna_sample.bam" has completed upload
    When I go to patient "PT_AU04_MdaTsShipped1" details page
    Then I see the downloads in the timeline

  @ui_p1
  Scenario Outline: As a <site> user I can select only the same kind of IR user
    Given I am logged in as a "<user>" user
    When I go to patient "<patient_id>" with surgical event "<surgical_event_id>"
    And I scroll to the bottom of the page
    And I can click on the "Upload new sample file" link
    And I can see the "Upload BAM files and Variant ZIP files" dialog
    And I click on the "Select Site and Ion Reporter ID" button
    Then I can only see "<site>" type user
    And I click on the "Close" button
    And I logout
    Examples:
      | user                | patient_id               | surgical_event_id            | site  |
      | VR_Sender_mocha     | PT_AU04_MochaTsShipped1  | PT_AU04_MochaTsShipped1_SEI1 | mocha |
      | VR_Sender_mda       | PT_AU04_MdaTsShipped1    | PT_AU04_MdaTsShipped1_SEI1   | mda   |
  @ui_p2
  Scenario Outline: As Sender type user, link to upload is <visibility> to a patient of status <status>
    Given I stay logged in as "VR_Sender_mda" user
    When I go to patient "<patient_id>" with surgical event "<surgical_event_id>"
    And The patient has a status of "<status>"
    Then The "Upload new sample file" link is "<visibility>"
    Examples:
        | patient_id                    | surgical_event_id                     | status                            | visibility  |
        | ION_AQ02_TsShipped            | ION_AQ02_TsShipped_SEI1               | TISSUE_NUCLEIC_ACID_SHIPPED       | visible     |
        | ION_AQ41_TsVrUploaded         | ION_AQ41_TsVrUploaded_SEI1            | TISSUE_VARIANT_REPORT_RECEIVED    | visible     |
        | PT_OS01_AssayReceived         | PT_OS01_AssayReceived_SEI1            | ASSAY_RESULTS_RECEIVED            | visible     |
        | PT_AS12_PendingConfirmation   | PT_AS12_PendingConfirmation_SEI1      | PENDING_CONFIRMATION              | invisible   |
        | PT_AM03_PendingApproval       | PT_AM03_PendingApproval_SEI1          | PENDING_APPROVAL                  | invisible   |
        | PT_SR10_CompassionateCare     | PT_SR10_CompassionateCare_SEI1        | COMPASSIONATE_CARE                | invisible   |
        | PT_AS00_SlideShipped4         | PT_AS00_SlideShipped4_SEI1            | TISSUE_SLIDE_SPECIMEN_SHIPPED     | invisible   |
        | PT_AS09_OffStudy              | PT_AS09_OffStudy_SEI1                 | OFF_STUDY                         | invisible   |
        | PT_AS09_ReqNoAssignment       | PT_AS09_ReqNoAssignment_SEI1          | REQUEST_NO_ASSIGNMENT             | invisible   |
        | PT_AS12_OnTreatmentArm        | PT_AS12_OnTreatmentArm_SEI1           | ON_TREATMENT_ARM                  | invisible   |
        | PT_RA03_NoTaAvailable         | PT_RA03_NoTaAvailable_SEI1            | NO_TA_AVAILABLE                   | invisible   |


  @ui_p2
  Scenario: As a privileged user I cannot upload sample file until all validations pass
    Given I am logged in as a "VR_Sender_mda" user
    When I go to patient "ION_AQ02_TsShipped" with surgical event "ION_AQ02_TsShipped_SEI1"
    And I scroll to the bottom of the page
    Then The "Upload new sample file" link is "visible"
    And The "Upload new sample file" link is "enabled"
    And I can click on the "Upload new sample file" link
    And I can see the "Upload BAM files and Variant ZIP files" dialog
    Then I select an Ion Reporter "mda - IR_MDA05"
    Then The "Start Upload" button looks "disabled"
    And The "Close" button looks "enabled"
    Then I enter Analysis ID "ION_AQ41_TsVrUploaded_ANI1"
    And I make all elements visible
    And I press "Select Variant ZIP File" file button to upload "vcfFile.vcf" file
    And I press "Select DNA BAM File" file button to upload "dna.bam" file
    And I press "Select cDNA BAM File" file button to upload "cdna.bam" file
    And The "Start Upload" button looks "disabled"
    Then I enter Analysis ID "TOTALLY_NEW_ID"
    And The "Start Upload" button looks "enabled"
    Then I select an Ion Reporter "Select Site and Ion Reporter ID"
    And The "Start Upload" button looks "disabled"

  @ui_p2
  Scenario: As a privileged user I can cancel upload
    Given I am logged in as a "VR_Reviewer_mocha" user
    When I go to patient "ION_AQ02_TsShipped" with surgical event "ION_AQ02_TsShipped_SEI1"
    And I can see that some files have not been uploaded for the Surgical Event
    Then The "Upload new sample file" link is "visible"
    And The "Upload new sample file" button is "enabled"
    And I click on the "Upload new sample file" button
    And I can see the "Upload BAM files and Variant ZIP files" dialog
    Then I select an Ion Reporter "mocha - IR_MCA00"
    And I enter Analysis ID "ION_AQ41_TsVrUploaded_ANI1"
    And The "Start Upload" button looks "enabled"
    And I click on the "Start Upload" button
    When I click on the "Stop Download and Close" button
    Then The "Upload new sample file" button is "enabled"

  @ui_p2
  Scenario: As a privileged Mocha Sender I can upload a sample file
    Given I clear the file from S3 under reporter "IR_MCA00", mol_id "PT_AU04_MochaTsShipped1_MOI1", analysis_id "PT_AU04_MochaTsShipped1_An123"
    And I am logged in as a "VR_Sender_mocha" user
    When I go to patient "PT_AU04_MochaTsShipped1" with surgical event "PT_AU04_MochaTsShipped1_SEI1"
    And I scroll to the bottom of the page
    And I can see that some files have not been uploaded for the Surgical Event
    Then The "Upload new sample file" link is "visible"
    And The "Upload new sample file" link is "enabled"
    And I can click on the "Upload new sample file" link
    And I can see the "Upload BAM files and Variant ZIP files" dialog
    And The "Start Upload" button looks "disabled"
    Then I select an Ion Reporter "mocha - IR_MCA00"
    And I enter Analysis ID "PT_AU04_MochaTsShipped1_An123"
    And I make all elements visible
    And I press "Select Variant ZIP File" file button to upload "vcf_sample.zip" file
    And I press "Select DNA BAM File" file button to upload "dna_sample.bam" file
    And I press "Select cDNA BAM File" file button to upload "cdna_sample.bam" file
    Then The "Start Upload" button looks "enabled"
    Then I can click on the "Start Upload" button
    And I wait for "15" seconds
    And I verify that file "vcf_sample.zip" has completed upload
    And I verify that file "dna_sample.bam" has completed upload
    And I verify that file "cdna_sample.bam" has completed upload
    When I go to patient "PT_AU04_MochaTsShipped1" details page
    Then I see the downloads in the timeline
