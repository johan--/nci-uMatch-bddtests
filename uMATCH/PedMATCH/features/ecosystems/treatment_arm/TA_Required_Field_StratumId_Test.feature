#encoding: utf-8
  
@treatment_arm

Feature: Treatment Arm API Tests that focus on "stratum_id" field

  Scenario: TA_SI3. Calling treatment arm list filters values by both id and stratum
    Given template treatment arm json with an id: "APEC1621-SI3-1", stratum_id: "STRATUM1" and version: "2016-06-03"
    Then creating a new treatment arm using post request
    Then a success message is returned
    Then wait for "5" seconds
    Then template treatment arm json with an id: "APEC1621-SI3-1", stratum_id: "STRATUM1" and version: "2016-06-15"
    Then updating an existing treatment arm using put request
    Then a success message is returned
    Then wait for "5" seconds
    Then template treatment arm json with an id: "APEC1621-SI3-1", stratum_id: "STRATUM2" and version: "2016-06-15"
    Then creating a new treatment arm using post request
    Then a success message is returned
    Then wait for "5" seconds
    Then template treatment arm json with an id: "APEC1621-SI3-2", stratum_id: "STRATUM2" and version: "2016-06-15"
    Then creating a new treatment arm using post request
    Then a success message is returned
    Then retrieve treatment arms with id: "APEC1621-SI3-1" and stratum_id: "STRATUM1" from API
    Then there are "2" treatment arms in returned list
    Then retrieve treatment arms with id: "APEC1621-SI3-1" and stratum_id: "STRATUM2" from API
    Then there are "1" treatment arms in returned list
    Then retrieve treatment arms with id: "APEC1621-SI3-2" and stratum_id: "STRATUM2" from API
    Then there are "1" treatment arms in returned list
    Then retrieve treatment arms with id: "APEC1621-SI3-2" and stratum_id: "STRATUM1" from API
    Then there are "0" treatment arms in returned list

