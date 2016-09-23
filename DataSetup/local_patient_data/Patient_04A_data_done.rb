require_relative '../patient_message_loader'

PatientMessageLoader.upload_start_with_wait_time(15)

pt = PatientDataSet.new('PT_AS02_SlideShipped')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)

pt = PatientDataSet.new('PT_AS03_SlideShipped')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)

pt = PatientDataSet.new('PT_AS04_SlideShipped')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)

pt = PatientDataSet.new('PT_AS05_SlideShipped')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)

pt = PatientDataSet.new('PT_AS06_SlideShipped')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)

pt = PatientDataSet.new('PT_AS07_SlideShipped')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)

pt = PatientDataSet.new('PT_AS08_Registered')
PatientMessageLoader.register_patient(pt.id)

pt = PatientDataSet.new('PT_AS08_TissueReceived')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)

pt = PatientDataSet.new('PT_AS09SlideShipped')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)

pt = PatientDataSet.new('PT_AS09aSlideShipped')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)

pt = PatientDataSet.new('PT_AS11SlideShipped')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)

pt = PatientDataSet.new('PT_AS08_SEI1HasSlideSEI2NoSlide')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei_increase, '2016-05-28T15:17:11+00:00')

pt = PatientDataSet.new('PT_AS10SlideShipped')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei_increase, '2016-05-28T15:17:11+00:00')
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc_increase, '2016-06-04T19:42:13+00:00')

pt = PatientDataSet.new('PT_AS10aSlideShipped1')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)

pt = PatientDataSet.new('PT_AS10aSlideShipped2')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)

pt = PatientDataSet.new('PT_AS12_VRConfirmedNoPatho')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
sleep(10.0)
PatientMessageLoader.variant_file_confirmed(pt.id, 'confirm', pt.moi, pt.ani)

pt = PatientDataSet.new('PT_AS12_PathoConfirmedNoVR')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.pathology(pt.id, pt.sei)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)

pt = PatientDataSet.new('PT_AS12_VRAndPathoConfirmed')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.pathology(pt.id, pt.sei)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
sleep(10.0)
PatientMessageLoader.variant_file_confirmed(pt.id, 'confirm', pt.moi, pt.ani)

PatientMessageLoader.upload_done
