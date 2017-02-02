#encoding: utf-8

@treatment_arm
Feature: TA_CF. Treatment Arm API common tests for all fields

  @treatment_arm_p1
  Scenario: TA_CF1. Consume a New Treatment Arm
    Given template treatment arm json with an id: "APEC1621-HappyTest6"
    When creating a new treatment arm using post request
    Then a success message is returned

  @treatment_arm_p1
  Scenario: TA_CF2. Reposting the same treatment arm should fail
    Given template treatment arm json with an id: "APEC1621-DUP-1", stratum_id: "STRATUM1" and version: "2016-01-01"
    When creating a new treatment arm using post request
    Then a success message is returned
    Then wait for processor to complete request in "10" attempts
    When creating a new treatment arm using post request
    Then a failure response code of "400" is returned
    And a failure message is returned which contains: "already exists in the DataBase"
    Then wait for processor to complete request in "10" attempts
    When retrieve treatment arms with id: "APEC1621-DUP-1" and stratum_id: "STRATUM1" from API
    Then should return "1" of the records

  @treatment_arm_p1
  Scenario: TA_CF3. Update Treatment Arm with same "version" value should not be taken
    Given template treatment arm json with an id: "APEC1621-VS10-1", stratum_id: "stratum100" and version: "2016-06-03"
    And set template treatment arm json field: "gene" to value: "EGFR" in type: "string"
    When creating a new treatment arm using post request
    Then a success message is returned
    Then wait for processor to complete request in "10" attempts
    Then set template treatment arm json field: "gene" to value: "xxyyyy" in type: "string"
    When creating a new treatment arm using post request
    Then a failure response code of "400" is returned
    And a failure message is returned which contains: "already exists in the DataBase"
    Then retrieve the posted treatment arm from API
    Then the returned treatment arm has value: "EGFR" in field: "gene"

  @treatment_arm_p1
  Scenario: TA_CF4. Update a treatment arm with a newer version
    Given that treatment arm is received from COG:
	"""
	{"study_id":"APEC1621",
	"treatment_arm_id":"TA_CF4",
	"stratum_id":"1",
	"version":"2017-01-28",
	"gene":"ALK",
	"description":"Afatinib",
	"name":"Afatinib",
	"target_id":1234,
	"target_name":"HGFR Pathway",
    "date_created": "2017-01-28 15:57:25 UTC",
	"treatment_arm_drugs":[{"drugClass":"angiokinase inhibitor","description":"Afatinib","name":"Afatinib","drugId":"1"}],
	"gene_fusions":[],
	"non_hotspot_rules":[],
	"snv_indels":[
	  {
	  "variant_type": "snp",
	  "gene":"ALK",
	  "identifier":"COSM1686998",
	  "chromosome":"1.0",
	  "position":"11184573",
	  "level_of_evidence":2.0,
	  "ocp_reference":"G",
	  "ocp_alternative":"A",
	  "inclusion":true,
	  "public_med_ids":["23724913"],
	  "protein" : "p.L858R"
	  }
	],
	"copy_number_variants":[]
	}
	"""
    When creating a new treatment arm using post request
    Then a message with Status "SUCCESS" and message "Save to datastore." is returned:
    Then wait for processor to complete request in "10" attempts
    Then retrieve treatment arms with id: "TA_CF4" and stratum_id: "1" from API
    Then the first returned treatment arm has value: "TA_CF4" in field: "treatment_arm_id"
    Then the first returned treatment arm has value: "1" in field: "stratum_id"
    Then the first returned treatment arm has value: "2017-01-28" in field: "version"

  @invalid
  Scenario: TA_CF5. Return failure message when treatment arm version is missing or empty
    Given that treatment arm is received from COG:
	"""
	{"study_id":"APEC1621",
	"treatment_arm_id":"NoVersion",
	"stratum_id":"1",
	"gene":"ALK",
	"description":"Afatinib",
	"name":"Afatinib",
	"target_id":1234,
	"target_name":"HGFR Pathway",
	"treatment_arm_drugs":[{"drugClass":"angiokinase inhibitor","description":"Afatinib","name":"Afatinib","drugId":"1"}],
	"snv_indels":[
	  {
	  "variant_type": "snp",
	  "gene":"ALK",
	  "identifier":"COSM1686998",
	  "protein" : "p.L858R",
	  "level_of_evidence":2.0,
	  "chromosome":"1",
	  "position":"11184573",
	  "ocp_alternative":"A",
	  "ocp_reference":"G",
	  "inclusion":true,
	  "public_med_ids":["23724913"]
	  }],
	"copy_number_variants":[]
	}
	"""
    When creating a new treatment arm using post request
    Then a failure response code of "404" is returned

  @treatment_arm_p2
  Scenario: TA_CF6. Verify that a treatment arm when created is assigned a status of OPEN
    Given that treatment arm is received from COG:
	"""
		{
		"study_id":"APEC1621",
	    "treatment_arm_id" : "TA_test3",
	    "stratum_id":"1",
	    "name" : "ta_test3",
	    "target_id" : 1234,
	    "target_name" : "ALK",
	    "version":"2016-05-25",
	    "gene" : "ALK",
        "date_created": "2016-11-08 15:57:25 UTC",
	    "treatment_arm_drugs" : [
	        {
	            "drugId" : "1234",
	            "name" : "Curcumin",
	            "description" : "Treats stomach tumors"
	        }
	    ],
	    "exclusion_drugs" : [
				{
					"drugId" : "0",
					"name" : "Crizotinib"
				},
				{
					"drugId" : "0",
					"name" : "Ceritinib"
				},
				{
					"drugId" : "0",
					"name" : "Alectinib"
				},
				{
					"drugId" : "0",
					"name" : "AP26113"
				}
	    ],
        "snv_indels" : [
            {
                "variant_type": "snp",
                "public_med_ids" : [
                    "23724913"
                ],
                "gene" : "ALK",
                "chromosome" : "1",
                "position" : "11184573",
                "identifier" : "ta_test3",
                "ocp_reference" : "G",
                "ocp_alternative" : "A",
                "description" : "some description",
                "readDepth" : "0",
                "rare" : false,
                "alleleFrequency" : 0,
                "level_of_evidence" : 2,
                "inclusion" : true
            }
        ],
        "copy_number_variants" : [],
        "gene_fusions" : [],
        "non_hotspot_rules" : []
	}
	"""
    When creating a new treatment arm using post request
    Then a message with Status "SUCCESS" and message "Saved to datastore." is returned:
    Then the treatment_arm_status field has a value "OPEN" for the ta "TA_test3"

  @treatment_arm_p3
  Scenario Outline: TA_CF7. New Treatment Arm with unrequired field that has different kinds of value should pass
    Given template treatment arm json with an id: "<treatment_arm_id>"
    And set template treatment arm json field: "<field>" to string value: "<value>"
    When creating a new treatment arm using post request
    Then a success message is returned
    Then wait for processor to complete request in "10" attempts
    Then retrieve the posted treatment arm from API
    Then the returned treatment arm has value: "<returned_value>" in field: "<field>"
    Examples:
      | treatment_arm_id | field       | value   | returned_value |
      | APEC1621-CF1-1   | target_id   |         |                |
      | APEC1621-CF1-2   | gene        | null    |                |
      | APEC1621-CF1-3   | target_name | (&^$@HK | (&^$@HK        |

  @treatment_arm_p3
  Scenario Outline: TA_CF8. New Treatment Arm without unrequired field should set the value of this field to empty
    Given template treatment arm json with an id: "<treatment_arm_id>"
    And remove field: "<field>" from template treatment arm json
    When creating a new treatment arm using post request
    Then a success message is returned
    Then wait for processor to complete request in "10" attempts
    Then retrieve the posted treatment arm from API
    Then the returned treatment arm has value: "" in field: "<field>"
    Examples:
      | treatment_arm_id | field       |
      | APEC1621-CF2-1   | target_name |

  @treatment_arm_p3
  Scenario Outline: TA_CF9. New Treatment Arm with unrequired field which has improper data type values should fail
    Given template treatment arm json with a random id
    And set template treatment arm json field: "<field>" to value: "<value>" in type: "<type>"
    When creating a new treatment arm using post request
    Then a failure message is returned which contains: "<validation_message>"
    Examples:
      | field     | value | type | validation_message                                           |
      | gene      | 419   | int  | Fixnum did not match one or more of the required schemas     |
      | target_id | false | bool | FalseClass did not match one or more of the required schemas |

    #this is not required anymore, the date_created value now is provided by the spreadsheet
#  @treatment_arm_p2
#  Scenario: TA_CF10. "date_created" value is generated properly
#    Given template treatment arm json with an id: "APEC1621-CF6-1"
#    When creating a new treatment arm using post request
#    Then a success message is returned
#    Then wait for processor to complete request in "10" attempts
#    Then retrieve the posted treatment arm from API
#    Then the returned treatment arm has correct date_created value

  @treatment_arm_p3
  Scenario Outline: TA_CF11. Treatment arm return correct values for single fields
    Given template treatment arm json with an id: "<treatment_arm_id>"
    And set template treatment arm json field: "<field_name>" to value: "<fieldValue>" in type: "<dataType>"
    When creating a new treatment arm using post request
    Then a success message is returned
    Then wait for processor to complete request in "10" attempts
    Then retrieve the posted treatment arm from API
    Then the returned treatment arm has "<dataType>" value: "<fieldValue>" in field: "<field_name>"
    Examples:
      | treatment_arm_id | field_name  | fieldValue                               | dataType |
      | APEC1621-CF7-1   | description | This is a test that verify output values | string   |
      | APEC1621-CF7-2   | target_id   | 3453546232                               | string   |
      | APEC1621-CF7-3   | target_id   | Trametinib in GNAQ or GNA11 mutation     | string   |
      | APEC1621-CF7-4   | target_name | Trametinib                               | string   |
      | APEC1621-CF7-5   | gene        | GNA                                      | string   |
      | APEC1621-CF7-7   | study_id    | APEC1621                                 | string   |
      | APEC1621-CF7-8   | stratum_id  | kjg13gas                                 | string   |


  @treatment_arm_p2
  Scenario Outline: TA_CF12. Fields in the treatment arm response can be controlled by projections.
    Given retrieving all treatment arms based on "<projection>"
    Then each element should only have the keys listed in "<projection>"
    Examples:
      | projection                                |
      | treatment_arm_id,gene,treatment_arm_drugs |
      | treatment_arm_id,diseases,snv_indels      |


  @treatment_arm_p2
  Scenario: TA_CF13. If projected value does not exist then Array of empty objects are returned
    Given retrieving all treatment arms based on "apple"
    Then I should get an array of empty objects equal to the count of treatment arms
