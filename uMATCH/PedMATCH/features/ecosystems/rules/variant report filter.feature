@rules
@demo
Feature: Test the functionality that filters the variant report based on specified critiera


  Scenario Outline: Filter-out a SNV variant that has a location value as 'intronic' when the ova, function and exon are missing
    #   If snv has the location annotated (not guaranteed) and that
    #   annotation states that it is intronic, reject the snv as those should
    #   not be in the variant report.

    #  Some variants are not annotated with location and if this is the case
    #  check the identifier, ova, exon, and function. If all of those are
    #  missing than the location is intronic and we filter it out.

    Given a tsv variant report file file "<tsvFile>" and treatment arms file "<TAFile>"
    When call the amoi rest service
    Then moi report is returned with the snv variant "match769.2" as an amoi
    And amoi treatment arm names for snv variant "match769.2" include:
    """
    SNV_location_intronic100
    """
    And amoi treatment arms for snv variant "match769.2" include:
    """
    {
    "CURRENT":["SNV_location_intronic100"]
    }
    """
    Then moi report is returned with the snv variant "." as an amoi
    Examples:
      |tsvFile                                    |TAFile                         |ta                           |
      |SNV_location_intronic.tsv                  |SNV_location_intronic_TA.json  |["SNV_location_intronic100"] |


#  Scenario Outline: Filter-out a SNV variant that does not have a PASS filter
#    Given a vcf file "<vcfFile>" and rule file "<rulesFile>"
#    When call the moi rest service
#    Then moi report is returned without the variant "<MOI>"
#    Examples:
#      |vcfFile                                    |rulesFile                    |MOI                      |
#      |SNV_NO_PASS_filter                         |SNV_v4dot1                   |match769.3.1             |
#
#
#  Scenario Outline: Filter out SVN variants with allele frequency less than 0.5%
#    Given a vcf file "<vcfFile>" and rule file "<rulesFile>"
#    When call the moi rest service
#    Then moi report is returned without the variant "<MOI>"
#    Examples:
#      |vcfFile                                    |rulesFile                    |MOI                      |
#      |SNV_NO_PASS_filter                         |SNV_v4dot1                   |match769.3.2             |
#
#
#  Scenario Outline: Filter out SVN variants with FAO less than 25
#    Given a vcf file "<vcfFile>" and rule file "<rulesFile>"
#    When call the moi rest service
#    Then moi report is returned without the variant "<MOI>"
#    Examples:
#      |vcfFile                                    |rulesFile                    |MOI                      |
#      |SNV_NO_PASS_filter                         |SNV_v4dot1                   |match769.3.4             |
#
#  Scenario Outline: Filter out SVN variants with a protein that does not match the protein convention (p.(=))
#    Given a vcf file "<vcfFile>" and rule file "<rulesFile>"
#    When call the moi rest service
#    Then moi report is returned without the variant "<MOI>"
#    Examples:
#      |vcfFile                                    |rulesFile                    |MOI                      |
#      |SNV_NO_PASS_filter                         |SNV_v4dot1                   |match769.3.6             |
#
#
#  Scenario Outline: Filter-out SVN variants with function 'synonymous'
#    Given a vcf file "<vcfFile>" and rule file "<rulesFile>"
#    When call the moi rest service
#    Then moi report is returned without the variant "<MOI>"
#    Examples:
#      |vcfFile                                    |rulesFile                    |MOI                      |
#      |SNV_NO_PASS_filter                         |SNV_v4dot1                   |match769.3.7             |
#
#
#  Scenario Outline: Filter-in SVN variants with valid function name
#  -refallele
#  -unknown
#  -missense
#  -nonsense
#  -frameshiftinsertion
#  -frameshiftdeletion
#  -nonframeshiftinsertion
#  -nonframeshiftdeletion
#  -stoploss
#  -frameshiftblocksubstitution
#  -nonframeshiftblocksubstitution
#    Given a vcf file "<vcfFile>" and rule file "<rulesFile>"
#    When call the moi rest service
#    Then moi report is returned with MOI "<MOI>"
#    Examples:
#      |vcfFile                                    |rulesFile                    |MOI                                                                                                                                                    |
#      |SNV_NO_PASS_filter                         |SNV_v4dot1                   |match769.3.8,match769.3.9,match769.3.10,match769.3.11,match769.3.12,match769.3.13,match769.3.14,match769.3.15,match769.3.16,match769.3.17,match769.3.18|
#
#
#
#  Scenario Outline: Filter-out SNV variants that does not have a gene in the oncomine_genes.txt
#    Given a vcf file "<vcfFile>" and rule file "<rulesFile>"
#    When call the moi rest service
#    Then moi report is returned with MOI "<eMOI>"
#    Then moi report is returned without the variant "<nMOI>"
#    Examples:
#      |vcfFile                                    |rulesFile                    |eMOI                      |nMOI            |
#      |SNV_OVA_GENE                               |SNV_v4dot1                   |moip-1,moip-2             |moip-3          |
#
#
#  Scenario Outline: Filter-out all Germline SNV variants
#    Given a vcf file "<vcfFile>" and rule file "<rulesFile>"
#    When call the moi rest service
#    Then moi report is returned without any variants
#    Examples:
#      |vcfFile                                    |rulesFile                    |
#      |SNV_Germline_filter                        |SNV_v4dot1                   |
#
#
