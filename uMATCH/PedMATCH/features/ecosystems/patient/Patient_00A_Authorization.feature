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
    And patient API user authorization role is "<auth_role>"
    When POST to MATCH patients service, response includes "<message>" with code "<code>"
    Examples:
      | patient_id   | auth_role                         | message | code |
      | PT_AU01_New0 | NO_TOKEN                          |         | 401  |
      | PT_AU01_New0 | NCI_MATCH_READONLY                |         | 401  |
      | PT_AU01_New0 | NO_ROLE                           |         | 401  |
      | PT_AU01_New1 | ADMIN                             | success | 202  |
      | PT_AU01_New2 | SYSTEM                            |         | 401  |
      | PT_AU01_New0 | ASSIGNMENT_REPORT_REVIEWER        |         | 401  |
      | PT_AU01_New0 | MDA_VARIANT_REPORT_SENDER         |         | 401  |
      | PT_AU01_New0 | MDA_VARIANT_REPORT_REVIEWER       |         | 401  |
      | PT_AU01_New0 | MOCHA_VARIANT_REPORT_SENDER       |         | 401  |
      | PT_AU01_New0 | MOCHA_VARIANT_REPORT_REVIEWER     |         | 401  |
      | PT_AU01_New0 | DARTMOUTH_VARIANT_REPORT_SENDER   |         | 401  |
      | PT_AU01_New0 | DARTMOUTH_VARIANT_REPORT_REVIEWER |         | 401  |
      | PT_AU01_New3 | PATIENT_MESSAGE_SENDER            | success | 202  |
      | PT_AU01_New0 | SPECIMEN_MESSAGE_SENDER           |         | 401  |
      | PT_AU01_New0 | ASSAY_MESSAGE_SENDER              |         | 401  |

  @patients_p1
  Scenario Outline: PT_AU02a role base authorization works properly for patient specimen receive
    Given patient id is "<patient_id>"
    And load template specimen type: "TISSUE" received message for this patient
    Then set patient message field: "surgical_event_id" to value: "<patient_id>_SEI1"
    And patient API user authorization role is "<auth_role>"
    When POST to MATCH patients service, response includes "<message>" with code "<code>"
    Examples:
      | patient_id          | auth_role                         | message | code |
      | PT_AU02_Registered0 | NO_TOKEN                          |         | 401  |
      | PT_AU02_Registered0 | NCI_MATCH_READONLY                |         | 401  |
      | PT_AU02_Registered0 | NO_ROLE                           |         | 401  |
      | PT_AU02_Registered1 | ADMIN                             | success | 202  |
      | PT_AU02_Registered2 | SYSTEM                            |         | 401  |
      | PT_AU02_Registered0 | ASSIGNMENT_REPORT_REVIEWER        |         | 401  |
      | PT_AU02_Registered0 | MDA_VARIANT_REPORT_SENDER         |         | 401  |
      | PT_AU02_Registered0 | MDA_VARIANT_REPORT_REVIEWER       |         | 401  |
      | PT_AU02_Registered0 | MOCHA_VARIANT_REPORT_SENDER       |         | 401  |
      | PT_AU02_Registered0 | MOCHA_VARIANT_REPORT_REVIEWER     |         | 401  |
      | PT_AU02_Registered0 | DARTMOUTH_VARIANT_REPORT_SENDER   |         | 401  |
      | PT_AU02_Registered0 | DARTMOUTH_VARIANT_REPORT_REVIEWER |         | 401  |
      | PT_AU02_Registered0 | PATIENT_MESSAGE_SENDER            |         | 401  |
      | PT_AU02_Registered3 | SPECIMEN_MESSAGE_SENDER           | success | 202  |
      | PT_AU02_Registered0 | ASSAY_MESSAGE_SENDER              |         | 401  |

  @patients_p1
  Scenario Outline: PT_AU02b role base authorization works properly for patient specimen ship
    Given patient id is "<patient_id>"
    And load template specimen type: "TISSUE" shipped message for this patient
    Then set patient message field: "molecular_id" to value: "<patient_id>_MOI1"
    Then set patient message field: "surgical_event_id" to value: "<patient_id>_SEI1"
    Then set patient message field: "shipped_dttm" to value: "current"
    And patient API user authorization role is "<auth_role>"
    When POST to MATCH patients service, response includes "<message>" with code "<code>"
    Examples:
      | patient_id          | auth_role                         | message | code |
      | PT_AU02_TsReceived0 | NO_TOKEN                          |         | 401  |
      | PT_AU02_TsReceived0 | NCI_MATCH_READONLY                |         | 401  |
      | PT_AU02_TsReceived0 | NO_ROLE                           |         | 401  |
      | PT_AU02_TsReceived1 | ADMIN                             | success | 202  |
      | PT_AU02_TsReceived2 | SYSTEM                            |         | 401  |
      | PT_AU02_TsReceived0 | ASSIGNMENT_REPORT_REVIEWER        |         | 401  |
      | PT_AU02_TsReceived0 | MDA_VARIANT_REPORT_SENDER         |         | 401  |
      | PT_AU02_TsReceived0 | MDA_VARIANT_REPORT_REVIEWER       |         | 401  |
      | PT_AU02_TsReceived0 | MOCHA_VARIANT_REPORT_SENDER       |         | 401  |
      | PT_AU02_TsReceived0 | MOCHA_VARIANT_REPORT_REVIEWER     |         | 401  |
      | PT_AU02_TsReceived0 | DARTMOUTH_VARIANT_REPORT_SENDER   |         | 401  |
      | PT_AU02_TsReceived0 | DARTMOUTH_VARIANT_REPORT_REVIEWER |         | 401  |
      | PT_AU02_TsReceived0 | PATIENT_MESSAGE_SENDER            |         | 401  |
      | PT_AU02_TsReceived3 | SPECIMEN_MESSAGE_SENDER           | success | 202  |
      | PT_AU02_TsReceived0 | ASSAY_MESSAGE_SENDER              |         | 401  |

  @patients_p1
  Scenario Outline: PT_AU03 role base authorization works properly for patient assay messages
    Given patient id is "<patient_id>"
    And load template assay message for this patient
    Then set patient message field: "surgical_event_id" to value: "<patient_id>_SEI1"
    Then set patient message field: "biomarker" to value: "ICCPTENs"
    And patient API user authorization role is "<auth_role>"
    When POST to MATCH patients service, response includes "<message>" with code "<code>"
    Examples:
      | patient_id            | auth_role                         | message | code |
      | PT_AU03_SlideShipped0 | NO_TOKEN                          |         | 401  |
      | PT_AU03_SlideShipped0 | NCI_MATCH_READONLY                |         | 401  |
      | PT_AU03_SlideShipped0 | NO_ROLE                           |         | 401  |
      | PT_AU03_SlideShipped1 | ADMIN                             | success | 202  |
      | PT_AU03_SlideShipped2 | SYSTEM                            |         | 401  |
      | PT_AU03_SlideShipped0 | ASSIGNMENT_REPORT_REVIEWER        |         | 401  |
      | PT_AU03_SlideShipped0 | MDA_VARIANT_REPORT_SENDER         |         | 401  |
      | PT_AU03_SlideShipped0 | MDA_VARIANT_REPORT_REVIEWER       |         | 401  |
      | PT_AU03_SlideShipped0 | MOCHA_VARIANT_REPORT_SENDER       |         | 401  |
      | PT_AU03_SlideShipped0 | MOCHA_VARIANT_REPORT_REVIEWER     |         | 401  |
      | PT_AU03_SlideShipped0 | DARTMOUTH_VARIANT_REPORT_SENDER   |         | 401  |
      | PT_AU03_SlideShipped0 | DARTMOUTH_VARIANT_REPORT_REVIEWER |         | 401  |
      | PT_AU03_SlideShipped0 | PATIENT_MESSAGE_SENDER            |         | 401  |
      | PT_AU03_SlideShipped0 | SPECIMEN_MESSAGE_SENDER           |         | 401  |
      | PT_AU03_SlideShipped3 | ASSAY_MESSAGE_SENDER              | success | 202  |

  @patients_p1
  Scenario Outline: PT_AU04 role base authorization works properly for patient variant report upload
    ######MDA_VARIANT_REPORT_SENDER and MOCHA_VARIANT_REPORT_SENDER are for ui user to upload files,
    ######variant report file upload message is only sent by ion ecosystem, so that should be SYSTEM role
    Given patient id is "<patient_id>"
    And load template variant file uploaded message for molecular id: "<patient_id>_MOI1"
    Then set patient message field: "analysis_id" to value: "<patient_id>_ANI1"
    Then set patient message field: "ion_reporter_id" to value: "bdd_test_ion_reporter"
    Then files for molecular_id "<patient_id>_MOI1" and analysis_id "<patient_id>_ANI1" are in S3
    And patient API user authorization role is "<auth_role>"
    When POST to MATCH variant report upload service, response includes "<message>" with code "<code>"
    Examples:
      | patient_id              | auth_role                         | message | code |
      | PT_AU04_MdaTsShipped0   | NO_TOKEN                          |         | 401  |
      | PT_AU04_MdaTsShipped0   | NCI_MATCH_READONLY                |         | 401  |
      | PT_AU04_MdaTsShipped0   | NO_ROLE                           |         | 401  |
      | PT_AU04_MdaTsShipped1   | ADMIN                             | success | 202  |
      | PT_AU04_MochaTsShipped1 | SYSTEM                            | success | 202  |
      | PT_AU04_MdaTsShipped0   | ASSIGNMENT_REPORT_REVIEWER        |         | 401  |
      | PT_AU04_MochaTsShipped0 | MDA_VARIANT_REPORT_SENDER         |         | 401  |
      | PT_AU04_MdaTsShipped2   | MDA_VARIANT_REPORT_SENDER         | success | 202  |
      | PT_AU04_DtmTsShipped0   | MDA_VARIANT_REPORT_SENDER         |         | 401  |
      | PT_AU04_MdaTsShipped3   | MDA_VARIANT_REPORT_REVIEWER       |         | 401  |
      | PT_AU04_MdaTsShipped0   | MOCHA_VARIANT_REPORT_SENDER       |         | 401  |
      | PT_AU04_MochaTsShipped2 | MOCHA_VARIANT_REPORT_SENDER       | success | 202  |
      | PT_AU04_DtmTsShipped0   | MOCHA_VARIANT_REPORT_SENDER       |         | 401  |
      | PT_AU04_MochaTsShipped3 | MOCHA_VARIANT_REPORT_REVIEWER     |         | 401  |
      | PT_AU04_MochaTsShipped0 | DARTMOUTH_VARIANT_REPORT_SENDER   |         | 401  |
      | PT_AU04_MdaTsShipped0   | DARTMOUTH_VARIANT_REPORT_SENDER   |         | 401  |
      | PT_AU04_DtmTsShipped1   | DARTMOUTH_VARIANT_REPORT_SENDER   | success | 202  |
      | PT_AU04_DtmTsShipped0   | DARTMOUTH_VARIANT_REPORT_REVIEWER |         | 401  |
      | PT_AU04_MdaTsShipped0   | PATIENT_MESSAGE_SENDER            |         | 401  |
      | PT_AU04_MochaTsShipped0 | SPECIMEN_MESSAGE_SENDER           |         | 401  |
      | PT_AU04_MdaTsShipped0   | ASSAY_MESSAGE_SENDER              |         | 401  |

  @patients_p3
  Scenario Outline: PT_AU05a role base authorization works properly for patient variant report confirm
    Given patient id is "<patient_id>"
    Then load template variant report confirm message for analysis id: "<patient_id>_ANI1"
    And patient API user authorization role is "<auth_role>"
    When PUT to MATCH variant report "confirm" service, response includes "<message>" with code "<code>"
    Examples:
      | patient_id                 | auth_role                         | message | code |
      | PT_AU05_MdaTsVrUploaded0   | NO_TOKEN                          |         | 401  |
      | PT_AU05_MdaTsVrUploaded0   | NCI_MATCH_READONLY                |         | 401  |
      | PT_AU05_MdaTsVrUploaded0   | NO_ROLE                           |         | 401  |
      | PT_AU05_MdaTsVrUploaded1   | ADMIN                             | success | 200  |
      | PT_AU05_MochaTsVrUploaded1 | SYSTEM                            |         | 401  |
      | PT_AU05_MdaTsVrUploaded0   | ASSIGNMENT_REPORT_REVIEWER        |         | 401  |
      | PT_AU05_MdaTsVrUploaded0   | MDA_VARIANT_REPORT_SENDER         |         | 401  |
      | PT_AU05_MdaTsVrUploaded2   | MDA_VARIANT_REPORT_REVIEWER       | success | 200  |
      | PT_AU05_MochaTsVrUploaded0 | MDA_VARIANT_REPORT_REVIEWER       |         | 401  |
      | PT_AU05_DtmTsVrUploaded0   | MDA_VARIANT_REPORT_REVIEWER       |         | 401  |
      | PT_AU05_MochaTsVrUploaded0 | MOCHA_VARIANT_REPORT_SENDER       |         | 401  |
      | PT_AU05_MochaTsVrUploaded2 | MOCHA_VARIANT_REPORT_REVIEWER     | success | 200  |
      | PT_AU05_MdaTsVrUploaded0   | MOCHA_VARIANT_REPORT_REVIEWER     |         | 401  |
      | PT_AU05_MdaTsVrUploaded0   | MOCHA_VARIANT_REPORT_REVIEWER     |         | 401  |
      | PT_AU05_DtmTsVrUploaded0   | DARTMOUTH_VARIANT_REPORT_SENDER   |         | 401  |
      | PT_AU05_DtmTsVrUploaded1   | DARTMOUTH_VARIANT_REPORT_REVIEWER | success | 200  |
      | PT_AU05_MochaTsVrUploaded0 | DARTMOUTH_VARIANT_REPORT_REVIEWER |         | 401  |
      | PT_AU05_MdaTsVrUploaded0   | DARTMOUTH_VARIANT_REPORT_REVIEWER |         | 401  |
      | PT_AU05_DtmTsVrUploaded0   | PATIENT_MESSAGE_SENDER            |         | 401  |
      | PT_AU05_MochaTsVrUploaded0 | SPECIMEN_MESSAGE_SENDER           |         | 401  |
      | PT_AU05_MdaTsVrUploaded0   | ASSAY_MESSAGE_SENDER              |         | 401  |

  @patients_p3
  Scenario Outline: PT_AU05b role base authorization works properly for patient variant confirm
    Given patient id is "<patient_id>"
    And a random variant for analysis id "<patient_id>_ANI1"
    And load template variant confirm message for this patient
    And patient API user authorization role is "<auth_role>"
    Then PUT to MATCH variant "<check>" service for this uuid, response includes "<message>" with code "<code>"
    Examples:
      | patient_id                 | auth_role                         | check     | message    | code |
      | PT_AU05_MdaTsVrUploaded0   | NO_TOKEN                          | unchecked |            | 401  |
      | PT_AU05_MdaTsVrUploaded0   | NCI_MATCH_READONLY                | unchecked |            | 401  |
      | PT_AU05_MdaTsVrUploaded0   | NO_ROLE                           | unchecked |            | 401  |
      | PT_AU05_MdaTsVrUploaded3   | ADMIN                             | unchecked | changed to | 200  |
      | PT_AU05_MochaTsVrUploaded3 | SYSTEM                            | checked   |            | 401  |
      | PT_AU05_MdaTsVrUploaded0   | ASSIGNMENT_REPORT_REVIEWER        | unchecked |            | 401  |
      | PT_AU05_MdaTsVrUploaded0   | MDA_VARIANT_REPORT_SENDER         | unchecked |            | 401  |
      | PT_AU05_MdaTsVrUploaded3   | MDA_VARIANT_REPORT_REVIEWER       | unchecked | changed to | 200  |
      | PT_AU05_MochaTsVrUploaded0 | MDA_VARIANT_REPORT_REVIEWER       | unchecked |            | 401  |
      | PT_AU05_DtmTsVrUploaded0   | MDA_VARIANT_REPORT_REVIEWER       | unchecked |            | 401  |
      | PT_AU05_MochaTsVrUploaded0 | MOCHA_VARIANT_REPORT_SENDER       | unchecked |            | 401  |
      | PT_AU05_MochaTsVrUploaded3 | MOCHA_VARIANT_REPORT_REVIEWER     | checked   | changed to | 200  |
      | PT_AU05_MdaTsVrUploaded0   | MOCHA_VARIANT_REPORT_REVIEWER     | unchecked |            | 401  |
      | PT_AU05_DtmTsVrUploaded0   | MOCHA_VARIANT_REPORT_REVIEWER     | unchecked |            | 401  |
      | PT_AU05_DtmTsVrUploaded0   | DARTMOUTH_VARIANT_REPORT_SENDER   | unchecked |            | 401  |
      | PT_AU05_DtmTsVrUploaded2   | DARTMOUTH_VARIANT_REPORT_REVIEWER | unchecked | changed to | 200  |
      | PT_AU05_MochaTsVrUploaded0 | DARTMOUTH_VARIANT_REPORT_REVIEWER | unchecked |            | 401  |
      | PT_AU05_MdaTsVrUploaded0   | DARTMOUTH_VARIANT_REPORT_REVIEWER | unchecked |            | 401  |
      | PT_AU05_MdaTsVrUploaded0   | PATIENT_MESSAGE_SENDER            | unchecked |            | 401  |
      | PT_AU05_MochaTsVrUploaded0 | SPECIMEN_MESSAGE_SENDER           | unchecked |            | 401  |
      | PT_AU05_MdaTsVrUploaded0   | ASSAY_MESSAGE_SENDER              | unchecked |            | 401  |

  @patients_p1
  Scenario Outline: PT_AU06 role base authorization works properly for patient assignment confirm
    Given patient id is "<patient_id>"
    And load template assignment report confirm message for analysis id: "<patient_id>_ANI1"
    And patient API user authorization role is "<auth_role>"
    When PUT to MATCH assignment report "confirm" service, response includes "<message>" with code "<code>"
    Examples:
      | patient_id                   | auth_role                         | message | code |
      | PT_AU06_PendingConfirmation0 | NO_TOKEN                          |         | 401  |
      | PT_AU06_PendingConfirmation0 | NCI_MATCH_READONLY                |         | 401  |
      | PT_AU06_PendingConfirmation0 | NO_ROLE                           |         | 401  |
      | PT_AU06_PendingConfirmation1 | ADMIN                             | success | 200  |
      | PT_AU06_PendingConfirmation2 | SYSTEM                            |         | 401  |
      | PT_AU06_PendingConfirmation3 | ASSIGNMENT_REPORT_REVIEWER        | success | 200  |
      | PT_AU06_PendingConfirmation0 | MDA_VARIANT_REPORT_SENDER         |         | 401  |
      | PT_AU06_PendingConfirmation0 | MDA_VARIANT_REPORT_REVIEWER       |         | 401  |
      | PT_AU06_PendingConfirmation0 | MOCHA_VARIANT_REPORT_SENDER       |         | 401  |
      | PT_AU06_PendingConfirmation0 | MOCHA_VARIANT_REPORT_REVIEWER     |         | 401  |
      | PT_AU06_PendingConfirmation0 | DARTMOUTH_VARIANT_REPORT_SENDER   |         | 401  |
      | PT_AU06_PendingConfirmation0 | DARTMOUTH_VARIANT_REPORT_REVIEWER |         | 401  |
      | PT_AU06_PendingConfirmation0 | PATIENT_MESSAGE_SENDER            |         | 401  |
      | PT_AU06_PendingConfirmation0 | SPECIMEN_MESSAGE_SENDER           |         | 401  |
      | PT_AU06_PendingConfirmation0 | ASSAY_MESSAGE_SENDER              |         | 401  |

  @patients_p1
  Scenario Outline: PT_AU07a role base authorization works properly for patient off study
    Given patient id is "<patient_id>"
    And load template off study message for this patient
    Then set patient message field: "step_number" to value: "1.0"
    And patient API user authorization role is "<auth_role>"
    When POST to MATCH patients service, response includes "<message>" with code "<code>"
    Examples:
      | patient_id          | auth_role                         | message | code |
      | PT_AU07_Registered0 | NO_TOKEN                          |         | 401  |
      | PT_AU07_Registered0 | NCI_MATCH_READONLY                |         | 401  |
      | PT_AU07_Registered0 | NO_ROLE                           |         | 401  |
      | PT_AU07_Registered1 | ADMIN                             | success | 202  |
      | PT_AU07_Registered2 | SYSTEM                            |         | 401  |
      | PT_AU07_Registered0 | ASSIGNMENT_REPORT_REVIEWER        |         | 401  |
      | PT_AU07_Registered0 | MDA_VARIANT_REPORT_SENDER         |         | 401  |
      | PT_AU07_Registered0 | MDA_VARIANT_REPORT_REVIEWER       |         | 401  |
      | PT_AU07_Registered0 | MOCHA_VARIANT_REPORT_SENDER       |         | 401  |
      | PT_AU07_Registered0 | MOCHA_VARIANT_REPORT_REVIEWER     |         | 401  |
      | PT_AU07_Registered0 | DARTMOUTH_VARIANT_REPORT_SENDER   |         | 401  |
      | PT_AU07_Registered0 | DARTMOUTH_VARIANT_REPORT_REVIEWER |         | 401  |
      | PT_AU07_Registered3 | PATIENT_MESSAGE_SENDER            | success | 202  |
      | PT_AU07_Registered0 | SPECIMEN_MESSAGE_SENDER           |         | 401  |
      | PT_AU07_Registered0 | ASSAY_MESSAGE_SENDER              |         | 401  |

    #no bio expired any more
  @patients_off
  Scenario Outline: PT_AU07b role base authorization works properly for patient off study biopsy expired
    Given patient id is "<patient_id>"
    And load template off study biopsy expired message for this patient
    Then set patient message field: "step_number" to value: "1.0"
    And patient API user authorization role is "<auth_role>"
    When POST to MATCH patients service, response includes "<message>" with code "<code>"
    Examples:
      | patient_id          | auth_role                         | message | code |
      | PT_AU07_TsReceived0 | NO_TOKEN                          |         | 401  |
      | PT_AU07_TsReceived0 | NCI_MATCH_READONLY                |         | 401  |
      | PT_AU07_TsReceived0 | NO_ROLE                           |         | 401  |
      | PT_AU07_TsReceived1 | ADMIN                             | success | 202  |
      | PT_AU07_TsReceived2 | SYSTEM                            |         | 401  |
      | PT_AU07_TsReceived0 | ASSIGNMENT_REPORT_REVIEWER        |         | 401  |
      | PT_AU07_TsReceived0 | MDA_VARIANT_REPORT_SENDER         |         | 401  |
      | PT_AU07_TsReceived0 | MDA_VARIANT_REPORT_REVIEWER       |         | 401  |
      | PT_AU07_TsReceived0 | MOCHA_VARIANT_REPORT_SENDER       |         | 401  |
      | PT_AU07_TsReceived0 | MOCHA_VARIANT_REPORT_REVIEWER     |         | 401  |
      | PT_AU07_TsReceived0 | DARTMOUTH_VARIANT_REPORT_SENDER   |         | 401  |
      | PT_AU07_TsReceived0 | DARTMOUTH_VARIANT_REPORT_REVIEWER |         | 401  |
      | PT_AU07_TsReceived3 | PATIENT_MESSAGE_SENDER            | success | 202  |
      | PT_AU07_TsReceived0 | SPECIMEN_MESSAGE_SENDER           |         | 401  |
      | PT_AU07_TsReceived0 | ASSAY_MESSAGE_SENDER              |         | 401  |

  @patients_p1
  Scenario Outline: PT_AU08a role base authorization works properly for patient request assignment
    Given patient id is "<patient_id>"
    And load template request assignment message for this patient
    Then set patient message field: "rebiopsy" to value: "<rebiopsy>"
    And set patient message field: "step_number" to value: "1.0"
    And patient API user authorization role is "<auth_role>"
    When POST to MATCH patients service, response includes "<message>" with code "<code>"
    Examples:
      | patient_id               | rebiopsy | auth_role                         | message | code |
      | PT_AU08_PendingApproval0 | Y        | NO_TOKEN                          |         | 401  |
      | PT_AU08_PendingApproval0 | Y        | NCI_MATCH_READONLY                |         | 401  |
      | PT_AU08_PendingApproval0 | Y        | NO_ROLE                           |         | 401  |
      | PT_AU08_PendingApproval1 | N        | ADMIN                             | success | 202  |
      | PT_AU08_PendingApproval2 | Y        | SYSTEM                            |         | 401  |
      | PT_AU08_PendingApproval0 | Y        | ASSIGNMENT_REPORT_REVIEWER        |         | 401  |
      | PT_AU08_PendingApproval0 | Y        | MDA_VARIANT_REPORT_SENDER         |         | 401  |
      | PT_AU08_PendingApproval0 | Y        | MDA_VARIANT_REPORT_REVIEWER       |         | 401  |
      | PT_AU08_PendingApproval0 | N        | MOCHA_VARIANT_REPORT_SENDER       |         | 401  |
      | PT_AU08_PendingApproval0 | N        | MOCHA_VARIANT_REPORT_REVIEWER     |         | 401  |
      | PT_AU08_PendingApproval0 | Y        | DARTMOUTH_VARIANT_REPORT_SENDER   |         | 401  |
      | PT_AU08_PendingApproval0 | N        | DARTMOUTH_VARIANT_REPORT_REVIEWER |         | 401  |
      | PT_AU08_PendingApproval3 | Y        | PATIENT_MESSAGE_SENDER            | success | 202  |
      | PT_AU08_PendingApproval4 | N        | PATIENT_MESSAGE_SENDER            | success | 202  |
      | PT_AU08_PendingApproval0 | Y        | SPECIMEN_MESSAGE_SENDER           |         | 401  |
      | PT_AU08_PendingApproval0 | N        | ASSAY_MESSAGE_SENDER              |         | 401  |

  @patients_p3
  Scenario Outline: PT_AU08b role base authorization works properly for patient request no assignment
    Given patient id is "<patient_id>"
    And load template request no assignment message for this patient
    And set patient message field: "step_number" to value: "1.0"
    And patient API user authorization role is "<auth_role>"
    When POST to MATCH patients service, response includes "<message>" with code "<code>"
    Examples:
      | patient_id               | auth_role                         | message | code |
      | PT_AU08_PendingApproval0 | NO_TOKEN                          |         | 401  |
      | PT_AU08_PendingApproval0 | NCI_MATCH_READONLY                |         | 401  |
      | PT_AU08_PendingApproval0 | NO_ROLE                           |         | 401  |
      | PT_AU08_PendingApproval5 | ADMIN                             | success | 202  |
      | PT_AU08_PendingApproval6 | SYSTEM                            |         | 401  |
      | PT_AU08_PendingApproval0 | ASSIGNMENT_REPORT_REVIEWER        |         | 401  |
      | PT_AU08_PendingApproval0 | MDA_VARIANT_REPORT_SENDER         |         | 401  |
      | PT_AU08_PendingApproval0 | MDA_VARIANT_REPORT_REVIEWER       |         | 401  |
      | PT_AU08_PendingApproval0 | MOCHA_VARIANT_REPORT_SENDER       |         | 401  |
      | PT_AU08_PendingApproval0 | MOCHA_VARIANT_REPORT_REVIEWER     |         | 401  |
      | PT_AU08_PendingApproval0 | DARTMOUTH_VARIANT_REPORT_SENDER   |         | 401  |
      | PT_AU08_PendingApproval0 | DARTMOUTH_VARIANT_REPORT_REVIEWER |         | 401  |
      | PT_AU08_PendingApproval7 | PATIENT_MESSAGE_SENDER            | success | 202  |
      | PT_AU08_PendingApproval0 | SPECIMEN_MESSAGE_SENDER           |         | 401  |
      | PT_AU08_PendingApproval0 | ASSAY_MESSAGE_SENDER              |         | 401  |

  @patients_p1
  Scenario Outline: PT_AU09 role base authorization works properly for patient on treatment arm
    Given patient id is "<patient_id>"
    Then load template on treatment arm confirm message for this patient
    Then set patient message field: "treatment_arm_id" to value: "APEC1621-A"
    Then set patient message field: "stratum_id" to value: "100"
    Then set patient message field: "step_number" to value: "1.1"
    And patient API user authorization role is "<auth_role>"
    When POST to MATCH patients service, response includes "<message>" with code "<code>"
#    Then wait for "1" seconds
    Examples:
      | patient_id               | auth_role                         | message | code |
      | PT_AU09_PendingApproval0 | NO_TOKEN                          |         | 401  |
      | PT_AU09_PendingApproval0 | NCI_MATCH_READONLY                |         | 401  |
      | PT_AU09_PendingApproval0 | NO_ROLE                           |         | 401  |
      | PT_AU09_PendingApproval1 | ADMIN                             | success | 202  |
      | PT_AU09_PendingApproval2 | SYSTEM                            |         | 401  |
      | PT_AU09_PendingApproval0 | ASSIGNMENT_REPORT_REVIEWER        |         | 401  |
      | PT_AU09_PendingApproval0 | MDA_VARIANT_REPORT_SENDER         |         | 401  |
      | PT_AU09_PendingApproval0 | MDA_VARIANT_REPORT_REVIEWER       |         | 401  |
      | PT_AU09_PendingApproval0 | MOCHA_VARIANT_REPORT_SENDER       |         | 401  |
      | PT_AU09_PendingApproval0 | MOCHA_VARIANT_REPORT_REVIEWER     |         | 401  |
      | PT_AU09_PendingApproval0 | DARTMOUTH_VARIANT_REPORT_SENDER   |         | 401  |
      | PT_AU09_PendingApproval0 | DARTMOUTH_VARIANT_REPORT_REVIEWER |         | 401  |
      | PT_AU09_PendingApproval3 | PATIENT_MESSAGE_SENDER            | success | 202  |
      | PT_AU09_PendingApproval0 | SPECIMEN_MESSAGE_SENDER           |         | 401  |
      | PT_AU09_PendingApproval0 | ASSAY_MESSAGE_SENDER              |         | 401  |

  @patients_p1
  Scenario Outline: PT_AU10 role base authorization works properly for patient GET
    Given patient GET service: "<service>", patient id: "<patient_id>", id: "<id>"
    And patient API user authorization role is "<auth_role>"
    When GET from MATCH patient API, http code "<code>" should return
    Examples:
      | service               | patient_id                 | id                       | auth_role                         | code |
      |                       |                            |                          | NO_TOKEN                          | 401  |
      | statistics            |                            |                          | NCI_MATCH_READONLY                | 200  |
      | patient_limbos        |                            |                          | NO_ROLE                           | 401  |
      | events                |                            |                          | ADMIN                             | 200  |
      | variant_reports       |                            | PT_GVF_RARebioY_ANI1     | SYSTEM                            | 200  |
      | treatment_arm_history | PT_SC06a_PendingApproval   |                          | ASSIGNMENT_REPORT_REVIEWER        | 200  |
      | specimens             | PT_GVF_RequestNoAssignment |                          | MDA_VARIANT_REPORT_SENDER         | 200  |
      | shipments             |                            |                          | MDA_VARIANT_REPORT_REVIEWER       | 200  |
      | specimen_events       | PT_GVF_VrAssayReady        |                          | MOCHA_VARIANT_REPORT_SENDER       | 200  |
      | patient_limbos        |                            |                          | MOCHA_VARIANT_REPORT_REVIEWER     | 200  |
      | pending_items         |                            |                          | DARTMOUTH_VARIANT_REPORT_SENDER   | 200  |
      | amois                 |                            |                          | DARTMOUTH_VARIANT_REPORT_REVIEWER | 200  |
      | shipments             |                            |                          | PATIENT_MESSAGE_SENDER            | 200  |
      | action_items          | PT_GVF_TsVrUploaded        |                          | SPECIMEN_MESSAGE_SENDER           | 200  |
      | analysis_report       | PT_GVF_VrAssayReady        | PT_GVF_VrAssayReady_ANI1 | ASSAY_MESSAGE_SENDER              | 200  |

  @patients_p1
  Scenario Outline: PT_AU11 role base authorization works properly for allowing user upload variant file from UI
    Given patient GET service: "specimen_events", patient id: "PT_AU11_MdaTsShipped", id: ""
    And patient API user authorization role is "<auth_role>"
    When GET from MATCH patient API, http code "200" should return
    And this patient tissue specimen_events "PT_AU11_MdaTsShipped_MOI1" allow_upload field should be "<allow1>"
    Then patient GET service: "specimen_events", patient id: "PT_AU11_MochaTsShipped", id: ""
    When GET from MATCH patient API, http code "200" should return
    And this patient tissue specimen_events "PT_AU11_MochaTsShipped_MOI1" allow_upload field should be "<allow2>"
    Then patient GET service: "specimen_events", patient id: "PT_AU11_DtmTsShipped", id: ""
    When GET from MATCH patient API, http code "200" should return
    And this patient tissue specimen_events "PT_AU11_DtmTsShipped_MOI1" allow_upload field should be "<allow3>"
    Examples:
      | auth_role                         | allow1 | allow2 | allow3 |
      | NCI_MATCH_READONLY                | false  | false  | false  |
      | ADMIN                             | true   | true   | true   |
      | SYSTEM                            | false  | false  | false  |
      | ASSIGNMENT_REPORT_REVIEWER        | false  | false  | false  |
      | MDA_VARIANT_REPORT_SENDER         | true   | false  | false  |
      | MDA_VARIANT_REPORT_REVIEWER       | false  | false  | false  |
      | MOCHA_VARIANT_REPORT_SENDER       | false  | true   | false  |
      | MOCHA_VARIANT_REPORT_REVIEWER     | false  | false  | false  |
      | DARTMOUTH_VARIANT_REPORT_SENDER   | false  | false  | true   |
      | DARTMOUTH_VARIANT_REPORT_REVIEWER | false  | false  | false  |
      | PATIENT_MESSAGE_SENDER            | false  | false  | false  |
      | SPECIMEN_MESSAGE_SENDER           | false  | false  | false  |
      | ASSAY_MESSAGE_SENDER              | false  | false  | false  |

  @patients_p1
  Scenario Outline: PT_AU12 role base authorization works properly for creating patient event
    Given patient id is "<patient_id>"
    And patient API user authorization role is "<role>"
    And load template variant file uploaded event message for this patient
    Then set patient variant file uploaded event message field: "analysis_id" to value: "<patient_id>_ANI1"
    Then set patient variant file uploaded event message field: "site" to value: "<site>"
    Then set patient variant file uploaded event message field: "molecular_id" to value: "<patient_id>_MOI1"
    When POST to MATCH patients event service, response includes "<message>" with code "<code>"
    Examples:
      | patient_id             | site      | role                              | message | code |
      | PT_AU12_TsShippedToMda | mocha     | NCI_MATCH_READONLY                |         | 401  |
      | PT_AU12_TsShippedToMda | mda       | ADMIN                             | success | 200  |
      | PT_AU12_TsShippedToDtm | dartmouth | SYSTEM                            | success | 200  |
      | PT_AU12_TsShippedToMca | mocha     | ASSIGNMENT_REPORT_REVIEWER        |         | 401  |
      | PT_AU12_TsShippedToMda | mda       | MDA_VARIANT_REPORT_SENDER         | success | 200  |
      | PT_AU12_TsShippedToMda | mda       | MDA_VARIANT_REPORT_REVIEWER       |         | 401  |
      | PT_AU12_TsShippedToMca | mocha     | MOCHA_VARIANT_REPORT_SENDER       | success | 200  |
      | PT_AU12_TsShippedToMca | mocha     | MOCHA_VARIANT_REPORT_REVIEWER     |         | 401  |
      | PT_AU12_TsShippedToDtm | dartmouth | DARTMOUTH_VARIANT_REPORT_SENDER   | success | 200  |
      | PT_AU12_TsShippedToDtm | dartmouth | DARTMOUTH_VARIANT_REPORT_REVIEWER |         | 401  |
      | PT_AU12_TsShippedToMda | mda       | PATIENT_MESSAGE_SENDER            |         | 401  |
      | PT_AU12_TsShippedToMca | mocha     | SPECIMEN_MESSAGE_SENDER           |         | 401  |
      | PT_AU12_TsShippedToDtm | dartmouth | ASSAY_MESSAGE_SENDER              |         | 401  |

  @patients_p1_off
  Scenario Outline: PT_AU13 role base authorization works properly for rollback
    Given patient id is "<patient_id>"
    And patient API user authorization role is "<role>"
    When PUT to MATCH rollback with step number "1.0", response includes "<message>" with code "<code>"
    Examples:
      | patient_id             | role                              | message | code |
      | PT_AU13_TsVrConfirmed2 | NCI_MATCH_READONLY                |         | 401  |
      | PT_AU13_TsVrConfirmed1 | ADMIN                             | success | 200  |
      | PT_AU13_TsVrConfirmed2 | SYSTEM                            |         | 401  |
      | PT_AU13_TsVrConfirmed2 | ASSIGNMENT_REPORT_REVIEWER        |         | 401  |
      | PT_AU13_TsVrConfirmed2 | MDA_VARIANT_REPORT_SENDER         |         | 401  |
      | PT_AU13_TsVrConfirmed2 | MDA_VARIANT_REPORT_REVIEWER       |         | 401  |
      | PT_AU13_TsVrConfirmed2 | MOCHA_VARIANT_REPORT_SENDER       |         | 401  |
      | PT_AU13_TsVrConfirmed2 | MOCHA_VARIANT_REPORT_REVIEWER     |         | 401  |
      | PT_AU13_TsVrConfirmed2 | DARTMOUTH_VARIANT_REPORT_SENDER   |         | 401  |
      | PT_AU13_TsVrConfirmed2 | DARTMOUTH_VARIANT_REPORT_REVIEWER |         | 401  |
      | PT_AU13_TsVrConfirmed2 | PATIENT_MESSAGE_SENDER            |         | 401  |
      | PT_AU13_TsVrConfirmed2 | SPECIMEN_MESSAGE_SENDER           |         | 401  |
      | PT_AU13_TsVrConfirmed2 | ASSAY_MESSAGE_SENDER              |         | 401  |


  @patients_p1
  Scenario Outline: PT_AU15 role base authorization works properly for editable field in assignment reports
    Given patient GET service: "analysis_report", patient id: "<patient_id>", id: "<patient_id>_ANI1"
    And patient API user authorization role is "<role>"
    When GET from MATCH patient API, http code "200" should return
    Then this patient analysis_report should have assignment report editable: "<editable>"
    Examples:
      | patient_id                  | role                              | editable |
      | PT_AU15_PendingConfirmation | NCI_MATCH_READONLY                | false    |
      | PT_AU15_PendingConfirmation | ADMIN                             | true     |
      | PT_AU15_PendingConfirmation | SYSTEM                            | false    |
      | PT_AU15_PendingConfirmation | ASSIGNMENT_REPORT_REVIEWER        | true     |
      | PT_AU15_PendingConfirmation | MDA_VARIANT_REPORT_SENDER         | false    |
      | PT_AU15_PendingConfirmation | MDA_VARIANT_REPORT_REVIEWER       | false    |
      | PT_AU15_PendingConfirmation | MOCHA_VARIANT_REPORT_SENDER       | false    |
      | PT_AU15_PendingConfirmation | MOCHA_VARIANT_REPORT_REVIEWER     | false    |
      | PT_AU15_PendingConfirmation | DARTMOUTH_VARIANT_REPORT_SENDER   | false    |
      | PT_AU15_PendingConfirmation | DARTMOUTH_VARIANT_REPORT_REVIEWER | false    |
      | PT_AU15_PendingConfirmation | PATIENT_MESSAGE_SENDER            | false    |
      | PT_AU15_PendingConfirmation | SPECIMEN_MESSAGE_SENDER           | false    |
      | PT_AU15_PendingConfirmation | ASSAY_MESSAGE_SENDER              | false    |

  @patients_p1
  Scenario Outline: PT_AU16 role base authorization works properly for editable field in variant reports
    Given patient GET service: "analysis_report", patient id: "PT_AU16_MdaVrUploaded", id: "PT_AU16_MdaVrUploaded_ANI1"
    And patient API user authorization role is "<role>"
    When GET from MATCH patient API, http code "200" should return
    Then this patient analysis_report should have variant report editable: "<mda_editable>"
    Given patient GET service: "analysis_report", patient id: "PT_AU16_McaVrUploaded", id: "PT_AU16_McaVrUploaded_ANI1"
    And patient API user authorization role is "<role>"
    When GET from MATCH patient API, http code "200" should return
    Then this patient analysis_report should have variant report editable: "<mca_editable>"
    Given patient GET service: "analysis_report", patient id: "PT_AU16_DtmVrUploaded", id: "PT_AU16_DtmVrUploaded_ANI1"
    And patient API user authorization role is "<role>"
    When GET from MATCH patient API, http code "200" should return
    Then this patient analysis_report should have variant report editable: "<dtm_editable>"
    Examples:
      | role                              | mda_editable | mca_editable | dtm_editable |
      | NCI_MATCH_READONLY                | false        | false        | false        |
      | ADMIN                             | true         | true         | true         |
      | SYSTEM                            | false        | false        | false        |
      | ASSIGNMENT_REPORT_REVIEWER        | false        | false        | false        |
      | MDA_VARIANT_REPORT_SENDER         | false        | false        | false        |
      | MDA_VARIANT_REPORT_REVIEWER       | true         | false        | false        |
      | MOCHA_VARIANT_REPORT_SENDER       | false        | false        | false        |
      | MOCHA_VARIANT_REPORT_REVIEWER     | false        | true         | false        |
      | DARTMOUTH_VARIANT_REPORT_SENDER   | false        | false        | false        |
      | DARTMOUTH_VARIANT_REPORT_REVIEWER | false        | false        | true         |
      | PATIENT_MESSAGE_SENDER            | false        | false        | false        |
      | SPECIMEN_MESSAGE_SENDER           | false        | false        | false        |
      | ASSAY_MESSAGE_SENDER              | false        | false        | false        |

  @patients_p2
  Scenario Outline: PT_AU17a certain user can change auth0 password properly
    Given patient API user authorization role is "<role>"
    Then create a new auth0 password
    When PATCH to MATCH account password change service, response includes "200" with code "200"
    Then apply auth0 token using "new" password, response includes "id_token" with code "200"
    Then apply auth0 token using "old" password, response includes "password" with code "401"
    Examples:
      | role                    |
      | ADMIN                   |
      | PATIENT_MESSAGE_SENDER  |
      | SPECIMEN_MESSAGE_SENDER |
      | ASSAY_MESSAGE_SENDER    |

  @patients_p2
  Scenario Outline: PT_AU17b certain user is not allowed to use auth0 password change service
    Given patient API user authorization role is "<role>"
    Then create a new auth0 password
    When PATCH to MATCH account password change service, response includes "authorized" with code "401"
    Examples:
      | role                              |
      | SYSTEM                            |
      | ASSIGNMENT_REPORT_REVIEWER        |
      | MDA_VARIANT_REPORT_SENDER         |
      | MDA_VARIANT_REPORT_REVIEWER       |
      | MOCHA_VARIANT_REPORT_SENDER       |
      | MOCHA_VARIANT_REPORT_REVIEWER     |
      | DARTMOUTH_VARIANT_REPORT_SENDER   |
      | DARTMOUTH_VARIANT_REPORT_REVIEWER |

