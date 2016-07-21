require 'HTTParty'

class PatientLoader
  include HTTParty

  # cmd line: ruby -r "./patient_loader.rb" -e "PatientLoader.load_patient '3344'"
  def self.load_patient(patient_id, waitTime)
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
        if !output.include?'Success'
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

end
