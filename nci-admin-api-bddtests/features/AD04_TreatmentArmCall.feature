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

  Scenario Outline: API should retrieve all treatment arms that match parameters provided
    Given I build a request param with "<first_field>" "<first_value>" and "<second_field>" "<second_value>"
    When I make a get call to treatment_arm_api with those parameters
    Then  I "should" see a "<success>" message
    And I should see a status code of "<status_code>"
    And I should retrieve an array of treatment arm(s)
    And All the "<first_field>" in all the treatment arm is "<first_value>"
    And All the "<second_field>" in all the treatment arm is "<second_value>"
    Examples:
      | first_field      | first_value | second_field | second_value | success | status_code |
      | treatment_arm_id | APEC1621-A  | stratum_id   | 100          | Success | 200         |
      | treatment_arm_id | APEC1621-A  | version      | 2015-08-06   | Failure | 400         |
      | stratum_id       | 100         | version      | 2015-08-06   | Failure | 400         |

  Scenario: If calling the API with one field it should retrieve all treatment arms that match the field
    Given I build a request param with id "APEC1621-A"
    When I make a get call to treatment_arm_api with those parameters
    Then  I "should" see a "Success" message
    And I should see a status code of "200"
    And I should retrieve an array of treatment arm(s)
    And All the "treatment_arm_id" in all the treatment arm is "APEC1621-A"

  Scenario: If calling the API with values for non-existent Treatment arm should return a 404
    Given I build a request param with id "APEC1621-XYZ", stratum id "100" and version "vaersion"
    When I make a get call to treatment_arm_api with those parameters
    Then  I "should" see a "Failure" message
    And I should see a status code of "404"
    And I should receive an empty hash

  Scenario: If calling the API with a parameter for non-existent Treatment arm should return a 404
    Given I build a request param with id "DOESNOTEXIST"
    When I make a get call to treatment_arm_api with those parameters
    Then  I "should" see a "Failure" message
    And I should see a status code of "404"
    And I should receive an empty array
