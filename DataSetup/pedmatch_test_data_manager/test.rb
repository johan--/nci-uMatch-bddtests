require_relative 'seed_file'
require_relative 'ped_match_database'
require_relative 'ped_match_test_data'
require_relative 'patient_story'
require_relative 'constants'

# pt = PatientStory.new('PT_AS15_AssayReceived')
# pt.create_seed_patient {
#   pt.story_register
#   pt.story_specimen_received_tissue
#   pt.story_specimen_shipped_slide('2017-08-05T10:42:13+00:00')
#   pt.story_assay('ICCPTENs', 'POSITIVE', '2017-08-06T10:42:13+00:00')
#   pt.story_assay('ICCBAF47s', 'POSITIVE', '2017-08-06T10:43:13+00:00')
#   pt.story_assay('ICCBRG1s', 'POSITIVE', '2017-08-06T10:44:13+00:00')
# }
PedMatchTestData.load_seed_patients(['PT_AS15_AssayReceived'])


# pt = PatientStory.new('PT_Test1')
# pt.create_temporary_patient{
#   pt.story_specimen_shipped_tissue('MoCha', 'current', 'PT_Test1_MOI1', 'PT_Test1_SEI1')
# }
# PedMatchTestData.use_uat_tier
# PedMatchTestData.send_a_patient_story(pt)

# PedMatchDatabase.reload_local('ion_reporter')
# PedMatchDatabase.backup_ion('ion_reporter')
# PedMatchDatabase.backup('demo')
# string = File.read('./delete.json')
# h = JSON.parse(string)
# h.each {|o| puts o['patient_id']
# puts o['current_status']
# puts "\n\n"}

# PedMatchDatabase.load_int_to_local