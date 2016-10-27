require_relative '../patient_message_loader'

PatientMessageLoader.upload_start_with_wait_time(15)


# pt = PatientDataSet.new('PT_ETE02')
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_blood(pt.id)
# PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
# PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)
# PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
# PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
# PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs')
# PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCMLH1s')
# PatientMessageLoader.variant_file_uploaded(pt.id, pt.bd_moi, pt.ani)
# PatientMessageLoader.variant_file_confirmed(pt.id, 'reject', pt.ani)
#


PatientMessageLoader.upload_done
