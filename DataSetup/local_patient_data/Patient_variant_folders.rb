require_relative '../patient_variant_folder_creator'
require_relative '../patient_message_loader'


PatientVariantFolderCreator.set_output_type('bdd_test_ion_reporter')
PatientVariantFolderCreator.clear_all
PatientVariantFolderCreator.create_default('PT_SR10_PendingApproval', 'tissue')
PatientVariantFolderCreator.create_default('PT_SR10_PendingApproval2', 'tissue')
PatientVariantFolderCreator.create_default('PT_SR10_OnTreatmentArm', 'tissue')
PatientVariantFolderCreator.create_default('PT_SR10_ProgressReBioY1', 'tissue')
PatientVariantFolderCreator.create_default('PT_SR10_ProgressReBioY2', 'tissue')
PatientVariantFolderCreator.create_default('PT_SR10_ProgressReBioY', 'tissue')
PatientVariantFolderCreator.create_default('PT_SR10_OffStudy', 'tissue')
PatientVariantFolderCreator.create_default('PT_SR10_BdVRReceived', 'blood')
PatientVariantFolderCreator.create_default('PT_SR14_BdVrUploaded', 'blood')
PatientVariantFolderCreator.create_default('PT_SR14_BdVrUploaded1', 'blood')
PatientVariantFolderCreator.create_default('PT_SR10_TsVrReceived', 'tissue')
PatientVariantFolderCreator.create_default('PT_SR10_TsVRRejected', 'tissue')
PatientVariantFolderCreator.create_default('PT_SS26_PendingApproval', 'tissue')
PatientVariantFolderCreator.create_default('PT_SR12_VariantReportConfirmed', 'tissue')
PatientVariantFolderCreator.create_default('PT_SR14_TsVrUploaded', 'tissue')
PatientVariantFolderCreator.create_default('PT_SR14_TsVrUploaded1', 'tissue')
PatientVariantFolderCreator.create_default('PT_SS02a_TsVrRejected', 'tissue')
PatientVariantFolderCreator.create_default('PT_SS21_TissueVariantConfirmed', 'tissue')
PatientVariantFolderCreator.create_default('PT_SS26_TsVRReceived', 'tissue')
PatientVariantFolderCreator.create_default('PT_SS26_TsVRConfirmed', 'tissue')
PatientVariantFolderCreator.create_default('PT_SS26_Progression', 'tissue')
PatientVariantFolderCreator.create_default('PT_SS27_VariantReportUploaded', 'tissue')
PatientVariantFolderCreator.create_default('PT_AS12_VrConfirmed', 'tissue')
PatientVariantFolderCreator.create_default('PT_AS12_VrReceived', 'tissue')

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


PatientVariantFolderCreator.create_default('PT_VU02a_TissueShippedToMDA', 'tissue')
PatientVariantFolderCreator.create_default('PT_VU02a_TissueShippedToMoCha', 'tissue')
PatientVariantFolderCreator.create_default('PT_VC05_TissueShipped', 'tissue')

PatientVariantFolderCreator.create_default('PT_VC15_VrReceived', 'tissue')
PatientVariantFolderCreator.create_default('PT_VC15_AssayReceivedVrReceivedToConfirm', 'tissue')
PatientVariantFolderCreator.create_default('PT_VC15_AssayReceivedVrReceivedToReject', 'tissue')
PatientVariantFolderCreator.create_default('PT_VC15_OneAssayAndVrReceived', 'tissue')
PatientVariantFolderCreator.create_default('PT_VC01_VRUploaded', 'tissue')
PatientVariantFolderCreator.create_default('PT_VC02_VRUploaded', 'tissue')
PatientVariantFolderCreator.create_default('PT_VC11b_TsVRConfirmed', 'tissue')
PatientVariantFolderCreator.create_default('PT_VC11b_TsVRRejected', 'tissue')

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

PatientVariantFolderCreator.create_default('PT_AM02_VrReceived', 'tissue')
PatientVariantFolderCreator.create_default('PT_SR14_RequestAssignment', 'tissue')
PatientVariantFolderCreator.create_default('PT_SS11a_Step2TsReceived1', 'tissue')
PatientVariantFolderCreator.create_default('PT_SS11a_Step2TsReceived2', 'tissue')
PatientVariantFolderCreator.create_default('PT_SS11a_Step2BdReceived', 'tissue')
PatientVariantFolderCreator.create_default('PT_OS01_TsShipped', 'tissue')
PatientVariantFolderCreator.create_default('PT_OS01_slideShipped', 'tissue')
PatientVariantFolderCreator.create_default('PT_OS01_TsVrConfirmed', 'tissue')
PatientVariantFolderCreator.create_default('PT_OS01_TsVrRejected', 'tissue')
PatientVariantFolderCreator.create_default('PT_OS01_OnTreatmentArm', 'tissue')
PatientVariantFolderCreator.create_default('PT_OS01_ReqAssignment', 'tissue')
PatientVariantFolderCreator.create_default('PT_OS01_ReqNoAssignment', 'tissue')
PatientVariantFolderCreator.create_default('PT_OS02_OffStudy1', 'tissue')
PatientVariantFolderCreator.create_default('PT_OS02_OffStudy2', 'tissue')
PatientVariantFolderCreator.create_default('PT_OS03_OffStudy1', 'tissue')
PatientVariantFolderCreator.create_default('PT_OS03_OffStudy2', 'tissue')
PatientVariantFolderCreator.create_default('PT_OS04_OnTA1', 'tissue')
PatientVariantFolderCreator.create_default('PT_OS04_OnTA2', 'tissue')
PatientVariantFolderCreator.create_default('PT_RA05_OnTreatmentArm', 'tissue')
PatientVariantFolderCreator.create_default('PT_RA06_OnTreatmentArm', 'tissue')
PatientVariantFolderCreator.create_default('PT_RA06_PendingAproval', 'tissue')
PatientVariantFolderCreator.create_default('PT_RA06_PendingAproval', 'tissue')
PatientVariantFolderCreator.create_default('PT_AM04_TsReceived1', 'tissue')
PatientVariantFolderCreator.create_default('PT_AM04_TsReceived2', 'tissue')

PatientVariantFolderCreator.create_default('PT_RA01_PendingApproval', 'tissue')
PatientVariantFolderCreator.create_default('PT_RA01_OnTreatmentArm', 'tissue')
PatientVariantFolderCreator.create_default('PT_RA02_PendingApproval', 'tissue')
PatientVariantFolderCreator.create_default('PT_RA02_OnTreatmentArm', 'tissue')
PatientVariantFolderCreator.create_default('PT_RA02_RequestNoAssignment', 'tissue')
PatientVariantFolderCreator.create_default('PT_RA02_RequestAssignment', 'tissue')
PatientVariantFolderCreator.create_default('PT_RA02_TsShipped', 'tissue')
PatientVariantFolderCreator.create_default('PT_RA02_slideShipped', 'tissue')
PatientVariantFolderCreator.create_default('PT_RA02_TsVrConfirmed', 'tissue')
PatientVariantFolderCreator.create_default('PT_RA02_TsVrRejected', 'tissue')
PatientVariantFolderCreator.create_default('PT_RA03_PendingApproval', 'tissue')
PatientVariantFolderCreator.create_default('PT_RA03_OnTreatmentArm', 'tissue')
PatientVariantFolderCreator.create_default('PT_RA03_RequestNoAssignment', 'tissue')
PatientVariantFolderCreator.create_default('PT_RA03_RequestAssignment', 'tissue')
PatientVariantFolderCreator.create_default('PT_RA03_TsShipped', 'tissue')
PatientVariantFolderCreator.create_default('PT_RA03_slideShipped', 'tissue')
PatientVariantFolderCreator.create_default('PT_RA03_TsVrConfirmed', 'tissue')
PatientVariantFolderCreator.create_default('PT_RA03_TsVrRejected', 'tissue')

pt = PatientDataSet.new('PT_RA02_TsVrReceived')
PatientVariantFolderCreator.create(pt.moi, pt.ani)
PatientVariantFolderCreator.create(pt.moi_increase, pt.ani_increase)

pt = PatientDataSet.new('PT_RA03_TsVrReceived')
PatientVariantFolderCreator.create(pt.moi, pt.ani)
PatientVariantFolderCreator.create(pt.moi_increase, pt.ani_increase)

pt = PatientDataSet.new('PT_RA04_RequestNoAssignment')
PatientVariantFolderCreator.create(pt.moi, pt.ani)
PatientVariantFolderCreator.create(pt.moi_increase, pt.ani_increase)
PatientVariantFolderCreator.create(pt.bd_moi, pt.ani_increase)
PatientVariantFolderCreator.create(pt.moi, pt.ani_increase)

pt = PatientDataSet.new('PT_OS01_TsVrReceived')
PatientVariantFolderCreator.create(pt.moi, pt.ani)
PatientVariantFolderCreator.create(pt.moi_increase, pt.ani_increase)

pt = PatientDataSet.new('PT_OS01_PendingApproval')
PatientVariantFolderCreator.create(pt.moi, pt.ani)
PatientVariantFolderCreator.create(pt.moi_increase, pt.ani_increase)


PatientVariantFolderCreator.create_default('PT_CR01_PathAssayDoneVRUploadedToConfirm', 'tissue')
PatientVariantFolderCreator.create_default('PT_CR02_OnTreatmentArm', 'tissue')
PatientVariantFolderCreator.create_default('PT_CR03_VRUploadedPathConfirmed', 'tissue')
PatientVariantFolderCreator.create_default('PT_CR04_VRUploadedAssayReceived', 'tissue')

pt = PatientDataSet.new('PT_CR05_SpecimenShippedTwice')
PatientVariantFolderCreator.create(pt.moi, pt.ani)
PatientVariantFolderCreator.create(pt.moi_increase, pt.ani_increase)

PatientVariantFolderCreator.create_default('ION_AQ41_TsVrUploaded', 'tissue')
PatientVariantFolderCreator.create_default('ION_AQ42_BdVrUploaded', 'blood')
PatientVariantFolderCreator.create_default('ION_AQ43_TsVrUploaded', 'tissue')
PatientVariantFolderCreator.create_default('ION_SF03_TsVrUploaded', 'tissue')
PatientVariantFolderCreator.create_default('ION_FL02_TsVrUploaded', 'tissue')
PatientVariantFolderCreator.create_default('PT_AM03_PendingApproval', 'tissue')




### pathology is not used anymore
# PatientVariantFolderCreator.create_default('PT_PR13_VRConfirmedNoAssay', 'tissue')
# PatientVariantFolderCreator.create_default('PT_PR13_AssayReceivedVRNotConfirmed', 'tissue')
# PatientVariantFolderCreator.create_default('PT_PR13_VRConfirmedOneAssay', 'tissue')
# PatientVariantFolderCreator.create_default('PT_PR13_AssayAndVRDonePlanToY', 'tissue')
# PatientVariantFolderCreator.create_default('PT_PR13_AssayAndVRDonePlanToN', 'tissue')
# PatientVariantFolderCreator.create_default('PT_PR13_AssayAndVRDonePlanToU', 'tissue')


# PatientVariantFolderCreator.set_output_type('test_data')

# PatientVariantFolderCreator.create_default('PT_VU06_TissueShipped', 'tissue')
# PatientVariantFolderCreator.create_default('PT_VU14_TissueAndBloodShipped', 'blood')
# PatientVariantFolderCreator.create_default('PT_VU02a_TissueShippedToMDA', 'tissue')
# PatientVariantFolderCreator.create_default('PT_VU02a_TissueShippedToMoCha', 'tissue')
# PatientVariantFolderCreator.create_default('PT_VC05_TissueShipped', 'tissue')

# pt = PatientDataSet.new('PT_VU12_VariantReportRejected')
# PatientVariantFolderCreator.create(pt.moi, pt.ani)
# PatientVariantFolderCreator.create(pt.moi, pt.ani_increase)

# pt = PatientDataSet.new('PT_VU09_VariantReportUploaded')
# PatientVariantFolderCreator.create(pt.moi, pt.ani_increase)

# pt = PatientDataSet.new('PT_VU11_VariantReportRejected')
# PatientVariantFolderCreator.create(pt.moi, pt.ani_increase)

# pt = PatientDataSet.new('PT_VU16_BdVRUploaded')
# PatientVariantFolderCreator.create(pt.bd_moi, pt.ani_increase)

# pt = PatientDataSet.new('PT_VU17_BdVRConfirmed')
# PatientVariantFolderCreator.create(pt.bd_moi, pt.ani_increase)
# PatientVariantFolderCreator.create(pt.moi, pt.ani_increase)

# PatientVariantFolderCreator.create_default('ION_AQ41_TsVrUploaded', 'tissue')
# PatientVariantFolderCreator.create_default('ION_AQ42_BdVrUploaded', 'blood')
# PatientVariantFolderCreator.create_default('ION_AQ43_TsVrUploaded', 'tissue')
# PatientVariantFolderCreator.create_default('ION_SF03_TsVrUploaded', 'tissue')
# PatientVariantFolderCreator.create_default('ION_FL02_TsVrUploaded', 'tissue')













# PatientVariantFolderCreator.create_default('PT_SR10_BdVRRejected', 'blood')
# PatientVariantFolderCreator.create_default('PT_SR10_BdVRConfirmed', 'blood')
# PatientVariantFolderCreator.create_default('PT_SS22_BloodVariantConfirmed', 'blood')
#
# pt = PatientDataSet.new('PT_VU17_BdVRConfirmed')
# PatientVariantFolderCreator.create(pt.bd_moi, pt.ani)
# PatientVariantFolderCreator.create(pt.bd_moi, pt.ani_increase)
# PatientVariantFolderCreator.create(pt.moi, pt.ani_increase)
#
# PatientVariantFolderCreator.create_default('PT_VC11b_BdVRConfirmed', 'blood')
# PatientVariantFolderCreator.create_default('PT_VC11b_BdVRRejected', 'blood')
#
# pt = PatientDataSet.new('PT_AM05')
# PatientVariantFolderCreator.create(pt.bd_moi, pt.ani)
# PatientVariantFolderCreator.create(pt.moi, pt.ani_increase)