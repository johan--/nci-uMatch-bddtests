require_relative '../patient_message_loader'

PatientMessageLoader.upload_start_with_wait_time(15)

patient_id = 'PT_SS01_BloodReceived'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_blood(patient_id)

patient_id = 'PT_SS02_TissueReceived'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)

patient_id = 'PT_SS03_TissueReceived'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)

patient_id = 'PT_SS05_TissueReceived'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)

patient_id = 'PT_SS06_TissueReceived'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)

patient_id = 'PT_SS07_TissueReceived'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)

patient_id = 'PT_SS08_TissueReceived'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id, '2016-04-28T15:17:11+00:00', '2016-04-28T16:17:11+00:00', 'SEI_02')

patient_id = 'PT_SS09_TissueReceived'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)

patient_id = 'PT_SS10_TissueReceived'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)

patient_id = 'PT_SS11_Tissue1Shipped'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)

patient_id = 'PT_SS12_Tissue1Shipped'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)

patient_id = 'PT_SS13_TissueReceived'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)

patient_id = 'PT_SS14_TissueReceived'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)

patient_id = 'PT_SS15_Slide1Shipped'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)
PatientMessageLoader.specimen_shipped_slide(patient_id)

patient_id = 'PT_SS16_Slide1Shipped'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)
PatientMessageLoader.specimen_shipped_slide(patient_id)

PatientMessageLoader.register_patient('PT_SS17_Registered')

patient_id = 'PT_SS18_BloodReceived'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_blood(patient_id)

patient_id = 'PT_SS19_Blood1Shipped'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_blood(patient_id)
PatientMessageLoader.specimen_shipped_blood(patient_id)

patient_id = 'PT_SS20_Blood1Shipped'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_blood(patient_id)
PatientMessageLoader.specimen_shipped_blood(patient_id)

patient_id = 'PT_SS20_Blood1Shipped'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_blood(patient_id)
PatientMessageLoader.specimen_shipped_blood(patient_id)

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

patient_id = 'PT_SS23_TissueReceived1'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)

patient_id = 'PT_SS23_TissueReceived2'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)

patient_id = 'PT_SS23_SlideShipped'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)
PatientMessageLoader.specimen_shipped_slide(patient_id)

patient_id = 'PT_SS23_TissueShipped'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)

patient_id = 'PT_SS24_BloodShipped'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_blood(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_blood(patient_id)

patient_id = 'PT_SS24_TissueShipped'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_blood(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)

patient_id = 'PT_SS25_BloodShipped'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_blood(patient_id)
PatientMessageLoader.specimen_shipped_blood(patient_id)

patient_id = 'PT_SS26_TsReceived'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_blood(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)

patient_id = 'PT_SS26_TsShipped'
PatientMessageLoader.register_patient(patient_id)
PatientMessageLoader.specimen_received_blood(patient_id)
PatientMessageLoader.specimen_received_tissue(patient_id)
PatientMessageLoader.specimen_shipped_tissue(patient_id)


PatientMessageLoader.upload_done
