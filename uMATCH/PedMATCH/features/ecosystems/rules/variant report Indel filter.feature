@rules
Feature: Test the functionality that filters the Indel variants based on specified filter criteria

  Scenario Outline: Filter-out a Indel variant that has a location value as 'intronic' when the ova, function and exon are missing
    Given a tsv variant report file file "<tsvFile>" and treatment arms file "<TAFile>"
    When call the amoi rest service
    Then moi report is returned without the indel variant "FRED"
    Examples:
      |tsvFile                                    |TAFile            |
      |Indel_variants.tsv                         |APEC1621-B.json   |


  Scenario Outline: Filter-out a Indel variant that has the filter value FAIL
    Given a tsv variant report file file "<tsvFile>" and treatment arms file "<TAFile>"
    When call the amoi rest service
    Then moi report is returned without the indel variant "NOPASS"
    Examples:
      |tsvFile                                    |TAFile            |
      |Indel_variants.tsv                         |APEC1621-B.json   |


  Scenario Outline: Following indel variants are filtered-in
        a. AF > 0.05%,
        b. Read depth > 25
        c. Func block with location exonic and function names matching the following list  -refallele
            -unknown
            -missense
            -nonsense
            -frameshiftinsertion
            -frameshiftdeletion
            -nonframeshiftinsertion
            -nonframeshiftdeletion
            -stoploss
            -frameshiftblocksubstitution
            -nonframeshiftblocksubstitution
        d. Filter = PASS
        e. OVA = Deleterious
    Given a tsv variant report file file "<tsvFile>" and treatment arms file "<TAFile>"
    When call the amoi rest service
    Then moi report is returned with the indel variant "WILMA"
    Then moi report is returned with the indel variant "COSM97131"
    Then moi report is returned with the indel variant "NOONCOM"
    Then moi report is returned with the indel variant "NOEXON"
    Then moi report is returned with the indel variant "NOFUNCT"
    Then moi report is returned with the indel variant "NOLOC"
    Then moi report is returned with the indel variant "OVADELETERIOUS"
    Examples:
      |tsvFile                                    |TAFile            |
      |Indel_variants.tsv                         |APEC1621-B.json   |