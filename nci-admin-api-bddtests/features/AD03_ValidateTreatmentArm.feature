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
And I should see the reason of rejection on "<field>" as "<reason>"
And I "should" see "false" value under the "passed" field
Examples:
	| field 								| validation_level | reason 																															|
	| treatment_arm_id 			| all 						 | The field treatment_arm_id must exist within the treatment arm. 			|
	| name 									| all 						 | The field name must exist within the treatment arm. 									|
	| version 							| all 						 | The field version must exist within the treatment arm. 							|
	| stratum_id 						| all 						 | The field stratum_id must exist.													 						|
	| study_id 							| all 						 | The field study_id must exist within the treatment arm. 							|
	| treatment_arm_drugs 	| all 						 | The field treatment_arm_drugs must exist within the treatment arm. 	|


Scenario Outline: A treatment Arm with certain missing top level fields should not fail validation
Given I retrieve the template for treatment arm
And I remove the field "<field>" from the template
When I issue a post request for validation at level "<validation_level>" with the treatment arm
Then I "should" see a "Success" message
And I "should" see "true" value under the "passed" field
Examples:
	| field 								| validation_level | 
	| gene 									| all 						 | 
	| assay_rules 					| all 						 | 
	| snv_indels 						| all 						 | 
	| non_hotspot_rules 		| all 						 | 
	| copy_number_variants 	| all 						 | 
	| gene_fusions 					| all 						 | 
	| diseases 							| all 						 | 
	| exclusion_drugs				| all 						 | 


Scenario: A treatment arm with empty Treatment arm Id should fail
Given I retrieve the template for treatment arm
And I substitute "" for the "treatment_arm_id"
When I issue a post request for validation at level "all" with the treatment arm
Then I should see the reason of rejection on "treatment_arm_id" as "The treatment arm must have a field treatment_arm_id, and that field must not be empty."


Scenario Outline: A treatment arm with non string treatmene arm id should fail
Given I retrieve the template for treatment arm
And I enter a hash "{name: 'APEC1621'}" for the treatment_arm_id
When I issue a post request for validation at level "all" with the treatment arm
Then I should see the reason of rejection as "<reason>"
Examples:
| reason |
| "{'treatment_arm_id': 'The field treatment_arm_id must be a string. (i.e APEC1621A1)'}" |


Scenario Outline: Validation should raise and inform the user about the ordinal of snv_indel that has the error
Given I retrieve the template for treatment arm
And I add another object of "<top_level>" to "<top_level>"
And I pick the "<ordinal>" ordinal of "<top_level>"
And I set "<key>" to "<value>"
When I issue a post request for validation at level "<top_level>" with the treatment arm
Then I should see the reason of rejection as "<reason>"
Examples:
| top_level  						| ordinal  	| key 							 	| value 	| reason |
| snv_indels 						| 0 			 	| variant_type 		 		| 			 	| reason 1 |
| snv_indels 						| 1  		 	 	| identifier 			 		| 			 	| reason 1 |
| snv_indels 						| 0 			 	| level_of_evidence 	| 			 	| ease|
| snv_indels 						| 1 			 	| inclusion 				 	| 			 	| reaseon |
| assay_rules 					| 0				 	| type 								|	| |
| assay_rules 					| 0				 	| type 								|	| |
| assay_rules 					| 0				 	| type 								|	| |
| assay_rules 					| 0				 	| type 								|	| |
| copy_number_variants	| 0					| variant_type				| | |
| copy_number_variants	| 0					| variant_type				| | |
| copy_number_variants	| 0					| variant_type				| | |
| gene_fusions					| 0					| variant_type				| | |
| gene_fusions					| 0					| variant_type				| | |
| gene_fusions					| 0					| variant_type				| | |
| non_hotspot_rules			| 0					| inclusion						| | |
|	non_hotspot_rules			| 0					| inclusion						| | |
| non_hotspot_rules			| 0					| inclusion						| | |
| non_hotspot_rules			| 0					| inclusion						| | |
| non_hotspot_rules			| 0					| inclusion						| | |
| non_hotspot_rules			| 0					| inclusion						| | |


@broken
Scenario: A treatent arm with multiple errors should see all the errors
Given I retrieve the template for treatment arm
And I remove the field "treeatment_arm_id" from the template
And I remove the field "name" from the template
When I issue a post request for validation at level "all" with the treatment arm
Then I "should" see a "Success" message
And I should see the reason of rejection as "<reason>"
And I "should" see "false" value under the "passed" field

