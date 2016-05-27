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
      |2016-05-27 |APEC1621   |TA_test1		|Afatinib			|covalent inhibitor 		|1234		|EGFR Pathway	|ALK			|1,Afatinib,Afatinib,angiokinase inhibitor			|SUCCESS		|Saved to datastore.						|2014-06-29 11:34:20.179 GMT	|PENDING	|
      |2016-05-27 |APEC1621   |TA_test2		|Afatinib			|covalent inhibitor         |1234		|EGFR Pathway	|ALK			|1,Afatinib,Afatinib,angiokinase inhibitor;2,tylenol,tylenol,angiokinase inhibitor	|SUCCESS|Saved to datastore.|2014-06-29 11:34:20.179 GMT	|PENDING	|
      |2016-05-27 |APEC1621   |				|Afatinib			|covalent inhibitor 		|1234		|EGFR Pathway	|ALK			|1,Afatinib,Afatinib,angiokinase inhibitor			|FAILURE		|id may not be empty						|2014-06-29 11:34:20.179 GMT	|PENDING	|
      |2016-05-27 |APEC1621   |null			|Afatinib			|covalent inhibitor 		|1234		|EGFR Pathway	|ALK			|1,Afatinib,Afatinib,angiokinase inhibitor			|FAILURE		|id may not be empty  						|2014-06-29 11:34:20.179 GMT	|PENDING	|
      |2016-05-27 |APEC1621   |TA_test3		|					|                    		|1234		|EGFR Pathway	|ALK			|1,Afatinib,Afatinib,angiokinase inhibitor			|FAILURE		|name may not be empty						|2014-06-29 11:34:20.179 GMT	|PENDING	|
      |2016-05-27 |APEC1621   |TA_test4		|null				|null                		|1234		|EGFR Pathway	|ALK			|1,Afatinib,Afatinib,angiokinase inhibitor			|FAILURE		|name may not be empty					 	|2014-06-29 11:34:20.179 GMT	|PENDING	|
      |2016-05-27 |APEC1621   |TA_test5		|Afatinib			|covalent inhibitor 		|1234		|EGFR Pathway	|ALK			|1,,Afatinib,angiokinase inhibitor					|FAILURE		|treatmentArmDrugs[0].name may not be empty	|2014-06-29 11:34:20.179 GMT	|PENDING	|
      |2016-05-27 |APEC1621   |TA_test6		|Afatinib			|covalent inhibitor 		|1234		|EGFR Pathway	|ALK			|1,null,Afatinib,angiokinase inhibitor				|FAILURE		|treatmentArmDrugs[0].name may not be empty |2014-06-29 11:34:20.179 GMT	|PENDING	|
      |2016-05-27 |APEC1621   |TA_test7		|Afatinib			|covalent inhibitor 		|1234		|EGFR Pathway	|ALK			|1,Afatinib,Afatinib,angiokinase inhibitor			|SUCCESS		|Saved to datastore.						|2014-06-29 11:34:20.179 GMT	|PENDING	|
      |2016-05-27 |APEC1621   |TA_test8		|Afatinib			|covalent inhibitor 		|1234		|EGFR Pathway	|ALK			|1,Afatinib,Afatinib,angiokinase inhibitor			|SUCCESS		|Saved to datastore.						|2014-06-29 11:34:20.179 GMT	|PENDING	|
      |2016-05-27 |APEC1621   |TA_test9		|Afatinib			|covalent inhibitor 		|1234		|EGFR Pathway	|ALK			|1,Afatinib,Afatinib,angiokinase inhibitor			|SUCCESS		|Saved to datastore.						|2014-06-29 11:34:20.179 GMT	|PENDING	|
      |2016-05-27 |APEC1621   |TA_test10		|Afatinib			|covalent inhibitor 		|1234		|EGFR Pathway	|ALK			|1,Afatinib,Afatinib,angiokinase inhibitor			|SUCCESS		|Saved to datastore.						|2014-06-29 11:34:20.179 GMT	|PENDING	|
      |2016-05-27 |APEC1621   |TA_test11		|Afatinib			|covalent inhibitor 		|1234		|EGFR Pathway	|ALK			|1,Afatinib,Afatinib,angiokinase inhibitor			|SUCCESS		|Saved to datastore.						|2014-06-29 11:34:20.179 GMT	|PENDING	|
      |2016-05-27 |APEC1621   |TA_test12		|Afatinib			|covalent inhibitor 		|1234		|EGFR Pathway	|ALK			|1,Afatinib,Afatinib,angiokinase inhibitor			|SUCCESS		|Saved to datastore.						|2014-06-29 11:34:20.179 GMT	|PENDING	|
      |2016-05-27 |APEC1621   |TA_test13		|Afatinib			|covalent inhibitor 		|1234		|EGFR Pathway	|ALK			|1,Afatinib,Afatinib,angiokinase inhibitor			|SUCCESS		|Saved to datastore.						|2014-06-29 11:34:20.179 GMT	|PENDING	|
      |2016-05-27 |APEC1621   |TA_test14		|Afatinib			|covalent inhibitor 		|1234		|EGFR Pathway	|ALK			|1,Afatinib,Afatinib,angiokinase inhibitor			|SUCCESS		|Saved to datastore.						|2014-06-29 11:34:20.179 GMT	|PENDING	|
      |2016-05-27 |APEC1621   |TA_test15		|Afatinib			|covalent inhibitor 		|1234		|EGFR Pathway	|ALK			|1,Afatinib,Afatinib,angiokinase inhibitor			|SUCCESS		|Saved to datastore.						|2014-06-29 11:34:20.179 GMT	|PENDING	|
      |2016-05-27 |APEC1621   |TA_test16		|Afatinib			|covalent inhibitor 		|1234		|EGFR Pathway	|ALK			|1,Afatinib,Afatinib,angiokinase inhibitor			|SUCCESS		|Saved to datastore.						|2014-06-29 11:34:20.179 GMT	|PENDING	|
      |2016-05-27 |APEC1621   |TA_test17		|Afatinib			|covalent inhibitor 		|1234		|EGFR Pathway	|ALK			|1,Afatinib,Afatinib,angiokinase inhibitor			|SUCCESS		|Saved to datastore.						|2014-06-29 11:34:20.179 GMT	|PENDING	|
      |2016-05-27 |APEC1621   |TA_test18		|Afatinib			|covalent inhibitor 		|1234		|EGFR Pathway	|ALK			|1,Afatinib,Afatinib,angiokinase inhibitor			|SUCCESS		|Saved to datastore.						|2014-06-29 11:34:20.179 GMT	|PENDING	|
      |2016-05-27 |APEC1621   |TA_test19		|Afatinib			|covalent inhibitor 		|1234		|EGFR Pathway	|ALK			|1,Afatinib,Afatinib,angiokinase inhibitor			|SUCCESS		|Saved to datastore.						|2014-06-29 11:34:20.179 GMT	|PENDING	|
      |2016-05-27 |APEC1621   |TA_test20		|Afatinib			|covalent inhibitor 		|1234		|EGFR Pathway	|ALK			|1,Afatinib,Afatinib,angiokinase inhibitor			|SUCCESS		|Saved to datastore.						|2014-06-29 11:34:20.179 GMT	|PENDING	|
      |2016-05-27 |APEC1621   |TA_test21		|Afatinib			|covalent inhibitor 		|1234		|EGFR Pathway	|ALK			|1,Afatinib,Afatinib,angiokinase inhibitor			|SUCCESS		|Saved to datastore.						|2014-06-29 11:34:20.179 GMT	|PENDING	|
      |2016-05-27 |APEC1621   |TA_test227		|Afatinib			|covalent inhibitor 		|1234		|EGFR Pathway	|ALK			|1,Afatinib,Afatinib,angiokinase inhibitor			|SUCCESS		|Saved to datastore.						|2014-06-29 11:34:20.179 GMT	|PENDING	|


  Scenario: 1.2 Return failure message when treatment arm already exists in MATCH
    Given that treatment arm is received from COG:
	"""
	{"study_id":"APEC1621",
	"id":"TA_test1",
	"version":"2015-08-26",
	"gene":"ALK",
	"description":"Afatinib",
	"name":"Afatinib",
	"targetId":"1234",
	"targetName":"HGFR Pathway",
	"treatmentArmDrugs":[{"drugClass":"angiokinase inhibitor","description":"Afatinib","name":"Afatinib","drugId":"1"}],
	"variantReport":{"geneFusions":[],"nonHotspotRules":[],"singleNucleotideVariants":[{"position":"11184573","gene":"ALK","levelOfEvidence":2,"alternative":"A","type":"snv","chromosome":"1","inclusion":true,"reference":"G","alleleFrequency":0,"rare":false,"description":"some description","readDepth":"0","publicMedIds":["23724913"],"identifier":"COSM1686998"}],"indels":[],"copyNumberVariants":[]}}
	"""

    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains:
	"""
	The treatment arm (ID:TA_test1) already exists.
	"""

  Scenario: 1.3 Receive and consume an update to an existing treatment arm with a different and newer version
	Given that treatment arm is received from COG:
	"""
	{"study_id":"APEC1621",
	"id":"TA_test1",
	"version":"2016-05-18",
	"gene":"ALK",
	"description":"Afatinib",
	"name":"Afatinib",
	"targetId":"1234",
	"targetName":"HGFR Pathway",
	"treatmentArmDrugs":[{"drugClass":"angiokinase inhibitor","description":"Afatinib","name":"Afatinib","drugId":"1"}],
	"variantReport":{"geneFusions":[],"nonHotspotRules":[],"singleNucleotideVariants":[{"position":"11184573","gene":"ALK","levelOfEvidence":2,"alternative":"A","type":"snv","chromosome":"1","inclusion":true,"reference":"G","alleleFrequency":0,"rare":false,"description":"some description","readDepth":"0","publicMedIds":["23724913"],"identifier":"COSM1686998"}],"indels":[],"copyNumberVariants":[]}}
	"""
	When posted to MATCH newTreatmentArm
	Then a message with Status "SUCCESS" and message "Save to datastore." is returned:

  Scenario: 1.4 Return failure message when treatment arm version is missing or empty
	Given that treatment arm is received from COG:
	"""
	{"study_id":"APEC1621",
	"id":"NoVersion",
	"gene":"ALK",
	"description":"Afatinib",
	"name":"Afatinib",
	"targetId":"1234",
	"targetName":"HGFR Pathway",
	"treatmentArmDrugs":[{"drugClass":"angiokinase inhibitor","description":"Afatinib","name":"Afatinib","drugId":"1"}],
	"variantReport":{"geneFusions":[],"nonHotspotRules":[],"singleNucleotideVariants":[{"position":"11184573","gene":"ALK","levelOfEvidence":2,"alternative":"A","type":"snv","chromosome":"1","inclusion":true,"reference":"G","alleleFrequency":0,"rare":false,"description":"some description","readDepth":"0","publicMedIds":["23724913"],"identifier":"COSM1686998"}],"indels":[],"copyNumberVariants":[]}}
	"""
	When posted to MATCH newTreatmentArm
	Then a failure message is returned which contains:
	"""
	The treatment arm (ID:NoVersion) is missing version information.
	"""


#  Scenario: 1.3 Verify that MATCH returns a failure message when a treatment arm is created with a status of OPEN
#    Given that treatment arm is received from EA layer with already existing id:
#	"""
#		{
#	    "id" : "4",
#	    "name" : "ta_test4",
#	    "version":"2015-08-26",
#	    "targetId" : "1234",
#	    "targetName" : "ALK",
#	    "gene" : "ALK",
#	    "treatmentArmDrugs" : [
#	        {
#	            "drugId" : "1234",
#	            "name" : "Curcumin",
#	            "description" : "Treats stomach tumors"
#	        }
#	    ],
#	    "exclusionDrugs" : [
#	        {
#	            "drugs" : [
#	                {
#	                    "drugId" : "0",
#	                    "name" : "Crizotinib"
#	                }
#	            ]
#	        },
#	        {
#	            "drugs" : [
#	                {
#	                    "drugId" : "0",
#	                    "name" : "Ceritinib"
#	                }
#	            ]
#	        },
#	        {
#	            "drugs" : [
#	                {
#	                    "drugId" : "0",
#	                    "name" : "Alectinib"
#	                }
#	            ]
#	        },
#	        {
#	            "drugs" : [
#	                {
#	                    "drugId" : "0",
#	                    "name" : "AP26113"
#	                }
#	            ]
#	        },
#	        {
#	            "drugs" : [
#	                {
#	                    "drugId" : "0",
#	                    "name" : "TSR-011"
#	                }
#	            ]
#	        },
#	        {
#	            "drugs" : [
#	                {
#	                    "drugId" : "0",
#	                    "name" : "PF-06463922"
#	                }
#	            ]
#	        },
#	        {
#	            "drugs" : [
#	                {
#	                    "drugId" : "0",
#	                    "name" : "X-396"
#	                }
#	            ]
#	        },
#	        {
#	            "drugs" : [
#	                {
#	                    "drugId" : "0",
#	                    "name" : "RXDX-101"
#	                }
#	            ]
#	        },
#	        {
#	            "drugs" : [
#	                {
#	                    "drugId" : "0",
#	                    "name" : "CEP-37440"
#	                }
#	            ]
#	        }
#	    ],
#	    "exclusionCriterias" : [],
#	    "numPatientsAssigned" : 0,
#	    "maxPatientsAllowed" : 35,
#		"treatmentArmStatus":"OPEN"
#
#	}
#	"""
#    When posted to MATCH newTreatmentArm
#    Then a message with Status "FAILURE" and message "The treatment arm (ID:4) status OPEN is invalid." is returned:


  Scenario: 1.5 Verify that a treatment arm when created is assigned a status of OPEN
    Given that treatment arm is received from COG:
	"""
		{"study_id":"APEC1621",
	    "id" : "TA_test3",
	    "name" : "ta_test3",
	    "targetId" : "1234",
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
	            "drugs" : [
	                {
	                    "drugId" : "0",
	                    "name" : "Crizotinib"
	                }
	            ]
	        },
	        {
	            "drugs" : [
	                {
	                    "drugId" : "0",
	                    "name" : "Ceritinib"
	                }
	            ]
	        },
	        {
	            "drugs" : [
	                {
	                    "drugId" : "0",
	                    "name" : "Alectinib"
	                }
	            ]
	        },
	        {
	            "drugs" : [
	                {
	                    "drugId" : "0",
	                    "name" : "AP26113"
	                }
	            ]
	        },
	        {
	            "drugs" : [
	                {
	                    "drugId" : "0",
	                    "name" : "TSR-011"
	                }
	            ]
	        },
	        {
	            "drugs" : [
	                {
	                    "drugId" : "0",
	                    "name" : "PF-06463922"
	                }
	            ]
	        },
	        {
	            "drugs" : [
	                {
	                    "drugId" : "0",
	                    "name" : "X-396"
	                }
	            ]
	        },
	        {
	            "drugs" : [
	                {
	                    "drugId" : "0",
	                    "name" : "RXDX-101"
	                }
	            ]
	        },
	        {
	            "drugs" : [
	                {
	                    "drugId" : "0",
	                    "name" : "CEP-37440"
	                }
	            ]
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


#  Scenario: 1.5 & 1.6 Verify that a treatment arm cannot be approved when there are no associated variants or non-hotspot rules
#    Given the treatmentArmStatus field has a value "PENDING" for the ta "CukeTest-PEN-NoVar"
#    When the treatmentArm "CukeTest-PEN-NoVar" is posted to the MATCH approveTreatmentArm service
#    Then a failure message is returned which contains:
#  """
#	This treatment arm is not eligible for approval.
#  """
#    And the treatmentArmStatus field has a value "PENDING" for the ta "CukeTest-PEN-NoVar"




#  Scenario: 1.8 Verify that a treatment arm that has inclusion variants and in PENDING status can be approved
#    Given the treatmentArmStatus field has a value "PENDING" for the ta "3"
#    When the treatmentArm "3" is posted to the MATCH approveTreatmentArm service
#    Then a SUCCESS message is returned which contains:
#	"""
#	Treatment arm has been approved to be opened to patient enrollment.
#	"""
#    Then the treatmentArmStatus field has a value "READY" for the ta "3"

#  Scenario: 1.9 Verify error message returned when ECOG TA approval processing results in a failure.
#    Given that treatment arm is received from EA layer with already existing id:
#	"""
#		{
#	    "id" : "EAY131_5",
#	    "name" : "CukeTestEAY131_5",
#	    "version":"2015-08-26",
#	    "targetId" : "1234",
#	    "targetName" : "ALK",
#	    "gene" : "ALK",
#	    "treatmentArmDrugs" : [
#	        {
#	            "drugId" : "1234",
#	            "name" : "Curcumin",
#	            "description" : "Treats stomach tumors"
#	        }
#	    ],
#	    "exclusionDrugs" : [
#	        {
#	            "drugs" : [
#	                {
#	                    "drugId" : "0",
#	                    "name" : "Crizotinib"
#	                }
#	            ]
#	        },
#	        {
#	            "drugs" : [
#	                {
#	                    "drugId" : "0",
#	                    "name" : "Ceritinib"
#	                }
#	            ]
#	        },
#	        {
#	            "drugs" : [
#	                {
#	                    "drugId" : "0",
#	                    "name" : "Alectinib"
#	                }
#	            ]
#	        },
#	        {
#	            "drugs" : [
#	                {
#	                    "drugId" : "0",
#	                    "name" : "AP26113"
#	                }
#	            ]
#	        },
#	        {
#	            "drugs" : [
#	                {
#	                    "drugId" : "0",
#	                    "name" : "TSR-011"
#	                }
#	            ]
#	        },
#	        {
#	            "drugs" : [
#	                {
#	                    "drugId" : "0",
#	                    "name" : "PF-06463922"
#	                }
#	            ]
#	        },
#	        {
#	            "drugs" : [
#	                {
#	                    "drugId" : "0",
#	                    "name" : "X-396"
#	                }
#	            ]
#	        },
#	        {
#	            "drugs" : [
#	                {
#	                    "drugId" : "0",
#	                    "name" : "RXDX-101"
#	                }
#	            ]
#	        },
#	        {
#	            "drugs" : [
#	                {
#	                    "drugId" : "0",
#	                    "name" : "CEP-37440"
#	                }
#	            ]
#	        }
#	    ],
#	    "exclusionCriterias" : [],
#	    "numPatientsAssigned" : 0,
#	    "maxPatientsAllowed" : 35,
#	    "variantReport" : {
#	        "singleNucleotideVariants" : [
#	            {
#	                "type":"snv",
#	                "publicMedIds" : [
#	                    "23724913"
#	                ],
#	                "gene" : "ALK",
#	                "chromosome" : "1",
#	                "position" : "11184573",
#	                "identifier" : "COSM1686998",
#	                "reference" : "G",
#	                "alternative" : "A",
#	                "description" : "some description",
#	                "readDepth" : "0",
#	                "rare" : false,
#	                "alleleFrequency" : 0,
#	                "levelOfEvidence" : 2,
#	                "inclusion" : true
#	            }
#	        ],
#	        "indels" : [],
#	        "copyNumberVariants" : [],
#	        "geneFusions" : [],
#	        "nonHotspotRules" : []
#	    }
#	}
#	"""
#    When posted to MATCH newTreatmentArm
#    Then a message with Status "SUCCESS" and message "Saved to datastore." is returned:
#    Then the treatmentArmStatus field has a value "PENDING" for the ta "EAY131_5"
#    When the treatmentArm "EAY131_5" is posted to the MATCH approveTreatmentArm service
#    Then a failure message is returned which contains:
#  	"""
#		An error occurred sending approval of this treatment arm.
#	"""


#  Scenario: 1.10 Verify error message returned TA approval is requested for an invalid Treatment Arm ID.
#    When the treatmentArm "jdgjljhgfd" is posted to the MATCH approveTreatmentArm service
#    Then a failure message is returned which contains:
#	"""
#	This treatment arm id is invalid.
#	"""

