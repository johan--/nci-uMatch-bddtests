#encoding: utf-8
@ion_reporter_reporters
Feature: Tests for aliquots service in ion ecosystem

@ion_reporter_p1
  Scenario: ION_AQ01. aliquot service will return success message when a valid request is received

  Scenario: ION_AQ02. for sample control specimen, aliquot service will generate tsv file and upload to S3

  Scenario: ION_AQ03. for sample control specimen, aliquot service will generate bai file and upload to S3

  Scenario: ION_AQ04. for patient specimen, aliquot service will generate tsv file and upload to S3

  Scenario: ION_AQ05. for patient specimen, aliquot service will generate bai file and upload to S3

  Scenario: ION_AQ06. aliquot service will update sample control database once process done

  Scenario: ION_AQ07. aliquot service will not update sample control database if specimen is for patient

  Scenario: ION_AQ08. aliquot service will store generated sample control variants to database (with correct analysis_id), once process done

  Scenario: ION_AQ09. aliquot service will send variant files uploaded message (with correct analysis_id) to patient ecosystem once process done

  Scenario: ION_AQ10. aliquot service will return error if site-ion_reporter_id pair in message body is invalid

  Scenario: ION_AQ11. aliquot service will return error if any file value(vcf, bam, qc) is missing

  Scenario: ION_AQ39. extra key-value pair in the message body should NOT fail




  Scenario: ION_AQ40. aliquot service can return correct result for sample control molecular_id (with details under every analysis_ids)

  Scenario: ION_AQ41. aliquot service can return correct result for patient tissue molecular_id

  Scenario: ION_AQ42. aliquot service can return correct result for patient blood molecular_id

  Scenario: ION_AQ43. aliquot service should only return projected VALID key-value pair

  Scenario: ION_AQ44. aliquot service should fail if an invalid key is projected

  Scenario: ION_AQ45. aliquot service should return 404 error if query a non-existing molecular_id

  Scenario: ION_AQ46. aliquot service should fail if no molecular_id and parameter is provided



  Scenario: ION_AQ80. aliquot service should fail when user want to create new item using POST

  Scenario: ION_AQ81. aliquot service should fail when user want to delete item using DELETE


