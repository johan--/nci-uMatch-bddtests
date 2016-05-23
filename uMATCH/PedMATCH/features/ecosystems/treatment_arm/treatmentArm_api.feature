Feature: api that provides access to treatment arm data. This feature ensures the api is running

  Scenario Outline: Test to ensure that service is running
    When the service /version is called
    Then the version "<version>" is returned
  Examples:
    |version    |
    |0.0.6      |


