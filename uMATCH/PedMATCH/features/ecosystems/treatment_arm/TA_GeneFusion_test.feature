@treatment_arm
Feature: TA_FSN. GeneFusion Rules test

  @treatment_arm_p1
  Scenario: TA_FSN1. identifier of gene fusion should be parsed to gene1 and gene2
    Given template treatment arm json with an id: "APEC1621_FSN1"
    And clear template treatment arm json's variant: "gf" list
    Then create a template variant: "gf" for treatment arm
    And set template treatment arm variant field: "identifier" to string value: "BCR-FGFR1.B4F10"
    And set template treatment arm variant field: "arm_specific" to bool value: "false"
    And set template treatment arm variant field: "gene" to string value: "FGFR1"
    And set template treatment arm variant field: "protein" to string value: "BCR-FGFR1.B4F10"
    And set template treatment arm variant field: "description" to string value: "FGFR1 Gene Fusion"
    Then add template variant: "gf" to template treatment arm json
    When creating a new treatment arm using post request
    Then a success message is returned
    Then wait for processor to complete request in "10" attempts
    Then retrieve treatment arms with id: "APEC1621_FSN1" and stratum_id: "stratum1" from API
    Then the first returned treatment arm has "gf" variant (id: "BCR-FGFR1.B4F10", field: "description", value: "FGFR1 Gene Fusion")
    And this treatment arm variant has field "gene1" value "BCR"
    And this treatment arm variant has field "gene2" value "FGFR1"
