@ui_p2
Feature: MATCHKB-352. Users are given authorization based on their roles.

 Scenario: As a variant_report reviewer from MDA lab I can edit variant comments
    Given I am logged in as a "VR_Reviewer_mda" user
    When I go to the patient "UI_PA08_MdaTsVrUploaded" with variant report "UI_PA08_MdaTsVrUploaded_ANI1"
    Then I can see the variant report page
    And I wait for "10" seconds
    And I click on the comment link at ordinal "1"
    Then I can see the "Unconfirmed for UI display" in the modal text box
    And The "OK" button is "visible"
    Then I click on the "OK" button
    Then I logout

  Scenario: As a read-only user, I do not have access to confirm or reject a variant report
    Given I am logged in as a "read_only" user
    When I go to the patient "UI_PA08_MdaTsVrUploaded" with variant report "UI_PA08_MdaTsVrUploaded_ANI1"
    Then I can see the variant report page
    And I "should not" see the "REJECT" button on the VR page
    And I "should not" see the "CONFIRM" button on the VR page
    Then I logout

  Scenario: The variant report checkboxes are disabled for a read-only user
    Given I am logged in as a "read_only" user
    When I go to the patient "UI_PA08_MdaTsVrUploaded" with variant report "UI_PA08_MdaTsVrUploaded_ANI1"
    Then I can see the variant report page
    And The checkboxes are disabled
    Then I logout

 Scenario Outline: As a non-privileged user, <user>,  I can view variant comments but not edit
    Given I am logged in as a "<user>" user
    When I go to the patient "UI_PA08_MdaTsVrUploaded" with variant report "UI_PA08_MdaTsVrUploaded_ANI1"
    Then I can see the variant report page
    And I click on the comment link at ordinal "1"
    Then I can see the "Unconfirmed for UI display" in the modal text box
    And The "OK" button is "invisible"
    Then I click on the "Close" button
    Then I logout
    Examples:
      | user              |
      | read_only         |
      | VR_Reviewer_mocha |
      | AR_Reviewer       |

  Scenario: As a variant_report reviewer from MoCha lab, I can only view the variant report of a patient from MDA lab
    Given I am logged in as a "VR_Reviewer_mocha" user
    When I go to the patient "UI_PA08_MdaTsVrUploaded" with variant report "UI_PA08_MdaTsVrUploaded_ANI1"
    Then I can see the variant report page
    And I "should not" see the "REJECT" button on the VR page
    And I "should not" see the "CONFIRM" button on the VR page
    Then I logout

  Scenario Outline:  As a variant_report reviewer, <user>, I cannot approve an assignment report
    Given I am logged in as a "<user>" user
    When I go to the patient "UI_PA08_PendingConfirmation" with variant report "UI_PA08_PendingConfirmation_ANI1"
    And I click on the Assignment Report tab "Assignment Report - PENDING"
    Then I "should not" see the Assignment report "CONFIRM" button
    Then I logout
    Examples:
      | user              |
      | read_only         |
      | VR_Reviewer_mocha |
      | VR_Reviewer_mda   |

 Scenario: As a variant_report reviewer from MoCha lab, I can confirm or reject the variant report of a patient from MoCha lab
    Given I am logged in as a "VR_Reviewer_mocha" user
    When I go to the patient "UI_PA08_MochaTsVrUploaded" with variant report "UI_PA08_MochaTsVrUploaded_ANI1"
    Then I can see the variant report page
    And The "REJECT" button is "visible"
    And The "REJECT" button is "enabled"
    And The "CONFIRM" button is "visible"
    And The "CONFIRM" button is "enabled"
    Then I logout

 Scenario: As a variant_report reviewer from MDA lab, I can confirm or reject the variant report of a patient from MDA lab
    Given I am logged in as a "VR_Reviewer_mda" user
    When I go to the patient "UI_PA08_MdaTsVrUploaded" with variant report "UI_PA08_MdaTsVrUploaded_ANI1"
    Then I can see the variant report page
    And The "REJECT" button is "visible"
    And The "REJECT" button is "enabled"
    And The "CONFIRM" button is "visible"
    And The "CONFIRM" button is "enabled"
    Then I logout

  Scenario: As an assignment_report reviewer, I can approve an assignment report
    Given I am logged in as a "AR_Reviewer" user
    When I go to the patient "UI_PA08_PendingConfirmation" with variant report "UI_PA08_PendingConfirmation_ANI1"
    Then I click the assignment report tab "Assignment Report - PENDING"
    And I can see the assignment report page "Assignment Report - PENDING"
    Then I scroll to the bottom of the page
    And The "CONFIRM" button is "visible"
    And The "CONFIRM" button is "enabled"
    Then I logout

  Scenario: As an assignment_report reviewer, I cannot approve or reject a variant report
    Given I am logged in as a "AR_Reviewer" user
    When I go to the patient "UI_PA08_MdaTsVrUploaded" with variant report "UI_PA08_MdaTsVrUploaded_ANI1"
    Then I can see the variant report page
    And I "should not" see the "REJECT" button on the VR page
    And I "should not" see the "CONFIRM" button on the VR page
    Then I logout

  Scenario: As an assignment_report reviewer, I cannot check / uncheck variants
    Given I am logged in as a "AR_Reviewer" user
    When I go to the patient "UI_PA08_MdaTsVrUploaded" with variant report "UI_PA08_MdaTsVrUploaded_ANI1"
    Then I can see the variant report page
    And The checkboxes are disabled
    Then I logout
