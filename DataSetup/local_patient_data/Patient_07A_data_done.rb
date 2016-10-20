require_relative '../patient_message_loader'

PatientMessageLoader.upload_start_with_wait_time(15)


pt = PatientDataSet.new('PT_VC05_TissueShipped')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)



pt = PatientDataSet.new('PT_VC10_VRUploadedSEIExpired')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei_increase, '2016-06-25T15:17:11+00:00')
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi_increase, '2016-07-01T19:42:13+00:00')
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani_increase)

pt = PatientDataSet.new('PT_VC10_VRUploadedMOIExpired')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi_increase, '2016-07-01T19:42:13+00:00')
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani_increase)

pt = PatientDataSet.new('PT_VC10_VRUploadedANIExpired')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani_increase)

pt = PatientDataSet.new('PT_VC14_BdVRUploadedTsVRUploadedOtherReady')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_blood(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.pathology(pt.id, pt.sei)
PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs')
PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCMLH1s')
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.bd_moi, pt.ani_increase)

pt = PatientDataSet.new('PT_VC15_VRUploadedPathConfirmed')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.pathology(pt.id, pt.sei)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)

pt = PatientDataSet.new('PT_VC15_VRUploadedAssayReceived')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs')
PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCMLH1s')
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)

pt = PatientDataSet.new('PT_VC15_PathAssayDoneVRUploadedToConfirm')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.pathology(pt.id, pt.sei)
PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs')
PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCMLH1s')
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)


pt = PatientDataSet.new('PT_VC15_PathAssayDoneVRUploadedToReject')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.pathology(pt.id, pt.sei)
PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs')
PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCMLH1s')
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)



pt = PatientDataSet.new('PT_VC01_VRUploaded')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)

pt = PatientDataSet.new('PT_VC02_VRUploaded')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)

pt = PatientDataSet.new('PT_VC03_VRUploadedAfterRejected')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
PatientMessageLoader.variant_file_confirmed(pt.id, 'reject', pt.ani)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani_increase)

pt = PatientDataSet.new('PT_VC04_VRUploaded')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)

pt = PatientDataSet.new('PT_VC08_VRUploaded')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)

pt = PatientDataSet.new('PT_VC09_VRUploaded')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)

pt = PatientDataSet.new('PT_VC11_VRUploaded')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)

pt = PatientDataSet.new('PT_VC12_VRUploaded1')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)

pt = PatientDataSet.new('PT_VC12_VRUploaded2')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)

pt = PatientDataSet.new('PT_VC13_VRUploaded1')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)


pt = PatientDataSet.new('PT_VC04a_VRUploaded')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)

pt = PatientDataSet.new('PT_VC11b_TsVRConfirmed')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
sleep(10.0)
PatientMessageLoader.variant_file_confirmed(pt.id, 'confirm', pt.ani)

pt = PatientDataSet.new('PT_VC11b_TsVRRejected')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
sleep(10.0)
PatientMessageLoader.variant_file_confirmed(pt.id, 'reject', pt.ani)


PatientMessageLoader.upload_done













# pt = PatientDataSet.new('PT_VC11b_BdVRConfirmed')
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_blood(pt.id)
# PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)
# PatientMessageLoader.variant_file_uploaded(pt.id, pt.bd_moi, pt.ani)
# sleep(10.0)
# PatientMessageLoader.variant_file_confirmed(pt.id, 'confirm', pt.ani)
#
# pt = PatientDataSet.new('PT_VC11b_BdVRRejected')
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_blood(pt.id)
# PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)
# PatientMessageLoader.variant_file_uploaded(pt.id, pt.bd_moi, pt.ani)
# sleep(10.0)
# PatientMessageLoader.variant_file_confirmed(pt.id, 'reject', pt.ani)