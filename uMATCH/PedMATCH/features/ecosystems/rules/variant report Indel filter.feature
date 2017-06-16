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
  f. non-hotspot variant matching the treatment arms (exclusion domain: 331-413, inclusion domain is 414-622
    Then moi report is returned with the indel variant "WILMA"
    Then moi report is returned with the indel variant "COSM97131"
    Then moi report is returned with the indel variant "NOONCOM"
    Then moi report is returned with the indel variant "NOEXON"
    Then moi report is returned with the indel variant "NOFUNCT"
    Then moi report is returned with the indel variant "NOLOC"
    Then moi report is returned with the indel variant "OVADELETERIOUS"
    Then moi report is returned with indel variants with following amoi information
      | id | protein    | is_amoi | amoi_ta_id | amoi_ta_stratum | amoi_ta_version | amoi_exclusion | amoi_status |
      | .  | p.Gln105fs | false   | APEC1621-B | 100             | 2015-08-06      |                |             |
      | .  | p.Val330fs | false   | APEC1621-B | 100             | 2015-08-06      |                |             |
      | .  | p.Asp331fs | true    | APEC1621-B | 100             | 2015-08-06      | true           | CURRENT     |
      | .  | p.Thr401fs | true    | APEC1621-B | 100             | 2015-08-06      | true           | CURRENT     |
      | .  | p.Ser413fs | true    | APEC1621-B | 100             | 2015-08-06      | true           | CURRENT     |
      | .  | p.Asn414fs | true    | APEC1621-B | 100             | 2015-08-06      | false          | CURRENT     |
      | .  | p.Ala501fs | true    | APEC1621-B | 100             | 2015-08-06      | false          | CURRENT     |
      | .  | p.Leu622fs | true    | APEC1621-B | 100             | 2015-08-06      | false          | CURRENT     |
      | .  | p.Lys623fs | false   | APEC1621-B | 100             | 2015-08-06      |                |             |
      | .  | p.Cys750fs | false   | APEC1621-B | 100             | 2015-08-06      |                |             |
