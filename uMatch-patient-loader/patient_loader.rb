require 'HTTParty'

class PatientLoader
  include HTTParty

  # cmd line: ruby -r "./patient_loader.rb" -e "PatientLoader.load_patient '3344'"
  def self.load_patient(patient_id)
    p "Loading patient #{patient_id}"
    raise "patient_id must be valid" if patient_id.nil? || patient_id.length == 0
    file = File.read("patients/#{patient_id}.json")

    message_list = JSON.parse(file)
    p "There are #{message_list.length} json messages in patient json file. Processing..."

    message_list.each do |message|
      p "Loading message #{message.to_json}..."

      service_name = 'trigger'

      curl_cmd ="curl -k -X POST -H \"Content-Type: application/json\" -H \"Accept: application/json\"  -d '" + message.to_json + "' http://localhost:10240/" + service_name

      p "Running curl: #{curl_cmd}"

      output = `#{curl_cmd}`
      p "Output from running curl: #{output}"

      sleep(10)
    end

  end

end

PatientLoader.load_patient('0001')