Feature: MATCHKB-352 Ped-Match users are given authorization based on their roles.


  Scenario: As a read-only user, I do not have access to confirm or reject a variant report
    Given I'm logged in as a "admin" user
    When I go to the patient "PT_CR03_VRUploadedPathConfirmed" with variant report "PT_CR03_VRUploadedPathConfirmed_ANI1"
    Then I can see the variant report page
    And I "should not" see the "REJECT" button on the VR page
    And I "should not" see the "CONFIRM" button on the VR page

  Scenario: The variant report checkboxes are disabled for a read-only user
    Given I'm logged in as a "read_only" user
    When I go to the patient "PT_CR03_VRUploadedPathConfirmed" with variant report "PT_CR03_VRUploadedPathConfirmed_ANI1"
    Then I can see the variant report page
    And The checkboxes are disabled

  Scenario: As a read-only user, I do not have access to approve an assignment report

  Scenario Outline: Verify as a read-only user I can not edit variant report comments and can view

    Examples:

  Scenario Outline: As a variant_report reviewer from MoCha lab, I can only view the variant report of a patient from MDA lab

    Examples:

  Scenario:  As a variant_report reviewer user, I do not have access to approve an assignment report

  Scenario Outline: As a variant_report reviewer from MoCha lab, I can edit the comments of a variant report of a patient from MoCha lab

    Examples:


  Scenario Outline: As a variant_report reviewer from MoCha lab, I can confirm the variant report of a patient from MoCha lab

    Examples:

  Scenario Outline: As a variant_report reviewer from MoCha lab, I can reject the variant report of a patient from MoCha lab

    Examples:


  Scenario: As an assignment_report reviewer, I can approve an assignment report

  Scenario: As an assignment_report reviewer, I do not have access to approve or reject a variant report

  Scenario: As an assignment_report reviewer, I do not have access to edit comments in a variant report but can view

  Scenario: As an assignment_report reviewer, I do not have access to check / uncheck variants