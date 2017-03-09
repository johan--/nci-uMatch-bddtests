require_relative '../patient_message_loader'
require_relative '../match_test_data_manager'
require_relative '../../DataSetup/local_patient_data/Patient_06A_data_done'

Environment.setTier 'local' #set this value to 'local' if you are running tests on your local machine.

MatchTestDataManager.clear_all_local_tables
MatchTestDataManager.upload_all_seed_data_to_local
Auth0Token.force_generate_auth0_token('ADMIN')

Patient06A.upload_patient('PT_VU17_TsShippedTwice')
Patient06A.upload_patient('PT_VU17_BdShippedTwice')
Patient06A.upload_patient('PT_VU17_TsVrUploaded')
Patient06A.upload_patient('PT_VU17_BdVrUploaded')
Patient06A.upload_patient('PT_VU17_TsVrUploadedStep2')

sleep 10
MatchTestDataManager.backup_all_patient_local_db
