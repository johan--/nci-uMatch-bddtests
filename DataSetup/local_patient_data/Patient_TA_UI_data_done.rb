require_relative '../patient_message_loader'

PatientMessageLoader.upload_start_with_wait_time(15)

pt = PatientDataSet.new('PT_CR01_PathAssayDoneVRUploadedToConfirm')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.pathology(pt.id, pt.sei)
PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs')
PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCMLH1s')
PatientMessageLoader.tsv_vcf_uploaded(pt.id, pt.moi, pt.ani)

# pt = PatientDataSet.new('PT_CR02_OnTreatmentArm')
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
# PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
# PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
# PatientMessageLoader.pathology(pt.id, pt.sei, 'Y')
# PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs')
# PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCMLH1s')
# PatientMessageLoader.tsv_vcf_uploaded(pt.id, pt.moi, pt.ani)
# PatientMessageLoader.variant_file_confirmed(pt.id, 'CONFIRMED', pt.moi, pt.ani)
# sleep(10.0)
# PatientMessageLoader.assignment_confirmed(pt.id, 'CONFIRMED', pt.moi, pt.ani)

pt = PatientDataSet.new('PT_CR03_VRUploadedPathConfirmed')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.pathology(pt.id, pt.sei)
PatientMessageLoader.tsv_vcf_uploaded(pt.id, pt.moi, pt.ani)

pt = PatientDataSet.new('PT_CR04_VRUploadedAssayReceived')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs')
PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCMLH1s')
PatientMessageLoader.tsv_vcf_uploaded(pt.id, pt.moi, pt.ani)

PatientMessageLoader.upload_done
