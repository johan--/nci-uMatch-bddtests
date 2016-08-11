#encoding: utf-8
@patients_not_implemented
Feature: NCH Specimen shipped messages
  Scenario: PT_SS01. Received specimen_shipped message for type 'BLOOD' from NCH for a patient who has already received the specimen_received message
    Given template specimen shipped message in type: "BLOOD" for patient: "PT_SS01_BloodReceived"
    When posted to MATCH patient trigger service, returns a message that includes "specimen shipped message received and saved." with status "Success"

  Scenario: PT_SS02. Received specimen_shipped message for type 'TISSUE' from NCH for a patient who has already received the specimen_received message
#  Testing patient:PT_SS01_TissueReceived; surgical_event_id: SEI_TR_01
    Given template specimen shipped message in type: "TISSUE" for patient: "PT_SS02_TissueReceived"
    Then set patient message field: "surgical_event_id" to value: "SEI_TR_01"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"

  Scenario: PT_SS03. Received specimen_shipped message for type 'SLIDE' from NCH for a patient who has already received the specimen_received message
#  Testing patient:PT_SS03_TissueReceived; surgical_event_id: SEI_TR_02
    Given template specimen shipped message in type: "SLIDE" for patient: "PT_SS03_TissueReceived"
    Then set patient message field: "surgical_event_id" to value: "SEI_TR_02"
    When posted to MATCH patient trigger service, returns a message that includes "specimen shipped message received and saved." with status "Success"

  Scenario Outline: PT_SS04. Shipment with invalid patient_id fails
    Given template specimen shipped message in type: "<type>" for patient: "<patient>"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "<status>"
    Examples:
    |type   |patient                |status   |message                                                        |
    |TISSUE |PT_SS04_NonExisting    |Failure  |patient_id does not exist                                                            |
    |BLOOD  |                       |Failure  |was not of a minimum string length of 1                        |
    |SLIDE  |null                   |Failure  |type NilClass did not match the following type: string         |

  Scenario Outline: PT_SS05. Shipment with invalid study_id fails
    #  Testing patient:PT_SS05_TissueReceived; surgical_event_id: SEI_TR_02
    Given template specimen shipped message in type: "TISSUE" for patient: "PT_SS05_TissueReceived"
    Then set patient message field: "study_id" to value: "<study_id>"
    Then set patient message field: "surgical_event_id" to value: "SEI_TR_02"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
      |study_id     |message                                                        |
      |other        |not match one of the following values: APEC1621                |
      |             |not of a minimum string length of 1                            |
      |null         |type NilClass did not match the following type: string         |

  Scenario: PT_SS06. shipped_dttm older than received_dttm fails
#  Testing patient: PT_SS06_TissueReceived, surgical_event_id: SEI_TR_02, received_dttm: 2016-04-25T16:17:11+00:00
    Given template specimen shipped message in type: "TISSUE" for patient: "PT_SS06_TissueReceived"
    Then set patient message field: "surgical_event_id" to value: "SEI_TR_02"
    Then set patient message field: "shipped_dttm" to value: "2016-03-25T16:17:11+00:00"
    When posted to MATCH patient trigger service, returns a message that includes "TBD" with status "Failure"

  Scenario Outline: PT_SS07. shipped tissue or slide with a non-exist surgical_event_id fails
    Given template specimen shipped message in type: "<type>" for patient: "PT_SS07_TissueReceived"
    Then set patient message field: "surgical_event_id" to value: "<SEI>"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
    |type   |SEI            |message                                                              |
    |TISSUE |badSEI         |cannot transition from                                               |
    |SLIDE  |               |not of a minimum string length of 1                                  |

  Scenario Outline: PT_SS08. tissue or slide with an expired surgical_event_id fails
#  Testing patient: PT_SS08_TissueReceived
#  surgical event: SEI_TR_1 received Then SEI_TR_2 received (SEI_TR_1 expired)
    Given template specimen shipped message in type: "<type>" for patient: "PT_SS08_TissueReceived"
    Then set patient message field: "surgical_event_id" to value: "SEI_TR_1"
    When posted to MATCH patient trigger service, returns a message that includes "cannot transition from" with status "Failure"
    Examples:
    |type     |
    |TISSUE   |
    |SLIDE    |

  Scenario Outline: PT_SS09. shipped tissue or slide without surgical_event_id fails
    Given template specimen shipped message in type: "<type>" for patient: "PT_SS09_TissueReceived"
    Then remove field: "surgical_event_id" from patient message
    When posted to MATCH patient trigger service, returns a message that includes "not contain a required property of 'surgical_event_id'" with status "Failure"
    Examples:
      |type     |
      |TISSUE   |
      |SLIDE    |

  Scenario Outline: PT_SS10. shipped tissue without molecular_id or molecular_dna_id or molecular_cdna_id fails
    Given template specimen shipped message in type: "TISSUE" for patient: "PT_SS10_TissueReceived"
    Then remove field: "<field>" from patient message
    When posted to MATCH patient trigger service, returns a message that includes "cannot transition from" with status "Failure"
    Examples:
      |field              |
      |molecular_id       |
      |molecular_dna_id   |
      |molecular_cdna_id  |

  Scenario: PT_SS11. shipped tissue with a existing surgical_event_id + molecular_id combination fails
#  Testing patient: PT_SS11_Tissue1Shipped, surgical_event_id: SEI_TR_1
#    molecular_id: MOI_TR_01 has shipped
    Given template specimen shipped message in type: "TISSUE" for patient: "PT_SS11_Tissue1Shipped"
    Then set patient message field: "surgical_event_id" to value: "SEI_TR_1"
    Then set patient message field: "molecular_id" to value: "MOI_TR_01"
    When posted to MATCH patient trigger service, returns a message that includes "cannot transition from" with status "Failure"

  Scenario: PT_SS12. shipped tissue with a new molecular_id in latest surgical_event_id pass
#  Testing patient: PT_SS12_Tissue1Shipped, surgical_event_id: SEI_TR_1
#    molecular_id: MOI_TR_01 has shipped
    Given template specimen shipped message in type: "TISSUE" for patient: "PT_SS12_Tissue1Shipped"
    Then set patient message field: "surgical_event_id" to value: "SEI_TR_1"
    Then set patient message field: "molecular_id" to value: "MOI_TR_02"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"

  Scenario: PT_SS13. shipped slide with molecular_id fails
#  Testing patient: PT_SS13_TissueReceived, surgical_event_id: SEI_TR_1
    Given template specimen shipped message in type: "SLIDE" for patient: "PT_SS13_TissueReceived"
    Then set patient message field: "molecular_id" to value: "MOI_TR_01"
    When posted to MATCH patient trigger service, returns a message that includes "cannot transition from" with status "Failure"

  Scenario: PT_SS14. shipped slide without slide_barcode fails
#  Testing patient: PT_SS14_TissueReceived, surgical_event_id: SEI_TR_1
    Given template specimen shipped message in type: "SLIDE" for patient: "PT_SS14_TissueReceived"
    Then set patient message field: "surgical_event_id" to value: "SEI_TR_1"
    Then remove field: "slide_barcode" from patient message
    When posted to MATCH patient trigger service, returns a message that includes "cannot transition from" with status "Failure"

  Scenario: PT_SS15. shipped slide with new barcode passes
#  Testing patient: PT_SS15_Slide1Shipped, surgical_event_id: SEI_TR_1
#    slide with barcode: BC_001 has been shipped
    Given template specimen shipped message in type: "SLIDE" for patient: "PT_SS15_Slide1Shipped"
    Then set patient message field: "surgical_event_id" to value: "SEI_TR_1"
    Then set patient message field: "slide_barcode" to value: "BC_002"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"

  Scenario: PT_SS16. shipped slide with a existing surgical_event_id + slide_barcode combination fails
#  Testing patient: PT_SS16_Slide1Shipped, surgical_event_id: SEI_TR_1
#    slide with barcode: BC_001 has been shipped
    Given template specimen shipped message in type: "SLIDE" for patient: "PT_SS16_Slide1Shipped"
    Then set patient message field: "surgical_event_id" to value: "SEI_TR_1"
    Then set patient message field: "slide_barcode" to value: "BC_001"
    When posted to MATCH patient trigger service, returns a message that includes "TBD" with status "Failure"

  Scenario: PT_SS17. shipped blood without blood received fails
#  Testing patient: PT_SS17_BloodReceived
#     These is no blood specimen received event in this patient
    Given template specimen shipped message in type: "BLOOD" for patient: "PT_SS17_BloodReceived"
    When posted to MATCH patient trigger service, returns a message that includes "TBD" with status "Failure"

  Scenario: PT_SS18. shipped blood with SEI fails
    Given template specimen shipped message in type: "BLOOD" for patient: "PT_SS18_BloodReceived"
    Then set patient message field: "surgical_event_id" to value: "SEI_BR_1"
    When posted to MATCH patient trigger service, returns a message that includes "TBD" with status "Failure"

# data cannot be prepared due to current bug
#  Scenario: PT_SS19. shipped blood with existing molecular_id (in this patient) fails
##  Testing patient: PT_SS19_Blood1Shipped
##    blood molecular_id: MOI_BR_01 has shipped
#    Given template specimen shipped message in type: "BLOOD" for patient: "PT_SS19_Blood1Shipped"
#    Then set patient message field: "molecular_id" to value: "MOI_BR_01"
#    When posted to MATCH patient trigger service, returns a message that includes "TBD" with status "Failure"

  # data cannot be prepared due to current bug
#  Scenario: PT_SS20. shipped blood with new molecular_id (in this patient) passes
##  Testing patient: PT_SS20_Blood1Shipped
##    blood molecular_id: MOI_BR_01 has shipped
#    Given template specimen shipped message in type: "BLOOD" for patient: "PT_SS20_Blood1Shipped"
#    Then set patient message field: "molecular_id" to value: "MOI_BR_02"
#    When posted to MATCH patient trigger service, returns a message that includes "specimen shipped message received and saved." with status "Success"

  Scenario: PT_SS21. Tissue cannot be shipped if there is one tissue variant report get confirmed
#    Testing patient: PT_SS21_TissueVariantConfirmed, surgical_event_id: SEI_TR_1
#      this patient has TISSUE_VARIANT_REPORT_CONFIRMED status
    Given template specimen shipped message in type: "TISSUE" for patient: "PT_SS21_TissueVariantConfirmed"
    When posted to MATCH patient trigger service, returns a message that includes "cannot transition from" with status "Failure"

  # data cannot be prepared due to current bug
#  Scenario: PT_SS22. Blood cannot be shipped if there is on blood variant report get confirmed
##    Testing patient: PT_SS21_BloodVariantConfirmed
##      this patient has BLOOD_VARIANT_REPORT_CONFIRMED status
#    Given template specimen shipped message in type: "BLOOD" for patient: "PT_SS22_BloodVariantConfirmed"
#    When posted to MATCH patient trigger service, returns a message that includes "cannot transition from" with status "Failure"

  Scenario Outline: PT_SS23. Tissue shipment and slide shipment should not depend on each other
    Given template specimen shipped message in type: "<type>" for patient: "<patient_id>"
    Then set patient message field: "shipped_dttm" to value: "2016-05-02T19:42:13+00:00"
    When posted to MATCH patient trigger service, returns a message that includes "Message has been processed successfully" with status "Success"
    Examples:
    |type   |patient_id                 |
    |TISSUE |PT_SS23_TissueReceived1    |
    |SLIDE  |PT_SS23_TissueReceived2    |
# data cannot be prepared due to current bug    |TISSUE |PT_SS23_SlideShipped       |
    |SLIDE  |PT_SS23_TissueShipped      |
    
  Scenario Outline: PT_SS24. Tissue shipment and blood shipment should not use same molecular_id
#    Testing patient: PT_SS24_BloodShipped,
#                          Blood shipped MOI_01,
#                          Tissue receveid SEI_TR_01,try to ship it using MOI_01
#                     PT_SS24_TissueShipped,
#                          Tissue shipped SEI_TR_01, MOI_01,
#                          Blood received, try to ship it using MOI_01
    Given template specimen shipped message in type: "<type>" for patient: "<patient_id>"
    Then set patient message field: "surgical_event_id" to value: "<sei>"
    Then set patient message field: "molecular_id" to value: "MOI_01"
    When posted to MATCH patient trigger service, returns a message that includes "<message>" with status "Failure"
    Examples:
    |patient_id             |type       |sei            |message                                                  |
    |PT_SS24_BloodShipped   |TISSUE     |SEI_TR_01      |TBD                                                      |
    |PT_SS24_TissueShipped  |BLOOD      |skip_this_value|TBD                                                      |