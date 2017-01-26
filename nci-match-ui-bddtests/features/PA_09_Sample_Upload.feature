@ui_p2
Feature: MATCHKB-542. Users can upload patient sample files.
  The user is able to upload a large sample file, such as BAM file. 
  A file can be as large as 20 GB or more.

  Scenario Outline: As a privileged user I can upload a sample file
    Given I'm logged in as a "<user>" user
    When I go to patient "<patient_id>" details page
    And I click on the Surgical Event Tab "<surgical_event_id>"
    And I can see that some files have not been uploaded for the Surgical Event
    Then The "Upload new sample file" button is "visible"
    And The "Upload new sample file" button is "enabled"
    And I click on the "Upload new sample file" button
    And I can see the "Upload BAM files and Variant ZIP files" dialog
    Then I select an Ion Reporter "<ir_reporter>"
    And I enter Analysis ID "<analysis_id>"
    And I select a file "<file>"
    Then The "Upload" button is "visible"
    And The "Upload" button is "enabled"
    Then I can click on the "Upload" button
    And I can see the Sample File upload process has started
    Then I logout
    Examples:
      | user              | patient_id              | surgical_event_id            | ir_reporter      | analysis_id                   | file            |
      | VR_Reviewer_mda   | PT_AU04_MdaTsShipped1   | PT_AU04_MdaTsShipped1_SEI1   | mda - IR_MDA05   | PT_AU04_MdaTsShipped1_An123   | mda_small.vcf   |
      | VR_Reviewer_mocha | PT_AU04_MochaTsShipped1 | PT_AU04_MochaTsShipped1_SEI1 | mocha - IR_MCA00 | PT_AU04_MochaTsShipped1_An123 | mocha_small.vcf |

  Scenario: As a privileged user I can't upload a sample file if all files have been uploaded already
    Given I'm logged in as a "VR_Reviewer_mda" user
    When I go to patient "ION_AQ41_TsVrUploaded" details page
    And I click on the Surgical Event Tab "ION_AQ41_TsVrUploaded_SEI1"
    And I can see that all files have been uploaded for the Surgical Event
    Then The "Upload new sample file" button is "not visible"
    Then I logout

  Scenario: As a privileged user I can't upload sample file until all validations pass
    Given I'm logged in as a "VR_Reviewer_mocha" user
    When I go to patient "ION_AQ02_TsShipped" details page
    And I click on the Surgical Event Tab "ION_AQ02_TsShipped_SEI1"
    And I can see that some files have not been uploaded for the Surgical Event
    Then The "Upload new sample file" button is "visible"
    And The "Upload new sample file" button is "enabled"
    And I click on the "Upload new sample file" button
    And I can see the "Upload BAM files and Variant ZIP files" dialog
    Then I select an Ion Reporter "mocha - IR_MCA00"
    And I enter Analysis ID ""
    Then The "Upload" button is "not enabled"
    Then I enter Analysis ID "ION_AQ41_TsVrUploaded_ANI1"
    And The "Upload" button is "not enabled"
    Then I enter Analysis ID "TOTALLY_NEW_ID"
    And The "Upload" button is "enabled"
    Then I select an Ion Reporter "Select Site and Ion Reporter ID"
    And The "Upload" button is "not enabled"
    Then I logout

  Scenario: As a privileged user I can cancel upload
    Given I'm logged in as a "VR_Reviewer_mocha" user
    When I go to patient "ION_AQ02_TsShipped" details page
    And I click on the Surgical Event Tab "ION_AQ02_TsShipped_SEI1"
    And I can see that some files have not been uploaded for the Surgical Event
    Then The "Upload new sample file" button is "visible"
    And The "Upload new sample file" button is "enabled"
    And I click on the "Upload new sample file" button
    And I can see the "Upload BAM files and Variant ZIP files" dialog
    Then I select an Ion Reporter "mocha - IR_MCA00"
    And I enter Analysis ID "ION_AQ41_TsVrUploaded_ANI1"
    And The "Upload" button is "enabled"
    And I click on the "Upload" button
    Then I can see the Upload Progress in the toolbar
    And I click on the Upload Progress in the toolbar
    Then I can see current uploads
    And I can cancel the first upload in the list
    Then The cancelled file is removed from the upload list
    Then I logout
