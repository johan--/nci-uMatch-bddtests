require_relative '../patient_message_loader'
require_relative '../match_test_data_manager'
require_relative '../../DataSetup/local_patient_data/Patient_06A_data_done'

Environment.setTier 'local' #set this value to 'local' if you are running tests on your local machine.

# patient_list = []
# patient_list << 'PT_VU17_TsShippedTwice'
# patient_list << 'PT_VU17_BdShippedTwice'

# MatchTestDataManager.delete_patients_from_seed(patient_list)
MatchTestDataManager.clear_all_local_tables
MatchTestDataManager.upload_all_seed_data_to_local
Auth0Token.force_generate_auth0_token('ADMIN')

# Patient06A.upload_patient('PT_VU17_PendingConfirmation')
# Patient06A.upload_patient('PT_VU17_PendingApproval')
# Patient06A.upload_patient('PT_VU17_TsShippedOffStudy')
# Patient06A.upload_patient('PT_VU17_TsShippedOffStudyBioExp')
# Patient06A.upload_patient('PT_VU17_TsSlideShipped')
# Patient06A.upload_patient('PT_VU17_TsShippedAssayReceived')
Patient06A.upload_patient('PT_VU17_TsVrConfirmed')
Patient06A.upload_patient('PT_VU17_TsVrRejected')
# Patient06A.upload_patient('PT_VU17_OnTreatmentArm')
# Patient06A.upload_patient('PT_VU17_ReqAssignment')
# Patient06A.upload_patient('PT_VU17_ReqNoAssignment')
# Patient06A.upload_patient('PT_VU17_NoTaAvailable')
# Patient06A.upload_patient('PT_VU17_CompassionateCare')

sleep 10
MatchTestDataManager.backup_all_local_db
