@ui_p2
@test
Feature: MATCHKB-542. Users can upload patient sample files.
  The user is able to upload a large sample file, such as BAM file. 
  A file can be as large as 20 GB or more.

  Scenario Outline: As a privileged user I can upload a sample file
    Given I'm logged in as a "<user>" user
    When I go to patient "<patient_id>" details page
    And I click on the Surgical Event Tab "<surgical_event_id>"
    Then The "Upload new sample file" button is "visible"
    And The "Upload new sample file" button is "enabled"
    And I click on the "Upload new sample file" button
    And I can see the "Upload BAM files and Variant ZIP files" dialog
    Then I select an Ion Reporter "<ir_reporter>"
    And I enter Analysis ID "<analysis_id>"
    Examples:
      | user              | patient_id | surgical_event_id | ir_reporter | analysis_id
      | read_only         |            | 
      | VR_Reviewer_mocha |            | 
      | AR_Reviewer       |            | 

  Scenario Outline: As a non-privileged user I can't upload sample file
    Given I'm logged in as a "<user>" user
    Examples:
      | user              | patient_id | surgical_event_id
      | read_only         |            | 
      | VR_Reviewer_mocha |            | 
      | AR_Reviewer       |            | 

  Scenario: As a privileged user I can cancel upload
    Given I'm logged in as a "read_only" user
