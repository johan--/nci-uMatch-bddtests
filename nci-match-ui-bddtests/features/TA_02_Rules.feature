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
    When I scroll to the bottom of the page
    And I select the <subTabName> sub-tab
    Then I should see that <subTabName> sub-tab is active
    When I select the Inclusion button
    Then I should see the Inclusion Variants table for <subTabName>
    When I select the Exclusion button
    Then I should see the Exclusion Variants table for <subTabName>
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
      | SNVs / MNVs / Indels  | ID         | Inclusion     | cosmic-link[link-id="item.identifier"] | Cosmic   |
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
      | SNVs / MNVs / Indels  |
      | CNVs                  |
      | Non-Hotspot Rules     |
      | Gene Fusions          |

  @ui_p2
  Scenario: Check for Gene in the Non-Sequencing Assays table.
    When I select the Non-Sequencing Assays sub-tab
    Then I see that the elements in the column "Gene" for table "Non-Sequencing Assays" and "Inclusion" is a gene


  @ui_p2
  Scenario: Check for links in the Non-Sequencing Assays table.
    When I select the Non-Sequencing Assays sub-tab
    And I get the index of the "Gene" value in "Non-Sequencing Assays" and "None"
    Then I see that the element with css "cosmic-link[link-id="item.gene"]" is a "Gene" link
    And I see that the elements in the column "Gene" for table "Non-Sequencing Assays" is a gene

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
