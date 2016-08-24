require_relative '../patient_message_loader'

PatientMessageLoader.upload_start_with_wait_time(15)

patient_id = 'PT_SS21_TissueVariantConfirmed'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)
PatientMessageLoader.variant_file_uploaded(patient_id)
PatientMessageLoader.variant_file_confirmed(patient_id, 'CONFIRMED')

patient_id = 'PT_SS22_BloodVariantConfirmed'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_blood(patient_id)
PatientMessageLoader.specimen_shipped_blood(patient_id)
PatientMessageLoader.variant_file_uploaded(patient_id, 'MOI_BR_01')
PatientMessageLoader.variant_file_confirmed(patient_id, 'CONFIRMED', 'MOI_BR_01')

patient_id = 'PT_SS26_AssayConfirmed'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_slide(patient_id)
PatientMessageLoader.assay(patient_id, 'NEGATIVE', 'ICCPTENs')

patient_id = 'PT_SS26_PathologyConfirmed'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.pathology(patient_id,'Y')

patient_id = 'PT_SS26_TsVRReceived'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)
PatientMessageLoader.variant_file_uploaded(patient_id)

patient_id = 'PT_SS26_TsVRConfirmed'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)
PatientMessageLoader.variant_file_uploaded(patient_id)
PatientMessageLoader.variant_file_confirmed(patient_id, 'CONFIRMED')

patient_id = 'PT_SS27_VariantReportUploaded'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)
PatientMessageLoader.variant_file_uploaded(patient_id)

patient_id = 'PT_SS28_TissueReceived1'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)

patient_id = 'PT_SS28_TissueReceived2'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)

patient_id = 'PT_SS28_TissueReceived3'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)

patient_id = 'PT_SS28_TissueReceived4'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)

patient_id = 'PT_SS28_TissueReceived5'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)

patient_id = 'PT_SS28_BloodReceived1'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)

patient_id = 'PT_SS28_BloodReceived2'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_blood(patient_id)

patient_id = 'PT_SS28_BloodReceived3'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_blood(patient_id)


PatientMessageLoader.upload_done
