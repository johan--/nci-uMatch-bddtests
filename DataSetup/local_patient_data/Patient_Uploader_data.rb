require_relative '../patient_message_loader'
require_relative '../local_patient_data/Patient_Uploader_data_done'
require_relative '../patient_message_loader'
require_relative '../../DataSetup/dynamo_delete_script'
require_relative '../../DataSetup/dynamo_data_upload'
require_relative '../../DataSetup/match_test_data_manager'



Environment.setTier 'local' #set this value to 'local' if you are running tests on your local machine.

# patient_list = []
# patient_list << 'UI_PA09_TsVr52Uploaded'
# #
# MatchTestDataManager.delete_patients_from_seed(patient_list)
MatchTestDataManager.clear_all_local_tables
MatchTestDataManager.upload_all_seed_data_to_local
Auth0Token.force_generate_auth0_token('ADMIN')
PatientUploader.upload_patient('UP_JWP01a_TsShippedToMda')
PatientUploader.upload_patient('UP_JWP01a_TsShippedToMocha')
#
sleep(10.0)

# Patient99A.upload_patient('PT_AM03_PendingApproval')


MatchTestDataManager.backup_all_local_db
