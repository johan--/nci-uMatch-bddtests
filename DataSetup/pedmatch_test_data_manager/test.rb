require_relative 'seed_file'
require_relative 'ped_match_database'
require_relative 'ped_match_test_data'
require_relative 'patient_story'

list = []
# list << 'TA_AS01_TsVrReceivedV1'
# list << 'TA_AS01_TsVrReceivedV1Step2'
# list << 'TA_AS02_PendingConfV1'
# list << 'TA_AS02_PendingConfV1Step2'
# list << 'TA_AS03_PendingConfV1'
# list << 'TA_AS03_PendingConfV1Step2'
# list << 'TA_AS03_PendingApprV1'
# list << 'TA_AS03_PendingApprV1Step2'
# list << 'TA_AS03_OnTreatmentArmV1'
# list << 'TA_AS03_OnTreatmentArmV1Step2'
# list << 'TA_AS04_PendingApprV1'
# list << 'TA_AS04_PendingApprV1Step2'
# list << 'TA_AS05_PendingApprV1_1'
# list << 'TA_AS05_PendingApprV1_2'
# list << 'TA_AS05_PendingApprV1Step2_1'
# list << 'TA_AS05_PendingApprV1Step2_2'
# list << 'TA_AS05_OnTreatmentArmV1_1'
# list << 'TA_AS05_OnTreatmentArmV1_2'
# list << 'TA_AS05_OnTreatmentArmV1Step2_1'
# list << 'TA_AS05_OnTreatmentArmV1Step2_2'
# list << 'TA_AS01_TsVrReceivedV2'
# list << 'TA_AS01_TsVrReceivedV2Step2'
list << 'TA_AS02_PendingConfV2'
# list << 'TA_AS02_PendingConfV2Step2'
list << 'TA_AS03_PendingConfV2'
# list << 'TA_AS03_PendingConfV2Step2'
list << 'TA_AS03_PendingApprV2'
# list << 'TA_AS03_PendingApprV2Step2'
# list << 'TA_AS03_OnTreatmentArmV2'
# list << 'TA_AS03_OnTreatmentArmV2Step2'
list << 'TA_AS04_PendingApprV2'
# list << 'TA_AS04_PendingApprV2Step2'
list << 'TA_AS05_PendingApprV2_1'
list << 'TA_AS05_PendingApprV2_2'
# list << 'TA_AS05_PendingApprV2Step2_1'
# list << 'TA_AS05_PendingApprV2Step2_2'
# list << 'TA_AS05_OnTreatmentArmV2_1'
# list << 'TA_AS05_OnTreatmentArmV2_2'
# list << 'TA_AS05_OnTreatmentArmV2Step2_1'
# list << 'TA_AS05_OnTreatmentArmV2Step2_2'
# #
PedMatchTestData.load_seed_patients(list, 'treatment_arm')
#
# PedMatchDatabase.reload_local('treatment_arm')
#
# h = JSON.parse(File.read('/Users/wangl17/match_apps/nci-uMatch-bddtests/DataSetup/local_treatment_arm_data/a.json'))
# v = h.collect {|a| "#{a['date_created']}"}
# puts v.size
# puts v.uniq.size