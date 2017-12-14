#encoding: utf-8
@specimen_shipped
Feature: NCH Specimen shipped messages

  Background:
    Given patient API user authorization role is "SPECIMEN_MESSAGE_SENDER"

  @patients_p3
  Scenario: PT_SS01. Received specimen_shipped message for type 'BLOOD' from NCH for a patient who has already received the specimen_received message
    Given patient id is "PT_SS01_BloodReceived"
    And load template specimen type: "BLOOD" shipped message for this patient
    Then set patient message field: "molecular_id" to value: "PT_SS01_BloodReceived_BD_MOI1"
    Then set patient message field: "shipped_dttm" to value: "current"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then wait until patient specimen is updated
    Then patient should have specimen (field: "active_molecular_id" is "PT_SS01_BloodReceived_BD_MOI1")

  @patients_p1
  Scenario: PT_SS02. Received specimen_shipped message for type 'TISSUE' from NCH for a patient who has already received the specimen_received message
  #  Testing patient:PT_SS02_TissueReceived; surgical_event_id: PT_SS02_TissueReceived_SEI1
    Given patient id is "PT_SS02_TissueReceived"
    And load template specimen type: "TISSUE" shipped message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_SS02_TissueReceived_SEI1"
    Then set patient message field: "molecular_id" to value: "PT_SS02_TissueReceived_MOI1"
    Then set patient message field: "shipped_dttm" to value: "current"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "TISSUE_NUCLEIC_ACID_SHIPPED"
    Then patient should have specimen (field: "active_molecular_id" is "PT_SS02_TissueReceived_MOI1")

  @patients_p2
  Scenario: PT_SS02b. specimen_shipped message shouldn't be processed twice if sent twice quickly
    Given patient id is "PT_SS02b_TissueReceived"
    And load template specimen type: "TISSUE" shipped message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_SS02b_TissueReceived_SEI1"
    Then set patient message field: "molecular_id" to value: "PT_SS02b_TissueReceived_MOI1"
    Then set patient message field: "shipped_dttm" to value: "current"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    When POST to MATCH patients service
    Then patient status should change to "TISSUE_NUCLEIC_ACID_SHIPPED"
    Then wait for "30" seconds
    Then patient should have one shipment with molecular_id "PT_SS02b_TissueReceived_MOI1"

  @patients_p2
  Scenario: PT_SS02a. Received specimen_shipped message for type 'TISSUE' from NCH for a patient who has TISSUE_VARIANT_REPORT_REJECTED status
    Given patient id is "PT_SS02a_TsVrRejected"
    And load template specimen type: "TISSUE" shipped message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_SS02a_TsVrRejected_SEI1"
    Then set patient message field: "molecular_id" to value: "PT_SS02a_TsVrRejected_MOI2"
    Then set patient message field: "shipped_dttm" to value: "current"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "TISSUE_NUCLEIC_ACID_SHIPPED"
    Then patient should have specimen (field: "active_molecular_id" is "PT_SS02a_TsVrRejected_MOI2")

  @patients_p2
  Scenario: PT_SS02b. Leading or ending whitespace in molecular id value should be ignored
    Given patient id is "PT_SS02b_TsReceived"
    And load template specimen type: "TISSUE" shipped message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_SS02b_TsReceived_SEI1"
    Then set patient message field: "molecular_id" to value: " PT_SS02b_TsReceived_MOI1"
    Then set patient message field: "shipped_dttm" to value: "current"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "TISSUE_NUCLEIC_ACID_SHIPPED"
    Then patient should have specimen (field: "active_molecular_id" is "PT_SS02b_TsReceived_MOI1")
    Then set patient message field: "molecular_id" to value: "PT_SS02b_TsReceived_MOI2 "
    Then set patient message field: "shipped_dttm" to value: "current"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then wait until patient is updated
    Then patient should have specimen (field: "active_molecular_id" is "PT_SS02b_TsReceived_MOI2")

  @patients_p1
  Scenario: PT_SS03. Received specimen_shipped message for type 'SLIDE' from NCH for a patient who has already received the specimen_received message
  #  Testing patient:PT_SS03_TissueReceived; surgical_event_id: PT_SS03_TissueReceived_SEI1
    Given patient id is "PT_SS03_TissueReceived"
    And load template specimen type: "SLIDE" shipped message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_SS03_TissueReceived_SEI1"
    Then set patient message field: "slide_barcode" to value: "PT_SS03_TissueReceived_BC1"
    Then set patient message field: "shipped_dttm" to value: "current"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "TISSUE_SLIDE_SPECIMEN_SHIPPED"

  @patients_p2
  Scenario Outline: PT_SS04. Shipment with invalid patient_id fails
    Given patient id is "<patient>"
    And load template specimen type: "<type>" shipped message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_SS04_SEI1"
    Then set patient message field: "molecular_id" to value: "PT_SS04_ID1"
    Then set patient message field: "shipped_dttm" to value: "current"
    When POST to MATCH patients service, response includes "<message>" with code "<http_code>"
    Examples:
      | type   | patient             | http_code | message                |
      | TISSUE | PT_SS04_NonExisting | 403       | Unable to find patient |
    #since now patient_id need to be appear in the url of webservice, so it's impossible to make the following mistake
#    |BLOOD  |                       |Failure  |can't be blank                                                 |
#    |SLIDE  |null                   |Failure  |can't be blank                                                 |

  @patients_p2
  Scenario Outline: PT_SS05. Shipment with invalid study_id fails
  #  Testing patient:PT_SS05_TissueReceived; surgical_event_id: PT_SS05_TissueReceived_SEI1
    Given patient id is "PT_SS05_TissueReceived"
    And load template specimen type: "TISSUE" shipped message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_SS05_TissueReceived_SEI1"
    Then set patient message field: "molecular_id" to value: "PT_SS05_TissueReceived_MOI1"
    Then set patient message field: "study_id" to value: "<study_id>"
    Then set patient message field: "shipped_dttm" to value: "current"
    When POST to MATCH patients service, response includes "<message>" with code "403"
    Examples:
      | study_id | message              |
      | other    | not a valid study_id |
      |          | can't be blank       |
      | null     | can't be blank       |

#  @patients_p2
  Scenario: PT_SS06. shipped_dttm older than collection_dt fails
  #  Testing patient: PT_SS06_TissueReceived, surgical_event_id: PT_SS06_TissueReceived_SEI1, collected_date: "2016-04-25T15:17:11+00:00",
    Given patient id is "PT_SS06_TissueReceived"
    And load template specimen type: "TISSUE" shipped message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_SS06_TissueReceived_SEI1"
    Then set patient message field: "molecular_id" to value: "PT_SS06_TissueReceived_MOI1"
    Then set patient message field: "shipped_dttm" to value: "2016-03-25T16:17:11+00:00"
    When POST to MATCH patients service, response includes "collected date" with code "403"

    #this test case is not required
#  Scenario: PT_SS06a. shipped_dttm should not be older than the latest shipped_dttm in the same surgical_event_id
#    #Testing patient: PT_SS06a_TissueShipped, surgical_event_id: PT_SS06a_TissueShipped_SEI1, molecular_id: PT_SS06a_TissueShipped_MOI1 shipped 2016-05-01T19:42:13+00:00
#    Given template specimen shipped message in type: "TISSUE" for patient: "PT_SS06a_TissueShipped", it has surgical_event_id: "PT_SS06a_TissueShipped_SEI1", molecular_id: "PT_SS06a_TissueShipped_MOI2", slide_barcode: ""
#    Then set patient message field: "shipped_dttm" to value: "2016-05-01T15:42:13+00:00"
#    When POST to MATCH patients service, response includes "TBD" with status "Failure"

  @patients_p2
  Scenario Outline: PT_SS07. shipped tissue or slide with a non-exist surgical_event_id fails
  #  Testing patient: PT_SS07_TissueReceived, surgical_event_id: PT_SS07_TissueReceived_SEI1
    Given patient id is "PT_SS07_TissueReceived"
    And load template specimen type: "<type>" shipped message for this patient
    Then set patient message field: "surgical_event_id" to value: "<sei>"
    Then set patient message field: "<field>" to value: "<value>"
    Then set patient message field: "shipped_dttm" to value: "current"
    When POST to MATCH patients service, response includes "<message>" with code "403"
    Examples:
      | type   | sei    | field         | value                       | message        |
      | TISSUE | badSEI | molecular_id  | PT_SS07_TissueReceived_MOI1 | Unable to find |
      | SLIDE  |        | slide_barcode | PT_SS07_TissueReceived_BC1  | can't be blank |

  @patients_p2
  Scenario Outline: PT_SS08. tissue or slide with an expired surgical_event_id fails
  #  Testing patient: PT_SS08_TissueReceived
  #  surgical event: PT_SS08_TissueReceived_SEI1 received Then PT_SS08_TissueReceived_SEI2 received (PT_SS08_TissueReceived_SEI1 expired)
    Given patient id is "PT_SS08_TissueReceived"
    And load template specimen type: "<type>" shipped message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_SS08_TissueReceived_SEI1"
    Then set patient message field: "<field>" to value: "<value>"
    Then set patient message field: "shipped_dttm" to value: "current"
    When POST to MATCH patients service, response includes "not currently active" with code "403"
    Examples:
      | type   | field         | value                       |
      | TISSUE | molecular_id  | PT_SS08_TissueReceived_MOI1 |
      | SLIDE  | slide_barcode | PT_SS08_TissueReceived_BC1  |

  @patients_p2
  Scenario Outline: PT_SS08a. tissue or slide with an active surgical_event_id but doesn't belong to this patient fails
  #    Test patients: PT_SS08a_TissueReceived1a has tissue received with sei PT_SS08a_TissueReceived1a_SEI1,
  #                   PT_SS08a_TissueReceived1b has tissue received with sei PT_SS08a_TissueReceived1b_SEI1,
  #    Test patients: PT_SS08a_TissueReceived2a has tissue received with sei PT_SS08a_TissueReceived2a_SEI1,
  #                   PT_SS08a_TissueReceived2b has tissue received with sei PT_SS08a_TissueReceived2b_SEI1
    Given patient id is "<patient_id>"
    And load template specimen type: "<type>" shipped message for this patient
    Then set patient message field: "surgical_event_id" to value: "<sei>"
    Then set patient message field: "<field>" to value: "<value>"
    Then set patient message field: "shipped_dttm" to value: "current"
    When POST to MATCH patients service, response includes "surgical" with code "403"
    Examples:
      | patient_id                | sei                            | field         | value                          | type   |
      | PT_SS08a_TissueReceived1a | PT_SS08a_TissueReceived1b_SEI1 | molecular_id  | PT_SS08a_TissueReceived1a_MOI1 | TISSUE |
      | PT_SS08a_TissueReceived2a | PT_SS08a_TissueReceived2b_SEI1 | slide_barcode | PT_SS08a_TissueReceived2a_BC1  | SLIDE  |

  @patients_p2
  Scenario Outline: PT_SS09. shipped tissue or slide without surgical_event_id fails
  #  Testing patient: PT_SS09_TissueReceived, surgical_event_id: PT_SS09_TissueReceived_SEI1
    Given patient id is "PT_SS09_TissueReceived"
    And load template specimen type: "<type>" shipped message for this patient
    Then set patient message field: "<field>" to value: "PT_SS09_TissueReceived_ID1"
    Then remove field: "surgical_event_id" from patient message
    Then set patient message field: "shipped_dttm" to value: "current"
    When POST to MATCH patients service, response includes "surgical" with code "403"
    Examples:
      | type   | field         |
      | TISSUE | molecular_id  |
      | SLIDE  | slide_barcode |

  @patients_p2
  Scenario Outline: PT_SS10. shipped tissue without molecular_id fails
  #or molecular_dna_id or molecular_cdna_id fails   ######not required any more
  #  Testing patient: PT_SS10_TissueReceived, surgical_event_id: PT_SS10_TissueReceived_SEI1
    Given patient id is "PT_SS10_TissueReceived"
    And load template specimen type: "TISSUE" shipped message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_SS10_TissueReceived_SEI1"
    Then remove field: "<field>" from patient message
    Then set patient message field: "shipped_dttm" to value: "current"
    When POST to MATCH patients service, response includes "<field>" with code "403"
    Examples:
      | field        |
      | molecular_id |
     ######not required any more
#      | molecular_dna_id  |
#      | molecular_cdna_id |

  @patients_p2
  Scenario Outline: PT_SS11. shipped tissue with a existing surgical_event_id + molecular_id combination fails
  #  Testing patient: PT_SS11_Tissue1Shipped, surgical_event_id: PT_SS11_Tissue1Shipped_SEI1
  #    molecular_id: PT_SS11_Tissue1Shipped_MOI1 has shipped and PT_SS11_Tissue1Shipped_MOI2 has shipped
    Given patient id is "PT_SS11_Tissue1Shipped"
    And load template specimen type: "TISSUE" shipped message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_SS11_Tissue1Shipped_SEI1"
    Then set patient message field: "molecular_id" to value: "<moi>"
    Then set patient message field: "shipped_dttm" to value: "current"
    When POST to MATCH patients service, response includes "<message>" with code "403"
    Examples:
      | moi                         | message           |
      | PT_SS11_Tissue1Shipped_MOI1 | same molecular id |
      | PT_SS11_Tissue1Shipped_MOI2 | same molecular id |

  @patients_p2
  Scenario Outline: PT_SS11a. shipment with molecular_id (or barcode) that was used in previous step should fail
#    patient: "PT_SS11a_Step2TsReceived1" with status: "TISSUE_SPECIMEN_RECEIVED" on step: "2.0"
#    patient: "PT_SS11a_Step2TsReceived2" with status: "TISSUE_SPECIMEN_RECEIVED" on step: "2.0"
#    patient: "PT_SS11a_Step2BdReceived" with status: "REQUEST_ASSIGNMENT" on step: "2.0"
#    moi or barcode has been used in step 1.0
    Given patient id is "<patient_id>"
    And load template specimen type: "<type>" shipped message for this patient
    Then set patient message field: "surgical_event_id" to value: "<sei>"
    Then set patient message field: "<field>" to value: "<value>"
    Then set patient message field: "destination" to value: "MDA"
    Then set patient message field: "shipped_dttm" to value: "current"
    When POST to MATCH patients service, response includes "<message>" with code "403"
    Examples:
      | patient_id                | sei                            | field         | value                            | type   | message           |
      | PT_SS11a_Step2TsReceived1 | PT_SS11a_Step2TsReceived1_SEI2 | molecular_id  | PT_SS11a_Step2TsReceived1_MOI1   | TISSUE | same molecular id |
      | PT_SS11a_Step2TsReceived2 | PT_SS11a_Step2TsReceived2_SEI2 | slide_barcode | PT_SS11a_Step2TsReceived2_BC1    | SLIDE  | slide barcode     |
      | PT_SS11a_Step2BdReceived  |                                | molecular_id  | PT_SS11a_Step2BdReceived_BD_MOI1 | BLOOD  | same molecular id |


  @patients_p2
  Scenario: PT_SS12. shipped tissue with a new molecular_id in latest surgical_event_id pass
  #  Testing patient: PT_SS12_Tissue1Shipped, surgical_event_id: PT_SS12_Tissue1Shipped_SEI1
  #    molecular_id: PT_SS12_Tissue1Shipped_MOI1 has shipped
    Given patient id is "PT_SS12_Tissue1Shipped"
    And load template specimen type: "TISSUE" shipped message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_SS12_Tissue1Shipped_SEI1"
    Then set patient message field: "molecular_id" to value: "PT_SS12_Tissue1Shipped_MOI2"
    Then set patient message field: "shipped_dttm" to value: "current"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then wait until patient specimen is updated
    Then patient should have specimen (field: "surgical_event_id" is "PT_SS12_Tissue1Shipped_SEI1")
    Then this specimen field: "active_molecular_id" should be: "PT_SS12_Tissue1Shipped_MOI2"


    #This is not required
#  Scenario: PT_SS13. shipped slide with molecular_id fails
##  Testing patient: PT_SS13_TissueReceived, surgical_event_id: SEI_01
#    Given template specimen shipped message in type: "SLIDE" for patient: "PT_SS13_TissueReceived"
#    Then set patient message field: "surgical_event_id" to value: "SEI_TR_1"
#    Then set patient message field: "molecular_id" to value: "MOI_01"
#    When POST to MATCH patients service, response includes "cannot transition from" with status "Failure"

  @patients_p2
  Scenario: PT_SS14. shipped slide without slide_barcode fails
  #  Testing patient: PT_SS14_TissueReceived, surgical_event_id: PT_SS14_TissueReceived_SEI1
    Given patient id is "PT_SS14_TissueReceived"
    And load template specimen type: "SLIDE" shipped message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_SS14_TissueReceived_SEI1"
    Then set patient message field: "slide_barcode" to value: "PT_SS14_TissueReceived_BC1"
    Then remove field: "slide_barcode" from patient message
    Then set patient message field: "shipped_dttm" to value: "current"
    When POST to MATCH patients service, response includes "can't be blank" with code "403"

  @patients_p2
  Scenario: PT_SS15. shipped slide with new barcode passes
  #  Testing patient: PT_SS15_Slide1Shipped, surgical_event_id: PT_SS15_Slide1Shipped_SEI1
  #    slide with barcode: PT_SS15_Slide1Shipped_BC1 has been shipped
    Given patient id is "PT_SS15_Slide1Shipped"
    And load template specimen type: "SLIDE" shipped message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_SS15_Slide1Shipped_SEI1"
    Then set patient message field: "slide_barcode" to value: "PT_SS15_Slide1Shipped_BC2"
    Then set patient message field: "shipped_dttm" to value: "current"
    When POST to MATCH patients service, response includes "successfully" with code "202"

  @patients_p2
  Scenario: PT_SS16. shipped slide with a existing surgical_event_id + slide_barcode combination fails
#  Testing patient: PT_SS16_Slide1Shipped, surgical_event_id: PT_SS16_Slide1Shipped_SEI1
#    slide with barcode: PT_SS16_Slide1Shipped_BC1 has been shipped
    Given patient id is "PT_SS16_Slide1Shipped"
    And load template specimen type: "SLIDE" shipped message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_SS16_Slide1Shipped_SEI1"
    Then set patient message field: "slide_barcode" to value: "PT_SS16_Slide1Shipped_BC1"
    Then set patient message field: "shipped_dttm" to value: "current"
    When POST to MATCH patients service, response includes "slide barcode already exists" with code "403"

  @patients_p2
  Scenario: PT_SS17a. shipped tissue without tissue received fails
    Given patient id is "PT_SS17a_Registered"
    And load template specimen type: "TISSUE" shipped message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_SS17a_Registered_SEI1"
    Then set patient message field: "molecular_id" to value: "PT_SS17a_Registered_MOI1"
    When POST to MATCH patients service, response includes "Unable to find a TISSUE specimen" with code "403"

  @patients_p2
  Scenario: PT_SS17b. shipped slide without tissue received fails
    Given patient id is "PT_SS17b_Registered"
    And load template specimen type: "SLIDE" shipped message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_SS17b_Registered_SEI1"
    Then set patient message field: "slide_barcode" to value: "PT_SS17b_Registered_BC1"
    Then set patient message field: "shipped_dttm" to value: "current"
    When POST to MATCH patients service, response includes "Unable to find a TISSUE specimen" with code "403"

  @patients_p2
  Scenario: PT_SS17. shipped blood without blood received fails
  #  Testing patient: PT_SS17_Registered
  #     These is no blood specimen received event in this patient
    Given patient id is "PT_SS17_Registered"
    And load template specimen type: "BLOOD" shipped message for this patient
    Then set patient message field: "surgical_event_id" to value: ""
    Then set patient message field: "molecular_id" to value: "PT_SS17_Registered_BD_MOI1"
    Then set patient message field: "shipped_dttm" to value: "current"
    When POST to MATCH patients service, response includes "Unable to find a BLOOD specimen" with code "403"

    #this test case is not required
#  Scenario: PT_SS18. shipped blood with SEI fails
#    Given template specimen shipped message in type: "BLOOD" for patient: "PT_SS18_BloodReceived"
#    Then set patient message field: "surgical_event_id" to value: "SEI_BR_1"
#    When POST to MATCH patients service, response includes "TBD" with status "Failure"

  @patients_p3
  Scenario: PT_SS20. shipped blood with new molecular_id (in this patient) passes
  #  Testing patient: PT_SS20_Blood1Shipped
  #    blood molecular_id: PT_SS20_Blood1Shipped_BD_MOI1 has shipped
    Given patient id is "PT_SS20_Blood1Shipped"
    And load template specimen type: "BLOOD" shipped message for this patient
    Then set patient message field: "molecular_id" to value: "PT_SS20_Blood1Shipped_BD_MOI2"
    Then set patient message field: "shipped_dttm" to value: "current"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then wait until patient specimen is updated
    Then patient should have specimen (field: "active_molecular_id" is "PT_SS20_Blood1Shipped_BD_MOI2")
    And this specimen field: "specimen_type" should be: "BLOOD"

  @patients_p2
  Scenario Outline: PT_SS21. Tissue cannot be shipped if there is one tissue variant report get confirmed
  #    Testing patient: PT_SS21_TissueVariantConfirmed, surgical_event_id: PT_SS21_TissueVariantConfirmed_SEI1, molecular_id: PT_SS21_TissueVariantConfirmed_MOI1, analysis_id: PT_SS21_TissueVariantConfirmed_ANI1
  #      this patient has TISSUE_VARIANT_REPORT_CONFIRMED status
    Given patient id is "<patient_id>"
    And load template specimen type: "TISSUE" shipped message for this patient
    Then set patient message field: "surgical_event_id" to value: "<patient_id>_SEI1"
    Then set patient message field: "molecular_id" to value: "<patient_id>_MOI2"
    Then set patient message field: "shipped_dttm" to value: "current"
    When POST to MATCH patients service, response includes "confirmed variant report" with code "403"
    Examples:
      | patient_id                     |
      | PT_SS21_TissueVariantConfirmed |
      | PT_SS21_RbRequested            | new


  @patients_p2
  Scenario Outline: PT_SS23. Tissue shipment and slide shipment should not depend on each other
    Given patient id is "<patient_id>"
    And load template specimen type: "<type>" shipped message for this patient
    Then set patient message field: "surgical_event_id" to value: "<sei>"
    Then set patient message field: "<field>" to value: "<value>"
    Then set patient message field: "shipped_dttm" to value: "current"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Examples:
      | type   | patient_id              | sei                          | field         | value                        |
      | TISSUE | PT_SS23_TissueReceived1 | PT_SS23_TissueReceived1_SEI1 | molecular_id  | PT_SS23_TissueReceived1_MOI1 |
      | SLIDE  | PT_SS23_TissueReceived2 | PT_SS23_TissueReceived2_SEI1 | slide_barcode | PT_SS23_TissueReceived2_BC1  |
      | TISSUE | PT_SS23_SlideShipped    | PT_SS23_SlideShipped_SEI1    | molecular_id  | PT_SS23_SlideShipped_MOI1    |
      | SLIDE  | PT_SS23_TissueShipped   | PT_SS23_TissueShipped_SEI1   | slide_barcode | PT_SS23_TissueShipped_BC1    |

  @patients_p3
  Scenario Outline: PT_SS24. Tissue shipment and blood shipment should not use same molecular_id
  #    Testing patient: PT_SS24_BloodShipped,
  #                          Blood shipped PT_SS24_BloodShipped_BD_MOI1,
  #                          Tissue received PT_SS24_BloodShipped_SEI1,try to ship it using PT_SS24_BloodShipped_BD_MOI1
  #                     PT_SS24_TissueShipped,
  #                          Tissue shipped PT_SS24_TissueShipped_SEI1, PT_SS24_TissueShipped_MOI1,
  #                          Blood received, try to ship it using PT_SS24_TissueShipped_MOI1
    Given patient id is "<patient_id>"
    And load template specimen type: "<type>" shipped message for this patient
    Then set patient message field: "surgical_event_id" to value: "<sei>"
    Then set patient message field: "molecular_id" to value: "<moi>"
    Then set patient message field: "shipped_dttm" to value: "current"
    When POST to MATCH patients service, response includes "<message>" with code "403"
    Examples:
      | patient_id            | type   | sei                       | moi                          | message                          |
      | PT_SS24_BloodShipped  | TISSUE | PT_SS24_BloodShipped_SEI1 | PT_SS24_BloodShipped_BD_MOI1 | same molecular id has been found |
      | PT_SS24_TissueShipped | BLOOD  |                           | PT_SS24_TissueShipped_MOI1   | same molecular id has been found |

  @patients_p3
  Scenario Outline: PT_SS25. Blood shipment use old blood molecular_id should fail
  #    Testing patient: PT_SS25_BloodShipped, PT_SS25_BloodShipped_BD_MOI1 has been shipped, PT_SS25_BloodShipped_BD_MOI2 has been shipped
    Given patient id is "PT_SS25_BloodShipped"
    And load template specimen type: "BLOOD" shipped message for this patient
    Then set patient message field: "surgical_event_id" to value: ""
    Then set patient message field: "molecular_id" to value: "<moi>"
    Then set patient message field: "shipped_dttm" to value: "current"
    When POST to MATCH patients service, response includes "same molecular id" with code "403"
    Examples:
      | moi                          |
      | PT_SS25_BloodShipped_BD_MOI1 |
      | PT_SS25_BloodShipped_BD_MOI2 |

  @patients_p3
  Scenario Outline: PT_SS26. Blood specimen can only be shipped in certain status (blood specimen has been received before)
    Given patient id is "<patient_id>"
    And load template specimen type: "BLOOD" shipped message for this patient
    Then set patient message field: "surgical_event_id" to value: ""
    Then set patient message field: "molecular_id" to value: "<moi>"
    Then set patient message field: "shipped_dttm" to value: "current"
    When POST to MATCH patients service, response includes "<message>" with code "<http_code>"
    Examples:
      | patient_id                  | moi                                 | http_code | message                  |
      | PT_SS26_TsReceived          | PT_SS26_TsReceived_BD_MOI1          | 202       | processed successfully   |
      | PT_SS26_TsShipped           | PT_SS26_TsShipped_BD_MOI1           | 202       | processed successfully   |
      | PT_SS26_AssayConfirmed      | PT_SS26_AssayConfirmed_BD_MOI1      | 202       | processed successfully   |
      | PT_SS26_TsVRReceived        | PT_SS26_TsVRReceived_BD_MOI1        | 202       | processed successfully   |
      | PT_SS26_TsVRConfirmed       | PT_SS26_TsVRConfirmed_BD_MOI1       | 202       | processed successfully   |
      | PT_SS26_PendingApproval1    | PT_SS26_PendingApproval1_BD_MOI1    | 202       | processed successfully   |
      | PT_SS26_RequestAssignment   | PT_SS26_Progression_BD_MOI1         | 202       | processed successfully   |
      | PT_SS26_OffStudy            | PT_SS26_OffStudy_BD_MOI1            | 403       | cannot transition from   |
      | PT_SS22_BdVRReceived        | PT_SS22_BdVRReceived_BD_MOI2        | 202       | success                  |
      | PT_SS22_PendingConfirmation | PT_SS22_PendingConfirmation_BD_MOI1 | 202       | success                  |
      | PT_SS22_OnTreatmentArm      | PT_SS22_OnTreatmentArm_BD_MOI1      | 202       | success                  |
      | PT_SS22_BdVRRejected        | PT_SS22_BdVRRejected_BD_MOI2        | 202       | success                  |
      | PT_SS22_BdVRConfirmed       | PT_SS22_BdVRConfirmed_BD_MOI2       | 403       | confirmed variant report |
      | PT_SS22_NoTaAvailable       | PT_SS22_NoTaAvailable_BD_MOI1       | 202       | success                  |
      | PT_SS22_CompassionateCare   | PT_SS22_CompassionateCare_BD_MOI1   | 202       | success                  |
      #there is no “PATHOLOGY_REVIEWED” status anymore
#      | PT_SS26_PathologyConfirmed | PT_SS26_PathologyConfirmed_BD_MOI1 | Success | processed successfully |

  @patients_p2
  Scenario: PT_SS27. new specimen shipped using new MOI in same SEI will push all pending variant report from old MOI to "REJECT"
    #    Test patient: PT_SS27_VariantReportUploaded; variant report files uploaded: surgical_event_id: PT_SS27_VariantReportUploaded_SEI1, molecular_id: PT_SS27_VariantReportUploaded_MOI1, analysis_id: PT_SS27_VariantReportUploaded_ANI1
    #          Plan to ship new specimen using same surgical_event_id: PT_SS27_VariantReportUploaded_SEI1 but new molecular_id PT_SS27_VariantReportUploaded_MOI2
    Given patient id is "PT_SS27_VariantReportUploaded"
    And load template specimen type: "TISSUE" shipped message for this patient
    Then set patient message field: "surgical_event_id" to value: "PT_SS27_VariantReportUploaded_SEI1"
    Then set patient message field: "molecular_id" to value: "PT_SS27_VariantReportUploaded_MOI2"
    Then set patient message field: "shipped_dttm" to value: "current"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "TISSUE_NUCLEIC_ACID_SHIPPED"
    Then patient should have variant report (analysis_id: "PT_SS27_VariantReportUploaded_ANI1")
    And this variant report field: "status" should be "REJECTED"

  @patients_p2
  Scenario Outline: PT_SS28. destination should be validated
      #slide can only be shipped to MDA, if it is shipped to MoCha, that should fail
    Given patient id is "<patient_id>"
    And load template specimen type: "<type>" shipped message for this patient
    Then set patient message field: "surgical_event_id" to value: "<sei>"
    Then set patient message field: "<field>" to value: "<patient_id>_shipmentID"
    Then set patient message field: "destination" to value: "<site>"
    Then set patient message field: "shipped_dttm" to value: "current"
    When POST to MATCH patients service, response includes "<message>" with code "<code>"
    Examples:
      | patient_id          | sei                      | field         | type   | site      | code | message      |
      | PT_SS28_TsReceived1 | PT_SS28_TsReceived1_SEI1 | molecular_id  | TISSUE | MoCha     | 202  | successfully |
      | PT_SS28_TsReceived2 | PT_SS28_TsReceived2_SEI1 | molecular_id  | TISSUE | MDA       | 202  | successfully |
      | PT_SS28_TsReceived3 | PT_SS28_TsReceived3_SEI1 | molecular_id  | TISSUE | Other     | 403  | destination  |
      | PT_SS28_TsReceived4 | PT_SS28_TsReceived4_SEI1 | slide_barcode | SLIDE  | MDA       | 202  | successfully |
      | PT_SS28_TsReceived5 | PT_SS28_TsReceived5_SEI1 | slide_barcode | SLIDE  | MoCha     | 403  | destination  |
      | PT_SS28_TsReceived6 | PT_SS28_TsReceived6_SEI1 | molecular_id  | TISSUE | Dartmouth | 202  | successfully |
      | PT_SS28_TsReceived7 | PT_SS28_TsReceived7_SEI1 | slide_barcode | SLIDE  | Dartmouth | 403  | destination  |
      | PT_SS28_BdReceived1 |                          | molecular_id  | BLOOD  | MoCha     | 202  | successfully |
      | PT_SS28_BdReceived2 |                          | molecular_id  | BLOOD  | MDA       | 202  | successfully |
      | PT_SS28_BdReceived3 |                          | molecular_id  | BLOOD  | mda       | 403  | destination  |
      | PT_SS28_BdReceived4 |                          | molecular_id  | BLOOD  | Dartmouth | 202  | successfully |

#  This test case is not required
#  Scenario Outline: PT_SS29. Blood and tissue shippment should has same destination (?? not sure)
#    Given template specimen shipped message in type: "BLOOD" for patient: "<patient_id>"
#    Then set patient message field: "destination" to value: "<blood_destination>"
#    Then set patient message field: "shipped_dttm" to value: "2016-08-01T15:17:11+00:00"
#    When POST to MATCH patients service, response includes "successfully" with code "202"
#    Then wait for "15" seconds
#    Given template specimen shipped message in type: "TISSUE" for patient: "<patient_id>"
#    Then set patient message field: "destination" to value: "<tissue_destination>"
#    Then set patient message field: "shipped_dttm" to value: "2016-08-01T18:17:11+00:00"
#    When POST to MATCH patients service, response includes "<message>" with status "<status>"
#    Examples:
#    |patient_id                 |blood_destination|tissue_destination|status    |message                                  |
#    |PT_SS29_BdAndTsReceived1   |MDA              |MDA               |Success   |processed successfully  |
#    |PT_SS29_BdAndTsReceived2   |Mocha            |Mocha             |Success   |processed successfully  |
#    |PT_SS29_BdAndTsReceived3   |Mocha            |MDA               |Failure   |destination                              |

  @patients_p3
  Scenario Outline: PT_SS30. extra key-value pair in the message body should NOT fail
    Given patient id is "PT_SS30_TsBdReceived"
    And load template specimen type: "<type>" shipped message for this patient
    Then set patient message field: "surgical_event_id" to value: "<sei>"
    Then set patient message field: "<field>" to value: "<value>"
    Then set patient message field: "shipped_dttm" to value: "current"
    Then set patient message field: "extra_info" to value: "This is extra information"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Examples:
      | type   | sei                       | field         | value                        |
      | TISSUE | PT_SS30_TsBdReceived_SEI1 | molecular_id  | PT_SS30_TsBdReceived_MOI1    |
      | BLOOD  |                           | molecular_id  | PT_SS30_TsBdReceived_BD_MOI1 |
      | SLIDE  | PT_SS30_TsBdReceived_SEI1 | slide_barcode | PT_SS30_TsBdReceived_BC1     |

  @patients_p2
  Scenario Outline: PT_SS31. tissue or slide specimen cannot be shipped when patient is on NO_TA_AVAILABLE or COMPASSIONATE_CARE status
    Given patient id is "<patient_id>"
    And load template specimen type: "<type>" shipped message for this patient
    Then set patient message field: "surgical_event_id" to value: "<patient_id>_SEI1"
    Then set patient message field: "<field>" to value: "<value>"
    Then set patient message field: "shipped_dttm" to value: "current"
    When POST to MATCH patients service, response includes "transition" with code "403"
    Examples:
      | patient_id                | type   | field         | value                          |
      | PT_SS31_NoTaAvailable     | TISSUE | molecular_id  | PT_SS31_NoTaAvailable_MOI2     |
      | PT_SS31_NoTaAvailable     | SLIDE  | slide_barcode | PT_SS31_NoTaAvailable_BC2      |
      | PT_SS31_CompassionateCare | TISSUE | molecular_id  | PT_SS31_CompassionateCare_MOI2 |
      | PT_SS31_CompassionateCare | SLIDE  | slide_barcode | PT_SS31_CompassionateCare_BC2  |

  @patients_p1
  Scenario Outline: PT_SS32. shipped_dttm can be any time on the same day when specimen is collected
    Given patient id is "<patient_id>"
    And load template specimen type: "TISSUE" received message for this patient
    Then set patient message field: "surgical_event_id" to value: "<patient_id>_SEI1"
    Then set patient message field: "collection_dt" to value: "2017-07-05"
    Then set patient message field: "received_dttm" to value: "2017-07-05T00:00:01+00:00"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Then patient status should change to "TISSUE_SPECIMEN_RECEIVED"
    Then load template specimen type: "<type>" shipped message for this patient
    And set patient message field: "surgical_event_id" to value: "<patient_id>_SEI1"
    Then set patient message field: "<field>" to value: "<value>"
    And set patient message field: "shipped_dttm" to value: "2017-07-05T<time>"
    When POST to MATCH patients service, response includes "successfully" with code "202"
    Examples:
      | patient_id          | type   | field         | value                    | time           |
      | PT_SS32_Registered1 | TISSUE | molecular_id  | PT_SS32_Registered1_MOI1 | 00:01:00-04:00 |
      | PT_SS32_Registered2 | TISSUE | molecular_id  | PT_SS32_Registered2_MOI1 | 01:01:00-05:00 |
      | PT_SS32_Registered3 | TISSUE | molecular_id  | PT_SS32_Registered3_MOI1 | 06:00:00-06:00 |
      | PT_SS32_Registered4 | TISSUE | molecular_id  | PT_SS32_Registered4_MOI1 | 11:59:59-00:00 |
      | PT_SS32_Registered5 | SLIDE  | slide_barcode | PT_SS32_Registered5_BC1  | 10:01:00-07:00 |
      | PT_SS32_Registered6 | SLIDE  | slide_barcode | PT_SS32_Registered6_BC1  | 04:01:00-08:00 |
      | PT_SS32_Registered7 | SLIDE  | slide_barcode | PT_SS32_Registered7_BC1  | 08:01:00-09:00 |
      | PT_SS32_Registered8 | SLIDE  | slide_barcode | PT_SS32_Registered8_BC1  | 00:00:01-10:00 |


