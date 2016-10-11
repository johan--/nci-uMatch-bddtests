#encoding: utf-8

@treatment_arm
Feature: TA_VR. Treatment Arm API Tests that focus on Variants

  @treatment_arm_p2
  Scenario Outline: TA_VR1.Variant should return correct inclusion/exclusion value
    Given template treatment arm json with an id: "<treatment_arm_id>"
    Then clear template treatment arm json's variant: "<variantType>" list
    Then create a template variant: "<variantType>" for treatment arm
    And set template treatment arm variant field: "identifier" to string value: "<identifier>"
    And set template treatment arm variant field: "inclusion" to bool value: "<inclusionValue>"
    Then add template variant: "<variantType>" to template treatment arm json
    When creating a new treatment arm using post request
    Then a success message is returned
    Then wait for processor to complete request in "10" seconds
    Then retrieve the posted treatment arm from API
    Then the returned treatment arm has "<variantType>" variant (id: "<identifier>", field: "inclusion", value: "<inclusionValue>")
    Examples:
    |treatment_arm_id   |variantType  |identifier               |inclusionValue   |
    |APEC1621-VR1-1     |snv          |COSM1686998              |true             |
    |APEC1621-VR1-2     |snv          |COSM583                  |false            |
    |APEC1621-VR1-3     |cnv          |MYCL                     |true             |
    |APEC1621-VR1-4     |cnv          |MET                      |false            |
    |APEC1621-VR1-5     |gf           |FGFR2-OFD1.F17O3         |true             |
    |APEC1621-VR1-6     |gf           |CD74-ROS1.C6R34.COSF1200 |false            |
    |APEC1621-VR1-7     |id           |COSM99742                |true             |
    |APEC1621-VR1-8     |id           |COSM14067                |false            |
    |APEC1621-VR1-9     |nhr          |id0001                   |true             |
    |APEC1621-VR1-10    |nhr          |id0002                   |false            |

  @treatment_arm_p2
  Scenario Outline: TA_VR2. Variant should return correct arm_specific value
    Given template treatment arm json with an id: "<treatment_arm_id>"
    Then clear template treatment arm json's variant: "<variantType>" list
    Then create a template variant: "<variantType>" for treatment arm
    And set template treatment arm variant field: "identifier" to string value: "<identifier>"
    And set template treatment arm variant field: "arm_specific" to bool value: "<inputValue>"
    Then add template variant: "<variantType>" to template treatment arm json
    When creating a new treatment arm using post request
    Then a success message is returned
    Then wait for processor to complete request in "10" seconds
    Then retrieve the posted treatment arm from API
    Then the returned treatment arm has "<variantType>" variant (id: "<identifier>", field: "arm_specific", value: "<inputValue>")
    Examples:
      |treatment_arm_id   |variantType  |identifier                     |inputValue   |
      |APEC1621-VR2-1     |snv          |COSM1686998                    |true         |
      |APEC1621-VR2-2     |snv          |COSM583                        |false        |
      |APEC1621-VR2-3     |cnv          |MYCL                           |true         |
      |APEC1621-VR2-4     |cnv          |MET                            |false        |
      |APEC1621-VR2-5     |gf           |FGFR2-OFD1.F17O3               |true         |
      |APEC1621-VR2-6     |gf           |CCD74-ROS1.C6R34.COSF1200      |false        |
      |APEC1621-VR2-7     |id           |COSM99742                      |true         |
      |APEC1621-VR2-8     |id           |COSM14067                      |false        |
      |APEC1621-VR2-9     |nhr          |id0001                         |true         |
      |APEC1621-VR2-10    |nhr          |id0002                         |false        |

  @treatment_arm_p2
  Scenario Outline: TA_VR3. Variant should return full public_med_ids list
    Given template treatment arm json with an id: "<treatment_arm_id>"
    Then clear template treatment arm json's variant: "<variantType>" list
    Then create a template variant: "<variantType>" for treatment arm
    And set template treatment arm variant field: "identifier" to string value: "<identifier>"
    And set template treatment arm variant public_med_ids: "<pmIDs>"
    Then add template variant: "<variantType>" to template treatment arm json
    When creating a new treatment arm using post request
    Then a success message is returned
    Then wait for processor to complete request in "10" seconds
    Then retrieve the posted treatment arm from API
    Then the returned treatment arm has "<variantType>" variant (id: "<identifier>", public_med_ids: "<pmIDs>")
    Examples:
      |treatment_arm_id   |variantType  |identifier                     |pmIDs                         |
      |APEC1621-VR3-1     |snv          |COSM1686998                    |14512,2362,32345,7451         |
      |APEC1621-VR3-2     |snv          |COSM583                        |873,67,023496,459             |
      |APEC1621-VR3-3     |cnv          |MYCL                           |234,67                        |
      |APEC1621-VR3-4     |cnv          |MET                            |92,0,562                      |
      |APEC1621-VR3-5     |gf           |FGFR2-OFD1.F17O3               |2984,58,5,2,7,1,0,34,14634,3  |
      |APEC1621-VR3-6     |gf           |CCD74-ROS1.C6R34.COSF1200      |348,56,23454236534632         |
      |APEC1621-VR3-7     |id           |COSM99742                      |431                           |
      |APEC1621-VR3-8     |id           |COSM14067                      |3420952,43                    |
      |APEC1621-VR3-9     |nhr          |id0001                         |982,546,2436547,243           |
      |APEC1621-VR3-10    |nhr          |id0002                         |2,32,6,13                     |

  @treatment_arm_p3
  Scenario Outline: TA_VR4. Treatment arm which contains two variants of the same identifier should fail
    Given template treatment arm json with a random id
    Then clear template treatment arm json's variant: "<variantType>" list
    Then create a template variant: "<variantType>" for treatment arm
    And set template treatment arm variant field: "inclusion" to bool value: "true"
    And add template variant: "<variantType>" to template treatment arm json
    Then create a template variant: "<variantType>" for treatment arm
    And set template treatment arm variant field: "inclusion" to bool value: "false"
    And add template variant: "<variantType>" to template treatment arm json
    When creating a new treatment arm using post request
    Then a failure message is returned which contains: "Validation failed."
    Examples:
      |variantType  |
      |snv          |
      |cnv          |
      |gf           |
      |id           |
      |nhr          |

  @treatment_arm_p2
  Scenario Outline: TA_VR5. Treatment arm which contains variant without ID should fail
    Given template treatment arm json with a random id
    Then clear template treatment arm json's variant: "<variantType>" list
    Then create a template variant: "<variantType>" for treatment arm
    And remove template treatment arm variant field: "identifier"
    And add template variant: "<variantType>" to template treatment arm json
    When creating a new treatment arm using post request
    Then failure message listing "<variantType>" and reason as "identifier" is returned
    Examples:
      |variantType  |
      |snv          |
      |cnv          |
      |gf           |
      |id           |

  @treatment_arm_p3
  Scenario Outline: TA_VR6. Variant with valid Oncomine Variant Class value should pass
    Given template treatment arm json with an id: "<treatment_arm_id>"
    Then clear template treatment arm json's variant: "<variantType>" list
    Then create a template variant: "<variantType>" for treatment arm
    And set template treatment arm variant field: "identifier" to string value: "<identifier>"
    And set template treatment arm variant field: "oncomine_variant_class" to string value: "<ovcValue>"
    And add template variant: "<variantType>" to template treatment arm json
    When creating a new treatment arm using post request
    Then a success message is returned
    Then wait for processor to complete request in "10" seconds
    Then retrieve the posted treatment arm from API
    Then the returned treatment arm has "<variantType>" variant (id: "<identifier>", field: "oncomine_variant_class", value: "<ovcValue>")
    Examples:
      |treatment_arm_id   |variantType  |identifier             |ovcValue             |
      |APEC1621-VR6-5     |nhr          |id0001                 |deleterious          |

  @treatment_arm_p3
  Scenario Outline: TA_VR7. Variant with invalid Oncomine Variant Class value should fail
    Given template treatment arm json with a random id
    Then clear template treatment arm json's variant: "<variantType>" list
    Then create a template variant: "<variantType>" for treatment arm
    And set template treatment arm variant field: "oncomine_variant_class" to bool value: "<oncomine_variant_classValue>"
    And add template variant: "<variantType>" to template treatment arm json
    When creating a new treatment arm using post request
    Then a failure message is returned which contains: "FalseClass did not match the following type: string"
    Examples:
      |variantType  |oncomine_variant_classValue |
      |nhr          |fusion                      |
      |nhr          |hotspot                     |

  @treatment_arm_p2
  Scenario Outline: TA_VR8a. Variant without "type" field should fail
    Given template treatment arm json with an id: "APEC1621_VR8_<variantType>"
    Then clear template treatment arm json's variant: "<variantType>" list
    Then create a template variant: "<variantType>" for treatment arm
    And remove template treatment arm variant field: "variant_type"
    And add template variant: "<variantType>" to template treatment arm json
    When creating a new treatment arm using post request
    Then a failure message is returned which contains: "did not contain a required property of 'variant_type'"
    Examples:
      |variantType  |
      |snv          |
      |id           |
      |cnv          |
      |gf           |

  @treatment_arm_p2
  Scenario Outline: TA_VR8. Variant with invalid type value should fail
    Given template treatment arm json with a random id
    Then clear template treatment arm json's variant: "<variantType>" list
    Then create a template variant: "<variantType>" for treatment arm
    And set template treatment arm variant field: "variant_type" to string value: "<typeValue>"
    And add template variant: "<variantType>" to template treatment arm json
    When creating a new treatment arm using post request
    Then a failure message is returned which contains: "did not match one of the following values"
    Examples:
      |variantType  |typeValue                        |
      |snv          |cnv                              |
      |id           |nhr                              |
      |cnv          |snp                              |
      |gf           |fudge                            |


  @treatment_arm_p3
  Scenario: TA_VR9. Duplicated Non-Hotspot Rules will be ignored
    Given template treatment arm json with an id: "APEC1621-VR9-1"
    Then clear template treatment arm json's variant: "nhr" list
    Then create a template variant: "nhr" for treatment arm
    And add template variant: "nhr" to template treatment arm json
    Then create a template variant: "nhr" for treatment arm
    And add template variant: "nhr" to template treatment arm json
    When creating a new treatment arm using post request
    Then a success message is returned
    Then wait for processor to complete request in "10" seconds
    Then retrieve the posted treatment arm from API
    Then the returned treatment arm has "nhr" variant count:"1"

  @treatment_arm_p3
  Scenario Outline: TA_VR10. Non-Hotspot Rules with valid function value should pass
    Given template treatment arm json with an id: "<treatment_arm_id>"
    Then clear template treatment arm json's variant: "nhr" list
    Then create a template variant: "nhr" for treatment arm
    And set template treatment arm variant field: "identifier" to string value: "<identifier>"
    And set template treatment arm variant field: "function" to string value: "<functionValue>"
    And add template variant: "nhr" to template treatment arm json
    When creating a new treatment arm using post request
    Then a success message is returned
    Then wait for processor to complete request in "10" seconds
    Then retrieve the posted treatment arm from API
    Then the returned treatment arm has "nhr" variant (id: "<identifier>", field: "function", value: "<functionValue>")
    Examples:
      |treatment_arm_id  |identifier             |functionValue                    |
      |APEC1621-VR10-1   |id0001                 |refallele                        |
      |APEC1621-VR10-2   |id0002                 |unknown                          |
      |APEC1621-VR10-3   |id0003                 |missense                         |
      |APEC1621-VR10-4   |id0004                 |nonsense                         |
      |APEC1621-VR10-5   |id0005                 |frameshiftinsertion              |
      |APEC1621-VR10-6   |id0006                 |frameshiftdeletion               |
      |APEC1621-VR10-7   |id0007                 |nonframeshiftinsertion           |
      |APEC1621-VR10-8   |id0008                 |nonframeshiftdeletion            |
      |APEC1621-VR10-9   |id0009                 |stoploss                         |
      |APEC1621-VR10-10  |id0010                 |frameshiftblocksubstitution      |
      |APEC1621-VR10-11  |id0011                 |nonframeshiftblocksubstitution   |


  @treatment_arm_p3
  Scenario Outline: TA_VR11. Non-Hotspot Rules with invalid function value should fail
    Given template treatment arm json with a random id
    Then clear template treatment arm json's variant: "nhr" list
    Then create a template variant: "nhr" for treatment arm
    And set template treatment arm variant field: "identifier" to string value: "<identifier>"
    And set template treatment arm variant field: "function" to bool value: "<functionValue>"
    And add template variant: "nhr" to template treatment arm json
    When creating a new treatment arm using post request
    Then a failure message is returned which contains: "did not match the following type"
    Examples:
      |identifier             |functionValue                    |
      |id0001                 |synonymous                       |

  @treatment_arm_p2
  Scenario Outline: TA_VR12. Variants can have the approved variant_type and the TA should be created.
    Given template treatment arm json with a random id
    And clear template treatment arm json's variant: "<variant_type>" list
    And create a template variant: "<variant_type>" for treatment arm
    And set template treatment arm variant field: "variant_type" to string value: "<variant_type_value>"
    And add template variant: "<variant_type>" to template treatment arm json
    When creating a new treatment arm using post request
    Then a success message is returned
    Examples:
    | variant_type  | variant_type_value |
    | snv           | snp                |
    | snv           | mnp                |
    | id            | ins                |
    | id            | del                |
    | id            | complex            |
    | cnv           | cnv                |
    | gf            | fusion             |


  @treatment_arm_p3
  Scenario: TA_VR13. NonHotSpot Rule should have at least one of the elements from the function block
    Given template treatment arm json with an id: "APEC1621-VR13", stratum_id: "100" and version: "V100"
    And clear template treatment arm json's variant: "nhr" list
    And create a template variant: "nhr" for treatment arm
    And remove "function" field from the variant
    And remove "func_gene" field from the variant
    And remove "oncomine_variant_class" field from the variant
    And remove "exon" field from the variant
    And add template variant: "nhr" to template treatment arm json
    When creating a new treatment arm using post request
    Then a failure message is returned which contains: "missing required non hotspot rule"
