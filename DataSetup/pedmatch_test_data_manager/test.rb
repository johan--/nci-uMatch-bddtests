require_relative 'seed_file'
require_relative 'ped_match_database'
require_relative 'ped_match_test_data'
require_relative 'patient_story'
require_relative 'constants'

pt = PatientStory.new('PT_VC16_BdVrTsReceived')
pt.create_seed_patient {
  pt.story_register
  pt.story_specimen_received_blood
  pt.story_specimen_shipped_blood
  pt.story_blood_variant_report
  pt.story_specimen_received_tissue
}
pt = PatientStory.new('PT_VC16_BdVrTsShipped')
pt.create_seed_patient {
  pt.story_register
  pt.story_specimen_received_blood
  pt.story_specimen_shipped_blood
  pt.story_blood_variant_report
  pt.story_specimen_received_tissue
  pt.story_specimen_shipped_tissue
}
pt = PatientStory.new('PT_VC16_BdVrSlideShipped')
pt.create_seed_patient {
  pt.story_register
  pt.story_specimen_received_blood
  pt.story_specimen_shipped_blood
  pt.story_blood_variant_report
  pt.story_specimen_received_tissue
  pt.story_specimen_shipped_tissue
  pt.story_specimen_shipped_slide
}
pt = PatientStory.new('PT_VC16_BdVrAssayReceived')
pt.create_seed_patient {
  pt.story_register
  pt.story_specimen_received_tissue
  pt.story_specimen_shipped_tissue
  pt.story_specimen_shipped_slide
  pt.story_specimen_received_blood
  pt.story_specimen_shipped_blood
  pt.story_blood_variant_report
  pt.story_assay('ICCPTENs')
  pt.story_assay('ICCBAF47s')
  pt.story_assay('ICCBRG1s')
}
pt = PatientStory.new('PT_VC16_BdVrTsVrReceived')
pt.create_seed_patient {
  pt.story_register
  pt.story_specimen_received_tissue
  pt.story_specimen_shipped_tissue
  pt.story_specimen_received_blood
  pt.story_specimen_shipped_blood
  pt.story_blood_variant_report
  pt.story_tissue_variant_report
}
pt = PatientStory.new('PT_VC16_BdVrTsVrConfirmed')
pt.create_seed_patient {
  pt.story_register
  pt.story_specimen_received_tissue
  pt.story_specimen_shipped_tissue
  pt.story_specimen_received_blood
  pt.story_specimen_shipped_blood
  pt.story_blood_variant_report
  pt.story_tissue_variant_report
  pt.story_tissue_vr_confirmed
}
pt = PatientStory.new('PT_VC16_BdVrTsVrRejected')
pt.create_seed_patient {
  pt.story_register
  pt.story_specimen_received_tissue
  pt.story_specimen_shipped_tissue
  pt.story_specimen_received_blood
  pt.story_specimen_shipped_blood
  pt.story_blood_variant_report
  pt.story_tissue_variant_report
  pt.story_tissue_vr_confirmed('reject')
}
pt = PatientStory.new('PT_VC16_BdVrPendingConfirmation')
pt.create_seed_patient {
  pt.story_register
  pt.story_specimen_received_tissue
  pt.story_specimen_shipped_tissue
  pt.story_specimen_shipped_slide
  pt.story_specimen_received_blood
  pt.story_specimen_shipped_blood
  pt.story_blood_variant_report
  pt.story_assay('ICCPTENs')
  pt.story_assay('ICCBAF47s')
  pt.story_assay('ICCBRG1s')
  pt.story_tissue_variant_report
  pt.story_tissue_vr_confirmed
}
pt = PatientStory.new('PT_VC16_BdVrPendingApproval')
pt.create_seed_patient {
  pt.story_register
  pt.story_specimen_received_tissue
  pt.story_specimen_shipped_tissue
  pt.story_specimen_shipped_slide
  pt.story_specimen_received_blood
  pt.story_specimen_shipped_blood
  pt.story_blood_variant_report
  pt.story_assay('ICCPTENs')
  pt.story_assay('ICCBAF47s')
  pt.story_assay('ICCBRG1s')
  pt.story_tissue_variant_report
  pt.story_tissue_vr_confirmed
  pt.story_assignment_confirmed
}

pt = PatientStory.new('PT_VC16_BdVrOnTreatmentArm')
pt.create_seed_patient {
  pt.story_register
  pt.story_specimen_received_tissue
  pt.story_specimen_shipped_tissue
  pt.story_specimen_shipped_slide
  pt.story_specimen_received_blood
  pt.story_specimen_shipped_blood
  pt.story_blood_variant_report
  pt.story_assay('ICCPTENs')
  pt.story_assay('ICCBAF47s')
  pt.story_assay('ICCBRG1s')
  pt.story_tissue_variant_report
  pt.story_tissue_vr_confirmed
  pt.story_assignment_confirmed
  pt.story_on_treatment_arm('APEC1621-A', '100')
}

pt = PatientStory.new('PT_VC16_BdVrReqAssignment')
pt.create_seed_patient {
  pt.story_register
  pt.story_specimen_received_tissue
  pt.story_specimen_shipped_tissue
  pt.story_specimen_shipped_slide
  pt.story_specimen_received_blood
  pt.story_specimen_shipped_blood
  pt.story_blood_variant_report
  pt.story_assay('ICCPTENs')
  pt.story_assay('ICCBAF47s')
  pt.story_assay('ICCBRG1s')
  pt.story_tissue_variant_report
  pt.story_tissue_vr_confirmed
  pt.story_assignment_confirmed
  pt.story_on_treatment_arm('APEC1621-A', '100')
  pt.story_request_assignment('Y')
}

pt = PatientStory.new('PT_VC16_BdVrOffStudy')
pt.create_seed_patient {
  pt.story_register
  pt.story_specimen_received_blood
  pt.story_specimen_shipped_blood
  pt.story_blood_variant_report
  pt.story_off_study
}

pt = PatientStory.new('PT_AS12b_NoVr3Assay')
pt.create_seed_patient {
  pt.story_register
  pt.story_specimen_received_tissue
  pt.story_specimen_shipped_tissue
  pt.story_specimen_shipped_slide
  pt.story_specimen_received_blood
  pt.story_specimen_shipped_blood
  pt.story_blood_variant_report
  pt.story_assay('ICCPTENs')
  pt.story_assay('ICCBAF47s')
  pt.story_assay('ICCBRG1s')
}

pt = PatientStory.new('PT_AS12b_VrReceived3Assay')
pt.create_seed_patient {
  pt.story_register
  pt.story_specimen_received_tissue
  pt.story_specimen_shipped_tissue
  pt.story_specimen_shipped_slide
  pt.story_specimen_received_blood
  pt.story_specimen_shipped_blood
  pt.story_blood_variant_report
  pt.story_assay('ICCPTENs')
  pt.story_assay('ICCBAF47s')
  pt.story_assay('ICCBRG1s')
  pt.story_tissue_variant_report
}

pt = PatientStory.new('PT_AS12b_VrConfirmed3Assay')
pt.create_seed_patient {
  pt.story_register
  pt.story_specimen_received_tissue
  pt.story_specimen_shipped_tissue
  pt.story_specimen_shipped_slide
  pt.story_specimen_received_blood
  pt.story_specimen_shipped_blood
  pt.story_blood_variant_report
  pt.story_assay('ICCPTENs')
  pt.story_assay('ICCBAF47s')
  pt.story_assay('ICCBRG1s')
  pt.story_tissue_variant_report
  pt.story_tissue_vr_confirmed
}

pt = PatientStory.new('PT_AS12b_RbRequestedNoAssay')
pt.create_seed_patient {
  pt.story_register
  pt.story_specimen_received_tissue
  pt.story_specimen_shipped_tissue
  pt.story_specimen_shipped_slide
  pt.story_specimen_received_blood
  pt.story_specimen_shipped_blood
  pt.story_blood_variant_report
  pt.story_tissue_variant_report
  pt.story_tissue_vr_confirmed
}

pt = PatientStory.new('PT_AS12b_RbRequested2Assay')
pt.create_seed_patient {
  pt.story_register
  pt.story_specimen_received_tissue
  pt.story_specimen_shipped_tissue
  pt.story_specimen_shipped_slide
  pt.story_specimen_received_blood
  pt.story_specimen_shipped_blood
  pt.story_blood_variant_report
  pt.story_assay('ICCPTENs')
  pt.story_assay('ICCBRG1s')
  pt.story_tissue_variant_report
  pt.story_tissue_vr_confirmed
}

pt = PatientStory.new('PT_AS12b_RbRequest3Assay')
pt.create_seed_patient {
  pt.story_register
  pt.story_specimen_received_tissue
  pt.story_specimen_shipped_tissue
  pt.story_specimen_shipped_slide
  pt.story_specimen_received_blood
  pt.story_specimen_shipped_blood
  pt.story_blood_variant_report
  pt.story_assay('ICCPTENs')
  pt.story_assay('ICCBAF47s')
  pt.story_assay('ICCBRG1s')
  pt.story_tissue_variant_report
  pt.story_tissue_vr_confirmed
}

list = []
list << 'PT_VC16_BdVrTsReceived'
list << 'PT_VC16_BdVrTsShipped'
list << 'PT_VC16_BdVrSlideShipped'
list << 'PT_VC16_BdVrAssayReceived'
list << 'PT_VC16_BdVrTsVrReceived'
list << 'PT_VC16_BdVrTsVrConfirmed'
list << 'PT_VC16_BdVrTsVrRejected'
list << 'PT_VC16_BdVrPendingConfirmation'
list << 'PT_VC16_BdVrPendingApproval'
list << 'PT_VC16_BdVrOnTreatmentArm'
list << 'PT_VC16_BdVrReqAssignment'
list << 'PT_VC16_BdVrOffStudy'
list << 'PT_AS12b_NoVr3Assay'
list << 'PT_AS12b_VrReceived3Assay'
list << 'PT_AS12b_VrConfirmed3Assay'
list << 'PT_AS12b_RbRequestedNoAssay'
list << 'PT_AS12b_RbRequested2Assay'
list << 'PT_AS12b_RbRequest3Assay'


PedMatchTestData.load_seed_patients(list)


# pt = PatientStory.new('PT_Test1')
# pt.create_temporary_patient{
#   pt.story_specimen_shipped_tissue('MoCha', 'current', 'PT_Test1_MOI1', 'PT_Test1_SEI1')
# }
# PedMatchTestData.use_uat_tier
# PedMatchTestData.send_a_patient_story(pt)

# PedMatchDatabase.reload_local
# PedMatchDatabase.backup_ion('ion_reporter')
# PedMatchDatabase.backup('demo')
# string = File.read('./delete.json')
# h = JSON.parse(string)
# h.each {|o| puts o['patient_id']
# puts o['current_status']
# puts "\n\n"}

# PedMatchDatabase.load_int_to_local