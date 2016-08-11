@patients #@demo
Feature: api that provides access to patient data. This feature ensures the api is running

  Scenario Outline: Test to ensure that service is running
    When the patient service /version is called
    Then the version "<version>" is returned
    Examples:
      |version    |
      |0.0.1        |


  Scenario Outline: Test to ensure that service is running
    When the patient processor service /version is called
    Then the version "<version>" is returned
    Examples:
      |version    |
      |0.0.1        |