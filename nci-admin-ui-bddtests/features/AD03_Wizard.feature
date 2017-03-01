@admin_ui_p2
Feature: This feature tests the wizard capabilities that can be
 used to create a treatment are from scratch within the Admin tool

Scenario: User can create a treatment arm wihout preloading data using the Wizard tool
	Given I am a logged in user
	And I go to the "Wizard" Section
	And I click on "Next"
	And I fill in the "Arm Data" form page
	And I click on "Next"
	And I fill in the "Other Data" forma page
	And I click on "Next"
	And I fill in the "Exclusion/Inclusion Varients" form page
	When I click on "Next"
	Then I see the details I entered for confirmation
	And I click on "Finish"
	Then I can see then new Treatment arm in the temporary table

Scenario: User can create a treatment arm after preloading data in the wizard tool
	Given I am a logged in user
	And I go to the "Wizard" Section
	And I Preload The "<report_type>" data columns are seen
	And I click on "Next"
	And I fill in the "Arm Data" form page
	And I click on "Next"
	And I fill in the "Other Data" forma page
	And I click on "Next"
	And I fill in the "Exclusion/Inclusion Varients" form page
	When I click on "Next"
	Then I see the details I entered for confirmation
	And I click on "Finish"
	Then I can see then new Treatment arm in the temporary table
