require_relative '../patient_message_loader'
require_relative '../../DataSetup/match_test_data_manager'
require_relative 'Patient_5xA_data_done'

Environment.setTier 'local' #set this value to 'local' if you are running tests on your local machine.
#
#
# MatchTestDataManager.clear_all_local_tables
# MatchTestDataManager.upload_all_seed_data_to_local
# # #
# Auth0Token.force_generate_auth0_token('ADMIN')
# Patient5xA.upload_patient('PT_SC04d_TwoAssay')
MatchTestDataManager.backup_all_local_db