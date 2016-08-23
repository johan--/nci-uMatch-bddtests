require_relative '../patient_message_loader'

PatientMessageLoader.upload_start_with_wait_time(15)

patient_id = 'PT_VU07_SlideShippedNoTissueShipped'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_slide(patient_id)

patient_id = 'PT_VU15_TissueReceivedAndShippedTwice'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id, '2016-05-25T15:17:11+00:00', '016-05-25T16:17:11+00:00', 'SEI_02')
PatientMessageLoader.specimen_shipped_tissue(patient_id, '2016-06-01T19:42:13+00:00', 'SEI_02')

PatientMessageLoader.upload_done
