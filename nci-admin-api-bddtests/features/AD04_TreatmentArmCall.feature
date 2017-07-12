@admin_api_p1
Feature: Admin API Treatment Arm Call
  As an Admin user of Admin Tool API
  I should be able to use the treatment_arm_api route
  So that I can retrieve data from the treatment arm table

  Background:
    Given I am a user of type "ADMIN"

  Scenario: Calling the API with treatment_arm_id, version and stratum id will return specific treatment arm
    Given I build a request param with id "APEC1621-A", stratum id "100" and version "2015-08-06"
    When I make a get call to treatment_arm_api with those parameters
    Then  I "should" see a "Success" message
    And I should see a status code of "200"
    And I should retrieve one treatment arm

  Scenario: If calling the API with values for non-existent Treatment arm should return a 404
    Given I build a request param with id "APEC1621-XYZ", stratum id "100" and version "vaersion"
    When I make a get call to treatment_arm_api with those parameters
    Then  I "should" see a "Failure" message
    And I should see a status code of "404"
    And I should receive an appropriate message
