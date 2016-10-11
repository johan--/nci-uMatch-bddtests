@treatment_arm
  Feature: TA_NHR. NonHotspot Rules test

    @treatment_arm_p3
    Scenario: TA_NHR1. Treatment arm with no nhr will pass
      Given template treatment arm json with an id: "APEC1621_NO_NHR"
      And remove field: "non_hotspot_rules" from template treatment arm json
      When creating a new treatment arm using post request
      Then a success message is returned
      And the "non_hotspot_rules" field has a "null" value

    @treatment_arm_p3
    Scenario: TA_NHR2. Treatment arm with nhr wil fail if all entries are null
      Given template treatment arm json with an id: "APEC1621_NHR"
