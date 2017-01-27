require_relative '../patient_message_loader'

class Patient03A
  def self.upload_all
    PatientMessageLoader.upload_start_with_wait_time(15)
    Patient03A.methods.each { |method|
      method_name = method.to_s
      if method_name.start_with?('pt_') || method_name.start_with?('ion_')
        Patient03A.send(method_name)
      end
    }
    PatientMessageLoader.upload_done
  end

  def self.upload_patient(patient_id)
    PatientMessageLoader.upload_start_with_wait_time(15)
    if Patient03A.respond_to?(patient_id.underscore)
      Patient03A.send(patient_id.underscore)
    else
      raise("Patient #{patient_id} doesn't exist")
    end
    PatientMessageLoader.upload_done
  end

  def self.pt_ss01_blood_received
    pt = PatientDataSet.new('PT_SS01_BloodReceived')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_blood(pt.id)
  end

  def self.pt_ss02_tissue_received
    pt = PatientDataSet.new('PT_SS02_TissueReceived')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
  end

  def self.pt_ss02a_ts_vr_rejected
    pt = PatientDataSet.new('PT_SS02a_TsVrRejected')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.variant_file_confirmed(pt.id, 'reject', pt.ani)
  end

  def self.pt_ss02b_ts_received
    pt = PatientDataSet.new('PT_SS02b_TsReceived')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
  end

  def self.pt_ss03_tissue_received
    pt = PatientDataSet.new('PT_SS03_TissueReceived')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
  end

  def self.pt_ss05_tissue_received
    pt = PatientDataSet.new('PT_SS05_TissueReceived')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
  end

  def self.pt_ss06_tissue_received
    pt = PatientDataSet.new('PT_SS06_TissueReceived')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
  end

  def self.pt_ss06a_tissue_shipped
    pt = PatientDataSet.new('PT_SS06a_TissueShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
  end

  def self.pt_ss07_tissue_received
    pt = PatientDataSet.new('PT_SS07_TissueReceived')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
  end

  def self.pt_ss08_tissue_received
    pt = PatientDataSet.new('PT_SS08_TissueReceived')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei_increase, '2016-04-26')
  end

  def self.pt_ss08a_tissue_received1a
    pt = PatientDataSet.new('PT_SS08a_TissueReceived1a')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
  end

  def self.pt_ss08a_tissue_received1b
    pt = PatientDataSet.new('PT_SS08a_TissueReceived1b')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
  end

  def self.pt_ss08a_tissue_received2a
    pt = PatientDataSet.new('PT_SS08a_TissueReceived2a')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
  end

  def self.pt_ss08a_tissue_received2b
    pt = PatientDataSet.new('PT_SS08a_TissueReceived2b')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
  end

  def self.pt_ss09_tissue_received
    pt = PatientDataSet.new('PT_SS09_TissueReceived')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
  end

  def self.pt_ss10_tissue_received
    pt = PatientDataSet.new('PT_SS10_TissueReceived')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
  end

  def self.pt_ss11_tissue1_shipped
    pt = PatientDataSet.new('PT_SS11_Tissue1Shipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi_increase, '2016-05-01T22:42:13+00:00')
  end

  def self.pt_ss12_tissue1_shipped
    pt = PatientDataSet.new('PT_SS12_Tissue1Shipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
  end

  def self.pt_ss14_tissue_received
    pt = PatientDataSet.new('PT_SS14_TissueReceived')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
  end

  def self.pt_ss15_slide1_shipped
    pt = PatientDataSet.new('PT_SS15_Slide1Shipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
  end

  def self.pt_ss16_slide1_shipped
    pt = PatientDataSet.new('PT_SS16_Slide1Shipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
  end

  def self.pt_ss17_registered
    pt = PatientDataSet.new('PT_SS17_Registered')
    PatientMessageLoader.register_patient(pt.id)
  end

  def self.pt_ss17a_registered
    pt = PatientDataSet.new('PT_SS17a_Registered')
    PatientMessageLoader.register_patient(pt.id)
  end

  def self.pt_ss17b_registered
    pt = PatientDataSet.new('PT_SS17b_Registered')
    PatientMessageLoader.register_patient(pt.id)
  end

  def self.pt_ss20_blood1_shipped
    pt = PatientDataSet.new('PT_SS20_Blood1Shipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_blood(pt.id)
    PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)
  end

  def self.pt_ss23_tissue_received1
    pt = PatientDataSet.new('PT_SS23_TissueReceived1')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
  end

  def self.pt_ss23_tissue_received2
    pt = PatientDataSet.new('PT_SS23_TissueReceived2')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
  end

  def self.pt_ss23_slide_shipped
    pt = PatientDataSet.new('PT_SS23_SlideShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
  end

  def self.pt_ss23_tissue_shipped
    pt = PatientDataSet.new('PT_SS23_TissueShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
  end

  def self.pt_ss24_blood_shipped
    pt = PatientDataSet.new('PT_SS24_BloodShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_blood(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)
  end

  def self.pt_ss24_tissue_shipped
    pt = PatientDataSet.new('PT_SS24_TissueShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_blood(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
  end

  def self.pt_ss25_blood_shipped
    pt = PatientDataSet.new('PT_SS25_BloodShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_blood(pt.id)
    PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)
    PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi_increase, '2016-05-01T22:42:13+00:00')
  end

  def self.pt_ss26_ts_received
    pt = PatientDataSet.new('PT_SS26_TsReceived')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_blood(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
  end

  def self.pt_ss26_ts_shipped
    pt = PatientDataSet.new('PT_SS26_TsShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_blood(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
  end

  def self.pt_ss26_assay_confirmed
    pt = PatientDataSet.new('PT_SS26_AssayConfirmed')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_blood(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
    PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs')
  end

  def self.pt_ss28_tissue_received1
    pt = PatientDataSet.new('PT_SS28_TissueReceived1')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
  end

  def self.pt_ss28_tissue_received2
    pt = PatientDataSet.new('PT_SS28_TissueReceived2')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
  end

  def self.pt_ss28_tissue_received3
    pt = PatientDataSet.new('PT_SS28_TissueReceived3')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
  end

  def self.pt_ss28_tissue_received4
    pt = PatientDataSet.new('PT_SS28_TissueReceived4')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
  end

  def self.pt_ss28_tissue_received5
    pt = PatientDataSet.new('PT_SS28_TissueReceived5')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
  end

  def self.pt_ss28_blood_received1
    pt = PatientDataSet.new('PT_SS28_BloodReceived1')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_blood(pt.id)
  end

  def self.pt_ss28_blood_received2
    pt = PatientDataSet.new('PT_SS28_BloodReceived2')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_blood(pt.id)
  end

  def self.pt_ss28_blood_received3
    pt = PatientDataSet.new('PT_SS28_BloodReceived3')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_blood(pt.id)
  end

  def self.pt_ss21_tissue_variant_confirmed
    pt = PatientDataSet.new('PT_SS21_TissueVariantConfirmed')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.variant_file_confirmed(pt.id, 'confirm', pt.ani)
  end

  def self.pt_ss26_ts_vr_received
    pt = PatientDataSet.new('PT_SS26_TsVRReceived')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_blood(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
  end

  def self.pt_ss26_ts_vr_confirmed
    pt = PatientDataSet.new('PT_SS26_TsVRConfirmed')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_blood(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
    sleep(10.0)
    PatientMessageLoader.variant_file_confirmed(pt.id, 'confirm', pt.ani)
  end

  def self.pt_ss27_variant_report_uploaded
    pt = PatientDataSet.new('PT_SS27_VariantReportUploaded')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
  end

  def self.pt_ss30_ts_bd_received
    pt = PatientDataSet.new('PT_SS30_TsBdReceived')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_blood(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
  end

  def self.pt_ss26_pending_approval1
    pt = PatientDataSet.new('PT_SS26_PendingApproval1')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_blood(pt.id)
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
  end

  def self.pt_ss26_request_assignment
    pt = PatientDataSet.new('PT_SS26_RequestAssignment')
    PatientMessageLoader.reset_cog_patient(pt.id)
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_blood(pt.id)
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
    sleep(10.0)
    PatientMessageLoader.on_treatment_arm(pt.id, 'APEC1621-A')
    PatientMessageLoader.request_assignment(pt.id)
  end

  def self.pt_ss31_no_ta_available
    pt = PatientDataSet.new('PT_SS31_NoTaAvailable')
    PatientMessageLoader.reset_cog_patient(pt.id)
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
    PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs')
    PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCBAF47s')
    PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCBRG1s')
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani, 'no_ta_available')
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.variant_file_confirmed(pt.id, 'confirm', pt.ani)
    sleep(10.0)
    PatientMessageLoader.assignment_confirmed(pt.id, pt.ani)
  end

  def self.pt_ss31_compassionate_care
    pt = PatientDataSet.new('PT_SS31_CompassionateCare')
    PatientMessageLoader.reset_cog_patient(pt.id)
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
    PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs')
    PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCBAF47s')
    PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCBRG1s')
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani, 'compassionate_care')
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.variant_file_confirmed(pt.id, 'confirm', pt.ani)
    sleep(10.0)
    PatientMessageLoader.assignment_confirmed(pt.id, pt.ani)
  end


end