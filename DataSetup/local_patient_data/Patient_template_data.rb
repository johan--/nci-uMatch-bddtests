require_relative '../patient_message_loader'
require_relative '../../DataSetup/match_test_data_manager'
require_relative '../../DataSetup/dynamo_utilities'
require_relative 'Patient_tempalte_data_done'


def create(patient_id, type)
  Environment.setTier 'local'
  Auth0Token.force_generate_auth0_token('ADMIN')
  MatchTestDataManager.clear_all_local_tables
  PatientTemplate.upload_patient(patient_id)
  sleep 10.0
  TableDetails.patient_tables.each do |table|
    file_path = "#{File.dirname(__FILE__)}/../patient_seed_data_templates/#{type}/#{table}.json"
    DynamoUtilities.backup_local_table_to_file(table, file_path)
  end
end

create('PT_TMP_Registered', 'registered')
create('PT_TMP_TsReceived', 'tissue_received')
create('PT_TMP_TsShipped', 'tissue_shipped')
create('PT_TMP_SlideShipped', 'slide_shipped')
create('PT_TMP_AssayReceived', 'assay_received')


