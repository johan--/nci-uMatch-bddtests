#encoding: utf-8
@patients_p1 @rules_p1 @demo_p1 @treatment_arm_p1
Feature: Make sure all services are running

  Scenario: GN_HC01. healthcheck for patient_api should work as expected
    When call healthcheck for application "patient_api", http code "200" should be returned
    Then following key-value pairs should be returned
      | dynamodb_connection | successful |
      | queue_connection    | successful |
      | s3_connection       | successful |

  Scenario: GN_HC02. healthcheck for patient_state should work as expected
    When call healthcheck for application "patient_state", http code "200" should be returned
    Then following key-value pairs should be returned
      | dynamodb_connection | successful |

  Scenario: GN_HC03. healthcheck for patient_processor should work as expected
    When call healthcheck for application "patient_processor", http code "200" should be returned
    Then following key-value pairs should be returned
      | dynamodb_connection | successful |
      | queue_connection    | successful |
      | cog_connection      | successful |

  Scenario: GN_HC04. healthcheck for treatment arm api should work as expected
    When call healthcheck for application "ta_api", http code "200" should be returned
    Then following key-value pairs should be returned
      | dynamodb_connection | successful |
      | queue_connection    | successful |
      | cog_connection      | successful |

  Scenario: GN_HC05. healthcheck for treatment arm processor should work as expected
    When call healthcheck for application "ta_processor", http code "200" should be returned
    Then following key-value pairs should be returned
      | dynamodb_connection | successful |
      | queue_connection    | successful |

  Scenario: GN_HC06. healthcheck for rules should work as expected
    When call healthcheck for application "rules", http code "200" should be returned
    Then following key-value pairs should be returned
      | awsConnection | Connected |

#  Scenario: GN_HC07. healthcheck for admin tool should work as expected
#    When call healthcheck for application "admin", http code "200" should be returned
#    Then following key-value pairs should be returned
#      | dynamodb_connection | successful |
#      | queue_connection    | successful |
#      | s3_connection       | successful |

#  Scenario: GN_HC08. healthcheck for aliquot should work as expected
#    When call healthcheck for application "aliquot", http code "200" should be returned
#    Then following key-value pairs should be returned
#      | dynamodb_connection | successful |
#      | queue_connection    | successful |
#      | s3_connection       | successful |
#
#  Scenario: GN_HC09. healthcheck for sample_controls should work as expected
#    When call healthcheck for application "sample_control", http code "200" should be returned
#    Then following key-value pairs should be returned
#      | dynamodb_connection | successful |
#      | queue_connection    | successful |
#      | s3_connection       | successful |
#
#  Scenario: GN_HC10. healthcheck for ion_reporters should work as expected
#    When call healthcheck for application "ion_reporter", http code "200" should be returned
#    Then following key-value pairs should be returned
#      | dynamodb_connection | successful |
#      | queue_connection    | successful |
#      | s3_connection       | successful |