require_relative 'patient_story_sender'
require_relative 'treatment_arm_sender'
require_relative 'patient_story'
require_relative 'seed_file'
require_relative 'data_transfer'
require_relative 'logger'

class PedMatchTestData
  def self.load_treatment_arms(tag='patients')
    DataTransfer.clear_all_local
    DataTransfer.upload_ion_seed_to_local(tag)
    TreatmentArmSender.send_all
  end

  def self.load_patients(patient_list, tag='patients')
    failed = []
    SeedFile.delete_patients(patient_list, tag)
    DataTransfer.clear_all_local
    DataTransfer.upload_seed_data_to_local(tag)
    patient_list.each { |pt| failed << pt unless PatientStorySender.send_patient(pt) }
    passed_number = patient_list.size - failed.size
    if passed_number > 0
      sleep 10.0
      DataTransfer.backup(tag)
    end
    Logger.log("Load patient work is done. #{passed_number}/#{patient_list.size} patients are writen to seed file")
    if failed.size > 0
      Logger.warning('The following patients are not loaded properly, please reload them')
      Logger.warning(failed.to_s)
    end
  end
end


PedMatchTestData.load_patients(PatientStory.all_patients)