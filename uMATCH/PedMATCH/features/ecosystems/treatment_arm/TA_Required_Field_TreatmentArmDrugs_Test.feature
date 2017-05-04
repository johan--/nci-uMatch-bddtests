#encoding: utf-8

@treatment_arm
Feature: TA_DG. Treatment Arm API Tests that focus on "treatment_arm_drugs" and "exclusion_drugs" field

  @treatment_arm_p2
  Scenario: TA_DG1. New Treatment Arm with empty "treatment_arm_drugs" field should fail
    Given template treatment arm json with a random id
    And clear list field: "treatment_arm_drugs" from template treatment arm json
    When creating a new treatment arm using post request
#    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"
    Then a failure message is returned which contains: "The property '#/treatment_arm_drugs' did not contain a minimum number of items 1"

  @treatment_arm_p2
  Scenario: TA_DG2. New Treatment Arm with "treatment_arm_drugs": null should fail
    Given template treatment arm json with a random id
    And set template treatment arm json field: "treatment_arm_drugs" to string value: "null"
    When creating a new treatment arm using post request
    Then a failure message is returned which contains: "The property '#/treatment_arm_drugs' of type NilClass did not match the following type: array"

  @treatment_arm_p2
  Scenario: TA_DG3. New Treatment Arm without "treatment_arm_drugs" field should fail
    Given template treatment arm json with a random id
    And remove field: "treatment_arm_drugs" from template treatment arm json
    When creating a new treatment arm using post request
    Then a failure message is returned which contains: "The property '#/' did not contain a required property of 'treatment_arm_drugs'"

  @treatment_arm_p2
  Scenario: TA_DG4. New Treatment Arm with duplicated drug entities should fail
    Given template treatment arm json with an id: "APEC1621-DG4-1"
    And clear list field: "treatment_arm_drugs" from template treatment arm json
    And add drug with name: "AZD9291" pathway: "EGFR" and id: "781254" to template treatment arm json
    And add drug with name: "AZD9291" pathway: "EGFR" and id: "781254" to template treatment arm json
    When creating a new treatment arm using post request
    Then a failure response code of "412" is returned

  @treatment_arm_p2
  Scenario: TA_DG5. New Treatment Arm with same drug in both "treatment_arm_drugs" and "exclusion_drugs" field should pass
    Given template treatment arm json with a random id
    And clear list field: "treatment_arm_drugs" from template treatment arm json
    And clear list field: "exclusion_drugs" from template treatment arm json
    And add drug with name: "AZD9291" pathway: "EGFR" and id: "781254" to template treatment arm json
    And add PedMATCH exclusion drug with name: "AZD9291" and id: "781254" to template treatment arm json
    When creating a new treatment arm using post request
    Then a success message is returned

  @treatment_arm_p2
  Scenario Outline: TA_DG6a. New Treatment Arm with incomplete drug name should fail
    Given template treatment arm json with a random id
    And clear list field: "treatment_arm_drugs" from template treatment arm json
    And add drug with name: "<drugName>" pathway: "<drugPathway>" and id: "<drugId>" to template treatment arm json
    When creating a new treatment arm using post request
    Then a failure message is returned which contains: "<validation_message>"
    Examples:
      | drugName | drugPathway | drugId | validation_message         |
      | null     | EGFR        | 781254 | name' of type NilClass     |
      |          | EGFR        | 781254 | minimum string length of 1 |

  Scenario Outline: TA_DG6b. New Treatment Arm with incomplete drug id should pass
    Given template treatment arm json with a random id
    And clear list field: "treatment_arm_drugs" from template treatment arm json
    And add drug with name: "<drugName>" pathway: "<drugPathway>" and id: "<drugId>" to template treatment arm json
    When creating a new treatment arm using post request
    Then a success message is returned
    Examples:
      | drugName | drugPathway | drugId |
      | AZD9291  | EGFR        | null   |
      | AZD9291  | EGFR        |        |

  @treatment_arm_p2
  Scenario Outline: TA_DG7 New Treatment Arm with null or empty drug pathway should pass
    Given template treatment arm json with a random id
    And clear list field: "treatment_arm_drugs" from template treatment arm json
    And add drug with name: "AZD9291" pathway: "<drug_pathway>" and id: "781254" to template treatment arm json
    When creating a new treatment arm using post request
    Then a success message is returned
    Examples:
      | drug_pathway |
      | null         |
      |              |

  @treatment_arm_p3
  Scenario Outline: TA_DG8 Validate the treatment_arm json message received for new treatment arm request
    Given that a new treatment arm is received from COG with version: "<version>" study_id: "<study_id>" id: "<id>" name: "<name>" description: "<description>" target_id: "<target_id>" target_name: "<target_name>" gene: "<gene>" and with one drug: "<drug>" and with tastatus: "<tastatus>" and with stratum_id "<stratum_id>"
    And with variant report
	"""
    {
    "snv_indels" : [
      {
        "variant_type": "snp",
        "gene" : "ALK",
        "identifier" : "COSM1686998",
        "protein" : "p.L858",
        "level_of_evidence" : 2.0,
        "chromosome" : "1",
        "position" : "11184573",
        "ocp_reference" : "G",
        "ocp_alternative" : "A",
        "public_med_ids" : [
                  "23724913"
        ],
        "inclusion" : true,
        "arm_specific" : false
      }
    ],
    "copy_number_variants" : [],
    "gene_fusions" : [],
    "non_hotspot_rules" : []
	}
	"""
    When creating a new treatment arm using post request
    Then a failure message is returned which contains: "<message>"
    Examples:
      | version    | study_id | id       | name     | description        | target_id | target_name  | gene | drug                                  | Status  | message                                                                                               | timestamp                   | tastatus | stratum_id |
      | 2016-05-27 | APEC1621 | TA_test5 | Afatinib | covalent inhibitor | 1234      | EGFR Pathway | ALK  | 1,,Afatinib,angiokinase inhibitor     | FAILURE | The property '#/treatment_arm_drugs/0/name' was not of a minimum string length of 1                   | 2014-06-29 11:34:20.179 GMT | OPEN     | 1          |
      | 2016-05-27 | APEC1621 | TA_test6 | Afatinib | covalent inhibitor | 1234      | EGFR Pathway | ALK  | 1,null,Afatinib,angiokinase inhibitor | FAILURE | The property '#/treatment_arm_drugs/0/name' of type NilClass did not match the following type: string | 2014-06-29 11:34:20.179 GMT | OPEN     | 1          |
