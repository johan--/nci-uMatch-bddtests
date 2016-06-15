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
  
  Scenario Outline: Variant with Hotspot Oncomine Variant Class value should pass
    Given template json with a new unique id
    Then set template json field: "version" to string value: "2016-06-03"
    Then clear template json's variant: "<variantType>" list
    Then create a template variant: "<variantType>"
    And set template variant field: "identifier" to string value: "<identifier>"
    And set template variant field: "oncominevariantclass" to bool value: "hotspot"
    And add template variant: "<variantType>" to template json
    When posted to MATCH newTreatmentArm
    Then success message is returned:
    Then the treatment arm with id: "saved_id" and version: "2016-06-03" return from API has "<variantType>" variant (id: "<identifier>", field: "oncominevariantclass", value: "hotspot")
    Examples:
      |variantType  |identifier             |
      |snv          |COSM1686998            |
      |snv          |COSM583                |
      |cnv          |MYCL                   |
      |cnv          |MET                    |

  Scenario Outline: Variant with non-Hotspot Oncomine Variant Class value should fail
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
      |snv          |noAType                          |
      |cnv          |@NT$N                            |