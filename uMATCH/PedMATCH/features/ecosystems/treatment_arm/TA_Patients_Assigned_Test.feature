@treatment_arm
Feature: TA_AS. Treatment Arm API Tests that focus on assignment records
  @treatment_arm_p1
  Scenario Outline: TA_AS01. treatment arm assignment data update properly (confirm variant report)
    Given patient id is "<patient_id>"
    And record treatment arm statistic numbers
    Then load template variant report confirm message for analysis id: "<patient_id>_<ani>"
    When PUT to MATCH variant report "confirm" service, response includes "success" with code "200"
    Then wait until ta assignment report for id "APEC1621-M" stratum "100" is updated
    Then following ta assignment reports for patient "<patient_id>" should be found
      | ta_id      | stratum | version    | patient_status |
      | APEC1621-M | 100     | v_2        | <status_m>     |
      | APEC1621-A | 100     | 2015-08-06 | <status_a>     |
    Then there is no treatment arm statistic number change
    Then response of treatment arm accrual command should match database
    Examples:
      | patient_id                  | ani  | status_m             | status_a          |
      | TA_AS01_TsVrReceivedV1      | ANI1 | PENDING_CONFIRMATION |                   |
      | TA_AS01_TsVrReceivedV1Step2 | ANI2 | PENDING_CONFIRMATION | PREVIOUSLY_ON_ARM |
      | TA_AS01_TsVrReceivedV2      | ANI1 | PENDING_CONFIRMATION |                   |
      | TA_AS01_TsVrReceivedV2Step2 | ANI2 | PENDING_CONFIRMATION | PREVIOUSLY_ON_ARM |

  @treatment_arm_p1
  Scenario Outline: TA_AS02. treatment arm assignment data update properly (confirm assignment report)
    Given patient id is "<patient_id>"
    And record treatment arm statistic numbers
    Then load template assignment report confirm message for analysis id: "<ani>"
    When PUT to MATCH assignment report "confirm" service, response includes "success" with code "200"
    Then wait until ta assignment report for id "APEC1621-M" stratum "100" is updated
    Then following ta assignment reports for patient "<patient_id>" should be found
      | ta_id      | stratum | version    | patient_status |
      | APEC1621-M | 100     | <ver>      | <status_m>     |
      | APEC1621-A | 100     | 2015-08-06 | <status_a>     |
    Then the statistic number changes for treatment arms should be described in this table
      | ta_id      | stratum | version | current_patients | former_patients | not_enrolled_patients | pending_patients |
      | APEC1621-M | 100     | <ver>   | 0                | 0               | 0                     | 1                |
    Then response of treatment arm accrual command should match database
    Examples:
      | patient_id                 | ani                             | ver | status_m         | status_a          |
      | TA_AS02_PendingConfV1      | TA_AS02_PendingConfV1_ANI1      | v_1 | PENDING_APPROVAL |                   |
      | TA_AS02_PendingConfV1Step2 | TA_AS02_PendingConfV1Step2_ANI2 | v_1 | PENDING_APPROVAL | PREVIOUSLY_ON_ARM |
      | TA_AS02_PendingConfV2      | TA_AS02_PendingConfV2_ANI1      | v_2 | PENDING_APPROVAL |                   |
      | TA_AS02_PendingConfV2Step2 | TA_AS02_PendingConfV2Step2_ANI2 | v_2 | PENDING_APPROVAL | PREVIOUSLY_ON_ARM |

  @treatment_arm_p2
  Scenario Outline: TA_AS03. statistic numbers update properly (change to OFF_STUDY)
    Given patient id is "<patient_id>"
    And record treatment arm statistic numbers
    Then load template off study message for this patient
    Then set patient message field: "step_number" to value: "<step>"
    When POST to MATCH patients service, response includes "success" with code "202"
    Then wait until ta assignment report for id "APEC1621-M" stratum "100" is updated
    Then following ta assignment reports for patient "<patient_id>" should be found
      | ta_id      | stratum | version    | patient_status |
      | APEC1621-M | 100     | <ver>      | <status_m>     |
      | APEC1621-A | 100     | 2015-08-06 | <status_a>     |
    Then the statistic number changes for treatment arms should be described in this table
      | ta_id      | stratum | version | current_patients | former_patients | not_enrolled_patients | pending_patients |
      | APEC1621-M | 100     | <ver>   | <cp>             | <fp>            | <np>                  | <pp>             |
    Then response of treatment arm accrual command should match database
    Examples:
      | patient_id                    | ver | step | status_m                      | status_a                    | cp | fp | np | pp |
      | TA_AS03_PendingConfV1         | v_1 | 1.0  | NOT_ENROLLED_ON_ARM           |                             | 0  | 0  | 1  | 0  |
      | TA_AS03_PendingConfV1Step2    | v_1 | 2.0  | NOT_ENROLLED_ON_ARM           | PREVIOUSLY_ON_ARM_OFF_STUDY | 0  | 0  | 1  | 0  |
      | TA_AS03_PendingApprV1         | v_1 | 1.0  | NOT_ENROLLED_ON_ARM_OFF_STUDY |                             | 0  | 0  | 1  | -1 |
      | TA_AS03_PendingApprV1Step2    | v_1 | 2.0  | NOT_ENROLLED_ON_ARM_OFF_STUDY | PREVIOUSLY_ON_ARM_OFF_STUDY | 0  | 0  | 1  | -1 |
      | TA_AS03_OnTreatmentArmV1      | v_1 | 1.0  | PREVIOUSLY_ON_ARM_OFF_STUDY   |                             | -1 | 1  | 0  | 0  |
      | TA_AS03_OnTreatmentArmV1Step2 | v_1 | 2.1  | PREVIOUSLY_ON_ARM_OFF_STUDY   | PREVIOUSLY_ON_ARM_OFF_STUDY | -1 | 1  | 0  | 0  |
      | TA_AS03_PendingConfV2         | v_2 | 1.0  | NOT_ENROLLED_ON_ARM           |                             | 0  | 0  | 1  | 0  |
      | TA_AS03_PendingConfV2Step2    | v_2 | 2.0  | NOT_ENROLLED_ON_ARM           | PREVIOUSLY_ON_ARM_OFF_STUDY | 0  | 0  | 1  | 0  |
      | TA_AS03_PendingApprV2         | v_2 | 1.0  | NOT_ENROLLED_ON_ARM_OFF_STUDY |                             | 0  | 0  | 1  | -1 |
      | TA_AS03_PendingApprV2Step2    | v_2 | 2.0  | NOT_ENROLLED_ON_ARM_OFF_STUDY | PREVIOUSLY_ON_ARM_OFF_STUDY | 0  | 0  | 1  | -1 |
      | TA_AS03_OnTreatmentArmV2      | v_2 | 1.0  | PREVIOUSLY_ON_ARM_OFF_STUDY   |                             | -1 | 1  | 0  | 0  |
      | TA_AS03_OnTreatmentArmV2Step2 | v_2 | 2.1  | PREVIOUSLY_ON_ARM_OFF_STUDY   | PREVIOUSLY_ON_ARM_OFF_STUDY | -1 | 1  | 0  | 0  |

  @treatment_arm_p1
  Scenario Outline: TA_AS04. statistic numbers update properly (change to ON_TREATMENT_ARM)
    Given patient id is "<patient_id>"
    And record treatment arm statistic numbers
    Then load template on treatment arm confirm message for this patient
    Then set patient message field: "treatment_arm_id" to value: "APEC1621-M"
    Then set patient message field: "stratum_id" to value: "100"
    Then set patient message field: "step_number" to value: "<step>"
    When POST to MATCH patients service, response includes "success" with code "202"
    Then wait until ta assignment report for id "APEC1621-M" stratum "100" is updated
    Then following ta assignment reports for patient "<patient_id>" should be found
      | ta_id      | stratum | version    | patient_status   |
      | APEC1621-M | 100     | <ver>      | ON_TREATMENT_ARM |
      | APEC1621-A | 100     | 2015-08-06 | <status_a>       |
    Then the statistic number changes for treatment arms should be described in this table
      | ta_id      | stratum | version | current_patients | former_patients | not_enrolled_patients | pending_patients |
      | APEC1621-M | 100     | <ver>   | 1                | 0               | 0                     | -1               |
    Then response of treatment arm accrual command should match database
    Examples:
      | patient_id                 | ver | step | status_a          |
      | TA_AS04_PendingApprV1      | v_1 | 1.1  |                   |
      | TA_AS04_PendingApprV1Step2 | v_1 | 2.1  | PREVIOUSLY_ON_ARM |
      | TA_AS04_PendingApprV2      | v_2 | 1.1  |                   |
      | TA_AS04_PendingApprV2Step2 | v_2 | 2.1  | PREVIOUSLY_ON_ARM |

  @treatment_arm_p1
  Scenario Outline: TA_AS05. statistic numbers update properly (send request assignment message)
    Given patient id is "<patient_id>"
    And record treatment arm statistic numbers
    Then load template request assignment message for this patient
    Then set patient message field: "rebiopsy" to value: "<rebiopsy>"
    And set patient message field: "step_number" to value: "<step>"
    When POST to MATCH patients service, response includes "success" with code "202"
    Then wait until ta assignment report for id "APEC1621-M" stratum "100" is updated
    Then following ta assignment reports for patient "<patient_id>" should be found
      | ta_id      | stratum | version    | patient_status |
      | APEC1621-M | 100     | <ver>      | <status_m>     |
      | APEC1621-A | 100     | 2015-08-06 | <status_a>     |
    Then the statistic number changes for treatment arms should be described in this table
      | ta_id      | stratum | version | current_patients | former_patients | not_enrolled_patients | pending_patients |
      | APEC1621-M | 100     | <ver>   | <cp>             | <fp>            | <np>                  | <pp>             |
    Then response of treatment arm accrual command should match database
    Examples:
      | patient_id                      | rebiopsy | ver | step | status_m            | status_a          | cp | fp | np | pp |
      | TA_AS05_PendingApprV1_1         | Y        | v_1 | 1.0  | NOT_ENROLLED_ON_ARM |                   | 0  | 0  | 1  | -1 |
      | TA_AS05_PendingApprV1_2         | N        | v_1 | 1.0  | NOT_ENROLLED_ON_ARM |                   | 0  | 0  | 1  | -1 |
      | TA_AS05_PendingApprV1Step2_1    | Y        | v_1 | 1.0  | NOT_ENROLLED_ON_ARM | PREVIOUSLY_ON_ARM | 0  | 0  | 1  | -1 |
      | TA_AS05_PendingApprV1Step2_2    | N        | v_1 | 1.0  | NOT_ENROLLED_ON_ARM | PREVIOUSLY_ON_ARM | 0  | 0  | 1  | -1 |
      | TA_AS05_OnTreatmentArmV1_1      | Y        | v_1 | 2.0  | PREVIOUSLY_ON_ARM   |                   | -1 | 1  | 0  | 0  |
      | TA_AS05_OnTreatmentArmV1_2      | N        | v_1 | 2.0  | PREVIOUSLY_ON_ARM   |                   | -1 | 1  | 0  | 0  |
      | TA_AS05_OnTreatmentArmV1Step2_1 | Y        | v_1 | 3.0  | PREVIOUSLY_ON_ARM   | PREVIOUSLY_ON_ARM | -1 | 1  | 0  | 0  |
      | TA_AS05_OnTreatmentArmV1Step2_2 | N        | v_1 | 3.0  | PREVIOUSLY_ON_ARM   | PREVIOUSLY_ON_ARM | -1 | 1  | 0  | 0  |
      | TA_AS05_PendingApprV2_1         | Y        | v_2 | 1.0  | NOT_ENROLLED_ON_ARM |                   | 0  | 0  | 1  | -1 |
      | TA_AS05_PendingApprV2_2         | N        | v_2 | 1.0  | NOT_ENROLLED_ON_ARM |                   | 0  | 0  | 1  | -1 |
      | TA_AS05_PendingApprV2Step2_1    | Y        | v_2 | 1.0  | NOT_ENROLLED_ON_ARM | PREVIOUSLY_ON_ARM | 0  | 0  | 1  | -1 |
      | TA_AS05_PendingApprV2Step2_2    | N        | v_2 | 1.0  | NOT_ENROLLED_ON_ARM | PREVIOUSLY_ON_ARM | 0  | 0  | 1  | -1 |
      | TA_AS05_OnTreatmentArmV2_1      | Y        | v_2 | 2.0  | PREVIOUSLY_ON_ARM   |                   | -1 | 1  | 0  | 0  |
      | TA_AS05_OnTreatmentArmV2_2      | N        | v_2 | 2.0  | PREVIOUSLY_ON_ARM   |                   | -1 | 1  | 0  | 0  |
      | TA_AS05_OnTreatmentArmV2Step2_1 | Y        | v_2 | 3.0  | PREVIOUSLY_ON_ARM   | PREVIOUSLY_ON_ARM | -1 | 1  | 0  | 0  |
      | TA_AS05_OnTreatmentArmV2Step2_2 | N        | v_2 | 3.0  | PREVIOUSLY_ON_ARM   | PREVIOUSLY_ON_ARM | -1 | 1  | 0  | 0  |

  @treatment_arm_p2
  Scenario: TA_AS40. treatment arm assignment patient list should include patient who has compassionate care assignment
    Given patient id is "TA_AS40_TsVrReceived"
    And patient API user authorization role is "MDA_VARIANT_REPORT_REVIEWER"
    Then load template variant report confirm message for analysis id: "TA_AS40_TsVrReceived_ANI1"
    When PUT to MATCH variant report "confirm" service, response includes "successfully" with code "200"
    Then patient status should change to "PENDING_CONFIRMATION"
    Then patient API user authorization role is "ASSIGNMENT_REPORT_REVIEWER"
    Then wait until ta assignment report for id "CukeTest-122-1-SUSPENDED" stratum "stratum122a" is updated
    Then load template assignment report confirm message for analysis id: "TA_AS40_TsVrReceived_ANI1"
    Then PUT to MATCH assignment report "confirm" service, response includes "successfully" with code "200"
    Then wait until ta assignment report for id "CukeTest-122-1-SUSPENDED" stratum "stratum122a" is updated
    Then following ta assignment reports for patient "TA_AS40_TsVrReceived" should be found
      | ta_id                    | stratum     | version    | patient_status     |
      | CukeTest-122-1-SUSPENDED | stratum122a | 2015-08-06 | COMPASSIONATE_CARE |

  @treatment_arm_p2
  Scenario: TA_OS4. /treatment_arms/accrual return correct result
    Given response of treatment arm accrual command should match database