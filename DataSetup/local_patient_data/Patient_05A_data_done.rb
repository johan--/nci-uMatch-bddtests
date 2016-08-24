require_relative '../patient_message_loader'

PatientMessageLoader.upload_start_with_wait_time(15)

patient_id = 'PT_PR02_TissueReceived'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)

patient_id = 'PT_PR03_TissueReceived'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)

patient_id = 'PT_PR04_TissueReceived'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)

patient_id = 'PT_PR05_TissueReceived'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)

patient_id = 'PT_PR06_TissueReceived'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)

patient_id = 'PT_PR07_TissueShipped'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)

patient_id = 'PT_PR08_SlideShipped'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_slide(patient_id)

PatientMessageLoader.register_patient('PT_PR09_Registered')

patient_id = 'PT_PR09_SEI1HasTissue'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)

patient_id = 'PT_PR10TissueReceived'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)

patient_id = 'PT_PR11TissueReceived'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id, '2016-04-28T15:17:11+00:00', 'SEI_02')

patient_id = 'PT_PR12TissueReceived'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)

patient_id = 'PT_PR12_PathologyYReceived'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.pathology(patient_id)

patient_id = 'PT_PR12_PathologyNReceived'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.pathology(patient_id, 'N')

patient_id = 'PT_PR12_PathologyUReceived1'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.pathology(patient_id, 'U')

patient_id = 'PT_PR12_PathologyUReceived2'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.pathology(patient_id, 'U')

patient_id = 'PT_PR12_PathologyUReceived3'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.pathology(patient_id, 'U')

PatientMessageLoader.upload_done
