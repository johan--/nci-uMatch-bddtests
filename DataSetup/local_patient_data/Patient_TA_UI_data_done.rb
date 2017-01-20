require_relative '../patient_message_loader'

class PatientTA
  def self.upload_all
    PatientMessageLoader.upload_start_with_wait_time(15)
    PatientTA.methods.each { |method|
      method_name = method.to_s
      if method_name.start_with?('pt_') || method_name.start_with?('ion_')
        PatientTA.send(method_name)
      end
    }
    PatientMessageLoader.upload_done
  end

  def self.upload_patient(patient_id)
    PatientMessageLoader.upload_start_with_wait_time(15)
    if PatientTA.respond_to?(patient_id.underscore)
      PatientTA.send(patient_id.underscore)
    else
      raise("Patient #{patient_id} doesn't exist")
    end
    PatientMessageLoader.upload_done
  end

  def self.pt_cr01_path_assay_done_vr_uploaded_to_confirm
    pt = PatientDataSet.new('PT_CR01_PathAssayDoneVRUploadedToConfirm')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs')
    PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCBAF47s')
    PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCBRG1s')
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
  end

  def self.pt_cr02_on_treatment_arm
    pt = PatientDataSet.new('PT_CR02_OnTreatmentArm')
    PatientMessageLoader.reset_cog_patient(pt.id)
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
    PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs')
    PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCBAF47s')
    PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCBRG1s')
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.variant_file_confirmed(pt.id, 'confirm', pt.ani)
    sleep(10.0)
    PatientMessageLoader.assignment_confirmed(pt.id, pt.ani)
    sleep(5.0)
    PatientMessageLoader.on_treatment_arm(pt.id, 'APEC1621-A')
  end

  def self.pt_cr03_vr_uploaded_path_confirmed
    pt = PatientDataSet.new('PT_CR03_VRUploadedPathConfirmed')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
  end

  def self.pt_cr04_vr_uploaded_assay_received
    pt = PatientDataSet.new('PT_CR04_VRUploadedAssayReceived')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs')
    PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCBAF47s')
    PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCBRG1s')
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
  end

  def self.pt_cr05_specimen_shipped_twice
    pt = PatientDataSet.new('PT_CR05_SpecimenShippedTwice')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi_increase, '2016-05-02T19:42:13+00:00')
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani_increase)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
  end

  def self.pt_cr06_reject_one_variant
    pt = PatientDataSet.new('PT_CR06_RejectOneVariant')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
  end

  def self.pt_cr07_reject_variant_report
    pt = PatientDataSet.new('PT_CR07_RejectVariantReport')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
  end

  def self.pt_cr08_blood_specimen_uploaded
    begin
    pt = PatientDataSet.new('PT_CR08_BloodSpecimenUploaded')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_blood(pt.id)
    PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)
     PatientMessageLoader.variant_file_uploaded(pt.id, pt.bd_moi, pt.ani)
    # PatientMessageLoader.variant_file_uploaded(pt.id, pt.bd_moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.bd_moi, pt.ani)
    rescue => e
      p e.backtrace
    end

  end

end





# PatientMessageLoader.upload_start_with_wait_time(15)
#
# pt = PatientDataSet.new('PT_CR01_PathAssayDoneVRUploadedToConfirm')
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
# PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
# PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
# PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs')
# PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCBAF47s')
# PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
# PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
#
# pt = PatientDataSet.new('PT_CR02_OnTreatmentArm')
# PatientMessageLoader.reset_cog_patient(pt.id)
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
# PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
# PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
# PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs')
# PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCBAF47s')
# PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
# PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
# PatientMessageLoader.variant_file_confirmed(pt.id, 'confirm', pt.ani)
# sleep(10.0)
# PatientMessageLoader.assignment_confirmed(pt.id, pt.ani)
# sleep(5.0)
# PatientMessageLoader.on_treatment_arm(pt.id, 'APEC1621-A')
#
# pt = PatientDataSet.new('PT_CR03_VRUploadedPathConfirmed')
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
# PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
# PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
# PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
# PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
#
# pt = PatientDataSet.new('PT_CR04_VRUploadedAssayReceived')
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
# PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
# PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
# PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs')
# PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCBAF47s')
# PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
# PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
#
# pt = PatientDataSet.new('PT_CR05_SpecimenShippedTwice')
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
# PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
# PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
# PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
# PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi_increase, '2016-05-02T19:42:13+00:00')
# PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani_increase)
# PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
#
# pt = PatientDataSet.new('PT_CR06_RejectOneVariant')
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
# PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
# PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
# PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
# PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
#
# pt = PatientDataSet.new('PT_CR07_RejectVariantReport')
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
# PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
# PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
# PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
# PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
#
# PatientMessageLoader.upload_done
