Feature: Treatment Arm details page show the details about the patient associated with that particular TA
@ui_p2
Scenario Outline: A patient on status <status> <see_or_not> see the Date Off Arm data generated
  Given I stay logged in as "read_only" user
  When I go to treatment arm with "APEC1621-A" as the id and "100" as stratum id
  And I enter "<patient_id>" in the all patients data filter field
  And His status in the all patients table is "<status>"
  Then I "<see_or_not>" see the Data of Arm Generated
  Examples:
    | patient_id                 | status                | see_or_not |
    | PT_SR10_ProgressReBioY     | PREVIOUSLY_ON_ARM     | should     |
    | PT_RA04a_TsShipped         | NOT_ENROLLED_ON_ARM   | should     |
    | PT_RA06_OnTreatmentArm     | ON_TREATMENT_ARM      | should not |
    | PT_OS03_OffStudy1          | PENDING_CONFIRMATION  | should not |
    | PT_SC04b_PendingApproval   | PENDING_APPROVAL      | should not |
    | PT_GVF_RequestNoAssignment | REQUEST_NO_ASSIGNMENT | should not |
    | PT_SC01c_TsVrUploadedStep2 | REQUEST_ASSIGNMENT    | should not |
