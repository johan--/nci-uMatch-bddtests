#encoding: utf-8

@treatment_arm
Feature: Treatment Arm API Tests that focus on "treatmentArmStatus" field

  Scenario Outline: TA_TAS1. New Treatment Arm with invalid "treatmentArmStatus" value should fail (including empty string)
    Given template json with a random id
    And set template json field: "treatmentArmStatus" to string value: "<status>"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "not match one of the following values: OPEN"
    Examples:
    |status   |
    |OTHER    |
    |XXX      |
    |         |
    |32       |
    |CLOSED   |
    |SUSPENDED|
    
  Scenario: TA_TAS2. New Treatment Arm with "treatmentArmStatus":null value should pass and value should be set to "OPEN"
    Given template json with an id: "APEC1621-TAS2-1"
    And set template json field: "treatmentArmStatus" to string value: "OPEN"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then retrieve the posted treatment arm from API
    Then the returned treatment arm has value: "OPEN" in field: "treatment_arm_status"

  Scenario: TA_TAS3. New Treatment Arm without "treatmentArmStatus" value should pass and value should be set to "OPEN"
    Given template json with an id: "APEC1621-TAS3-1"
    And remove field: "treatmentArmStatus" from template json
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then retrieve the posted treatment arm from API
    Then the returned treatment arm has value: "OPEN" in field: "treatment_arm_status"



#There should have a new service to update treatmentArmStatus
#  Scenario Outline: TA_TAS4. Existing Treatment Arm with "treatmentArmStatus": CLOSED can not be updated anymore
#    Given template json with an id: "APEC1621-TAS4-1" and version: "2016-06-03"
#    When posted to MATCH newTreatmentArm
#    Then success message is returned:
#    Then cog changes treatment arm with id:"APEC1621-TAS4-1" status to: "CLOSED"
#    And api update status of treatment arm with id:"APEC1621-TAS4-1" from cog
#    Then set template json field: "version" to string value: "2016-06-03"
#    And set template json field: "<field>" to value: "<value>" in type: "<type>"
#    Then posted to MATCH newTreatmentArm
#    Then a failure message is returned which contains: "Validation failed. Closed treatment arm cannot be updated anymore"
#    Examples:
#      |field                |value                               |type                   |
#      |description          |Trying to update closed ta          |string                 |
#
#  Scenario: TA_TAS5. Treatment Arm should have properly generated "statusLog" field
#    Given template json with an id: "APEC1621-TAS5-1" and version: "2016-06-03"
#    When posted to MATCH newTreatmentArm
#    Then success message is returned:
#    Then the treatment arm with id: "APEC1621-TAS5-1" and version: "2016-06-03" return from API has correct latest status that match cog record
#    Then cog changes treatment arm with id:"APEC1621-TAS5-1" status to: "SUSPENDED"
#    And api update status of treatment arm with id:"APEC1621-TAS5-1" from cog
#    Then the treatment arm with id: "APEC1621-TAS5-1" and version: "2016-06-03" return from API has correct latest status that match cog record
#    Then cog changes treatment arm with id:"APEC1621-TAS5-1" status to: "OPEN"
#    And api update status of treatment arm with id:"APEC1621-TAS5-1" from cog
#    Then the treatment arm with id: "APEC1621-TAS5-1" and version: "2016-06-03" return from API has correct latest status that match cog record
#    Then cog changes treatment arm with id:"APEC1621-TAS5-1" status to: "CLOSED"
#    And api update status of treatment arm with id:"APEC1621-TAS5-1" from cog
#    Then the treatment arm with id: "APEC1621-TAS5-1" and version: "2016-06-03" return from API has correct latest status that match cog record
#
#
#  Scenario Outline: TA_TAS6. "treatmentArmStatus" can be updated properly using "ecogTreatmentArmList" service
#    Given template json with an id: "APEC1621-TAS6-1" and version: "2016-06-03"
#    When posted to MATCH newTreatmentArm
#    Then success message is returned:
#    Then cog changes treatment arm with id:"APEC1621-TAS6-1" status to: "<beforeStatus>"
#    And api update status of treatment arm with id:"APEC1621-TAS6-1" from cog
#    Then cog changes treatment arm with id:"APEC1621-TAS6-1" status to: "<afterStatus>"
#    And api update status of treatment arm with id:"APEC1621-TAS6-1" from cog
#    Then the treatment arm with id: "APEC1621-TAS6-1" and version: "2016-06-03" return from API has value: "<afterStatus>" in field: "treatment_arm_status"
#    Examples:
#      |beforeStatus         |afterStatus        |
#      |OPEN                 |SUSPENDED          |
#      |OPEN                 |CLOSED             |
#      |SUSPENDED            |OPEN               |
#      |SUSPENDED            |CLOSED             |
