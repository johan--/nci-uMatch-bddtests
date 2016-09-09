class PatientVariantFolderCreator
  TEMPLATE_ANI_FOLDER_PATH = "#{File.dirname(__FILE__)}/variant_file_templates/3366_moi/3366_ani"
  TEMPLATE_ANI_FOLDER_NAME = "3366_ani"
  OUTPUT_FOLDER_PATH = "#{File.dirname(__FILE__)}/variant_file_templates/outputs"


  def self.create(moi, ani)
    target_moi_folder = "#{OUTPUT_FOLDER_PATH}/#{moi}"
    target_ani_folder = "#{target_moi_folder}/#{ani}"
    if File.directory?(target_ani_folder)
      p "#{target_ani_folder} exists, skipping..."
      return
    end

    unless File.directory?(target_moi_folder)
      cmd = "mkdir #{target_moi_folder}"
      `#{cmd}`
    end
    cmd = "cp -R #{TEMPLATE_ANI_FOLDER_PATH} #{target_moi_folder}"
    `#{cmd}`
    cmd = "mv #{target_moi_folder}/#{TEMPLATE_ANI_FOLDER_NAME} #{target_ani_folder}"
    `#{cmd}`
    p "#{target_ani_folder} created!"
  end

  def self.create_default(patient_id, type)
    moi = case type
            when 'tissue' then '_MOI1'
            when 'blood' then '_BD_MOI1'
          end
    moi = patient_id + moi
    ani = patient_id + '_ANI1'

    create(moi, ani)
  end
end