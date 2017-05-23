@rules_p1
Feature: Test the functionality that filters the Indel variants based on specified filter criteria

  Background: the amoi service is run
    Given a tsv variant report file "Indel_variants" and treatment arms file "APEC1621-B.json"
    And remove quality control json from S3
    When call the amoi rest service
    Then quality control json file should be generated


  Scenario: FIL-IND_01: Filter-out an Indel variant that has a location value as 'intronic' when the ova, function and exon are missing
    Then moi report is returned without the indel variant "FRED"



  Scenario: FIL-IND_02: Filter-out an Indel variant that has the filter value FAIL
    Then moi report is returned without the indel variant "NOPASS"

  Scenario: FIL-IND_03: Filter-out an Indel variant that has alleleFrequency < 0.05%
    Then moi report is returned without the indel variant "COSM41596"

  Scenario: FIL-IND_04: Filter-out an Indel variant that has read_depth (FAO) < 25
    Then moi report is returned without the indel variant "COSM250061"


  Scenario: FIL-IND_05: Following indel variants are filtered-in based on:
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
    """
    [{"version":"2015-08-06", "exclusion":false, "treatment_arm_id":"APEC1621-B", "stratum_id":"100", "amoi_status":"CURRENT"}]
    """
