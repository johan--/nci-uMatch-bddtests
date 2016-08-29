require_relative '../patient_message_loader'

PatientMessageLoader.upload_start_with_wait_time(15)
PatientMessageLoader.register_patient('PT_SR01_Registered')
PatientMessageLoader.register_patient('PT_SR02_Registered')
PatientMessageLoader.register_patient('PT_SR03_Registered')
PatientMessageLoader.register_patient('PT_SR04_Registered')
PatientMessageLoader.register_patient('PT_SR05_Registered')
PatientMessageLoader.register_patient('PT_SR06_Registered')
PatientMessageLoader.register_patient('PT_SR08_Registered')
PatientMessageLoader.register_patient('PT_SR09_Registered')


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

pt = PatientDataSet.new('PT_SR10_TsVRRejected')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
sleep(10)
PatientMessageLoader.variant_file_confirmed(pt.id, 'REJECTED', pt.moi, pt.ani)

pt = PatientDataSet.new('PT_SR10_BdVRReceived')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_blood(pt.id)
PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.bd_moi, pt.ani)

pt = PatientDataSet.new('PT_SR10_BdVRRejected')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_blood(pt.id)
PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.bd_moi, pt.ani)
sleep(10)
PatientMessageLoader.variant_file_confirmed(pt.id, 'REJECTED', pt.bd_moi, pt.ani)

pt = PatientDataSet.new('PT_SR10_BdVRConfirmed')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_blood(pt.id)
PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.bd_moi, pt.ani)
sleep(10)
PatientMessageLoader.variant_file_confirmed(pt.id, 'CONFIRMED', pt.bd_moi, pt.ani)

pt = PatientDataSet.new('PT_SR10_UPathoReceived')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.pathology(pt.id, pt.sei, 'U')

pt = PatientDataSet.new('PT_SR10_NPathoReceived')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.pathology(pt.id, pt.sei,'N')

pt = PatientDataSet.new('PT_SR10_YPathoReceived')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.pathology(pt.id, pt.sei,'Y')

PatientMessageLoader.register_patient('PT_SR11_Registered')

pt = PatientDataSet.new('PT_SR12_VariantReportConfirmed')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
sleep(10)
PatientMessageLoader.variant_file_confirmed(pt.id, 'CONFIRMED', pt.moi, pt.ani)

pt = PatientDataSet.new('PT_SR14_VariantReportUploaded')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)

pt = PatientDataSet.new('PT_SR10_WaitingPtData')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
PatientMessageLoader.pathology(pt.id, pt.sei, 'Y')
PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs')
PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCMLH1s')
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
# Run this step separately, keep refresh patient status, once AWAITING_PATIENT_DATA appears, disconnect mock service immediately
PatientMessageLoader.variant_file_confirmed(pt.id, 'CONFIRMED', pt.moi, pt.ani)

PatientMessageLoader.upload_done
