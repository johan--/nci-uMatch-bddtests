Feature: CLIA Labs Page
    @ui_p1
    Scenario Outline: User can generate an MSN under <sectionName> section for <subTabName>
        Given I'm logged in as a "<userType>" user
        When I navigate to the CLIA Labs page
        And I click on the "<sectionName>" section
        Then I am on the "<sectionName>" section
        And I click on "<subTabName>" under "<sectionName>"
        Then I verify that "<subTabName>" under "<sectionName>" is active
        And I verify the headings for "<subTabName>" under "<sectionName>"
        And I collect information on "<subTabName>" under "<sectionName>"
        And I click on Generate MSN button
        And I collect new information on "<subTabName>" under "<sectionName>"
        Then a new Molecular Id is created under the "<sectionName>"

        Examples:
            | userType        | sectionName | subTabName                  |
            | VR_Reviewer_mocha | MoCha       | Positive Sample Controls    |
            | VR_Reviewer_mocha | MoCha       | No Template Control         |
            | VR_Reviewer_mocha | MoCha       | Proficiency And Competency  |
            | VR_Reviewer_mda   | MD Anderson | Positive Sample Controls    |
            | VR_Reviewer_mda   | MD Anderson | No Template Control         |
            | VR_Reviewer_mda   | MD Anderson | Proficiency And Competency  |

    @ui_p1
    Scenario: User can add a variant report to a generated MSN
        Given I'm logged in as a "VR_Reviewer_mocha" user
        When I navigate to the CLIA Labs page
        When I click on the "MoCha" section
        And I click on "Positive Sample Controls" under "MoCha"
        And I collect information on "Positive Sample Controls" under "MoCha"
        And I click on Generate MSN button
        And I collect new information on "Positive Sample Controls" under "MoCha"
        And I capture the new MSN created
        And I upload variant report to S3 with the generated MSN
        And I wait "5" seconds
        And I call the aliquot service with the generated MSN
        And I wait "30" seconds
        And I navigate to the CLIA Labs page
        Then I see variant report details for the generated MSN
        And I delete the variant reports uploaded to S3

    @ui_p1
    Scenario: User can access information about the uploaded No Template Control report.
        Given I'm logged in as a "VR_Reviewer_mocha" user
        When I navigate to the CLIA Labs page
        When I click on the "MoCha" section
        And I click on "No Template Control" under "MoCha"
        And I go to clia variant report with "SC_SA1CB" as the molecular_id
        And The "PASSED" button is "visible"

    @ui_p1
    Scenario: User can access information about the uploaded Positive Sample Control report.
        Given I'm logged in as a "VR_Reviewer_mocha" user
        When I navigate to the CLIA Labs page
        When I click on the "MoCha" section
        And I click on "Positive Sample Controls" under "MoCha"
        And I enter "SC_A2PD6" in the search field on "Positive Sample Controls" under "MoCha"
        And I collect information about the sample variant report
        And I click on the sample control link
        Then I verify that I am on the sample control page for that molecularId
        And I verify all the values on the left hand side section under Positive Sample Control
        And I verify all the values on the right hand side section under Positive Sample Control
        And I verify all the headings on the "left" hand side section under Positive Sample Control
        And I verify all the headings on the "right" hand side section under Positive Sample Control
        And I verify the presence of Positive controls and False positive variants table
        And I verify that valid IDs are links and invalid IDs are not in "Positive Controls" table
        And I verify that valid IDs are links and invalid IDs are not in "False Positive Variants" table

    @ui_p1 @demo_p4 @tests
    Scenario Outline: User can access information about the uploaded <tableType> report.
        Given I'm logged in as a "VR_Reviewer_mocha" user
        When I navigate to the CLIA Labs page
        When I click on the "MoCha" section
        And I click on "<tableType>" under "MoCha"
        And I enter "<sampleControlId>" in the search field on "<tableType>" under "MoCha"
        And I collect information about the sample variant report from aliquot
        And I click on the sample control link
        Then I verify that I am on the sample control page for that molecularId
        And I verify all the values on the left hand side section under "<tableType>"
        And I verify all the values on the right hand side section under "<tableType>"
        And I verify all the headings on the "left" hand side section under "<tableType>"
        And I verify all the headings on the "right" hand side section under "<tableType>"
        And I verify the presence of SNVs, CNVs and Gene Fusions Table
        #    And I verify the valid Ids are links in the SNVs/MNVs/Indels table under "<tableType>"
        #    And I verify the valid Ids are links in the Gene Fusions table under "<tableType>"
        #    And I verify the valid Ids are links in the Copy Number Variants table under "<tableType>"
        Examples:
            | tableType | sampleControlId |
            | No Template Control | SC_KGPVI |
            | Proficiency And Competency | SC_FDK09 |
