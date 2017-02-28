#!/usr/bin/env ruby
require_relative 'dynamo_utilities'
require_relative 'table_details'
require_relative 'patient_message_loader'

class MatchTestDataManager
  LOCAL_TIER = 'local'
  INT_TIER = 'int'
  UAT_TIER = 'uat'
  SEED_DATA_FOLDER = 'seed_data_for_upload'
  PRESSUER_SEED_DATA_FOLDER = 'pressure_test'
  SEED_TEMPLATE_FOLDER = 'patient_seed_data_templates'
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
      if DynamoUtilities.table_exist(table_name, LOCAL_TIER)
        DynamoUtilities.backup_local_table_to_file(table_name, seed_file(table_name))
      end
    }
    LOG.log('Done!')
  end

  def self.backup_all_patient_local_db
    TableDetails.patient_tables.each { |table_name|
      if DynamoUtilities.table_exist(table_name, LOCAL_TIER)
        DynamoUtilities.backup_local_table_to_file(table_name, seed_file(table_name))
      end
    }
    LOG.log('Done!')
  end

  def self.backup_all_ta_local_db
    TableDetails.treatment_arm_tables.each { |table_name|
      if DynamoUtilities.table_exist(table_name, LOCAL_TIER)
        DynamoUtilities.backup_local_table_to_file(table_name, seed_file(table_name))
      end
    }
    LOG.log('Done!')
  end

  def self.backup_all_ion_local_db
    TableDetails.ion_tables.each { |table_name|
      if DynamoUtilities.table_exist(table_name, LOCAL_TIER)
        DynamoUtilities.backup_local_table_to_file(table_name, seed_file(table_name))
      end
    }
    LOG.log('Done!')
  end

  def self.delete_patients_from_seed(patient_id_list)
    TableDetails.patient_tables.each { |table_name|
      field_name = table_name=='event' ? 'entity_id' : 'patient_id'
      remove_json_nodes_from_file(seed_file(table_name), field_name, patient_id_list, 'S', table_name)
    }
    TableDetails.treatment_arm_tables.each { |table_name|
      remove_json_nodes_from_file(seed_file(table_name), 'patient_id', patient_id_list, 'S', table_name)
    }
  end

  # def self.delete_ta_from_seed(ta_id, stratum, version)
  #   field_name = table_name=='event' ? 'entity_id' : 'patient_id'
  #   remove_json_nodes_from_file(seed_file(table_name), field_name, patient_id_list, 'S', table_name)
  #   TableDetails.treatment_arm_tables.each { |table_name|
  #     remove_json_nodes_from_file(seed_file('treatment_arm'), 'patient_id', patient_id_list, 'S', table_name)
  #   }
  # end

  ################pressure test patient seed data
  def self.clear_all_pressure_seed_files
    TableDetails.patient_tables.each{|table_name|
      clear_pressure_seed_file(table_name)
    }
  end

  def self.clear_pressure_seed_file(table_name)
    empty_data = {
        "ScannedCount"=>0,
        "Count"=>0,
        "Items"=>[],
        "ConsumedCapacity"=>nil
    }
    File.open(pressure_seed_file(table_name), 'w') { |f| f.write(JSON.pretty_generate(empty_data)) }
    LOG.log("#{pressure_seed_file(table_name)} get cleared")
  end

  def self.generate_patient_instance(template_patient_id, count)
    TableDetails.patient_tables.each { |table_name|
      sorting_key = TableDetails.sorting_key(table_name)
      template_string = File.read(patient_seed_template_file(template_patient_id, table_name))
      id_offset = 1
      output = []
      while id_offset < (count+1) do
        id_offset +=1
        replace_string = template_string.gsub(template_patient_id, "#{template_patient_id}#{id_offset}")
        patient_template_items = JSON.parse(replace_string)['Items']
        next if patient_template_items.size < 1
        time_offset = id_offset.to_i * 300
        output.push(*replace_date_sorting_value(patient_template_items, sorting_key, time_offset))
      end
      append_items_to_seed_file(pressure_seed_file(table_name), output)
    }
  end

  def self.replace_date_sorting_value(item_list, sorting_key, time_offset)
    return unless sorting_key.present?
    item_list.each { |this_item|
      sorting_value = this_item[sorting_key]
      if sorting_value.keys[0] == 'S'
        if is_date_string(sorting_value['S'])
          new_time = Time.parse(sorting_value['S'])+time_offset
          sorting_value['S'] = new_time.iso8601
        end
      end
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

  def self.upload_pressure_data_to_local
    LOG.log('Uploading all pressure test seed data to local dynamodb')
    TableDetails.patient_tables.each do |table|
      DynamoUtilities.upload_seed_data(table, pressure_seed_file(table), LOCAL_TIER)
    end
    LOG.log('Done!')
  end

  def self.upload_pressure_data_to_int
    LOG.log('Uploading all pressure test seed data to int dynamodb')
    TableDetails.patient_tables.each do |table|
      DynamoUtilities.upload_seed_data(table, pressure_seed_file(table), INT_TIER)
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

  def self.patient_seed_template_file(template_type, table_name)
    "#{File.dirname(__FILE__)}/#{SEED_TEMPLATE_FOLDER}/#{template_type}/#{table_name}.json"
  end

  def self.pressure_seed_file(table_name)
    "#{File.dirname(__FILE__)}/#{SEED_DATA_FOLDER}/#{PRESSUER_SEED_DATA_FOLDER}/#{table_name}.json"
  end

  def self.append_items_to_seed_file(file_name, new_items)
    return if new_items.size<1
    file_hash = JSON.parse(File.read(file_name))
    items = file_hash['Items']
    items.push(*new_items)
    file_hash['ScannedCount'] = items.size
    file_hash['Count'] = items.size
    File.open(file_name, 'w') { |f| f.write(JSON.pretty_generate(file_hash)) }
    LOG.log("There are #{new_items.size} items added to #{file_name}")
  end

  def self.remove_json_nodes_from_file(file, target_field, target_value_list, value_type, nickname)
    file_hash = JSON.parse(File.read(file))
    items = file_hash['Items']
    old_count = items.size
    items.delete_if { |this_item|
      this_item.keys.include?(target_field) && target_value_list.include?(this_item[target_field][value_type]) }

    deleted = old_count-items.size
    if deleted > 0
      File.open(file, 'w') { |f| f.write(JSON.pretty_generate(file_hash)) }
    end
    LOG.log("There are #{old_count-items.size} items(#{target_field}=#{target_value_list.to_s}) get removed from #{nickname}")
  end

  def self.is_date_string(string)
    begin
      Date.parse(string)
    rescue ArgumentError
      return false
    end
    true
  end

  def self.json_node_exist_in_file(file, target_field, target_value, value_type)
    items = JSON.parse(File.read(file))['Items']
    items.any? { |this_item| this_item[target_field][value_type] == target_value }
  end
end
