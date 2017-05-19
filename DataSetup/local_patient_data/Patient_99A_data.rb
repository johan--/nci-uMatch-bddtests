require_relative '../patient_message_loader'
require_relative '../../DataSetup/match_test_data_manager'
require_relative 'Patient_99A_data_done'
require_relative 'Patient_TA_UI_data_done'
require_relative 'Ion_data_done'
require_relative 'Patient_02A_data_done'
require_relative 'Patient_03A_data_done'
require_relative 'Patient_00A_data_done'

Environment.setTier 'local' #set this value to 'local' if you are running tests on your local machine.

tag = 'patients'
# patient_list = []
# patient_list << 'UI_PA09_TsVr52Uploaded'
# #
# MatchTestDataManager.delete_patients_from_seed(patient_list)
MatchTestDataManager.clear_all_local_tables
MatchTestDataManager.upload_seed_data_to_local(tag)
Auth0Token.force_generate_auth0_token('ADMIN')
# PatientTA.upload_patient('UL_CM02_TsShipped')
# Iondata.upload_patient('ION_AQ09_TsShipped')
# PatientTA.upload_patient('UI_PA09_TsVr52Uploaded')
# PatientTA.upload_patient('UI_PA08_PendingConfirmation')
Patient99A.upload_patient('PT_AM11_AssayVrCompCareReady')
Patient99A.upload_patient('PT_AM12_AssayVrNoTaReady')
#
#
sleep(10.0)

# Patient99A.upload_patient('PT_AM03_PendingApproval')


MatchTestDataManager.backup_local_db(tag)

