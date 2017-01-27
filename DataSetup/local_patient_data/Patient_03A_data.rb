require_relative '../patient_message_loader'
require_relative '../match_test_data_manager'


Environment.setTier 'local' #set this value to 'local' if you are running tests on your local machine.

MatchTestDataManager.clear_all_local_tables
MatchTestDataManager.upload_all_seed_data_to_local
Auth0Token.force_generate_auth0_token('ADMIN')

PatientMessageLoader.upload_start_with_wait_time(15)


pt = PatientDataSet.new('PT_SS02b_TsReceived')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)




PatientMessageLoader.upload_done
MatchTestDataManager.backup_all_patient_local_db