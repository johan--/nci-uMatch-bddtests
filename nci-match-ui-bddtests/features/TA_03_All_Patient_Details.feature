Feature: Treatment Arm details page show the details about the patient associated with that particular TA

  Background:
    Given I stay logged in as "read_only" user
    When I go to treatment arm with "APEC1621-A" as the id and "100" as stratum id

  @ui_p2
  Scenario Outline: A patient on status <status> <see_or_not> see the Date Off Arm data generated
    And I enter "<patient_id>" in the all patients data filter field
    And His status in the all patients table is "<status>"
    Then I "<see_or_not>" see the Data of Arm Generated
    Examples:
      | patient_id                    | status               | see_or_not |
      | PT_SR10_ProgressReBioY        | PREVIOUSLY_ON_ARM    | should     |
      | PT_AS08_TsReceivedStep2       | NOT_ENROLLED_ON_ARM  | should     |
      | PT_RA06_OnTreatmentArm        | ON_TREATMENT_ARM     | should not |
      | PT_AU06_PendingConfirmation0  | PENDING_CONFIRMATION | should not |
      | PT_AU08_PendingApproval0      | PENDING_APPROVAL     | should not |
#      | PT_SC06a_PendingApprovalStep2 | REQUEST_ASSIGNMENT   | should not |
#    | PT_GVF_RequestNoAssignment | REQUEST_NO_ASSIGNMENT | should not |

  @ui_p2
  Scenario: Patients on different statuses should show or not show the Date Off Arm data generated
    And I enter "PT_SR10_ProgressReBioY" in the all patients data filter field
    And His status in the all patients table is "PREVIOUSLY_ON_ARM"
    Then I "should" see the Data of Arm Generated
    And I enter "PT_AS08_TsReceivedStep2" in the all patients data filter field
    And His status in the all patients table is "NOT_ENROLLED_ON_ARM"
    Then I "should" see the Data of Arm Generated
    And I enter "PT_SC06a_PendingApprovalStep2" in the all patients data filter field
    And His status in the all patients table is "REQUEST_ASSIGNMENT"
    Then I "should" see the Data of Arm Generated
    And I enter "PT_RA06_OnTreatmentArm" in the all patients data filter field
    And His status in the all patients table is "ON_TREATMENT_ARM"
    Then I "should not" see the Data of Arm Generated
    And I enter "PT_AU06_PendingConfirmation0" in the all patients data filter field
    And His status in the all patients table is "PENDING_CONFIRMATION"
    Then I "should not" see the Data of Arm Generated
    And I enter "PT_AU08_PendingApproval0" in the all patients data filter field
    And His status in the all patients table is "PENDING_APPROVAL"
    Then I "should not" see the Data of Arm Generated

