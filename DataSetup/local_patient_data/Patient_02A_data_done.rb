require_relative '../patient_message_loader'

PatientMessageLoader.upload_start_with_wait_time(1)
PatientMessageLoader.register_patient('PT_SR01_Registered')
PatientMessageLoader.register_patient('PT_SR02_Registered')
PatientMessageLoader.register_patient('PT_SR03_Registered')
PatientMessageLoader.register_patient('PT_SR04_Registered')
PatientMessageLoader.register_patient('PT_SR05_Registered')
PatientMessageLoader.register_patient('PT_SR06_Registered')
PatientMessageLoader.register_patient('PT_SR08_Registered')
PatientMessageLoader.register_patient('PT_SR13_Registered')
PatientMessageLoader.upload_done


PatientMessageLoader.upload_start_with_wait_time(15)


pt = PatientDataSet.new('PT_SR10_PendingApproval')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs')
PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCMLH1s')
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
PatientMessageLoader.variant_file_confirmed(pt.id, 'confirm', pt.ani)
sleep(10.0)
PatientMessageLoader.assignment_confirmed(pt.id, pt.ani)


pt = PatientDataSet.new('PT_SR10_OnTreatmentArm')
PatientMessageLoader.reset_cog_patient(pt.id)
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs')
PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCMLH1s')
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
PatientMessageLoader.variant_file_confirmed(pt.id, 'confirm', pt.ani)
sleep(10.0)
PatientMessageLoader.assignment_confirmed(pt.id, pt.ani)
sleep(5.0)
PatientMessageLoader.on_treatment_arm(pt.id, 'APEC1621-A')

pt = PatientDataSet.new('PT_SR10_ProgressReBioY')
PatientMessageLoader.reset_cog_patient(pt.id)
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs')
PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCMLH1s')
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
PatientMessageLoader.variant_file_confirmed(pt.id, 'confirm', pt.ani)
sleep(10.0)
PatientMessageLoader.assignment_confirmed(pt.id, pt.ani)
sleep(10.0)
PatientMessageLoader.on_treatment_arm(pt.id, 'APEC1621-A')
PatientMessageLoader.request_assignment(pt.id)

pt = PatientDataSet.new('PT_SR10_ProgressReBioY1')
PatientMessageLoader.reset_cog_patient(pt.id)
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs')
PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCMLH1s')
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
PatientMessageLoader.variant_file_confirmed(pt.id, 'confirm', pt.ani)
sleep(10.0)
PatientMessageLoader.assignment_confirmed(pt.id, pt.ani)
sleep(10.0)
PatientMessageLoader.on_treatment_arm(pt.id, 'APEC1621-A')
PatientMessageLoader.request_assignment(pt.id)


pt = PatientDataSet.new('PT_SR10_BdReceived')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_blood(pt.id)

pt = PatientDataSet.new('PT_SR10_TsReceived')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)


pt = PatientDataSet.new('PT_SR10_TsVrReceived')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)

pt = PatientDataSet.new('PT_SR10_TsVRRejected')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
sleep(10)
PatientMessageLoader.variant_file_confirmed(pt.id, 'reject', pt.ani)

PatientMessageLoader.register_patient('PT_SR11_Registered')

pt = PatientDataSet.new('PT_SR12_VariantReportConfirmed')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
sleep(10)
PatientMessageLoader.variant_file_confirmed(pt.id, 'confirm', pt.ani)

pt = PatientDataSet.new('PT_SR14_TsVrUploaded')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)

pt = PatientDataSet.new('PT_SR09_TsReceivedTwice')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei_increase, '2016-04-28T15:17:11+00:00')


pt = PatientDataSet.new('PT_SR10_BdVRReceived')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_blood(pt.id)
PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.bd_moi, pt.ani)
PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.bd_moi, pt.ani)

pt = PatientDataSet.new('PT_SR14_BdVrUploaded')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_blood(pt.id)
PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.bd_moi, pt.ani)
PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.bd_moi, pt.ani)

pt = PatientDataSet.new('PT_SR14_TsVrUploaded1')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)

pt = PatientDataSet.new('PT_SR14_BdVrUploaded1')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_blood(pt.id)
PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.bd_moi, pt.ani)
PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.bd_moi, pt.ani)

pt = PatientDataSet.new('PT_SR14d_BdVrUploaded')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_blood(pt.id)
PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.bd_moi, pt.ani)
PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.bd_moi, pt.ani)

pt = PatientDataSet.new('PT_SR10_OffStudy')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs')
PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCMLH1s')
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
PatientMessageLoader.variant_file_confirmed(pt.id, 'confirm', pt.ani)
sleep(10.0)
PatientMessageLoader.off_study(pt.id, '1.0')


pt = PatientDataSet.new('PT_SR10_OffStudy2')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
PatientMessageLoader.off_study(pt.id, '1.0')

pt = PatientDataSet.new('PT_SR10_PendingApproval2')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs')
PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCMLH1s')
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
PatientMessageLoader.variant_file_confirmed(pt.id, 'confirm', pt.ani)
sleep(10.0)
PatientMessageLoader.assignment_confirmed(pt.id, pt.ani)


PatientMessageLoader.upload_done









# PatientMessageLoader.register_patient('PT_SR09_Registered')

#
# pt = PatientDataSet.new('PT_SR10_BdVRRejected')
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_blood(pt.id)
# PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)
# PatientMessageLoader.variant_file_uploaded(pt.id, pt.bd_moi, pt.ani)
# PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.bd_moi, pt.ani)
# sleep(10)
# PatientMessageLoader.variant_file_confirmed(pt.id, 'reject', pt.ani)
#
# pt = PatientDataSet.new('PT_SR10_BdVRConfirmed')
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_blood(pt.id)
# PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)
# PatientMessageLoader.variant_file_uploaded(pt.id, pt.bd_moi, pt.ani)
# PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.bd_moi, pt.ani)
# sleep(10)
# PatientMessageLoader.variant_file_confirmed(pt.id, 'confirm', pt.ani)

# pt = PatientDataSet.new('PT_SR10_UPathoReceived')
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
# PatientMessageLoader.pathology(pt.id, pt.sei, 'U')
#
# pt = PatientDataSet.new('PT_SR10_NPathoReceived')
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
# PatientMessageLoader.pathology(pt.id, pt.sei, 'N')
#
# pt = PatientDataSet.new('PT_SR10_YPathoReceived')
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
# PatientMessageLoader.pathology(pt.id, pt.sei, 'Y')