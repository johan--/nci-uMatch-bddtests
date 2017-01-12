require_relative '../patient_message_loader'
require_relative '../../DataSetup/dynamo_delete_script'
require_relative '../../DataSetup/dynamo_data_upload'
require_relative '../../DataSetup/match_test_data_manager'
require_relative 'Patient_99A_data_done'

Environment.setTier 'local' #set this value to 'local' if you are running tests on your local machine.

# MatchTestDataManager.delete_patients_from_seed(['PT_AU06_PendingConfirmation3'])
MatchTestDataManager.clear_all_local_tables
MatchTestDataManager.upload_all_seed_data_to_local

Auth0Token.force_generate_auth0_token('ADMIN')


pt = PatientDataSet.new('PT_AM04_TsReceived2')
PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCBRG1s')

sleep(10.0)
MatchTestDataManager.backup_all_local_db


