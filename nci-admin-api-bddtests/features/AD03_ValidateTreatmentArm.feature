@admin_api_p1
Feature: Treatment arm validation
As an admin user
I want to make sure that when I post a file
Validations are performed on that file

Background: 
Given I am a user of type "ADMIN"

Scenario: A valid treatment should pass all the validations
Given I retrieve the template for treatment arm
And I substitute "APEC1621-test" for the "treatment_arm_id"
And I substitute "stratum100" for the "stratum_id"
And I substitute "2_1_0" for the "version"
When I issue a post request for validation at level "all" with the treatment arm
Then I "should" see a "Success" message

Scenario Outline: A treatment arm with any of the important fields missing should fail validation
Given I retrieve the template for treatment arm
And I remove the field "<field>" from the template
When I issue a post request for validation at level "<validation_level>" with the treatment arm
Then I "should" see a "Success" message
And I should see the reason of rejection as "<reason>"
And I "should" see "false" value under the "passed" field
Examples:
	| field 								| validation_level | reason |
	| treatment_arm_id 			| all |The field treatment_arm_id must exist within the treatment arm. |
	| name 									| all |The field name must exist within the treatment arm. |
	| version 							| all |The field version must exist within the treatment arm. |
	| stratum_id 						| all |The field stratum_id must exist within the treatment arm. |
	| gene 									| all |The field gene must exist within the treatment arm. |
	| study_id 							| all |The field study_id must exist within the treatment arm. |
	| assay_rules 					| all |The field assay_rules must exist within the treatment arm. |
	| treatment_arm_drugs 	| all |The field treatment_arm_drugs must exist within the treatment arm. |
	| snv_indels 						| all |The field snv_indels must exist within the treatment arm. |
	| non_hotspot_rules 		| all |The field non_hotspot_rules must exist within the treatment arm. |
	| copy_number_variants 	| all |The field copy_number_variants must exist within the treatment arm. |
	| gene_fusions 					| all |The field gene_fusions must exist within the treatment arm. |
	| diseases 							| all |The field diseases must exist within the treatment arm. |
	| exclusion_drugs				| all |The field exclusion_drugs must exist within the treatment arm. |
