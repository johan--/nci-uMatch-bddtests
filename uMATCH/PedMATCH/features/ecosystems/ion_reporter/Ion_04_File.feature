#encoding: utf-8
@ion_reporter_reporters
Feature: Tests for files service in ion ecosystem

@ion_reporter_p1

  Scenario: ION_FL01. files service can return correct result for sample control molecular_id (sorted by different analysis_ids?)

  Scenario: ION_FL02. files service can return correct result for patient tissue molecular_id

  Scenario: ION_FL03. files service can return correct result for patient blood molecular_id

  Scenario: ION_FL04. files service should fail if specified molecular_id is invalid

  Scenario: ION_FL04. files service should fail if specified file_type is invalid

  Scenario: ION_FL05. returned file path should be valid S3 path

  Scenario: ION_FL06. files service should return error if no molecular_id and file_type is provided

  Scenario: ION_FL07. files service should return 404 error if result for current query



  Scenario: ION_FL80. files service should return error when user want to create new item using POST

  Scenario: ION_FL81. files service should return error when user want to delete item using DELETE

  Scenario: ION_FL82. files service should return error when user want to update item using PUT


