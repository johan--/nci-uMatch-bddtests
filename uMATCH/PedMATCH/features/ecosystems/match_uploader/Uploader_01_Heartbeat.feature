@uploader
Feature: Match Uploader heartbeat service tests

  Scenario Outline: UP_HB01. Heartbeat can update ion reporter status in both ped match and adult match
#    Given set match uploader config field "ion_reporter_id" to "<ion_id>"
#    And set match uploader config field "site" to "<site>"
#    And set match uploader config field "ion_reporter_version" to "<ion_version>"
    Then run uploader heartbeat service
#    When GET ion_reporter "<ion_id>" healthcheck from pedmatch should response code "200"
#    Then returned ion_reporter healthcheck ir_status should be within 10 seconds
#    And returned ion_reporter healthcheck last_contact should be within 10 seconds
#    And returned ion_reporter healthcheck host_name should be correct
#    And returned ion_reporter healthcheck internal_ip_address should be correct
#    And returned ion_reporter healthcheck field "ion_reporter_id" should be "<ion_id>"
#    And returned ion_reporter healthcheck field "site" should be "<site>"
#    And returned ion_reporter healthcheck field "ion_reporter_version" should be "<ion_version>"
#    When GET ion_reporter "<ion_id>" healthcheck from adult match should response code "200"
#    Then returned ion_reporter healthcheck ir_status should be within 10 seconds
#    And returned ion_reporter healthcheck last_contact should be within 10 seconds
#    And returned ion_reporter healthcheck host_name should be correct
#    And returned ion_reporter healthcheck internal_ip_address should be correct
#    And returned ion_reporter healthcheck field "ion_reporter_id" should be "<ion_id>"
#    And returned ion_reporter healthcheck field "site" should be "<site>"
#    And returned ion_reporter healthcheck field "ion_reporter_version" should be "<ion_version>"
    Examples:
      | ion_id   | site      | ion_version |
      | IR_MDA00 | mda       | 5.0         |
      | IR_MCA00 | mocha     | 5.2         |
      | IR_DTM00 | dartmouth | 5.0         |

#  Scenario Outline: UP_HB02. Heartbeat can update ion reporter which is only used by ped match
#    Then set match uploader config field "ion_reporter_id" to "<ion_id>"
#    And set match uploader config field "site" to "<site>"
#    And set match uploader config field "ion_reporter_version" to "<ion_version>"
#    Then run uploader heartbeat service
#    When GET ion_reporter "<ion_id>" healthcheck from pedmatch should response code "200"
#    Then returned ion_reporter healthcheck ir_status should be within 10 seconds
#    And returned ion_reporter healthcheck last_contact should be within 10 seconds
#    And returned ion_reporter healthcheck host_name should be correct
#    And returned ion_reporter healthcheck internal_ip_address should be correct
#    And returned ion_reporter healthcheck field "ion_reporter_id" should be "<ion_id>"
#    And returned ion_reporter healthcheck field "site" should be "<site>"
#    And returned ion_reporter healthcheck field "ion_reporter_version" should be "<ion_version>"
#    When GET ion_reporter "<ion_id>" healthcheck from adult match should response code "404"
#    Examples:
#      | ion_id   | site      | ion_version |
#      | IR_MDA01 | mda       | 5.0         |
#      | IR_MCA01 | mocha     | 5.2         |
#      | IR_DTM01 | dartmouth | 5.0         |

#  Scenario Outline: UP_HB02. Heartbeat can update ion reporter which is only used by adult match
#    Then set match uploader config field "ion_reporter_id" to "<ion_id>"
#    And set match uploader config field "site" to "<site>"
#    And set match uploader config field "ion_reporter_version" to "<ion_version>"
#    Then run uploader heartbeat service
#    When GET ion_reporter "<ion_id>" healthcheck from adult match should response code "200"
#    Then returned ion_reporter healthcheck ir_status should be within 10 seconds
#    And returned ion_reporter healthcheck last_contact should be within 10 seconds
#    And returned ion_reporter healthcheck host_name should be correct
#    And returned ion_reporter healthcheck internal_ip_address should be correct
#    And returned ion_reporter healthcheck field "ion_reporter_id" should be "<ion_id>"
#    And returned ion_reporter healthcheck field "site" should be "<site>"
#    And returned ion_reporter healthcheck field "ion_reporter_version" should be "<ion_version>"
#    When GET ion_reporter "<ion_id>" healthcheck from pedmatch should response code "404"
#    Examples:
#      | ion_id   | site      | ion_version |
#      | IR_YAL01 | yale       | 5.0         |
#      | IR_BSN01 | boston     | 5.2         |
