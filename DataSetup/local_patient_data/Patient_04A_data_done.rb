require_relative '../patient_message_loader'

class Patient04A
  def self.upload_all
    PatientMessageLoader.upload_start_with_wait_time(15)
    Patient04A.methods.each { |method|
      method_name = method.to_s
      if method_name.start_with?('pt_') || method_name.start_with?('ion_')
        Patient04A.send(method_name)
      end
    }
    PatientMessageLoader.upload_done
  end

  def self.upload_patient(patient_id)
    PatientMessageLoader.upload_start_with_wait_time(15)
    if Patient04A.respond_to?(patient_id.underscore)
      Patient04A.send(patient_id.underscore)
    else
      raise("Patient #{patient_id} doesn't exist")
    end
    PatientMessageLoader.upload_done
  end

  def self.pt_as00_slide_shipped1
    pt = PatientDataSet.new('PT_AS00_SlideShipped1')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
  end

  def self.pt_as00_slide_shipped2
    pt = PatientDataSet.new('PT_AS00_SlideShipped2')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
  end

  def self.pt_as00_slide_shipped3
    pt = PatientDataSet.new('PT_AS00_SlideShipped3')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
  end

  def self.pt_as00_slide_shipped4
    pt = PatientDataSet.new('PT_AS00_SlideShipped4')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
  end

  def self.pt_as02_slide_shipped
    pt = PatientDataSet.new('PT_AS02_SlideShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
  end

  def self.pt_as03_slide_shipped
    pt = PatientDataSet.new('PT_AS03_SlideShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
  end

  def self.pt_as04_slide_shipped
    pt = PatientDataSet.new('PT_AS04_SlideShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
  end

  def self.pt_as05_slide_shipped
    pt = PatientDataSet.new('PT_AS05_SlideShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
  end

  def self.pt_as06_slide_shipped
    pt = PatientDataSet.new('PT_AS06_SlideShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
  end

  def self.pt_as07_slide_shipped
    pt = PatientDataSet.new('PT_AS07_SlideShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
  end

  def self.pt_as08_registered
    pt = PatientDataSet.new('PT_AS08_Registered')
    PatientMessageLoader.register_patient(pt.id)
  end

  def self.pt_as08_tissue_received
    pt = PatientDataSet.new('PT_AS08_TissueReceived')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
  end

  def self.pt_as11_slide_shipped
    pt = PatientDataSet.new('PT_AS11SlideShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
  end

  def self.pt_as08_sei1_has_slide_sei2_no_slide
    pt = PatientDataSet.new('PT_AS08_SEI1HasSlideSEI2NoSlide')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei_increase, '2016-05-28')
  end

  def self.pt_as10_slide_shipped
    pt = PatientDataSet.new('PT_AS10SlideShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei_increase, '2016-05-28')
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc_increase, '2016-06-04T19:42:13+00:00')
  end

  def self.pt_as10a_slide_shipped1
    pt = PatientDataSet.new('PT_AS10aSlideShipped1')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
  end

  def self.pt_as10a_slide_shipped2
    pt = PatientDataSet.new('PT_AS10aSlideShipped2')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
  end

  def self.pt_as13_slide_shipped
    pt = PatientDataSet.new('PT_AS13_SlideShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
  end

  def self.pt_as12_vr_confirmed
    pt = PatientDataSet.new('PT_AS12_VrConfirmed')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
    sleep(10.0)
    PatientMessageLoader.variant_file_confirmed(pt.id, 'confirm', pt.ani)
  end

  def self.pt_as12_vr_received
    pt = PatientDataSet.new('PT_AS12_VrReceived')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
  end


  def self.pt_as14_slide_shipped
    pt = PatientDataSet.new('PT_AS14_SlideShipped')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei, '2016-11-28')
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc, '2016-11-30T19:42:13+00:00')
  end

  def self.pt_as08_ts_received_step2
    pt = PatientDataSet.new('PT_AS08_TsReceivedStep2')
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
  end

  def self.pt_as09_req_no_assignment
    pt = PatientDataSet.new('PT_AS09_ReqNoAssignment')
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

  def self.pt_as09_off_study
    pt = PatientDataSet.new('PT_AS09_OffStudy')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
    PatientMessageLoader.off_study(pt.id, '1.0')
  end

  def self.pt_as09_off_study_biopsy_expired
    pt = PatientDataSet.new('PT_AS09_OffStudyBiopsyExpired')
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
    PatientMessageLoader.off_study_biopsy_expired(pt.id, '1.0')
  end

  def self.pt_as12_pending_confirmation
    pt = PatientDataSet.new('PT_AS12_PendingConfirmation')
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
  end

  def self.pt_as12_pending_approval
    pt = PatientDataSet.new('PT_AS12_PendingApproval')
    PatientMessageLoader.reset_cog_patient(pt.id)
    PatientMessageLoader.register_patient(pt.id, 'current')
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei, 'today')
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi, 'current')
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc, 'current')
    PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs', 'current')
    PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCBAF47s', 'current')
    PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCBRG1s', 'current')
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.variant_file_confirmed(pt.id, 'confirm', pt.ani)
    sleep(10.0)
    PatientMessageLoader.assignment_confirmed(pt.id, pt.ani)
  end

  def self.pt_as12_on_treatment_arm
    pt = PatientDataSet.new('PT_AS12_OnTreatmentArm')
    PatientMessageLoader.reset_cog_patient(pt.id)
    PatientMessageLoader.register_patient(pt.id, 'current')
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei, 'today')
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi, 'current')
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc, 'current')
    PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCPTENs', 'current')
    PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCBAF47s', 'current')
    PatientMessageLoader.assay(pt.id, pt.sei, 'NEGATIVE', 'ICCBRG1s', 'current')
    PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.copy_CNV_json_to_int_folder(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.variant_file_confirmed(pt.id, 'confirm', pt.ani)
    sleep(10.0)
    PatientMessageLoader.assignment_confirmed(pt.id, pt.ani)
    sleep(10.0)
    PatientMessageLoader.on_treatment_arm(pt.id, 'APEC1621-A')
  end







end
