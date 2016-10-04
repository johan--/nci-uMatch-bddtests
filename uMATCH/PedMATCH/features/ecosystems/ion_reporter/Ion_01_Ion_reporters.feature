#encoding: utf-8
@ion_reporter_reporters
Feature: Tests for ion_reporters service in ion ecosystem

@ion_reporter_p1
Scenario: ION_IR01. new ion_reporter can be created successfully
  #should keep the generated ion_reporter_id from returned response
#  should check returned field date_ion_reporter_id_created, ion_reporter_id, site

Scenario: ION_IR02. new ion_reporter for the existing site should fail(or should pass, but old ion_reporter_id will not be used?)

Scenario Outline: ION_IR03. new ion_reporter for invalid site should fail
  Examples:

Scenario: ION_IR04. ion_reporter_id in message body should not be stored

Scenario: ION_IR19. extra key-value pair in the message body should NOT fail


Scenario Outline: ION_IR21. ion_reporter can be updated successfully
  Examples:

Scenario: ION_IR41. specific ion_reporter can be deleted successfully

Scenario Outline: ION_IR42. ion_reporter can be batch deleted
  Examples:

Scenario: ION_IR43. no ion_reporter will be deleted if no one meet the batch delete criteria



Scenario Outline: ION_IR61. ion_reporter can be updated successfully
  Examples:





