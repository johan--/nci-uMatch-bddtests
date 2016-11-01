require_relative '../patient_message_loader'

PatientMessageLoader.upload_start_with_wait_time(15)


# pt = PatientDataSet.new('PT_AM01_TsVrReceived1')
# PatientMessageLoader.reset_cog_patient(pt.id)
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
# PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
# PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
# PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs')
# PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCMLH1s')
# PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)



PatientMessageLoader.upload_done
