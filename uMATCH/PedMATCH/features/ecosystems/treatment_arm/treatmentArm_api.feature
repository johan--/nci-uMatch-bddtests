Feature: api that provides access to treatment arm data. This feature ensures the api is running
@demo
  Scenario Outline: Test to ensure that treatment_arm_api service is running
    When the ta service /version is called
    Then the version "<version>" is returned
  Examples:
    |version    |
    |0.0.9      |


