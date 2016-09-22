#@demo
@ion_reporter
Feature: ion reporter api happy tests

  Scenario: Test to ensure that ion reporter service is running
    When the ion reporter service /version is called, the version "0.0.1" is returned