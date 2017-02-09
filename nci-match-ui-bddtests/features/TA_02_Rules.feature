##
# Created by raseel.mohamed on 6/7/16
##

Feature: Treatment Arm Rules
  A User should be able to drill into a treatment arm to see
  the various rules applied

  Background:
    Given I am a logged in user
    And I go to treatment arm with "APEC1621-UI" as the id and "STR100" as stratum id
    And I collect backend information about the treatment arm
    When I select the "Rules" Main Tab

  @ui_p1
  Scenario Outline: Logged in user can access <subTabName> with Inclusion/Exclusion details under Rules
    When I select the <subTabName> sub-tab
    Then I should see that <subTabName> sub-tab is active
    When I select the Inclusion button
    Then I should see the Inclusion Variants table for <subTabName>
    When I select the Exclusion button
    Then I should see the Exclusion Variants table for <subTabName>
    Then I logout
    Examples:
      | subTabName           |
      | SNVs / MNVs / Indels |
      | CNVs                 |
      | Gene Fusions         |
      | Non-Hotspot Rules    |

  @ui_p2
  Scenario: Logged in user can access Drugs/Disease details on the Rules Tab
    When I select the Drugs / Diseases sub-tab
    Then I should see that Drugs / Diseases sub-tab is active
    And I should see Exclusionary Diseases table
    And I should see Exclusionary Drugs table
    And I should see Inclusionary Diseases table
    Then I logout

  @ui_p2
  Scenario: Logged in user can access the Non-Sequencing Assays details on the Rules Tab
    When I select the Non-Sequencing Assays sub-tab
    Then I should see that Non-Sequencing Assays sub-tab is active
    And I should see the Non-Sequencing Assays table
    Then I logout

 @ui_p2
  Scenario Outline: Check for links in the <subTabName> table.
    When I select the <subTabName> sub-tab
    And I select the Inclusion button
    And I get the index of the "<columnName>" value in "<subTabName>" and "<inclusionType>"
    Then I see that the element with css "<cssSelector>" is a "<linkType>" link
    Then I logout
    Examples:
      | subTabName            | columnName | inclusionType | cssSelector                            | linkType |
      | SNVs / MNVs / Indels  | ID         | Inclusion     | cosmic-link[link-id="item.identifier"] | Cosmic   |
      | CNVs                  | Gene       | Inclusion     | cosmic-link[link-id="item.identifier"] | Gene     |
      | Non-Hotspot Rules     | Gene       | Inclusion     | cosmic-link[link-id="item.func_gene"]  | Gene     |
      | Gene Fusions          | ID         | Inclusion     | cosmic-link[link-id="item.identifier"] | Cosf     |

@ui_p2
Scenario: Check for links in the Non-Sequencing Assays table.
    When I select the Non-Sequencing Assays sub-tab
    And I get the index of the "Gene" value in "Non-Sequencing Assays" and "None"
    Then I see that the element with css "cosmic-link[link-id="item.gene"]" is a "Gene" link
    Then I logout
