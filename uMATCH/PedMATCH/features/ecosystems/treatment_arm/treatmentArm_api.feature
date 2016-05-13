Feature: api that provides access to treatment arm data


  Scenario Outline: Test to ensure that service is running
    When the service /version is called
    Then the version "<version>" is returned
  Examples:
    |version    |
    |0.0.5      |


