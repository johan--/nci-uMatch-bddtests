Feature: Patient Report Tab
  A user can access the details about the Tissue and Blood Variant Report for a patient

  Background:
    Given I am a logged in user
    And I navigate to the patients page
    And I click on one of the patients

#  @ui_p1
#  Scenario: Clicking on Tissue Reports lets the user access information about tissue report
#    When I click on the "Tissue Reports" tab
#    Then I should see the "Tissue Reports" tab is active
#    When I click on the Filtered Button under "Tissue Reports" tab
#    Then I see the "Filtered" Button under "Tissue Reports" is selected
#    And I can see the "Surgical Event" drop down
#    And I can see the Surgical event details section
#    And I can see SNVs, Indels, CNV, Gene Fusion Sections under "Tissue Reports" Filtered tab
#    And I can see the "SNVs/MNVs/Indels" table under "Tissue Reports" tab
#    And I can see the "Copy Number Variant(s)" table under "Tissue Reports" tab
#    And I can see the "Gene Fusion(s)" table under "Tissue Reports" tab
#    When I click on the QC Report Button under "Tissue Reports" tab
#    Then I see the "QC Report" Button under "Tissue Reports" is selected
#    And I can see the "SNVs/MNVs/Indels" table under "Tissue Reports" tab
#    And I can see the "Copy Number Variant(s)" table under "Tissue Reports" tab
#    And I can see the "Gene Fusion(s)" table under "Tissue Reports" tab

  @ui_p3
  Scenario: Clicking on the Blood Specimens lets the user access information about the Blood variant.
    When I click on the "Blood Specimens" tab
    Then I should see the "Blood Specimens" tab is active
    When I click on the Filtered Button under "Blood Specimens" tab
    Then I see the "Filtered" Button under "Blood Specimens" is selected
    And I can see the "Analysis" drop down
    And I can see the Analysis ID details section
    And I can see SNVs, Indels, CNV, Gene Fusion Sections under "Blood Specimens" Filtered tab
    And I can see the "SNVs/MNVs/Indels" table under "Blood Specimens" tab
    And I can see the "Copy Number Variant(s)" table under "Blood Specimens" tab
    And I can see the "Gene Fusion(s)" table under "Blood Specimens" tab
    When I click on the QC Report Button under "Blood Specimens" tab
    Then I see the "QC Report" Button under "Blood Specimens" is selected
    And I can see the "SNVs/MNVs/Indels" table under "Blood Specimens" tab
    And I can see the "Copy Number Variant(s)" table under "Blood Specimens" tab
    And I can see the "Gene Fusion(s)" table under "Blood Specimens" tab

#  @ui_p3
#  Scenario: Variant report in Pending status only can access check boxes to confirm
#    And I see the check box in the "SNVs/MNVs/Indels" sub section
#    And I see the check box in the "Copy Number Variant(s)" sub section
#    And I see the check box in the "Gene Fusion(s)" sub section
#    When I click on the "QC Report" Button under "Tissue Reports" tab
#    Then I see the "QC Report" Button under "Tissue Reports" is selected
#    And I can see the Oncomine Control Panel Summary Details
#    And I do not see the check box in the "SNVs/MNVs/Indels sub section
#    And I do not see the check box in the "Copy Number Variant(s)" sub section
#    And I do not see the check box in the "Gene Fusion(s)"n sub section

  @ui_p3
  Scenario: Clicking on the Blood Variant Report lets the user access information about blood variant report
    When I click on the "Blood Variant Report" tab
    Then I can see the "Analysis" drop down
    And I can see the Analysis ID details section
    And I can see the "SNVs/MNVs/Indels" table under "Blood Specimens" tab
    And I can see the "Copy Number Variant(s)" table under "Blood Specimens" tab
    And I can see the "Gene Fusion(s)" table under "Blood Specimens" tab
    When I click on the "Filtered" Button under "Blood Specimens" tab
    Then I see the check box in the "SNVs/MNVs/Indels" sub section
    And I see the check box in the "Copy Number Variant(s)" sub section
    And I see the check box in the "Gene Fusion(s)" sub section
    When I click on the "QC Report" Button under "Blood Specimens" tab
    Then I do not see the check box in the "SNVs/MNVs/Indels sub section
    And I do not see the check box in the "Copy Number Variant(s)" sub section
    And I do not see the check box in the "Gene Fusion(s)"n sub section
