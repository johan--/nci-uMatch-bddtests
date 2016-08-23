require_relative '../patient_message_loader'

PatientMessageLoader.upload_start_with_wait_time(15)
PatientMessageLoader.register_patient('PT_SR01_Registered')
PatientMessageLoader.register_patient('PT_SR02_Registered')
PatientMessageLoader.register_patient('PT_SR03_Registered')
PatientMessageLoader.register_patient('PT_SR04_Registered')
PatientMessageLoader.register_patient('PT_SR05_Registered')
PatientMessageLoader.register_patient('PT_SR06_Registered')
PatientMessageLoader.register_patient('PT_SR08_Registered')
PatientMessageLoader.register_patient('PT_SR09_Registered')

patient_id = 'PT_SR10_TsVrReceived'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)
PatientMessageLoader.variant_file_uploaded(patient_id)

patient_id = 'PT_SR10_UPathoReceived'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.pathology(patient_id,'U')

patient_id = 'PT_SR10_NPathoReceived'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.pathology(patient_id,'N')

patient_id = 'PT_SR10_YPathoReceived'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.pathology(patient_id,'Y')

patient_id = 'PT_SR10_BdReceived'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_blood(patient_id)

patient_id = 'PT_SR10_TsVRRejected'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)
PatientMessageLoader.variant_file_uploaded(patient_id)
sleep(10)
PatientMessageLoader.variant_file_confirmed(patient_id, 'REJECTED')

patient_id = 'PT_SR10_TsReceived'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)

patient_id = 'PT_SR10_BdVRReceived'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_blood(patient_id)
PatientMessageLoader.specimen_shipped_blood(patient_id)
PatientMessageLoader.variant_file_uploaded(patient_id, 'MOI_BR_01')

patient_id = 'PT_SR10_BdVRRejected'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_blood(patient_id)
PatientMessageLoader.specimen_shipped_blood(patient_id)
PatientMessageLoader.variant_file_uploaded(patient_id, 'MOI_BR_01')
sleep(10)
PatientMessageLoader.variant_file_confirmed(patient_id, 'REJECTED', 'MOI_BR_01')

patient_id = 'PT_SR10_BdVRConfirmed'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_blood(patient_id)
PatientMessageLoader.specimen_shipped_blood(patient_id)
PatientMessageLoader.variant_file_uploaded(patient_id, 'MOI_BR_01')
sleep(10)
PatientMessageLoader.variant_file_confirmed(patient_id, 'CONFIRMED', 'MOI_BR_01')

PatientMessageLoader.register_patient('PT_SR11_Registered')

patient_id = 'PT_SR12_VariantReportConfirmed'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)
PatientMessageLoader.variant_file_uploaded(patient_id)
sleep(10)
PatientMessageLoader.variant_file_confirmed(patient_id, 'CONFIRMED')

patient_id = 'PT_SR14_VariantReportUploaded'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)
PatientMessageLoader.variant_file_uploaded(patient_id)

patient_id = 'PT_SR15_VariantReportUploaded'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)
PatientMessageLoader.variant_file_uploaded(patient_id)

PatientMessageLoader.upload_done
