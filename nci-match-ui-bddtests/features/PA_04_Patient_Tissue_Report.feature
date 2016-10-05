Feature: Patient Report Tab
  A user can access the details about the Tissue and Blood Variant Report for a patient

  Background:
    Given I am a logged in user
    And I navigate to the patient page
    And I click on one of the patients

  @patients_p1 @ui_p1
  Scenario: Clicking on Tissue Reports lets the user access information about tissue report
    When I click on the "Tissue Reports" tab
    Then I should see the "Tissue Reports" tab is active
    When I click on the Filtered Button under "Tissue Reports" tab
    Then I see the "Filtered" Button under "Tissue Reports" is selected
    And I can see the "Surgical Event" drop down
    And I can see the Surgical event details section
    And I can see SNVs, Indels, CNV, Gene Fusion Sections under "Tissue Reports" Filtered tab
    And I can see the "SNVs/MNVs/Indels" table under "Tissue Reports" tab
    And I can see the "Copy Number Variant(s)" table under "Tissue Reports" tab
    And I can see the "Gene Fusion(s)" table under "Tissue Reports" tab
    When I click on the QC Report Button under "Tissue Reports" tab
    Then I see the "QC Report" Button under "Tissue Reports" is selected
    And I can see the "SNVs/MNVs/Indels" table under "Tissue Reports" tab
    And I can see the "Copy Number Variant(s)" table under "Tissue Reports" tab
    And I can see the "Gene Fusion(s)" table under "Tissue Reports" tab

  @patients_p2 @ui_p2
  Scenario: Clicking on the Blood Variant Report lets the user access information about the Blood variant.
    When I click on the "Blood Variant Reports" tab
    Then I should see the "Blood Variant Reports" tab is active
    When I click on the Filtered Button under "Blood Variant Reports" tab
    Then I see the "Filtered" Button under "Blood Variant Reports" is selected
    And I can see the "Analysis" drop down
    And I can see the Analysis ID details section
    And I can see SNVs, Indels, CNV, Gene Fusion Sections under "Blood Variant Reports" Filtered tab
    And I can see the "SNVs/MNVs/Indels" table under "Blood Variant Reports" tab
    And I can see the "Copy Number Variant(s)" table under "Blood Variant Reports" tab
    And I can see the "Gene Fusion(s)" table under "Blood Variant Reports" tab
    When I click on the QC Report Button under "Blood Variant Reports" tab
    Then I see the "QC Report" Button under "Blood Variant Reports" is selected
    And I can see the "SNVs/MNVs/Indels" table under "Blood Variant Reports" tab
    And I can see the "Copy Number Variant(s)" table under "Blood Variant Reports" tab
    And I can see the "Gene Fusion(s)" table under "Blood Variant Reports" tab

  @patients_p3 @ui_p3
  Scenario: Variant report in Pending status only can access check boxes to confirm
    And I see the check box in the "SNVs/MNVs/Indels" sub section
    And I see the check box in the "Copy Number Variant(s)" sub section
    And I see the check box in the "Gene Fusion(s)" sub section
    When I click on the "QC Report" Button under "Tissue Reports" tab
    Then I see the "QC Report" Button under "Tissue Reports" is selected
    And I can see the Oncomine Control Panel Summary Details
    And I do not see the check box in the "SNVs/MNVs/Indels sub section
    And I do not see the check box in the "Copy Number Variant(s)" sub section
    And I do not see the check box in the "Gene Fusion(s)"n sub section

  @patients_p3 @ui_p3
  Scenario: Clicking on the Blood Variant Report lets the user access information about blood variant report
    When I click on the "Blood Variant Report" tab
    Then I can see the "Analysis" drop down
    And I can see the Analysis ID details section
    And I can see the "SNVs/MNVs/Indels" table under "Blood Variant Reports" tab
    And I can see the "Copy Number Variant(s)" table under "Blood Variant Reports" tab
    And I can see the "Gene Fusion(s)" table under "Blood Variant Reports" tab
    When I click on the "Filtered" Button under "Blood Variant Reports" tab
    Then I see the check box in the "SNVs/MNVs/Indels" sub section
    And I see the check box in the "Copy Number Variant(s)" sub section
    And I see the check box in the "Gene Fusion(s)" sub section
    When I click on the "QC Report" Button under "Blood Variant Reports" tab
    Then I do not see the check box in the "SNVs/MNVs/Indels sub section
    And I do not see the check box in the "Copy Number Variant(s)" sub section
    And I do not see the check box in the "Gene Fusion(s)"n sub section

    # todo: MATCHKB-348 in assignment section the "selected Tretmnet arm" is present under the selcted section and in a green box on top of the assignment report section
  # todo: MATCHKB-349 Only Pending Variant report should show confirm / reject button
    # todo: MATCHKB-350  pending report does not show the date. COnfirmed report shows confirmed date, rejected report shows rejected date.
    # todo: MATCHKB-404 go to patient => tissue reports => QC REPORT. if the values in the oncominr report is 0 we should see an additonal essage box.
