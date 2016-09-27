require_relative 'patient_message_loader'
require_relative 'treatment_arm_message_loader'
require_relative 'dynamo_data_upload'
require_relative 'dynamo_delete_script'

############clear local dynamodb and load all seed data
DynamoDb.new('local').clear_all_tables
DynamoDataUploader.new('local').upload_treatment_arm_to_aws
DynamoDataUploader.new('local').upload_patient_data_to_aws

# DynamoDataUploader.backup_all_local_db

############clear local treatment arm related tables
# DynamoDb.new('local').clear_table('treatment_arm')
# DynamoDb.new('local').clear_table('treatment_arm_patient')


############clear aws dynamodb and load all seed data
# DynamoDb.new('default').clear_all_tables
# DynamoDataUploader.new('default').upload_patient_data_to_aws
# DynamoDataUploader.new('default').upload_treatment_arm_to_aws
