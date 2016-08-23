require_relative '../patient_message_loader'

PatientMessageLoader.upload_start_with_wait_time(1)
PatientMessageLoader.register_patient('PT_RG02_ExistingPatient')
PatientMessageLoader.upload_done
