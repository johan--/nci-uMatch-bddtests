require_relative '../patient_message_loader'

class Patient06A
  def self.upload_all
    PatientMessageLoader.upload_start_with_wait_time(15)
    Patient06A.methods.each { |method|
      method_name = method.to_s
      if method_name.start_with?('pt_') || method_name.start_with?('ion_')
        Patient06A.send(method_name)
      end
    }
    PatientMessageLoader.upload_done
  end

  def self.upload_patient(patient_id)
    PatientMessageLoader.upload_start_with_wait_time(15)
    if Patient06A.respond_to?(patient_id.underscore)
      Patient06A.send(patient_id.underscore)
    else
      raise("Patient #{patient_id} doesn't exist")
    end
    PatientMessageLoader.upload_done
  end

  def self.pt_vu01_tissue_shipped1
    pt = PatientDataSet.new('PT_VU01_TissueShipped1')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
  end

  def self.pt_vu01_tissue_shipped2
    pt = PatientDataSet.new('PT_VU01_TissueShipped2')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
  end

  def self.pt_vu02_tissue_shipped
    pt = PatientDataSet.new('PT_VU02_TissueShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
  end

  def self.pt_vu03_tissue_shipped
    pt = PatientDataSet.new('PT_VU03_TissueShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
  end

  def self.pt_vu04_tissue_shipped
    pt = PatientDataSet.new('PT_VU04_TissueShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
  end

  def self.pt_vu05_tissue_shipped
    pt = PatientDataSet.new('PT_VU05_TissueShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi_increase, '2016-05-01T23:42:13+00:00')
  end

  def self.pt_vu05_blood_shipped
    pt = PatientDataSet.new('PT_VU05_BloodShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_blood(pt.id)
    PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)
    PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi_increase, '2016-05-01T23:42:13+00:00')
  end

  def self.pt_vu06_tissue_shipped
    pt = PatientDataSet.new('PT_VU06_TissueShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
  end

  def self.pt_vu06b_tissue_shipped
    pt = PatientDataSet.new('PT_VU06b_TissueShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
  end

  def self.pt_vu06a_ts_shipped
    pt = PatientDataSet.new('PT_VU06a_TsShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
  end

  def self.pt_vu14_tissue_and_blood_shipped
    pt = PatientDataSet.new('PT_VU14_TissueAndBloodShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_blood(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)
  end

  def self.pt_vu07_slide_shipped_no_tissue_shipped
    pt = PatientDataSet.new('PT_VU07_SlideShippedNoTissueShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
  end

  def self.pt_vu09_variant_report_uploaded
    pt = PatientDataSet.new('PT_VU09_VariantReportUploaded')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
  end

  def self.pt_vu10_variant_report_uploaded
    pt = PatientDataSet.new('PT_VU10_VariantReportUploaded')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
  end

  def self.pt_vu11_variant_report_rejected
    pt = PatientDataSet.new('PT_VU11_VariantReportRejected')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.variant_file_confirmed(pt.id, 'reject', pt.ani)
  end

  def self.pt_vu12_variant_report_rejected
    pt = PatientDataSet.new('PT_VU12_VariantReportRejected')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.variant_file_confirmed(pt.id, 'reject', pt.ani)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani_increase)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.variant_file_confirmed(pt.id, 'reject', pt.ani)
  end

  def self.pt_vu13_variant_report_confirmed
    pt = PatientDataSet.new('PT_VU13_VariantReportConfirmed')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.variant_file_confirmed(pt.id, 'confirm', pt.ani)
  end

  def self.pt_vu16_bd_vr_uploaded
    pt = PatientDataSet.new('PT_VU16_BdVRUploaded')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_blood(pt.id)
    PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.bd_moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.bd_moi, pt.ani)
  end

  def self.pt_vu18_tissue_shipped
    pt = PatientDataSet.new('PT_VU18_TissueShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
  end


  def self.pt_vu17_ts_shipped_twice
    pt = PatientDataSet.new('PT_VU17_TsShippedTwice')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi, '2016-05-01T19:42:13+00:00')
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi_increase, '2016-05-01T23:42:13+00:00')
  end


  def self.pt_vu17_ts_ship_dtm_then_mda
    pt = PatientDataSet.new('PT_VU17_TsShipDtmThenMda')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi, '2016-05-01T19:42:13+00:00', 'Dartmouth')
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi_increase, '2016-05-01T23:42:13+00:00', 'MDA')
  end


  def self.pt_vu17_ts_ship_mda_then_dtm
    pt = PatientDataSet.new('PT_VU17_TsShipMdaThenDtm')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi, '2016-05-01T19:42:13+00:00', 'MDA')
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi_increase, '2016-05-01T23:42:13+00:00', 'Dartmouth')
  end

  def self.pt_vu17_bd_shipped_twice
    pt = PatientDataSet.new('PT_VU17_BdShippedTwice')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_blood(pt.id)
    PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi, '2016-05-02T19:42:13+00:00')
    PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi_increase, '2016-05-02T23:42:13+00:00')
  end

  def self.pt_vu17_ts_vr_uploaded
    pt = PatientDataSet.new('PT_VU17_TsVrUploaded')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
  end

  def self.pt_vu17_bd_vr_uploaded
    pt = PatientDataSet.new('PT_VU17_BdVrUploaded')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_blood(pt.id)
    PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.bd_moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.bd_moi, pt.ani)
  end

  def self.pt_vu17_ts_vr_uploaded_step2
    pt = PatientDataSet.new('PT_VU17_TsVrUploadedStep2')
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
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei_increase)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi_increase)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani_increase)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
  end

  def self.pt_vu17_pending_confirmation
    pt = PatientDataSet.new('PT_VU17_PendingConfirmation')
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
  end

  def self.pt_vu17_pending_approval
    pt = PatientDataSet.new('PT_VU17_PendingApproval')
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

  def self.pt_vu17_ts_shipped_off_study
    pt = PatientDataSet.new('PT_VU17_TsShippedOffStudy')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.off_study(pt.id, '1.0')
  end

  def self.pt_vu17_ts_shipped_off_study_bio_exp
    pt = PatientDataSet.new('PT_VU17_TsShippedOffStudyBioExp')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.off_study_biopsy_expired(pt.id, '1.0')
  end

  def self.pt_vu17_ts_slide_shipped
    pt = PatientDataSet.new('PT_VU17_TsSlideShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
  end

  def self.pt_vu17_ts_shipped_assay_received
    pt = PatientDataSet.new('PT_VU17_TsShippedAssayReceived')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
    PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs')
    PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCBAF47s')
    PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCBRG1s')
  end

  def self.pt_vu17_ts_vr_confirmed
    pt = PatientDataSet.new('PT_VU17_TsVrConfirmed')
    # PatientMessageLoader.register_patient(pt.id)
    # PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    # PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.variant_file_confirmed(pt.id, 'confirm', pt.ani)
  end

  def self.pt_vu17_ts_vr_rejected
    pt = PatientDataSet.new('PT_VU17_TsVrRejected')
    # PatientMessageLoader.register_patient(pt.id)
    # PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    # PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.variant_file_confirmed(pt.id, 'reject', pt.ani)
  end

  def self.pt_vu17_on_treatment_arm
    pt = PatientDataSet.new('PT_VU17_OnTreatmentArm')
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
  end

  def self.pt_vu17_req_assignment
    pt = PatientDataSet.new('PT_VU17_ReqAssignment')
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

  def self.pt_vu17_req_no_assignment
    pt = PatientDataSet.new('PT_VU17_ReqNoAssignment')
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
    PatientMessageLoader.request_no_assignment(pt.id, '1.1')
  end

  def self.pt_vu17_no_ta_available
    pt = PatientDataSet.new('PT_VU17_NoTaAvailable')
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

  def self.pt_vu17_compassionate_care
    pt = PatientDataSet.new('PT_VU17_CompassionateCare')
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