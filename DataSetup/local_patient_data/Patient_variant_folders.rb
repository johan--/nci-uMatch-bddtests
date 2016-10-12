require_relative '../patient_variant_folder_creator'
require_relative '../patient_message_loader'

PatientVariantFolderCreator.clear_all

PatientVariantFolderCreator.set_output_type('seed_data')
PatientVariantFolderCreator.create_default('PT_SR10_PendingApproval', 'tissue')
PatientVariantFolderCreator.create_default('PT_SR10_OnTreatmentArm', 'tissue')
PatientVariantFolderCreator.create_default('PT_SR10_ProgressReBioY1', 'tissue')
PatientVariantFolderCreator.create_default('PT_SR10_ProgressReBioY2', 'tissue')
PatientVariantFolderCreator.create_default('PT_SR10_ProgressReBioY', 'tissue')
PatientVariantFolderCreator.create_default('PT_SR10_OffStudy', 'tissue')
PatientVariantFolderCreator.create_default('PT_SR10_BdVRReceived', 'blood')
PatientVariantFolderCreator.create_default('PT_SR10_BdVRRejected', 'blood')
PatientVariantFolderCreator.create_default('PT_SR10_BdVRConfirmed', 'blood')
PatientVariantFolderCreator.create_default('PT_SR14_BdVrUploaded', 'blood')
PatientVariantFolderCreator.create_default('PT_SR10_TsVrReceived', 'tissue')
PatientVariantFolderCreator.create_default('PT_SR10_TsVRRejected', 'tissue')
PatientVariantFolderCreator.create_default('PT_SS26_PendingApproval', 'tissue')
PatientVariantFolderCreator.create_default('PT_SR12_VariantReportConfirmed', 'tissue')
PatientVariantFolderCreator.create_default('PT_SR14_TsVrUploaded', 'tissue')
PatientVariantFolderCreator.create_default('PT_SS22_BloodVariantConfirmed', 'blood')
PatientVariantFolderCreator.create_default('PT_SS21_TissueVariantConfirmed', 'tissue')
PatientVariantFolderCreator.create_default('PT_SS26_TsVRReceived', 'tissue')
PatientVariantFolderCreator.create_default('PT_SS26_TsVRConfirmed', 'tissue')
PatientVariantFolderCreator.create_default('PT_SS26_Progression', 'tissue')
PatientVariantFolderCreator.create_default('PT_SS27_VariantReportUploaded', 'tissue')
PatientVariantFolderCreator.create_default('PT_AS12_VRConfirmedNoPatho', 'tissue')
PatientVariantFolderCreator.create_default('PT_AS12_PathoConfirmedNoVR', 'tissue')
PatientVariantFolderCreator.create_default('PT_AS12_VRAndPathoConfirmed', 'tissue')

PatientVariantFolderCreator.create_default('PT_PR13_VRConfirmedNoAssay', 'tissue')
PatientVariantFolderCreator.create_default('PT_PR13_AssayReceivedVRNotConfirmed', 'tissue')
PatientVariantFolderCreator.create_default('PT_PR13_AssayAndVRDonePlanToY', 'tissue')
PatientVariantFolderCreator.create_default('PT_PR13_AssayAndVRDonePlanToN', 'tissue')
PatientVariantFolderCreator.create_default('PT_PR13_AssayAndVRDonePlanToU', 'tissue')
PatientVariantFolderCreator.create_default('PT_VU06_TissueShipped', 'tissue')
PatientVariantFolderCreator.create_default('PT_VU10_VariantReportUploaded', 'tissue')
PatientVariantFolderCreator.create_default('PT_VU13_VariantReportConfirmed', 'tissue')
PatientVariantFolderCreator.create_default('PT_VU14_TissueAndBloodShipped', 'blood')

pt = PatientDataSet.new('PT_VU09_VariantReportUploaded')
PatientVariantFolderCreator.create(pt.moi, pt.ani)
PatientVariantFolderCreator.create(pt.moi, pt.ani_increase)

pt = PatientDataSet.new('PT_VU11_VariantReportRejected')
PatientVariantFolderCreator.create(pt.moi, pt.ani)
PatientVariantFolderCreator.create(pt.moi, pt.ani_increase)

pt = PatientDataSet.new('PT_VU12_VariantReportRejected')
PatientVariantFolderCreator.create(pt.moi, pt.ani)
PatientVariantFolderCreator.create(pt.moi, pt.ani_increase)

pt = PatientDataSet.new('PT_VU16_BdVRUploaded')
PatientVariantFolderCreator.create(pt.bd_moi, pt.ani)
PatientVariantFolderCreator.create(pt.bd_moi, pt.ani_increase)

pt = PatientDataSet.new('PT_VU17_BdVRConfirmed')
PatientVariantFolderCreator.create(pt.bd_moi, pt.ani)
PatientVariantFolderCreator.create(pt.bd_moi, pt.ani_increase)
PatientVariantFolderCreator.create(pt.moi, pt.ani_increase)

pt = PatientDataSet.new('PT_VC10_VRUploadedSEIExpired')
PatientVariantFolderCreator.create(pt.moi, pt.ani)
PatientVariantFolderCreator.create(pt.moi_increase, pt.ani_increase)

pt = PatientDataSet.new('PT_VC10_VRUploadedMOIExpired')
PatientVariantFolderCreator.create(pt.moi, pt.ani)
PatientVariantFolderCreator.create(pt.moi_increase, pt.ani_increase)

pt = PatientDataSet.new('PT_VC10_VRUploadedANIExpired')
PatientVariantFolderCreator.create(pt.moi, pt.ani)
PatientVariantFolderCreator.create(pt.moi, pt.ani_increase)

pt = PatientDataSet.new('PT_VC14_BdVRUploadedTsVRUploadedOtherReady')
PatientVariantFolderCreator.create(pt.moi, pt.ani)
PatientVariantFolderCreator.create(pt.bd_moi, pt.ani_increase)

PatientVariantFolderCreator.create_default('PT_VC15_VRUploadedPathConfirmed', 'tissue')
PatientVariantFolderCreator.create_default('PT_VC15_VRUploadedAssayReceived', 'tissue')
PatientVariantFolderCreator.create_default('PT_VC15_PathAssayDoneVRUploadedToConfirm', 'tissue')
PatientVariantFolderCreator.create_default('PT_VC15_PathAssayDoneVRUploadedToReject', 'tissue')
PatientVariantFolderCreator.create_default('PT_VC01_VRUploaded', 'tissue')
PatientVariantFolderCreator.create_default('PT_VC02_VRUploaded', 'tissue')
PatientVariantFolderCreator.create_default('PT_VC11b_TsVRConfirmed', 'tissue')
PatientVariantFolderCreator.create_default('PT_VC11b_TsVRRejected', 'tissue')
PatientVariantFolderCreator.create_default('PT_VC11b_BdVRConfirmed', 'blood')
PatientVariantFolderCreator.create_default('PT_VC11b_BdVRRejected', 'blood')

pt = PatientDataSet.new('PT_VC03_VRUploadedAfterRejected')
PatientVariantFolderCreator.create(pt.moi, pt.ani)
PatientVariantFolderCreator.create(pt.moi, pt.ani_increase)

PatientVariantFolderCreator.create_default('PT_VC04_VRUploaded', 'tissue')
PatientVariantFolderCreator.create_default('PT_VC04a_VRUploaded', 'tissue')
PatientVariantFolderCreator.create_default('PT_VC08_VRUploaded', 'tissue')
PatientVariantFolderCreator.create_default('PT_VC09_VRUploaded', 'tissue')
PatientVariantFolderCreator.create_default('PT_VC11_VRUploaded', 'tissue')
PatientVariantFolderCreator.create_default('PT_VC12_VRUploaded1', 'tissue')
PatientVariantFolderCreator.create_default('PT_VC12_VRUploaded2', 'tissue')
PatientVariantFolderCreator.create_default('PT_VC13_VRUploaded1', 'tissue')


PatientVariantFolderCreator.create_default('PT_CR01_PathAssayDoneVRUploadedToConfirm', 'tissue')
PatientVariantFolderCreator.create_default('PT_CR02_OnTreatmentArm', 'tissue')
PatientVariantFolderCreator.create_default('PT_CR03_VRUploadedPathConfirmed', 'tissue')
PatientVariantFolderCreator.create_default('PT_CR04_VRUploadedAssayReceived', 'tissue')

PatientVariantFolderCreator.create_default('ION_AQ41_TsVrUploaded', 'tissue')
PatientVariantFolderCreator.create_default('ION_AQ42_BdVrUploaded', 'blood')
PatientVariantFolderCreator.create_default('ION_AQ43_TsVrUploaded', 'tissue')
PatientVariantFolderCreator.create_default('ION_SF03_TsVrUploaded', 'tissue')
PatientVariantFolderCreator.create_default('ION_FL02_TsVrUploaded', 'tissue')



PatientVariantFolderCreator.set_output_type('test_data')

PatientVariantFolderCreator.create_default('PT_VU06_TissueShipped', 'tissue')
PatientVariantFolderCreator.create_default('PT_VU14_TissueAndBloodShipped', 'blood')
PatientVariantFolderCreator.create_default('PT_VU02a_TissueShippedToMDA', 'tissue')
PatientVariantFolderCreator.create_default('PT_VU02a_TissueShippedToMoCha', 'tissue')
PatientVariantFolderCreator.create_default('PT_VC05_TissueShipped', 'tissue')

pt = PatientDataSet.new('PT_VU09_VariantReportUploaded')
PatientVariantFolderCreator.create(pt.moi, pt.ani_increase)

pt = PatientDataSet.new('PT_VU11_VariantReportRejected')
PatientVariantFolderCreator.create(pt.moi, pt.ani_increase)

pt = PatientDataSet.new('PT_VU16_BdVRUploaded')
PatientVariantFolderCreator.create(pt.bd_moi, pt.ani_increase)

pt = PatientDataSet.new('PT_VU17_BdVRConfirmed')
PatientVariantFolderCreator.create(pt.bd_moi, pt.ani_increase)
PatientVariantFolderCreator.create(pt.moi, pt.ani_increase)

PatientVariantFolderCreator.create_default('ION_AQ41_TsVrUploaded', 'tissue')
PatientVariantFolderCreator.create_default('ION_AQ42_BdVrUploaded', 'blood')
PatientVariantFolderCreator.create_default('ION_AQ43_TsVrUploaded', 'tissue')
PatientVariantFolderCreator.create_default('ION_SF03_TsVrUploaded', 'tissue')
PatientVariantFolderCreator.create_default('ION_FL02_TsVrUploaded', 'tissue')