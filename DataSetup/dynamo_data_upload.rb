require 'nci_match_patient_models'
require_relative 'table_details'
require_relative 'options_manager'

class DynamoDataUploader


  DEFAULT_AWS_ENDPOINT = 'https://dynamodb.us-east-1.amazonaws.com'
  DEFAULT_AWS_REGION = "us-east-1"
  DEFAULT_AWS_ACCESS_KEY = ENV['AWS_ACCESS_KEY_ID']
  DEFAULT_AWS_SECRET_KEY = ENV['AWS_SECRET_ACCESS_KEY']
  DEFAULT_LOCAL_DB_ENDPOINT = 'http://localhost:8000'
  SEED_DATA_FOLDER = 'seed_data_for_upload'
  SEED_FILE_PREFIX = 'nci_match_bddtests_seed_data'



  def self.backup_all_local_db
    TableDetails.all_tables.each { |table_name|
      cmd = "aws dynamodb scan --table-name #{table_name} "
      cmd = cmd + "--endpoint-url #{DEFAULT_LOCAL_DB_ENDPOINT} > "
      cmd = cmd + "#{SEED_DATA_FOLDER}/#{SEED_FILE_PREFIX}_#{table_name}.json"
      `#{cmd}`
      p "Table <#{table_name}> has been exported"
    }
    p 'Done!'
  end


  def initialize(options)
    @endpoint = options[:endpoint].nil??DEFAULT_AWS_ENDPOINT:options[:endpoint]
    @region = options[:region].nil??DEFAULT_AWS_REGION:options[:region]
    @access_key = options[:aws_access_key_id].nil??DEFAULT_AWS_ACCESS_KEY:options[:aws_access_key_id]
    @secret_key = options[:endpoint].nil??DEFAULT_AWS_SECRET_KEY:options[:@secret_key]

    Aws.config.update({
                          endpoint: @endpoint,
                          access_key_id: @access_key,
                          secret_access_key: @secret_key,
                          region: @region
                      })
    p "AWS endpoint: #{@endpoint}, region: #{@region}"
  end

  def upload_patient_data_to_aws
    TableDetails.patient_tables.each { |table_name| upload_patient_table_to_aws(table_name) }
    p 'All local to aws works done!'
  end

  def upload_patient_table_to_aws(table_name)
    class_name = "NciMatchPatientModels::#{table_name.camelize}"
    clazz = class_name.constantize
    clazz.send('set_table_name', table_name.downcase)
    local_json = JSON.parse(File.read("#{SEED_DATA_FOLDER}/#{SEED_FILE_PREFIX}_#{table_name}.json"))
    items = local_json['Items']
    items.each do |this_item|
      this_instance = clazz.new
      this_item.keys.each do |this_field|
        unless is_a_valid_field(class_name, this_field, this_item[this_field])
          return
        end

        if this_item[this_field].keys[0]=='NULL' #this value is null
          next
        end

        if this_instance.respond_to?(this_field)
          this_instance.send("#{this_field}=", extract_value(this_item[this_field]))
        else
          p "#{class_name} class doesn't contains attribute #{this_field}"
        end
      end

      if this_instance.respond_to?('save')
        this_instance.save
      else
        p "#{class_name} doesn't have save method!"
        return
      end
    end
    p "#{table_name}: Local to aws done!"
  end

  def extract_value(field_object)
    if field_object.keys[0] == 'M'
      result = Hash.new
      field_object.values[0].each do |key, value|
        result[key] = value.values[0]
      end
      result
    else
      field_object.values[0]
    end
  end

  def is_a_valid_field(class_name, field_name, field_object)
    length_correct = field_object.keys.length == 1
    unless length_correct
      p "#{class_name}-#{field_name} has #{field_object.keys.length} keys"
    end

    acceptable_types = %w(M S BOOL N NULL)
    type_correct = acceptable_types.include?(field_object.keys[0])
    unless type_correct
      p "#{class_name}-#{field_name} has invalid key #{field_object.keys[0]}"
    end
    length_correct&&type_correct
  end
end


options = OptionsManager.parse(ARGV)
DynamoDataUploader.new(options).upload_patient_data_to_aws