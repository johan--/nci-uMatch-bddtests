require_relative '../patient_message_loader'

PatientMessageLoader.upload_start_with_wait_time(15)

# pt = PatientDataSet.new('PT_SR10_PendingApproval')
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
# PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
# PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
# PatientMessageLoader.pathology(pt.id, pt.sei, 'Y')
# PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs')
# PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCMLH1s')
# PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
# PatientMessageLoader.variant_file_confirmed(pt.id, 'CONFIRMED', pt.moi, pt.ani)

# pt = PatientDataSet.new('PT_SR10_OnTreatmentArm')
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
# PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
# PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
# PatientMessageLoader.pathology(pt.id, pt.sei, 'Y')
# PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs')
# PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCMLH1s')
# PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
# PatientMessageLoader.variant_file_confirmed(pt.id, 'CONFIRMED', pt.moi, pt.ani)
# sleep(10.0)
# PatientMessageLoader.assignment_confirmed(pt.id, 'CONFIRMED', pt.moi, pt.ani)







PatientMessageLoader.upload_done
