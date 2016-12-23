require_relative '../patient_message_loader'
require_relative '../../DataSetup/dynamo_delete_script'
require_relative '../../DataSetup/dynamo_data_upload'
require_relative 'Patient_99A_data_done'

Environment.setTier 'local' #set this value to 'local' if you are running tests on your local machine.
Auth0Token.generate_auth0_token

DynamoDataUploader.delete_all_data_for_patient('PT_AM02_VrReceived')

DynamoDb.new('local').clear_all_tables
DynamoDataUploader.new('local').upload_treatment_arm_to_aws
DynamoDataUploader.new('local').upload_patient_data_to_aws
DynamoDataUploader.new('local').upload_ion_to_aws

Patient99A.upload_patient('PT_AM02_VrReceived')


DynamoDataUploader.backup_all_local_db


