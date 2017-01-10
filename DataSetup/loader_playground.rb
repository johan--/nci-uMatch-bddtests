require_relative 'patient_message_loader'
require_relative 'treatment_arm_message_loader'
require_relative 'match_test_data_manager'



# puts Auth0Token.force_generate_auth0_token 'ADMIN'

# ############clear local dynamodb and load all existing seed data
MatchTestDataManager.clear_all_local_tables
MatchTestDataManager.upload_all_seed_data_to_local





#################backup the just generated local db
# MatchTestDataManager.backup_all_local_db
# MatchTestDataManager.backup_all_patient_local_db
# MatchTestDataManager.backup_all_ion_local_db
# MatchTestDataManager.backup_all_ta_local_db




############clear aws dynamodb and load all seed data
# MatchTestDataManager.clear_all_int_tables
# MatchTestDataManager.upload_all_seed_data_to_int



# MatchTestDataManager.delete_patients_from_seed('patient_id')




# /api/v1/patients/statistics(.:format)
# /api/v1/patients/pending_items(.:format)
# /api/v1/patients/amois(.:format)
# /api/v1/patients/events(.:format)
# /api/v1/patients/variant_reports(.:format)
# /api/v1/patients/variants(.:format)
# /api/v1/patients/assignments(.:format)
# /api/v1/patients/shipments(.:format)
# /api/v1/patients/patient_limbos(.:format)
# /api/v1/patients/specimens(.:format)
# /api/v1/patients(.:format)
#
#
# /api/v1/patients/events/:id(.:format)
# /api/v1/patients/variant_reports/:id(.:format)
# /api/v1/patients/variants/:id(.:format)
# /api/v1/patients/assignments/:id(.:format)
# /api/v1/patients/shipments/:id(.:format)
# /api/v1/patients/:id(.:format)
#
#
#
#
# /api/v1/patients/:patient_id/action_items(.:format)
# /api/v1/patients/:patient_id/treatment_arm_history(.:format)
# /api/v1/patients/:patient_id/specimens(.:format)
# /api/v1/patients/:patient_id/specimen_events(.:format)
#
#
#
#
#
# /api/v1/patients/:patient_id/specimens/:id(.:format)
# /api/v1/patients/:patient_id/analysis_report/:id(.:format)
# /api/v1/patients/:patient_id/analysis_report_amois/:id(.:format)
# /api/v1/patients/:patient_id/qc_variant_reports/:id(.:format)
# /api/v1/patients/:patient_id/variant_file_download/:id(.:format)