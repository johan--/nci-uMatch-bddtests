require_relative 'seed_file'
require_relative 'ped_match_database'
require_relative 'ped_match_test_data'
require_relative 'patient_story'
require_relative 'constants'

pt = PatientStory.new('PT_VU20_BdVrUploaded')
pt.create_seed_patient {
  pt.story_register
  pt.story_specimen_received_blood
  pt.story_specimen_shipped_blood
  pt.story_blood_variant_report
}
pt = PatientStory.new('PT_VU20_BdVrRejected')
pt.create_seed_patient {
  pt.story_register
  pt.story_specimen_received_blood
  pt.story_specimen_shipped_blood
  pt.story_blood_variant_report
  pt.story_blood_vr_confirmed('reject')
}
pt = PatientStory.new('PT_VU20_BdVrConfirmed')
pt.create_seed_patient {
  pt.story_register
  pt.story_specimen_received_blood
  pt.story_specimen_shipped_blood
  pt.story_blood_variant_report
  pt.story_blood_vr_confirmed
}
pt = PatientStory.new('PT_VU20_PendingConfirmation')
pt.create_seed_patient {
  pt.story_register
  pt.story_specimen_received_blood
  pt.story_specimen_shipped_blood
  pt.story_specimen_received_tissue
  pt.story_specimen_shipped_tissue
  pt.story_specimen_shipped_slide
  pt.story_tissue_variant_report
  pt.story_assay('ICCPTENs')
  pt.story_assay('ICCBAF47s')
  pt.story_assay('ICCBRG1s')
  pt.story_tissue_vr_confirmed
}
pt = PatientStory.new('PT_VU20_PendingApproval')
pt.create_seed_patient {
  pt.story_register
  pt.story_specimen_received_blood
  pt.story_specimen_shipped_blood
  pt.story_specimen_received_tissue
  pt.story_specimen_shipped_tissue
  pt.story_specimen_shipped_slide
  pt.story_tissue_variant_report
  pt.story_assay('ICCPTENs')
  pt.story_assay('ICCBAF47s')
  pt.story_assay('ICCBRG1s')
  pt.story_tissue_vr_confirmed
  pt.story_assignment_confirmed
}
pt = PatientStory.new('PT_VU20_OnTreatmentArm')
pt.create_seed_patient {
  pt.story_register
  pt.story_specimen_received_blood
  pt.story_specimen_shipped_blood
  pt.story_specimen_received_tissue
  pt.story_specimen_shipped_tissue
  pt.story_specimen_shipped_slide
  pt.story_tissue_variant_report
  pt.story_assay('ICCPTENs')
  pt.story_assay('ICCBAF47s')
  pt.story_assay('ICCBRG1s')
  pt.story_tissue_vr_confirmed
  pt.story_assignment_confirmed
  pt.story_on_treatment_arm('APEC1621-A', '100')
}
pt = PatientStory.new('PT_VU20_RequestAssignment')
pt.create_seed_patient {
  pt.story_register
  pt.story_specimen_received_blood
  pt.story_specimen_shipped_blood
  pt.story_specimen_received_tissue
  pt.story_specimen_shipped_tissue
  pt.story_specimen_shipped_slide
  pt.story_tissue_variant_report
  pt.story_assay('ICCPTENs')
  pt.story_assay('ICCBAF47s')
  pt.story_assay('ICCBRG1s')
  pt.story_tissue_vr_confirmed
  pt.story_assignment_confirmed
  pt.story_on_treatment_arm('APEC1621-A', '100')
  pt.story_request_assignment('Y')
}
pt = PatientStory.new('PT_VU20_TsVrConfirmed')
pt.create_seed_patient {
  pt.story_register
  pt.story_specimen_received_blood
  pt.story_specimen_shipped_blood
  pt.story_specimen_received_tissue
  pt.story_specimen_shipped_tissue
  pt.story_tissue_variant_report
  pt.story_tissue_vr_confirmed
}
pt = PatientStory.new('PT_VU20_OffStudy')
pt.create_seed_patient {
  pt.story_register
  pt.story_specimen_received_blood
  pt.story_specimen_shipped_blood
  pt.story_off_study
}
PedMatchTestData.load_seed_patients(['PT_VU20_BdVrUploaded', 'PT_VU20_BdVrConfirmed', 'PT_VU20_BdVrRejected','PT_VU20_OffStudy','PT_VU20_TsVrConfirmed','PT_VU20_PendingConfirmation','PT_VU20_PendingApproval','PT_VU20_OnTreatmentArm', 'PT_VU20_RequestAssignment'])


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