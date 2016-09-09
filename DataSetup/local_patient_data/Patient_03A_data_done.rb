require_relative '../patient_message_loader'

PatientMessageLoader.upload_start_with_wait_time(15)

pt = PatientDataSet.new('PT_SS01_BloodReceived')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_blood(pt.id)

pt = PatientDataSet.new('PT_SS02_TissueReceived')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)

pt = PatientDataSet.new('PT_SS03_TissueReceived')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
#
pt = PatientDataSet.new('PT_SS05_TissueReceived')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)

pt = PatientDataSet.new('PT_SS06_TissueReceived')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)

pt = PatientDataSet.new('PT_SS06a_TissueShipped')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)

pt = PatientDataSet.new('PT_SS07_TissueReceived')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)

pt = PatientDataSet.new('PT_SS08_TissueReceived')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei_increase,'2016-04-25T18:17:11+00:00')

pt = PatientDataSet.new('PT_SS08a_TissueReceived1a')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)

pt = PatientDataSet.new('PT_SS08a_TissueReceived1b')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)

pt = PatientDataSet.new('PT_SS08a_TissueReceived2a')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)

pt = PatientDataSet.new('PT_SS08a_TissueReceived2b')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)

pt = PatientDataSet.new('PT_SS09_TissueReceived')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)

pt = PatientDataSet.new('PT_SS10_TissueReceived')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
#
pt = PatientDataSet.new('PT_SS11_Tissue1Shipped')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi_increase, '2016-05-01T22:42:13+00:00')

pt = PatientDataSet.new('PT_SS12_Tissue1Shipped')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)

pt = PatientDataSet.new('PT_SS14_TissueReceived')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)

pt = PatientDataSet.new('PT_SS15_Slide1Shipped')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)

pt = PatientDataSet.new('PT_SS16_Slide1Shipped')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)

PatientMessageLoader.register_patient('PT_SS17_Registered')

pt = PatientDataSet.new('PT_SS20_Blood1Shipped')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_blood(pt.id)
PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)

pt = PatientDataSet.new('PT_SS23_TissueReceived1')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)

pt = PatientDataSet.new('PT_SS23_TissueReceived2')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
#
pt = PatientDataSet.new('PT_SS23_SlideShipped')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)

pt = PatientDataSet.new('PT_SS23_TissueShipped')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)

pt = PatientDataSet.new('PT_SS24_BloodShipped')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_blood(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)
#
pt = PatientDataSet.new('PT_SS24_TissueShipped')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_blood(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)

pt = PatientDataSet.new('PT_SS25_BloodShipped')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_blood(pt.id)
PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)
PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi_increase, '2016-05-01T22:42:13+00:00')

pt = PatientDataSet.new('PT_SS26_TsReceived')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_blood(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)

pt = PatientDataSet.new('PT_SS26_TsShipped')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_blood(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)

pt = PatientDataSet.new('PT_SS26_PathologyConfirmed')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_blood(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.pathology(pt.id, pt.sei, 'Y')

pt = PatientDataSet.new('PT_SS26_AssayConfirmed')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_blood(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs')

pt = PatientDataSet.new('PT_SS28_TissueReceived1')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)

pt = PatientDataSet.new('PT_SS28_TissueReceived2')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)

pt = PatientDataSet.new('PT_SS28_TissueReceived3')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)

pt = PatientDataSet.new('PT_SS28_TissueReceived4')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)

pt = PatientDataSet.new('PT_SS28_TissueReceived5')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)

pt = PatientDataSet.new('PT_SS28_BloodReceived1')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_blood(pt.id)

pt = PatientDataSet.new('PT_SS28_BloodReceived2')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_blood(pt.id)

pt = PatientDataSet.new('PT_SS28_BloodReceived3')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_blood(pt.id)


pt = PatientDataSet.new('PT_SS21_TissueVariantConfirmed')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.tsv_vcf_uploaded(pt.id, pt.moi, pt.ani)
PatientMessageLoader.variant_file_confirmed(pt.id, 'CONFIRMED', pt.moi, pt.ani)

pt = PatientDataSet.new('PT_SS26_TsVRReceived')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_blood(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.tsv_vcf_uploaded(pt.id, pt.moi, pt.ani)

pt = PatientDataSet.new('PT_SS26_TsVRConfirmed')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_blood(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.tsv_vcf_uploaded(pt.id, pt.moi, pt.ani)
sleep(10.0)
PatientMessageLoader.variant_file_confirmed(pt.id, 'CONFIRMED', pt.moi, pt.ani)

pt = PatientDataSet.new('PT_SS27_VariantReportUploaded')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.tsv_vcf_uploaded(pt.id, pt.moi, pt.ani)

pt = PatientDataSet.new('PT_SS22_BloodVariantConfirmed')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_blood(pt.id)
PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)
PatientMessageLoader.tsv_vcf_uploaded(pt.id, pt.bd_moi, pt.ani)
PatientMessageLoader.variant_file_confirmed(pt.id, 'CONFIRMED', pt.bd_moi, pt.ani)

PatientMessageLoader.upload_done
