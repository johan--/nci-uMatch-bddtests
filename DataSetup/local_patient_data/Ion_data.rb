require_relative '../patient_message_loader'
require_relative '../../DataSetup/match_test_data_manager'
require_relative '../../DataSetup/local_patient_data/Ion_data_done'


Environment.setTier 'local' #set this value to 'local' if you are running tests on your local machine.

tag = 'ion_reporter'
MatchTestDataManager.delete_patients_from_seed(%w(ION_AQ61_VrConfirmed), tag)
MatchTestDataManager.clear_all_local_tables
MatchTestDataManager.upload_seed_data_to_local(tag)

Auth0Token.force_generate_auth0_token('ADMIN')
# Patient5xA.upload_patient('PT_SC04b_PendingConfirmation')
Iondata.upload_patient('ION_AQ61_VrConfirmed')
sleep 10.0
MatchTestDataManager.backup_local_db(tag)