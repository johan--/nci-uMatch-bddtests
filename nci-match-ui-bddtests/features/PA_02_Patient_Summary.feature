##
# Created by: Raseel Mohamed
#  Date: 06/24/2016
##

Feature: Patient Summary Page
  A user can see the summarized details about a particular patient

  Background:
    Given I stay logged in as "read_only" user

  @ui_p1
  Scenario: I can see the details of the patient
    When I navigate to the patients page
    And I enter "PT_CR02_OnTreatmentArm" in the patient filter field
    And I click on one of the patients
    And I collect the patient Api Information
    Then I am taken to the patient details page
    And I turn off synchronization
    And I should see Patient details breadcrumb
    And I should see the patient's information table
    And I should see the patient's disease information table
    And I should see the main tabs associated with the patient

  @ui_p3
  Scenario: I can see the details within the Summary tab of the patient
    When I go to patient "PT_CR02_OnTreatmentArm" details page
    And I collect the patient Api Information
    And I turn off synchronization
    Then I should see the "Summary" tab is active
    And I should see the patient's information match database
    And I should see the patient's disease information match the database
    And I should see the "Patient Timeline" section heading

  @ui_p2
  Scenario: I can see COG Message in Patient Timeline
    When I go to patient "UI_EM_OffStudy" details page
    Then I should see the "Summary" tab is active
    And I scroll to the bottom of the page
    And I should see the "Patient Timeline" section heading
    And I should see a message "COG Message: Patient is deceased." in the timeline

  @ui_p3
  Scenario Outline: Patient with status "<status>" <see_or_not> show TA
    When I go to patient "<patient>" details page
#    When His status is "<status>"
    Then I "<see_or_not>" see a Treatment Arm selected for the patient

    Examples:
      | patient                       | status                          | see_or_not |
      | PT_CR08_BloodSpecimenUploaded | REGISTRATION                    | should not |
      | PT_AU03_SlideShipped0         | TISSUE_SLIDE_SPECIMEN_SHIPPED   | should not |
      | PT_RA03_TsShipped             | TISSUE_NUCLEIC_ACID_SHIPPED     | should not |
      | PT_AS08_TissueReceived        | TISSUE_SPECIMEN_RECEIVED        | should not |
      | PT_AM05_TsVrReceived1         | TISSUE_VARIANT_REPORT_RECEIVED  | should not |
      | PT_AS12_VrConfirmed           | TISSUE_VARIANT_REPORT_CONFIRMED | should not |
      | PT_AM01_TsVrReceived1         | ASSAY_RESULTS_RECEIVED          | should not |
      | PT_AS09_OffStudy              | OFF_STUDY                       | should not |
      | PT_AS09_OffStudyBiopsyExpired | OFF_STUDY_BIOPSY_EXPIRED        | should not |
      | PT_AS09_ReqNoAssignment       | REQUEST_NO_ASSIGNMENT           | should not |
      | PT_SS26_RequestAssignment     | REQUEST_ASSIGNMENT              | should not |
      | PT_SS31_CompassionateCare     | COMPASSIONATE_CARE              | should not |
      | PT_SS31_NoTaAvailable         | NO_TA_AVAILABLE                 | should not |
      | PT_AS12_PendingConfirmation   | PENDING_CONFIRMATION            | should     |
      | PT_AM03_PendingApproval       | PENDING_APPROVAL                | should     |
      | PT_AS12_OnTreatmentArm        | ON_TREATMENT_ARM                | should     |
