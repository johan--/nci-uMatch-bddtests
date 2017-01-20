require_relative '../patient_message_loader'
require_relative '../../DataSetup/dynamo_delete_script'
require_relative '../../DataSetup/dynamo_data_upload'
require_relative '../../DataSetup/match_test_data_manager'
require_relative 'Patient_99A_data_done'
require_relative 'Patient_TA_UI_data_done'

Environment.setTier 'local' #set this value to 'local' if you are running tests on your local machine.

# MatchTestDataManager.delete_patients_from_seed(%w(PT_CR01_PathAssayDoneVRUploadedToConfirm PT_CR02_OnTreatmentArm PT_CR04_VRUploadedAssayReceived))
# MatchTestDataManager.clear_all_local_tables
# MatchTestDataManager.upload_all_seed_data_to_local

# Auth0Token.force_generate_auth0_token('ADMIN')

# PatientTA.upload_patient('PT_CR01_PathAssayDoneVRUploadedToConfirm')
# PatientTA.upload_patient('PT_CR02_OnTreatmentArm')
# PatientTA.upload_patient('PT_CR04_VRUploadedAssayReceived')


# sleep(10.0)
MatchTestDataManager.backup_all_local_db


