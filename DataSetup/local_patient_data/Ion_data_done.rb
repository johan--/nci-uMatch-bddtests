require_relative '../ion_message_loader'
require_relative '../patient_message_loader'


class Iondata
  def self.upload_all
    PatientMessageLoader.upload_start_with_wait_time(15)
    Iondata.methods.each { |method|
      method_name = method.to_s
      if method_name.start_with?('pt_') || method_name.start_with?('ion_')
        Iondata.send(method_name)
      end
    }
    PatientMessageLoader.upload_done
  end

  def self.upload_patient(patient_id)
    PatientMessageLoader.upload_start_with_wait_time(15)
    if Iondata.respond_to?(patient_id.underscore)
      Iondata.send(patient_id.underscore)
    else
      raise("Patient #{patient_id} doesn't exist")
    end
    PatientMessageLoader.upload_done
  end

  def self.ion_sc22_ts_shipped
    pt = PatientDataSet.new('ION_SC22_TsShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
  end

  def self.ion_sc43_ts_shipped
    pt = PatientDataSet.new('ION_SC43_TsShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
  end

  def self.ion_aq02_ts_shipped
    pt = PatientDataSet.new('ION_AQ02_TsShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
  end

  def self.ion_aq03_bd_shipped
    pt = PatientDataSet.new('ION_AQ03_BdShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_blood(pt.id)
    PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)
  end

  def self.ion_aq04_ts_shipped
    pt = PatientDataSet.new('ION_AQ04_TsShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
  end

  def self.ion_aq23_ts_shipped
    pt = PatientDataSet.new('ION_AQ23_TsShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
  end

  def self.ion_aq24_ts_shipped
    pt = PatientDataSet.new('ION_AQ24_TsShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
  end

  def self.ion_aq80_ts_shipped
    pt = PatientDataSet.new('ION_AQ80_TsShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
  end

  def self.ion_aq81_ts_shipped
    pt = PatientDataSet.new('ION_AQ81_TsShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
  end

  def self.ion_aq41_ts_vr_uploaded
    pt = PatientDataSet.new('ION_AQ41_TsVrUploaded')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
  end

  def self.ion_aq42_bd_vr_uploaded
    pt = PatientDataSet.new('ION_AQ42_BdVrUploaded')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_blood(pt.id)
    PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.bd_moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.bd_moi, pt.ani)
  end

  def self.ion_aq43_ts_vr_uploaded
    pt = PatientDataSet.new('ION_AQ43_TsVrUploaded')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
  end

  def self.ion_sf03_ts_vr_uploaded
    pt = PatientDataSet.new('ION_SF03_TsVrUploaded')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
  end

  def self.ion_fl02_ts_vr_uploaded
    pt = PatientDataSet.new('ION_FL02_TsVrUploaded')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
  end

  def self.pt_ir01_on_treatment_arm
    pt = PatientDataSet.new('PT_IR01_OnTreatmentArm')
    PatientMessageLoader.reset_cog_patient(pt.id)
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_blood(pt.id, '2016-05-10')
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei, '2016-09-11')
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi, '2016-09-12T19:42:13+00:00')
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi_increase, '2016-09-13T19:42:13+00:00')
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc, '2016-09-13T19:42:13+00:00')
    PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs', '2016-09-15T13:12:09.071-05:00')
    PatientMessageLoader.assay(pt.id, pt.sei, 'POSITIVE', 'ICCBRG1s', '2016-09-16T12:12:09.071-05:00')
    PatientMessageLoader.assay(pt.id, pt.sei, 'POSITIVE', 'ICCBAF47s', '2016-09-15T13:12:09.071-05:00')
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani, 'default', 'bdd_test_ion_reporter', '3366.tsv')
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.variant_file_confirmed(pt.id, 'confirm', pt.ani)
    sleep(10.0)
    PatientMessageLoader.assignment_confirmed(pt.id, pt.ani)
    # sleep(5.0)
    # PatientMessageLoader.on_treatment_arm(pt.id, 'APEC1621-IR-A')
  end

  def self.ion_aq61_vr_confirmed
    pt = PatientDataSet.new('ION_AQ61_VrConfirmed')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
  end

  def self.ion_aq63_ts_shipped
    pt = PatientDataSet.new('ION_AQ63_TsShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
  end

  def self.ion_aq63_bd_shipped
    pt = PatientDataSet.new('ION_AQ63_BdShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_blood(pt.id)
    PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)
  end

  def self.ion_aq06_ts_shipped
    pt = PatientDataSet.new('ION_AQ06_TsShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
  end

  def self.ion_aq07_ts_shipped1
    pt = PatientDataSet.new('ION_AQ07_TsShipped1')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
  end

  def self.ion_aq07_ts_shipped2
    pt = PatientDataSet.new('ION_AQ07_TsShipped2')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
  end

  def self.ion_aq08_ts_shipped
    pt = PatientDataSet.new('ION_AQ08_TsShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
  end

  def self.ion_aq08_cdna_uploaded1
    pt = PatientDataSet.new('ION_AQ08_CdnaUploaded1')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.file_uploaded_cdna(pt.id, pt.moi, pt.ani)
  end

    def self.ion_aq08_cdna_uploaded2
      pt = PatientDataSet.new('ION_AQ08_CdnaUploaded2')
      PatientMessageLoader.register_patient(pt.id)
      PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
      PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
      PatientMessageLoader.file_uploaded_cdna(pt.id, pt.moi, pt.ani)
    end

  def self.ion_aq08_ts_vr_uploaded1
    pt = PatientDataSet.new('ION_AQ08_TsVrUploaded1')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
  end

  def self.ion_aq08_ts_vr_uploaded2
    pt = PatientDataSet.new('ION_AQ08_TsVrUploaded2')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
  end
end


# PatientMessageLoader.upload_start_with_wait_time(15.0)
# pt = PatientDataSet.new('ION_SC22_TsShipped')
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
# PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
#
# pt = PatientDataSet.new('ION_SC43_TsShipped')
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
# PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
#
# pt = PatientDataSet.new('ION_AQ02_TsShipped')
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
# PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
#
# pt = PatientDataSet.new('ION_AQ03_BdShipped')
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_blood(pt.id)
# PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)
#
# pt = PatientDataSet.new('ION_AQ04_TsShipped')
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
# PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
#
# pt = PatientDataSet.new('ION_AQ23_TsShipped')
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
# PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
#
# pt = PatientDataSet.new('ION_AQ24_TsShipped')
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
# PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
#
# pt = PatientDataSet.new('ION_AQ80_TsShipped')
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
# PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
#
# pt = PatientDataSet.new('ION_AQ81_TsShipped')
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
# PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
#
# pt = PatientDataSet.new('ION_AQ41_TsVrUploaded')
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
# PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
# PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
# PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
#
# pt = PatientDataSet.new('ION_AQ42_BdVrUploaded')
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_blood(pt.id)
# PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)
# PatientMessageLoader.variant_file_uploaded(pt.id, pt.bd_moi, pt.ani)
# PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.bd_moi, pt.ani)
#
# pt = PatientDataSet.new('ION_AQ43_TsVrUploaded')
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
# PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
# PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
# PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
#
# pt = PatientDataSet.new('ION_SF03_TsVrUploaded')
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
# PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
# PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
# PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
#
# pt = PatientDataSet.new('ION_FL02_TsVrUploaded')
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
# PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
# PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
# PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
#
# PatientMessageLoader.upload_done