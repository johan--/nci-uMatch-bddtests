require_relative '../patient_message_loader'
require_relative '../../DataSetup/match_test_data_manager'
require_relative 'Patient_04A_data_done'

Environment.setTier 'local' #set this value to 'local' if you are running tests on your local machine.

# patient_list = []
# patient_list << 'PT_AM03_PendingApproval'

# MatchTestDataManager.delete_patients_from_seed(patient_list)
# MatchTestDataManager.clear_all_local_tables
# MatchTestDataManager.upload_all_seed_data_to_local
# #
# Auth0Token.force_generate_auth0_token('ADMIN')

# Patient04A.upload_patient('PT_AS08_TsReceivedStep2')
# Patient04A.upload_patient('PT_AS09_ReqNoAssignment')
# Patient04A.upload_patient('PT_AS09_OffStudy')
# Patient04A.upload_patient('PT_AS09_OffStudyBiopsyExpired')
# Patient04A.upload_patient('PT_AS12_PendingConfirmation')
# Patient04A.upload_patient('PT_AS12_PendingApproval')
# Patient04A.upload_patient('PT_AS12_OnTreatmentArm')
#
#
# # sleep(10.0)


MatchTestDataManager.backup_all_local_db