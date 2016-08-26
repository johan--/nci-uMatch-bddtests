require_relative '../patient_message_loader'

PatientMessageLoader.upload_start_with_wait_time(15)

#!!disconnect mock service before run this "PT_SR10_WaitingPtData"
# pt = PatientDataSet.new('PT_SR10_WaitingPtData'
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_tissue(pt.id)
# PatientMessageLoader.specimen_shipped_tissue(pt.id)
# PatientMessageLoader.pathology(pt.id,'Y')
# PatientMessageLoader.assay(pt.id, 'NEGATIVE', 'ICCPTENs')
# PatientMessageLoader.assay(pt.id, 'NEGATIVE', 'ICCMLH1s')
# PatientMessageLoader.variant_file_uploaded(pt.id)
# PatientMessageLoader.variant_file_confirmed(pt.id, 'CONFIRMED')
#
# #connect mock service back before run the following blocks
# pt = PatientDataSet.new('PT_SR10_PendingApproval'
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_tissue(pt.id)
# PatientMessageLoader.specimen_shipped_tissue(pt.id)
# PatientMessageLoader.pathology(pt.id,'Y')
# PatientMessageLoader.assay(pt.id, 'NEGATIVE', 'ICCPTENs')
# PatientMessageLoader.assay(pt.id, 'NEGATIVE', 'ICCMLH1s')
# PatientMessageLoader.variant_file_uploaded(pt.id)
# PatientMessageLoader.variant_file_confirmed(pt.id, 'CONFIRMED')
#
# pt = PatientDataSet.new('PT_SR10_OnTreatmentArm'
# PatientMessageLoader.register_patient(pt.id)
# PatientMessageLoader.specimen_received_tissue(pt.id)
# PatientMessageLoader.specimen_shipped_tissue(pt.id)
# PatientMessageLoader.pathology(pt.id,'Y')
# PatientMessageLoader.assay(pt.id, 'NEGATIVE', 'ICCPTENs')
# PatientMessageLoader.assay(pt.id, 'NEGATIVE', 'ICCMLH1s')
# PatientMessageLoader.variant_file_uploaded(pt.id)
# PatientMessageLoader.variant_file_confirmed(pt.id, 'CONFIRMED')
# sleep(10.0)
# PatientMessageLoader.assignment_confirmed(pt.id, 'CONFIRMED')






PatientMessageLoader.upload_done
