require_relative 'patient_message_loader'
require_relative 'treatment_arm_message_loader'
require_relative 'dynamo_data_upload'
require_relative 'dynamo_delete_script'

############clear local dynamodb and load all seed data
DynamoDb.new('local').clear_all_tables
DynamoDataUploader.new('local').upload_treatment_arm_to_aws
DynamoDataUploader.new('local').upload_patient_data_to_aws
DynamoDataUploader.new('local').upload_ion_to_aws


############clear different tables
# DynamoDb.new('local').clear_all_patient_tables
# DynamoDb.new('local').clear_all_treatment_arm_tables
# DynamoDb.new('local').clear_all_ion_tables

############upload treatment arms seed data
# TreatmentArmMessageLoader.load_treatment_arm_to_local('Treatment_Arm_data', 2)




#################backup the just generated local db
# DynamoDataUploader.backup_all_local_db
# DynamoDataUploader.backup_all_patient_local_db
# DynamoDataUploader.backup_all_ion_local_db















