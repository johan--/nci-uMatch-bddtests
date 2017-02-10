require_relative '../patient_message_loader'

class PatientTemplate
  def self.upload_all
    PatientMessageLoader.upload_start_with_wait_time(15)
    self.methods.each { |method|
      method_name = method.to_s
      if method_name.start_with?('pt_') || method_name.start_with?('ion_')
        self.send(method_name)
      end
    }
    PatientMessageLoader.upload_done
  end

  def self.upload_patient(patient_id)
    if PatientMessageLoader.patient_exist(patient_id)
      puts "#{patient_id} exists, skip"
      return
    end
    PatientMessageLoader.upload_start_with_wait_time(15)
    if self.respond_to?(patient_id.underscore)
      self.send(patient_id.underscore)
    else
      raise("Patient #{patient_id} doesn't exist")
    end
    PatientMessageLoader.upload_done
  end

  def self.pt_tmp_registered
    pt = PatientDataSet.new('PT_TMP_Registered')
    PatientMessageLoader.register_patient(pt.id, 'current')
  end


  def self.pt_tmp_ts_received
    pt = PatientDataSet.new('PT_TMP_TsReceived')
    PatientMessageLoader.register_patient(pt.id, 'current')
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei, 'current')
  end

  def self.pt_tmp_ts_shipped
    pt = PatientDataSet.new('PT_TMP_TsShipped')
    PatientMessageLoader.register_patient(pt.id, 'current')
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei, 'current')
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi, 'current')
  end

  def self.pt_tmp_slide_shipped
    pt = PatientDataSet.new('PT_TMP_SlideShipped')
    PatientMessageLoader.register_patient(pt.id, 'current')
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei, 'current')
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi, 'current')
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc, 'current')
  end

  def self.pt_tmp_assay_received
    pt = PatientDataSet.new('PT_TMP_AssayReceived')
    PatientMessageLoader.register_patient(pt.id, 'current')
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei, 'current')
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi, 'current')
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc, 'current')
    PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs', 'current')
    PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCBAF47s', 'current')
    PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCBRG1s', 'current')
  end
end