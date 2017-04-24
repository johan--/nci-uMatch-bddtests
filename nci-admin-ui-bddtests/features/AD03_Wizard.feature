@admin_ui_p2 @wizard
Feature: This feature tests the wizard capabilities that can be
 used to create a treatment are from scratch within the Admin tool

Scenario: Wizard01 - User can create a new treatment arm using the Wizard tool
	Given I am a logged in user
	And I navigate to "Wizard" page
	And I click on "Create New Treatment Arm" button in the wizard
	Then I am on the "Arm Data" section
	And I fill in the Arm Data form section
  And I click on "Validate Changes" button in the wizard
	And I click on "Next" button in the wizard
	Then I am on the "Other Data" section
	And I fill in the Other Data form section
	And I click on "Validate Changes" button in the wizard
	And I click on "Next" button in the wizard
	Then I am on the "Exclusion/Inclusion Variants" section
	And I fill in the Exclusion/Inclusion Varients form section
	And I click on "Validate Changes" button in the wizard
	When I click on "Next" button in the wizard
	Then I see the details I entered for confirmation
	And I click on "Complete" button in the wizard
	Then I can see then new Treatment arm in the temporary table

Scenario: Wizard02 - User cannot move forward to the next section without running validations
	Given I am a logged in user
	And I navigate to "Wizard" page
	And I click on "Create New Treatment Arm" button in the wizard
	And I fill in the Arm Data form section
	And I click on "Next" button in the wizard
	Then I am on the "Arm Data" section

Scenario: Wizard03 - Preloaded Arm selection has to be done with the version
	Given I am a logged in user
	And I navigate to "Wizard" page
	And I click on "Upload or Choose Treatment Arm" button in the wizard
	And I land on the selection section
	Then I see that the "Pick this treatment arm" button is "disabled"
	When I select treatment arm "APEC1621-AA-PEND" from the choices
	Then I see that the "Pick this treatment arm" button is "disabled"
	When I select version "version1" from the version dropdown
	Then I see that the "Pick this treatment arm" button is "enabled"

Scenario: Wizard04 - User can create a treatment arm after preloading data in the wizard tool
	Given I am a logged in user
	And I navigate to "Wizard" page
	And I click on "Upload or Choose Treatment Arm" button in the wizard
	And I preload treatment arm "APEC1621-AA-PEND" and version "version1"
	And I click on "Pick this treatment arm" button in the wizard
	And I verify the Arm Data form section
	And I click on "Validate Changes" button in the wizard
	And I click on "Next" button in the wizard
	And I verify the Other Data form section
	And I click on "Validate Changes" button in the wizard
	And I click on "Next" button in the wizard
	And I verify the Exclusion/Inclusion Varients form section
	And I click on "Validate Changes" button in the wizard
	When I click on "Next" button in the wizard
	And I click on "Complete" button in the wizard
	Then I can see then new Treatment arm in the temporary table

Scenario Outline: Wizard05_<tc_no> - Validations on the Arm Data section
	Given I am a logged in user
	And I navigate to "Wizard" page
	And I click on "Create New Treatment Arm" button in the wizard
	And I fill in the Arm Data form section
	And I delete the "<field_name>" field
	Then I see the field is required message under "<field_name>" field
	When I click on "Validate Changes" button in the wizard
	Then A popup is seen displaying the message "Field is missing"
	Examples:
	| tc_no | field_name 				 	|
	|	01		| Treatment Arm Name 	|
	|	02		| Gene 								|
	|	03		| Drug 								|
	|	04		| Drug Id 						|
	|	05		| Pathway Name 				|
	| 06		| Stratum Id 					|


Scenario Outline: Wizard06_<tc_no> - Validations on the Disease and Drugs section
	Given I am a logged in user
	And I navigate to "Wizard" page
	And I click on "Create New Treatment Arm" button in the wizard
	And I fill in the Arm Data form section
	And I click on "Validate Changes" button in the wizard
	And I click on "Next" button in the wizard
	And I fill in the Other Data form section
	And I delete the "<field_name>" field
	Then I see the field is required message under "<field_name>" field
	When I click on "Validate Changes" button in the wizard
	Then A popup is seen displaying the message "Field is missing"
	Examples:
	| tc_no | field_name 				 	|
	|	01		| Disease Code Type 	|
	|	02		| Disease Code				|
	|	03		| Disease Name				|
