@treatment_arm
Feature: TA_AU. Treatment Arm API authorization tests

  @treatment_arm_p1
  Scenario Outline: TA_AU01 role base authorization works properly for the service list treatment arm
    Given GET list service for treatment arm id "<ta_id>", stratum id "<stratum>" and version "<version>"
    When GET from MATCH treatment arm API as authorization role "<auth_role>"
    Then a http response code of "<code>" is returned
    Examples:
      | ta_id          | stratum | version    | auth_role                         | code |
      |                |         |            | NO_TOKEN                          | 401  |
      | APEC1621-A     | 100     |            | NO_TOKEN                          | 401  |
      | APEC1621-B     | 100     | 2015-08-06 | NO_ROLE                           | 401  |
      |                |         |            | NCI_MATCH_READONLY                | 200  |
      | APEC1621-A     | 100     |            | NCI_MATCH_READONLY                | 200  |
      |                |         |            | ADMIN                             | 200  |
      | APEC1621-ETE-A | 100     |            | SYSTEM                            | 200  |
      | APEC1621-ETE-A | 100     | 2015-08-06 | ASSIGNMENT_REPORT_REVIEWER        | 200  |
      | APEC1621-ETE-B | 100     |            | MDA_VARIANT_REPORT_SENDER         | 200  |
      | APEC1621-ETE-B | 100     |            | MDA_VARIANT_REPORT_REVIEWER       | 200  |
      | APEC1621-ETE-C | 100     |            | MOCHA_VARIANT_REPORT_SENDER       | 200  |
      | APEC1621-ETE-C | 100     | 2015-08-06 | MOCHA_VARIANT_REPORT_REVIEWER     | 200  |
      | APEC1621-ETE-B | 100     |            | DARTMOUTH_VARIANT_REPORT_SENDER   | 200  |
      | APEC1621-ETE-B | 100     |            | DARTMOUTH_VARIANT_REPORT_REVIEWER | 200  |
      | APEC1621-ETE-D | 100     |            | PATIENT_MESSAGE_SENDER            | 200  |
      | APEC1621-ETE-D | 100     |            | SPECIMEN_MESSAGE_SENDER           | 200  |
      | APEC1621-2V    | 100     | version2   | ASSAY_MESSAGE_SENDER              | 200  |

  @treatment_arm_p1
  Scenario Outline: TA_AU02 role base authorization works properly for the service list treatment arm assignment report
    Given GET assignment report service for treatment arm id "APEC1621-A" and stratum id "100"
    When GET from MATCH treatment arm API as authorization role "<auth_role>"
    Then a http response code of "<code>" is returned
    Examples:
      | auth_role                         | code |
      | NO_TOKEN                          | 401  |
      | NO_ROLE                           | 401  |
      | NCI_MATCH_READONLY                | 200  |
      | ADMIN                             | 200  |
      | SYSTEM                            | 200  |
      | ASSIGNMENT_REPORT_REVIEWER        | 200  |
      | MDA_VARIANT_REPORT_SENDER         | 200  |
      | MDA_VARIANT_REPORT_REVIEWER       | 200  |
      | MOCHA_VARIANT_REPORT_SENDER       | 200  |
      | MOCHA_VARIANT_REPORT_REVIEWER     | 200  |
      | DARTMOUTH_VARIANT_REPORT_SENDER   | 200  |
      | DARTMOUTH_VARIANT_REPORT_REVIEWER | 200  |
      | PATIENT_MESSAGE_SENDER            | 200  |
      | SPECIMEN_MESSAGE_SENDER           | 200  |
      | ASSAY_MESSAGE_SENDER              | 200  |

  @treatment_arm_p1
  Scenario Outline: TA_AU03 role base authorization works properly for the service POST treatment arm
    Given template treatment arm json with an id: "<ta_id>", stratum_id: "<stratum>" and version: "<version>"
    When POST to MATCH treatment arm API as authorization role "<auth_role>"
    Then a http response code of "<code>" is returned
    Examples:
      | ta_id      | stratum | version    | auth_role                         | code |
      | TA_AU03_1  | 100     | 2017-01-01 | NO_TOKEN                          | 401  |
      | TA_AU03_2  | 100     | 2017-01-01 | NO_ROLE                           | 401  |
      | TA_AU03_3  | 100     | 2017-01-01 | NCI_MATCH_READONLY                | 401  |
      | TA_AU03_4  | 100     | 2017-01-01 | ADMIN                             | 202  |
      | TA_AU03_5  | 100     | 2017-01-01 | SYSTEM                            | 202  |
      | TA_AU03_6  | 100     | 2017-01-01 | ASSIGNMENT_REPORT_REVIEWER        | 401  |
      | TA_AU03_7  | 100     | 2017-01-01 | MDA_VARIANT_REPORT_SENDER         | 401  |
      | TA_AU03_8  | 100     | 2017-01-01 | MDA_VARIANT_REPORT_REVIEWER       | 401  |
      | TA_AU03_9  | 100     | 2017-01-01 | MOCHA_VARIANT_REPORT_SENDER       | 401  |
      | TA_AU03_10 | 100     | 2017-01-01 | MOCHA_VARIANT_REPORT_REVIEWER     | 401  |
      | TA_AU03_11 | 100     | 2017-01-01 | PATIENT_MESSAGE_SENDER            | 401  |
      | TA_AU03_12 | 100     | 2017-01-01 | SPECIMEN_MESSAGE_SENDER           | 401  |
      | TA_AU03_13 | 100     | 2017-01-01 | ASSAY_MESSAGE_SENDER              | 401  |
      | TA_AU03_14 | 100     | 2017-01-01 | DARTMOUTH_VARIANT_REPORT_SENDER   | 401  |
      | TA_AU03_15 | 100     | 2017-01-01 | DARTMOUTH_VARIANT_REPORT_REVIEWER | 401  |

  @treatment_arm_p1
  Scenario Outline: TA_AU04 role base authorization works properly for the service POST treatment arm assignment event
    Given template treatment arm assignment json for patient "<patient_id>" with treatment arm id: "APEC1621-XXX", stratum_id: "1" and version: "v_1"
    When POST to MATCH treatment arm API as authorization role "<auth_role>"
    Then a http response code of "<code>" is returned
    Examples:
      | patient_id                   | auth_role                         | code |
      | PT_TA_AU_TsVrAndAssayReady1  | NO_TOKEN                          | 401  |
      | PT_TA_AU_TsVrAndAssayReady2  | NO_ROLE                           | 401  |
      | PT_TA_AU_TsVrAndAssayReady3  | NCI_MATCH_READONLY                | 401  |
      | PT_TA_AU_TsVrAndAssayReady4  | ADMIN                             | 202  |
      | PT_TA_AU_TsVrAndAssayReady5  | SYSTEM                            | 202  |
      | PT_TA_AU_TsVrAndAssayReady6  | ASSIGNMENT_REPORT_REVIEWER        | 401  |
      | PT_TA_AU_TsVrAndAssayReady7  | MDA_VARIANT_REPORT_SENDER         | 401  |
      | PT_TA_AU_TsVrAndAssayReady8  | MDA_VARIANT_REPORT_REVIEWER       | 401  |
      | PT_TA_AU_TsVrAndAssayReady9  | MOCHA_VARIANT_REPORT_SENDER       | 401  |
      | PT_TA_AU_TsVrAndAssayReady10 | MOCHA_VARIANT_REPORT_REVIEWER     | 401  |
      | PT_TA_AU_TsVrAndAssayReady11 | PATIENT_MESSAGE_SENDER            | 401  |
      | PT_TA_AU_TsVrAndAssayReady12 | SPECIMEN_MESSAGE_SENDER           | 401  |
      | PT_TA_AU_TsVrAndAssayReady13 | ASSAY_MESSAGE_SENDER              | 401  |
      | PT_TA_AU_TsVrAndAssayReady14 | DARTMOUTH_VARIANT_REPORT_SENDER   | 401  |
      | PT_TA_AU_TsVrAndAssayReady15 | DARTMOUTH_VARIANT_REPORT_REVIEWER | 401  |

  @treatment_arm_p2
  Scenario Outline: TA_AU05 role base authorization works properly for the service PUT treatment arm version
    When updating treatment arm status using put request as authorization role "<auth_role>"
    Then a http response code of "<code>" is returned
    Examples:
      | auth_role                         | code |
      | NO_TOKEN                          | 401  |
      | NO_ROLE                           | 401  |
      | NCI_MATCH_READONLY                | 401  |
      | ADMIN                             | 200  |
      | SYSTEM                            | 200  |
      | ASSIGNMENT_REPORT_REVIEWER        | 401  |
      | MDA_VARIANT_REPORT_SENDER         | 401  |
      | MDA_VARIANT_REPORT_REVIEWER       | 401  |
      | MOCHA_VARIANT_REPORT_SENDER       | 401  |
      | MOCHA_VARIANT_REPORT_REVIEWER     | 401  |
      | DARTMOUTH_VARIANT_REPORT_SENDER   | 401  |
      | DARTMOUTH_VARIANT_REPORT_REVIEWER | 401  |
      | PATIENT_MESSAGE_SENDER            | 401  |
      | SPECIMEN_MESSAGE_SENDER           | 401  |
      | ASSAY_MESSAGE_SENDER              | 401  |