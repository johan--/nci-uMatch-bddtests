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
| field 								| reason | error_code |
| treatment_arm_id 			|
| name 									|
| date_created 					|
| version 							|
| stratum_id 						|
| description 					|
| target_id 						|
| target_name 					|
| gene 									|
| treatment_arm_status 	|
| study_id 							|
| assay_rules 					|
| num_patients_assigned |
| date_opened 					|
| status_log 						|
| treatment_arm_drugs 	|
| snv_indels 						|
| non_hotspot_rules 		|
| copy_number_variants 	|
| gene_fusions 					|
| diseases 							|
| exclusion_drugs				|