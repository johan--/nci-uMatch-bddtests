#encoding: utf-8
@ion_reporter_reporters
Feature: Tests for ion_reporters service in ion ecosystem

  @ion_reporter_new_p1
  Scenario Outline: ION_IR01. new ion_reporter can be created successfully
    Given site is "<site>"
    When POST to ion_reporters service 1 times, response includes "New ion reporter created" with code "200"
    Then each generated ion_reporter_id should have 1 record
    Then field: "site" for each generated ion_reporter should be: "<site>"
    Then field: "study_id" for each generated ion_reporter should be: "APEC1621SC"
    Examples:
      | site      |
      | mda       |
      | mocha     |
      | dartmouth |

  @ion_reporter_new_p2
  Scenario: ION_IR02. multiple ion_reporters can be generated for same site
    Given site is "mda"
    When POST to ion_reporters service 3 times, response includes "New ion reporter created" with code "200"
    Then there are 3 ion_reporter_ids generated
    And each generated ion_reporter_id should have 1 record

  @ion_reporter_not_required
  Scenario Outline: ION_IR03. new ion_reporter for invalid site should fail
    Given site is "<site>"
    When POST to ion_reporters service 1 times, response includes "site" with code "403"
    Examples:
      | site         |
      | MDA          |
      | MoCha        |
      | Dartmouth    |
      | invalid_site |

  @ion_reporter_new_p3
  Scenario: ION_IR04. ion_reporter POST service can take any message body but should not store it (no-related values, ion_reporter_id, site...)
    Given site is "mocha"
    Then add field: "ion_reporter_id" value: "IR_O2YIA" to message body
    Then add field: "site" value: "yale" to message body
    Then add field: "ip_address" value: "204.60.187.1" to message body
    When POST to ion_reporters service 1 times, response includes "New ion reporter created" with code "200"
    Then each generated ion_reporter should have 3 field-value pairs
    Then each generated ion_reporter should have field: "date_ion_reporter_id_created"
    Then each generated ion_reporter should have field: "ion_reporter_id"
    Then each generated ion_reporter should have field: "site"
    Then field: "site" for each generated ion_reporter should be: "mocha"

  @ion_reporter_new_p2
  Scenario: ION_IR05. date_ion_reporter_id_created should be generated properly
    Given site is "mda"
    When POST to ion_reporters service 1 times, response includes "New ion reporter created" with code "200"
    Then each generated ion_reporter should have correct date_ion_reporter_id_created


  @ion_reporter_new_p2
  Scenario: ION_IR06. ion_reporter service should fail if "ion_reporter_id" is passed in
    Given site is "mocha"
    Then add field: "ion_reporter_id" value: "IR_O2YIA" to url
    When POST to ion_reporters service 1 times, response includes "ion_reporter_id was passed in" with code "400"

#  @ion_reporter_adult_match
#  Scenario Outline: ION_IR07. new Adult MATCH ion_reporter can be created successfully
#    Given site is "<site>"
#    When POST to Adult MATCH ion_reporters service 1 times, response includes "New ion reporter created" with code "200"
#    Then each generated ion_reporter_id should have 1 record
#    Then field: "site" for each generated ion_reporter should be: "<site>"
#    Examples:
#      | site      |
#      | mda       |
#      | mocha     |
#      | dartmouth |
#      | yale      |
#      | mgh       |

  @ion_reporter_new_p1
  Scenario: ION_IR20. ion_reporter can be updated successfully
    Given ion_reporter_id is "IR_CFUER"
    Then add field: "site" value: "mda" to message body
    Then add field: "internal_ip_address" value: "172.20.174.24" to message body
    Then add field: "host_name" value: "MDA-MATCH-IR" to message body
    Then add field: "data_files" value: "Log File" to message body
    Then add field: "ip_address" value: "132.183.13.75" to message body
    When PUT to ion_reporters service, response includes "updated" with code "200"
    Then wait up to 15 seconds until this ion_reporter get updated
    Then field: "internal_ip_address" for this ion_reporter should be: "172.20.174.24"
    Then field: "host_name" for this ion_reporter should be: "MDA-MATCH-IR"
    Then field: "data_files" for this ion_reporter should be: "Log File"
    Then field: "ip_address" for this ion_reporter should be: "132.183.13.75"

  @ion_reporter_new_p2
  Scenario Outline: ION_IR21. ion_reporter update request should not update ion_reporter_id
    Given ion_reporter_id is "IR_GBOPP"
    Then add field: "<field>" value: "<value1>" to message body
    Then add field: "site" value: "mocha" to message body
    When PUT to ion_reporters service, response includes "updated" with code "200"
    Then wait up to 15 seconds until this ion_reporter get updated
    Then field: "<field>" for this ion_reporter should be: "<value2>"
    Examples:
      | field                        | value1     | value2     |
      | date_ion_reporter_id_created | 2010-04-25 | 2010-04-25 |
      | ion_reporter_id              | IR_XXJXX   | IR_GBOPP   |

  @ion_reporter_new_p3
  Scenario: ION_IR22. ion_reporter update request should fail if non-existing ion_reporter_id is passed in
    Given ion_reporter_id is "IR_NON_EXISTING"
    Then add field: "last_contact" value: "2017-02-02 09:08:23.446499" to message body
    Then add field: "site" value: "mocha" to message body
    When PUT to ion_reporters service, response includes "exist" with code "404"

  @ion_reporter_new_p3
  Scenario: ION_IR23. ion_reporter update request should fail if no ion_reporter_id is passed in
    Given ion_reporter_id is ""
    Then add field: "last_contact" value: "2017-02-02 09:08:23.446499" to message body
    Then add field: "site" value: "mocha" to message body
    When PUT to ion_reporters service, response includes "is not allowed for the requested URL" with code "405"

  @ion_reporter_not_required
  Scenario: ION_IR24. ion_reporter update request should not fail if extra key-value pair in message body, but doesn't store them
    Given ion_reporter_id is "IR_1H9XW"
    Then add field: "extra_information" value: "other" to message body
    Then add field: "site" value: "mocha" to message body
    When PUT to ion_reporters service, response includes "updated" with code "200"
    Then wait up to 15 seconds until this ion_reporter get updated
    Then updated ion_reporter should not have field: "extra_information"

  @ion_reporter_new_p2
  Scenario: ION_IR25. ion_reporter update request should not remove existing fields that are not in PUT message body
    Given ion_reporter_id is "IR_3I4AB"

#    not requirement anymore
#  @ion_reporter_new_p2
#  Scenario: ION_IR26. ion_reporter update request will fail if no site value passed in
#    Given ion_reporter_id is "IR_1H9XW"
#    Then add field: "host_name" value: "MDACC-MATCH-IR" to message body
#    Then add field: "data_files" value: "Log File" to message body
#    Then add field: "ip_address" value: "132.183.13.75" to message body
#    When PUT to ion_reporters service, response includes "Need to pass in site information" with code "400"

  @ion_reporter_new_p1
  Scenario: ION_IR27. ion_reporter last contact can be updated properly
    Given ion_reporter_id is "IR_MCA03"
    And site is "mocha"
    Then add field: "last_contact" value: "now" to message body
    Then add field: "internal_ip" value: "10.19.10.10" to message body
    Then add field: "host_name" value: "MOCHA-MATCH-IR" to message body
    Then add field: "ion_reporter_version" value: "5.0" to message body
    Then add field: "site" value: "mocha" to message body
    And ir user authorization role is "SYSTEM"
    When PUT to ion_reporters service, response includes "updated" with code "200"
    Then wait up to 15 seconds until this ion_reporter get updated
    Then last_contact for this ion_reporter should have correct value
    Then last_contact for this ion_reporter healthcheck should have correct value
    Then ir_status for this ion_reporter healthcheck should be less than 60 seconds
    Then this ion_reporter healthcheck field "ion_reporter_version" should be "5.0"
    Then this ion_reporter healthcheck field "internal_ip" should be "10.19.10.10"
    Then this ion_reporter healthcheck field "host_name" should be "MOCHA-MATCH-IR"
    Then this ion_reporter healthcheck field "site" should be "mocha"

  @ion_reporter_new_p1
  Scenario: ION_IR40. specific ion_reporter can be deleted successfully
    Given ion_reporter_id is "IR_TG2DY"
    When DELETE to ion_reporters service, response includes "Item deleted" with code "200"
    Then wait up to 15 seconds until this ion_reporter get updated
    When GET from ion_reporters service, response includes "No ABCMeta" with code "404"

  @ion_reporter_new_p1
  Scenario: ION_IR41. ion_reporters can be batch deleted
    #ion_reporter IR_37Y4Y should be deleted
    Given ion_reporter_id is ""
    Then add field: "date_ion_reporter_id_created" value: "2016-10-12 21:19:38.752627" to url
    When GET from ion_reporters service, response includes "" with code "200"
    Then there are|is 1 ion_reporter returned
    When DELETE to ion_reporters service, response includes "Batch deletion request placed" with code "200"
    Then wait for "30" seconds
    When GET from ion_reporters service, response includes "" with code "200"
    Then there are|is 0 ion_reporter returned

  @ion_reporter_new_p2
  Scenario: ION_IR42. ion_reporter service should fail if no ion_reporter_id is passed in, and no ion_reporter is deleted
    Given ion_reporter_id is ""
    Then record total ion_reporters count
    When DELETE to ion_reporters service, response includes "delete all records" with code "400"
    #all this kinds of checking difference steps are removed, because in parallel INT run, we cannot guarantee, the
  #other valid deletion tests do not run during this waiting time.
#    Then wait for "30" seconds
#    Then new and old total ion_reporters counts should have 0 difference

  @ion_reporter_new_p2
  Scenario: ION_IR43. ion_reporter service should fail if non-existing ion_reporter_id is passed in, and no ion_reporter is deleted
    Given ion_reporter_id is "IR_NON_EXISTING"
    Then record total ion_reporters count
    When DELETE to ion_reporters service, response includes "exist" with code "404"
#    Then wait for "30" seconds
#    Then new and old total ion_reporters counts should have 0 difference

  @ion_reporter_new_p2
  Scenario: ION_IR44. no ion_reporter will be deleted if no ion_reporter meet batch delete parameters, and
    Given ion_reporter_id is ""
    Then add field: "site" value: "invalid_site" to url
    Then record total ion_reporters count
    When DELETE to ion_reporters service, response includes "" with code "200"
#    Then wait for "30" seconds
#    Then new and old total ion_reporters counts should have 0 difference

  @ion_reporter_new_p1
  Scenario: ION_IR60. ion_reporter service can list all existing ped match ion_reporters
    Given ion_reporter_id is ""
    When GET from ion_reporters service, response includes "ion_reporter_id" with code "200"
    Then each returned ion_reporter field "study_id" should be "APEC1621SC"

  @ion_reporter_new_p1
  Scenario: ION_IR61. ion_reporter service can list all ion_reporters that meet query parameters(special characters?)
    Given ion_reporter_id is ""
    Then add field: "date_ion_reporter_id_created" value: "2016-10-12 21:19:37.073738" to url
    Then field: "ion_reporter_id" for this ion_reporter should be: "IR_ONO31"

  @ion_reporter_new_p1
  Scenario: ION_IR62. ion_reporter service can return single ion_reporter with specified ion_reporter_id
    Given ion_reporter_id is "IR_PU4NI"
    Then field: "site" for this ion_reporter should be: "mocha"

  @ion_reporter_new_p2
  Scenario Outline: ION_IR63. ion_reporter service should only return VALID projected key-value pair
    Given ion_reporter_id is "<ion_id>"
    Then add projection: "<field1>" to url
    Then add projection: "<field2>" to url
    Then add projection: "bad_projection" to url
    When GET from ion_reporters service, response includes "" with code "200"
    Then each returned ion_reporter should have 2 fields
    Then each returned ion_reporter should have field "<field1>"
    Then each returned ion_reporter should have field "<field2>"
    Examples:
      | ion_id   | field1                       | field2          |
      | IR_NX0TL | host_name                    | ion_reporter_id |
      |          | date_ion_reporter_id_created | site            |

  @ion_reporter_new_p2
  Scenario: ION_IR65. ion_reporter service should return 404 error if query a non-existing ion_reporter_id
    Given ion_reporter_id is ""
    Then add field: "site" value: "non_existing_site" to url
    When GET from ion_reporters service, response includes "" with code "200"
    Then there are|is 0 ion_reporter returned

  @ion_reporter_new_p1
  Scenario Outline: ION_IR66. ion_reporter/healthcheck service can return correct values
    Given site is "<site>"
    When GET from ion_reporters service, response includes "" with code "200"
    Then record all ion_reporters which has field "last_contact"
    Then ion_repoters healthcheck service result should match the recorded list
    Examples:
      | site  |
      | mocha |
      | mda   |

#  @ion_reporter_adult_match
#  Scenario: ION_IR67. ion_reporter service can list all adult match ion_reports
#    Given ion_reporter_id is ""
#    And study_id is "EAY131"
#    When GET from adult MATCH ion_reporters service, response includes "ion_reporter_id" with code "200"
#    Then each returned ion_reporter field "study_id" should be "EAY131"

#  @ion_reporter_new_p1
#  Scenario: ION_IR80. ion_reporter service can list all patients on specified ion_reporter

  #this service is removed
#  @ion_reporter_new_p1
#  Scenario: ION_IR81. ion_reporter service can list all sample controls on specified ion_reporter
#    Given ion_reporter_id is "IR_0HV52"
#    When GET sample_controls from ion_reporters service, response includes "" with code "200"
#    Then there are|is 3 sample_control returned
#    Then returned sample_control should contain molecular_id: "SC_JFCEO"
#    Then returned sample_control should contain molecular_id: "SC_CN8ZS"
#    Then returned sample_control should contain molecular_id: "SC_C777Z"
#
##  Scenario: ION_IR82. ion_reporter service should fail if projection is used when query patients
#
#  @ion_reporter_new_p2
#  Scenario: ION_IR83. ion_reporter service should only return VALID projected key-value pair when query sample controls
#    Given ion_reporter_id is "IR_0R0WO"
#    Then add projection: "molecular_id" to url
#    Then add projection: "control_type" to url
#    Then add projection: "bad_projection" to url
#    When GET sample_controls from ion_reporters service, response includes "" with code "200"
#    Then each returned sample_control should have 2 fields
#    Then each returned sample_control should have field "molecular_id"
#    Then each returned sample_control should have field "control_type"
#
#  @ion_reporter_new_p3
#  Scenario: ION_IR84. ion_reporter service should fail(or just not return this field?) if no sample control meet the parameter
#    Given ion_reporter_id is "IR_TCWEV"
#    Then add field: "molecular_id" value: "non_existing_moi" to url
#    When GET sample_controls from ion_reporters service, response includes "No records" with code "404"









