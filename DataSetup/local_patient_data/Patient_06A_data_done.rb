require_relative '../patient_message_loader'

PatientMessageLoader.upload_start_with_wait_time(15)

patient_id = 'PT_VU02_TissueShipped'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)

patient_id = 'PT_VU03_TissueShipped'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)

patient_id = 'PT_VU04_TissueShipped'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)

patient_id = 'PT_VU05_TissueShipped'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)

patient_id = 'PT_VU06_TissueShipped'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)

patient_id = 'PT_VU08_TissueShipped'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)

patient_id = 'PT_VU09_VariantReportUploaded'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)
PatientMessageLoader.variant_file_uploaded(patient_id)

patient_id = 'PT_VU10_VariantReportUploaded'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)
PatientMessageLoader.variant_file_uploaded(patient_id)

patient_id = 'PT_VU11_VariantReportRejected'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)
PatientMessageLoader.variant_file_uploaded(patient_id)
PatientMessageLoader.variant_file_confirmed(patient_id, 'REJECTED')

patient_id = 'PT_VU12_VariantReportRejected'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)
PatientMessageLoader.variant_file_uploaded(patient_id)
PatientMessageLoader.variant_file_confirmed(patient_id, 'REJECTED')
PatientMessageLoader.variant_file_uploaded(patient_id, 'MOI_01', 'ANI_02')
PatientMessageLoader.variant_file_confirmed(patient_id, 'REJECTED', 'MOI_01', 'ANI_02')

patient_id = 'PT_VU13_VariantReportConfirmed'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)
PatientMessageLoader.variant_file_uploaded(patient_id)
PatientMessageLoader.variant_file_confirmed(patient_id, 'CONFIRMED')

patient_id = 'PT_VU14_TissueAndBloodShipped'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_blood(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id, '2016-05-01T19:42:13+00:00', 'SEI_01', 'MOI_TR_01')
PatientMessageLoader.specimen_shipped_blood(patient_id, '2016-05-01T19:42:13+00:00', 'MOI_BR_01')

patient_id = 'PT_VU16_BdVRUploaded'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_blood(patient_id)
PatientMessageLoader.specimen_shipped_blood(patient_id, '2016-05-01T19:42:13+00:00', 'MOI_BR_01')
PatientMessageLoader.variant_file_uploaded(patient_id, 'MOI_BR_01', 'ANI_BR_01')

PatientMessageLoader.upload_done
