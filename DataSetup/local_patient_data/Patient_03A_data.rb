require_relative '../patient_message_loader'
require_relative '../match_test_data_manager'
require_relative '../../DataSetup/local_patient_data/Patient_03A_data_done'


Environment.setTier 'local' #set this value to 'local' if you are running tests on your local machine.

MatchTestDataManager.clear_all_local_tables
MatchTestDataManager.upload_all_seed_data_to_local
Auth0Token.force_generate_auth0_token('ADMIN')

Patient03A.upload_patient('PT_SS28_BdReceived4')
Patient03A.upload_patient('PT_SS28_TsReceived6')
Patient03A.upload_patient('PT_SS28_TsReceived7')

sleep 10.0

MatchTestDataManager.backup_all_patient_local_db