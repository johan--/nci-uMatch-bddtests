require_relative 'patient_story_sender'
require_relative 'treatment_arm_sender'
require_relative 'patient_story'
require_relative 'seed_file'
require_relative 'ped_match_database'
require_relative 'logger'
require_relative 'constants'

class PedMatchTestData
  def self.use_local_tier
    Constants.set_tier(Constants.tier_local)
  end

  def self.use_int_tier
    Constants.set_tier(Constants.tier_int)
  end

  def self.use_uat_tier
    Constants.set_tier(Constants.tier_uat)
  end

  def self.clear_and_initial_all(tag='patients')
    PedMatchDatabase.clear_all_local
    TableInfo.patient_tables.each { |table| SeedFile.clear_seed_file(table, tag) }
    TableInfo.treatment_arm_tables.each { |table| SeedFile.clear_seed_file(table, tag) }
    PedMatchDatabase.upload_ion_seed_to_local(tag)
    TreatmentArmSender.send_all
    PedMatchDatabase.backup_treatment_arm(tag)
  end

  def self.load_seed_patients(patient_list, tag='patients')
    failed = []
    SeedFile.delete_patients(patient_list, tag)
    PedMatchDatabase.clear_all_local
    PedMatchDatabase.upload_seed_data_to_local(tag)
    patient_list.each { |pt| failed << pt unless PatientStorySender.send_seed_patient(pt) }
    passed_number = patient_list.size - failed.size
    if passed_number > 0
      sleep 10.0
      PedMatchDatabase.backup(tag)
    end
    Logger.log("Load patient work is done. #{passed_number}/#{patient_list.size} patients are writen to seed file")
    if failed.size > 0
      Logger.warning('The following patients are not loaded properly, please reload them')
      Logger.warning(failed.to_s)
    end
  end

  def self.load_patient_seed_file_index(index, tag='patients')
    load_seed_patients(PatientStory.patients_in_save_file(index), tag)
  end

  def self.send_a_patient_story(patient_story)
    PatientStorySender.send_patient_story(patient_story)
  end
end


# pt = PatientStory.new('PT_TEST111')
# pt.create_temporary_patient{
#   pt.story_register
#   pt.story_specimen_received_tissue
# }
# PedMatchTestData.use_int_tier
# PedMatchTestData.send_a_patient_story(pt)

#
# for i in (13..14)
#   PedMatchTestData.load_patient_seed_file_index(i)
# end

# PedMatchTestData.clear_and_initial_all
#   PedMatchTestData.load_patient_seed_file_index(19)

# pt = PatientStory.new('PT_SC10c_PendingConfirmationStep2')
# pt.create_seed_patient{
#   pt.story_register
#   pt.story_specimen_received_tissue
#   pt.story_specimen_shipped_tissue
#   pt.story_tissue_variant_report
#   pt.story_file_uploaded_dna('PT_SC10c_PendingConfirmationStep2_ANI1')
#   pt.story_file_uploaded_cdna('PT_SC10c_PendingConfirmationStep2_ANI1')
#   pt.story_specimen_shipped_slide
#   pt.story_assay('ICCPTENs', 'NEGATIVE')
#   pt.story_assay('ICCBAF47s', 'NEGATIVE')
#   pt.story_assay('ICCBRG1s', 'NEGATIVE')
#   pt.story_variant_file_confirmed
#   pt.story_assignment_confirmed
#   pt.story_on_treatment_arm('APEC1621-A', '100')
#   pt.story_request_assignment('Y')
#   pt.story_specimen_received_tissue
#   pt.story_specimen_shipped_tissue
#   pt.story_specimen_shipped_slide
#   pt.story_assay('ICCPTENs', 'NEGATIVE')
#   pt.story_assay('ICCBAF47s', 'NEGATIVE')
#   pt.story_assay('ICCBRG1s', 'NEGATIVE')
#   pt.story_tissue_variant_report
#   pt.story_file_uploaded_dna('PT_SC10c_PendingConfirmationStep2_ANI2')
#   pt.story_file_uploaded_cdna('PT_SC10c_PendingConfirmationStep2_ANI2')
#   pt.story_variant_file_confirmed
#   pt.story_assignment_confirmed
#   pt.story_request_assignment('N')
# }

# PedMatchTestData.load_seed_patients(['PT_SC10c_PendingConfirmationStep2'])
