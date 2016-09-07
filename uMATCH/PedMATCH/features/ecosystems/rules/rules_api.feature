@demo
Feature: This feature ensures the rules api is running

  Scenario: Test to ensure that service is running
    When the rules service /version is called
    Then the version "1.0.0" is returned as json


