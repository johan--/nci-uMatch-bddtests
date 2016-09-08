require_relative '../patient_message_loader'

PatientMessageLoader.upload_start_with_wait_time(15)


pt = PatientDataSet.new('PT_VC05_TissueShipped')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)

PatientMessageLoader.upload_done
