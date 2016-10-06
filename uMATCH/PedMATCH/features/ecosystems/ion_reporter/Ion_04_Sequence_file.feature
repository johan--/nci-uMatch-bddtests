#encoding: utf-8
@ion_reporter_reporters
Feature: Tests for sequence files service in ion ecosystem

@ion_reporter_p1

  Scenario: ION_SF01. sequence files service can return correct result for sample control molecular_id

  Scenario: ION_SF05. returned file path should be reachable S3 path
  
  Scenario: ION_SF02. sequence files service should fail if a patient molecular_id is passed in

  Scenario: ION_SF04. sequence files service should fail if an non-existing molecular_id is passed in

  Scenario: ION_SF04. sequence files service should fail if an non-existing file_format is passed in

  Scenario: ION_SF04. sequence files service should fail if an non-existing nucleic acid type is passed in

  Scenario: ION_SF04. sequence files service should fail if tsv|vcf and nucleic acid type are passed in

  Scenario: ION_SF04. sequence files service should fail if only tsv|vcf is passed in

  Scenario: ION_SF04. sequence files service should fail if only bam|bai is passed in

  Scenario: ION_SF06. sequence files service should fail if only molecular_id is passed in

  Scenario: ION_SF06. sequence files service should fail if no parameter is passed in


  Scenario: ION_SF07. sequence files service should return 404 error if no result for current query



  Scenario: ION_SF80. sequence files service should fail when user want to create new item using POST

  Scenario: ION_SF81. sequence files service should fail when user want to delete item using DELETE

  Scenario: ION_SF82. sequence files service should fail when user want to update item using PUT


