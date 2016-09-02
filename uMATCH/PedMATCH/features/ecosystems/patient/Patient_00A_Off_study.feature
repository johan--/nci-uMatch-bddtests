#encoding: utf-8
@patients @patients_off_study
Feature: Patient off_study message
  Scenario Outline: PT_OS01. patient can be set to OFF_STUDY status from any status
    Given template off study message for patient: "<patient_id>" the off study type is "<off_study_type>"
    When post to MATCH patients service, returns a message that includes "Message has been processed successfully" with status "Success"
    Examples:
    |patient_id             |off_study_type           |
    |PT_OS01_Registered     |OFF_STUDY_DECEASED       |
    |PT_OS01_TsReceived     |OFF_STUDY_DECEASED       |
    |PT_OS01_BdReceived     |OFF_STUDY_DECEASED       |
    |PT_OS01_TsShipped      |OFF_STUDY_DECEASED       |
    |PT_OS01_BdShipped      |OFF_STUDY_DECEASED       |
    |PT_OS01_AssayReceived  |OFF_STUDY_DECEASED       |
    |PT_OS01_PathoConfirmed |OFF_STUDY_DECEASED       |
    |PT_OS01_TsVrReceived   |OFF_STUDY_DECEASED       |
    |PT_OS01_BdVrReceived   |OFF_STUDY_DECEASED       |
    |PT_OS01_TsVrConfirmed  |OFF_STUDY_DECEASED       |
    |PT_OS01_BdVrConfirmed  |OFF_STUDY_DECEASED       |
    |PT_OS01_TsVrRejected   |OFF_STUDY_DECEASED       |
    |PT_OS01_BdVrRejected   |OFF_STUDY_DECEASED       |
    |PT_OS01_WaitingPtData  |OFF_STUDY_DECEASED       |
    |PT_OS01_PendingApproval|OFF_STUDY_DECEASED       |
    |PT_OS01_Progression    |OFF_STUDY_DECEASED       |
    |PT_OS01_OnTreatmentArm |OFF_STUDY_DECEASED       |