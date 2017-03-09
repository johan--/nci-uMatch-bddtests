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

    @treatment_arm_p2
    Scenario: TA_NHR3. Treatment arm with a domain value in NHR containing a valid value should pass
      Given template treatment arm json with an id: "APEC1621_with_NHR_domain_success"
      And create a template variant: "nhr" for treatment arm
      And set template treatment arm variant field: "domain" to string value: "400-450"
      Then add template variant: "nhr" to template treatment arm json
      When creating a new treatment arm using post request
      Then a success message is returned

    @treatment_arm_p2
    Scenario: TA_NHR3. Treatment arm with a domain value in NHR containing a invalid value should return an error
      Given template treatment arm json with an id: "APEC1621_with_NHR_invalid_domain"
      And create a template variant: "nhr" for treatment arm
      And set template treatment arm variant field: "domain" to string value: "400"
      Then add template variant: "nhr" to template treatment arm json
      When creating a new treatment arm using post request
      Then a failure message is returned which contains: "Validation failed."

    @treatment_arm_p2
    Scenario: TA_NHR3. Treatment arm with a domain value in NHR containing a invalid range should return an error
      Given template treatment arm json with an id: "APEC1621_with_NHR_invaliddomainrange"
      And create a template variant: "nhr" for treatment arm
      And set template treatment arm variant field: "domain" to string value: "410-400"
      Then add template variant: "nhr" to template treatment arm json
      When creating a new treatment arm using post request
      Then a failure message is returned which contains: "Validation failed."
