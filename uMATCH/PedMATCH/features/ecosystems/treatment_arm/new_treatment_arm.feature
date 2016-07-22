#encoding: utf-8
@treatment_arm
Feature: MATCH-1: New Treatment Arm Message
  Receive new treatment arm from COG in JSON format
  Consume the message within MATCH.
Note: start treatment-arm-processor RAILS_ENV=test bundle exec shoryuken -R
      start treatment-arm-api RAILS_ENV=test rails s

  Scenario Outline: 1.1 Consume new treatment arm. Ensure the validity of the message received from EA layer
    Given that a new treatment arm is received from COG with version: "<version>" study_id: "<study_id>" id: "<id>" name: "<name>" description: "<description>" targetId: "<targetId>" targetName: "<targetName>" gene: "<gene>" and with one drug: "<drug>" and with tastatus: "<tastatus>"
    And with variant report
	"""
    {
    "singleNucleotideVariants" : [
        {
            "type":"snv",
            "publicMedIds" : [
                "23724913"
            ],
            "gene" : "ALK",
            "chromosome" : "1",
            "position" : "11184573",
            "identifier" : "COSM1686998",
            "reference" : "G",
            "alternative" : "A",
            "description" : "some description",
            "readDepth" : "0",
            "rare" : false,
            "alleleFrequency" : 0,
            "levelOfEvidence" : 2,
            "inclusion" : true
        }
    ],
    "indels" : [],
    "copyNumberVariants" : [],
    "geneFusions" : [],
    "nonHotspotRules" : []
	}
	"""
    When posted to MATCH newTreatmentArm
    Then a message with Status "<Status>" and message "<message>" is returned:
    Examples:
      |version    |study_id   |id			|name				|description	            |targetId	|targetName		|gene			|drug												|Status			|message									|timestamp						|tastatus	|
      |2016-05-27 |APEC1621   |TA_test1		|Afatinib			|covalent inhibitor 		|1234		|EGFR Pathway	|ALK			|1,Afatinib,Afatinib,angiokinase inhibitor			|SUCCESS		|Saved to datastore.						|2014-06-29 11:34:20.179 GMT	|OPEN	|
      |2016-05-27 |APEC1621   |TA_test2		|Afatinib			|covalent inhibitor         |1234		|EGFR Pathway	|ALK			|1,Afatinib,Afatinib,angiokinase inhibitor;2,tylenol,tylenol,angiokinase inhibitor	|SUCCESS|Saved to datastore.|2014-06-29 11:34:20.179 GMT	|OPEN	|
      |2016-05-27 |APEC1621   |				|Afatinib			|covalent inhibitor 		|1234		|EGFR Pathway	|ALK			|1,Afatinib,Afatinib,angiokinase inhibitor			|FAILURE		|id may not be empty						|2014-06-29 11:34:20.179 GMT	|OPEN	|
      |2016-05-27 |APEC1621   |null			|Afatinib			|covalent inhibitor 		|1234		|EGFR Pathway	|ALK			|1,Afatinib,Afatinib,angiokinase inhibitor			|FAILURE		|id may not be empty  						|2014-06-29 11:34:20.179 GMT	|OPEN	|
      |2016-05-27 |APEC1621   |TA_test3		|					|                    		|1234		|EGFR Pathway	|ALK			|1,Afatinib,Afatinib,angiokinase inhibitor			|FAILURE		|name may not be empty						|2014-06-29 11:34:20.179 GMT	|OPEN	|
      |2016-05-27 |APEC1621   |TA_test4		|null				|null                		|1234		|EGFR Pathway	|ALK			|1,Afatinib,Afatinib,angiokinase inhibitor			|FAILURE		|name may not be empty					 	|2014-06-29 11:34:20.179 GMT	|OPEN	|
      |2016-05-27 |APEC1621   |TA_test5		|Afatinib			|covalent inhibitor 		|1234		|EGFR Pathway	|ALK			|1,,Afatinib,angiokinase inhibitor					|FAILURE		|treatmentArmDrugs[0].name may not be empty	|2014-06-29 11:34:20.179 GMT	|OPEN	|
      |2016-05-27 |APEC1621   |TA_test6		|Afatinib			|covalent inhibitor 		|1234		|EGFR Pathway	|ALK			|1,null,Afatinib,angiokinase inhibitor				|FAILURE		|treatmentArmDrugs[0].name may not be empty |2014-06-29 11:34:20.179 GMT	|OPEN	|


  Scenario: 1.2 Return a failure message when a treatment arm update is received with a version number and stratum_id same as the one that already exists in MATCH
    Given that treatment arm is received from COG:
	"""
	{"study_id":"APEC1621",
	"id":"TA_test1",
	"stratum_id":"1",
	"version":"2016-05-27",
	"gene":"ALK",
	"description":"covalent inhibitor",
	"name":"Afatinib",
	"targetId":1234,
	"targetName":"EGFR Pathway",
	"treatmentArmDrugs":[{"drugClass":"angiokinase inhibitor","description":"Afatinib","name":"Afatinib","drugId":"1"}],
	"variantReport":{"geneFusions":[],"nonHotspotRules":[],"singleNucleotideVariants":[{"position":"11184573","gene":"ALK","levelOfEvidence":2,"alternative":"A","type":"snv","chromosome":"1","inclusion":true,"reference":"G","alleleFrequency":0,"rare":false,"description":"some description","readDepth":"0","publicMedIds":["23724913"],"identifier":"COSM1686998"}],"indels":[],"copyNumberVariants":[]}}
	"""

    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "The treatment arm (ID:TA_test1) already exists."

  Scenario: 1.3 Receive and consume an update to an existing treatment arm with a different and newer version
	Given that treatment arm is received from COG:
	"""
	{"study_id":"APEC1621",
	"id":"TA_test1",
	"stratum_id":"1",
	"version":"2016-05-28",
	"gene":"ALK",
	"description":"Afatinib",
	"name":"Afatinib",
	"targetId":1234,
	"targetName":"HGFR Pathway",
	"treatmentArmDrugs":[{"drugClass":"angiokinase inhibitor","description":"Afatinib","name":"Afatinib","drugId":"1"}],
	"variantReport":{"geneFusions":[],"nonHotspotRules":[],"singleNucleotideVariants":[{"position":"11184573","gene":"ALK","levelOfEvidence":2,"alternative":"A","type":"snv","chromosome":"1","inclusion":true,"reference":"G","alleleFrequency":0,"rare":false,"description":"some description","readDepth":"0","publicMedIds":["23724913"],"identifier":"COSM1686998"}],"indels":[],"copyNumberVariants":[]}}
	"""
	When posted to MATCH newTreatmentArm
	Then a message with Status "SUCCESS" and message "Save to datastore." is returned:

  Scenario: 1.4 Return a failure message when a treatment arm update is received with a version number older than the version of the currently active treatment arm
	Given that treatment arm is received from COG:
	"""
	{"study_id":"APEC1621",
	"id":"TA_test1",
	"stratum_id":"1",
	"version":"2015-05-28",
	"gene":"ALK",
	"description":"Afatinib",
	"name":"Afatinib",
	"targetId":1234,
	"targetName":"HGFR Pathway",
	"treatmentArmDrugs":[{"drugClass":"angiokinase inhibitor","description":"Afatinib","name":"Afatinib","drugId":"1"}],
	"variantReport":{"geneFusions":[],"nonHotspotRules":[],"singleNucleotideVariants":[{"position":"11184573","gene":"ALK","levelOfEvidence":2,"alternative":"A","type":"snv","chromosome":"1","inclusion":true,"reference":"G","alleleFrequency":0,"rare":false,"description":"some description","readDepth":"0","publicMedIds":["23724913"],"identifier":"COSM1686998"}],"indels":[],"copyNumberVariants":[]}}
	"""
	When posted to MATCH newTreatmentArm
	Then a message with Status "FAILURE" and message "Version cannot be older thn current version" is returned:

  Scenario: 1.5 Return failure message when treatment arm version is missing or empty
	Given that treatment arm is received from COG:
	"""
	{"study_id":"APEC1621",
	"id":"NoVersion",
	"stratum_id":"1",
	"gene":"ALK",
	"description":"Afatinib",
	"name":"Afatinib",
	"targetId":1234,
	"targetName":"HGFR Pathway",
	"treatmentArmDrugs":[{"drugClass":"angiokinase inhibitor","description":"Afatinib","name":"Afatinib","drugId":"1"}],
	"variantReport":{"geneFusions":[],"nonHotspotRules":[],"singleNucleotideVariants":[{"position":"11184573","gene":"ALK","levelOfEvidence":2,"alternative":"A","type":"snv","chromosome":"1","inclusion":true,"reference":"G","alleleFrequency":0,"rare":false,"description":"some description","readDepth":"0","publicMedIds":["23724913"],"identifier":"COSM1686998"}],"indels":[],"copyNumberVariants":[]}}
	"""
	When posted to MATCH newTreatmentArm
	Then a failure message is returned which contains: "The property '#/' did not contain a required property of 'version'"



  Scenario: 1.6 Verify that a treatment arm when created is assigned a status of OPEN
    Given that treatment arm is received from COG:
	"""
		{"study_id":"APEC1621",
	    "id" : "TA_test3",
	    "stratum_id":"1",
	    "name" : "ta_test3",
	    "targetId" : 1234,
	    "targetName" : "ALK",
	    "treatmentArmStatus" : "OPEN",
	    "version":"2016-05-25",
	    "gene" : "ALK",
	    "treatmentArmDrugs" : [
	        {
	            "drugId" : "1234",
	            "name" : "Curcumin",
	            "description" : "Treats stomach tumors"
	        }
	    ],
	    "exclusionDrugs" : [
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
	    "exclusionCriterias" : [],
	    "numPatientsAssigned" : 0,
	    "maxPatientsAllowed" : 35,
	    "variantReport" : {
	        "singleNucleotideVariants" : [
	            {
	                "type":"snv",
	                "publicMedIds" : [
	                    "23724913"
	                ],
	                "gene" : "ALK",
	                "chromosome" : "1",
	                "position" : "11184573",
	                "identifier" : "ta_test3",
	                "reference" : "G",
	                "alternative" : "A",
	                "description" : "some description",
	                "readDepth" : "0",
	                "rare" : false,
	                "alleleFrequency" : 0,
	                "levelOfEvidence" : 2,
	                "inclusion" : true
	            }
	        ],
	        "indels" : [],
	        "copyNumberVariants" : [],
	        "geneFusions" : [],
	        "nonHotspotRules" : []
	    }
	}
	"""
    When posted to MATCH newTreatmentArm
    Then a message with Status "SUCCESS" and message "Saved to datastore." is returned:
    Then the treatmentArmStatus field has a value "OPEN" for the ta "TA_test3"


