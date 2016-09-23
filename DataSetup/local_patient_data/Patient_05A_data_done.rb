require_relative '../patient_message_loader'

PatientMessageLoader.upload_start_with_wait_time(15)

pt = PatientDataSet.new('PT_PR02_TissueReceived')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)

pt = PatientDataSet.new('PT_PR03_TissueReceived')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)

pt = PatientDataSet.new('PT_PR04_TissueReceived')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)

pt = PatientDataSet.new('PT_PR05_TissueReceived')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)

pt = PatientDataSet.new('PT_PR06_TissueReceived')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)

pt = PatientDataSet.new('PT_PR07_TissueShipped')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)

pt = PatientDataSet.new('PT_PR08_SlideShipped')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)

PatientMessageLoader.register_patient('PT_PR09_Registered')

pt = PatientDataSet.new('PT_PR09_SEI1HasTissue')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)

pt = PatientDataSet.new('PT_PR10TissueReceived')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)

pt = PatientDataSet.new('PT_PR11TissueReceived')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei_increase, '2016-04-28T15:17:11+00:00')

pt = PatientDataSet.new('PT_PR11aTissueReceived1')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)

pt = PatientDataSet.new('PT_PR11aTissueReceived2')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)

pt = PatientDataSet.new('PT_PR12TissueReceived')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)

pt = PatientDataSet.new('PT_PR12_PathologyYReceived')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.pathology(pt.id, pt.sei)

pt = PatientDataSet.new('PT_PR12_PathologyNReceived')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.pathology(pt.id, pt.sei, 'N')

pt = PatientDataSet.new('PT_PR12_PathologyUReceived1')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.pathology(pt.id, pt.sei, 'U')

pt = PatientDataSet.new('PT_PR12_PathologyUReceived2')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.pathology(pt.id, pt.sei, 'U')

pt = PatientDataSet.new('PT_PR12_PathologyUReceived3')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.pathology(pt.id, pt.sei, 'U')




pt = PatientDataSet.new('PT_PR13_VRConfirmedNoAssay')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
sleep(10.0)
PatientMessageLoader.variant_file_confirmed(pt.id, 'confirm', pt.moi, pt.ani)

pt = PatientDataSet.new('PT_PR13_AssayReceivedVRNotConfirmed')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
PatientMessageLoader.assay(pt.id, pt.sei, "POSITIVE", 'ICCPTENs', '2016-05-30T12:11:09.071-05:00')
PatientMessageLoader.assay(pt.id, pt.sei, "POSITIVE", 'ICCMLH1s', '2016-05-30T12:18:09.071-05:00')
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)

pt = PatientDataSet.new('PT_PR13_AssayAndVRDonePlanToY')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
PatientMessageLoader.assay(pt.id, pt.sei, "POSITIVE", 'ICCPTENs', '2016-05-30T12:11:09.071-05:00')
PatientMessageLoader.assay(pt.id, pt.sei, "POSITIVE", 'ICCMLH1s', '2016-05-30T12:18:09.071-05:00')
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
sleep(10.0)
PatientMessageLoader.variant_file_confirmed(pt.id, 'confirm', pt.moi, pt.ani)

pt = PatientDataSet.new('PT_PR13_AssayAndVRDonePlanToN')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
PatientMessageLoader.assay(pt.id, pt.sei, "POSITIVE", 'ICCPTENs', '2016-05-30T12:11:09.071-05:00')
PatientMessageLoader.assay(pt.id, pt.sei, "POSITIVE", 'ICCMLH1s', '2016-05-30T12:18:09.071-05:00')
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
sleep(10.0)
PatientMessageLoader.variant_file_confirmed(pt.id, 'confirm', pt.moi, pt.ani)

pt = PatientDataSet.new('PT_PR13_AssayAndVRDonePlanToU')
PatientMessageLoader.register_patient(pt.id)
PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
PatientMessageLoader.assay(pt.id, pt.sei, "POSITIVE", 'ICCPTENs', '2016-05-30T12:11:09.071-05:00')
PatientMessageLoader.assay(pt.id, pt.sei, "POSITIVE", 'ICCMLH1s', '2016-05-30T12:18:09.071-05:00')
PatientMessageLoader.variant_file_uploaded(pt.id, pt.moi, pt.ani)
sleep(10.0)
PatientMessageLoader.variant_file_confirmed(pt.id, 'confirm', pt.moi, pt.ani)


PatientMessageLoader.upload_done
