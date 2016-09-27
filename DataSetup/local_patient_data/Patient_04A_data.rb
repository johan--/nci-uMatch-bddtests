require_relative '../patient_message_loader'

PatientMessageLoader.upload_start_with_wait_time(15)


pt = PatientDataSet.new('PT_AS13_SlideShipped')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)

PatientMessageLoader.upload_done
