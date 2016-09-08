#encoding: utf-8

@treatment_arm
Feature: Treatment Arm API Tests that focus on "treatment_arm_status" field

  Scenario Outline: TA_TAS1. New Treatment Arm with invalid "treatment_arm_status" value should fail (including empty string)
    Given template treatment arm json with a random id
    And set template treatment arm json field: "treatment_arm_status" to string value: "<status>"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "not match one of the following values: OPEN"
    Examples:
    |status   |
    |XXX      |
    |         |
    |32       |
    
  Scenario Outline: TA_TAS2. The status of new Treatment Arm should be set to "OPEN", no matter what the value of "treatment_arm_status" is
    Given template treatment arm json with an id: "<treatmentArmID>"
    And set template treatment arm json field: "treatment_arm_status" to string value: "<status>"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then retrieve the posted treatment arm from API
    Then the returned treatment arm has value: "OPEN" in field: "treatment_arm_status"
    Examples:
    |treatmentArmID             |status     |
    |APEC1621-TAS2-1            |           |
    |APEC1621-TAS2-2            |CLOSED     |
    |APEC1621-TAS2-3            |SUSPENDED  |

  Scenario: TA_TAS3. The status of update Treatment Arm should be set to same value with the last version, no matter what the value of "treatment_arm_status" is
    Given template treatment arm json with an id: "APEC1621-TAS2-1", stratum_id: "STRATUM1" and version: "2016-06-03"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then wait for "5" seconds
    Then cog changes treatment arm with id:"APEC1621-TAS3-1" and stratumID:"STRATUM1" status to: "SUSPENDED"
    Then set the version of the treatment arm to "2016-06-28"
    Then set template treatment arm json field: "treatment_arm_status" to string value: "CLOSED"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then retrieve the posted treatment arm from API
    Then the returned treatment arm has value: "SUSPENDED" in field: "treatment_arm_status"



#Eventually any treatment arm query via API will trigger TA processor to request latest treatment arm status from COG service
  #so there is no need to have this step: "And api update status of treatment arm with id:"APEC1621-TAS4-1" from cog"
  Scenario: TA_TAS4. Existing Treatment Arm with "treatment_arm_status": CLOSED can be updated but remain CLOSED
    Given template treatment arm json with an id: "APEC1621-TAS4-1", stratum_id: "STRATUM1" and version: "2016-06-03"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then wait for "5" seconds
    Then cog changes treatment arm with id:"APEC1621-TAS4-1" and stratumID:"STRATUM1" status to: "CLOSED"
    Then set the version of the treatment arm to "2016-06-28"
    And set template treatment arm json field: "treatment_arm_status" to string value: "OPEN"
    Then posted to MATCH newTreatmentArm
    Then success message is returned:
    Then retrieve the posted treatment arm from API
    Then the returned treatment arm has value: "CLOSED" in field: "treatment_arm_status"
#
#  Scenario: TA_TAS5. Treatment Arm should have properly generated "statusLog" field
  ##########this need to be updated, if a treatment arm (id-stratum_id) has multiple version, once treatment arm status changed, all version should be changed
  ############which means the statusLog should always has same "SUSPENDED" and "CLOSED" log
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
#  Scenario Outline: TA_TAS6. "treatment_arm_status" can be updated properly using "ecogTreatmentArmList" service
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
#  Scenario: TA_TAS7. updated treatment arm(new version) should derive the current status of old treatment arm
#  Scenario: TA_TAS8. status of old treatment arm(old version) will never be updated after a new version comes in
      #id1-stratum1
      #new version          v1:OPEN
      #COG SUSPENDED        v1:SUSPENDED
      #new version          v1:SUSPENDED    v2:SUSPENDED
      #COG OPEN             v1:SUSPENDED    v2:OPEN
      #COG CLOSED           v1:SUSPENDED    v2:CLOSED
#  Scenario: TA_TAS9. update should not change treatment_arm_status
#  Scenario: TA_TAS10. CLOSED treatment arm can still be updated(add new version) but remain CLOSED

