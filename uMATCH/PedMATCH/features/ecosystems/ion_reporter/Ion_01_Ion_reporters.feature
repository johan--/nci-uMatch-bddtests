#encoding: utf-8
@ion_reporter_reporters
Feature: Tests for ion_reporters service in ion ecosystem

  @ion_reporter_p1
  Scenario Outline: ION_IR01. new ion_reporter can be created successfully
    Given site is "<site>"
    When call ion_reporters POST service 1 times, returns a message that includes "New ion reporter created" with status "Success"
    Then each generated ion_reporter_id should have 1 record
    Then field: "site" for each generated ion_reporter should be: "<site>"
    Examples:
      | site  |
      | mda   |
      | mocha |

  @ion_reporter_p2
  Scenario: ION_IR02. multiple ion_reporters can be generated for same site
    Given site is "mda"
    When call ion_reporters POST service 3 times, returns a message that includes "New ion reporter created" with status "Success"
    Then there are 3 ion_reporter_ids generated
    And each generated ion_reporter_id should have 1 record

  @ion_reporter_not_required
  Scenario Outline: ION_IR03. new ion_reporter for invalid site should fail
    Given site is "<site>"
    When call ion_reporters POST service 1 times, returns a message that includes "site" with status "Failure"
    Examples:
      | site         |
      | MDA          |
      | MoCha        |
      | invalid_site |

  @ion_reporter_p3
  Scenario: ION_IR04. ion_reporter POST service can take any message body but should not store it (no-related values, ion_reporter_id, site...)
    Given site is "mocha"
    Then add field: "ion_reporter_id" value: "IR_O2YIA" to message body
    Then add field: "site" value: "yale" to message body
    Then add field: "ip_address" value: "204.60.187.1" to message body
    When call ion_reporters POST service 1 times, returns a message that includes "New ion reporter created" with status "Success"
    Then each generated ion_reporter should have 3 field-value pairs
    Then each generated ion_reporter should have field: "date_ion_reporter_id_created"
    Then each generated ion_reporter should have field: "ion_reporter_id"
    Then each generated ion_reporter should have field: "site"
    Then field: "site" for each generated ion_reporter should be: "mocha"

  @ion_reporter_p2
  Scenario: ION_IR05. date_ion_reporter_id_created should be generated properly
    Given site is "mda"
    When call ion_reporters POST service 1 times, returns a message that includes "New ion reporter created" with status "Success"
    Then each generated ion_reporter should have correct date_ion_reporter_id_created

  @ion_reporter_not_required
  Scenario Outline: ION_IR06. ion_reporter service should fail if parameters other than "site" are passed in
    Given site is "mocha"
    Then add field: "<field>" value: "<value>" to url
    When call ion_reporters POST service 1 times, returns a message that includes "<field> was passed in request" with status "Failure"
    Examples:
      | field                        | value                   |
      | date_ion_reporter_id_created | 2010-01-07              |
      | ion_reporter_id              | IR_O2YIA                |
      | ir_status                    | Contacted 4 minutes ago |
      | host_name                    | YSM-MATCH-IR            |

  @ion_reporter_p1
  Scenario: ION_IR20. ion_reporter can be updated successfully
    Given ion_reporter_id is "IR_CFUER"
    Then add field: "last_contact" value: "October 03, 2016 10:35 PM" to message body
    Then add field: "internal_ip_address" value: "172.20.174.24" to message body
    Then add field: "ir_status" value: "Contacted 5 days ago" to message body
    Then add field: "host_name" value: "MDACC-MATCH-IR" to message body
    Then add field: "data_files" value: "Log File" to message body
    Then add field: "ip_address" value: "132.183.13.75" to message body
    When call ion_reporters PUT service, returns a message that includes "updated" with status "Success"
    Then wait up to 15 seconds until this ion_reporter get updated
    Then field: "last_contact" for this ion_reporter should be: "October 03, 2016 10:35 PM"
    Then field: "internal_ip_address" for this ion_reporter should be: "172.20.174.24"
    Then field: "ir_status" for this ion_reporter should be: "Contacted 5 days ago"
    Then field: "host_name" for this ion_reporter should be: "MDACC-MATCH-IR"
    Then field: "data_files" for this ion_reporter should be: "Log File"
    Then field: "ip_address" for this ion_reporter should be: "132.183.13.75"

  @ion_reporter_p2
  Scenario Outline: ION_IR21. ion_reporter update request should fail if ion_reporter_id, site or date_ion_reporter_id_created is in message body
    Given ion_reporter_id is "IR_GBOPP"
    Then add field: "<field>" value: "<value>" to message body
    When call ion_reporters PUT service, returns a message that includes "<field>" with status "Failure"
    Examples:
      | field                        | value      |
      | date_ion_reporter_id_created | 2010-04-25 |
      | ion_reporter_id              | IR_XXJXX   |
      | site                         | mocha      |

  @ion_reporter_p3
  Scenario: ION_IR22. ion_reporter update request should fail if non-existing ion_reporter_id is passed in
    Given ion_reporter_id is "IR_NON_EXISTING"
    Then add field: "last_contact" value: "October 03, 2016 10:35 PM" to message body
    When call ion_reporters PUT service, returns a message that includes "exist" with status "Failure"

  @ion_reporter_p3
  Scenario: ION_IR23. ion_reporter update request should fail if no ion_reporter_id is passed in
    Given ion_reporter_id is ""
    Then add field: "last_contact" value: "October 03, 2016 10:35 PM" to message body
    When call ion_reporters PUT service, returns a message that includes "The method is not allowed for the requested URL" with status "Failure"

  @ion_reporter_not_required
  Scenario: ION_IR24. ion_reporter update request should not fail if extra key-value pair in message body, but doesn't store them
    Given ion_reporter_id is "IR_1H9XW"
    Then add field: "extra_information" value: "other" to message body
    When call ion_reporters PUT service, returns a message that includes "updated" with status "Success"
    Then wait up to 15 seconds until this ion_reporter get updated
    Then updated ion_reporter should not have field: "extra_information"

  @ion_reporter_p2
  Scenario: ION_IR25. ion_reporter update request should not remove existing fields that are not in PUT message body
    Given ion_reporter_id is "IR_3I4AB"

  @ion_reporter_p1
  Scenario: ION_IR40. specific ion_reporter can be deleted successfully
    Given ion_reporter_id is "IR_TG2DY"
    Then call ion_reporters DELETE service, returns a message that includes "Item deleted" with status "Success"
    Then wait up to 15 seconds until this ion_reporter get updated
    Then call ion_reporters GET service, returns a message that includes "No ABCMeta" with status "Failure"

  @ion_reporter_p1
  Scenario: ION_IR41. ion_reporters can be batch deleted
    #ion_reporter IR_37Y4Y should be deleted
    Given ion_reporter_id is ""
    Then add field: "date_ion_reporter_id_created" value: "2016-10-12 21:19:38.752627" to url
    Then call ion_reporters GET service, returns a message that includes "" with status "Success"
    Then there are|is 1 ion_reporter returned
    Then call ion_reporters DELETE service, returns a message that includes "Batch deletion request placed on queue to be processed" with status "Success"
    Then wait for "5" seconds
    Then call ion_reporters GET service, returns a message that includes "No records meet the query parameters" with status "Failure"

  @ion_reporter_p2
  Scenario: ION_IR42. ion_reporter service should fail if no ion_reporter_id is passed in, and no ion_reporter is deleted
    Given ion_reporter_id is ""
    Then record total ion_reporters count
    Then call ion_reporters DELETE service, returns a message that includes "Cannot use batch delete to delete all records" with status "Failure"
    Then wait for "5" seconds
    Then new and old total ion_reporters counts should have 0 difference

  @ion_reporter_p2
  Scenario: ION_IR43. ion_reporter service should fail if non-existing ion_reporter_id is passed in, and no ion_reporter is deleted
    Given ion_reporter_id is "IR_NON_EXISTING"
    Then record total ion_reporters count
    Then call ion_reporters DELETE service, returns a message that includes "exist" with status "Failure"
    Then wait for "5" seconds
    Then new and old total ion_reporters counts should have 0 difference

  @ion_reporter_p2
  Scenario: ION_IR44. no ion_reporter will be deleted if no ion_reporter meet batch delete parameters, and
    Given ion_reporter_id is ""
    Then add field: "site" value: "invalid_site" to url
    Then record total ion_reporters count
    Then call ion_reporters DELETE service, returns a message that includes "" with status "Success"
    Then wait for "5" seconds
    Then new and old total ion_reporters counts should have 0 difference

  @ion_reporter_p1
  Scenario: ION_IR60. ion_reporter service can list all existing ion_reporters
    Given ion_reporter_id is ""
    When call ion_reporters GET service, returns a message that includes "ion_reporter_id" with status "Success"

  @ion_reporter_p1
  Scenario: ION_IR61. ion_reporter service can list all ion_reporters that meet query parameters(special characters?)
    Given ion_reporter_id is ""
    Then add field: "date_ion_reporter_id_created" value: "2016-10-12 21:19:37.073738" to url
    Then field: "ion_reporter_id" for this ion_reporter should be: "IR_ONO31"

  @ion_reporter_p1
  Scenario: ION_IR62. ion_reporter service can return single ion_reporter with specified ion_reporter_id
    Given ion_reporter_id is "IR_PU4NI"
    Then field: "site" for this ion_reporter should be: "mocha"

  @ion_reporter_p2
  Scenario Outline: ION_IR63. ion_reporter service should only return VALID projected key-value pair
    Given ion_reporter_id is "<ion_id>"
    Then add projection: "<field1>" to url
    Then add projection: "<field2>" to url
    Then add projection: "bad_projection" to url
    Then call ion_reporters GET service, returns a message that includes "" with status "Success"
    Then each returned ion_reporter should have 2 fields
    Then each returned ion_reporter should have field "<field1>"
    Then each returned ion_reporter should have field "<field2>"
    Examples:
      | ion_id   | field1                       | field2          |
      | IR_NX0TL | host_name                    | ion_reporter_id |
      |          | date_ion_reporter_id_created | site            |

  @ion_reporter_p2
  Scenario: ION_IR65. ion_reporter service should return 404 error if query a non-existing ion_reporter_id
    Given ion_reporter_id is ""
    Then add field: "site" value: "non_existing_site" to url
    Then call ion_reporters GET service, returns a message that includes "No records meet the query parameters" with status "Failure"

  @ion_reporter_p1
  Scenario: ION_IR80. ion_reporter service can list all patients on specified ion_reporter

  @ion_reporter_p1
  Scenario: ION_IR81. ion_reporter service can list all sample controls on specified ion_reporter
    Given ion_reporter_id is "IR_0HV52"
    When call ion_reporters GET sample_controls service, returns a message that includes "" with status "Success"
    Then there are|is 3 sample_control returned
    Then returned sample_control should contain molecular_id: "SC_JFCEO"
    Then returned sample_control should contain molecular_id: "SC_CN8ZS"
    Then returned sample_control should contain molecular_id: "SC_C777Z"

#  Scenario: ION_IR82. ion_reporter service should fail if projection is used when query patients

  @ion_reporter_p2
  Scenario: ION_IR83. ion_reporter service should only return VALID projected key-value pair when query sample controls
    Given ion_reporter_id is "IR_0R0WO"
    Then add projection: "molecular_id" to url
    Then add projection: "control_type" to url
    Then add projection: "bad_projection" to url
    When call ion_reporters GET sample_controls service, returns a message that includes "" with status "Success"
    Then each returned sample_control should have 2 fields
    Then each returned sample_control should have field "molecular_id"
    Then each returned sample_control should have field "control_type"

  @ion_reporter_p3
  Scenario: ION_IR84. ion_reporter service should fail(or just not return this field?) if no sample control meet the parameter
    Given ion_reporter_id is "IR_TCWEV"
    Then add field: "molecular_id" value: "non_existing_moi" to url
    Then call ion_reporters GET sample_controls service, returns a message that includes "No records meet the query parameters" with status "Failure"









