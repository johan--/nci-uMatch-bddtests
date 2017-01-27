#encoding: utf-8
@ion_reporter_sequence_files
Feature: Tests for sequence files service in ion ecosystem

  @ion_reporter_p1
  Scenario Outline: ION_SF01. sequence files service can return correct result for sample control molecular_id
    Given molecular id is "SC_NPID3"
    Given sequence file type: "<file_type>", nucleic acid type: "<nucleic_acid_type>"
    When GET from sequence_files service, response includes "<result>" with code "200"
    Examples:
      | file_type | nucleic_acid_type | result                                                     |
      | bam       | dna               | s3.amazonaws.com/IR_TCWEV/SC_NPID3/SC_NPID3_ANI1/dna.bam   |
      | bam       | cdna              | s3.amazonaws.com/IR_TCWEV/SC_NPID3/SC_NPID3_ANI1/cdna.bam  |
      | bai       | dna               | s3.amazonaws.com/IR_TCWEV/SC_NPID3/SC_NPID3_ANI1/dna.bai   |
      | bai       | cdna              | s3.amazonaws.com/IR_TCWEV/SC_NPID3/SC_NPID3_ANI1/cdna.bai  |
      | tsv       |                   | s3.amazonaws.com/IR_TCWEV/SC_NPID3/SC_NPID3_ANI1/test1.tsv |
      | vcf       |                   | s3.amazonaws.com/IR_TCWEV/SC_NPID3/SC_NPID3_ANI1/test1.vcf |

#  @ion_reporter_p2
#  Scenario: ION_SF02. returned file path should be reachable S3 path

  @ion_reporter_p2
  Scenario: ION_SF03. sequence files service should fail if a patient molecular_id is passed in
    Given molecular id is "PT_VC08_VRUploaded_MOI1"
    Given sequence file type: "tsv", nucleic acid type: ""
    When GET from sequence_files service, response includes "PT_VC08_VRUploaded_MOI1 was not found" with code "404"

  @ion_reporter_p2
  Scenario: ION_SF04. sequence files service should fail if an non-existing molecular_id is passed in
    Given molecular id is "SC_NON_EXISTING"
    Given sequence file type: "bam", nucleic acid type: "cdna"
    When GET from sequence_files service, response includes "SC_NON_EXISTING was not found" with code "404"

  @ion_reporter_p2
  Scenario Outline: ION_SF05. sequence files service should fail if an non-existing file_format or nucleic acid type is passed in
    Given molecular id is "SC_EUPC2"
    Given sequence file type: "<file_type>", nucleic acid type: "<nucleic_acid_type>"
    When GET from sequence_files service, response includes "<message>" with code "400"
    Examples:
      | file_type  | nucleic_acid_type  | message                              |
      | other_type | dna                | Only supports bam\|bai and cdna\|dna |
      | bai        | other_nucleic_acid | Only supports bam\|bai and cdna\|dna |
      | qc_name    |                    | Only supports vcf and tsv files      |

  @ion_reporter_p3
  Scenario Outline: ION_SF06. sequence files service should fail if tsv|vcf and nucleic acid type are passed in
    Given molecular id is "SC_AWBSY"
    Given sequence file type: "<file_type>", nucleic acid type: "<nucleic_acid_type>"
    When GET from sequence_files service, response includes "Only supports bam|bai and cdna|dna" with code "400"
    Examples:
      | file_type | nucleic_acid_type |
      | tsv       | dna               |
      | vcf       | cdna              |

  @ion_reporter_p3
  Scenario Outline: ION_SF07. sequence files service should fail if molecular id is not passed in
    Given molecular id is ""
    Given sequence file type: "<file_type>", nucleic acid type: "<nucleic_acid_type>"
    When GET from sequence_files service, response includes "<result>" with code "<code>"
    Examples:
      | file_type | nucleic_acid_type | result                          | code |
      | tsv       |                   | not found                       | 404  |
      | vcf       |                   | not found                       | 404  |
      | bam       | cdna              | Only supports vcf and tsv files | 400  |
      | bai       | dna               | Only supports vcf and tsv files | 400  |

  @ion_reporter_p3
  Scenario Outline: ION_SF08. sequence files service should fail if only bam|bai is passed in
    Given molecular id is "SC_XPCQG"
    Given sequence file type: "<file_type>", nucleic acid type: ""
    When GET from sequence_files service, response includes "Only supports vcf and tsv files" with code "400"
    Examples:
      | file_type |
      | bam       |
      | bai       |

  @ion_reporter_p3
  Scenario: ION_SF09. sequence files service should fail if only molecular_id is passed in
    Given molecular id is "SC_2A9FY"
    Given sequence file type: "", nucleic acid type: ""
    When GET from sequence_files service, response includes "Only supports bam|bai and cdna|dna" with code "400"

  @ion_reporter_p3
  Scenario: ION_SF10. sequence files service should fail if no parameter is passed in
    Given molecular id is ""
    Given sequence file type: "", nucleic acid type: ""
    When GET from sequence_files service, response includes "No ABCMeta with id: sequence_files found" with code "404"

  @ion_reporter_p2
  Scenario: ION_SF11. sequence files service should return 404 error if no result for current query
    Given molecular id is "SC_XZD70"
    Given sequence file type: "vcf", nucleic acid type: ""
    When GET from sequence_files service, response includes "Key does not exist" with code "404"

  @ion_reporter_p2
  Scenario: ION_SF80. sequence files service should fail when user want to create new item using POST
    Given molecular id is "SC_73JIO"
    Given sequence file type: "vcf", nucleic acid type: ""
    When POST to sequence_files service, response includes "The method is not allowed" with code "405"

  @ion_reporter_p2
  Scenario: ION_SF81. sequence files service should fail when user want to delete item using DELETE
    Given molecular id is "SC_43K8V"
    Given sequence file type: "vcf", nucleic acid type: ""
    When DELETE to sequence_files service, response includes "The method is not allowed" with code "405"

  @ion_reporter_p2
  Scenario: ION_SF82. sequence files service should fail when user want to update item using PUT
    Given molecular id is "SC_IEWC6"
    Given sequence file type: "vcf", nucleic acid type: ""
    When PUT to sequence_files service, response includes "The method is not allowed" with code "405"


