Feature: Patient Report Tab
  A user can access the details about the Tissue and Blood Variant Report for a patient

  Background:
    Given I am a logged in user
    And I navigate to the patient page
    And I click on one of the patients

  @patients @ui @broken
  Scenario: Clicking on Tissue Report lets the user access information about tissue report
    When I click on the "Tissue Report" tab
    Then I can see the "Surgical Event" drop down
    And I can see the Surgical event details section
    And I can see the "SNVs/MNVs/Indels" sub-section
    And I can see the "Copy Number Variant(s)" sub-section
    And I can see the "Gene Fusion(s)" sub-section
    When I click on the Filtered Button
    Then I can see the Variant section
    And I can see the aMOI Summary
    And I see the check box in the "SNVs/MNVs/Indels" sub section
    And I see the check box in the "Copy Number Variant(s)" sub section
    And I see the check box in the "Gene Fusion(s)" sub section
    When I click on the QC Report Button
    Then I can see the Oncomine Control Panel Summary Details
    And I do not see the check box in the "SNVs/MNVs/Indels sub section
    And I do not see the check box in the "Copy Number Variant(s)" sub section
    And I do not see the check box in the "Gene Fusion(s)"n sub section

  @patients @ui @broken
  Scenario: Clicking on the Blood Variant Report lets the user access information about blood variant report
    When I click on the "Blood Variant Report" tab
    Then I can see the "Analysis" drop down
    And I can see the Analysis ID details section
    And I can see the "SNVs/MNVs/Indels" sub-section
    And I can see the "Copy Number Variant(s)" sub-section
    And I can see the "Gene Fusion(s)" sub-section
    When I click on the Filtered Button
    Then I see the check box in the "SNVs/MNVs/Indels" sub section
    And I see the check box in the "Copy Number Variant(s)" sub section
    And I see the check box in the "Gene Fusion(s)" sub section
    When I click on the QC Report Button
    Then I do not see the check box in the "SNVs/MNVs/Indels sub section
    And I do not see the check box in the "Copy Number Variant(s)" sub section
    And I do not see the check box in the "Gene Fusion(s)"n sub section

