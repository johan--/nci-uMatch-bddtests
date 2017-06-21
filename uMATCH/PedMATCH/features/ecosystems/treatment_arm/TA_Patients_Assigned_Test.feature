@treatment_arm
Feature: TA_ST. Treatment Arm API Tests that focus on assignment records
#  @treatment_arm_p2
#  Scenario Outline: TA_AS00. treatment arm assignment data update properly ( to PENDING_CONFIRMATION)
#    Examples:
#  Scenario Outline: TA_AS01. treatment arm assignment data update properly (PENDING_CONFIRMATION to PENDING_APPROVAL)
#    Examples:
#  Scenario Outline: TA_AS02. statistic numbers update properly (PENDING_CONFIRMATION to OFF_STUDY)
#    Examples:
#  Scenario Outline: TA_AS04. statistic numbers update properly (PENDING_APPROVAL to ON_TREATMENT_ARM)
#    Examples:
#  Scenario Outline: TA_AS05. statistic numbers update properly (PENDING_APPROVAL to REQUEST_ASSIGNMENT,rebio=N)
#    Examples:
#  Scenario Outline: TA_AS06. statistic numbers update properly (PENDING_APPROVAL to REQUEST_ASSIGNMENT,rebio=Y)
#    Examples:
#  Scenario Outline: TA_AS07. statistic numbers update properly (PENDING_APPROVAL to OFF_STUDY)
#    Examples:
#  Scenario Outline: TA_AS09. statistic numbers update properly (ON_TREATMENT_ARM to REQUEST_ASSIGNMENT,rebio=N)
#    Examples:
#  Scenario Outline: TA_AS10. statistic numbers update properly (ON_TREATMENT_ARM to REQUEST_ASSIGNMENT,rebio=Y)
#    Examples:
#  Scenario Outline: TA_AS11. statistic numbers update properly (ON_TREATMENT_ARM to OFF_STUDY)
#    Examples:
##  Scenario Outline: TA_AS03. statistic numbers update properly (PENDING_CONFIRMATION to OFF_STUDY_BIOPSY_EXPIRED)
##    Examples:
##  Scenario Outline: TA_AS08. statistic numbers update properly (PENDING_APPROVAL to OFF_STUDY_BIOPSY_EXPIRED)
##    Examples:
##  Scenario Outline: TA_AS12. statistic numbers update properly (ON_TREATMENT_ARM to OFF_STUDY_BIOPSY_EXPIRED)
##    Examples:

  Scenario: TA_AS40. treatment arm assignment patient list should include patient who has compassionate care assignment
    Given patient id is "TA_AS40_TsVrReceived"
    And patient API user authorization role is "MDA_VARIANT_REPORT_REVIEWER"
    Then load template variant report confirm message for analysis id: "TA_AS40_TsVrReceived_ANI1"
    When PUT to MATCH variant report "confirm" service, response includes "successfully" with code "200"
    Then patient status should change to "PENDING_CONFIRMATION"
    Then patient API user authorization role is "ASSIGNMENT_REPORT_REVIEWER"
    Then load template assignment report confirm message for analysis id: "TA_AS40_TsVrReceived_ANI1"
    Then PUT to MATCH assignment report "confirm" service, response includes "successfully" with code "200"
    Then patient status should change to "COMPASSIONATE_CARE"
    Given GET assignment report service for treatment arm id "CukeTest-122-1-SUSPENDED" and stratum id "stratum122a"
    When GET from MATCH treatment arm API as authorization role "ADMIN"
    Then returned treatment arm assignment report should have patient "TA_AS40_TsVrReceived" in patients list

  @treatment_arm_p2
  Scenario: TA_OS4. /treatment_arms/accrual return correct result
    Given response of treatment arm accrual command should match database