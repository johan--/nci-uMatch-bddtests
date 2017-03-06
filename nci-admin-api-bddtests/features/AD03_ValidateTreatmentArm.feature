Feature: Treatment arm validation
As an admin user
I want to make sure that when I post a file
Validations are performed on that file

Background: 
Given I am a user of type "admin"

Scenario: A valid treatment arm is accepted into pending treatment arm table
Given I retrieve the template for treatment arm
And I substitute "APEC1621-test" for the "treatment_arm_id"
And I substitute "stratum100" for the "stratum_id"
When I issue a post request with the treatment arm 
Then I should receive a success response
And I should see the treatment arm in the pending treatment arms table. 


Scenario Outline: A treatment arm with any of the top level fields missing should fail validation
Given I retrieve the template for treatment arm
And I remove the field "<field>" from the template
When I issue a post request with the treatment arm 
Then I should receive a failed response of "<error_code>"
And I should see the reason of rejection as "<reason>"
Examples:
| field 								| reason | error_code |
| treatment_arm_id 			| fail | 500 | 
| name 									| fail | 500 | 
| date_created 					| fail | 500 | 
| version 							| fail | 500 | 
| stratum_id 						| fail | 500 | 
| description 					| fail | 500 | 
| target_id 						| fail | 500 | 
| target_name 					| fail | 500 | 
| gene 									| fail | 500 | 
| treatment_arm_status 	| fail | 500 | 
| study_id 							| fail | 500 | 
| assay_rules 					| fail | 500 | 
| num_patients_assigned | fail | 500 | 
| date_opened 					| fail | 500 | 
| status_log 						| fail | 500 | 
| treatment_arm_drugs 	| fail | 500 | 
| snv_indels 						| fail | 500 | 
| non_hotspot_rules 		| fail | 500 | 
| copy_number_variants 	| fail | 500 | 
| gene_fusions 					| fail | 500 | 
| diseases 							| fail | 500 | 
| exclusion_drugs				| fail | 500 | 
