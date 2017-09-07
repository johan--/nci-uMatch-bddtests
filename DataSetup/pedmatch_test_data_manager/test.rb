require_relative 'seed_file'
require_relative 'ped_match_database'
require_relative 'ped_match_test_data'
require_relative 'patient_story'
require_relative 'constants'

pt = PatientStory.new('PT_VU19_BdVrConfirmed')
pt.create_seed_patient {
  pt.story_register
  pt.story_specimen_received_blood
  pt.story_specimen_shipped_blood
  pt.story_blood_variant_report
  pt.story_blood_vr_confirmed('reject')
  pt.story_specimen_received_tissue
  pt.story_specimen_shipped_tissue
}
PedMatchTestData.load_seed_patients(['PT_VU19_BdVrConfirmed'])


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