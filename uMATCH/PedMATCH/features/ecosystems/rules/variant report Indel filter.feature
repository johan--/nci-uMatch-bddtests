@rules
Feature: Test the functionality that filters the Indel variants based on specified filter criteria

  Background: the amoi service is run
    Given a tsv variant report file file "Indel_variants.tsv" and treatment arms file "APEC1621-B.json"
    When call the amoi rest service


  Scenario: Filter-out an Indel variant that has a location value as 'intronic' when the ova, function and exon are missing
    Then moi report is returned without the indel variant "FRED"



  Scenario: Filter-out an Indel variant that has the filter value FAIL
    Then moi report is returned without the indel variant "NOPASS"

  Scenario: Filter-out an Indel variant that has alleleFrequency < 0.05%
    Then moi report is returned without the indel variant "COSM41596"

  Scenario: Filter-out an Indel variant that has read_depth (FAO) < 25
    Then moi report is returned without the indel variant "COSM250061"


  Scenario: Following indel variants are filtered-in based on:
        a. AF > 0.05%;
        b. Read depth > 25;
        c. Func block with location exonic and function names matching the following list:
            -refallele,
            -unknown,
            -missense,
            -nonsense,
            -frameshiftinsertion,
            -frameshiftdeletion,
            -nonframeshiftinsertion,
            -nonframeshiftdeletion,
            -stoploss,
            -frameshiftblocksubstitution,
            -nonframeshiftblocksubstitution;
        d. Filter = PASS;
        e. OVA = Deleterious;
        f. non-hotspot variant matching the treatment arms
    Then moi report is returned with the indel variant "WILMA"
    Then moi report is returned with the indel variant "COSM97131"
    Then moi report is returned with the indel variant "NOONCOM"
    Then moi report is returned with the indel variant "NOEXON"
    Then moi report is returned with the indel variant "NOFUNCT"
    Then moi report is returned with the indel variant "NOLOC"
    Then moi report is returned with the indel variant "OVADELETERIOUS"
    Then moi report is returned with the indel variant "." as an amoi