require_relative '../patient_message_loader'


Environment.setTier 'local' #set this value to 'local' if you are running tests on your local machine.

Auth0Token.force_generate_auth0_token('ADMIN')
PatientMessageLoader.upload_start_with_wait_time(15)

#


pt = PatientDataSet.new('PT_SR17_Registered')
PatientMessageLoader.register_patient(pt.id)




PatientMessageLoader.upload_done
