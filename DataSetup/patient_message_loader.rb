require 'HTTParty'

class PatientMessageLoader
  include HTTParty

  LOCAL_PATIENT_DATA_FOLDER = 'local_patient_data'
  LOCAL_DYNAMODB_URL = 'http://localhost:8000'
  LOCAL_PATIENT_API_URL = 'http://localhost:10240'
  SERVICE_NAME = 'trigger'

  def self.load_patient_to_local(message_file, wait_time)
    raise 'patient_id must be valid' if message_file.nil? || message_file.length == 0
    file = File.read("#{LOCAL_PATIENT_DATA_FOLDER}/#{message_file}.json")

    message_list = JSON.parse(file)
    p "There are #{message_list.length} json messages in patient json file. Processing..."

    all_items = 0
    failure = 0
    message_list.each do |message|
      all_items += 1
      if message.key?('sleep')
        p "Sleep for #{message['sleep']} seconds"
        sleep(message['sleep'].to_f)
      else

        curl_cmd ="curl -k -X POST -H \"Content-Type: application/json\""
        curl_cmd = curl_cmd + " -H \"Accept: application/json\"  -d '" + message.to_json
        curl_cmd = curl_cmd + "' #{LOCAL_PATIENT_API_URL}/#{SERVICE_NAME}"
        output = `#{curl_cmd}`
        p "Output from running No.#{all_items} curl: #{output}"
        unless output.downcase.include?'success'
          p 'Failed'
          puts JSON.pretty_generate(message)
          failure += 1
        end
        sleep(wait_time)
      end
    end

    pass = all_items - failure
    p ''
    p "#{all_items} messages processed, #{pass} passed and #{failure} failed"
  end
end
