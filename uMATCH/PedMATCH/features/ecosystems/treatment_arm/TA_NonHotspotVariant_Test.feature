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

    @treatment_arm_p3
    Scenario: TA_NHR3a. Treatment arm with a domain value in NHR containing a valid value should pass
      Given template treatment arm json with an id: "APEC1621_with_NHR_domain_success"
      And create a template variant: "nhr" for treatment arm
      And set template treatment arm variant field: "domain" to string value: "400-450"
      Then add template variant: "nhr" to template treatment arm json
      When creating a new treatment arm using post request
      Then a success message is returned

    @treatment_arm_p3
    Scenario: TA_NHR3b. Treatment arm with a domain value in NHR containing a single int value should return an error
      Given template treatment arm json with an id: "APEC1621_with_NHR_single_int_domain"
      And create a template variant: "nhr" for treatment arm
      And set template treatment arm variant field: "domain" to string value: "400"
      Then add template variant: "nhr" to template treatment arm json
      When creating a new treatment arm using post request
      Then a failure message is returned which contains: "Validation failed."

    @treatment_arm_p3
    Scenario: TA_NHR3c. Treatment arm with a domain value in NHR containing a reverse range should return an error
      Given template treatment arm json with an id: "APEC1621_with_NHR_reversedomainrange"
      And create a template variant: "nhr" for treatment arm
      And set template treatment arm variant field: "domain" to string value: "410-400"
      Then add template variant: "nhr" to template treatment arm json
      When creating a new treatment arm using post request
      Then a failure message is returned which contains: "Validation failed."

    @treatment_arm_p3
    Scenario: TA_NHR3d. Treatment arm with a domain value in NHR containing value other than range should return an error
      Given template treatment arm json with an id: "APEC1621_with_NHR_stringdomainrange"
      And create a template variant: "nhr" for treatment arm
      And set template treatment arm variant field: "domain" to string value: "string"
      Then add template variant: "nhr" to template treatment arm json
      When creating a new treatment arm using post request
      Then a failure message is returned which contains: "Validation failed."

    @treatment_arm_p3
    Scenario: TA_NHR3e. Treatment arm with a domain value in NHR containing minus value should return an error
      Given template treatment arm json with an id: "APEC1621_with_NHR_minusdomainrange"
      And create a template variant: "nhr" for treatment arm
      And set template treatment arm variant field: "domain" to string value: "-5-400"
      Then add template variant: "nhr" to template treatment arm json
      When creating a new treatment arm using post request
      Then a failure message is returned which contains: "Validation failed."
