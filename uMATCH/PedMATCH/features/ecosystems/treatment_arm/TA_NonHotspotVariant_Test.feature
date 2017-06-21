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
  Scenario: TA_NHR3a. Treatment arm with a domain value in NHR containing a valid value should pass
    Given template treatment arm json with an id: "APEC1621_with_NHR_domain_success"
    And create a template variant: "nhr" for treatment arm
    And set template treatment arm variant field: "domain_range" to string value: "400-450"
    Then add template variant: "nhr" to template treatment arm json
    When creating a new treatment arm using post request
    Then a success message is returned

  @treatment_arm_p2
  Scenario Outline: TA_NHR3b. Treatment arm with a domain value in NHR containing invalid value should return an error
    Given template treatment arm json with an id: "<ta_id>"
    And create a template variant: "nhr" for treatment arm
    And set template treatment arm variant field: "domain_range" to string value: "<domain_range>"
    Then add template variant: "nhr" to template treatment arm json
    When creating a new treatment arm using post request
    Then a failure message is returned which contains: "Domain Range"
    Examples:
      | ta_id                                | domain_range |
      | APEC1621_with_NHR_single_int_domain  | 400          |
      | APEC1621_with_NHR_reversedomainrange | 410-400      |
      | APEC1621_with_NHR_stringdomainrange  | two-400      |
      | APEC1621_with_NHR_minusdomainrange   | -5-400       |
      | APEC1621_with_NHR_nodashdomainrange1 | 200 400      |
      | APEC1621_with_NHR_nodashdomainrange2 | 200_400      |
      | APEC1621_with_NHR_space_domainrange1 | 100 -200     |
      | APEC1621_with_NHR_space_domainrange2 | 100- 200     |
      | APEC1621_with_NHR_space_domainrange3 | 10 0-200     |
      | APEC1621_with_NHR_space_domainrange4 | 100-2 00     |
