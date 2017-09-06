require_relative 'seed_file'
require_relative 'ped_match_database'
require_relative 'ped_match_test_data'
require_relative 'patient_story'
require_relative 'constants'

# pt = PatientStory.new('PT_SS26_OnTreatmentArm')
# pt.create_seed_patient {
#   pt.story_register
#   pt.story_specimen_received_blood
#   pt.story_specimen_received_tissue
#   pt.story_specimen_shipped_tissue
#   pt.story_specimen_shipped_slide
#   pt.story_tissue_variant_report
#   pt.story_assay('ICCPTENs')
#   pt.story_assay('ICCBAF47s')
#   pt.story_assay('ICCBRG1s')
#   pt.story_tissue_vr_confirmed
#   pt.story_assignment_confirmed
#   pt.story_on_treatment_arm('APEC1621-A', '100')
# }
PedMatchTestData.load_seed_patients(['PT_SS26_OnTreatmentArm','PT_SS26_BdVRRejected'])


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