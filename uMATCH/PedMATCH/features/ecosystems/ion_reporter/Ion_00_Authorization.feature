@ion_auth
Feature: ir ecosystem authorization tests

  @ion_reporter_new_p1
  Scenario Outline: ION_AU01 role base authorization works properly to create ion_reporter
    Given site is "mda"
    And ir user authorization role is "<auth_role>"
    When POST to ion_reporters service 1 times, response includes "<message>" with code "<code>"
    Given site is "mocha"
    When POST to ion_reporters service 1 times, response includes "<message>" with code "<code>"
    Given site is "dartmouth"
    When POST to ion_reporters service 1 times, response includes "<message>" with code "<code>"
    Examples:
      | auth_role                         | message | code |
      | NO_TOKEN                          |         | 401  |
      | NCI_MATCH_READONLY                |         | 401  |
      | NO_ROLE                           |         | 401  |
      | ADMIN                             | created | 200  |
      | SYSTEM                            | created | 200  |
      | ASSIGNMENT_REPORT_REVIEWER        |         | 401  |
      | MDA_VARIANT_REPORT_SENDER         |         | 401  |
      | MDA_VARIANT_REPORT_REVIEWER       |         | 401  |
      | MOCHA_VARIANT_REPORT_SENDER       |         | 401  |
      | MOCHA_VARIANT_REPORT_REVIEWER     |         | 401  |
      | DARTMOUTH_VARIANT_REPORT_SENDER   |         | 401  |
      | DARTMOUTH_VARIANT_REPORT_REVIEWER |         | 401  |
      | PATIENT_MESSAGE_SENDER            |         | 401  |
      | SPECIMEN_MESSAGE_SENDER           |         | 401  |
      | ASSAY_MESSAGE_SENDER              |         | 401  |

  @ion_reporter_new_p2
  Scenario Outline: ION_AU02 role base authorization works properly to list ion_reporter
    Given ion_reporter_id is ""
    And ir user authorization role is "<auth_role>"
    When GET from ion_reporters service, response includes "<message>" with code "<code>"
    Examples:
      | auth_role                         | message         | code |
      | NO_TOKEN                          |                 | 401  |
      | NCI_MATCH_READONLY                | ion_reporter_id | 200  |
      | NO_ROLE                           |                 | 401  |
      | ADMIN                             | ion_reporter_id | 200  |
      | SYSTEM                            | ion_reporter_id | 200  |
      | ASSIGNMENT_REPORT_REVIEWER        | ion_reporter_id | 200  |
      | MDA_VARIANT_REPORT_SENDER         | ion_reporter_id | 200  |
      | MDA_VARIANT_REPORT_REVIEWER       | ion_reporter_id | 200  |
      | MOCHA_VARIANT_REPORT_SENDER       | ion_reporter_id | 200  |
      | MOCHA_VARIANT_REPORT_REVIEWER     | ion_reporter_id | 200  |
      | DARTMOUTH_VARIANT_REPORT_SENDER   | ion_reporter_id | 200  |
      | DARTMOUTH_VARIANT_REPORT_REVIEWER | ion_reporter_id | 200  |
      | PATIENT_MESSAGE_SENDER            | ion_reporter_id | 200  |
      | SPECIMEN_MESSAGE_SENDER           | ion_reporter_id | 200  |
      | ASSAY_MESSAGE_SENDER              | ion_reporter_id | 200  |

  @ion_reporter_new_p1
  Scenario Outline: ION_AU03 role base authorization works properly to update ion_reporter
    Given ion_reporter_id is "IR_MDA01"
    Then add field: "last_contact" value: "2017-02-02 09:08:23.446499" to message body
    Then add field: "site" value: "mda" to message body
    And ir user authorization role is "<auth_role>"
    When PUT to ion_reporters service, response includes "<mda_msg>" with code "<mda_code>"
    Given ion_reporter_id is "IR_MCA01"
    Then add field: "site" value: "mocha" to message body
    Then add field: "last_contact" value: "2017-02-02 09:08:23.446499" to message body
    When PUT to ion_reporters service, response includes "<mocha_msg>" with code "<mocha_code>"
    Given ion_reporter_id is "IR_DTM01"
    Then add field: "site" value: "dartmouth" to message body
    Then add field: "last_contact" value: "2017-02-02 09:08:23.446499" to message body
    When PUT to ion_reporters service, response includes "<dartmouth_msg>" with code "<dartmouth_code>"
    Examples:
      | auth_role                         | mda_msg | mda_code | mocha_msg | mocha_code | dartmouth_msg | dartmouth_code |
      | NO_TOKEN                          |         | 401      |           | 401        |               | 401            |
      | NCI_MATCH_READONLY                |         | 401      |           | 401        |               | 401            |
      | NO_ROLE                           |         | 401      |           | 401        |               | 401            |
      | ADMIN                             | updated | 200      | updated   | 200        | updated       | 200            |
      | SYSTEM                            | updated | 200      | updated   | 200        | updated       | 200            |
      | ASSIGNMENT_REPORT_REVIEWER        |         | 401      |           | 401        |               | 401            |
      | MDA_VARIANT_REPORT_SENDER         |         | 401      |           | 401        |               | 401            |
      | MDA_VARIANT_REPORT_REVIEWER       |         | 401      |           | 401        |               | 401            |
      | MOCHA_VARIANT_REPORT_SENDER       |         | 401      |           | 401        |               | 401            |
      | MOCHA_VARIANT_REPORT_REVIEWER     |         | 401      |           | 401        |               | 401            |
      | DARTMOUTH_VARIANT_REPORT_SENDER   |         | 401      |           | 401        |               | 401            |
      | DARTMOUTH_VARIANT_REPORT_REVIEWER |         | 401      |           | 401        |               | 401            |
      | PATIENT_MESSAGE_SENDER            |         | 401      |           | 401        |               | 401            |
      | SPECIMEN_MESSAGE_SENDER           |         | 401      |           | 401        |               | 401            |
      | ASSAY_MESSAGE_SENDER              |         | 401      |           | 401        |               | 401            |

  @ion_reporter_new_p1
  Scenario Outline: ION_AU04 role base authorization works properly to delete ion_reporter
    Given ion_reporter_id is "<mda_id>"
    And ir user authorization role is "<auth_role>"
    When DELETE to ion_reporters service, response includes "<mda_msg>" with code "<mda_code>"
    Given ion_reporter_id is "<mocha_id>"
    When DELETE to ion_reporters service, response includes "<mocha_msg>" with code "<mocha_code>"
    Given ion_reporter_id is "<dartmouth_id>"
    When DELETE to ion_reporters service, response includes "<dartmouth_msg>" with code "<dartmouth_code>"
    Examples:
      | auth_role                     | mda_id   | mda_msg | mda_code | mocha_id | mocha_msg | mocha_code | dartmouth_id | dartmouth_msg | dartmouth_code |
      | NO_TOKEN                      | IR_MDA00 |         | 401      | IR_MCA00 |           | 401        | IR_DTM00     |               | 401            |
      | NCI_MATCH_READONLY            | IR_MDA00 |         | 401      | IR_MCA00 |           | 401        | IR_DTM00     |               | 401            |
      | NO_ROLE                       | IR_MDA00 |         | 401      | IR_MCA00 |           | 401        | IR_DTM00     |               | 401            |
      | ADMIN                         | IR_MDA02 | deleted | 200      | IR_MCA02 | deleted   | 200        | IR_DTM02     | deleted       | 200            |
      | SYSTEM                        | IR_MDA00 |         | 401      | IR_MCA00 |           | 401        | IR_DTM00     |               | 401            |
      | ASSIGNMENT_REPORT_REVIEWER    | IR_MDA00 |         | 401      | IR_MCA00 |           | 401        | IR_DTM00     |               | 401            |
      | MDA_VARIANT_REPORT_SENDER     | IR_MDA00 |         | 401      | IR_MCA00 |           | 401        | IR_DTM00     |               | 401            |
      | MDA_VARIANT_REPORT_REVIEWER   | IR_MDA00 |         | 401      | IR_MCA00 |           | 401        | IR_DTM00     |               | 401            |
      | MOCHA_VARIANT_REPORT_SENDER   | IR_MDA00 |         | 401      | IR_MCA00 |           | 401        | IR_DTM00     |               | 401            |
      | MOCHA_VARIANT_REPORT_REVIEWER | IR_MDA00 |         | 401      | IR_MCA00 |           | 401        | IR_DTM00     |               | 401            |
      | PATIENT_MESSAGE_SENDER        | IR_MDA00 |         | 401      | IR_MCA00 |           | 401        | IR_DTM00     |               | 401            |
      | SPECIMEN_MESSAGE_SENDER       | IR_MDA00 |         | 401      | IR_MCA00 |           | 401        | IR_DTM00     |               | 401            |
      | ASSAY_MESSAGE_SENDER          | IR_MDA00 |         | 401      | IR_MCA00 |           | 401        | IR_DTM00     |               | 401            |

  @ion_reporter_new_p1
  Scenario Outline: ION_AU05 role base authorization works properly to create sample_control
    Given site is "mda"
    Given control_type is "proficiency_competency"
    And molecular id is ""
    And ir user authorization role is "<auth_role>"
    When POST to sample_controls service, response includes "<mda_msg>" with code "<mda_code>"
    Given site is "mocha"
    Given control_type is "no_template"
    And molecular id is ""
    When POST to sample_controls service, response includes "<mocha_msg>" with code "<mocha_code>"
    Given site is "dartmouth"
    Given control_type is "positive"
    And molecular id is ""
    When POST to sample_controls service, response includes "<dartmouth_msg>" with code "<dartmouth_code>"
    Examples:
      | auth_role                         | mda_msg | mda_code | mocha_msg | mocha_code | dartmouth_msg | dartmouth_code |
      | NO_TOKEN                          |         | 401      |           | 401        |               | 401            |
      | NCI_MATCH_READONLY                |         | 401      |           | 401        |               | 401            |
      | NO_ROLE                           |         | 401      |           | 401        |               | 401            |
      | ADMIN                             | created | 200      | created   | 200        | created       | 200            |
      | SYSTEM                            |         | 401      |           | 401        |               | 401            |
      | ASSIGNMENT_REPORT_REVIEWER        |         | 401      |           | 401        |               | 401            |
      | MDA_VARIANT_REPORT_SENDER         | created | 200      |           | 401        |               | 401            |
      | MDA_VARIANT_REPORT_REVIEWER       |         | 401      |           | 401        |               | 401            |
      | MOCHA_VARIANT_REPORT_SENDER       |         | 401      | created   | 200        |               | 401            |
      | MOCHA_VARIANT_REPORT_REVIEWER     |         | 401      |           | 401        |               | 401            |
      | DARTMOUTH_VARIANT_REPORT_SENDER   |         | 401      |           | 401        | created       | 200            |
      | DARTMOUTH_VARIANT_REPORT_REVIEWER |         | 401      |           | 401        |               | 401            |
      | PATIENT_MESSAGE_SENDER            |         | 401      |           | 401        |               | 401            |
      | SPECIMEN_MESSAGE_SENDER           |         | 401      |           | 401        |               | 401            |
      | ASSAY_MESSAGE_SENDER              |         | 401      |           | 401        |               | 401            |

  @ion_reporter_new_p2
  Scenario Outline: ION_AU05b MDA_VARIANT_REPORT_SENDER should be able create proficiency_competency sample control for mocha and dartmouth
    Given site is "<site>"
    Given control_type is "<control_type>"
    And molecular id is ""
    And ir user authorization role is "MDA_VARIANT_REPORT_SENDER"
    When POST to sample_controls service, response includes "<message>" with code "<code>"
    Examples:
      | site      | control_type           | message | code |
      | mocha     | proficiency_competency | created | 200  |
      | dartmouth | proficiency_competency | created | 200  |
      | mocha     | no_template            |         | 401  |
      | dartmouth | no_template            |         | 401  |
      | mocha     | positive               |         | 401  |
      | dartmouth | positive               |         | 401  |

  @ion_reporter_new_p2
  Scenario Outline: ION_AU06 role base authorization works properly to list sample_control
    Given molecular id is ""
    And add field: "site" value: "mda" to url
    And ir user authorization role is "<auth_role>"
    When GET from sample_controls service, response includes "<message>" with code "<code>"
    Then if sample_control list returned, it should have editable: "<mda_editable>"
    Then molecular id is ""
    And add field: "site" value: "mocha" to url
    And ir user authorization role is "<auth_role>"
    When GET from sample_controls service, response includes "<message>" with code "<code>"
    Then if sample_control list returned, it should have editable: "<mocha_editable>"
    Then molecular id is ""
    And add field: "site" value: "dartmouth" to url
    And ir user authorization role is "<auth_role>"
    When GET from sample_controls service, response includes "<message>" with code "<code>"
    Then if sample_control list returned, it should have editable: "<dartmouth_editable>"
    Examples:
      | auth_role                         | message      | code | mda_editable | mocha_editable | dartmouth_editable |
      | NO_TOKEN                          |              | 401  |              |                |                    |
      | NCI_MATCH_READONLY                | control_type | 200  | false        | false          | false              |
      | NO_ROLE                           |              | 401  |              |                |                    |
      | ADMIN                             | control_type | 200  | true         | true           | true               |
      | SYSTEM                            | control_type | 200  | false        | false          | false              |
      | ASSIGNMENT_REPORT_REVIEWER        | control_type | 200  | false        | false          | false              |
      | MDA_VARIANT_REPORT_SENDER         | control_type | 200  | true         | false          | false              |
      | MDA_VARIANT_REPORT_REVIEWER       | control_type | 200  | false        | false          | false              |
      | MOCHA_VARIANT_REPORT_SENDER       | control_type | 200  | false        | true           | false              |
      | MOCHA_VARIANT_REPORT_REVIEWER     | control_type | 200  | false        | false          | false              |
      | DARTMOUTH_VARIANT_REPORT_SENDER   | control_type | 200  | false        | false          | true               |
      | DARTMOUTH_VARIANT_REPORT_REVIEWER | control_type | 200  | false        | false          | false              |
      | PATIENT_MESSAGE_SENDER            | control_type | 200  | false        | false          | false              |
      | SPECIMEN_MESSAGE_SENDER           | control_type | 200  | false        | false          | false              |
      | ASSAY_MESSAGE_SENDER              | control_type | 200  | false        | false          | false              |

  @ion_reporter_new_p2
  Scenario Outline: ION_AU06b MDA_VARIANT_REPORT_SENDER should be able edit proficiency_competency sample control for mocha and dartmouth
    Given molecular id is ""
    And add field: "site" value: "<site>" to url
    And add field: "control_type" value: "<control_type>" to url
    And ir user authorization role is "MDA_VARIANT_REPORT_SENDER"
    When GET from sample_controls service, response includes "control_type" with code "200"
    Then if sample_control list returned, it should have editable: "<editable>"
    Examples:
      | site      | control_type           | editable |
      | mocha     | proficiency_competency |true      |
      | dartmouth | proficiency_competency |true      |
      | mocha     | no_template            |false     |
      | dartmouth | no_template            |false     |
      | mocha     | positive               |false     |
      | dartmouth | positive               |false     |

  @ion_reporter_new_p1
  Scenario Outline: ION_AU07 role base authorization works properly to update sample_control
    Given molecular id is "NTC_MDA_MDA01"
    Then add field: "qc_name" value: "IR_1H9XW/NTC_MDA_MDA01/SC_MDA01_ANI1/test.pdf" to message body
    Then add field: "site" value: "mda" to message body
    And ir user authorization role is "<auth_role>"
    When PUT to sample_controls service, response includes "<mda_msg>" with code "<mda_code>"
    Given molecular id is "NTC_MOCHA_MCA01"
    Then add field: "qc_name" value: "IR_1H9XW/NTC_MOCHA_MCA01/SC_MCA01_ANI1/test.pdf" to message body
    Then add field: "site" value: "mocha" to message body
    When PUT to sample_controls service, response includes "<mocha_msg>" with code "<mocha_code>"
    Given molecular id is "NTC_DARTMOUTH_DTM01"
    Then add field: "qc_name" value: "IR_1H9XW/NTC_DARTMOUTH_DTM01/SC_DTM01_ANI1/test.pdf" to message body
    Then add field: "site" value: "dartmouth" to message body
    When PUT to sample_controls service, response includes "<dartmouth_msg>" with code "<dartmouth_code>"
    Examples:
      | auth_role                         | mda_msg | mda_code | mocha_msg | mocha_code | dartmouth_msg | dartmouth_code |
      | NO_TOKEN                          |         | 401      |           | 401        |               | 401            |
      | NCI_MATCH_READONLY                |         | 401      |           | 401        |               | 401            |
      | NO_ROLE                           |         | 401      |           | 401        |               | 401            |
      | ADMIN                             | updated | 200      | updated   | 200        | updated       | 200            |
      | SYSTEM                            |         | 401      |           | 401        |               | 401            |
      | ASSIGNMENT_REPORT_REVIEWER        |         | 401      |           | 401        |               | 401            |
      | MDA_VARIANT_REPORT_SENDER         |         | 401      |           | 401        |               | 401            |
      | MDA_VARIANT_REPORT_REVIEWER       |         | 401      |           | 401        |               | 401            |
      | MOCHA_VARIANT_REPORT_SENDER       |         | 401      |           | 401        |               | 401            |
      | MOCHA_VARIANT_REPORT_REVIEWER     |         | 401      |           | 401        |               | 401            |
      | DARTMOUTH_VARIANT_REPORT_SENDER   |         | 401      |           | 401        |               | 401            |
      | DARTMOUTH_VARIANT_REPORT_REVIEWER |         | 401      |           | 401        |               | 401            |
      | PATIENT_MESSAGE_SENDER            |         | 401      |           | 401        |               | 401            |
      | SPECIMEN_MESSAGE_SENDER           |         | 401      |           | 401        |               | 401            |
      | ASSAY_MESSAGE_SENDER              |         | 401      |           | 401        |               | 401            |

  @ion_reporter_new_p1
  Scenario Outline: ION_AU08 role base authorization works properly to delete sample_control
    Given molecular id is "<mda_moi>"
    And ir user authorization role is "<auth_role>"
    When DELETE to sample_controls service, response includes "<mda_msg>" with code "<mda_code>"
    Given molecular id is "<mocha_moi>"
    When DELETE to sample_controls service, response includes "<mocha_msg>" with code "<mocha_code>"
    Given molecular id is "<dartmouth_moi>"
    When DELETE to sample_controls service, response includes "<dartmouth_msg>" with code "<dartmouth_code>"
    Examples:
      | auth_role                         | mda_moi       | mda_msg | mda_code | mocha_moi       | mocha_msg | mocha_code | dartmouth_moi       | dartmouth_msg | dartmouth_code |
      | NO_TOKEN                          | NTC_MDA_MDA00 |         | 401      | NTC_MOCHA_MCA00 |           | 401        | NTC_DARTMOUTH_DTM00 |               | 401            |
      | NCI_MATCH_READONLY                | NTC_MDA_MDA00 |         | 401      | NTC_MOCHA_MCA00 |           | 401        | NTC_DARTMOUTH_DTM00 |               | 401            |
      | NO_ROLE                           | NTC_MDA_MDA00 |         | 401      | NTC_MOCHA_MCA00 |           | 401        | NTC_DARTMOUTH_DTM00 |               | 401            |
      | ADMIN                             | NTC_MDA_MDA02 | deleted | 200      | NTC_MOCHA_MCA02 | deleted   | 200        | NTC_DARTMOUTH_DTM02 | deleted       | 200            |
      | SYSTEM                            | NTC_MDA_MDA00 |         | 401      | NTC_MOCHA_MCA00 |           | 401        | NTC_DARTMOUTH_DTM00 |               | 401            |
      | ASSIGNMENT_REPORT_REVIEWER        | NTC_MDA_MDA00 |         | 401      | NTC_MOCHA_MCA00 |           | 401        | NTC_DARTMOUTH_DTM00 |               | 401            |
      | MDA_VARIANT_REPORT_SENDER         | NTC_MDA_MDA00 |         | 401      | NTC_MOCHA_MCA00 |           | 401        | NTC_DARTMOUTH_DTM00 |               | 401            |
      | MDA_VARIANT_REPORT_REVIEWER       | NTC_MDA_MDA00 |         | 401      | NTC_MOCHA_MCA00 |           | 401        | NTC_DARTMOUTH_DTM00 |               | 401            |
      | MOCHA_VARIANT_REPORT_SENDER       | NTC_MDA_MDA00 |         | 401      | NTC_MOCHA_MCA00 |           | 401        | NTC_DARTMOUTH_DTM00 |               | 401            |
      | MOCHA_VARIANT_REPORT_REVIEWER     | NTC_MDA_MDA00 |         | 401      | NTC_MOCHA_MCA00 |           | 401        | NTC_DARTMOUTH_DTM00 |               | 401            |
      | DARTMOUTH_VARIANT_REPORT_SENDER   | NTC_MDA_MDA00 |         | 401      | NTC_MOCHA_MCA00 |           | 401        | NTC_DARTMOUTH_DTM00 |               | 401            |
      | DARTMOUTH_VARIANT_REPORT_REVIEWER | NTC_MDA_MDA00 |         | 401      | NTC_MOCHA_MCA00 |           | 401        | NTC_DARTMOUTH_DTM00 |               | 401            |
      | PATIENT_MESSAGE_SENDER            | NTC_MDA_MDA00 |         | 401      | NTC_MOCHA_MCA00 |           | 401        | NTC_DARTMOUTH_DTM00 |               | 401            |
      | SPECIMEN_MESSAGE_SENDER           | NTC_MDA_MDA00 |         | 401      | NTC_MOCHA_MCA00 |           | 401        | NTC_DARTMOUTH_DTM00 |               | 401            |
      | ASSAY_MESSAGE_SENDER              | NTC_MDA_MDA00 |         | 401      | NTC_MOCHA_MCA00 |           | 401        | NTC_DARTMOUTH_DTM00 |               | 401            |

  @ion_reporter_new_p2
  Scenario Outline: ION_AU09 role base authorization works properly to list aliquot
    Given molecular id is "NTC_MDA_3KSN8"
    And ir user authorization role is "<auth_role>"
    When GET from aliquot service, response "<message>" with code "<code>"
    Then if aliquot returned, it should have editable: "<mda_editable>"
    Then molecular id is "NTC_MOCHA_SA1CB"
    And ir user authorization role is "<auth_role>"
    When GET from aliquot service, response "<message>" with code "<code>"
    Then if aliquot returned, it should have editable: "<mocha_editable>"
    Then molecular id is "SC_DARTMOUTH_C8VQ0"
    And ir user authorization role is "<auth_role>"
    When GET from aliquot service, response "<message>" with code "<code>"
    Then if aliquot returned, it should have editable: "<dartmouth_editable>"

    Examples:
      | auth_role                         | message      | code | mda_editable | mocha_editable | dartmouth_editable |
      | NO_TOKEN                          |              | 401  |              |                |                    |
      | NCI_MATCH_READONLY                | control_type | 200  | false        | false          | false              |
      | NO_ROLE                           |              | 401  |              |                |                    |
      | ADMIN                             | control_type | 200  | true         | true           | true               |
      | SYSTEM                            | control_type | 200  | false        | false          | false              |
      | ASSIGNMENT_REPORT_REVIEWER        | control_type | 200  | false        | false          | false              |
      | MDA_VARIANT_REPORT_SENDER         | control_type | 200  | false        | false          | false              |
      | MDA_VARIANT_REPORT_REVIEWER       | control_type | 200  | true         | false          | false              |
      | MOCHA_VARIANT_REPORT_SENDER       | control_type | 200  | false        | false          | false              |
      | MOCHA_VARIANT_REPORT_REVIEWER     | control_type | 200  | false        | true           | true               |
      | DARTMOUTH_VARIANT_REPORT_SENDER   | control_type | 200  | false        | false          | false              |
      | DARTMOUTH_VARIANT_REPORT_REVIEWER | control_type | 200  | false        | false          | true               |
      | PATIENT_MESSAGE_SENDER            | control_type | 200  | false        | false          | false              |
      | SPECIMEN_MESSAGE_SENDER           | control_type | 200  | false        | false          | false              |
      | ASSAY_MESSAGE_SENDER              | control_type | 200  | false        | false          | false              |

  @ion_reporter_new_p1
  Scenario Outline: ION_AU10 role base authorization works properly to update aliquot
    Given molecular id is "<mda_moi>"
    Then add field: "analysis_id" value: "<mda_moi>_ANI1" to message body
    Then add field: "site" value: "mda" to message body
    Then add field: "ion_reporter_id" value: "IR_TCWEV" to message body
    Then add field: "vcf_name" value: "test1.vcf" to message body
    Then add field: "dna_bam_name" value: "dna.bam" to message body
    Then add field: "cdna_bam_name" value: "cdna.bam" to message body
    And ir user authorization role is "<auth_role>"
    When PUT to aliquot service, response includes "<mda_msg>" with code "<mda_code>"
    Given molecular id is "<mocha_moi>"
    Then add field: "analysis_id" value: "<mocha_moi>_ANI1" to message body
    Then add field: "site" value: "mocha" to message body
    Then add field: "ion_reporter_id" value: "IR_TCWEV" to message body
    Then add field: "vcf_name" value: "test1.vcf" to message body
    Then add field: "dna_bam_name" value: "dna.bam" to message body
    Then add field: "cdna_bam_name" value: "cdna.bam" to message body
    And ir user authorization role is "<auth_role>"
    When PUT to aliquot service, response includes "<mocha_msg>" with code "<mocha_code>"
    Given molecular id is "<dartmouth_moi>"
    Then add field: "analysis_id" value: "<dartmouth_moi>_ANI1" to message body
    Then add field: "site" value: "dartmouth" to message body
    Then add field: "ion_reporter_id" value: "IR_TCWEV" to message body
    Then add field: "vcf_name" value: "test1.vcf" to message body
    Then add field: "dna_bam_name" value: "dna.bam" to message body
    Then add field: "cdna_bam_name" value: "cdna.bam" to message body
    And ir user authorization role is "<auth_role>"
    When PUT to aliquot service, response includes "<dartmouth_msg>" with code "<dartmouth_code>"
    Examples:
      | auth_role                         | mda_moi       | mda_msg      | mda_code | mocha_moi       | mocha_msg    | mocha_code | dartmouth_moi       | dartmouth_msg | dartmouth_code |
      | NO_TOKEN                          | NTC_MDA_MDA00 |              | 401      | NTC_MOCHA_MCA00 |              | 401        | NTC_DARTMOUTH_DTM00 |               | 401            |
      | NCI_MATCH_READONLY                | NTC_MDA_MDA00 |              | 401      | NTC_MOCHA_MCA00 |              | 401        | NTC_DARTMOUTH_DTM00 |               | 401            |
      | NO_ROLE                           | NTC_MDA_MDA00 |              | 401      | NTC_MOCHA_MCA00 |              | 401        | NTC_DARTMOUTH_DTM00 |               | 401            |
      | ADMIN                             | NTC_MDA_MDA06 | Item updated | 200      | NTC_MOCHA_MCA06 | Item updated | 200        | NTC_DARTMOUTH_DTM06 | Item updated  | 200            |
      | SYSTEM                            | NTC_MDA_MDA07 | Item updated | 200      | NTC_MOCHA_MCA07 | Item updated | 200        | NTC_DARTMOUTH_DTM07 | Item updated  | 200            |
      | ASSIGNMENT_REPORT_REVIEWER        | NTC_MDA_MDA00 |              | 401      | NTC_MOCHA_MCA00 |              | 401        | NTC_DARTMOUTH_DTM00 |               | 401            |
      | MDA_VARIANT_REPORT_SENDER         | NTC_MDA_MDA08 | Item updated | 200      | NTC_MOCHA_MCA00 |              | 401        | NTC_DARTMOUTH_DTM00 |               | 401            |
      | MDA_VARIANT_REPORT_REVIEWER       | NTC_MDA_MDA09 | Item updated | 200      | NTC_MOCHA_MCA00 |              | 401        | NTC_DARTMOUTH_DTM00 |               | 401            |
      | MOCHA_VARIANT_REPORT_SENDER       | NTC_MDA_MDA00 |              | 401      | NTC_MOCHA_MCA08 | Item updated | 200        | NTC_DARTMOUTH_DTM00 |               | 401            |
      | MOCHA_VARIANT_REPORT_REVIEWER     | NTC_MDA_MDA00 |              | 401      | NTC_MOCHA_MCA09 | Item updated | 200        | NTC_DARTMOUTH_DTM00 |               | 401            |
      | DARTMOUTH_VARIANT_REPORT_SENDER   | NTC_MDA_MDA00 |              | 401      | NTC_MOCHA_MCA00 |              | 401        | NTC_DARTMOUTH_DTM08 | Item updated  | 200            |
      | DARTMOUTH_VARIANT_REPORT_REVIEWER | NTC_MDA_MDA00 |              | 401      | NTC_MOCHA_MCA00 |              | 401        | NTC_DARTMOUTH_DTM09 | Item updated  | 200            |
      | PATIENT_MESSAGE_SENDER            | NTC_MDA_MDA00 |              | 401      | NTC_MOCHA_MCA00 |              | 401        | NTC_DARTMOUTH_DTM00 |               | 401            |
      | SPECIMEN_MESSAGE_SENDER           | NTC_MDA_MDA00 |              | 401      | NTC_MOCHA_MCA00 |              | 401        | NTC_DARTMOUTH_DTM00 |               | 401            |
      | ASSAY_MESSAGE_SENDER              | NTC_MDA_MDA00 |              | 401      | NTC_MOCHA_MCA00 |              | 401        | NTC_DARTMOUTH_DTM00 |               | 401            |

  @ion_reporter_new_p2
  Scenario Outline: ION_AU11 role base authorization works properly to list sequence_files
    Given molecular id is "NTC_MDA_NPID3"
    Given sequence file type: "<file_type>", nucleic acid type: "<nucleic_acid_type>"
    And ir user authorization role is "<auth_role>"
    When GET from sequence_files service, response includes "<message>" with code "<code>"
    Examples:
      | file_type | nucleic_acid_type | auth_role                         | message          | code |
      | bam       | dna               | NO_TOKEN                          |                  | 401  |
      | bam       | cdna              | NCI_MATCH_READONLY                |                  | 200  |
      | bai       | dna               | NO_ROLE                           |                  | 401  |
      | bai       | cdna              | ADMIN                             | s3.amazonaws.com | 200  |
      | tsv       |                   | SYSTEM                            | s3.amazonaws.com | 200  |
      | vcf       |                   | ASSIGNMENT_REPORT_REVIEWER        | s3.amazonaws.com | 200  |
      | bam       | dna               | MDA_VARIANT_REPORT_SENDER         | s3.amazonaws.com | 200  |
      | bam       | cdna              | MDA_VARIANT_REPORT_REVIEWER       | s3.amazonaws.com | 200  |
      | bai       | dna               | MOCHA_VARIANT_REPORT_SENDER       | s3.amazonaws.com | 200  |
      | bai       | cdna              | MOCHA_VARIANT_REPORT_REVIEWER     | s3.amazonaws.com | 200  |
      | bai       | dna               | DARTMOUTH_VARIANT_REPORT_SENDER   | s3.amazonaws.com | 200  |
      | bai       | cdna              | DARTMOUTH_VARIANT_REPORT_REVIEWER | s3.amazonaws.com | 200  |
      | tsv       |                   | PATIENT_MESSAGE_SENDER            | s3.amazonaws.com | 200  |
      | vcf       |                   | SPECIMEN_MESSAGE_SENDER           | s3.amazonaws.com | 200  |
      | bam       | dna               | ASSAY_MESSAGE_SENDER              | s3.amazonaws.com | 200  |

  @ion_reporter_new_p2
  Scenario Outline: ION_AU12 role base authorization works properly to list files
    Given molecular id is "NTC_MDA_J6RDR"
    Given file name for files service is: "qc_name"
    And ir user authorization role is "<auth_role>"
    When GET from files service, response includes "<message>" with code "<code>"
    Examples:
      | auth_role                         | message          | code |
      | NO_TOKEN                          |                  | 401  |
      | NCI_MATCH_READONLY                |                  | 200  |
      | NO_ROLE                           |                  | 401  |
      | ADMIN                             | s3.amazonaws.com | 200  |
      | SYSTEM                            | s3.amazonaws.com | 200  |
      | ASSIGNMENT_REPORT_REVIEWER        | s3.amazonaws.com | 200  |
      | MDA_VARIANT_REPORT_SENDER         | s3.amazonaws.com | 200  |
      | MDA_VARIANT_REPORT_REVIEWER       | s3.amazonaws.com | 200  |
      | MOCHA_VARIANT_REPORT_SENDER       | s3.amazonaws.com | 200  |
      | MOCHA_VARIANT_REPORT_REVIEWER     | s3.amazonaws.com | 200  |
      | DARTMOUTH_VARIANT_REPORT_SENDER   | s3.amazonaws.com | 200  |
      | DARTMOUTH_VARIANT_REPORT_REVIEWER | s3.amazonaws.com | 200  |
      | PATIENT_MESSAGE_SENDER            | s3.amazonaws.com | 200  |
      | SPECIMEN_MESSAGE_SENDER           | s3.amazonaws.com | 200  |
      | ASSAY_MESSAGE_SENDER              | s3.amazonaws.com | 200  |

