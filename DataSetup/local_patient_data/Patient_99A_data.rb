require_relative '../patient_message_loader'
require_relative '../../DataSetup/dynamo_delete_script'
require_relative '../../DataSetup/dynamo_data_upload'
require_relative 'Patient_99A_data_done'

Environment.setTier 'local' #set this value to 'local' if you are running tests on your local machine.
Auth0Token.generate_auth0_token



Patient99A.upload_patient('PT_AM04_TsReceived1')
Patient99A.upload_patient('PT_AM04_TsReceived2')


DynamoDataUploader.backup_all_local_db


