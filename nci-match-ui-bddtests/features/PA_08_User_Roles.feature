@ui_p2 @test
Feature: MATCHKB-352 Ped-Match users are given authorization based on their roles.

  Scenario: As a read-only user, I do not have access to confirm or reject a variant report
    Given I'm logged in as a "read_only" user
    When I go to the patient "ION_AQ41_TsVrUploaded" with variant report "ION_AQ41_TsVrUploaded_ANI1"
    Then I can see the variant report page
    And I "should not" see the "REJECT" button on the VR page
    And I "should not" see the "CONFIRM" button on the VR page
    Then I then logout

  Scenario: The variant report checkboxes are disabled for a read-only user
    Given I'm logged in as a "read_only" user
    When I go to the patient "ION_AQ41_TsVrUploaded" with variant report "ION_AQ41_TsVrUploaded_ANI1"
    Then I can see the variant report page
    And The checkboxes are disabled
    Then I then logout

 Scenario Outline: As a non-privileged user I can not edit variant report comments but can only view
    Given I'm logged in as a "<user>" user
    When I go to the patient "PT_GVF_TsVrUploaded" with variant report "PT_GVF_TsVrUploaded_ANI1"
    Then I can see the variant report page
    And I click on the comment link at ordinal "1"
    Then I can see the "Unconfirmed for UI display" in the modal text box
    And The "OK" button is "invisible"
    Then I click on the "Close" button
    Then I then logout
    Examples:
      | user              |
      | read_only         |
      | VR_Reviewer_mocha |
      | AR_Reviewer       |
      
 Scenario: As a variant_report reviewer from MDA lab I can edit variant report comments
    Given I'm logged in as a "VR_Reviewer_mda" user
    When I go to the patient "PT_GVF_TsVrUploaded" with variant report "PT_GVF_TsVrUploaded_ANI1"
    Then I can see the variant report page
    And I click on the comment link at ordinal "1"
    Then I can see the "Unconfirmed for UI display" in the modal text box
    And The "OK" button is "visible"
    Then I click on the "OK" button
    Then I then logout

  Scenario: As a variant_report reviewer from MoCha lab, I can only view the variant report of a patient from MDA lab
    Given I'm logged in as a "VR_Reviewer_mocha" user
    When I go to the patient "ION_AQ41_TsVrUploaded" with variant report "ION_AQ41_TsVrUploaded_ANI1"
    Then I can see the variant report page
    And I "should not" see the "REJECT" button on the VR page
    And I "should not" see the "CONFIRM" button on the VR page
    Then I then logout

  Scenario Outline:  As a variant_report reviewer user, I do not have access to approve an assignment report
    Given I'm logged in as a "<user>" user
    When I go to the patient "PT_OS01_PendingConfirmation" with variant report "PT_OS01_PendingConfirmation_ANI1"
    And I click on the Assignment Report tab "Assignment Report - PENDING"
    Then I "should not" see the Assignment report "CONFIRM" button
    Then I then logout
    Examples:
      | user              |
      | read_only         |
      | VR_Reviewer_mocha |
      | VR_Reviewer_mda   |

#  Scenario Outline: As a variant_report reviewer from MoCha lab, I can confirm the variant report of a patient from MoCha lab
#
#    Examples:
#
#  Scenario Outline: As a variant_report reviewer from MoCha lab, I can reject the variant report of a patient from MoCha lab
#
#    Examples:
#
#
#  Scenario: As an assignment_report reviewer, I can approve an assignment report

  Scenario: As an assignment_report reviewer, I do not have access to approve or reject a variant report
    Given I'm logged in as a "AR_Reviewer" user
    When I go to the patient "ION_AQ41_TsVrUploaded" with variant report "ION_AQ41_TsVrUploaded_ANI1"
    Then I can see the variant report page
    And I "should not" see the "REJECT" button on the VR page
    And I "should not" see the "CONFIRM" button on the VR page
    Then I then logout

  Scenario: As an assignment_report reviewer, I do not have access to check / uncheck variants
    Given I'm logged in as a "AR_Reviewer" user
    When I go to the patient "ION_AQ41_TsVrUploaded" with variant report "ION_AQ41_TsVrUploaded_ANI1"
    Then I can see the variant report page
    And The checkboxes are disabled
    Then I then logout
