require_relative '../patient_message_loader'

PatientMessageLoader.upload_start_with_wait_time(15)

patient_id = 'PT_VC10_VRUploaded_DiffSEI_DiffMOI'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)
PatientMessageLoader.variant_file_uploaded(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id, '2016-06-25T15:17:11+00:00', '2016-06-25T16:17:11+00:00', 'SEI_02')
PatientMessageLoader.specimen_shipped_tissue(patient_id, '2016-07-01T19:42:13+00:00', 'SEI_02', 'MOI_02')
PatientMessageLoader.variant_file_uploaded(patient_id, 'MOI_02', 'ANI_02')

patient_id = 'PT_VC10_VRUploaded_DiffSEI_SameMOI'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)
PatientMessageLoader.variant_file_uploaded(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id, '2016-06-25T15:17:11+00:00', '2016-06-25T16:17:11+00:00', 'SEI_02')
PatientMessageLoader.specimen_shipped_tissue(patient_id, '2016-07-01T19:42:13+00:00', 'SEI_02', 'MOI_01')
PatientMessageLoader.variant_file_uploaded(patient_id, 'MOI_01', 'ANI_01')

patient_id = 'PT_VC14_BdVRUploadedTsVRUploadedOtherReady'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_blood(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id,'2016-04-25T15:17:11+00:00', '2016-04-25T16:17:11+00:00', 'SEI_TR_01')
PatientMessageLoader.specimen_shipped_blood(patient_id, '2016-05-01T19:42:13+00:00', 'MOI_BR_01')
PatientMessageLoader.specimen_shipped_tissue(patient_id, '2016-05-01T19:48:13+00:00', 'SEI_TR_01', 'MOI_TR_01')
PatientMessageLoader.specimen_shipped_slide(patient_id, '2016-05-01T19:42:13+00:00', 'SEI_TR_01', 'BC_001')
PatientMessageLoader.pathology(patient_id)
PatientMessageLoader.assay(patient_id, 'NEGATIVE', 'ICCPTENs', 'SEI_TR_01')
PatientMessageLoader.assay(patient_id, 'NEGATIVE', 'ICCMLH1s', 'SEI_TR_01')
PatientMessageLoader.variant_file_uploaded(patient_id, 'MOI_TR_01', 'ANI_TR_01')
PatientMessageLoader.variant_file_uploaded(patient_id, 'MOI_BR_01', 'ANI_BR_01')

PatientMessageLoader.upload_done
