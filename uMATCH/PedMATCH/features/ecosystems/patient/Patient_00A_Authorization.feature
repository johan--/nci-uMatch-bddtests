@patients_auth
Feature: Patient API authorization tests
#the reason why all false test can use same patient is response http code is the only thing need to check. If the
  #response code is not 401, it doesn't matter what else the test is failed
  #this is really different with other tests. For other tests, we assign different patient for different negative test
  #because we expect correct error reason not just response code.

  @patients_p1
  Scenario Outline: PT_AU01 role base authorization works properly for patient registration
    Given patient id is "<patient_id>"
    And load template registration message for this patient
    And user authorization role is "<auth_role>"
    When POST to MATCH patients service, response includes "<message>" with code "<code>"
    Examples:
      | patient_id   | auth_role                     | message | code |
      | PT_AU01_New0 | NO_ROLE                       |         | 401  |
      | PT_AU01_New1 | ADMIN                         | success | 202  |
      | PT_AU01_New2 | SYSTEM                        | success | 202  |
      | PT_AU01_New0 | ASSIGNMENT_REPORT_REVIEWER    |         | 401  |
      | PT_AU01_New0 | MDA_VARIANT_REPORT_SENDER     |         | 401  |
      | PT_AU01_New0 | MDA_VARIANT_REPORT_REVIEWER   |         | 401  |
      | PT_AU01_New0 | MOCHA_VARIANT_REPORT_SENDER   |         | 401  |
      | PT_AU01_New0 | MOCHA_VARIANT_REPORT_REVIEWER |         | 401  |
      | PT_AU01_New3 | PATIENT_MESSAGE_SENDER        | success | 202  |
      | PT_AU01_New0 | SPECIMEN_MESSAGE_SENDER       |         | 401  |
      | PT_AU01_New0 | ASSAY_MESSAGE_SENDER          |         | 401  |

  @patients_p1
  Scenario Outline: PT_AU02a role base authorization works properly for patient specimen receive
    Given patient id is "<patient_id>"
    And load template specimen type: "TISSUE" received message for this patient
    Then set patient message field: "surgical_event_id" to value: "<patient_id>_SEI1"
    And user authorization role is "<auth_role>"
    When POST to MATCH patients service, response includes "<message>" with code "<code>"
    Examples:
      | patient_id          | auth_role                     | message | code |
      | PT_AU02_Registered0 | NO_ROLE                       |         | 401  |
      | PT_AU02_Registered1 | ADMIN                         | success | 202  |
      | PT_AU02_Registered2 | SYSTEM                        | success | 202  |
      | PT_AU02_Registered0 | ASSIGNMENT_REPORT_REVIEWER    |         | 401  |
      | PT_AU02_Registered0 | MDA_VARIANT_REPORT_SENDER     |         | 401  |
      | PT_AU02_Registered0 | MDA_VARIANT_REPORT_REVIEWER   |         | 401  |
      | PT_AU02_Registered0 | MOCHA_VARIANT_REPORT_SENDER   |         | 401  |
      | PT_AU02_Registered0 | MOCHA_VARIANT_REPORT_REVIEWER |         | 401  |
      | PT_AU02_Registered0 | PATIENT_MESSAGE_SENDER        |         | 401  |
      | PT_AU02_Registered3 | SPECIMEN_MESSAGE_SENDER       | success | 202  |
      | PT_AU02_Registered0 | ASSAY_MESSAGE_SENDER          |         | 401  |

  @patients_p1
  Scenario Outline: PT_AU02b role base authorization works properly for patient specimen ship
    Given patient id is "<patient_id>"
    And load template specimen type: "TISSUE" shipped message for this patient
    Then set patient message field: "molecular_id" to value: "<patient_id>_MOI1"
    Then set patient message field: "surgical_event_id" to value: "<patient_id>_SEI1"
    And user authorization role is "<auth_role>"
    When POST to MATCH patients service, response includes "<message>" with code "<code>"
    Examples:
      | patient_id          | auth_role                     | message | code |
      | PT_AU02_TsReceived0 | NO_ROLE                       |         | 401  |
      | PT_AU02_TsReceived1 | ADMIN                         | success | 202  |
      | PT_AU02_TsReceived2 | SYSTEM                        | success | 202  |
      | PT_AU02_TsReceived0 | ASSIGNMENT_REPORT_REVIEWER    |         | 401  |
      | PT_AU02_TsReceived0 | MDA_VARIANT_REPORT_SENDER     |         | 401  |
      | PT_AU02_TsReceived0 | MDA_VARIANT_REPORT_REVIEWER   |         | 401  |
      | PT_AU02_TsReceived0 | MOCHA_VARIANT_REPORT_SENDER   |         | 401  |
      | PT_AU02_TsReceived0 | MOCHA_VARIANT_REPORT_REVIEWER |         | 401  |
      | PT_AU02_TsReceived0 | PATIENT_MESSAGE_SENDER        |         | 401  |
      | PT_AU02_TsReceived3 | SPECIMEN_MESSAGE_SENDER       | success | 202  |
      | PT_AU02_TsReceived0 | ASSAY_MESSAGE_SENDER          |         | 401  |

  @patients_p1
  Scenario Outline: PT_AU03 role base authorization works properly for patient assay messages
    Given patient id is "<patient_id>"
    And load template assay message for this patient
    Then set patient message field: "surgical_event_id" to value: "<patient_id>_SEI1"
    Then set patient message field: "biomarker" to value: "ICCPTENs"
    And user authorization role is "<auth_role>"
    When POST to MATCH patients service, response includes "<message>" with code "<code>"
    Examples:
      | patient_id            | auth_role                     | message | code |
      | PT_AU03_SlideShipped0 | NO_ROLE                       |         | 401  |
      | PT_AU03_SlideShipped1 | ADMIN                         | success | 202  |
      | PT_AU03_SlideShipped2 | SYSTEM                        | success | 202  |
      | PT_AU03_SlideShipped0 | ASSIGNMENT_REPORT_REVIEWER    |         | 401  |
      | PT_AU03_SlideShipped0 | MDA_VARIANT_REPORT_SENDER     |         | 401  |
      | PT_AU03_SlideShipped0 | MDA_VARIANT_REPORT_REVIEWER   |         | 401  |
      | PT_AU03_SlideShipped0 | MOCHA_VARIANT_REPORT_SENDER   |         | 401  |
      | PT_AU03_SlideShipped0 | MOCHA_VARIANT_REPORT_REVIEWER |         | 401  |
      | PT_AU03_SlideShipped0 | PATIENT_MESSAGE_SENDER        |         | 401  |
      | PT_AU03_SlideShipped0 | SPECIMEN_MESSAGE_SENDER       |         | 401  |
      | PT_AU03_SlideShipped3 | ASSAY_MESSAGE_SENDER          | success | 202  |

  @patients_p1
  Scenario Outline: PT_AU04 role base authorization works properly for patient variant report upload
    Given patient id is "<patient_id>"
    And load template variant file uploaded message for this patient
    Then set patient message field: "molecular_id" to value: "<patient_id>_MOI1"
    Then set patient message field: "analysis_id" to value: "<patient_id>_ANI1"
    Then set patient message field: "ion_reporter_id" to value: "<site_value>"
    Then files for molecular_id "<patient_id>_MOI1" and analysis_id "<patient_id>_ANI1" are in S3
    And user authorization role is "<auth_role>"
    When POST to MATCH patients service, response includes "<message>" with code "<code>"
    Examples:
      | patient_id              | site_value | auth_role                     | message | code |
      | PT_AU04_MdaTsShipped0   | mda        | NO_ROLE                       |         | 401  |
      | PT_AU04_MdaTsShipped1   | mda        | ADMIN                         | success | 202  |
      | PT_AU04_MochaTsShipped1 | mocha      | SYSTEM                        | success | 202  |
      | PT_AU04_MdaTsShipped0   | mda        | ASSIGNMENT_REPORT_REVIEWER    |         | 401  |
      | PT_AU04_MochaTsShipped0 | mocha      | MDA_VARIANT_REPORT_SENDER     |         | 401  |
      | PT_AU04_MdaTsShipped2   | mda        | MDA_VARIANT_REPORT_SENDER     | success | 202  |
      | PT_AU04_MdaTsShipped0   | mda        | MDA_VARIANT_REPORT_REVIEWER   |         | 401  |
      | PT_AU04_MdaTsShipped0   | mda        | MOCHA_VARIANT_REPORT_SENDER   |         | 401  |
      | PT_AU04_MochaTsShipped2 | mocha      | MOCHA_VARIANT_REPORT_SENDER   | success | 202  |
      | PT_AU04_MochaTsShipped0 | mocha      | MOCHA_VARIANT_REPORT_REVIEWER |         | 401  |
      | PT_AU04_MdaTsShipped0   | mda        | PATIENT_MESSAGE_SENDER        |         | 401  |
      | PT_AU04_MochaTsShipped0 | mocha      | SPECIMEN_MESSAGE_SENDER       |         | 401  |
      | PT_AU04_MdaTsShipped0   | mda        | ASSAY_MESSAGE_SENDER          |         | 401  |

  @patients_p1
  Scenario Outline: PT_AU05 role base authorization works properly for patient variant report confirm
    Given patient id is "<patient_id>"
    Then load template variant report confirm message for analysis id: "<patient_id>_ANI1"
    And user authorization role is "<auth_role>"
    When PUT to MATCH variant report "confirm" service, response includes "<message>" with code "<code>"
    Examples:
      | patient_id                 | auth_role                     | message | code |
      | PT_AU05_MdaTsVrUploaded0   | NO_ROLE                       |         | 401  |
      | PT_AU05_MdaTsVrUploaded1   | ADMIN                         | success | 200  |
      | PT_AU05_MochaTsVrUploaded1 | SYSTEM                        | success | 200  |
      | PT_AU05_MdaTsVrUploaded0   | ASSIGNMENT_REPORT_REVIEWER    |         | 401  |
      | PT_AU05_MdaTsVrUploaded0   | MDA_VARIANT_REPORT_SENDER     |         | 401  |
      | PT_AU05_MdaTsVrUploaded2   | MDA_VARIANT_REPORT_REVIEWER   | success | 200  |
      | PT_AU05_MochaTsVrUploaded0 | MDA_VARIANT_REPORT_REVIEWER   |         | 401  |
      | PT_AU05_MochaTsVrUploaded0 | MOCHA_VARIANT_REPORT_SENDER   |         | 401  |
      | PT_AU05_MochaTsVrUploaded2 | MOCHA_VARIANT_REPORT_REVIEWER | success | 200  |
      | PT_AU05_MdaTsVrUploaded0   | MOCHA_VARIANT_REPORT_REVIEWER |         | 401  |
      | PT_AU05_MdaTsVrUploaded0   | PATIENT_MESSAGE_SENDER        |         | 401  |
      | PT_AU05_MochaTsVrUploaded0 | SPECIMEN_MESSAGE_SENDER       |         | 401  |
      | PT_AU05_MdaTsVrUploaded0   | ASSAY_MESSAGE_SENDER          |         | 401  |

  @patients_p1
  Scenario Outline: PT_AU06 role base authorization works properly for patient assignment confirm
    Given patient id is "<patient_id>"
    And load template assignment report confirm message for analysis id: "<patient_id>_ANI1"
    And user authorization role is "<auth_role>"
    When PUT to MATCH assignment report "confirm" service, response includes "<message>" with code "<code>"
    Examples:
      | patient_id                   | auth_role                     | message | code |
      | PT_AU06_PendingConfirmation0 | NO_ROLE                       |         | 401  |
      | PT_AU06_PendingConfirmation1 | ADMIN                         | success | 200  |
      | PT_AU06_PendingConfirmation2 | SYSTEM                        | success | 200  |
      | PT_AU06_PendingConfirmation3 | ASSIGNMENT_REPORT_REVIEWER    | success | 200  |
      | PT_AU06_PendingConfirmation0 | MDA_VARIANT_REPORT_SENDER     |         | 401  |
      | PT_AU06_PendingConfirmation0 | MDA_VARIANT_REPORT_REVIEWER   |         | 401  |
      | PT_AU06_PendingConfirmation0 | MOCHA_VARIANT_REPORT_SENDER   |         | 401  |
      | PT_AU06_PendingConfirmation0 | MOCHA_VARIANT_REPORT_REVIEWER |         | 401  |
      | PT_AU06_PendingConfirmation0 | PATIENT_MESSAGE_SENDER        |         | 401  |
      | PT_AU06_PendingConfirmation0 | SPECIMEN_MESSAGE_SENDER       |         | 401  |
      | PT_AU06_PendingConfirmation0 | ASSAY_MESSAGE_SENDER          |         | 401  |

  @patients_p1
  Scenario Outline: PT_AU07a role base authorization works properly for patient off study
    Given patient id is "<patient_id>"
    And load template off study message for this patient
    Then set patient message field: "step_number" to value: "1.0"
    And user authorization role is "<auth_role>"
    When POST to MATCH patients service, response includes "<message>" with code "<code>"
    Examples:
      | patient_id          | auth_role                     | message | code |
      | PT_AU07_Registered0 | NO_ROLE                       |         | 401  |
      | PT_AU07_Registered1 | ADMIN                         | success | 202  |
      | PT_AU07_Registered2 | SYSTEM                        | success | 202  |
      | PT_AU07_Registered0 | ASSIGNMENT_REPORT_REVIEWER    |         | 401  |
      | PT_AU07_Registered0 | MDA_VARIANT_REPORT_SENDER     |         | 401  |
      | PT_AU07_Registered0 | MDA_VARIANT_REPORT_REVIEWER   |         | 401  |
      | PT_AU07_Registered0 | MOCHA_VARIANT_REPORT_SENDER   |         | 401  |
      | PT_AU07_Registered0 | MOCHA_VARIANT_REPORT_REVIEWER |         | 401  |
      | PT_AU07_Registered3 | PATIENT_MESSAGE_SENDER        | success | 202  |
      | PT_AU07_Registered0 | SPECIMEN_MESSAGE_SENDER       |         | 401  |
      | PT_AU07_Registered0 | ASSAY_MESSAGE_SENDER          |         | 401  |

  @patients_p1
  Scenario Outline: PT_AU07a role base authorization works properly for patient off study biopsy expired
    Given patient id is "<patient_id>"
    And load template off study biopsy expired message for this patient
    Then set patient message field: "step_number" to value: "1.0"
    And user authorization role is "<auth_role>"
    When POST to MATCH patients service, response includes "<message>" with code "<code>"
    Examples:
      | patient_id          | auth_role                     | message | code |
      | PT_AU07_TsReceived0 | NO_ROLE                       |         | 401  |
      | PT_AU07_TsReceived1 | ADMIN                         | success | 202  |
      | PT_AU07_TsReceived2 | SYSTEM                        | success | 202  |
      | PT_AU07_TsReceived0 | ASSIGNMENT_REPORT_REVIEWER    |         | 401  |
      | PT_AU07_TsReceived0 | MDA_VARIANT_REPORT_SENDER     |         | 401  |
      | PT_AU07_TsReceived0 | MDA_VARIANT_REPORT_REVIEWER   |         | 401  |
      | PT_AU07_TsReceived0 | MOCHA_VARIANT_REPORT_SENDER   |         | 401  |
      | PT_AU07_TsReceived0 | MOCHA_VARIANT_REPORT_REVIEWER |         | 401  |
      | PT_AU07_TsReceived3 | PATIENT_MESSAGE_SENDER        | success | 202  |
      | PT_AU07_TsReceived0 | SPECIMEN_MESSAGE_SENDER       |         | 401  |
      | PT_AU07_TsReceived0 | ASSAY_MESSAGE_SENDER          |         | 401  |

  @patients_p1
  Scenario Outline: PT_AU08a role base authorization works properly for patient request assignment
    Given patient id is "<patient_id>"
    And load template request assignment message for this patient
    Then set patient message field: "rebiopsy" to value: "<rebiopsy>"
    And set patient message field: "step_number" to value: "1.0"
    And user authorization role is "<auth_role>"
    When POST to MATCH patients service, response includes "<message>" with code "<code>"
    Examples:
      | patient_id               | rebiopsy | auth_role                     | message | code |
      | PT_AU08_PendingApproval0 | Y        | NO_ROLE                       |         | 401  |
      | PT_AU08_PendingApproval1 | N        | ADMIN                         | success | 202  |
      | PT_AU08_PendingApproval2 | Y        | SYSTEM                        | success | 202  |
      | PT_AU08_PendingApproval0 | Y        | ASSIGNMENT_REPORT_REVIEWER    |         | 401  |
      | PT_AU08_PendingApproval0 | Y        | MDA_VARIANT_REPORT_SENDER     |         | 401  |
      | PT_AU08_PendingApproval0 | Y        | MDA_VARIANT_REPORT_REVIEWER   |         | 401  |
      | PT_AU08_PendingApproval0 | N        | MOCHA_VARIANT_REPORT_SENDER   |         | 401  |
      | PT_AU08_PendingApproval0 | N        | MOCHA_VARIANT_REPORT_REVIEWER |         | 401  |
      | PT_AU08_PendingApproval3 | Y        | PATIENT_MESSAGE_SENDER        | success | 202  |
      | PT_AU08_PendingApproval4 | N        | PATIENT_MESSAGE_SENDER        | success | 202  |
      | PT_AU08_PendingApproval0 | Y        | SPECIMEN_MESSAGE_SENDER       |         | 401  |
      | PT_AU08_PendingApproval0 | N        | ASSAY_MESSAGE_SENDER          |         | 401  |

  @patients_p1
  Scenario Outline: PT_AU08b role base authorization works properly for patient request no assignment
    Given patient id is "<patient_id>"
    And load template request no assignment message for this patient
    And set patient message field: "step_number" to value: "1.0"
    And user authorization role is "<auth_role>"
    When POST to MATCH patients service, response includes "<message>" with code "<code>"
    Examples:
      | patient_id               | auth_role                     | message | code |
      | PT_AU08_PendingApproval0 | NO_ROLE                       |         | 401  |
      | PT_AU08_PendingApproval5 | ADMIN                         | success | 202  |
      | PT_AU08_PendingApproval6 | SYSTEM                        | success | 202  |
      | PT_AU08_PendingApproval0 | ASSIGNMENT_REPORT_REVIEWER    |         | 401  |
      | PT_AU08_PendingApproval0 | MDA_VARIANT_REPORT_SENDER     |         | 401  |
      | PT_AU08_PendingApproval0 | MDA_VARIANT_REPORT_REVIEWER   |         | 401  |
      | PT_AU08_PendingApproval0 | MOCHA_VARIANT_REPORT_SENDER   |         | 401  |
      | PT_AU08_PendingApproval0 | MOCHA_VARIANT_REPORT_REVIEWER |         | 401  |
      | PT_AU08_PendingApproval7 | PATIENT_MESSAGE_SENDER        | success | 202  |
      | PT_AU08_PendingApproval0 | SPECIMEN_MESSAGE_SENDER       |         | 401  |
      | PT_AU08_PendingApproval0 | ASSAY_MESSAGE_SENDER          |         | 401  |

  @patients_p1
  Scenario Outline: PT_AU09 role base authorization works properly for patient on treatment arm
    Given patient id is "<patient_id>"
    Then load template on treatment arm confirm message for this patient
    Then set patient message field: "treatment_arm_id" to value: "APEC1621-A"
    Then set patient message field: "stratum_id" to value: "100"
    Then set patient message field: "step_number" to value: "1.1"
    And user authorization role is "<auth_role>"
    When POST to MATCH patients service, response includes "<message>" with code "<code>"
    Examples:
      | patient_id               | auth_role                     | message | code |
      | PT_AU09_PendingApproval0 | NO_ROLE                       |         | 401  |
      | PT_AU09_PendingApproval1 | ADMIN                         | success | 202  |
      | PT_AU09_PendingApproval2 | SYSTEM                        | success | 202  |
      | PT_AU09_PendingApproval0 | ASSIGNMENT_REPORT_REVIEWER    |         | 401  |
      | PT_AU09_PendingApproval0 | MDA_VARIANT_REPORT_SENDER     |         | 401  |
      | PT_AU09_PendingApproval0 | MDA_VARIANT_REPORT_REVIEWER   |         | 401  |
      | PT_AU09_PendingApproval0 | MOCHA_VARIANT_REPORT_SENDER   |         | 401  |
      | PT_AU09_PendingApproval0 | MOCHA_VARIANT_REPORT_REVIEWER |         | 401  |
      | PT_AU09_PendingApproval3 | PATIENT_MESSAGE_SENDER        | success | 202  |
      | PT_AU09_PendingApproval0 | SPECIMEN_MESSAGE_SENDER       |         | 401  |
      | PT_AU09_PendingApproval0 | ASSAY_MESSAGE_SENDER          |         | 401  |

  @patients_p1
  Scenario Outline: PT_AU10 role base authorization works properly for patient GET
    Given patient GET service: "<service>", patient id: "<patient_id>", id: "<id>"
    And user authorization role is "<auth_role>"
    When GET from MATCH patient API, http code "200" should return
    Examples:
      | service               | patient_id                 | id                       | auth_role                     |
      | patient_limbos        |                            |                          | NO_ROLE                       |
      | events                |                            |                          | ADMIN                         |
      | variant_reports       |                            | PT_GVF_RARebioY_ANI1     | SYSTEM                        |
      | treatment_arm_history | PT_SC06a_PendingApproval   |                          | ASSIGNMENT_REPORT_REVIEWER    |
      | specimens             | PT_GVF_RequestNoAssignment |                          | MDA_VARIANT_REPORT_SENDER     |
      | shipments             |                            |                          | MDA_VARIANT_REPORT_REVIEWER   |
      | specimen_events       | PT_GVF_VrAssay_Ready       |                          | MOCHA_VARIANT_REPORT_SENDER   |
      | variants              |                            |                          | MOCHA_VARIANT_REPORT_REVIEWER |
      | shipments             |                            |                          | PATIENT_MESSAGE_SENDER        |
      | action_items          | PT_GVF_TsVrUploaded        |                          | SPECIMEN_MESSAGE_SENDER       |
      | analysis_report       | PT_GVF_VrAssayReady        | PT_GVF_VrAssayReady_ANI1 | ASSAY_MESSAGE_SENDER          |