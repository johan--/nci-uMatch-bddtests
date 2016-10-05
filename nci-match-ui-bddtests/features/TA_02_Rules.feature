##
# Created by raseel.mohamed on 6/7/16
##

Feature: Treatment Arm Rules
  A User should be able to drill into a treatment arm to see
  the various rules applied

  Background:
    Given I am a logged in user
    And I navigate to the treatment-arms page
    And I go to treatment arm with "APEC1621-UI" as the id and "STR100" as stratum id

  @treatment_arm_p2 @ui_p2
  Scenario Outline: Logged in user can access <subTabName> with Inclusion/Exclusion details under Rules
    When I select the "Rules" Main Tab
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


  @treatment_arm_p2 @ui_p2
  Scenario: Logged in user can access Drugs/Disease details on the Rules Tab
    When I select the "Rules" Main Tab
    And I select the Drugs / Diseases sub-tab
    Then I should see that Drugs / Diseases sub-tab is active
    And I should see Exclusionary Diseases table
    And I should see Exclusionary Drugs table
    And I should see Inclusionary Diseases table

  @treatment_arm_p2 @ui_p2
    Scenario: Logged in user can access the Non-Sequencing Assays details on the Rules Tab
    When I select the "Rules" Main Tab
    And I select the Non-Sequencing Assays sub-tab
    Then I should see that Non-Sequencing Assays sub-tab is active
    And I should see the Non-Sequencing Assays table
