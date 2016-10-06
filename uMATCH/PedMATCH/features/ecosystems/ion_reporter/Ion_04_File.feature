#encoding: utf-8
@ion_reporter_reporters
Feature: Tests for files service in ion ecosystem

@ion_reporter_p1

  Scenario: ION_FL01. files service can return correct result for sample control molecular_id

  Scenario: ION_FL02. files service should fail if a patient molecular_id is passed in

  Scenario: ION_FL03. files service should fail if an non-existing molecular_id is passed in

  Scenario: ION_FL04. files service should fail if an non-existing file_name is passed in

  Scenario: ION_FL05. files service should fail if an non-misc file_name is passed in

  Scenario: ION_FL06. returned file path should be reachable S3 path

  Scenario: ION_FL07. files service should fail if no molecular_id and/or file_type is passed in

  Scenario: ION_FL08. files service should return 404 error if no result for current query



  Scenario: ION_FL80. files service should fail when user want to create new item using POST

  Scenario: ION_FL81. files service should fail when user want to delete item using DELETE

  Scenario: ION_FL82. files service should fail when user want to update item using PUT


