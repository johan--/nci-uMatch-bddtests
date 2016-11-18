require_relative 'patient_message_loader'
require_relative 'treatment_arm_message_loader'
require_relative 'dynamo_data_upload'
require_relative 'dynamo_delete_script'

############start prepare patient data
# DynamoDb.new('local').clear_all_tables
# DynamoDataUploader.new('local').upload_ion_to_aws
# TreatmentArmMessageLoader.load_treatment_arm_to_local('Treatment_Arm_data', 2)



############clear local dynamodb and load all existing seed data
DynamoDb.new('local').clear_all_tables
DynamoDataUploader.new('local').upload_treatment_arm_to_aws
DynamoDataUploader.new('local').upload_patient_data_to_aws
DynamoDataUploader.new('local').upload_ion_to_aws


############clear different tables
# DynamoDb.new('local').clear_all_patient_tables
# DynamoDb.new('local').clear_all_treatment_arm_tables
# DynamoDb.new('local').clear_all_ion_tables





#################backup the just generated local db
# DynamoDataUploader.backup_all_local_db
# DynamoDataUploader.backup_all_patient_local_db
# DynamoDataUploader.backup_all_ion_local_db




############clear aws dynamodb and load all seed data
# DynamoDb.new('default').clear_all_tables
# DynamoDataUploader.new('default').upload_treatment_arm_to_aws
# DynamoDataUploader.new('default').upload_patient_data_to_aws
# DynamoDataUploader.new('default').upload_ion_to_aws


# DynamoDataUploader.delete_all_data_for_patient('PT_VU16_BdVRUploaded')
# DynamoDataUploader.delete_all_data_for_patient('ION_AQ42_BdVrUploaded')
# DynamoDataUploader.delete_all_data_for_patient('PT_SR10_BdVRReceived')
# DynamoDataUploader.delete_all_data_for_patient('PT_SR14_BdVrUploaded')
# DynamoDataUploader.delete_all_data_for_patient('PT_SR14_BdVrUploaded1')
# DynamoDataUploader.delete_all_data_for_patient('PT_SR14d_BdVrUploaded')
# DynamoDataUploader.delete_all_data_for_patient('PT_VC14_BdVRUploadedTsVRUploadedOtherReady')


# require_relative 'local_patient_data/Patient_01A_data_done'
# require_relative 'local_patient_data/Patient_02A_data_done'
# require_relative 'local_patient_data/Patient_03A_data_done'
# require_relative 'local_patient_data/Patient_04A_data_done'
# require_relative 'local_patient_data/Patient_06A_data_done'
# require_relative 'local_patient_data/Patient_07A_data_done'
# require_relative 'local_patient_data/Patient_99A_data_done'
# require_relative 'local_patient_data/Patient_TA_UI_data_done'
# require_relative 'local_patient_data/Ion_data_done'
#




