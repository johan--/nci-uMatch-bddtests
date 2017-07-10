@admin_api_p1

Feature: Pending treatment arm call
  As an Admin user
  I want to access the /pending_treatment_arms api endpoint
  So I can get a json response to feed the UI


  Scenario: Pending_01: A valid user can get a list of pending treatment arms
    Given I am a user of type "ADMIN"
    When I issue a get request to pending treatment arms
    Then I should get a list of all the treatment arm in the table

  Scenario: Pending_02: A valid user can retrieve the details of a single treatment arm from the pending ta table
    Given I am a user of type "ADMIN"
    When I issue a get request to pending treatment arms with id "APEC1621-AA_PEND" and version "version1"
    And The "treatment_arm_id" of the treatment arm should be "APEC1621-AA_PEND"
    And The "version" of the treatment arm should be "version1"

  Scenario Outline: Pending_03_<Sno>: When a treatment arm is not found an error should be raised
    Given I am a user of type "ADMIN"
    When I issue a get request to pending treatment arms with id "<treatment_arm>" and version "<version>"
    Then I "should" see a "Failure" message
    And I should see a status code of "404"
    Examples:
      | Sno | treatment_arm    | version           |
      | 1   | APEC1621-AA-PEND | CantFindVersion   |
      | 2   | CantFindID       | 5_2_2017-20_57_22 |
      | 3   | CantFindID       |                   |
      | 4   |                  | 5_2_2017-20_57_22 |
