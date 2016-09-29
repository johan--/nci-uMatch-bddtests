#encoding: utf-8
  
@treatment_arm

Feature: Treatment Arm API Tests that focus on "stratum_id" field

  @treatment_arm_p2
  Scenario: TA_SI3. Calling treatment arm list filters values by both id and stratum
    Given template treatment arm json with an id: "APEC1621-SI3-1", stratum_id: "STRATUM1" and version: "2016-06-03"
    Then creating a new treatment arm using post request
    Then a success message is returned
    Then wait for processor to complete request in "10" seconds
    Then template treatment arm json with an id: "APEC1621-SI3-1", stratum_id: "STRATUM1" and version: "2016-06-15"
    Then creating a new treatment arm using post request
    Then a success message is returned
    Then wait for processor to complete request in "10" seconds
    Then template treatment arm json with an id: "APEC1621-SI3-1", stratum_id: "STRATUM2" and version: "2016-06-15"
    Then creating a new treatment arm using post request
    Then a success message is returned
    Then wait for processor to complete request in "10" seconds
    Then template treatment arm json with an id: "APEC1621-SI3-2", stratum_id: "STRATUM2" and version: "2016-06-15"
    Then creating a new treatment arm using post request
    Then a success message is returned
    Then retrieve treatment arms with id: "APEC1621-SI3-1" and stratum_id: "STRATUM1" from API
    Then should return "2" of the records
    Then retrieve treatment arms with id: "APEC1621-SI3-1" and stratum_id: "STRATUM2" from API
    Then should return "1" of the records
    Then retrieve treatment arms with id: "APEC1621-SI3-2" and stratum_id: "STRATUM2" from API
    Then should return "1" of the records
    Then retrieve treatment arms with id: "APEC1621-SI3-2" and stratum_id: "STRATUM1" from API
    Then should return "0" of the records

