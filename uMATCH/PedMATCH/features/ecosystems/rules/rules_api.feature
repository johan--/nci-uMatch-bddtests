@demo
Feature: This feature ensures the rules api is running

  Scenario Outline: Test to ensure that service is running
    When the rules service /version is called
    Then the version "<version>" is returned
  Examples:
  |version                                                              |
  |PED-Match Rules Engine v.1.0-SNAPSHOT built on                       |


