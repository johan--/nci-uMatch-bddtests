#encoding: utf-8

@treatment_arm
Feature: Treatment Arm API Tests that focus on Variants
  Scenario Outline: Variant should return correct inclusion/exclusion value
    Given template json with a new unique id
    Then set template json field: "version" to string value: "2016-06-03"
    Then clear template json's variant: "<variantType>" list
    Then create a template variant: "<variantType>"
    And set template variant field: "identifier" to string value: "<identifier>"
    And set template variant field: "inclusion" to bool value: "<inclusionValue>"
    Then add template variant: "<variantType>" to template json
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm with id: "saved_id" and version: "2016-06-03" return from API has "<variantType>" variant (id: "<identifier>", field: "inclusion", value: "<inclusionValue>")
    Examples:
    |variantType  |identifier               |inclusionValue   |
    |snv          |COSM1686998              |true             |
    |snv          |COSM583                  |false            |
    |cnv          |MYCL                     |true             |
    |cnv          |MET                      |false            |
    |gf           |FGFR2-OFD1.F17O3         |true             |
    |gf           |CD74-ROS1.C6R34.COSF1200 |false            |
    |id           |COSM99742                |true             |
    |id           |COSM14067                |false            |
    |nhr          |id0001                   |true             |
    |nhr          |id0002                   |false            |

  Scenario Outline: Variant should return correct armSpecific value
    Given template json with a new unique id
    Then set template json field: "version" to string value: "2016-06-03"
    Then clear template json's variant: "<variantType>" list
    Then create a template variant: "<variantType>"
    And set template variant field: "identifier" to string value: "<identifier>"
    And set template variant field: "armSpecific" to bool value: "<inputValue>"
    Then add template variant: "<variantType>" to template json
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm with id: "saved_id" and version: "2016-06-03" return from API has "<variantType>" variant (id: "<identifier>", field: "arm_specific", value: "<inputValue>")
    Examples:
      |variantType  |identifier                     |inputValue   |
      |snv          |COSM1686998                    |true         |
      |snv          |COSM583                        |false        |
      |cnv          |MYCL                           |true         |
      |cnv          |MET                            |false        |
      |gf           |FGFR2-OFD1.F17O3               |true         |
      |gf           |CCD74-ROS1.C6R34.COSF1200      |false        |
      |id           |COSM99742                      |true         |
      |id           |COSM14067                      |false        |
      |nhr          |id0001                         |true         |
      |nhr          |id0002                         |false        |

  Scenario Outline: Variant should return full publicMedIds list
    Given template json with a new unique id
    Then set template json field: "version" to string value: "2016-06-03"
    Then clear template json's variant: "<variantType>" list
    Then create a template variant: "<variantType>"
    And set template variant field: "identifier" to string value: "<identifier>"
    And set template variant publicMedIds: "<pmIDs>"
    Then add template variant: "<variantType>" to template json
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm with id: "saved_id" and version: "2016-06-03" return from API has "<variantType>" variant (id: "<identifier>", publicMedIds: "<pmIDs>")
    Examples:
      |variantType  |identifier                     |pmIDs                         |
      |snv          |COSM1686998                    |14512,2362,32345,7451         |
      |snv          |COSM583                        |873,67,023496,459             |
      |cnv          |MYCL                           |234,67                        |
      |cnv          |MET                            |92,0,562                      |
      |gf           |FGFR2-OFD1.F17O3               |2984,58,5,2,7,1,0,34,14634,3  |
      |gf           |CCD74-ROS1.C6R34.COSF1200      |348,56,23454236534632         |
      |id           |COSM99742                      |431                           |
      |id           |COSM14067                      |3420952,43                    |
      |nhr          |id0001                         |982,546,2436547,243           |
      |nhr          |id0002                         |2,32,6,13                     |

  Scenario Outline: Treatment arm which contains variants in same type with same ID should fail
    Given template json with a new unique id
    Then clear template json's variant: "<variantType>" list
    Then create a template variant: "<variantType>"
    And add template variant: "<variantType>" to template json
    Then create a template variant: "<variantType>"
    And set template variant field: "inclusion" to bool value: "false"
    And add template variant: "<variantType>" to template json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed."
    Examples:
      |variantType  |
      |snv          |
      |cnv          |
      |gf           |
      |id           |
      |nhr          |
    
  Scenario Outline: Treatment arm which contains variant without ID should fail
    Given template json with a new unique id
    Then clear template json's variant: "<variantType>" list
    Then create a template variant: "<variantType>"
    And remove template variant field: "identifier"
    And add template variant: "<variantType>" to template json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed."
    Examples:
      |variantType  |
      |snv          |
      |cnv          |
      |gf           |
      |id           |
  
  Scenario Outline: Variant with valid Oncomine Variant Class value should pass
    Given template json with a new unique id
    Then set template json field: "version" to string value: "2016-06-03"
    Then clear template json's variant: "<variantType>" list
    Then create a template variant: "<variantType>"
    And set template variant field: "identifier" to string value: "<identifier>"
    And set template variant field: "oncominevariantclass" to bool value: "<ovcValue>"
    And add template variant: "<variantType>" to template json
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm with id: "saved_id" and version: "2016-06-03" return from API has "<variantType>" variant (id: "<identifier>", field: "oncominevariantclass", value: "<ovcValue>")
    Examples:
      |variantType  |identifier             |ovcValue             |
      |snv          |COSM1686998            |hotspot              |
      |cnv          |COSM583                |hotspot              |
      |gf           |MYCL                   |fusion               |
      |id           |MET                    |hotspot              |
      |nhr          |id0001                 |deleterious          |

  Scenario Outline: Variant with invalid Oncomine Variant Class value should fail
    Given template json with a new unique id
    Then clear template json's variant: "<variantType>" list
    Then create a template variant: "<variantType>"
    And set template variant field: "oncominevariantclass" to bool value: "<oncominevariantclassValue>"
    And add template variant: "<variantType>" to template json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed."
    Examples:
      |variantType  |oncominevariantclassValue        |
      |snv          |deleterious                      |
      |cnv          |other                            |
      |gf           |*&@xx                            |
      |id           |other                            |
      |nhr          |fusion                           |
      |nhr          |hotspot                          |

  Scenario Outline: Variant with invalid type value should fail
    Given template json with a new unique id
    Then clear template json's variant: "<variantType>" list
    Then create a template variant: "<variantType>"
    And set template variant field: "type" to string value: "<typeValue>"
    And add template variant: "<variantType>" to template json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed."
    Examples:
      |variantType  |typeValue                        |
      |snv          |cnv                              |
      |cnv          |gf                               |
      |gf           |id                               |
      |id           |nhr                              |
      |nhr          |noAType                          |
      |snv          |@NT$N                            |

  Scenario: Duplicated Non-Hotspot Rules will be ignored
    Given template json with a new unique id
    Then set template json field: "version" to string value: "2016-06-03"
    Then clear template json's variant: "nhr" list
    Then create a template variant: "nhr"
    And add template variant: "nhr" to template json
    Then create a template variant: "nhr"
    And add template variant: "nhr" to template json
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm with id: "saved_id" and version: "2016-06-03" return from API has "nhr" variant count:"1"


  Scenario Outline: Non-Hotspot Rules with valid function value should pass
    Given template json with a new unique id
    Then set template json field: "version" to string value: "2016-06-03"
    Then clear template json's variant: "nhr" list
    Then create a template variant: "nhr"
    And set template variant field: "identifier" to string value: "<identifier>"
    And set template variant field: "function" to bool value: "<functionValue>"
    And add template variant: "nhr" to template json
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm with id: "saved_id" and version: "2016-06-03" return from API has "nhr" variant (id: "<identifier>", field: "function", value: "<functionValue>")
    Examples:
      |identifier             |functionValue                    |
      |id0001                 |refallele                        |
      |id0002                 |unknown                          |
      |id0003                 |missense                         |
      |id0004                 |nonsense                         |
      |id0005                 |frameshiftinsertion              |
      |id0006                 |frameshiftdeletion               |
      |id0007                 |nonframeshiftinsertion           |
      |id0008                 |nonframeshiftdeletion            |
      |id0009                 |stoploss                         |
      |id0010                 |frameshiftblocksubstitution      |
      |id0011                 |nonframeshiftblocksubstitution   |


  Scenario Outline: Non-Hotspot Rules with invalid function value should fail
    Given template json with a new unique id
    Then set template json field: "version" to string value: "2016-06-03"
    Then clear template json's variant: "nhr" list
    Then create a template variant: "nhr"
    And set template variant field: "identifier" to string value: "<identifier>"
    And set template variant field: "function" to bool value: "<functionValue>"
    And add template variant: "nhr" to template json
    When posted to MATCH newTreatmentArm
    Then a failure message is returned which contains: "Validation failed."
    Examples:
      |identifier             |functionValue                    |
      |id0001                 |synonymous                       |
      |id0002                 |unknown                          |
      |id0003                 |*#$dfb                           |