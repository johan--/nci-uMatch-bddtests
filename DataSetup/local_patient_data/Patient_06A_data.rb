require_relative '../patient_message_loader'

PatientMessageLoader.upload_start_with_wait_time(15)



pt = PatientDataSet.new('PT_VU09_VariantReportUploaded')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.tsv_vcf_uploaded(pt.id, pt.moi, pt.ani)

pt = PatientDataSet.new('PT_VU10_VariantReportUploaded')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.tsv_vcf_uploaded(pt.id, pt.moi, pt.ani)

pt = PatientDataSet.new('PT_VU11_VariantReportRejected')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.tsv_vcf_uploaded(pt.id, pt.moi, pt.ani)
PatientMessageLoader.variant_file_confirmed(pt.id, 'REJECTED', pt.moi, pt.ani)

pt = PatientDataSet.new('PT_VU12_VariantReportRejected')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.tsv_vcf_uploaded(pt.id, pt.moi, pt.ani)
PatientMessageLoader.variant_file_confirmed(pt.id, 'REJECTED', pt.moi, pt.ani)
PatientMessageLoader.tsv_vcf_uploaded(pt.id, pt.moi, pt.ani_increase)
PatientMessageLoader.variant_file_confirmed(pt.id, 'REJECTED', pt.moi, pt.ani)

pt = PatientDataSet.new('PT_VU13_VariantReportConfirmed')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.tsv_vcf_uploaded(pt.id, pt.moi, pt.ani)
PatientMessageLoader.variant_file_confirmed(pt.id, 'CONFIRMED', pt.moi, pt.ani)

pt = PatientDataSet.new('PT_VU16_BdVRUploaded')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_blood(pt.id)
PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)
PatientMessageLoader.tsv_vcf_uploaded(pt.id, pt.bd_moi, pt.ani)

PatientMessageLoader.upload_done
