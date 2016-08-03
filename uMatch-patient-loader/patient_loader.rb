require 'HTTParty'
require 'nci_match_patient_models'

class PatientLoader
  include HTTParty

  # cmd line: ruby -r "./patient_loader.rb" -e "PatientLoader.load_patient '3344'"
  def self.load_patient_to_local(patient_id, waitTime)
    p "Loading patient #{patient_id}"
    raise "patient_id must be valid" if patient_id.nil? || patient_id.length == 0
    file = File.read("patients/#{patient_id}.json")

    message_list = JSON.parse(file)
    p "There are #{message_list.length} json messages in patient json file. Processing..."

    allItems = 0
    failure = 0
    failList = 'Failed message IDs: '
    message_list.each do |message|
      allItems += 1
      p ''
      # p "Loading message #{message.to_json}..."
      if message.key?('sleep')
        p "Sleep for #{message['sleep']} seconds"
        sleep(message['sleep'].to_f)
      else
        service_name = 'trigger'

        curl_cmd ="curl -k -X POST -H \"Content-Type: application/json\" -H \"Accept: application/json\"  -d '" + message.to_json + "' http://localhost:10240/" + service_name
        p ''

        output = `#{curl_cmd}`
        p ''
        p "Output from running curl: #{output}"
        if !output.downcase.include?'success'
          p 'Failed'
          puts JSON.pretty_generate(message)
          failure += 1
          failList = "#{failList} No.#{allItems}"
        end
        sleep(waitTime)
      end
    end

    pass = allItems - failure
    p ''
    p "#{allItems} messages processed, #{pass} passed and #{failure} failed"
  end

  def self.configure
    Aws.config.update({
                          endpoint: 'https://dynamodb.us-east-1.amazonaws.com',
                          access_key_id: ENV['AWS_ACCESS_KEY_ID'],
                          secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
                          region: 'us-east-1'
                      })
  end


  def self.backup_local_db(table_name)
    cmd = "aws dynamodb scan --table-name #{table_name} --endpoint-url http://localhost:8000 > nci_match_bddtests_#{table_name}_seed_data.json"
    `#{cmd}`
  end

  def self.local_patient_to_aws
    NciMatchPatientModels::Patient.set_table_name 'patient'
    local_patient_json = JSON.parse(File.read('nci_match_bddtests_patient_seed_data.json'))
    items = local_patient_json['Items']
    p items.is_a?(Array)
    items.each do |this_patient|
      patient = NciMatchPatientModels::Patient.new
      this_patient.keys.each do |key|
        if patient.respond_to?(key)
          patient.send("#{key}=", this_patient[key].values[0])
        else
          p "Patient class doesn't contains attribute #{key}"
        end
      end
      patient.save

    end
  end

  def self.local_backup_to_aws(table_name)
    class_name = "NciMatchPatientModels::#{table_name.camelcase}"
    clazz = class_name.constantize
    clazz.send('set_table_name', table_name.downcase)
    local_json = JSON.parse(File.read("nci_match_bddtests_#{table_name}_seed_data.json"))
    items = local_json['Items']
    items.each do |this_item|
      this_instance = class_name.constantize.new
      this_item.keys.each do |key|

        if this_item[key].keys.length != 1
          p "#{class_name}-#{key} has #{this_item[key].keys.length} keys"
          return
        end

        if this_item[key].keys[0]=='NULL' #this value is null
          next
        end

        if this_item[key].keys[0]!='M'&&this_item[key].keys[0]!='S'
          p "#{class_name}-#{key} has invalid key #{this_item[key].keys[0]}"
          return
        end

        if this_instance.respond_to?(key)
          this_instance.send("#{key}=", this_item[key].values[0])
        else
          p "#{class_name} class doesn't contains attribute #{key}"
        end
      end

      if this_instance.respond_to?('save')
        this_instance.save
      else
        p "#{class_name} doesn't have save method!"
        return
      end

    end
  end

  def self.backup_all_local_patient_db
    backup_local_db('patient')
    backup_local_db('specimen')
    backup_local_db('event')
    backup_local_db('shipment')
    backup_local_db('variant')
    backup_local_db('variant_report')
    p 'Done!'
  end

  def self.upload_local_backups_to_aws
    configure
    # local_backup_to_aws('patient')
    # local_backup_to_aws('specimen')
    # local_backup_to_aws('shipment')
    #
    # local_backup_to_aws('event')
    local_backup_to_aws('variant')
    # local_backup_to_aws('variant_report')
    p 'Done!'
  end
end
