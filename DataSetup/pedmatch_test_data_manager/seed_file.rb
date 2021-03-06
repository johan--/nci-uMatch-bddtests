require_relative 'table_info'
require_relative 'log'
require 'fileutils'
require 'json'

class SeedFile
  SEED_DATA_FOLDER = "#{File.dirname(__FILE__)}/../seed_data_for_upload"

  def self.create_tag_if_not_exist(tag, copy_patient=true)
    if Dir.exist?("#{SEED_DATA_FOLDER}/#{tag}")
      Log.warning("Tag exists #{tag}, skip")
      return
    end
    FileUtils.makedirs("#{SEED_DATA_FOLDER}/#{tag}")
    FileUtils.cp_r("#{SEED_DATA_FOLDER}/patients/.", "#{SEED_DATA_FOLDER}/#{tag}") if copy_patient
  end

  def self.all_items(table, tag)
    file = seed_file(table, tag)
    result = []
    if File.exist?(file)
      result = JSON.parse(File.read(file))['Items']
    else
      Log.warning("Seed data #{file} doesn't exist")
    end
    result
  end

  def self.all_keys(table, tag)
    keys = TableInfo.keys(table)
    items = all_items(table, tag)
    result = []
    items.each {|i|
      this_key = {}
      keys.each {|k| this_key[k] = i[k].values.first}
      result << this_key
    }
    result
  end

  def self.delete_patients(patient_list, tag)
    TableInfo.patient_tables.each {|table_name|
      field_name = table_name=='event' ? 'entity_id' : 'patient_id'
      remove_json_nodes_from_file(seed_file(table_name, tag), field_name, patient_list, 'S', "#{tag}/#{table_name}")
    }
    rollback_in_ta_tables(patient_list, tag)
    # TableInfo.treatment_arm_tables.each { |table_name|
    #   remove_json_nodes_from_file(seed_file(table_name, tag), 'patient_id', patient_list, 'S', "#{tag}/#{table_name}")
    # }
  end

  def self.copy_patients_between_tags(patient_list, from_tag, to_tag)
    patient_list.each {|this_patient|
      tables = (TableInfo.patient_tables << TableInfo.treatment_arm_tables).flatten
      tables.each {|table_name|
        field_name = table_name=='event' ? 'entity_id' : 'patient_id'
        this_pt_data = get_json_node_from_file(seed_file(table_name, from_tag), field_name, this_patient, 'S')
        if this_pt_data.size > 0
          to_file = seed_file(table_name, to_tag)
          to_hash = JSON.parse(File.read(to_file))
          to_patients = []
          to_hash['Items'].each {|this_to| to_patients << this_to[field_name]['S']}
          if to_patients.include?(this_patient)
            Log.info("patient #{this_patient} has already been in #{to_tag} #{table_name} seed data, skipping...")
          else
            to_hash['Items'].push(*this_pt_data)
            to_hash['ScannedCount'] = to_hash['ScannedCount'] + this_pt_data.size
            to_hash['Count'] = to_hash['Count'] + this_pt_data.size
            File.open(to_file, 'w') {|f| f.write(JSON.pretty_generate(to_hash))}
            Log.info("There are #{this_pt_data.size} #{table_name} items(#{field_name}=#{this_patient}) get copied")
          end
        end
      }
    }
    add_patients_to_ta_table(patient_list, to_tag)
  end

  def self.analysis(tag)
    TableInfo.all_tables.each {|table_name|
      primary_key = TableInfo.primary_key(table_name)
      sorting_key = TableInfo.sorting_key(table_name)
      file_hash = JSON.parse(File.read(seed_file(table_name, tag)))['Items']
      analysis = {}
      file_hash.each {|this_item|
        id = this_item[primary_key]['S']
        id += "|#{this_item[sorting_key]['S']}" if sorting_key.length > 0
        if analysis.keys.include?(id)
          analysis[id] = analysis[id] + 1
        else
          analysis[id] = 1
        end
      }
      error = analysis.select {|k, v| v > 1}
      Log.info(table_name)
      Log.info(JSON.pretty_generate(error))
      Log.info("\n\n")
    }
  end

  def self.cleanup(tag)
    TableInfo.all_tables.each {|table_name|
      primary_key = TableInfo.primary_key(table_name)
      sorting_key = TableInfo.sorting_key(table_name)
      file_hash = JSON.parse(File.read(seed_file(table_name, tag)))
      items = file_hash['Items']
      ids = []
      new_items = []
      items.each {|this_item|
        id = this_item[primary_key]['S']
        id += "|#{this_item[sorting_key]['S']}" if sorting_key.length > 0
        if ids.include?(id)
          Log.warning("#{id} is duplicated")
        else
          new_items << this_item
          ids << id
        end
      }
      if new_items.size < items.size
        file_hash['Items'] = new_items
        file_hash['ScannedCount'] = new_items.size
        file_hash['Count'] = new_items.size
        File.open(seed_file(table_name, tag), 'w') {|f| f.write(JSON.pretty_generate(file_hash))}
      end
      Log.info("#{items.size-new_items.size} items are deleted from #{tag} #{table_name}")
    }
  end

  def self.clear_all_seed_files(tag)
    TableInfo.all_tables.each {|table_name|
      clear_seed_file(table_name, tag)
    }
  end

  def self.clear_seed_file(table_name, tag)
    empty_data = {
        :ScannedCount => 0,
        :Count => 0,
        :Items => [],
        :ConsumedCapacity => nil
    }
    File.open(seed_file(table_name, tag), 'w') {|f| f.write(JSON.pretty_generate(empty_data))}
    Log.info("#{seed_file(table_name, tag)} get cleared")
  end

  def self.seed_file(table_name, tag='patients')
    "#{SEED_DATA_FOLDER}/#{tag}/#{table_name}.json"
  end

  private_class_method def self.add_patients_to_ta_table(patient_list, tag)
                         file = seed_file('treatment_arm_assignment_event', tag)
                         file_hash = JSON.parse(File.read(file))
                         items = file_hash['Items']
                         changed = []
                         items.each do |this_item|
                           if patient_list.include?(this_item['patient_id']['S'])
                             status = this_item['patient_status']['S']
                             ta_id = this_item['treatment_arm_id']['S']
                             stratum = this_item['stratum_id']['S']
                             version = this_item['version']['S']
                             changed << this_item['patient_id']['S']
                             update_ta_table(status, ta_id, stratum, version, tag, 'add')
                           end
                         end

                         list = changed.to_s
                         if changed.size>3
                           list = "[#{changed[0]}, #{changed[1]}, #{changed[2]}, "
                           list += "and #{changed.size-3} more...]"
                         end
                         message = "There are #{changed.size} patients"
                         message += "(patient_id=#{list}) get updated in treatment arm table"
                         Log.info(message)
                       end

  private_class_method def self.remove_json_nodes_from_file(file, target_field, target_value_list, value_type, nickname)
                         file_hash = JSON.parse(File.read(file))
                         items = file_hash['Items']
                         old_count = items.size
                         items.delete_if {|this_item|
                           this_item.keys.include?(target_field) && target_value_list.include?(this_item[target_field][value_type])}

                         deleted = old_count-items.size
                         if deleted > 0
                           file_hash['ScannedCount'] = items.size
                           file_hash['Count'] = items.size
                           File.open(file, 'w') {|f| f.write(JSON.pretty_generate(file_hash))}
                         end
                         list = target_value_list.to_s
                         if target_value_list.size>3
                           list = "[#{target_value_list[0]}, #{target_value_list[1]}, #{target_value_list[2]}, "
                           list += "and #{target_value_list.size-3} more...]"
                         end
                         message = "There are #{old_count-items.size} items"
                         message += "(#{target_field}=#{list}) get removed from #{nickname}"
                         Log.info(message)
                       end

  private_class_method def self.get_json_node_from_file(file, target_field, target_value, value_type)
                         file_hash = JSON.parse(File.read(file))
                         items = file_hash['Items']
                         items.select {|this_item|
                           this_item.keys.include?(target_field) && target_value.eql?(this_item[target_field][value_type])}
                       end

  private_class_method def self.rollback_in_ta_tables(patient_list, tag)
                         file = seed_file('treatment_arm_assignment_event', tag)
                         file_hash = JSON.parse(File.read(file))
                         items = file_hash['Items']
                         old_count = items.size
                         items.each do |this_item|
                           if patient_list.include?(this_item['patient_id']['S'])
                             items.delete(this_item)
                             status = this_item['patient_status']['S']
                             ta_id = this_item['treatment_arm_id']['S']
                             stratum = this_item['stratum_id']['S']
                             version = this_item['version']['S']
                             update_ta_table(status, ta_id, stratum, version, tag)
                           end
                         end

                         deleted = old_count-items.size
                         if deleted > 0
                           file_hash['ScannedCount'] = items.size
                           file_hash['Count'] = items.size
                           File.open(file, 'w') {|f| f.write(JSON.pretty_generate(file_hash))}
                         end
                         list = patient_list.to_s
                         if patient_list.size>3
                           list = "[#{patient_list[0]}, #{patient_list[1]}, #{patient_list[2]}, "
                           list += "and #{patient_list.size-3} more...]"
                         end
                         message = "There are #{deleted} patients"
                         message += "(patient_id=#{list}) get removed from treatment arm tables"
                         Log.info(message)
                       end

  private_class_method def self.update_ta_table(status, ta_id, stratum, version, tag, add_or_remove='remove')
                         statuses = %w(PREVIOUSLY_ON_ARM PREVIOUSLY_ON_ARM_OFF_STUDY NOT_ENROLLED_ON_ARM)
                         statuses << 'NOT_ENROLLED_ON_ARM_OFF_STUDY'
                         statuses << 'PENDING_APPROVAL'
                         statuses << 'ON_TREATMENT_ARM'
                         return unless statuses.include?(status)
                         file_hash = JSON.parse(File.read(seed_file('treatment_arm', tag)))
                         ta_hashes = file_hash['Items'].select {|this_ta|
                           this_ta['treatment_arm_id']['S'] == ta_id && this_ta['stratum_id']['S']==stratum}
                         ta_hash = ta_hashes.select {|ta| ta['version']['S']==version}[0]
                         case status
                           when 'PREVIOUSLY_ON_ARM', 'PREVIOUSLY_ON_ARM_OFF_STUDY'
                             field = 'former_patients'
                             v_field = 'version_former_patients'
                           when 'NOT_ENROLLED_ON_ARM', 'NOT_ENROLLED_ON_ARM_OFF_STUDY'
                             field = 'not_enrolled_patients'
                             v_field = 'version_not_enrolled_patients'
                           when 'PENDING_APPROVAL'
                             field = 'pending_patients'
                             v_field = 'version_pending_patients'
                           when 'ON_TREATMENT_ARM'
                             field = 'current_patients'
                             v_field = 'version_current_patients'
                           else
                             field = ''
                             v_field = ''
                         end
                         case add_or_remove
                           when 'add'
                             diff = 1
                           when 'remove'
                             diff = -1
                           else
                             diff = 0
                         end
                         add_number_fields(ta_hash)
                         ta_hash[v_field]['N'] = (ta_hash[v_field]['N'].to_i + diff).to_s
                         ta_hashes.each do |ta|
                           add_number_fields(ta)
                           ta[field]['N'] = (ta[field]['N'].to_i + diff).to_s
                         end
                         File.open(seed_file('treatment_arm', tag), 'w') {|f| f.write(JSON.pretty_generate(file_hash))}
                       end
  private_class_method def self.add_number_fields(ta_hash)
                         ta_hash['former_patients'] = {'N' => "0"} unless ta_hash['former_patients'].present?
                         ta_hash['version_former_patients'] = {'N' => "0"} unless ta_hash['version_former_patients'].present?
                         ta_hash['not_enrolled_patients'] = {'N' => "0"} unless ta_hash['not_enrolled_patients'].present?
                         ta_hash['version_not_enrolled_patients'] = {'N' => "0"} unless ta_hash['version_not_enrolled_patients'].present?
                         ta_hash['pending_patients'] = {'N' => "0"} unless ta_hash['pending_patients'].present?
                         ta_hash['version_pending_patients'] = {'N' => "0"} unless ta_hash['version_pending_patients'].present?
                         ta_hash['current_patients'] = {'N' => "0"} unless ta_hash['current_patients'].present?
                         ta_hash['version_current_patients'] = {'N' => "0"} unless ta_hash['version_current_patients'].present?
                       end
end