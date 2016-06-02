#encoding: utf-8

@Treatment_Arm_API_Tests
Feature: Treatment Arm API Tests that focus on "id" field
  Scenario: New Treatment Arm with emtpy "id" field should fail
     Given template json with a new unique id
     And set template json field: "id" to string value: ""
     When posted to MATCH newTreatmentArm
     Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario: New Treatment Arm with "id": null should fail
    Given template json with a new unique id
    And set template json field: "id" to string value: "null"
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"

  Scenario: New Treatment Arm without "id" field should fail
    Given template json with a new unique id
    And remove field: "id" from template json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed.  Please check all required fields are present"


  Scenario Outline: New Treatment Arm with special character in "id" field should pass
    Given template json with a new unique id
    And set template json field: "id" to string value: "<id>"
    And set template json field: "version" to string value: "V0000001"
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm with id: "<encoded_id>" and version: "V0000001" should return from database
    Examples:
    |id                     |encoded_id                           |
    |TA_BDDTESTs_@*$%sdga#  |TA_BDDTESTs_%40*%24%25sdga%23        |
    |TA_BDDTESTs_!^&*()-_+= |TA_BDDTESTs_!%5E%26*()-_%2B%3D       |
    |TA_BDDTESTs_{}[]\/?    |TA_BDDTESTs_%7B%7D%5B%5D%5C%2F%3F    |
    |TA_BDDTESTs_;'<>,      |TA_BDDTESTs_%3B%27%3C%3E%2C          |
    |TA_BDDTESTs_?Àü ī      |TA_BDDTESTs_%3F%C3%80%C3%BC%20%C4%AB |
    |TA_BDDTESTs.id         |TA_BDDTESTs%2Eid                     |

  #if dot(.) cannot be used in URL, then id should not accept dot, then add this scenario:
  #Scenario: New Treatement Arm with dot "." in "id" field should fail