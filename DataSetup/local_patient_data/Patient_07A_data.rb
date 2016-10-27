require_relative '../patient_message_loader'

PatientMessageLoader.upload_start_with_wait_time(15)


pt = PatientDataSet.new('PT_VC15_VrReceived')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)

pt = PatientDataSet.new('PT_VC15_AssayReceivedVrReceivedToConfirm')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs')
PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCMLH1s')
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)

pt = PatientDataSet.new('PT_VC15_AssayReceivedVrReceivedToReject')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs')
PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCMLH1s')
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)

pt = PatientDataSet.new('PT_VC15_OneAssayAndVrReceived')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs')
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)

PatientMessageLoader.upload_done
