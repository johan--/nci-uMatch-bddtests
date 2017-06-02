require_relative 'table_info'
require_relative 'logger'
require 'json'

class SeedFile
  SEED_DATA_FOLDER = "#{File.dirname(__FILE__)}/../seed_data_for_upload"


  def self.all_items(table, tag)
    file = seed_file(table, tag)
    result = []
    if File.exist?(file)
      result = JSON.parse(File.read(file))['Items']
    else
      Logger.warning("Seed data #{file} doesn't exist")
    end
    result
  end

  def self.delete_patients(patient_list, tag)
    TableInfo.patient_tables.each { |table_name|
      field_name = table_name=='event' ? 'entity_id' : 'patient_id'
      remove_json_nodes_from_file(seed_file(table_name, tag), field_name, patient_list, 'S', "#{tag}/#{table_name}")
    }
    TableInfo.treatment_arm_tables.each { |table_name|
      remove_json_nodes_from_file(seed_file(table_name, tag), 'patient_id', patient_list, 'S', "#{tag}/#{table_name}")
    }
  end

  def self.copy_patients_between_tags(patient_list, from_tag, to_tag)
    patient_list.each { |this_patient|
      tables = (TableInfo.patient_tables << TableInfo.treatment_arm_tables).flatten
      tables.each { |table_name|
        field_name = table_name=='event' ? 'entity_id' : 'patient_id'
        this_pt_data = get_json_node_from_file(seed_file(table_name, from_tag), field_name, this_patient, 'S')
        if this_pt_data.size > 0
          to_file = seed_file(table_name, to_tag)
          to_hash = JSON.parse(File.read(to_file))
          to_patients = []
          to_hash['Items'].each { |this_to| to_patients << this_to[field_name]['S'] }
          if to_patients.include?(this_patient)
            Logger.log("patient #{this_patient} has already been in #{to_tag} #{table_name} seed data, skipping...")
          else
            to_hash['Items'].push(*this_pt_data)
            to_hash['ScannedCount'] = to_hash['ScannedCount'] + this_pt_data.size
            to_hash['Count'] = to_hash['Count'] + this_pt_data.size
            File.open(to_file, 'w') { |f| f.write(JSON.pretty_generate(to_hash)) }
            Logger.log("There are #{this_pt_data.size} #{table_name} items(#{field_name}=#{this_patient}) get copied")
          end
        end
      }
    }
  end

  def self.analysis(tag)
    TableInfo.all_tables.each { |table_name|
      primary_key = TableInfo.primary_key(table_name)
      sorting_key = TableInfo.sorting_key(table_name)
      file_hash = JSON.parse(File.read(seed_file(table_name, tag)))['Items']
      analysis = {}
      file_hash.each { |this_item|
        id = this_item[primary_key]['S']
        id += "|#{this_item[sorting_key]['S']}" if sorting_key.length > 0
        if analysis.keys.include?(id)
          analysis[id] = analysis[id] + 1
        else
          analysis[id] = 1
        end
      }
      error = analysis.select { |k, v| v > 1 }
      Logger.log(table_name)
      Logger.log(JSON.pretty_generate(error))
      Logger.log("\n\n")
    }
  end

  def self.cleanup(tag)
    TableInfo.all_tables.each { |table_name|
      primary_key = TableInfo.primary_key(table_name)
      sorting_key = TableInfo.sorting_key(table_name)
      file_hash = JSON.parse(File.read(seed_file(table_name, tag)))
      items = file_hash['Items']
      ids = []
      new_items = []
      items.each { |this_item|
        id = this_item[primary_key]['S']
        id += "|#{this_item[sorting_key]['S']}" if sorting_key.length > 0
        if ids.include?(id)
          Logger.warning("#{id} is duplicated")
        else
          new_items << this_item
          ids << id
        end
      }
      if new_items.size < items.size
        file_hash['Items'] = new_items
        file_hash['ScannedCount'] = new_items.size
        file_hash['Count'] = new_items.size
        File.open(seed_file(table_name, tag), 'w') { |f| f.write(JSON.pretty_generate(file_hash)) }
      end
      Logger.log("#{items.size-new_items.size} items are deleted from #{tag} #{table_name}")
    }
  end

  def self.clear_all_seed_files(tag)
    TableInfo.all_tables.each { |table_name|
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
    File.open(seed_file(table_name, tag), 'w') { |f| f.write(JSON.pretty_generate(empty_data)) }
    Logger.log("#{seed_file(table_name, tag)} get cleared")
  end

  def self.seed_file(table_name, tag='patients')
    "#{SEED_DATA_FOLDER}/#{tag}/#{table_name}.json"
  end

  private_class_method def self.remove_json_nodes_from_file(file, target_field, target_value_list, value_type, nickname)
                         file_hash = JSON.parse(File.read(file))
                         items = file_hash['Items']
                         old_count = items.size
                         items.delete_if { |this_item|
                           this_item.keys.include?(target_field) && target_value_list.include?(this_item[target_field][value_type]) }

                         deleted = old_count-items.size
                         if deleted > 0
                           file_hash['ScannedCount'] = items.size
                           file_hash['Count'] = items.size
                           File.open(file, 'w') { |f| f.write(JSON.pretty_generate(file_hash)) }
                         end
                         list = target_value_list.to_s
                         if target_value_list.size>3
                           list = "[#{target_value_list[0]}, #{target_value_list[1]}, #{target_value_list[2]}, "
                           list += "and #{target_value_list.size-3} more...]"
                         end
                         message = "There are #{old_count-items.size} items"
                         message += "(#{target_field}=#{list}) get removed from #{nickname}"
                         Logger.log(message)
                       end

  private_class_method def self.get_json_node_from_file(file, target_field, target_value, value_type)
                         file_hash = JSON.parse(File.read(file))
                         items = file_hash['Items']
                         items.select { |this_item|
                           this_item.keys.include?(target_field) && target_value.eql?(this_item[target_field][value_type]) }
                       end
end