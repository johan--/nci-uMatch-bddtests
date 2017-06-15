@patients_get
Feature: Patient GET service valid special case tests
###### all tests in this feature will use default ADMIN authorization role, because role base auth test for those
  #### POST and PUT service has been tested in other tests, those are not the purpose of these tes
  @patients_p2
  Scenario: PT_SC01a statistics service should have correct result
    Given patient GET service: "statistics", patient id: "", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then patient statistics field "number_of_patients" should have correct value
    Then patient statistics field "number_of_patients_on_treatment_arm" should have correct value
    Then patient statistics field "number_of_patients_with_confirmed_variant_report" should have correct value
    Then patient statistics field "treatment_arm_accrual" should have correct value

  @patients_p2
  Scenario: PT_SC01b statistics service should update number_of_patients properly
    Given patient id is "PT_SC01b_New"
    And load template registration message for this patient
    Then set patient message field: "status_date" to value: "current"
    Then POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "REGISTRATION"
    Then patient GET service: "statistics", patient id: "", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then patient statistics field "number_of_patients" should have correct value

  @patients_p2
  Scenario Outline: PT_SC01c statistics service should update number_of_patients_with_confirmed_variant_report properly
    Given patient id is "<patient_id>"
    Then load template variant report confirm message for analysis id: "<ani>"
    When PUT to MATCH variant report "confirm" service, response includes "changed successfully to" with code "200"
    Then patient status should change to "TISSUE_VARIANT_REPORT_CONFIRMED"
    Then patient GET service: "statistics", patient id: "", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then patient statistics field "number_of_patients_with_confirmed_variant_report" should have correct value
    Examples:
      | patient_id                 | ani                             |
      | PT_SC01c_TsVrUploaded      | PT_SC01c_TsVrUploaded_ANI1      |
      | PT_SC01c_TsVrUploadedStep2 | PT_SC01c_TsVrUploadedStep2_ANI2 |

  @patients_p2
  Scenario Outline: PT_SC01d statistics service should update treatment arm values properly
    Given patient id is "<patient_id>"
    Then load template on treatment arm confirm message for this patient
    Then set patient message field: "treatment_arm_id" to value: "<ta_id>"
    Then set patient message field: "stratum_id" to value: "<stratum>"
    Then set patient message field: "step_number" to value: "<step>"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "ON_TREATMENT_ARM"
    Then patient GET service: "statistics", patient id: "", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then patient statistics field "number_of_patients_on_treatment_arm" should have correct value
    Then patient statistics field "treatment_arm_accrual" should have correct value
    Examples:
      | patient_id                    | ta_id          | stratum | step |
      | PT_SC01d_PendingApproval      | APEC1621-A     | 100     | 1.1  |
      | PT_SC01d_PendingApprovalStep2 | APEC1621-ETE-A | 100     | 2.1  |

  @patients_p3
  Scenario: PT_SC02a pending_items should have correct result
    #this test is very difficult to get accurate result when cucumber runs in parallel mode, because during this test running time
    #the other test is running and the test could be confirming VR AR or uploading VR, that will change the result of pending_items
    #so as long as the rest of PT_SC02 tests pass, this feature is good enough
    Given patient GET service: "pending_items", patient id: "", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then patient pending_items field "tissue_variant_reports" should have correct value
    Then patient pending_items field "assignment_reports" should have correct value

  @patients_p1
  Scenario Outline: PT_SC02b pending_items should increase tissue_variant_reports value properly
    Given patient id is "<patient_id>"
    And load template variant file uploaded message for molecular id: "<moi>"
    Then set patient message field: "analysis_id" to value: "<ani>"
    Then files for molecular_id "<moi>" and analysis_id "<ani>" are in S3
    When POST to MATCH variant report upload service, response includes "successfully" with code "202"
    Then patient status should change to "TISSUE_VARIANT_REPORT_RECEIVED"
    Then patient GET service: "pending_items", patient id: "", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "1" patient "<pending_type>" pending_items have field: "analysis_id" value: "<ani>"
    Examples:
      | patient_id         | moi                     | ani                     | pending_type           |
      | PT_SC02b_TsShipped | PT_SC02b_TsShipped_MOI1 | PT_SC02b_TsShipped_ANI1 | tissue_variant_reports |

  @patients_p1
  Scenario Outline: PT_SC02c pending_items should decrease tissue_variant_reports value properly
    Given patient id is "<patient_id>"
    And load template variant report confirm message for analysis id: "<ani>"
    When PUT to MATCH variant report "confirm" service, response includes "changed successfully to" with code "200"
    Then patient status should change to "TISSUE_VARIANT_REPORT_CONFIRMED"
    Then patient GET service: "pending_items", patient id: "", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "0" patient "<pending_type>" pending_items have field: "analysis_id" value: "<ani>"
    Examples:
      | patient_id            | ani                        | pending_type           |
      | PT_SC02c_TsVrUploaded | PT_SC02c_TsVrUploaded_ANI1 | tissue_variant_reports |

  @patients_p1
  Scenario Outline: PT_SC02d pending_items should increase assignment_reports value properly
    Given patient id is "<patient_id>"
    And load template variant report confirm message for analysis id: "<ani>"
    When PUT to MATCH variant report "confirm" service, response includes "changed successfully to" with code "200"
    Then patient status should change to "PENDING_CONFIRMATION"
    Then patient GET service: "pending_items", patient id: "", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "0" patient "tissue_variant_reports" pending_items have field: "analysis_id" value: "<ani>"
    Then there are "1" patient "assignment_reports" pending_items have field: "analysis_id" value: "<ani>"
    Examples:
      | patient_id            | ani                        |
      | PT_SC02d_VrAssayReady | PT_SC02d_VrAssayReady_ANI1 |

  @patients_p1
  Scenario Outline: PT_SC02e pending_items should decrease assignment_reports value properly
    Given patient id is "<patient_id>"
    And load template assignment report confirm message for analysis id: "<ani>"
    When PUT to MATCH assignment report "confirm" service, response includes "changed successfully to" with code "200"
    Then patient status should change to "PENDING_APPROVAL"
    Then patient GET service: "pending_items", patient id: "", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "0" patient "<pending_type>" pending_items have field: "analysis_id" value: "<ani>"
    Examples:
      | patient_id                   | ani                               | pending_type       |
      | PT_SC02e_PendingConfirmation | PT_SC02e_PendingConfirmation_ANI1 | assignment_reports |

  @patients_p1
  Scenario Outline: PT_SC02f pending_items should remove patient once this patient change to OFF_STUDY
    Given patient id is "<patient_id>"
    And load template off study message for this patient
    Then set patient message field: "step_number" to value: "1.0"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "OFF_STUDY"
    Then patient GET service: "pending_items", patient id: "", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "0" patient "tissue_variant_reports" pending_items have field: "analysis_id" value: "<ani>"
    Then there are "0" patient "assignment_reports" pending_items have field: "analysis_id" value: "<ani>"
    Examples:
      | patient_id                   | ani                               |
      | PT_SC02f_TsVrUploaded        | PT_SC02f_TsVrUploaded_ANI1        |
      | PT_SC02f_PendingConfirmation | PT_SC02f_PendingConfirmation_ANI1 |

    #no bio expired any more
  @patients_off
  Scenario Outline: PT_SC02g pending_items should remove patient once this patient change to OFF_STUDY_BIOPSY_EXPIRED
    Given patient id is "<patient_id>"
    And load template off study biopsy expired message for this patient
    Then set patient message field: "step_number" to value: "1.0"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "OFF_STUDY_BIOPSY_EXPIRED"
    Then patient GET service: "pending_items", patient id: "", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "0" patient "tissue_variant_reports" pending_items have field: "analysis_id" value: "<ani>"
    Then there are "0" patient "assignment_reports" pending_items have field: "analysis_id" value: "<ani>"
    Examples:
      | patient_id                   | ani                               |
      | PT_SC02g_TsVrUploaded        | PT_SC02g_TsVrUploaded_ANI1        |
      | PT_SC02g_PendingConfirmation | PT_SC02g_PendingConfirmation_ANI1 |

  @patients_p2_off
  Scenario: PT_SC03a amois should have correct values
    Given patient GET service: "amois", patient id: "", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then patient amois should have correct value

  @patients_p2_off
  Scenario Outline: PT_SC03b amois values can be updated properly
    Given patient id is "<patient_id>"
    Then load template variant file uploaded message for molecular id: "<moi>"
    Then set patient message field: "analysis_id" to value: "<ani>"
    Then files for molecular_id "<moi>" and analysis_id "<ani>" are in S3
    When POST to MATCH variant report upload service, response includes "successfully" with code "202"
    Then patient status should change to "TISSUE_VARIANT_REPORT_RECEIVED"
    Then patient GET service: "amois", patient id: "", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then patient amois should have correct value
    Examples:
      | patient_id              | moi                          | ani                          |
      | PT_SC03b_TsShipped      | PT_SC03b_TsShipped_MOI1      | PT_SC03b_TsShipped_ANI1      |
      | PT_SC03b_TsShippedStep2 | PT_SC03b_TsShippedStep2_MOI2 | PT_SC03b_TsShippedStep2_ANI2 |

  @patients_p1
  Scenario: PT_SC04a patient_limbos should not have record for patients with certain status
    Given patient GET service: "patient_limbos", patient id: "", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "0" patient_limbos have field: "current_status" value: "REGISTRATION"
    Then there are "0" patient_limbos have field: "current_status" value: "OFF_STUDY"
    Then there are "0" patient_limbos have field: "current_status" value: "REQUEST_ASSIGNMENT"
    Then there are "0" patient_limbos have field: "current_status" value: "REQUEST_NO_ASSIGNMENT"
    Then there are "0" patient_limbos have field: "current_status" value: "ON_TREATMENT_ARM"
    Then there are "0" patient_limbos have field: "current_status" value: "COMPASSIONATE_CARE"
    Then there are "0" patient_limbos have field: "current_status" value: "NO_TA_AVAILABLE"
    #new requirement want pending_confirmation shows in limbo as well
#    Then there are "0" patient_limbos have field: "current_status" value: "PENDING_CONFIRMATION"
    #no bio expired any more
#    Then there are "0" patient_limbos have field: "current_status" value: "OFF_STUDY_BIOPSY_EXPIRED"

  @patients_p1
  Scenario Outline: PT_SC04b patient_limbos should have correct value
    Given patient id is "<patient_id>"
    And patient GET service: "patient_limbos", patient id: "", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "1" patient_limbos have field: "patient_id" value: "<patient_id>"
    Then this patient patient_limbos field "current_status" should be correct
    Then this patient patient_limbos field "active_tissue_specimen" should be correct
    Then this patient patient_limbos should have "<count>" messages which contain "<contain_message>"
    Then this patient patient_limbos days_pending should be correct
    Then this patient patient_limbos has_amoi should be "<amoi>"
    Examples:
      | patient_id                   | count | contain_message         | amoi  |
      | PT_SC04b_TsReceived          | 2     | Tissue-Slide            | false |
      | PT_SC04b_TsShippedNoSd       | 2     | Variant-Slide           | false |
      | PT_SC04b_SdShippedNoTs       | 4     | Tissue-BAF47-BRG1-PTEN  | false |
      | PT_SC04b_TsSdShipped         | 4     | Variant-BAF47-BRG1-PTEN | false |
      | PT_SC04b_TsVrUploadedNoSd    | 2     | confirmed-Slide         | true  |
      | PT_SC04b_TsVrConfirmedAndSd  | 3     | PTEN-BAF47-BRG1         | true  |
      | PT_SC04b_TsVrConfirmedNoSd   | 1     | Slide                   | true  |
      | PT_SC04b_VrConfirmedOneAssay | 2     | BAF47-BRG1              | true  |
      | PT_SC04b_TsShippedTwoAssay   | 2     | BAF47-Variant           | false |
      | PT_SC04b_ThreeAssayNoTs      | 1     | Tissue                  | false |
      | PT_SC04b_ThreeAssayAndTs     | 1     | Variant                 | false |
      | PT_SC04b_PendingConfirmation | 1     | assignment              | true  |
      | PT_SC04b_PendingApproval     | 1     | approval                | true  |
      | UI_PA09_TsVr52Uploaded       | 2     | confirmed-Slide         | false |

  @patients_p1
  Scenario: PT_SC04c patient_limbos should update properly after tissue is shipped
    Given patient id is "PT_SC04c_TsReceived"
    And load template specimen type: "TISSUE" shipped message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_SC04c_TsReceived_SEI1"
    Then set patient message field: "molecular_id" to value: "PT_SC04c_TsReceived_MOI1"
    Then set patient message field: "shipped_dttm" to value: "current"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "TISSUE_NUCLEIC_ACID_SHIPPED"
    Then patient GET service: "patient_limbos", patient id: "", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "1" patient_limbos have field: "patient_id" value: "PT_SC04c_TsReceived"
    Then this patient patient_limbos field "current_status" should be correct
    Then this patient patient_limbos field "active_tissue_specimen" should be correct
    Then this patient patient_limbos should have "2" messages which contain "Variant-Slide"
    Then this patient patient_limbos days_pending should be correct

  @patients_p1
  Scenario Outline: PT_SC04d patient_limbos should update properly after assay is received
    Given patient id is "<patient_id>"
    And load template assay message for this patient
    Then set patient message field: "surgical_event_id" to value: "<patient_id>_SEI1"
    Then set patient message field: "biomarker" to value: "<biomarker>"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then wait until patient specimen is updated
    Then patient GET service: "patient_limbos", patient id: "", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "1" patient_limbos have field: "patient_id" value: "<patient_id>"
    Then this patient patient_limbos field "current_status" should be correct
    Then this patient patient_limbos field "active_tissue_specimen" should be correct
    Then this patient patient_limbos should have "<count>" messages which contain "<contain_message>"
    Then this patient patient_limbos days_pending should be correct
    Examples:
      | patient_id        | biomarker | count | contain_message    |
      | PT_SC04d_NoAssay  | ICCPTENs  | 3     | variant-BAF47-BRG1 |
      | PT_SC04d_OneAssay | ICCBAF47s | 2     | variant-BRG1       |
      | PT_SC04d_TwoAssay | ICCBRG1s  | 1     | variant            |

  @patients_p1
  Scenario Outline: PT_SC04e patient_limbos should update properly after variant report is confirmed
    Given patient id is "<patient_id>"
    Then load template variant report confirm message for analysis id: "<patient_id>_ANI1"
    When PUT to MATCH variant report "<confirm>" service, response includes "changed successfully to" with code "200"
    Then patient status should change to "<status>"
    Then patient GET service: "patient_limbos", patient id: "", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "1" patient_limbos have field: "patient_id" value: "<patient_id>"
    Then this patient patient_limbos field "current_status" should be correct
    Then this patient patient_limbos field "active_tissue_specimen" should be correct
    Then this patient patient_limbos should have "<count>" messages which contain "<messages>"
    Then this patient patient_limbos days_pending should be correct
    Then this patient patient_limbos has_amoi should be "<amoi>"
    Examples:
      | patient_id             | confirm | status                          | count | messages        | amoi  |
      | PT_SC04e_TsVrUploaded1 | confirm | TISSUE_VARIANT_REPORT_CONFIRMED | 3     | PTEN-BAF47-BRG1 | true  |
      | PT_SC04e_TsVrUploaded2 | reject  | TISSUE_VARIANT_REPORT_REJECTED  | 4     | variant         | false |

  @patients_p1
  Scenario Outline: PT_SC04f patient_limbos should update properly after new tissue specimen is received
    Given patient id is "<patient_id>"
    Then patient GET service: "patient_limbos", patient id: "", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "<old>" patient_limbos have field: "patient_id" value: "<patient_id>"
    And load template specimen type: "TISSUE" received message for this patient
    Then set patient message field: "surgical_event_id" to value: "<sei>"
    Then set patient message field: "collection_dt" to value: "<date>"
    Then set patient message field: "received_dttm" to value: "<time>"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "TISSUE_SPECIMEN_RECEIVED"
    Then patient GET service: "patient_limbos", patient id: "", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "1" patient_limbos have field: "patient_id" value: "<patient_id>"
    And this patient patient_limbos has_amoi should be "false"
    Examples:
      | patient_id                 | sei                             | date       | time                      | old |
      | PT_SC04f_Registered1       | PT_SC04f_Registered1_SEI1       | today      | current                   | 0   |
      | PT_SC04f_Registered2       | PT_SC04f_Registered2_SEI1       | 2016-12-05 | 2016-12-05T19:42:13+00:00 | 0   |
      | PT_SC04f_TsVrUploaded      | PT_SC04f_TsVrUploaded_SEI2      | today      | current                   | 1   |
      | PT_SC04f_RequestAssignment | PT_SC04f_RequestAssignment_SEI2 | 2016-12-05 | 2016-12-05T19:42:13+00:00 | 0   |

  @patients_p1
  Scenario: PT_SC04g patient_limbos should remove patient once this patient change to OFF_STUDY
    Given patient id is "PT_SC04g_TsReceived"
    And load template off study message for this patient
    Then set patient message field: "step_number" to value: "1.0"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "OFF_STUDY"
    Then patient GET service: "patient_limbos", patient id: "", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "0" patient_limbos have field: "patient_id" value: "PT_SC04g_TsReceived"

    #no bio expired any more
  @patients_off
  Scenario: PT_SC04h patient_limbos should remove patient once this patient change to OFF_STUDY_BIOPSY_EXPIRED
    Given patient id is "PT_SC04h_TsReceived"
    And load template off study biopsy expired message for this patient
    Then set patient message field: "step_number" to value: "1.0"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "OFF_STUDY_BIOPSY_EXPIRED"
    Then patient GET service: "patient_limbos", patient id: "", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "0" patient_limbos have field: "patient_id" value: "PT_SC04h_TsReceived"

  @patients_p1
  Scenario: PT_SC04i patient_limbos should remove patient once this patient change to REQUEST_NO_ASSIGNMENT
    Given patient id is "PT_SC04i_PendingApproval"
    And load template request no assignment message for this patient
    Then set patient message field: "step_number" to value: "1.0"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "REQUEST_NO_ASSIGNMENT"
    Then patient GET service: "patient_limbos", patient id: "", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "0" patient_limbos have field: "patient_id" value: "PT_SC04i_PendingApproval"

  @patients_p1
  Scenario: PT_SC04j patient_limbos should remove patient once this patient get approved on treatment arm
    Given patient id is "PT_SC04j_PendingApproval"
    And load template on treatment arm confirm message for this patient
    Then set patient message field: "treatment_arm_id" to value: "APEC1621-A"
    Then set patient message field: "stratum_id" to value: "100"
    Then set patient message field: "step_number" to value: "1.1"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "ON_TREATMENT_ARM"
    Then patient GET service: "patient_limbos", patient id: "", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "0" patient_limbos have field: "patient_id" value: "PT_SC04j_PendingApproval"

  @patients_p1
  Scenario: PT_SC04k patient_limbos should update properly after slide shipped
    Given patient id is "PT_SC04k_TsReceived"
    Then load template specimen type: "SLIDE" shipped message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_SC04k_TsReceived_SEI1"
    Then set patient message field: "slide_barcode" to value: "PT_SC04k_TsReceived_BC1"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "TISSUE_SLIDE_SPECIMEN_SHIPPED"
    Then patient GET service: "patient_limbos", patient id: "", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "1" patient_limbos have field: "patient_id" value: "PT_SC04k_TsReceived"
    Then this patient patient_limbos field "current_status" should be correct
    Then this patient patient_limbos field "active_tissue_specimen" should be correct
    Then this patient patient_limbos should have "4" messages which contain "Tissue-BAF47-BRG1-PTEN"
    Then this patient patient_limbos days_pending should be correct

  @patients_p1
  Scenario: PT_SC04l patient_limbos should update properly after assignment get confirmed
    Given patient id is "PT_SC04l_PendingConfirmation"
    And load template assignment report confirm message for analysis id: "PT_SC04l_PendingConfirmation_ANI1"
    When PUT to MATCH assignment report "confirm" service, response includes "changed successfully to" with code "200"
    Then patient status should change to "PENDING_APPROVAL"
    Then patient GET service: "patient_limbos", patient id: "", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "1" patient_limbos have field: "patient_id" value: "PT_SC04l_PendingConfirmation"
    Then this patient patient_limbos field "current_status" should be correct
    Then this patient patient_limbos field "active_tissue_specimen" should be correct
    Then this patient patient_limbos should have "1" messages which contain "approval"
    Then this patient patient_limbos days_pending should be correct

  @patients_p1
  Scenario: PT_SC04m patient_limbos should update properly after request_assignment rebiopsy = N
    Given patient id is "PT_SC04m_PendingApproval"
    And load template request assignment message for this patient
    And set patient message field: "rebiopsy" to value: "N"
    And set patient message field: "step_number" to value: "1.0"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "PENDING_CONFIRMATION"
    Then patient GET service: "patient_limbos", patient id: "", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "1" patient_limbos have field: "patient_id" value: "PT_SC04m_PendingApproval"
    Then this patient patient_limbos field "current_status" should be correct
    Then this patient patient_limbos field "active_tissue_specimen" should be correct
    Then this patient patient_limbos should have "1" messages which contain "assignment"
    Then this patient patient_limbos days_pending should be correct
    Then this patient patient_limbos has_amoi should be "true"

  @patients_p1
  Scenario Outline: PT_SC05a action_items should have correct value
    Given patient GET service: "action_items", patient id: "<patient_id>", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "1" patient action_items have field: "action_type" value: "<action_type>"
    Then there are "1" patient action_items have field: "analysis_id" value: "<analysis_id>"
    Examples:
      | patient_id                   | action_type                   | analysis_id                       |
      | PT_SC05a_TsVrUploaded        | pending_tissue_variant_report | PT_SC05a_TsVrUploaded_ANI1        |
      | PT_SC05a_TsThenAssayReceived | pending_tissue_variant_report | PT_SC05a_TsThenAssayReceived_ANI1 |
      | PT_SC05a_PendingConfirmation | pending_assignment_report     | PT_SC05a_PendingConfirmation_ANI1 |

  @patients_p1
  Scenario Outline: PT_SC05b action_items should add pending_tissue_variant_report item after vr upload
    Given patient id is "<patient_id>"
    And load template variant file uploaded message for molecular id: "<moi>"
    Then set patient message field: "analysis_id" to value: "<ani>"
    Then files for molecular_id "<moi>" and analysis_id "<ani>" are in S3
    When POST to MATCH variant report upload service, response includes "successfully" with code "202"
    Then patient status should change to "TISSUE_VARIANT_REPORT_RECEIVED"
    Then patient GET service: "action_items", patient id: "<patient_id>", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "1" patient action_items have field: "action_type" value: "pending_tissue_variant_report"
    Then there are "1" patient action_items have field: "analysis_id" value: "<ani>"
    Examples:
      | patient_id         | moi                     | ani                     |
      | PT_SC05b_TsShipped | PT_SC05b_TsShipped_MOI1 | PT_SC05b_TsShipped_ANI1 |

  @patients_p1
  Scenario Outline: PT_SC05c action_items should remove pending_tissue_variant_report item after vr confirmed
    Given patient id is "<patient_id>"
    And load template variant report confirm message for analysis id: "<ani>"
    When PUT to MATCH variant report "confirm" service, response includes "changed successfully to" with code "200"
    Then patient status should change to "TISSUE_VARIANT_REPORT_CONFIRMED"
    Then patient GET service: "action_items", patient id: "<patient_id>", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "0" patient action_items have field: "action_type" value: "pending_tissue_variant_report"
    Examples:
      | patient_id            | ani                        |
      | PT_SC05c_TsVrUploaded | PT_SC05c_TsVrUploaded_ANI1 |

  @patients_p1
  Scenario Outline: PT_SC05d action_items should add pending_assignment_report after patient reach PENDING_CONFIRMATION
    Given patient id is "<patient_id>"
    And load template variant report confirm message for analysis id: "<ani>"
    When PUT to MATCH variant report "confirm" service, response includes "changed successfully to" with code "200"
    Then patient status should change to "PENDING_CONFIRMATION"
    Then patient GET service: "action_items", patient id: "<patient_id>", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "0" patient action_items have field: "action_type" value: "pending_tissue_variant_report"
    Then there are "1" patient action_items have field: "action_type" value: "pending_assignment_report"
    Then there are "1" patient action_items have field: "analysis_id" value: "<ani>"
    Examples:
      | patient_id            | ani                        |
      | PT_SC05d_VrAssayReady | PT_SC05d_VrAssayReady_ANI1 |

  @patients_p1
  Scenario Outline: PT_SC05e action_items should remove pending_assignment_report item after assignment confirmation
    Given patient id is "<patient_id>"
    And load template assignment report confirm message for analysis id: "<ani>"
    When PUT to MATCH assignment report "confirm" service, response includes "changed successfully to" with code "200"
    Then patient status should change to "PENDING_APPROVAL"
    Then patient GET service: "action_items", patient id: "<patient_id>", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "0" patient action_items have field: "action_type" value: "pending_assignment_report"
    Examples:
      | patient_id                   | ani                               |
      | PT_SC05e_PendingConfirmation | PT_SC05e_PendingConfirmation_ANI1 |

  @patients_p1
  Scenario Outline: PT_SC05f action_items should be cleared once this patient change to OFF_STUDY
    Given patient id is "<patient_id>"
    And load template off study message for this patient
    Then set patient message field: "step_number" to value: "1.0"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "OFF_STUDY"
    Then patient GET service: "action_items", patient id: "<patient_id>", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "0" patient action_items
    Examples:
      | patient_id                   |
      | PT_SC05f_TsVrUploaded        |
      | PT_SC05f_PendingConfirmation |

    #no bio expired any more
  @patients_off
  Scenario Outline: PT_SC05g action_items should be cleared once this patient change to OFF_STUDY_BIOPSY_EXPIRED
    Given patient id is "<patient_id>"
    And load template off study biopsy expired message for this patient
    Then set patient message field: "step_number" to value: "1.0"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "OFF_STUDY_BIOPSY_EXPIRED"
    Then patient GET service: "action_items", patient id: "<patient_id>", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "0" patient action_items
    Examples:
      | patient_id                   |
      | PT_SC05g_TsVrUploaded        |
      | PT_SC05g_PendingConfirmation |

  @patients_p1
  Scenario Outline: PT_SC06a treatment_arm_history should add item after patient on treatment arm
    Given patient id is "<patient_id>"
    Then load template on treatment arm confirm message for this patient
    Then set patient message field: "treatment_arm_id" to value: "<ta_id>"
    Then set patient message field: "stratum_id" to value: "<stratum>"
    Then set patient message field: "step_number" to value: "<step>"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "ON_TREATMENT_ARM"
    Then patient GET service: "treatment_arm_history", patient id: "<patient_id>", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "<count>" patient treatment_arm_history
    Then patient treatment_arm_history should have treatment_arm: "<ta_id>", stratum: "<stratum>", step: "<step>"
    Examples:
      | patient_id                    | ta_id          | stratum | step | count |
      | PT_SC06a_PendingApproval      | APEC1621-A     | 100     | 1.1  | 1     |
      | PT_SC06a_PendingApprovalStep2 | APEC1621-ETE-A | 100     | 2.1  | 2     |

  @patients_p2
  Scenario: PT_SC06b treatment_arm_history should not add item after patient transition to OFF_STUDY
    Given patient id is "PT_SC06b_PendingApproval"
    Then load template off study message for this patient
    Then set patient message field: "step_number" to value: "1.0"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "OFF_STUDY"
    Then patient GET service: "treatment_arm_history", patient id: "PT_SC06b_PendingApproval", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "0" patient treatment_arm_history
    Then patient treatment_arm_history should not have treatment_arm: "APEC1621-A", stratum: "100"

    #no bio expired any more
  @patients_off
  Scenario: PT_SC06c treatment_arm_history should not add item after patient transition to OFF_STUDY_BIOPSY_EXPIRED
    Given patient id is "PT_SC06c_PendingApprovalStep2"
    Then load template off study biopsy expired message for this patient
    Then set patient message field: "step_number" to value: "2.0"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "OFF_STUDY_BIOPSY_EXPIRED"
    Then patient GET service: "treatment_arm_history", patient id: "PT_SC06c_PendingApprovalStep2", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "1" patient treatment_arm_history
    Then patient treatment_arm_history should have treatment_arm: "APEC1621-A", stratum: "100", step: "1.1"
    Then patient treatment_arm_history should not have treatment_arm: "APEC1621-ETE-A", stratum: "100"

  @patients_p1
  Scenario Outline: PT_SC06d treatment_arm_history should not add item after patient transition to REQUEST_ASSIGNMENT
    Given patient id is "<patient_id>"
    And load template request assignment message for this patient
    And set patient message field: "rebiopsy" to value: "<rebiopsy>"
    And set patient message field: "step_number" to value: "1.0"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "<status>"
    Then patient GET service: "treatment_arm_history", patient id: "PT_SC06e_PendingApproval", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "0" patient treatment_arm_history
    Then patient treatment_arm_history should not have treatment_arm: "APEC1621-A", stratum: "100"
    Examples:
      | patient_id                | rebiopsy | status               |
      | PT_SC06d_PendingApproval1 | Y        | REQUEST_ASSIGNMENT   |
      | PT_SC06d_PendingApproval2 | N        | PENDING_CONFIRMATION |

  @patients_p2
  Scenario: PT_SC06e treatment_arm_history should not add item after patient transition to REQUEST_NO_ASSIGNMENT
    Given patient id is "PT_SC06e_PendingApproval"
    Then load template request no assignment message for this patient
    Then set patient message field: "step_number" to value: "1.0"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "REQUEST_NO_ASSIGNMENT"
    Then patient GET service: "treatment_arm_history", patient id: "PT_SC06e_PendingApproval", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then there are "0" patient treatment_arm_history
    Then patient treatment_arm_history should not have treatment_arm: "APEC1621-A", stratum: "100"

  @patients_p1
  Scenario Outline: PT_SC07a specimen_events should have correct value
    Given patient GET service: "specimen_events", patient id: "<patient_id>", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then this patient tissue specimen_events should have "<tissue_count>" elements
    Then this patient blood specimen_events should have "<blood_count>" specimens
    Examples:
      | patient_id            | tissue_count | blood_count |
      | PT_SC07a_TsReceived   | 1            | 0           |
      | PT_SC07a_BdReceived   | 0            | 1           |
      | PT_SC07a_TsBdReceived | 1            | 1           |

  @patients_p1
  Scenario Outline: PT_SC07b specimen_events should update properly
    Given patient id is "<patient_id>"
    Given patient GET service: "specimen_events", patient id: "<patient_id>", id: ""
    Then load template specimen type: "<specimen_type>" received message for this patient
    Then set patient message field: "surgical_event_id" to value: "<sei>"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then wait until patient specimen is updated
    When GET from MATCH patient API, http code "200" should return
    Then this patient tissue specimen_events should have "<tissue_after>" elements
    Then this patient blood specimen_events should have "<blood_after>" specimens
    Examples:
      | patient_id          | specimen_type | sei                      | tissue_after | blood_after |
      | PT_SC07b_TsReceived | TISSUE        | PT_SC07b_TsReceived_SEI2 | 2            | 0           |
      | PT_SC07b_TsShipped  | BLOOD         |                          | 1            | 1           |
      | PT_SC07b_BdReceived | TISSUE        | PT_SC07b_BdReceived_SEI1 | 1            | 1           |
      | PT_SC07b_BdShipped  | BLOOD         |                          | 0            | 2           |

  @patients_p1
  Scenario Outline: PT_SC07c specimen_events should return all assignment reports
    Given patient GET service: "specimen_events", patient id: "<pt_id>", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then this patient specimen_events should have assignment: analysis_id "<pt_id>_ANI1" and comment "<comment>"
    Examples:
      | pt_id                    | comment      |
      | PT_SC07c_PendingApproval | Assignment 1 |
      | PT_SC07c_PendingApproval | Assignment 2 |
      | PT_SC07c_PendingApproval | Assignment 3 |

  @patients_p2
  Scenario: PT_SC07d specimen_events should return all variant file names
    Given patient GET service: "specimen_events", patient id: "PT_SC07d_TsVrUploaded", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then this patient tissue specimen_events analyses "PT_SC07d_TsVrUploaded_ANI1" should have correct "dna" file names: "dna.bam"
    Then this patient tissue specimen_events analyses "PT_SC07d_TsVrUploaded_ANI1" should have correct "cdna" file names: "cdna.bam"
    Then this patient tissue specimen_events analyses "PT_SC07d_TsVrUploaded_ANI1" should have correct "vcf" file names: "test1.vcf"

  Scenario: PT_SC07e specimen_events should display assay history in correct order
    Given patient GET service: "specimen_events", patient id: "PT_SC07e_FiveAssay", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then this patient tissue specimen_events specimen "PT_SC07e_FiveAssay_SEI1" should have these assays
      | order | biomarker | result        | result_date          |
      | 1     | ICCBRG1s  | NEGATIVE      | 2017-06-05T21:15:47Z |
      | 2     | ICCBRG1s  | INDETERMINATE | 2017-06-05T21:15:43Z |
      | 3     | ICCPTENs  | POSITIVE      | 2017-06-05T21:15:41Z |
      | 4     | ICCBAF47s | NEGATIVE      | 2017-06-05T21:15:39Z |
      | 5     | ICCPTENs  | NEGATIVE      | 2017-06-05T21:15:38Z |

  @patients_p1
  Scenario Outline: PT_SC08a variant report can be downloaded properly
    Given patient id is "<patient_id>"
    And patient GET service: "variant_report", patient id: "<patient_id>", id: "<ani>"
    When GET from MATCH patient API, http code "200" should return
    Then save response from "variant" report download service to temp file
    Then the saved "variant" report should have these values
      | Patient ID          | <patient_id> |
      | Analysis ID         | <ani>        |
      | Status              | <status>     |
      | Variant Report Type | <type>       |
    Then the saved variant report should have correct MOI summary as variant report "<ani>"
    Then the saved variant report should have correct variants summary as variant report "<ani>"
    Examples:
      | patient_id                | ani                               | status   | type   |
      | PT_SC08_TsVrUploadedTwice | PT_SC08_TsVrUploadedTwice_ANI1    | REJECTED | TISSUE |
      | PT_SC08_TsVrUploadedTwice | PT_SC08_TsVrUploadedTwice_ANI2    | PENDING  | TISSUE |
      | PT_SC08_BdVrUploadedTwice | PT_SC08_BdVrUploadedTwice_BD_ANI1 | REJECTED | BLOOD  |
      | PT_SC08_BdVrUploadedTwice | PT_SC08_BdVrUploadedTwice_BD_ANI2 | PENDING  | BLOOD  |

  @patients_p3
  Scenario Outline: PT_SC08b invalid variant report download request should fail
    Given patient id is "<patient_id>"
    And patient GET service: "variant_report", patient id: "<patient_id>", id: "<ani>"
    When GET from MATCH patient API, http code "404" should return
    Examples:
      | patient_id                | ani                            |
      | PT_SC08_TsVrUploadedTwice | PT_SC08_BdVrUploadedTwice_ANI1 |
      | PT_SC08_TsVrUploadedTwice | non_existing_ani               |
      | PT_SC08_BdVrUploadedTwice | PT_SC08_TsVrUploadedTwice_ANI2 |
      | PT_SC08_BdVrUploadedTwice | non_existing_ani               |

  @patients_p1
  Scenario Outline: PT_SC09a assignment report can be downloaded properly
    Given patient id is "<patient_id>"
    And patient GET service: "assignment_report", patient id: "<patient_id>", id: "<uuid>"
    Then save response from "assignment" report download service to temp file
    Then the saved "assignment" report should have these values
      | Patient ID        | <patient_id>      |
      | Surgical Event ID | <patient_id>_SEI1 |
      | Molecular ID      | <patient_id>_MOI1 |
      | Analysis ID       | <patient_id>_ANI1 |
      | Status            | <status>          |
      | Study ID          | APEC1621SC        |
      | Report Status     | TREATMENT_FOUND   |
    Then the saved assignment report should have correct assignment result as assignment "<uuid>"
    Examples:
      | patient_id                  | uuid                                 | status    |
      | PT_SC09_PendingConfirmation | cd53ebfb-e994-4da3-a661-6018d4167c26 | PENDING   |
      | PT_SC09_PendingApproval     | fe3dda34-e606-4261-915f-48bb46525742 | CONFIRMED |
      | PT_SC09_OnTreatmentArm      | b3dd218f-0f11-4b0a-8aa0-d13a8344b45f | CONFIRMED |
      | PT_SC09_TsReceivedStep2     | d9249782-1b51-4a4d-a182-7406404ca764 | CONFIRMED |

  @patients_p3
  Scenario Outline: PT_SC09b invalid assignment report download request should fail
    Given patient id is "<patient_id>"
    And patient GET service: "assignment_report", patient id: "<patient_id>", id: "<uuid>"
    When GET from MATCH patient API, http code "404" should return
    Examples:
      | patient_id                  | uuid                                 |
      | PT_SC09_PendingConfirmation | non_existing_uuid                    |
      | PT_SC09_PendingApproval     | 301f05b2-a7b3-4305-8c2b-30bee9f258e1 |

  @patients_p2
  Scenario: PT_SC10a analysis_report can return all variant file names
    Given patient GET service: "analysis_report", patient id: "PT_SC10a_TsVrUploaded", id: "PT_SC10a_TsVrUploaded_ANI1"
    When GET from MATCH patient API, http code "200" should return
    Then this patient tissue analysis_report should have correct "dna" file names: "dna.bam"
    Then this patient tissue analysis_report should have correct "cdna" file names: "cdna.bam"
    Then this patient tissue analysis_report should have correct "vcf" file names: "test1.vcf"

  @patients_p2
  Scenario: PT_SC10b analysis report can display snp and mnp variant in "snv_indels" field
    Given patient id is "PT_SC10b_TsShipped"
    And load template variant file uploaded message for molecular id: "PT_SC10b_TsShipped_MOI1"
    Then set patient message field: "analysis_id" to value: "PT_SC10b_TsShipped_ANI1"
    Then upload files for molecular_id "PT_SC10b_TsShipped_MOI1" analysis_id "PT_SC10b_TsShipped_ANI1" using template "default_vcf52"
    When POST to MATCH variant report upload service, response includes "successfully" with code "202"
    Then wait until patient variant report is updated
    Then patient GET service: "analysis_report", patient id: "PT_SC10b_TsShipped", id: "PT_SC10b_TsShipped_ANI1"
    When GET from MATCH patient API, http code "200" should return
    Then this patient tissue analysis_report variant field "snv_indels" should include id "COSM893754"
    Then this patient tissue analysis_report variant field "snv_indels" should include id "COSM26494"

  @patients_p2
  Scenario: PT_SC10c analysis report should show reports which only belongs to specified analysis id
    Given patient GET service: "analysis_report", patient id: "PT_SC10c_PendingConfirmationStep2", id: "PT_SC10c_PendingConfirmationStep2_ANI1"
    When GET from MATCH patient API, http code "200" should return
    Then this patient analysis_report variant reports should have these values
      | analysis_id | PT_SC10c_PendingConfirmationStep2_ANI1 |
    Then this patient analysis_report should have "1" assignment reports
    Then this patient analysis_report every assignment reports should have these values
      | analysis_id | PT_SC10c_PendingConfirmationStep2_ANI1 |
    Given patient GET service: "analysis_report", patient id: "PT_SC10c_PendingConfirmationStep2", id: "PT_SC10c_PendingConfirmationStep2_ANI2"
    When GET from MATCH patient API, http code "200" should return
    Then this patient analysis_report variant reports should have these values
      | analysis_id | PT_SC10c_PendingConfirmationStep2_ANI2 |
    Then this patient analysis_report should have "2" assignment reports
    Then this patient analysis_report every assignment reports should have these values
      | analysis_id | PT_SC10c_PendingConfirmationStep2_ANI2 |

  @patient_p2
  Scenario: PT_SC11a assay event should have correct values
    Given patient id is "PT_SC11a_AssayReceived"
    And patient GET service: "events", patient id: "", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then returned events should include assay event with biomacker "IHC PTEN" result "NEGATIVE"
    Then returned events should include assay event with biomacker "IHC BRG1" result "POSITIVE"
    Then returned events should include assay event with biomacker "IHC BAF47" result "INDETERMINATE"

  @patient_p1
  Scenario: PT_SC11b all events should have required field
    Given patient GET service: "events", patient id: "", id: ""
    When GET from MATCH patient API, http code "200" should return
    Then returned events should have field "entity_id" with "string" value
    Then returned events should have field "event_date" with "date" value
    Then returned events should have field "event_type" with "string" value
    Then returned events should have field "event_message" with "string" value
    Then returned events should have field "event_data" with "hash" value
    Then returned event_data should have field "step" with "number" value
