#encoding: utf-8
@sample_control_reporters
Feature: Tests for sample_controls service in ion ecosystem

@sample_control_p1
  Scenario: ION_SC01. new sample_control can be created successfully(all control_types)
  #should keep the generated sample_control_id from returned response
  #  then check returned fields

  Scenario: ION_SC02. sample control service should generate unique molecular_id

  Scenario: ION_SC03. sample control service should fail if site is invalid

  Scenario: ION_SC04. sample control service should fail if control_type is invalid

  Scenario: ION_SC05. sample_control PUT service can take any message body but should not store it (no-related values, molecular_id, site...)

  Scenario: ION_SC06. date_molecular_id_created should be generated properly

  Scenario: ION_IR07. ion_reporter service should fail if parameters other than "site" and "control_type" are passed in


  Scenario: ION_SC20. sample_control can be updated successfully

  Scenario: ION_SC21. sample_control update request with non-existing molecular_id should fail

  Scenario: ION_SC22. sample_control update request with patient molecular_id should fail

  Scenario: ION_SC23. sample_control service should fail if site-ion_reporter_id pair in message body is invalid

  Scenario: ION_SC24. sample_control service should fail if existing analysis_id is used

  Scenario: ION_SC25. sample_control service should fail if any file value(vcf, bam, qc) is missing

  Scenario: ION_SC39. sample_control update request should not fail if extra key-value pair in message body, but doesn't store them




  Scenario: ION_SC40. sample_control with specific molecular_id can be deleted successfully

  Scenario: ION_SC41. sample_controls can be batch deleted using parameters

  Scenario: ION_SC41. sample_controls cannot be batch deleted without parameters

  Scenario: ION_SC42. sample_control service should fail if the specified molecular_id doesn't exist (including existing patient molecular_id), and no sample_control is deleted

  Scenario: ION_SC43. sample_control service should fail if no sample_control meet batch delete parameters, and no sample_control is deleted




  Scenario: ION_SC60. sample_control service can list all existing sample_controls

  Scenario: ION_SC61. sample_control service can list all sample_controls that meet query parameters

  Scenario: ION_SC62. sample_control service can return single sample_control with specified molecular_id

  Scenario: ION_SC63. sample_control service should only return projected VALID key-value pair

  Scenario: ION_SC64. sample_control service should fail if an invalid key is projected

  Scenario: ION_SC65. sample_control service should return 404 error if query a non-existing sample_control_id



