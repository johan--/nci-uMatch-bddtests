require_relative '../patient_message_loader'
require_relative '../../DataSetup/dynamo_delete_script'
require_relative '../../DataSetup/dynamo_data_upload'
require_relative '../../DataSetup/match_test_data_manager'
require_relative 'Patient_99A_data_done'
require_relative 'Patient_TA_UI_data_done'
require_relative 'Ion_data_done'

Environment.setTier 'local' #set this value to 'local' if you are running tests on your local machine.

# MatchTestDataManager.delete_patients_from_seed(%w(UI_EM_OffStudy))
# MatchTestDataManager.clear_all_local_tables
# MatchTestDataManager.upload_all_seed_data_to_local
#
# Auth0Token.force_generate_auth0_token('ADMIN')
# PatientTA.upload_patient('UI_MA_PendingApproval')
# Iondata.upload_patient('PT_IR01_OnTreatmentArm')
# PatientTA.upload_patient('UI_PA08_MochaTsVrUploaded')
# PatientTA.upload_patient('UI_PA08_PendingConfirmation')
#
#
# # sleep(10.0)



MatchTestDataManager.backup_all_local_db


