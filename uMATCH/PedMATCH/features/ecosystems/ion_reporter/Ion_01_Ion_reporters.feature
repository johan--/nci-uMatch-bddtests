#encoding: utf-8
@ion_reporter_reporters @test
Feature: Tests for ion_reporters service in ion ecosystem

@ion_reporter_p1
  Scenario: ION_IR01. new ion_reporter can be created successfully
  #should keep the generated ion_reporter_id from returned response
#  should check returned field date_ion_reporter_id_created, ion_reporter_id, site

  Scenario: ION_IR02. new ion_reporter for the existing site should fail(or should pass, but old ion_reporter_id will not be used?)

  Scenario: ION_IR03. new ion_reporter for invalid site should fail

  Scenario: ION_IR04. ion_reporter service can take any message body but should not store it (no-related values, ion_reporter_id, site...)

  Scenario: ION_IR05. date_ion_reporter_id_created should be generated properly


  Scenario: ION_IR20. ion_reporter can be updated successfully

  Scenario: ION_IR21. ion_reporter update request with non-existing ion_reporter_id should fail

  Scenario: ION_IR22. ion_reporter update request should not fail if extra key-value pair in message body, but doesn't store them




  Scenario: ION_IR40. specific ion_reporter can be deleted successfully

  Scenario: ION_IR41. ion_reporters can be batch deleted

  Scenario: ION_IR42. ion_reporter service should return error if the specified ion_reporter_id doesn't exist, and no ion_reporter is deleted

  Scenario: ION_IR43. ion_reporter service should return error if no ion_reporter meet batch delete parameters, and no ion_reporter is deleted



  Scenario: ION_IR60. ion_reporter service can list all existing ion_reporters

  Scenario: ION_IR61. ion_reporter service can list all ion_reporters that meet query parameters

  Scenario: ION_IR62. ion_reporter service can return single ion_reporter with specified ion_reporter_id

  Scenario: ION_IR63. ion_reporter service should only return projected VALID key-value pair

  Scenario: ION_IR64. ion_reporter service should fail if an invalid key is projected

  Scenario: ION_IR65. ion_reporter service should return 404 error if query a non-existing ion_reporter_id





