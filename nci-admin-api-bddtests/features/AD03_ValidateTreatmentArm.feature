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
	| study_id 							| all 						 | The field study_id must exist and it must be set to the value APEC1621.|
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

@broken
Scenario: A treatment arm with non string treatment arm id should fail
Given I retrieve the template for treatment arm
And I enter a hash "{name: 'APEC1621SC'}" for the treatment_arm_id
When I issue a post request for validation at level "all" with the treatment arm
Then I should see the reason of rejection on "treatment_arm_id" as "Treatment arm must be a string"


Scenario Outline: Validation should raise and inform the user about the ordinal of snv_indel that has the error
Given I retrieve the template for treatment arm
And I add a duplicate of the object to "<top_level>"
And I set "<key>" to "<value>"
When I issue a post request for validation at level "<top_level>" with the treatment arm
Then I "should" see a "Success" message
And I "should" see "false" value under the "passed" field
Then I should see the reason of rejectionon "<top_level>" as "<reason>"
Examples:
| top_level  						| key 							 	| value 	| reason 						 |
| snv_indels 						| variant_type 		 		| 			 	| reason placeholder |
| snv_indels 						| identifier 			 		| 			 	| reason placeholder |
| snv_indels 						| level_of_evidence 	| 			 	| reason placeholder |
| snv_indels 						| inclusion 				 	| 			 	| reason placeholder |
| assay_rules 					| type 								|					| reason placeholder |
| assay_rules 					| type 								|					| reason placeholder |
| assay_rules 					| type 								|					| reason placeholder |
| assay_rules 					| type 								|					| reason placeholder |
| copy_number_variants	| variant_type				| 				| reason placeholder |
| copy_number_variants	| variant_type				| 				| reason placeholder |
| copy_number_variants	| variant_type				| 				| reason placeholder |
| gene_fusions					| variant_type				| 				| reason placeholder |
| gene_fusions					| variant_type				| 				| reason placeholder |
| gene_fusions					| variant_type				| 				| reason placeholder |
| non_hotspot_rules			| inclusion						| 				| reason placeholder |
|	non_hotspot_rules			| inclusion						| 				| reason placeholder |
| non_hotspot_rules			| inclusion						| 				| reason placeholder |
| non_hotspot_rules			| inclusion						| 				| reason placeholder |
| non_hotspot_rules			| inclusion						| 				| reason placeholder |
| non_hotspot_rules			| inclusion						| 				| reason placeholder |


@broken
Scenario: A treatent arm with multiple errors should see all the errors
Given I retrieve the template for treatment arm
And I remove the field "treeatment_arm_id" from the template
And I remove the field "name" from the template
When I issue a post request for validation at level "all" with the treatment arm
Then I "should" see a "Success" message
And I should see the reason of rejection as "<reason>"
And I "should" see "false" value under the "passed" field

