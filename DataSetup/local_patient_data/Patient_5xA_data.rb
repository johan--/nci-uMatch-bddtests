require_relative '../patient_message_loader'
require_relative '../../DataSetup/match_test_data_manager'
require_relative 'Patient_5xA_data_done'

Environment.setTier 'local' #set this value to 'local' if you are running tests on your local machine.

tag = 'patients'
# MatchTestDataManager.delete_patients_from_seed(%w(PT_SC02h_TsVrUploaded))
MatchTestDataManager.clear_all_local_tables
MatchTestDataManager.upload_seed_data_to_local(tag)

Auth0Token.force_generate_auth0_token('ADMIN')
# Patient5xA.upload_patient('PT_SC04b_PendingConfirmation')
Patient5xA.upload_patient('PT_SC04l_PendingConfirmation')
sleep 10.0
MatchTestDataManager.backup_local_db(tag)