require_relative '../patient_message_loader'

PatientMessageLoader.upload_start_with_wait_time(15)

#!!disconnect mock service before run this "PT_SR10_WaitingPtData"
patient_id = 'PT_SR10_WaitingPtData'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)
PatientMessageLoader.pathology(patient_id,'Y')
PatientMessageLoader.assay(patient_id, 'NEGATIVE', 'ICCPTENs')
PatientMessageLoader.assay(patient_id, 'NEGATIVE', 'ICCMLH1s')
PatientMessageLoader.variant_file_uploaded(patient_id)
PatientMessageLoader.variant_file_confirmed(patient_id, 'CONFIRMED')

#connect mock service back before run the following blocks
patient_id = 'PT_SR10_PendingApproval'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)
PatientMessageLoader.pathology(patient_id,'Y')
PatientMessageLoader.assay(patient_id, 'NEGATIVE', 'ICCPTENs')
PatientMessageLoader.assay(patient_id, 'NEGATIVE', 'ICCMLH1s')
PatientMessageLoader.variant_file_uploaded(patient_id)
PatientMessageLoader.variant_file_confirmed(patient_id, 'CONFIRMED')

patient_id = 'PT_SR10_OnTreatmentArm'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)
PatientMessageLoader.pathology(patient_id,'Y')
PatientMessageLoader.assay(patient_id, 'NEGATIVE', 'ICCPTENs')
PatientMessageLoader.assay(patient_id, 'NEGATIVE', 'ICCMLH1s')
PatientMessageLoader.variant_file_uploaded(patient_id)
PatientMessageLoader.variant_file_confirmed(patient_id, 'CONFIRMED')
sleep(10.0)
PatientMessageLoader.assignment_confirmed(patient_id, 'CONFIRMED')





PatientMessageLoader.upload_done
