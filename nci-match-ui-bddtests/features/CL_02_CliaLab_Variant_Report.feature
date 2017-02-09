Feature: CLIA Labs Variant Reports Page
    @ui_p1 @demo_p4 @clia2
    Scenario Outline: User can access information about the uploaded Positive Sample Control report.
        Given I am logged in as a "<userType>" user
        And I go to clia variant filtered report with "<molecularId>" as the molecular_id on "<subTabName>" tab
#        And The clia report "ACCEPT" button is "visible"
        When I click on clia report "<statusButton>" button on "<subTabName>"
        Then I can see the clia report "Change of the Status" in the modal text box
#        Then I logout

        Examples:
            | userType          | subTabName               | statusButton | molecularId |
            | VR_Reviewer_mocha | Positive Sample Controls | REJECT       | SC_5AMCC    |
            | VR_Reviewer_mocha | No Template Control      | ACCEPT       | SC_SA1CB    |
            | VR_Reviewer_mocha | Proficiency And Competency | CONFIRM      | SC_FDK09   |
