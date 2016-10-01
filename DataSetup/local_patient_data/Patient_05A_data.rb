require_relative '../patient_message_loader'

PatientMessageLoader.upload_start_with_wait_time(15)



pt = PatientDataSet.new('PT_PR00_TsReceived1')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)

pt = PatientDataSet.new('PT_PR00_TsReceived2')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)

pt = PatientDataSet.new('PT_PR00_TsReceived3')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)


PatientMessageLoader.upload_done
