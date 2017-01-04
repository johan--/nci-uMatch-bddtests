require_relative '../patient_message_loader'
require_relative '../../DataSetup/dynamo_delete_script'
require_relative '../../DataSetup/dynamo_data_upload'
require_relative 'Patient_5xA_data_done'

Environment.setTier 'local' #set this value to 'local' if you are running tests on your local machine.


# DynamoDb.new('local').clear_all_tables
# DynamoDataUploader.new('local').upload_treatment_arm_to_aws
# DynamoDataUploader.new('local').upload_patient_data_to_aws
# DynamoDataUploader.new('local').upload_ion_to_aws
#
# Auth0Token.generate_auth0_token
# Patient5xA.upload_all
DynamoDataUploader.backup_all_local_db