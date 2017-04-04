require_relative '../patient_message_loader'

class PatientUploader
  def self.upload_all
    PatientMessageLoader.upload_start_with_wait_time(15)
    self.methods.each { |method|
      method_name = method.to_s
      if method_name.start_with?('up_')
        self.send(method_name)
      end
    }
    PatientMessageLoader.upload_done
  end

  def self.upload_patient(patient_id)
    PatientMessageLoader.upload_start_with_wait_time(15)
    if self.respond_to?(patient_id.underscore)
      self.send(patient_id.underscore)
    else
      raise("Patient #{patient_id} doesn't exist")
    end
    PatientMessageLoader.upload_done
  end

  def self.up_jwp01a_ts_shipped_to_mda
    pt = PatientDataSet.new('UP_JWP01a_TsShippedToMda')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
  end

  def self.up_jwp01a_ts_shipped_to_mocha
    pt = PatientDataSet.new('UP_JWP01a_TsShippedToMocha')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
  end
end