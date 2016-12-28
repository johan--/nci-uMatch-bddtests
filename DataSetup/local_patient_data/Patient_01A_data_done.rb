require_relative '../patient_message_loader'

class Patient01A
  def self.upload_all
    PatientMessageLoader.upload_start_with_wait_time(15)
    Patient01A.methods.each { |method|
      method_name = method.to_s
      if method_name.start_with?('pt_') || method_name.start_with?('ion_')
        Patient01A.send(method_name)
      end
    }
    PatientMessageLoader.upload_done
  end

  def self.upload_patient(patient_id)
    PatientMessageLoader.upload_start_with_wait_time(15)
    if Patient01A.respond_to?(patient_id.underscore)
      Patient01A.send(patient_id.underscore)
    else
      raise("Patient #{patient_id} doesn't exist")
    end
    PatientMessageLoader.upload_done
  end

  def self.pt_rg02_existing_patient
    pt = PatientDataSet.new('PT_RG02_ExistingPatient')
    PatientMessageLoader.register_patient(pt.id)
  end


end