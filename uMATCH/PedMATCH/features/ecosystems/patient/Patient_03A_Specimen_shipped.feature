#encoding: utf-8
#@patients
@specimen_shipped
Feature: NCH Specimen shipped messages
  Scenario: PT_SS01. Received specimen_shipped message for type 'BLOOD' from NCH for a patient who has already received the specimen_received message
    Given template specimen shipped message in type: "BLOOD" for patient: "PT_SS01_BloodReceived", it has surgical_event_id: "", molecular_id: "PT_SS01_MOI1", slide_barcode: ""
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "15" seconds
    Then retrieve patient: "PT_SS01_BloodReceived" from API
    Then returned patient has value: "BLOOD_NUCLEIC_ACID_SHIPPED" in field: "current_status"

  Scenario: PT_SS02. Received specimen_shipped message for type 'TISSUE' from NCH for a patient who has already received the specimen_received message
#  Testing patient:PT_SS01_TissueReceived; surgical_event_id: PT_SS02_SEI1
    Given template specimen shipped message in type: "TISSUE" for patient: "PT_SS02_TissueReceived", it has surgical_event_id: "PT_SS02_SEI1", molecular_id: "PT_SS02_MOI1", slide_barcode: ""
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "15" seconds
    Then retrieve patient: "PT_SS02_TissueReceived" from API
    Then returned patient has value: "TISSUE_NUCLEIC_ACID_SHIPPED" in field: "current_status"

  Scenario: PT_SS03. Received specimen_shipped message for type 'SLIDE' from NCH for a patient who has already received the specimen_received message
#  Testing patient:PT_SS03_TissueReceived; surgical_event_id: PT_SS03_SEI1
    Given template specimen shipped message in type: "SLIDE" for patient: "PT_SS03_TissueReceived", it has surgical_event_id: "PT_SS03_SEI1", molecular_id: "", slide_barcode: "PT_SS03_BC1"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "15" seconds
    Then retrieve patient: "PT_SS03_TissueReceived" from API
    Then returned patient has value: "TISSUE_SLIDE_SPECIMEN_SHIPPED" in field: "current_status"

  Scenario Outline: PT_SS04. Shipment with invalid patient_id fails
    Given template specimen shipped message in type: "<type>" for patient: "<patient>", it has surgical_event_id: "PT_SS04_SEI1", molecular_id: "PT_SS04_MOI1", slide_barcode: "PT_SS04_BC1"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "<status>"
    Examples:
    |type   |patient                |status   |message                                                        |
    |TISSUE |PT_SS04_NonExisting    |Failure  |Unable to find patient                                         |
    |BLOOD  |                       |Failure  |can't be blank                                                 |
    |SLIDE  |null                   |Failure  |can't be blank                                                 |

  Scenario Outline: PT_SS05. Shipment with invalid study_id fails
#  Testing patient:PT_SS05_TissueReceived; surgical_event_id: PT_SS05_SEI1
    Given template specimen shipped message in type: "TISSUE" for patient: "PT_SS05_TissueReceived", it has surgical_event_id: "PT_SS05_SEI1", molecular_id: "PT_SS05_MOI1", slide_barcode: ""
    Then set patient message field: "study_id" to value: "<study_id>"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |study_id     |message                                                        |
      |other        |not a valid study_id                                           |
      |             |can't be blank                                                 |
      |null         |can't be blank                                                 |

  Scenario: PT_SS06. shipped_dttm older than received_dttm fails
#  Testing patient: PT_SS06_TissueReceived, surgical_event_id: PT_SS06_SEI1, received_dttm: 2016-04-25T16:17:11+00:00
    Given template specimen shipped message in type: "TISSUE" for patient: "PT_SS06_TissueReceived", it has surgical_event_id: "PT_SS06_SEI1", molecular_id: "PT_SS06_MOI1", slide_barcode: ""
    Then set patient message field: "shipped_dttm" to value: "2016-03-25T16:17:11+00:00"
    When posted to MATCH patient trigger service, returns a message that includes "TBD" with status "Failure"

  Scenario: PT_SS06a. shipped_dttm should not be older than the latest shipped_dttm in the same surgical_event_id
    #Testing patient: PT_SS06a_TissueShipped, surgical_event_id: PT_SS06a_SEI1, molecular_id: PT_SS06a_MOI1 shipped 2016-05-01T19:42:13+00:00
    Given template specimen shipped message in type: "TISSUE" for patient: "PT_SS06a_TissueShipped", it has surgical_event_id: "PT_SS06a_SEI1", molecular_id: "PT_SS06a_MOI2", slide_barcode: ""
    Then set patient message field: "molecular_id" to value: "MOI_02"
    Then set patient message field: "shipped_dttm" to value: "2016-05-01T15:42:13+00:00"
    When posted to MATCH patient trigger service, returns a message that includes "TBD" with status "Failure"

  Scenario Outline: PT_SS07. shipped tissue or slide with a non-exist surgical_event_id fails
#  Testing patient: PT_SS07_TissueReceived, surgical_event_id: PT_SS07_SEI1
    Given template specimen shipped message in type: "<type>" for patient: "PT_SS07_TissueReceived", it has surgical_event_id: "<SEI>", molecular_id: "PT_SS07_MOI1", slide_barcode: "PT_SS07_BC1"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
    |type   |SEI            |message                                                              |
    |TISSUE |badSEI         |Unable to find                                                       |
    |SLIDE  |               |can't be blank                                                       |

  Scenario Outline: PT_SS08. tissue or slide with an expired surgical_event_id fails
#  Testing patient: PT_SS08_TissueReceived
#  surgical event: PT_SS08_SEI1 received Then PT_SS08_SEI2 received (PT_SS08_SEI1 expired)
    Given template specimen shipped message in type: "<type>" for patient: "PT_SS08_TissueReceived", it has surgical_event_id: "PT_SS08_SEI1", molecular_id: "PT_SS08_MOI1", slide_barcode: "PT_SS08_BC1"
    Then set patient message field: "shipped_dttm" to value: "current"
    When posted to MATCH patient trigger service, returns a message that includes "not currently active" with status "Failure"
    Examples:
    |type     |
    |TISSUE   |
    |SLIDE    |

  Scenario Outline: PT_SS09. shipped tissue or slide without surgical_event_id fails
#  Testing patient: PT_SS09_TissueReceived, surgical_event_id: PT_SS09_SEI1
    Given template specimen shipped message in type: "<type>" for patient: "PT_SS09_TissueReceived", it has surgical_event_id: "PT_SS09_SEI1", molecular_id: "PT_SS09_MOI1", slide_barcode: ""
    Then remove field: "surgical_event_id" from patient message
    When posted to MATCH patient trigger service, returns a message that includes "surgical_event_id" with status "Failure"
    Examples:
      |type     |
      |TISSUE   |
      |SLIDE    |

  Scenario Outline: PT_SS10. shipped tissue without molecular_id or molecular_dna_id or molecular_cdna_id fails
#  Testing patient: PT_SS10_TissueReceived, surgical_event_id: PT_SS10_SEI1
    Given template specimen shipped message in type: "TISSUE" for patient: "PT_SS10_TissueReceived", it has surgical_event_id: "PT_SS10_SEI1", molecular_id: "PT_SS10_MOI1", slide_barcode: ""
    Then remove field: "<field>" from patient message
    When posted to MATCH patient trigger service, returns a message that includes "<field>" with status "Failure"
    Examples:
      |field              |
      |molecular_id       |
      |molecular_dna_id   |
      |molecular_cdna_id  |

  Scenario Outline: PT_SS11. shipped tissue with a existing surgical_event_id + molecular_id combination fails
#  Testing patient: PT_SS11_Tissue1Shipped, surgical_event_id: PT_SS11_SEI1
#    molecular_id: PT_SS11_MOI1 has shipped and PT_SS11_MOI2 has shipped
    Given template specimen shipped message in type: "TISSUE" for patient: "PT_SS11_Tissue1Shipped", it has surgical_event_id: "PT_SS11_SEI1", molecular_id: "<moi>", slide_barcode: ""
    Then set patient message field: "shipped_dttm" to value: "2016-05-01T15:42:13+00:00"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
    |moi            |message                                  |
    |PT_SS11_MOI1   |molecular id                             |
    |PT_SS11_MOI2   |molecular id                             |

  Scenario: PT_SS12. shipped tissue with a new molecular_id in latest surgical_event_id pass
#  Testing patient: PT_SS12_Tissue1Shipped, surgical_event_id: PT_SS12_SEI1
#    molecular_id: PT_SS12_MOI1 has shipped
    Given template specimen shipped message in type: "TISSUE" for patient: "PT_SS12_Tissue1Shipped", it has surgical_event_id: "PT_SS12_SEI1", molecular_id: "PT_SS12_MOI2", slide_barcode: ""
    Then set patient message field: "shipped_dttm" to value: "current"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "15" seconds
    Then retrieve patient: "PT_SS12_Tissue1Shipped" from API
    Then returned patient has specimen (surgical_event_id: "PT_SS12_SEI1")
    And this specimen has value: "PT_SS12_MOI2" in field: "active_molecular_id"


    #This is not required
#  Scenario: PT_SS13. shipped slide with molecular_id fails
##  Testing patient: PT_SS13_TissueReceived, surgical_event_id: SEI_01
#    Given template specimen shipped message in type: "SLIDE" for patient: "PT_SS13_TissueReceived"
#    Then set patient message field: "surgical_event_id" to value: "SEI_TR_1"
#    Then set patient message field: "molecular_id" to value: "MOI_01"
#    When posted to MATCH patient trigger service, returns a message that includes "cannot transition from" with status "Failure"

  Scenario: PT_SS14. shipped slide without slide_barcode fails
#  Testing patient: PT_SS14_TissueReceived, surgical_event_id: PT_SS14_SEI1
    Given template specimen shipped message in type: "SLIDE" for patient: "PT_SS14_TissueReceived", it has surgical_event_id: "PT_SS14_SEI1", molecular_id: "", slide_barcode: "PT_SS14_BC1"
    Then remove field: "slide_barcode" from patient message
    When posted to MATCH patient trigger service, returns a message that includes "can't be blank" with status "Failure"

  Scenario: PT_SS15. shipped slide with new barcode passes
#  Testing patient: PT_SS15_Slide1Shipped, surgical_event_id: PT_SS15_SEI1
#    slide with barcode: PT_SS14_BC1 has been shipped
    Given template specimen shipped message in type: "SLIDE" for patient: "PT_SS15_Slide1Shipped", it has surgical_event_id: "PT_SS15_SEI1", molecular_id: "", slide_barcode: "PT_SS14_BC2"
    Then set patient message field: "shipped_dttm" to value: "current"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"

  Scenario: PT_SS16. shipped slide with a existing surgical_event_id + slide_barcode combination fails
#  Testing patient: PT_SS16_Slide1Shipped, surgical_event_id: PT_SS16_SEI1
#    slide with barcode: PT_SS16_BC1 has been shipped
    Given template specimen shipped message in type: "SLIDE" for patient: "PT_SS16_Slide1Shipped", it has surgical_event_id: "PT_SS16_SEI1", molecular_id: "PT_SS01_BloodReceived_MOI1", slide_barcode: ""
    Then set patient message field: "slide_barcode" to value: "BC_001"
    Then set patient message field: "shipped_dttm" to value: "2016-05-01T15:42:13+00:00"
    When posted to MATCH patient trigger service, returns a message that includes "TBD" with status "Failure"

  Scenario: PT_SS17. shipped blood without blood received fails
#  Testing patient: PT_SS17_Registered
#     These is no blood specimen received event in this patient
    Given template specimen shipped message in type: "BLOOD" for patient: "PT_SS17_Registered", it has surgical_event_id: "", molecular_id: "PT_SS17_MOI1", slide_barcode: ""
    When posted to MATCH patient trigger service, returns a message that includes "TBD" with status "Failure"

    #this test case is not required
#  Scenario: PT_SS18. shipped blood with SEI fails
#    Given template specimen shipped message in type: "BLOOD" for patient: "PT_SS18_BloodReceived"
#    Then set patient message field: "surgical_event_id" to value: "SEI_BR_1"
#    When posted to MATCH patient trigger service, returns a message that includes "TBD" with status "Failure"

  Scenario: PT_SS20. shipped blood with new molecular_id (in this patient) passes
#  Testing patient: PT_SS20_Blood1Shipped
#    blood molecular_id: PT_SS20_MOI1 has shipped
    Given template specimen shipped message in type: "BLOOD" for patient: "PT_SS20_Blood1Shipped", it has surgical_event_id: "", molecular_id: "PT_SS20_MOI2", slide_barcode: ""
    Then set patient message field: "shipped_dttm" to value: "2016-05-01T15:42:13+00:00"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "15" seconds
    Then retrieve patient: "PT_SS20_Blood1Shipped" from API
    Then returned patient's blood specimen has value: "PT_SS20_MOI2" in field: "active_molecular_id"

#  data not ready yet
#  Scenario: PT_SS21. Tissue cannot be shipped if there is one tissue variant report get confirmed
##    Testing patient: PT_SS21_TissueVariantConfirmed, surgical_event_id: PT_SS21_SEI1, molecular_id: PT_SS21_MOI1, analysis_id: PT_SS21_ANI1
##      this patient has TISSUE_VARIANT_REPORT_CONFIRMED status
#    Given template specimen shipped message in type: "TISSUE" for patient: "PT_SS21_TissueVariantConfirmed", it has surgical_event_id: "PT_SS21_SEI1", molecular_id: "PT_SS21_MOI2", slide_barcode: ""
#    Then set patient message field: "shipped_dttm" to value: "current"
#    When posted to MATCH patient trigger service, returns a message that includes "cannot transition from" with status "Failure"

#  data not ready yet
#  Scenario: PT_SS22. Blood cannot be shipped if there is one blood variant report get confirmed
##    Testing patient: PT_SS22_BloodVariantConfirmed, molecular_id: PT_SS22_MOI1, analysis_id: PT_SS22_ANI1
##      this patient has BLOOD_VARIANT_REPORT_CONFIRMED status
#    Given template specimen shipped message in type: "BLOOD" for patient: "PT_SS22_BloodVariantConfirmed", it has surgical_event_id: "", molecular_id: "PT_SS22_MOI2", slide_barcode: ""
#    Then set patient message field: "shipped_dttm" to value: "current"
    When posted to MATCH patient trigger service, returns a message that includes "cannot transition from" with status "Failure"

  Scenario Outline: PT_SS23. Tissue shipment and slide shipment should not depend on each other
    Given template specimen shipped message in type: "<type>" for patient: "<patient_id>", it has surgical_event_id: "<sei>", molecular_id: "<moi>", slide_barcode: "<barcode>"
    Then set patient message field: "shipped_dttm" to value: "2016-05-01T15:42:13+00:00"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"
    Examples:
    |type   |patient_id                 |sei                          |moi                          |barcode                    |
    |TISSUE |PT_SS23_TissueReceived1    |PT_SS23_TissueReceived1_SEI1 |PT_SS23_TissueReceived1_MOI1 |                           |
    |SLIDE  |PT_SS23_TissueReceived2    |PT_SS23_TissueReceived2_SEI1 |                             |PT_SS23_TissueReceived2_BC1|
    |TISSUE |PT_SS23_SlideShipped       |PT_SS23_SlideShipped_SEI1    |PT_SS23_SlideShipped_MOI1    |                           |
    |SLIDE  |PT_SS23_TissueShipped      |PT_SS23_TissueShipped_SEI1   |                             |PT_SS23_TissueShipped_BC1  |

  Scenario Outline: PT_SS24. Tissue shipment and blood shipment should not use same molecular_id
#    Testing patient: PT_SS24_BloodShipped,
#                          Blood shipped PT_SS24_BloodShipped_MOI1,
#                          Tissue received PT_SS24_BloodShipped_SEI1,try to ship it using PT_SS24_BloodShipped_MOI1
#                     PT_SS24_TissueShipped,
#                          Tissue shipped PT_SS24_TissueShipped_SEI1, PT_SS24_TissueShipped_MOI1,
#                          Blood received, try to ship it using PT_SS24_TissueShipped_MOI1
    Given template specimen shipped message in type: "<type>" for patient: "<patient_id>", it has surgical_event_id: "<sei>", molecular_id: "<moi>", slide_barcode: ""
    Then set patient message field: "shipped_dttm" to value: "2016-05-01T15:42:13+00:00"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
    |patient_id             |type       |sei                        |moi                        |message                                                  |
    |PT_SS24_BloodShipped   |TISSUE     |PT_SS24_BloodShipped_SEI1  |PT_SS24_BloodShipped_MOI1  |TBD                                                      |
    |PT_SS24_TissueShipped  |BLOOD      |                           |PT_SS24_TissueShipped_MOI1 |TBD                                                      |

  Scenario Outline: PT_SS25. Blood shipment use old blood molecular_id should fail
#    Testing patient: PT_SS25_BloodShipped, PT_SS25_MOI1 has been shipped, PT_SS25_MOI2 has been shipped
    Given template specimen shipped message in type: "BLOOD" for patient: "PT_SS25_BloodShipped", it has surgical_event_id: "", molecular_id: "<moi>", slide_barcode: ""
    Then set patient message field: "shipped_dttm" to value: "<ship_time>"
    When posted to MATCH patient trigger service, returns a message that includes "same molecular id" with status "Failure"
    Examples:
    |moi              |ship_time                  |
    |PT_SS25_MOI1     |2016-05-01T15:42:13+00:00  |
    |PT_SS25_MOI2     |2016-05-01T16:42:13+00:00  |


  Scenario Outline: PT_SS26. Blood specimen can only be shipped in certain status (blood specimen has been received before)
    Given template specimen shipped message in type: "BLOOD" for patient: "<patient_id>", it has surgical_event_id: "", molecular_id: "<moi>", slide_barcode: ""
    Then set patient message field: "shipped_dttm" to value: "2016-07-28T15:17:11+00:00"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "<status>"
    Examples:
    |patient_id                     |moi                              |status     |message                                    |
    |PT_SS26_TsReceived             |PT_SS26_TsReceived_MOI1          |Success    |Message has been processed successfully    |
    |PT_SS26_TsShipped              |PT_SS26_TsShipped_MOI1           |Success    |Message has been processed successfully    |
#    |PT_SS26_AssayConfirmed         |PT_SS26_AssayConfirmed_MOI1      |Success    |Message has been processed successfully    |
#    |PT_SS26_PathologyConfirmed     |PT_SS26_PathologyConfirmedç_MOI1 |Success    |Message has been processed successfully    |
#    |PT_SS26_TsVRReceived           |PT_SS26_TsVRReceived_MOI1        |Success    |Message has been processed successfully    |
#    |PT_SS26_TsVRConfirmed          |PT_SS26_TsVRConfirmed_MOI1       |Success    |Message has been processed successfully    |
#    |PT_SS26_WaitingPtData          |PT_SS26_WaitingPtData_MOI1       |Success    |Message has been processed successfully    |
#    |PT_SS26_PendingApproval        |PT_SS26_PendingApproval_MOI1     |Success    |Message has been processed successfully    |
#    |PT_SS26_Progression            |PT_SS26_Progression_MOI1         |Success    |Message has been processed successfully    |
#    |PT_SS26_OffStudy               |PT_SS26_OffStudy_MOI1            |Failure    |cannot transition from                     |

#data not ready yet
  Scenario: PT_SS27. new specimen shipped using new MOI in same SEI will push all pending variant report from old MOI to "REJECT"
  #    Test patient: PT_SS27_VariantReportUploaded; variant report files uploaded: surgical_event_id: PT_SS27_SEI1, molecular_id: PT_SS27_MOI1, analysis_id: PT_SS27_ANI1
  #          Plan to ship new specimen using same surgical_event_id: PT_SS27_SEI1 but new molecular_id PT_SS27_MOI2
    Given template specimen shipped message in type: "TISSUE" for patient: "PT_SS27_VariantReportUploaded", it has surgical_event_id: "PT_SS27_SEI1", molecular_id: "PT_SS27_MOI2", slide_barcode: ""
    Then set patient message field: "molecular_dna_id" to value: "PT_SS27_MOI2D"
    Then set patient message field: "molecular_cdna_id" to value: "PT_SS27_MOI2C"
    Then set patient message field: "shipped_dttm" to value: "2016-08-01T15:17:11+00:00"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "15" seconds
    Then retrieve patient: "PT_SS27_VariantReportUploaded" from API
    Then returned patient has value: "TISSUE_NUCLEIC_ACID_SHIPPED" in field: "current_status"
    Then returned patient has variant report (surgical_event_id: "PT_SS27_SEI1", molecular_id: "PT_SS27_MOI1", analysis_id: "PT_SS27_ANI1")
    And this variant report has value: "REJECTED" in field: "status"

#    This test case is not required
  Scenario Outline: PT_SS28. destination should be validated
    Given template specimen shipped message in type: "<type>" for patient: "<patient_id>", it has surgical_event_id: "<sei>", molecular_id: "<moi>", slide_barcode: "<barcode>"
    Then set patient message field: "destination" to value: "<destination>"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "<status>"
    Examples:
    |patient_id                   |sei              |moi              |barcode          |type       |destination   |status    |message                                    |
    |PT_SS28_TissueReceived1      |PT_SS28_TR1_SEI1 |PT_SS28_TR1_MOI1 |                 |TISSUE     |Mocha         |Success   |Message has been processed successfully    |
    |PT_SS28_TissueReceived2      |PT_SS28_TR2_SEI1 |PT_SS28_TR2_MOI1 |                 |TISSUE     |MDA           |Success   |Message has been processed successfully    |
    |PT_SS28_TissueReceived3      |PT_SS28_TR3_SEI1 |PT_SS28_TR3_MOI1 |                 |TISSUE     |Other         |Failure   |destination                                |
    |PT_SS28_TissueReceived4      |PT_SS28_TR4_SEI1 |                 |PT_SS28_TR4_BC1  |SLIDE      |MDA           |Success   |Message has been processed successfully    |
    |PT_SS28_TissueReceived5      |PT_SS28_TR5_SEI1 |                 |PT_SS28_TR5_BC1  |SLIDE      |Mocha         |Failure   |destination                                |
    |PT_SS28_BloodReceived1       |                 |PT_SS28_BR1_MOI1 |                 |BLOOD      |Mocha         |Success   |Message has been processed successfully    |
    |PT_SS28_BloodReceived2       |                 |PT_SS28_BR2_MOI1 |                 |BLOOD      |MDA           |Success   |Message has been processed successfully    |
    |PT_SS28_BloodReceived3       |                 |PT_SS28_BR3_MOI1 |                 |BLOOD      |mda           |Failure   |destination                                |

#  This test case is not required
#  Scenario Outline: PT_SS29. Blood and tissue shippment should has same destination (?? not sure)
#    Given template specimen shipped message in type: "BLOOD" for patient: "<patient_id>"
#    Then set patient message field: "destination" to value: "<blood_destination>"
#    Then set patient message field: "shipped_dttm" to value: "2016-08-01T15:17:11+00:00"
#    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"
#    Then wait for "15" seconds
#    Given template specimen shipped message in type: "TISSUE" for patient: "<patient_id>"
#    Then set patient message field: "destination" to value: "<tissue_destination>"
#    Then set patient message field: "shipped_dttm" to value: "2016-08-01T18:17:11+00:00"
#    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "<status>"
#    Examples:
#    |patient_id                 |blood_destination|tissue_destination|status    |message                                  |
#    |PT_SS29_BdAndTsReceived1   |MDA              |MDA               |Success   |Message has been processed successfully  |
#    |PT_SS29_BdAndTsReceived2   |Mocha            |Mocha             |Success   |Message has been processed successfully  |
#    |PT_SS29_BdAndTsReceived3   |Mocha            |MDA               |Failure   |destination                              |
#  Scenario Outline: PT_SS27. Blood specimen shippment will not affect other patient triggers
#For assay and pathology now they will fail if patient is in BLOOD_NUCLEIC_ACID_SHIPPED status
#  Incoming message failed patient state validation: State :BLOOD_NUCLEIC_ACID_SHIPPED doesn't exist