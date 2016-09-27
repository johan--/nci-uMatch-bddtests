require_relative '../patient_message_loader'

PatientMessageLoader.upload_start_with_wait_time(15)

pt = PatientDataSet.new('PT_VU01_TissueShipped1')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)

pt = PatientDataSet.new('PT_VU01_TissueShipped2')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)

pt = PatientDataSet.new('PT_VU02_TissueShipped')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)

# pt = PatientDataSet.new('PT_VU02a_TissueShippedToMDA')
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
# PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi, '2016-05-01T19:42:13+00:00', 'MDA')

# pt = PatientDataSet.new('PT_VU02a_TissueShippedToMoCha')
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
# PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi, '2016-05-01T19:42:13+00:00', 'MoCha')

pt = PatientDataSet.new('PT_VU03_TissueShipped')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)

pt = PatientDataSet.new('PT_VU04_TissueShipped')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)

pt = PatientDataSet.new('PT_VU05_TissueShipped')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi_increase, '2016-05-01T23:42:13+00:00')

pt = PatientDataSet.new('PT_VU05_BloodShipped')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_blood(pt.id)
PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)
PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi_increase, '2016-05-01T23:42:13+00:00')


pt = PatientDataSet.new('PT_VU06_TissueShipped')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)


pt = PatientDataSet.new('PT_VU14_TissueAndBloodShipped')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_blood(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)



pt = PatientDataSet.new('PT_VU07_SlideShippedNoTissueShipped')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)




pt = PatientDataSet.new('PT_VU09_VariantReportUploaded')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)

pt = PatientDataSet.new('PT_VU10_VariantReportUploaded')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)

pt = PatientDataSet.new('PT_VU11_VariantReportRejected')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
PatientMessageLoader.variant_file_confirmed(pt.id, 'reject', pt.ani)

pt = PatientDataSet.new('PT_VU12_VariantReportRejected')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
PatientMessageLoader.variant_file_confirmed(pt.id, 'reject', pt.ani)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani_increase)
PatientMessageLoader.variant_file_confirmed(pt.id, 'reject', pt.ani)

pt = PatientDataSet.new('PT_VU13_VariantReportConfirmed')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
PatientMessageLoader.variant_file_confirmed(pt.id, 'confirm', pt.ani)

pt = PatientDataSet.new('PT_VU16_BdVRUploaded')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_blood(pt.id)
PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.bd_moi, pt.ani)

pt = PatientDataSet.new('PT_VU17_BdVRConfirmed')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_blood(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_blood(pt.id, pt.bd_moi)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.bd_moi, pt.ani)
PatientMessageLoader.variant_file_confirmed(pt.id, 'confirm', pt.ani)

PatientMessageLoader.upload_done
