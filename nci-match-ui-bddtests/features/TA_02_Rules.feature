##
# Created by raseel.mohamed on 6/7/16
##

Feature: Treatment Arm Rules
  A User should be able to drill into a treatment arm to see
  the various rules applied

  Background:
    Given I stay logged in as "read_only" user
    And I go to treatment arm with "APEC1621-UI" as the id and "STR100" as stratum id
    And I collect backend information about the treatment arm
    When I select the "Rules" Main Tab

  @ui_p1
  Scenario Outline: Logged in user can access <subTabName> with Inclusion/Exclusion details under Rules
    When I select the <subTabName> sub-tab
    Then I should see that <subTabName> sub-tab is active
    When I select the Inclusion button
    Then I should see the Inclusion Variants table for <subTabName>
    And I verify that all the Literature References are valid links
    When I select the Exclusion button
    Then I should see the Exclusion Variants table for <subTabName>
    And I verify that all the Literature References are valid links
    Examples:
      | subTabName           |
      | SNVs / MNVs / Indels |
      | CNVs                 |
      | Gene Fusions         |
      | Non-Hotspot Rules    |

  @ui_p2
  Scenario: Logged in user can access Drugs/Disease details on the Rules Tab
    When I select the Drugs / Disease sub-tab
    Then I should see that Drugs / Disease sub-tab is active
    And I should see Exclusionary Disease table
    And I should see Exclusionary Drugs table
    And I should see Inclusionary Disease table

  @ui_p2
  Scenario: Logged in user can access the Non-Sequencing Assays details on the Rules Tab
    When I select the Non-Sequencing Assays sub-tab
    Then I should see that Non-Sequencing Assays sub-tab is active
    And I should see the Non-Sequencing Assays table

 @ui_p2
  Scenario Outline: Check for links in the <subTabName> table.
    When I select the <subTabName> sub-tab
    And I select the Inclusion button
    And I get the index of the "<columnName>" value in "<subTabName>" and "<inclusionType>"
    Then I see that the element with css "<cssSelector>" is a "<linkType>" link
    Examples:
      | subTabName            | columnName | inclusionType | cssSelector                            | linkType |
#      | SNVs / MNVs / Indels  | ID         | Inclusion     | cosmic-link[link-id="item.identifier"] | Cosmic   |
      | CNVs                  | Gene       | Inclusion     | cosmic-link[link-id="item.identifier"] | Gene     |
      | Non-Hotspot Rules     | Gene       | Inclusion     | cosmic-link[link-id="item.func_gene"]  | Gene     |
      | Gene Fusions          | ID         | Inclusion     | cosmic-link[link-id="item.identifier"] | Cosf     |


  @ui_p2
  Scenario Outline: Check for Gene in the <subTabName> table.
    When I select the <subTabName> sub-tab
    And I select the Inclusion button
    Then I see that the elements in the column "Gene" for table "<subTabName>" and "Inclusion" is a gene
    When I select the Exclusion button
    Then I see that the elements in the column "Gene" for table "<subTabName>" and "Exclusion" is a gene
    Examples:
      | subTabName            |
#      | SNVs / MNVs / Indels  |
      | CNVs                  |
      | Non-Hotspot Rules     |
      | Gene Fusions          |


  @ui_p2
  Scenario: Check for links in the Non-Sequencing Assays table.
    When I select the Non-Sequencing Assays sub-tab
    And I see that the elements in the column gene for table Non-Sequencing Assays is a gene

  @ui_p2
  Scenario Outline: Variants are sorted by defaults in ascending order of Chromosomes on the <subTabName> table
    When I select the <subTabName> sub-tab
    And I select the Inclusion button
    And I capture the "Chrom" column under "<subTabName>" Table with "Inclusion" type
    Then I verify that they are sorted numerically
    And I select the Exclusion button
    And I capture the "Chrom" column under "<subTabName>" Table with "Exclusion" type
    Then I verify that they are sorted numerically
    Examples:
      | subTabName           |
      | SNVs / MNVs / Indels |
      | CNVs                 |

  @ui_p2
  Scenario: User should be able to search for and retrieve one row based on search term
    When I select the SNVs / MNVs / Indels sub-tab
    And I enter "BT9" in the "SNVs / MNVs / Indels" search field
    Then I should see "BT9" in the retrieved row for "SNVs / MNVs / Indels"
    When I select the CNVs sub-tab
    And I enter "MYCL" in the "CNVs" search field
    Then I should see "MYCL" in the retrieved row for "CNVs"
    When I select the Gene Fusions sub-tab
    And I enter "TPM3-NTRK1.T7N10.COSF1318_2" in the "Gene Fusions" search field
    Then I should see "TPM3-NTRK1.T7N10.COSF1318_2" in the retrieved row for "Gene Fusions"
    When I select the Non-Sequencing Assays sub-tab
    And I enter "MEH1" in the "Non-Sequencing Assays" search field
    Then I should see "MEH1" in the retrieved row for "Non-Sequencing Assays"
    When I select the Non-Hotspot Rules sub-tab
    And I enter "SE" in the "Non-Hotspot Rules" search field
    Then I should not see any retrieved row for "Non-Hotspot Rules"
