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

  def self.up_jwp01a_ts_shipped_to_mocha
    pt = PatientDataSet.new('UP_JWP01a_TsShippedToMocha')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi, '2016-05-01T19:42:13+00:00', 'MoCha')
  end

  def self.up_jwp01a_ts_shipped_to_mda
    pt = PatientDataSet.new('UP_JWP01a_TsShippedToMda')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
  end

  def self.up_jwp01c_ts_shipped_to_mocha
    pt = PatientDataSet.new('UP_JWP01c_TsShippedToMocha')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi, '2016-05-01T19:42:14+00:00', 'MoCha')
  end

  def self.up_jwp01c_ts_shipped_to_dartmouth
    pt = PatientDataSet.new('UP_JWP01c_TsShippedToDartmouth')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi, '2016-05-01T19:45:13+00:00', 'Dartmouth')
  end

  def self.up_jwp02a_ts_shipped_to_mda1
    pt = PatientDataSet.new('UP_JWP02a_TsShippedToMda1')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
  end

  def self.up_jwp02a_ts_shipped_to_mocha1
    pt = PatientDataSet.new('UP_JWP02a_TsShippedToMocha1')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi, '2016-05-01T19:42:14+00:00', 'MoCha')
  end

  def self.up_jwp02a_ts_shipped_to_dartmouth1
    pt = PatientDataSet.new('UP_JWP02a_TsShippedToDartmouth1')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi, '2016-05-01T19:45:13+00:00', 'Dartmouth')
  end

  def self.up_jwp02a_ts_shipped_to_mda2
    pt = PatientDataSet.new('UP_JWP02a_TsShippedToMda2')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
  end

  def self.up_jwp02a_ts_shipped_to_mocha2
    pt = PatientDataSet.new('UP_JWP02a_TsShippedToMocha2')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi, '2016-05-01T19:42:14+00:00', 'MoCha')
  end

  def self.up_jwp02a_ts_shipped_to_dartmouth2
    pt = PatientDataSet.new('UP_JWP02a_TsShippedToDartmouth2')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi, '2016-05-01T19:45:13+00:00', 'Dartmouth')
  end

  def self.up_jwp03a_ts_shipped_to_mda
    pt = PatientDataSet.new('UP_JWP03a_TsShippedToMda')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
  end

  def self.up_jwp03a_ts_shipped_to_dartmouth
    pt = PatientDataSet.new('UP_JWP03a_TsShippedToDartmouth')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi, '2016-05-01T19:45:13+00:00', 'Dartmouth')
  end

  def self.up_jwp04_ts_shipped_to_mda
    pt = PatientDataSet.new('UP_JWP04_TsShippedToMda')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
  end

  def self.up_jwp04_ts_shipped_to_mocha
    pt = PatientDataSet.new('UP_JWP04_TsShippedToMocha')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi, '2016-05-01T19:42:14+00:00', 'MoCha')
  end

  def self.up_jwp04_ts_shipped_to_dartmouth
    pt = PatientDataSet.new('UP_JWP04_TsShippedToDartmouth')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi, '2016-05-01T19:45:13+00:00', 'Dartmouth')
  end

  def self.up_jwp05_ts_shipped_to_mocha
    pt = PatientDataSet.new('UP_JWP05_TsShippedToMocha')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi, '2016-05-01T19:42:14+00:00', 'MoCha')
  end

  def self.up_jwp06_ts_shipped_to_mocha
    pt = PatientDataSet.new('UP_JWP06_TsShippedToMocha')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi, '2016-05-01T19:42:14+00:00', 'MoCha')
  end

  def self.up_jwp06_ts_shipped_to_dartmouth
    pt = PatientDataSet.new('UP_JWP06_TsShippedToDartmouth')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi, '2016-05-01T19:45:13+00:00', 'Dartmouth')
  end

  def self.up_jwn05_ts_shipped_to_mda
    pt = PatientDataSet.new('UP_JWN05_TsShippedToMda')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
  end

  def self.up_jwn06_ts_shipped_to_mda_twice
    pt = PatientDataSet.new('UP_JWN06_TsShippedToMdaTwice')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi_increase, '2016-05-02T19:45:13+00:00')
  end

  def self.pt_jwn07_ts_vr_uploaded
    pt = PatientDataSet.new('PT_JWN07_TsVrUploaded')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
  end
end