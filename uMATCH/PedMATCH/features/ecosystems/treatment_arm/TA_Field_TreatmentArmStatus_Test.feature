#encoding: utf-8

@treatment_arm
Feature: TA_TAS. Treatment Arm API Tests that focus on "treatment_arm_status" field

  @treatment_arm_p3
  Scenario Outline: TA_TAS1. The status of new Treatment Arm should be set to "OPEN", no matter what the value of "treatment_arm_status" is
    Given template treatment arm json with an id: "<treatmentArmID>"
    And set template treatment arm json field: "treatment_arm_status" to string value: "<status>"
    When creating a new treatment arm using post request
    Then a success message is returned
    Then wait for processor to complete request in "10" seconds
    Then retrieve the posted treatment arm from API
    Then the returned treatment arm has value: "OPEN" in field: "treatment_arm_status"
    Examples:
    |treatmentArmID             |status     |
    |APEC1621-TAS2-1            |           |
    |APEC1621-TAS2-2            |CLOSED     |
    |APEC1621-TAS2-3            |SUSPENDED  |

  @treatment_arm_p3
  Scenario: TA_TAS2. The status of update Treatment Arm should be set to same value with the last version
    Given template treatment arm json with an id: "APEC1621-TAS2-1", stratum_id: "STRATUM1" and version: "2016-06-03"
    When creating a new treatment arm using post request
    Then a success message is returned
    Then wait for processor to complete request in "10" seconds
    Then cog changes treatment arm with id:"APEC1621-TAS2-1" and stratumID:"STRATUM1" status to: "SUSPENDED"
    Then retrieve the posted treatment arm from API
    Then the returned treatment arm has value: "SUSPENDED" in field: "treatment_arm_status"
    Then set the version of the treatment arm to "2016-06-28"
    When creating a new treatment arm using post request
    Then a success message is returned
    Then wait for processor to complete request in "10" seconds
    Then retrieve the posted treatment arm from API
    Then the returned treatment arm has value: "SUSPENDED" in field: "treatment_arm_status"



#Eventually any treatment arm query via API will trigger TA processor to request latest treatment arm status from COG service
  #so there is no need to have this step: "And api update status of treatment arm with id:"APEC1621-TAS4-1" from cog"
#  @broken
#  Scenario: TA_TAS4. Existing Treatment Arm with "treatment_arm_status": CLOSED can be updated but remain CLOSED
#    Given template treatment arm json with an id: "APEC1621-TAS4-1", stratum_id: "STRATUM1" and version: "2016-06-03"
#    When creating a new treatment arm using post request
#    Then a success message is returned
#    Then wait for processor to complete request in "10" seconds
#    Then cog changes treatment arm with id:"APEC1621-TAS4-1" and stratumID:"STRATUM1" status to: "CLOSED"
#    Then set the version of the treatment arm to "2016-06-28"
#    And set template treatment arm json field: "treatment_arm_status" to string value: "OPEN"
#    Then creating a new treatment arm using post request
#    Then a success message is returned
#    Then retrieve the posted treatment arm from API
#    Then the returned treatment arm has value: "CLOSED" in field: "treatment_arm_status"
