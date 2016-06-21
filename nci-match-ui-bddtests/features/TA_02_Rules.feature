##
# Created by raseel.mohamed on 6/7/16
##

Feature:
  As a valid logged in user
  I am able to view the various treatment arms
  Where I should see the Rules applied to the Treatment Arm

  Background:
    Given I am a logged in user
    And I navigate to the treatment-arms page
    And I click on one of the treatment arms

  @treatment
  Scenario Outline: Logged in user can access <subTabName> with <buttonType> details under Rules
    When I select the Rules Main Tab
    And I select the <subTabName> sub-tab
    Then I should see that <subTabName> sub-tab is active
    When I select the <buttonType> button
    Then I should see the <buttonType> Variants table for <subTabName>
    Examples:
      | subTabName            | buttonType |
      | SNV / MNV             | Inclusion  |
      | SNV / MNV             | Exclusion  |
      | Indel                 | Inclusion  |
      | Indel                 | Exclusion  |
      | CNV                   | Inclusion  |
      | CNV                   | Exclusion  |
      | Gene Fusion           | Inclusion  |
      | Gene Fusion           | Exclusion  |
      | Non-Hotspot Rules     | Inclusion  |
      | Non-Hotspot Rules     | Exclusion  |


  @treatment
  Scenario: Logged in user can access Drugs/Disease details on the Rules Tab
    When I select the Rules Main Tab
    And I select the Drugs / Diseases sub-tab
    Then I should see that Drugs / Diseases sub-tab is active
    And I should see Exclusionary Diseases table
#    And I should see Inclusionary Drugs table
#    And I should see Exclusionary Drugs table
#    And I should see Inclusionary Diseases table

  @treatment @dev
    Scenario: Logged in user can access the Non-Sequencing Assays details on the Rules Tab
    When I select the Rules Main Tab
    And I select the Non-Sequencing Assays sub-tab
    Then I should see that Non-Sequencing Assays sub-tab is active
    And I should see the Non-Sequencing Assays table



  @treatment
  Scenario: Rules Tab displays subtabs
    When I select the Rules Main Tab
    Then I should see the sub-tabs under Rules
