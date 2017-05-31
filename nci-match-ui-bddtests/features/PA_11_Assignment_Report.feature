@ui_p2
Feature: As a logged in user
  I should see the assignment reports
  In context of the Surgical Event Id

  Background:
    Given I stay logged in as "read_only" user

  Scenario: I should see that the assignment report is attached to the surgical event Id and is not displayed for another surgical id
    When I go to the patient "PT_SC06a_PendingApprovalStep2" with surgical event "PT_SC06a_PendingApprovalStep2_SEI2"
    And I scroll to the bottom of the page
    And I get the count of Assignment reports for the Surgical Event
    And I go to the patient "PT_SC06a_PendingApprovalStep2" with variant report "PT_SC06a_PendingApprovalStep2_ANI2"
    Then I see that the count of Assignment report tabs match that of count in the surgical event details
    When I go to the Assignment Report on tab "1"
    Then I see that the Analysis Id is "PT_SC06a_PendingApprovalStep2_ANI2"
    When I go to the patient "PT_SC06a_PendingApprovalStep2" with surgical event "PT_SC06a_PendingApprovalStep2_SEI1"
    And I scroll to the bottom of the page
    And I get the count of Assignment reports for the Surgical Event
    And I go to the patient "PT_SC06a_PendingApprovalStep2" with variant report "PT_SC06a_PendingApprovalStep2_ANI1"
    Then I see that the count of Assignment report tabs match that of count in the surgical event details
    When I go to the Assignment Report on tab "1"
    Then I see that the Analysis Id is "PT_SC06a_PendingApprovalStep2_ANI1"

  Scenario: I should see all the assignment report details for a surgical event
    When I go to the patient "PT_SC07c_PendingApproval" with surgical event "PT_SC07c_PendingApproval_SEI1"
    And I scroll to the bottom of the page
    And I get the count of Assignment reports for the Surgical Event
    And I go to the patient "PT_SC07c_PendingApproval" with variant report "PT_SC07c_PendingApproval_ANI1"
    Then I see that the count of Assignment report tabs match that of count in the surgical event details
    When I go to the Assignment Report on tab "1"
    Then I see that the Analysis Id is "PT_SC07c_PendingApproval_ANI1"
    And The comment on the Analysis Id is "Assignment 3"
    When I go to the Assignment Report on tab "2"
    Then I see that the Analysis Id is "PT_SC07c_PendingApproval_ANI1"
    And The comment on the Analysis Id is "Assignment 2"
    When I go to the Assignment Report on tab "3"
    Then I see that the Analysis Id is "PT_SC07c_PendingApproval_ANI1"
    And The comment on the Analysis Id is "Assignment 1"
    And Tab "1" "does" have a bell
    And Tab "2" "does not" have a bell
    And Tab "3" "does not" have a bell
