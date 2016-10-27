require_relative '../patient_message_loader'

PatientMessageLoader.upload_start_with_wait_time(15)

pt = PatientDataSet.new('PT_AS12_VrConfirmed')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
sleep(10.0)
PatientMessageLoader.variant_file_confirmed(pt.id, 'confirm', pt.ani)

pt = PatientDataSet.new('PT_AS12_VrReceived')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)

PatientMessageLoader.upload_done
