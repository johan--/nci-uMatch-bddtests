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
list << 'TA_AS01_TsVrReceivedV2'
list << 'TA_AS01_TsVrReceivedV2Step2'
# list << 'TA_AS02_PendingConfV2'
# list << 'TA_AS02_PendingConfV2Step2'
# list << 'TA_AS03_PendingConfV2'
# list << 'TA_AS03_PendingConfV2Step2'
# list << 'TA_AS03_PendingApprV2'
# list << 'TA_AS03_PendingApprV2Step2'
# list << 'TA_AS03_OnTreatmentArmV2'
# list << 'TA_AS03_OnTreatmentArmV2Step2'
# list << 'TA_AS04_PendingApprV2'
# list << 'TA_AS04_PendingApprV2Step2'
# list << 'TA_AS05_PendingApprV2_1'
# list << 'TA_AS05_PendingApprV2_2'
# list << 'TA_AS05_PendingApprV2Step2_1'
# list << 'TA_AS05_PendingApprV2Step2_2'
# list << 'TA_AS05_OnTreatmentArmV2_1'
# list << 'TA_AS05_OnTreatmentArmV2_2'
# list << 'TA_AS05_OnTreatmentArmV2Step2_1'
# list << 'TA_AS05_OnTreatmentArmV2Step2_2'
# #
# PedMatchTestData.load_seed_patients(list, 'treatment_arm')
#
PedMatchDatabase.reload_local('treatment_arm')
#
# h = JSON.parse(File.read('/Users/wangl17/match_apps/nci-uMatch-bddtests/DataSetup/local_treatment_arm_data/a.json'))
# v = h.collect {|a| "#{a['date_created']}"}
# puts v.size
# puts v.uniq.size

# pt_list = []
# pt_list << 'PT_AS08_Registered'
# pt_list << 'ION_AQ03_BdShipped'
# pt_list << 'ION_AQ42_BdVrUploaded'
# pt_list << 'PT_SC07a_BdReceived'
# pt_list << 'PT_SC08_BdVrUploadedTwice'
# pt_list << 'PT_SS11a_Step2BdReceived'
# pt_list << 'PT_VC14_BdVRUploadedTsVRUploadedOtherReady'
# pt_list << 'PT_VU17_BdShippedTwice'
# pt_list << 'UI_SP01_MultiBdSpecimens'
# pt_list << 'PT_AM05_TsVrReceived1'
# pt_list << 'PT_AM11_AssayVrCompCareReady'
# pt_list << 'PT_AU05_DtmTsVrUploaded0'
# pt_list << 'PT_AU05_MochaTsVrUploaded0'
# pt_list << 'ION_AQ81_TsShipped'
# pt_list << 'PT_CR05_SpecimenShippedTwice'
# pt_list << 'PT_SC04b_TsShippedTwoAssay'
# pt_list << 'PT_SC04b_SdShippedNoTs'
# pt_list << 'PT_VU17_TsShipMdaThenDtm'
# pt_list << 'PT_VU17_TsShippedOffStudy'
# pt_list << 'ION_AQ08_TsVrUploaded1'
# pt_list << 'PT_SC04b_VrConfirmedOneAssay'
# pt_list << 'PT_VC03_VRUploadedAfterRejected'
# pt_list << 'PT_AM13_AssayVrReady1'
# pt_list << 'PT_AM02b_PendingConfirmationNoTa'
# pt_list << 'PT_AS09_ReqNoAssignment'
# pt_list << 'PT_OS01a_ReqAssignment'
# pt_list << 'UI_EM_OffStudy'
# pt_list << 'PT_VC00_CnvVrReceived'
# pt_list << 'UI_PA09_TsVr52Uploaded'
# pt_list << 'PT_SC07c_PendingApproval'

# SeedFile.copy_patients_between_tags(pt_list.uniq, 'patients', 'treatment_arm')