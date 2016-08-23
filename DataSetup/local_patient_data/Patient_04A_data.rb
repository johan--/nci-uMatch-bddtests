require_relative '../patient_message_loader'

PatientMessageLoader.upload_start_with_wait_time(15)

patient_id = 'PT_AS08_SEI1HasSlideSEI2NoSlide'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)
PatientMessageLoader.specimen_shipped_slide(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id, '2016-05-28T15:17:11+00:00', '2016-05-28T16:17:11+00:00', 'SEI_02')

patient_id = 'PT_AS10SlideShipped'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)
PatientMessageLoader.specimen_shipped_slide(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id, '2016-04-28T15:17:11+00:00', '2016-04-28T16:17:11+00:00', 'SEI_02')
PatientMessageLoader.specimen_shipped_tissue(patient_id, '2016-06-01T19:42:13+00:00', 'SEI_02', 'MOI_02')
PatientMessageLoader.specimen_shipped_slide(patient_id, '2016-06-04T19:42:13+00:00', 'SEI_02', 'BC_002')

patient_id = 'PT_AS12_VRConfirmedNoPatho'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)
PatientMessageLoader.variant_file_uploaded(patient_id)
PatientMessageLoader.variant_file_confirmed(patient_id, 'CONFIRMED')

patient_id = 'PT_AS12_PathoConfirmedNoVR'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)
PatientMessageLoader.pathology(patient_id)

patient_id = 'PT_AS12_VRAndPathoConfrimed'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)
PatientMessageLoader.pathology(patient_id,'Y')
PatientMessageLoader.variant_file_uploaded(patient_id)
PatientMessageLoader.variant_file_confirmed(patient_id, 'CONFIRMED')

PatientMessageLoader.upload_done
