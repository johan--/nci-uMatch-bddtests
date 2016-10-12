require_relative '../ion_message_loader'
require_relative '../patient_message_loader'


PatientMessageLoader.upload_start_with_wait_time(15.0)


PatientMessageLoader.upload_done