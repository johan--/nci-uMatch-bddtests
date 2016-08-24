#encoding: utf-8
#@patients
@specimen_shipped
Feature: NCH Specimen shipped messages
  Scenario: PT_SS01. Received specimen_shipped message for type 'BLOOD' from NCH for a patient who has already received the specimen_received message
    Given template specimen shipped message in type: "BLOOD" for patient: "PT_SS01_BloodReceived"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "15" seconds
    Then retrieve patient: "PT_SS01_BloodReceived" from API
    Then returned patient has value: "BLOOD_NUCLEIC_ACID_SHIPPED" in field: "current_status"

  Scenario: PT_SS02. Received specimen_shipped message for type 'TISSUE' from NCH for a patient who has already received the specimen_received message
#  Testing patient:PT_SS01_TissueReceived; surgical_event_id: SEI_TR_01
    Given template specimen shipped message in type: "TISSUE" for patient: "PT_SS02_TissueReceived"
    Then set patient message field: "surgical_event_id" to value: "SEI_TR_01"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "15" seconds
    Then retrieve patient: "PT_SS02_TissueReceived" from API
    Then returned patient has value: "TISSUE_NUCLEIC_ACID_SHIPPED" in field: "current_status"

  Scenario: PT_SS03. Received specimen_shipped message for type 'SLIDE' from NCH for a patient who has already received the specimen_received message
#  Testing patient:PT_SS03_TissueReceived; surgical_event_id: SEI_TR_02
    Given template specimen shipped message in type: "SLIDE" for patient: "PT_SS03_TissueReceived"
    Then set patient message field: "surgical_event_id" to value: "SEI_TR_02"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "15" seconds
    Then retrieve patient: "PT_SS03_TissueReceived" from API
    Then returned patient has value: "TISSUE_SLIDE_SPECIMEN_SHIPPED" in field: "current_status"

  Scenario Outline: PT_SS04. Shipment with invalid patient_id fails
    Given template specimen shipped message in type: "<type>" for patient: "<patient>"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "<status>"
    Examples:
    |type   |patient                |status   |message                                                        |
    |TISSUE |PT_SS04_NonExisting    |Failure  |Unable to find patient                                         |
    |BLOOD  |                       |Failure  |can't be blank                                                 |
    |SLIDE  |null                   |Failure  |can't be blank                                                 |

  Scenario Outline: PT_SS05. Shipment with invalid study_id fails
    #  Testing patient:PT_SS05_TissueReceived; surgical_event_id: SEI_01
    Given template specimen shipped message in type: "TISSUE" for patient: "PT_SS05_TissueReceived"
    Then set patient message field: "study_id" to value: "<study_id>"
    Then set patient message field: "surgical_event_id" to value: "SEI_01"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |study_id     |message                                                        |
      |other        |not a valid study_id                                           |
      |             |can't be blank                                                 |
      |null         |can't be blank                                                 |

  Scenario: PT_SS06. shipped_dttm older than received_dttm fails
#  Testing patient: PT_SS06_TissueReceived, surgical_event_id: SEI_01, received_dttm: 2016-04-25T16:17:11+00:00
    Given template specimen shipped message in type: "TISSUE" for patient: "PT_SS06_TissueReceived"
    Then set patient message field: "shipped_dttm" to value: "2016-03-25T16:17:11+00:00"
    When posted to MATCH patient trigger service, returns a message that includes "TBD" with status "Failure"

  Scenario: PT_SS06a. shipped_dttm should not be older than the latest shipped_dttm in the same surgical_event_id
    #Testing patient: PT_SS06a_TissueShipped, surgical_event_id: SEI_01, molecular_id: MOI_01 shipped 2016-05-01T19:42:13+00:00
    Given template specimen shipped message in type: "TISSUE" for patient: "PT_SS06a_TissueShipped"
    Then set patient message field: "molecular_id" to value: "MOI_02"
    Then set patient message field: "shipped_dttm" to value: "2016-05-01T15:42:13+00:00"
    When posted to MATCH patient trigger service, returns a message that includes "TBD" with status "Failure"

  Scenario Outline: PT_SS07. shipped tissue or slide with a non-exist surgical_event_id fails
    Given template specimen shipped message in type: "<type>" for patient: "PT_SS07_TissueReceived"
    Then set patient message field: "surgical_event_id" to value: "<SEI>"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
    |type   |SEI            |message                                                              |
    |TISSUE |badSEI         |Unable to find                                                       |
    |SLIDE  |               |can't be blank                                                       |

  Scenario Outline: PT_SS08. tissue or slide with an expired surgical_event_id fails
#  Testing patient: PT_SS08_TissueReceived
#  surgical event: SEI_01 received Then SEI_02 received (SEI_01 expired)
    Given template specimen shipped message in type: "<type>" for patient: "PT_SS08_TissueReceived"
    Then set patient message field: "shipped_dttm" to value: "current"
    When posted to MATCH patient trigger service, returns a message that includes "not currently active" with status "Failure"
    Examples:
    |type     |
    |TISSUE   |
    |SLIDE    |

  Scenario Outline: PT_SS09. shipped tissue or slide without surgical_event_id fails
    Given template specimen shipped message in type: "<type>" for patient: "PT_SS09_TissueReceived"
    Then remove field: "surgical_event_id" from patient message
    When posted to MATCH patient trigger service, returns a message that includes "surgical_event_id" with status "Failure"
    Examples:
      |type     |
      |TISSUE   |
      |SLIDE    |

  Scenario Outline: PT_SS10. shipped tissue without molecular_id or molecular_dna_id or molecular_cdna_id fails
    Given template specimen shipped message in type: "TISSUE" for patient: "PT_SS10_TissueReceived"
    Then remove field: "<field>" from patient message
    When posted to MATCH patient trigger service, returns a message that includes "<field>" with status "Failure"
    Examples:
      |field              |
      |molecular_id       |
      |molecular_dna_id   |
      |molecular_cdna_id  |

  Scenario Outline: PT_SS11. shipped tissue with a existing surgical_event_id + molecular_id combination fails
#  Testing patient: PT_SS11_Tissue1Shipped, surgical_event_id: SEI_01
#    molecular_id: MOI_01 has shipped and MOI_02 has shipped
    Given template specimen shipped message in type: "TISSUE" for patient: "PT_SS11_Tissue1Shipped"
    Then set patient message field: "molecular_id" to value: "<moi>"
    Then set patient message field: "shipped_dttm" to value: "2016-05-01T15:42:13+00:00"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
    |moi            |message                                  |
    |MOI_01         |molecular id                             |
    |MOI_02         |molecular id                             |

  Scenario: PT_SS12. shipped tissue with a new molecular_id in latest surgical_event_id pass
#  Testing patient: PT_SS12_Tissue1Shipped, surgical_event_id: SEI_01
#    molecular_id: MOI_01 has shipped
    Given template specimen shipped message in type: "TISSUE" for patient: "PT_SS12_Tissue1Shipped"
    Then set patient message field: "molecular_id" to value: "MOI_02"
    Then set patient message field: "shipped_dttm" to value: "current"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "15" seconds
    Then retrieve patient: "PT_SS12_Tissue1Shipped" from API
    Then returned patient has specimen (surgical_event_id: "SEI_01")
    And this specimen has value: "MOI_02" in field: "active_molecular_id"


    #This is not required
#  Scenario: PT_SS13. shipped slide with molecular_id fails
##  Testing patient: PT_SS13_TissueReceived, surgical_event_id: SEI_01
#    Given template specimen shipped message in type: "SLIDE" for patient: "PT_SS13_TissueReceived"
#    Then set patient message field: "surgical_event_id" to value: "SEI_TR_1"
#    Then set patient message field: "molecular_id" to value: "MOI_01"
#    When posted to MATCH patient trigger service, returns a message that includes "cannot transition from" with status "Failure"

  Scenario: PT_SS14. shipped slide without slide_barcode fails
#  Testing patient: PT_SS14_TissueReceived, surgical_event_id: SEI_01
    Given template specimen shipped message in type: "SLIDE" for patient: "PT_SS14_TissueReceived"
    Then set patient message field: "surgical_event_id" to value: "SEI_TR_1"
    Then remove field: "slide_barcode" from patient message
    When posted to MATCH patient trigger service, returns a message that includes "can't be blank" with status "Failure"

  Scenario: PT_SS15. shipped slide with new barcode passes
#  Testing patient: PT_SS15_Slide1Shipped, surgical_event_id: SEI_01
#    slide with barcode: BC_001 has been shipped
    Given template specimen shipped message in type: "SLIDE" for patient: "PT_SS15_Slide1Shipped"
    Then set patient message field: "slide_barcode" to value: "BC_002"
    Then set patient message field: "shipped_dttm" to value: "current"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"

  Scenario: PT_SS16. shipped slide with a existing surgical_event_id + slide_barcode combination fails
#  Testing patient: PT_SS16_Slide1Shipped, surgical_event_id: SEI_01
#    slide with barcode: BC_001 has been shipped
    Given template specimen shipped message in type: "SLIDE" for patient: "PT_SS16_Slide1Shipped"
    Then set patient message field: "slide_barcode" to value: "BC_001"
    Then set patient message field: "shipped_dttm" to value: "2016-05-01T15:42:13+00:00"
    When posted to MATCH patient trigger service, returns a message that includes "TBD" with status "Failure"

  Scenario: PT_SS17. shipped blood without blood received fails
#  Testing patient: PT_SS17_Registered
#     These is no blood specimen received event in this patient
    Given template specimen shipped message in type: "BLOOD" for patient: "PT_SS17_Registered"
    When posted to MATCH patient trigger service, returns a message that includes "TBD" with status "Failure"

    #this test case is not required
#  Scenario: PT_SS18. shipped blood with SEI fails
#    Given template specimen shipped message in type: "BLOOD" for patient: "PT_SS18_BloodReceived"
#    Then set patient message field: "surgical_event_id" to value: "SEI_BR_1"
#    When posted to MATCH patient trigger service, returns a message that includes "TBD" with status "Failure"

  Scenario: PT_SS20. shipped blood with new molecular_id (in this patient) passes
#  Testing patient: PT_SS20_Blood1Shipped
#    blood molecular_id: MOI_BR_01 has shipped
    Given template specimen shipped message in type: "BLOOD" for patient: "PT_SS20_Blood1Shipped"
    Then set patient message field: "molecular_id" to value: "MOI_BR_02"
    Then set patient message field: "shipped_dttm" to value: "2016-05-01T15:42:13+00:00"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"
    Then wait for "15" seconds
    Then retrieve patient: "PT_SS20_Blood1Shipped" from API
    Then returned patient's blood specimen has value: "MOI_BR_02" in field: "active_molecular_id"

#  data not ready yet
#  Scenario: PT_SS21. Tissue cannot be shipped if there is one tissue variant report get confirmed
##    Testing patient: PT_SS21_TissueVariantConfirmed, surgical_event_id: SEI_01, molecular_id: MOI_01, analysis_id: ANI_01
##      this patient has TISSUE_VARIANT_REPORT_CONFIRMED status
#    Given template specimen shipped message in type: "TISSUE" for patient: "PT_SS21_TissueVariantConfirmed"
#    Then set patient message field: "molecular_id" to value: "MOI_02"
#    Then set patient message field: "shipped_dttm" to value: "current"
#    When posted to MATCH patient trigger service, returns a message that includes "cannot transition from" with status "Failure"

#  data not ready yet
#  Scenario: PT_SS22. Blood cannot be shipped if there is one blood variant report get confirmed
##    Testing patient: PT_SS21_BloodVariantConfirmed, molecular_id: MOI_BR_01, analysis_id: ANI_01
##      this patient has BLOOD_VARIANT_REPORT_CONFIRMED status
#    Given template specimen shipped message in type: "BLOOD" for patient: "PT_SS22_BloodVariantConfirmed"
#    Then set patient message field: "molecular_id" to value: "MOI_BR_02"
#    Then set patient message field: "shipped_dttm" to value: "current"
#    When posted to MATCH patient trigger service, returns a message that includes "cannot transition from" with status "Failure"

  Scenario Outline: PT_SS23. Tissue shipment and slide shipment should not depend on each other
    Given template specimen shipped message in type: "<type>" for patient: "<patient_id>"
    Then set patient message field: "shipped_dttm" to value: "2016-05-01T15:42:13+00:00"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"
    Examples:
    |type   |patient_id                 |
    |TISSUE |PT_SS23_TissueReceived1    |
    |SLIDE  |PT_SS23_TissueReceived2    |
    |TISSUE |PT_SS23_SlideShipped       |
    |SLIDE  |PT_SS23_TissueShipped      |
    
  Scenario Outline: PT_SS24. Tissue shipment and blood shipment should not use same molecular_id
#    Testing patient: PT_SS24_BloodShipped,
#                          Blood shipped MOI_BR_01,
#                          Tissue received SEI_01,try to ship it using MOI_BR_01
#                     PT_SS24_TissueShipped,
#                          Tissue shipped SEI_01, MOI_01,
#                          Blood received, try to ship it using MOI_01
    Given template specimen shipped message in type: "<type>" for patient: "<patient_id>"
    Then set patient message field: "molecular_id" to value: "<moi>"
    Then set patient message field: "shipped_dttm" to value: "2016-05-01T15:42:13+00:00"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
    |patient_id             |type       |moi      |message                                                  |
    |PT_SS24_BloodShipped   |TISSUE     |MOI_BR_01|TBD                                                      |
    |PT_SS24_TissueShipped  |BLOOD      |MOI_01   |TBD                                                      |

  Scenario Outline: PT_SS25. Blood shipment use old blood molecular_id should fail
#    Testing patient: PT_SS25_BloodShipped, MOI_BR_01 has been shipped, MOI_BR_02 has been shipped
    Given template specimen shipped message in type: "BLOOD" for patient: "PT_SS25_BloodShipped"
    Then  set patient message field: "molecular_id" to value: "<moi>"
    Then set patient message field: "shipped_dttm" to value: "<ship_time>"
    When posted to MATCH patient trigger service, returns a message that includes "same molecular id" with status "Failure"
    Examples:
    |moi              |ship_time                  |
    |MOI_BR_01        |2016-05-01T15:42:13+00:00  |
    |MOI_BR_02        |2016-05-01T16:42:13+00:00  |


  Scenario Outline: PT_SS26. Blood specimen can only be shipped in certain status (blood specimen has been received before)
    Given template specimen shipped message in type: "BLOOD" for patient: "<patient_id>"
    Then  set patient message field: "molecular_id" to value: "MOI_BR_01"
    Then set patient message field: "shipped_dttm" to value: "2016-07-28T15:17:11+00:00"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "<status>"
    Examples:
    |patient_id                     |status     |message                                    |
    |PT_SS26_TsReceived             |Success    |Message has been processed successfully    |
    |PT_SS26_TsShipped              |Success    |Message has been processed successfully    |
#    |PT_SS26_AssayConfirmed         |Success    |Message has been processed successfully    |
#    |PT_SS26_PathologyConfirmed     |Success    |Message has been processed successfully    |
#    |PT_SS26_TsVRReceived           |Success    |Message has been processed successfully    |
#    |PT_SS26_TsVRConfirmed          |Success    |Message has been processed successfully    |
#    |PT_SS26_WaitingPtData          |Success    |Message has been processed successfully    |
#    |PT_SS26_PendingApproval        |Success    |Message has been processed successfully    |
#    |PT_SS26_Progression            |Success    |Message has been processed successfully    |
#    |PT_SS26_OffStudy               |Failure    |cannot transition from                     |

#data not ready yet
#  Scenario: PT_SS27. new specimen shipped using new MOI in same SEI will push all pending variant report from old MOI to "REJECT"
#  #    Test patient: PT_SS27_VariantReportUploaded; variant report files uploaded: surgical_event_id: SEI_01, molecular_id: MOI_01, analysis_id: ANI_01
#  #          Plan to ship new specimen using same surgical_event_id: SEI_01 but new molecular_id MOI_02
#    Given template specimen shipped message in type: "TISSUE" for patient: "PT_SS27_VariantReportUploaded"
#    Then set patient message field: "surgical_event_id" to value: "SEI_01"
#    Then set patient message field: "molecular_id" to value: "MOI_02"
#    Then set patient message field: "molecular_dna_id" to value: "MOI_02D"
#    Then set patient message field: "molecular_cdna_id" to value: "MOI_02C"
#    Then set patient message field: "shipped_dttm" to value: "2016-08-01T15:17:11+00:00"
#    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"
#    Then wait for "15" seconds
#    Then retrieve patient: "PT_SS27_VariantReportUploaded" from API
#    Then returned patient has value: "TISSUE_NUCLEIC_ACID_SHIPPED" in field: "current_status"
#    Then returned patient has variant report (surgical_event_id: "SEI_01", molecular_id: "MOI_01", analysis_id: "ANI_01")
#    And this variant report has value: "REJECTED" in field: "status"

  Scenario Outline: PT_SS28. destination should be validated
    Given template specimen shipped message in type: "<type>" for patient: "<patient_id>"
    Then set patient message field: "destination" to value: "<destination>"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "<status>"
    Examples:
    |patient_id                   |type       |destination   |status    |message                                    |
    |PT_SS28_TissueReceived1      |TISSUE     |Mocha         |Success   |Message has been processed successfully    |
    |PT_SS28_TissueReceived2      |TISSUE     |MDA           |Success   |Message has been processed successfully    |
    |PT_SS28_TissueReceived3      |TISSUE     |Other         |Failure   |destination                                |
    |PT_SS28_TissueReceived4      |SLIDE      |MDA           |Success   |Message has been processed successfully    |
    |PT_SS28_TissueReceived5      |SLIDE      |Mocha         |Failure   |destination                                |
    |PT_SS28_BloodReceived1       |BLOOD      |Mocha         |Success   |Message has been processed successfully    |
    |PT_SS28_BloodReceived2       |BLOOD      |MDA           |Success   |Message has been processed successfully    |
    |PT_SS28_BloodReceived3       |BLOOD      |mda           |Failure   |destination                                |

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