require_relative '../patient_message_loader'


class Patient02A
  def self.upload_all
    PatientMessageLoader.upload_start_with_wait_time(15)
    Patient02A.methods.each { |method|
      method_name = method.to_s
      if method_name.start_with?('pt_') || method_name.start_with?('ion_')
        Patient02A.send(method_name)
      end
    }
    PatientMessageLoader.upload_done
  end

  def self.upload_patient(patient_id)
    PatientMessageLoader.upload_start_with_wait_time(15)
    if Patient02A.respond_to?(patient_id.underscore)
      Patient02A.send(patient_id.underscore)
    else
      raise("Patient #{patient_id} doesn't exist")
    end
    PatientMessageLoader.upload_done
  end

  def self.pt_sr01_registered
    pt = PatientDataSet.new('PT_SR01_Registered')
    PatientMessageLoader.register_patient(pt.id)
  end

  def self.pt_sr02_registered
    pt = PatientDataSet.new('PT_SR02_Registered')
    PatientMessageLoader.register_patient(pt.id)
  end

  def self.pt_sr03_registered
    pt = PatientDataSet.new('PT_SR03_Registered')
    PatientMessageLoader.register_patient(pt.id)
  end

  def self.pt_sr04_registered
    pt = PatientDataSet.new('PT_SR04_Registered')
    PatientMessageLoader.register_patient(pt.id)
  end

  def self.pt_sr05_registered
    pt = PatientDataSet.new('PT_SR05_Registered')
    PatientMessageLoader.register_patient(pt.id)
  end

  def self.pt_sr06_registered
    pt = PatientDataSet.new('PT_SR06_Registered')
    PatientMessageLoader.register_patient(pt.id)
  end

  def self.pt_sr08_registered
    pt = PatientDataSet.new('PT_SR08_Registered')
    PatientMessageLoader.register_patient(pt.id)
  end

  def self.pt_sr13_registered
    pt = PatientDataSet.new('PT_SR13_Registered')
    PatientMessageLoader.register_patient(pt.id)
  end

  def self.pt_sr10_pending_approval
    pt = PatientDataSet.new('PT_SR10_PendingApproval')
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
  end

  def self.pt_sr10_on_treatment_arm
    pt = PatientDataSet.new('PT_SR10_OnTreatmentArm')
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

  def self.pt_sr10_progress_re_bio_y
    pt = PatientDataSet.new('PT_SR10_ProgressReBioY')
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
    sleep(10.0)
    PatientMessageLoader.on_treatment_arm(pt.id, 'APEC1621-A')
    PatientMessageLoader.request_assignment(pt.id)
  end

  def self.pt_sr10_progress_re_bio_y1
    pt = PatientDataSet.new('PT_SR10_ProgressReBioY1')
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
    sleep(10.0)
    PatientMessageLoader.on_treatment_arm(pt.id, 'APEC1621-A')
    PatientMessageLoader.request_assignment(pt.id)
  end

  def self.pt_sr10_bd_received
    pt = PatientDataSet.new('PT_SR10_BdReceived')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_blood(pt.id)
  end

  def self.pt_sr10_ts_received
    pt = PatientDataSet.new('PT_SR10_TsReceived')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
  end

  def self.pt_sr10_ts_vr_received
    pt = PatientDataSet.new('PT_SR10_TsVrReceived')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
  end

  def self.pt_sr10_ts_vr_rejected
    pt = PatientDataSet.new('PT_SR10_TsVRRejected')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
    sleep(10)
    PatientMessageLoader.variant_file_confirmed(pt.id, 'reject', pt.ani)
  end

  def self.pt_sr11_registered
    pt = PatientDataSet.new('PT_SR11_Registered')
    PatientMessageLoader.register_patient(pt.id)
  end

  def self.pt_sr12_variant_report_confirmed
    pt = PatientDataSet.new('PT_SR12_VariantReportConfirmed')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
    sleep(10)
    PatientMessageLoader.variant_file_confirmed(pt.id, 'confirm', pt.ani)
  end

  def self.pt_sr14_ts_vr_uploaded
    pt = PatientDataSet.new('PT_SR14_TsVrUploaded')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
  end

  def self.pt_sr09_ts_received_twice
    pt = PatientDataSet.new('PT_SR09_TsReceivedTwice')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei_increase, '2016-04-28T15:17:11+00:00')
  end

  def self.pt_sr10_bd_vr_received
    pt = PatientDataSet.new('PT_SR10_BdVRReceived')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_blood(pt.id)
    PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.bd_moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.bd_moi, pt.ani)
  end

  def self.pt_sr14_bd_vr_uploaded
    pt = PatientDataSet.new('PT_SR14_BdVrUploaded')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_blood(pt.id)
    PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.bd_moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.bd_moi, pt.ani)
  end

  def self.pt_sr14_ts_vr_uploaded1
    pt = PatientDataSet.new('PT_SR14_TsVrUploaded1')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
  end

  def self.pt_sr14_bd_vr_uploaded1
    pt = PatientDataSet.new('PT_SR14_BdVrUploaded1')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_blood(pt.id)
    PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.bd_moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.bd_moi, pt.ani)
  end

  def self.pt_sr14d_bd_vr_uploaded
    pt = PatientDataSet.new('PT_SR14d_BdVrUploaded')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_blood(pt.id)
    PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.bd_moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.bd_moi, pt.ani)
  end

  def self.pt_sr10_off_study
    pt = PatientDataSet.new('PT_SR10_OffStudy')
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
    PatientMessageLoader.off_study(pt.id, '1.0')
  end

  def self.pt_sr10_off_study2
    pt = PatientDataSet.new('PT_SR10_OffStudy2')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
    PatientMessageLoader.off_study(pt.id, '1.0')
  end

  def self.pt_sr10_pending_approval2
    pt = PatientDataSet.new('PT_SR10_PendingApproval2')
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
  end

  def self.pt_sr15_ts_shipped
    pt = PatientDataSet.new('PT_SR15_TsShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
  end

  def self.pt_sr16_pending_approval
    pt = PatientDataSet.new('PT_SR16_PendingApproval')
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
  end

  def self.pt_sr10_no_ta_available
    pt = PatientDataSet.new('PT_SR10_NoTaAvailable')
    PatientMessageLoader.reset_cog_patient(pt.id)
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
    PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs')
    PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCBAF47s')
    PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCBRG1s')
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani, 'bdd_test_ion_reporter', 'test1.tsv', 'no_ta_available')
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.variant_file_confirmed(pt.id, 'confirm', pt.ani)
    sleep(10.0)
    PatientMessageLoader.assignment_confirmed(pt.id, pt.ani)
  end

  def self.pt_sr10_compassionate_care
    pt = PatientDataSet.new('PT_SR10_CompassionateCare')
    PatientMessageLoader.reset_cog_patient(pt.id)
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
    PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs')
    PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCBAF47s')
    PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCBRG1s')
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani, 'bdd_test_ion_reporter', 'test1.tsv', 'compassionate_care')
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.variant_file_confirmed(pt.id, 'confirm', pt.ani)
    sleep(10.0)
    PatientMessageLoader.assignment_confirmed(pt.id, pt.ani)
  end


end