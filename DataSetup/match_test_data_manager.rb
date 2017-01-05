#!/usr/bin/env ruby
require_relative 'dynamo_utilities'
require_relative 'table_details'
require_relative 'patient_message_loader'

class MatchTestDataManager
  LOCAL_TIER = 'local'
  INT_TIER = 'int'
  UAT_TIER = 'uat'
  SEED_DATA_FOLDER = 'seed_data_for_upload'
  SEED_FILE_PREFIX = 'match_bddtests_seed_data'
  PATIENT_MESSAGE_FOLDER = 'local_patient_data'

  #############local seed files
  def self.create_patient_from_file(file_name, patient_id)
    Environment.setTier('local')
    Auth0Token.force_generate_auth0_token('ADMIN')
    file_path = patient_message_file(file_name)
    delete_patients_from_seed([patient_id])
    clear_all_local_tables
    upload_all_seed_data_to_local
    pass = PatientMessageLoader.load_patient_message(file_path, patient_id)
    # backup_all_local_db if pass
  end

  def self.create_patients_from_file(file_name)
    file_path = patient_message_file(file_name)
    patients = PatientMessageLoader.list_patients(file_path)
    failed_patients = []
    delete_patients_from_seed(patients)
    clear_all_local_tables
    upload_all_seed_data_to_local
    patients.each { |this_patient|
      unless PatientMessageLoader.load_patient_message(file_path, this_patient)
        failed_patients << this_patient
      end
    }
    backup_all_local_db
    delete_patients_from_seed(failed_patients)
  end

  def self.backup_all_local_db
    TableDetails.all_tables.each { |table_name|
      DynamoUtilities.backup_local_table_to_file(table_name, seed_file(table_name))
    }
    LOG.log('Done!')
  end

  def self.backup_all_patient_local_db
    TableDetails.patient_tables.each { |table_name|
      DynamoUtilities.backup_local_table_to_file(table_name, seed_file(table_name))
    }
    LOG.log('Done!')
  end

  def self.backup_all_ta_local_db
    TableDetails.treatment_arm_tables.each { |table_name|
      DynamoUtilities.backup_local_table_to_file(table_name, seed_file(table_name))
    }
    LOG.log('Done!')
  end

  def self.backup_all_ion_local_db
    TableDetails.ion_tables.each { |table_name|
      DynamoUtilities.backup_local_table_to_file(table_name, seed_file(table_name))
    }
    LOG.log('Done!')
  end

  def self.delete_patients_from_seed(patient_id_list)
    TableDetails.patient_tables.each { |table_name|
      field_name = table_name=='event' ? 'entity_id' : 'patient_id'
      remove_json_nodes_from_file(seed_file(table_name), field_name, patient_id_list, table_name)
    }
    TableDetails.treatment_arm_tables.each { |table_name|
      remove_json_nodes_from_file(seed_file(table_name), 'patient_id', patient_id_list, table_name)
    }
  end

  ################clear
  def self.clear_all_local_tables
    LOG.log('Deleting all tables from local dynamodb')
    TableDetails.all_tables.each do |table|
      DynamoUtilities.clear_table(table, LOCAL_TIER)
    end
    LOG.log('Done!')
  end

  def self.clear_all_int_tables
    LOG.log('Deleting all tables from INT dynamodb')
    TableDetails.all_tables.each do |table|
      DynamoUtilities.clear_table(table, INT_TIER)
    end
    LOG.log('Done!')
  end

  def self.clear_all_uat_tables
    LOG.log('Deleting all tables from UAT dynamodb')
    TableDetails.all_tables.each do |table|
      DynamoUtilities.clear_table(table, UAT_TIER)
    end
    LOG.log('Done!')
  end

  ################upload
  def self.upload_all_seed_data_to_local
    LOG.log('Uploading all seed data to local dynamodb')
    TableDetails.all_tables.each do |table|
      DynamoUtilities.upload_seed_data(table, seed_file(table), LOCAL_TIER)
    end
    LOG.log('Done!')
  end

  def self.upload_all_seed_data_to_int
    LOG.log('Uploading all seed data to int dynamodb')
    TableDetails.all_tables.each do |table|
      DynamoUtilities.upload_seed_data(table, seed_file(table), INT_TIER)
    end
    LOG.log('Done!')
  end

  def self.upload_all_seed_data_to_uat
    LOG.log('Uploading all seed data to uat dynamodb')
    TableDetails.all_tables.each do |table|
      DynamoUtilities.upload_seed_data(table, seed_file(table), UAT_TIER)
    end
    LOG.log('Done!')
  end

  #################utilities
  def self.patient_message_file(file_name)
    "#{File.dirname(__FILE__)}/#{PATIENT_MESSAGE_FOLDER}/#{file_name}.json"
  end

  def self.seed_file(table_name)
    "#{File.dirname(__FILE__)}/#{SEED_DATA_FOLDER}/#{SEED_FILE_PREFIX}_#{table_name}.json"
  end

  def self.remove_json_nodes_from_file(file, target_field, target_value_list, nickname)
    items = JSON.parse(File.read(file))
    old_count = items.size
    items.delete_if { |this_item| target_value_list.include?(this_item[target_field]) }

    LOG.log("There are #{old_count-items.size} items(#{target_field}=#{target_value_list.to_s}) get removed from #{nickname}")
    File.open(file, 'w') { |f| f.write(JSON.pretty_generate(items)) }
  end

  def self.json_node_exist_in_file(file, target_field, target_value)
    items = JSON.parse(File.read(file))
    items.any? { |this_item| this_item[target_field] == target_value }
  end
end
