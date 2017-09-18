require_relative 'patient_story_sender'
require_relative 'treatment_arm_sender'
require_relative 'patient_story'
require_relative 'seed_file'
require_relative 'ped_match_database'
require_relative 'log'
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
    SeedFile.create_tag_if_not_exist(tag)
    PedMatchDatabase.clear_all_local
    TableInfo.patient_tables.each {|table| SeedFile.clear_seed_file(table, tag)}
    TableInfo.treatment_arm_tables.each {|table| SeedFile.clear_seed_file(table, tag)}
    PedMatchDatabase.upload_ion_seed_to_local(tag)
    TreatmentArmSender.send_all
    PedMatchDatabase.backup_treatment_arm(tag)
  end

  def self.load_seed_patients(patient_list, tag='patients')
    failed = []
    SeedFile.delete_patients(patient_list, tag)
    PedMatchDatabase.clear_all_local
    PedMatchDatabase.upload_seed_data_to_local(tag)
    patient_list.each {|pt| failed << pt unless PatientStorySender.send_seed_patient(pt)}
    passed_number = patient_list.size - failed.size
    if passed_number > 0
      sleep 30.0 #we need to wait more time until treatment arm assignment event get processed (if the story end with an assignment related action)
      PedMatchDatabase.backup(tag)
    end
    Log.info("Load patient work is done. #{passed_number}/#{patient_list.size} patients are writen to seed file")
    if failed.size > 0
      Log.warning('The following patients are not loaded properly, please reload them')
      Log.warning(failed.to_s)
    end
  end

  def self.send_a_patient_story(patient_story)
    PatientStorySender.send_patient_story(patient_story)
  end

  def self.add_treatment_arm(ta_text_or_hash, tag='patients')
    PedMatchDatabase.clear_all_local
    PedMatchDatabase.upload_seed_data_to_local(tag)
    if TreatmentArmSender.send_by_json(ta_text_or_hash)
      sleep 10.0
      PedMatchDatabase.backup_treatment_arm(tag)
    end
  end
end