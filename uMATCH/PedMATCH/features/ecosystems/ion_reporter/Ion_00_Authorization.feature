@ion_auth
Feature: ir ecosystem authorization tests

  @ion_reporter_p1
  Scenario Outline: ION_AU01 role base authorization works properly to create ion_reporter
    Given site is "mda"
    And ir user authorization role is "<auth_role>"
    When POST to ion_reporters service 1 times, response includes "<mda_message>" with code "<mda_code>"
    Given site is "mocha"
    When POST to ion_reporters service 1 times, response includes "<mocha_message>" with code "<mocha_code>"
    Examples:
      | auth_role                     | mda_message | mda_code | mocha_message | mocha_code |
      | NO_TOKEN                      |             | 401      |               | 401        |
      | NCI_MATCH_READONLY            |             | 401      |               | 401        |
      | NO_ROLE                       |             | 401      |               | 401        |
      | ADMIN                         | created     | 200      | created       | 200        |
      | SYSTEM                        | created     | 200      | created       | 200        |
      | ASSIGNMENT_REPORT_REVIEWER    |             | 401      |               | 401        |
      | MDA_VARIANT_REPORT_SENDER     | created     | 200      |               | 401        |
      | MDA_VARIANT_REPORT_REVIEWER   | created     | 200      |               | 401        |
      | MOCHA_VARIANT_REPORT_SENDER   |             | 401      | created       | 200        |
      | MOCHA_VARIANT_REPORT_REVIEWER |             | 401      | created       | 200        |
      | PATIENT_MESSAGE_SENDER        |             | 401      |               | 401        |
      | SPECIMEN_MESSAGE_SENDER       |             | 401      |               | 401        |
      | ASSAY_MESSAGE_SENDER          |             | 401      |               | 401        |

  Scenario Outline: ION_AU02 role base authorization works properly to list ion_reporter
    Given ion_reporter_id is ""
    And ir user authorization role is "<auth_role>"
    When GET from ion_reporters service, response includes "<message>" with code "<code>"
    Examples:
      | auth_role                     | message         | code |
      | NO_TOKEN                      |                 | 401  |
      | NCI_MATCH_READONLY            | ion_reporter_id | 200  |
      | NO_ROLE                       |                 | 401  |
      | ADMIN                         | ion_reporter_id | 200  |
      | SYSTEM                        | ion_reporter_id | 200  |
      | ASSIGNMENT_REPORT_REVIEWER    | ion_reporter_id | 200  |
      | MDA_VARIANT_REPORT_SENDER     | ion_reporter_id | 200  |
      | MDA_VARIANT_REPORT_REVIEWER   | ion_reporter_id | 200  |
      | MOCHA_VARIANT_REPORT_SENDER   | ion_reporter_id | 200  |
      | MOCHA_VARIANT_REPORT_REVIEWER | ion_reporter_id | 200  |
      | PATIENT_MESSAGE_SENDER        | ion_reporter_id | 200  |
      | SPECIMEN_MESSAGE_SENDER       | ion_reporter_id | 200  |
      | ASSAY_MESSAGE_SENDER          | ion_reporter_id | 200  |

  Scenario Outline: ION_AU03 role base authorization works properly to update ion_reporter
    Given ion_reporter_id is "IR_MDA01"
    Then add field: "last_contact" value: "January 03, 2017 10:35 PM" to message body
    And ir user authorization role is "<auth_role>"
    When PUT to ion_reporters service, response includes "<mda_message>" with code "<mda_code>"
    Given ion_reporter_id is "IR_MCA01"
    Then add field: "last_contact" value: "January 03, 2017 10:35 PM" to message body
    When PUT to ion_reporters service, response includes "<mocha_message>" with code "<mocha_code>"
    Examples:
      | auth_role                     | mda_message | mda_code | mocha_message | mocha_code |
      | NO_TOKEN                      |             | 401      |               | 401        |
      | NCI_MATCH_READONLY            |             | 401      |               | 401        |
      | NO_ROLE                       |             | 401      |               | 401        |
      | ADMIN                         | updated     | 200      | updated       | 200        |
      | SYSTEM                        | updated     | 200      | updated       | 200        |
      | ASSIGNMENT_REPORT_REVIEWER    |             | 401      |               | 401        |
      | MDA_VARIANT_REPORT_SENDER     | updated     | 200      |               | 401        |
      | MDA_VARIANT_REPORT_REVIEWER   | updated     | 200      |               | 401        |
      | MOCHA_VARIANT_REPORT_SENDER   |             | 401      | updated       | 200        |
      | MOCHA_VARIANT_REPORT_REVIEWER |             | 401      | updated       | 200        |
      | PATIENT_MESSAGE_SENDER        |             | 401      |               | 401        |
      | SPECIMEN_MESSAGE_SENDER       |             | 401      |               | 401        |
      | ASSAY_MESSAGE_SENDER          |             | 401      |               | 401        |

  Scenario Outline: ION_AU04 role base authorization works properly to delete ion_reporter
    Given ion_reporter_id is "<mda_id>"
    And ir user authorization role is "<auth_role>"
    When DELETE to ion_reporters service, response includes "<mda_message>" with code "<mda_code>"
    Given ion_reporter_id is "<mocha_id>"
    When DELETE to ion_reporters service, response includes "<mocha_message>" with code "<mocha_code>"
    Examples:
      | auth_role                     | mda_id   | mda_message | mda_code | mocha_id | mocha_message | mocha_code |
      | NO_TOKEN                      | IR_MDA00 |             | 401      | IR_MCA00 |               | 401        |
      | NCI_MATCH_READONLY            | IR_MDA00 |             | 401      | IR_MCA00 |               | 401        |
      | NO_ROLE                       | IR_MDA00 |             | 401      | IR_MCA00 |               | 401        |
      | ADMIN                         | IR_MDA02 | deleted     | 200      | IR_MCA02 | deleted       | 200        |
      | SYSTEM                        | IR_MDA03 | deleted     | 200      | IR_MCA03 | deleted       | 200        |
      | ASSIGNMENT_REPORT_REVIEWER    | IR_MDA00 |             | 401      | IR_MCA00 |               | 401        |
      | MDA_VARIANT_REPORT_SENDER     | IR_MDA04 | deleted     | 200      | IR_MCA00 |               | 401        |
      | MDA_VARIANT_REPORT_REVIEWER   | IR_MDA05 | deleted     | 200      | IR_MCA00 |               | 401        |
      | MOCHA_VARIANT_REPORT_SENDER   | IR_MDA00 |             | 401      | IR_MCA04 | deleted       | 200        |
      | MOCHA_VARIANT_REPORT_REVIEWER | IR_MDA00 |             | 401      | IR_MCA05 | deleted       | 200        |
      | PATIENT_MESSAGE_SENDER        | IR_MDA00 |             | 401      | IR_MCA00 |               | 401        |
      | SPECIMEN_MESSAGE_SENDER       | IR_MDA00 |             | 401      | IR_MCA00 |               | 401        |
      | ASSAY_MESSAGE_SENDER          | IR_MDA00 |             | 401      | IR_MCA00 |               | 401        |

  Scenario Outline: ION_AU05 role base authorization works properly to create sample_control
    Given site is "mda"
    Given control_type is "no_template"
    And ir user authorization role is "<auth_role>"
    When POST to sample_controls service, response includes "<mda_message>" with code "<mda_code>"
    Given site is "mocha"
    Given control_type is "positive"
    When POST to sample_controls service, response includes "<mocha_message>" with code "<mocha_code>"
    Examples:
      | auth_role                     | mda_message            | mda_code | mocha_message          | mocha_code |
      | NO_TOKEN                      |                        | 401      |                        | 401        |
      | NCI_MATCH_READONLY            |                        | 401      |                        | 401        |
      | NO_ROLE                       |                        | 401      |                        | 401        |
      | ADMIN                         | sample control created | 200      | sample control created | 200        |
      | SYSTEM                        | sample control created | 200      | sample control created | 200        |
      | ASSIGNMENT_REPORT_REVIEWER    |                        | 401      |                        | 401        |
      | MDA_VARIANT_REPORT_SENDER     | sample control created | 200      |                        | 401        |
      | MDA_VARIANT_REPORT_REVIEWER   | sample control created | 200      |                        | 401        |
      | MOCHA_VARIANT_REPORT_SENDER   |                        | 401      | sample control created | 200        |
      | MOCHA_VARIANT_REPORT_REVIEWER |                        | 401      | sample control created | 200        |
      | PATIENT_MESSAGE_SENDER        |                        | 401      |                        | 401        |
      | SPECIMEN_MESSAGE_SENDER       |                        | 401      |                        | 401        |
      | ASSAY_MESSAGE_SENDER          |                        | 401      |                        | 401        |


  Scenario Outline: ION_AU06 role base authorization works properly to list sample_control
    Given molecular id is ""
    And ir user authorization role is "<auth_role>"
    When GET from sample_controls service, response includes "<message>" with code "<code>"
    Examples:
      | auth_role                     | message      | code |
      | NO_TOKEN                      |              | 401  |
      | NCI_MATCH_READONLY            |              | 200  |
      | NO_ROLE                       |              | 401  |
      | ADMIN                         | control_type | 200  |
      | SYSTEM                        | control_type | 200  |
      | ASSIGNMENT_REPORT_REVIEWER    | control_type | 200  |
      | MDA_VARIANT_REPORT_SENDER     | control_type | 200  |
      | MDA_VARIANT_REPORT_REVIEWER   | control_type | 200  |
      | MOCHA_VARIANT_REPORT_SENDER   | control_type | 200  |
      | MOCHA_VARIANT_REPORT_REVIEWER | control_type | 200  |
      | PATIENT_MESSAGE_SENDER        | control_type | 200  |
      | SPECIMEN_MESSAGE_SENDER       | control_type | 200  |
      | ASSAY_MESSAGE_SENDER          | control_type | 200  |

  Scenario Outline: ION_AU07 role base authorization works properly to update sample_control
    Given molecular id is "SC_MDA01"
    Then add field: "qc_name" value: "IR_1H9XW/SC_MDA01/SC_MDA01_ANI1/test.pdf" to message body
    And ir user authorization role is "<auth_role>"
    When PUT to sample_controls service, response includes "<mda_message>" with code "<mda_code>"
    Given molecular id is "SC_MCA01"
    Then add field: "qc_name" value: "IR_1H9XW/SC_MCA01/SC_MCA01_ANI1/test.pdf" to message body
    When PUT to sample_controls service, response includes "<mocha_message>" with code "<mocha_code>"
    Examples:
      | auth_role                     | mda_message | mda_code | mocha_message | mocha_code |
      | NO_TOKEN                      |             | 401      |               | 401        |
      | NCI_MATCH_READONLY            |             | 401      |               | 401        |
      | NO_ROLE                       |             | 401      |               | 401        |
      | ADMIN                         | updated     | 200      | updated       | 200        |
      | SYSTEM                        | updated     | 200      | updated       | 200        |
      | ASSIGNMENT_REPORT_REVIEWER    |             | 401      |               | 401        |
      | MDA_VARIANT_REPORT_SENDER     | updated     | 200      |               | 401        |
      | MDA_VARIANT_REPORT_REVIEWER   | updated     | 200      |               | 401        |
      | MOCHA_VARIANT_REPORT_SENDER   |             | 401      | updated       | 200        |
      | MOCHA_VARIANT_REPORT_REVIEWER |             | 401      | updated       | 200        |
      | PATIENT_MESSAGE_SENDER        |             | 401      |               | 401        |
      | SPECIMEN_MESSAGE_SENDER       |             | 401      |               | 401        |
      | ASSAY_MESSAGE_SENDER          |             | 401      |               | 401        |

  Scenario Outline: ION_AU08 role base authorization works properly to delete sample_control
    Given molecular id is "<mda_moi>"
    And ir user authorization role is "<auth_role>"
    When DELETE to sample_controls service, response includes "<mda_message>" with code "<mda_code>"
    Given molecular id is "<mocha_moi>"
    When DELETE to sample_controls service, response includes "<mocha_message>" with code "<mocha_code>"
    Examples:
      | auth_role                     | mda_moi  | mda_message | mda_code | mocha_moi | mocha_message | mocha_code |
      | NO_TOKEN                      | SC_MDA00 |             | 401      | SC_MCA00  |               | 401        |
      | NCI_MATCH_READONLY            | SC_MDA00 |             | 401      | SC_MCA00  |               | 401        |
      | NO_ROLE                       | SC_MDA00 |             | 401      | SC_MCA00  |               | 401        |
      | ADMIN                         | SC_MDA02 | deleted     | 200      | SC_MCA02  | deleted       | 200        |
      | SYSTEM                        | SC_MDA03 | deleted     | 200      | SC_MCA03  | deleted       | 200        |
      | ASSIGNMENT_REPORT_REVIEWER    | SC_MDA00 |             | 401      | SC_MCA00  |               | 401        |
      | MDA_VARIANT_REPORT_SENDER     | SC_MDA04 | deleted     | 200      | SC_MCA00  |               | 401        |
      | MDA_VARIANT_REPORT_REVIEWER   | SC_MDA05 | deleted     | 200      | SC_MCA00  |               | 401        |
      | MOCHA_VARIANT_REPORT_SENDER   | SC_MDA00 |             | 401      | SC_MCA04  | deleted       | 200        |
      | MOCHA_VARIANT_REPORT_REVIEWER | SC_MDA00 |             | 401      | SC_MCA05  | deleted       | 200        |
      | PATIENT_MESSAGE_SENDER        | SC_MDA00 |             | 401      | SC_MCA00  |               | 401        |
      | SPECIMEN_MESSAGE_SENDER       | SC_MDA00 |             | 401      | SC_MCA00  |               | 401        |
      | ASSAY_MESSAGE_SENDER          | SC_MDA00 |             | 401      | SC_MCA00  |               | 401        |

  Scenario Outline: ION_AU09 role base authorization works properly to list aliquot
    Given molecular id is "SC_3KSN8"
    And ir user authorization role is "<auth_role>"
    When GET from aliquot service, response "<message>" with code "<code>"
    Examples:
      | auth_role                     | message      | code |
      | NO_TOKEN                      |              | 401  |
      | NCI_MATCH_READONLY            |              | 200  |
      | NO_ROLE                       |              | 401  |
      | ADMIN                         | control_type | 200  |
      | SYSTEM                        | control_type | 200  |
      | ASSIGNMENT_REPORT_REVIEWER    | control_type | 200  |
      | MDA_VARIANT_REPORT_SENDER     | control_type | 200  |
      | MDA_VARIANT_REPORT_REVIEWER   | control_type | 200  |
      | MOCHA_VARIANT_REPORT_SENDER   | control_type | 200  |
      | MOCHA_VARIANT_REPORT_REVIEWER | control_type | 200  |
      | PATIENT_MESSAGE_SENDER        | control_type | 200  |
      | SPECIMEN_MESSAGE_SENDER       | control_type | 200  |
      | ASSAY_MESSAGE_SENDER          | control_type | 200  |

  Scenario Outline: ION_AU10 role base authorization works properly to update aliquot
    Given molecular id is "<mda_moi>"
    Then add field: "analysis_id" value: "<mda_moi>_ANI1" to message body
    Then add field: "site" value: "mda" to message body
    Then add field: "ion_reporter_id" value: "IR_TCWEV" to message body
    Then add field: "vcf_name" value: "IR_TCWEV/<mda_moi>/<mda_moi>_ANI1/test1.vcf" to message body
    Then add field: "dna_bam_name" value: "IR_TCWEV/<mda_moi>/<mda_moi>_ANI1/dna.bam" to message body
    Then add field: "cdna_bam_name" value: "IR_TCWEV/<mda_moi>/<mda_moi>_ANI1/cdna.bam" to message body
    Then add field: "qc_name" value: "IR_TCWEV/<mda_moi>/<mda_moi>_ANI1/QA.pdf" to message body
    And ir user authorization role is "<auth_role>"
    When PUT to aliquot service, response includes "<mda_message>" with code "<mda_code>"
    Given molecular id is "<mocha_moi>"
    Then add field: "analysis_id" value: "<mocha_moi>_ANI1" to message body
    Then add field: "site" value: "mda" to message body
    Then add field: "ion_reporter_id" value: "IR_TCWEV" to message body
    Then add field: "vcf_name" value: "IR_TCWEV/<mocha_moi>/<mocha_moi>_ANI1/test1.vcf" to message body
    Then add field: "dna_bam_name" value: "IR_TCWEV/<mocha_moi>/<mocha_moi>_ANI1/dna.bam" to message body
    Then add field: "cdna_bam_name" value: "IR_TCWEV/<mocha_moi>/<mocha_moi>_ANI1/cdna.bam" to message body
    Then add field: "qc_name" value: "IR_TCWEV/<mocha_moi>/<mocha_moi>_ANI1/QA.pdf" to message body
    And ir user authorization role is "<auth_role>"
    When PUT to aliquot service, response includes "<mocha_message>" with code "<mocha_code>"
    Examples:
      | auth_role                     | mda_moi  | mda_message  | mda_code | mocha_moi | mocha_message | mocha_code |
      | NO_TOKEN                      | SC_MDA00 |              | 401      | SC_MCA00  |               | 401        |
      | NCI_MATCH_READONLY            | SC_MDA00 |              | 401      | SC_MCA00  |               | 401        |
      | NO_ROLE                       | SC_MDA00 |              | 401      | SC_MCA00  |               | 401        |
      | ADMIN                         | SC_MDA06 | Item updated | 200      | SC_MCA06  | Item updated  | 200        |
      | SYSTEM                        | SC_MDA07 | Item updated | 200      | SC_MCA07  | Item updated  | 200        |
      | ASSIGNMENT_REPORT_REVIEWER    | SC_MDA00 |              | 401      | SC_MCA00  |               | 401        |
      | MDA_VARIANT_REPORT_SENDER     | SC_MDA08 | Item updated | 200      | SC_MCA00  |               | 401        |
      | MDA_VARIANT_REPORT_REVIEWER   | SC_MDA09 | Item updated | 200      | SC_MCA00  |               | 401        |
      | MOCHA_VARIANT_REPORT_SENDER   | SC_MDA00 |              | 401      | SC_MCA08  | Item updated  | 200        |
      | MOCHA_VARIANT_REPORT_REVIEWER | SC_MDA00 |              | 401      | SC_MCA09  | Item updated  | 200        |
      | PATIENT_MESSAGE_SENDER        | SC_MDA00 |              | 401      | SC_MCA00  |               | 401        |
      | SPECIMEN_MESSAGE_SENDER       | SC_MDA00 |              | 401      | SC_MCA00  |               | 401        |
      | ASSAY_MESSAGE_SENDER          | SC_MDA00 |              | 401      | SC_MCA00  |               | 401        |

  Scenario Outline: ION_AU11 role base authorization works properly to list sequence_files
    Given molecular id is "SC_NPID3"
    Given sequence file type: "<file_type>", nucleic acid type: "<nucleic_acid_type>"
    And ir user authorization role is "<auth_role>"
    When GET from sequence_files service, response includes "<message>" with code "<code>"
    Examples:
      | file_type | nucleic_acid_type | auth_role                     | message          | code |
      | bam       | dna               | NO_TOKEN                      |                  | 401  |
      | bam       | cdna              | NCI_MATCH_READONLY            |                  | 200  |
      | bai       | dna               | NO_ROLE                       |                  | 401  |
      | bai       | cdna              | ADMIN                         | s3.amazonaws.com | 200  |
      | tsv       |                   | SYSTEM                        | s3.amazonaws.com | 200  |
      | vcf       |                   | ASSIGNMENT_REPORT_REVIEWER    | s3.amazonaws.com | 200  |
      | bam       | dna               | MDA_VARIANT_REPORT_SENDER     | s3.amazonaws.com | 200  |
      | bam       | cdna              | MDA_VARIANT_REPORT_REVIEWER   | s3.amazonaws.com | 200  |
      | bai       | dna               | MOCHA_VARIANT_REPORT_SENDER   | s3.amazonaws.com | 200  |
      | bai       | cdna              | MOCHA_VARIANT_REPORT_REVIEWER | s3.amazonaws.com | 200  |
      | tsv       |                   | PATIENT_MESSAGE_SENDER        | s3.amazonaws.com | 200  |
      | vcf       |                   | SPECIMEN_MESSAGE_SENDER       | s3.amazonaws.com | 200  |
      | bam       | dna               | ASSAY_MESSAGE_SENDER          | s3.amazonaws.com | 200  |

  Scenario Outline: ION_AU12 role base authorization works properly to list files
    Given molecular id is "SC_J6RDR"
    Given file name for files service is: "qc_name"
    And ir user authorization role is "<auth_role>"
    When GET from files service, response includes "<message>" with code "<code>"
    Examples:
      | auth_role                     | message          | code |
      | NO_TOKEN                      |                  | 401  |
      | NCI_MATCH_READONLY            |                  | 200  |
      | NO_ROLE                       |                  | 401  |
      | ADMIN                         | s3.amazonaws.com | 200  |
      | SYSTEM                        | s3.amazonaws.com | 200  |
      | ASSIGNMENT_REPORT_REVIEWER    | s3.amazonaws.com | 200  |
      | MDA_VARIANT_REPORT_SENDER     | s3.amazonaws.com | 200  |
      | MDA_VARIANT_REPORT_REVIEWER   | s3.amazonaws.com | 200  |
      | MOCHA_VARIANT_REPORT_SENDER   | s3.amazonaws.com | 200  |
      | MOCHA_VARIANT_REPORT_REVIEWER | s3.amazonaws.com | 200  |
      | PATIENT_MESSAGE_SENDER        | s3.amazonaws.com | 200  |
      | SPECIMEN_MESSAGE_SENDER       | s3.amazonaws.com | 200  |
      | ASSAY_MESSAGE_SENDER          | s3.amazonaws.com | 200  |