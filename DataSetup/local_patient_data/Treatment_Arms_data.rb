require_relative '../treatment_arm_message_loader'


TreatmentArmMessageLoader.upload_start_with_wait_time(5)

TreatmentArmMessageLoader.load_treatment_arm_to_local('APEC1621-A', '100', '2015-08-06')
TreatmentArmMessageLoader.load_treatment_arm_to_local('APEC1621-B', '100', '2015-08-06')
TreatmentArmMessageLoader.load_treatment_arm_to_local('APEC1621-UI', 'STR100', '2015-08-06')
TreatmentArmMessageLoader.load_treatment_arm_to_local('APEC1621-ETE-A', '100', '2015-08-06')
TreatmentArmMessageLoader.load_treatment_arm_to_local('APEC1621-ETE-B', '100', '2015-08-06')
TreatmentArmMessageLoader.load_treatment_arm_to_local('APEC1621-ETE-C', '100', '2015-08-06')
TreatmentArmMessageLoader.load_treatment_arm_to_local('APEC1621-ETE-D', '100', '2015-08-06')
TreatmentArmMessageLoader.load_treatment_arm_to_local('APEC1621-2V', '100', 'version1')
TreatmentArmMessageLoader.load_treatment_arm_to_local('APEC1621-2V', '100', 'version2')
TreatmentArmMessageLoader.load_treatment_arm_to_local('CukeTest-122-1-SUSPENDED', 'stratum122a', '2015-08-06')

TreatmentArmMessageLoader.upload_done