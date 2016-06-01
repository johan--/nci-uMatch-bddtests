#encoding: utf-8

@TA_Post_Tests
#Feature: Treatment Arm API Tests that focus on "treatmentArmDrugs" field
#  Scenario: New Treatment Arm with emtpy "treatmentArmDrugs" field should fail
#  Scenario: New Treatment Arm with "treatmentArmDrugs": null should fail
#  Scenario: New Treatment Arm without "treatmentArmDrugs" field should fail
#  Scenario: New Treatment Arm with duplicated drug entities shoudl fail (or duplicated entities should be ignored)
#  Scenario Outline: New Treatment Arm with incompleted drug entity should fail
#  Scenario: Update Treatment Arm with empty "treatmentArmDrugs" field should fail
#  Scenario: Update Treatment Arm with "treatmentArmDrugs": null should fail
#  Scenario: Update Treatment Arm without "treatmentArmDrugs" field should fail
#  Scenario: Update Treatment Arm with duplicated drug entities shoudl fail (or duplicated entities should be ignored)
#  Scenario Outline: Update Treatment Arm with incompleted drug entity should fail
#  Scenario: Drugs should have unique drugId
#  Scenario Outline: Unrelated fields in "treatmentArmDrugs" should be ignored
#  Scenario Outline: Unrelated fields in drug entity should be ignored
#  Scenario: Update Treatment Arm with extended "treatmentArmDrugs" list should pass
#  Scenario: Update Treatment Arm with shortened "treatmentArmDrugs" list should pass
#  Scenario: Update Treatment Arm with replaced "treatmentArmDrugs" list should pass
#  Scenario: Very long "treatmentArmDrugs" list should pass