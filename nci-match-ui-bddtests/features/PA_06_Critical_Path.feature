##
# Created by: Raseel Mohamed
#  Date: 08/31/2016
##
@critical
Feature: These are the critical path test cases.

  @ui_p2
  Scenario: User can see all the amois associated with the patient and matches the table
    Given I stay logged in as "VR_Reviewer_mda" user
    When I go to the patient "PT_VC00_CnvVrReceived" with variant report "PT_VC00_CnvVrReceived_ANI1"
    Then I can see the variant report page
    Then I see that Total MOIs match the number of MOIs on the page
    And I see that the Total aMOIs match the number of aMOIs on the page.
    And I get the Total confirmed MOIs on the page
    And I get the Total confirmed aMOIs on the page
    And I see that the Total Confirmed MOIs match the number of MOIs on the page
#      And I see that the Total Confirmed aMOIs match the number of aMOIs on the page

  @ui_p1
  Scenario: User can can see and click on a variant report and should be able to access the variant report page.
    Given I am logged in as a "VR_Reviewer_mda" user
    When I go to patient "PT_CR04_VRUploadedAssayReceived" details page
    Then I am taken to the patient details page
    And I click on the "Surgical Event PT_CR04_VRUploadedAssayReceived_SEI1" tab
    Then I should see the variant report link for "PT_CR04_VRUploadedAssayReceived_ANI1"
    And I click the variant report link for "PT_CR04_VRUploadedAssayReceived_ANI1"
    Then I can see the variant report page

  @ui_p1
  Scenario: User can see that all the variants are confirmed by default
    Given I stay logged in as "VR_Reviewer_mda" user
    When I go to the patient "PT_CR04_VRUploadedAssayReceived" with variant report "PT_CR04_VRUploadedAssayReceived_ANI1"
    Then I can see the variant report page
    Then I see that all the variant check boxes are selected

  @ui_p1
  Scenario: Variant rejection is not allowed without a comment
    Given I stay logged in as "VR_Reviewer_mda" user
    When I go to the patient "PT_CR04_VRUploadedAssayReceived" with variant report "PT_CR04_VRUploadedAssayReceived_ANI1"
    Then I can see the variant report page
    And I uncheck the variant of ordinal "1"
    Then I "should" see the confirmation modal pop up
    And The "OK" button is "disabled"
    When I click on the "Cancel" button
    Then I "should not" see the confirmation modal pop up
    Then The variant at ordinal "1" is "checked"

  @ui_p1
  Scenario: Variant rejection is allowed if a comment is added and one can still cancel the process.
    Given I stay logged in as "VR_Reviewer_mda" user
    When I go to the patient "PT_CR04_VRUploadedAssayReceived" with variant report "PT_CR04_VRUploadedAssayReceived_ANI1"
    Then I can see the variant report page
    Then I uncheck the variant of ordinal "1"
    And I enter the comment "This is a comment" in the modal text box
    And The "OK" button is "enabled"
    When I click on the "Cancel" button
    Then The variant at ordinal "1" is "checked"

  @ui_p1
  Scenario: If a variant is rejected the comments are stored and visible on the front end
    Given I stay logged in as "VR_Reviewer_mda" user
    When I go to the patient "PT_CR04_VRUploadedAssayReceived" with variant report "PT_CR04_VRUploadedAssayReceived_ANI1"
    Then I can see the variant report page
    And I uncheck the variant of ordinal "1"
    And I enter the comment "This is a comment" in the modal text box
    And The "OK" button is "enabled"
    When I click on the "OK" button
    Then The variant at ordinal "1" is "unchecked"
    When I click on the comment link at ordinal "1"
    Then I can see the "This is a comment" in the modal text box
    And I click on the "OK" button

  @ui_p1
  Scenario: Rejecting a variant will be noted in the backend and will change the number of confirmed mois
    Given I stay logged in as "VR_Reviewer_mda" user
    When I go to the patient "PT_CR06_RejectOneVariant" with variant report "PT_CR06_RejectOneVariant_ANI1"
    And I collect information about the patient variant report
    Then I can see the variant report page
    And I get the Total confirmed MOIs on the page
    When I note the ID of the variant at ordinal "1"
    Then I verify that the status of confirmation of that ID is "confirmed"
    When I uncheck the variant of ordinal "1"
    And I enter the comment "This is a comment" in the modal text box
    When I click on the "OK" button
    When I collect information about the patient variant report
    Then I verify that the status of confirmation of that ID is "rejected"
    And I go to the patient "PT_CR06_RejectOneVariant" with variant report "PT_CR06_RejectOneVariant_ANI1"
    Then The total number of confirmed MOI has "decreased" by "1"

  @ui_p1
  Scenario: Confirming a variant report will update the status of the report and also inform the activity feed on both dashboard and patient page.
    Given I stay logged in as "VR_Reviewer_mda" user
    When I go to the patient "PT_CR03_VRUploadedPathConfirmed" with variant report "PT_CR03_VRUploadedPathConfirmed_ANI1"
    Then I can see the variant report page
    And I scroll to the bottom of the page
    And I click on the "CONFIRM" button
    Then I "should" see the confirmation modal pop up
    When I click on the "OK" button
    Then The variant report status is marked "CONFIRMED"

  @broken
  Scenario: A Mocha user can confirm a MoCha variant report.
    Given I am logged in as a "VR_Reviewer_mocha" user
    When I go to the patient "mocha_patient" with variant report "mocha_report"
    Then I can see the variant report page
    And I click on the "CONFIRM" button
    Then I "should" see the confirmation modal pop up
    When I click on the "OK" button
    Then The variant report status is marked "CONFIRMED"
    Then I logout

  @ui_p1
  Scenario: Confirmed variant report will not have check boxes enabled
    Given I stay logged in as "VR_Reviewer_mda" user
    When I go to the patient "PT_AS12_PendingConfirmation" with variant report "PT_AS12_PendingConfirmation_ANI1"
    Then I can see the variant report page
    And The checkboxes are disabled
    And I "should not" see the "REJECT" button on the VR page
    And I "should not" see the "CONFIRM" button on the VR page

  @ui_p1
  Scenario: Confirmation of variant report will update the status on the patient as well as on the dashboard timeline.
    Given I stay logged in as "VR_Reviewer_mda" user
    When I go to patient "PT_CR03_VRUploadedPathConfirmed" details page
    Then I see the confirmation message in the Patient activity feed as "CONFIRMED" for "Analysis ID: PT_CR03_VRUploadedPathConfirmed_ANI1"
    When I navigate to the dashboard page
    Then I see the confirmation message in the Dashboard activity feed as "CONFIRMED" for "Analysis ID: PT_CR03_VRUploadedPathConfirmed_ANI1"

  @ui_p1
  Scenario: Rejecting a report will update the status of the report
    Given I stay logged in as "VR_Reviewer_mda" user
    When I go to the patient "PT_CR07_RejectVariantReport" with variant report "PT_CR07_RejectVariantReport_ANI1"
    Then I can see the variant report page
    And I scroll to the bottom of the page
    And I click on the "REJECT" button
    Then I "should" see the confirmation modal pop up
    And I enter the comment "This is a comment" in the VR modal text box
    When I click on the "OK" button
    Then I "should not" see the confirmation modal pop up
    Then The variant report status is marked "REJECTED"

  @ui_p1
  Scenario: Rejecting a report will disable checkboxes and other buttons to change the status of the report
    Given I stay logged in as "VR_Reviewer_mda" user
    When I go to the patient "PT_CR07_RejectVariantReport" with variant report "PT_CR07_RejectVariantReport_ANI1"
    Then I can see the variant report page
    And The checkboxes are disabled
    And Total confirmed MOIs and aMOIs are now '0'
    And I "should not" see the "REJECT" button on the VR page
    And I "should not" see the "CONFIRM" button on the VR page

  @ui_p1
  Scenario: Rejecting a report will update the patient and dashboard timeline
    Given I stay logged in as "VR_Reviewer_mda" user
    When I go to patient "PT_CR07_RejectVariantReport" details page
    Then I see the confirmation message in the Patient activity feed as "REJECTED" for "Analysis ID: PT_CR07_RejectVariantReport_ANI1"
    When I navigate to the dashboard page
    Then I see the confirmation message in the Dashboard activity feed as "REJECTED" for "Analysis ID: PT_CR07_RejectVariantReport_ANI1"

  @ui_p1
  Scenario: Confirming a variant report updates the status to Pending Confirmation if Pathology is present
    Given I stay logged in as "VR_Reviewer_mda" user
    When I go to the patient "PT_CR01_PathAssayDoneVRUploadedToConfirm" with variant report "PT_CR01_PathAssayDoneVRUploadedToConfirm_ANI1"
    Then I can see the variant report page
    And I scroll to the bottom of the page
    And I click on the "CONFIRM" button
    Then I "should" see the confirmation modal pop up
    When I click on the "OK" button
    Then The variant report status is marked "CONFIRMED"
    And I wait for "59" seconds
    When I go to patient "PT_CR01_PathAssayDoneVRUploadedToConfirm" details page
    Then I "should" see the patient "Status" as "PENDING_CONFIRMATION"
    Then I logout

  @ui_p1
  Scenario: Assignment link is provided on the Surgical Event Tab
    Given I am logged in as a "AR_Reviewer" user
    When I go to patient "PT_CR01_PathAssayDoneVRUploadedToConfirm" details page
    And I click on the "Surgical Event PT_CR01_PathAssayDoneVRUploadedToConfirm_SEI1" tab
    Then I should see the assignment report link for "PT_CR01_PathAssayDoneVRUploadedToConfirm_ANI1"
    When I click on the assignment report link
    Then I can see the assignment report page "Assignment Report - PENDING"

  @ui_p2
  Scenario: Assignment report should provide information regarding the assignment
    Given I stay logged in as "AR_Reviewer" user
    When I go to patient "PT_CR01_PathAssayDoneVRUploadedToConfirm" details page
    And I get the link to "PT_CR01_PathAssayDoneVRUploadedToConfirm_ANI1" assignment report
    And I navigate to the Assignment Report
    And I collect information about the assignment
    And I can see the top level details about assignment report
    And I can see the selected Treatment arm id "APEC1621-A" and stratum "100" and version "2015-08-06" in a box with reason
    And I can see the Assignment Logic section
    And I can see the selected treatment arm and the reason
    And The Types of Logic is the same as the backend
    And I "should" see the Assignment report "CONFIRM" button

  @ui_p1
  Scenario: Confirming the assignment report updates the status
    Given I stay logged in as "AR_Reviewer" user
    When I go to patient "PT_CR01_PathAssayDoneVRUploadedToConfirm" details page
    And I get the link to "PT_CR01_PathAssayDoneVRUploadedToConfirm_ANI1" assignment report
    And I navigate to the Assignment Report
    And I wait for "10" seconds
    And I click on the Assignment report "CONFIRM" button
    Then I "should" see the confirmation modal pop up
    When I click on the "OK" button
    Then I "should not" see the confirmation modal pop up
    And I "should not" see the Assignment report "CONFIRM" button
    When I go to patient "PT_CR01_PathAssayDoneVRUploadedToConfirm" details page
    Then I "should" see the patient "Status" as "PENDING_APPROVAL"
    # And I "should" see the patient "Treatment Arm Id" as "APEC1621-A"
    # And I "should" see the patient "Stratum Id" as "100"
    # And I "should" see the patient "Version" as "2015-08-06"

  @ui_p2
    Scenario: Arm Suspended Exclusion must explicitly call out the reason as the Arm was suspended
    Given I stay logged in as "AR_Reviewer" user
    When I go to patient "PT_CR01_PathAssayDoneVRUploadedToConfirm" details page
    And I get the link to "PT_CR01_PathAssayDoneVRUploadedToConfirm_ANI1" assignment report
    And I navigate to the Assignment Report
    And I get to the row heading that says "ARM_SUSPENDED_EXCLUSION"
    Then I see the first row after has the message description "but it is in a SUSPENDED state"

  @ui_p1
  Scenario: Confirmed Assignment Report updates information on the Assignment report section of the patient
    Given I stay logged in as "AR_Reviewer" user
    When I go to patient "PT_CR01_PathAssayDoneVRUploadedToConfirm" details page
    And I get the link to "PT_CR01_PathAssayDoneVRUploadedToConfirm_ANI1" assignment report
    And I navigate to the Assignment Report
    When I collect information about the assignment
    Then I can see more new top level details about assignment report
    Then I logout

  @ui_p1
  Scenario: As a privileged Dartmouth Sender I can upload a sample file
    Given I clear the file from S3 under reporter "IR_DTM00", mol_id "PT_UI04_DtmTsShipped1_MOI1", analysis_id "PT_UI04_DtmTsShipped1_An123"
    And I am logged in as a "VR_Sender_dartmouth" user
    When I go to patient "PT_UI04_DtmTsShipped1" with surgical event "PT_UI04_DtmTsShipped1_SEI1"
    And I scroll to the bottom of the page
    And I can see that some files have not been uploaded for the Surgical Event
    Then The "Upload new sample file" link is "visible"
    And The "Upload new sample file" link is "enabled"
    And I can click on the "Upload new sample file" link
    And I can see the "Upload BAM files and Variant ZIP files" dialog
    And The "Start Upload" button looks "disabled"
    And The "Close" button looks "enabled"
    Then I select an Ion Reporter "dartmouth - IR_DTM00"
    And I enter Analysis ID "PT_UI04_DtmTsShipped1_An123"
    And I make all elements visible
    And I press "Select Variant ZIP File" file button to upload "vcf_sample.zip" file
    And I press "Select DNA BAM File" file button to upload "dna_sample.bam" file
    And I press "Select cDNA BAM File" file button to upload "rna_sample.bam" file
    Then The "Start Upload" button looks "enabled"
    And The "Stop Upload and Close" button looks "enabled"
    Then I can click on the "Start Upload" button
    And I wait for "5" seconds
    And I verify that file "vcf_sample.zip" has completed upload
    And I verify that file "dna_sample.bam" has completed upload
    And I verify that file "rna_sample.bam" has completed upload
