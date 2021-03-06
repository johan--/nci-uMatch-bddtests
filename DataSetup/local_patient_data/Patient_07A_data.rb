require_relative '../patient_message_loader'
require_relative '../../DataSetup/match_test_data_manager'
require_relative 'Patient_07A_data_done'

Environment.setTier 'local' #set this value to 'local' if you are running tests on your local machine.

# patient_list = []
# patient_list << 'PT_VC15_OneAssayAndVrReceived'
#
# MatchTestDataManager.delete_patients_from_seed(patient_list)
MatchTestDataManager.clear_all_local_tables
MatchTestDataManager.upload_seed_data_to_local('patients')
Auth0Token.force_generate_auth0_token('ADMIN')
# PatientTA.upload_patient('UL_CM02_TsShipped')
# Iondata.upload_patient('ION_AQ09_TsShipped')
# PatientTA.upload_patient('UI_PA09_TsVr52Uploaded')
# PatientTA.upload_patient('UI_PA08_PendingConfirmation')
Patient07A.upload_patient('PT_VC18_PendAppr3Assigns')
#
#
sleep(10.0)

# Patient99A.upload_patient('PT_AM03_PendingApproval')


MatchTestDataManager.backup_local_db('patients')
