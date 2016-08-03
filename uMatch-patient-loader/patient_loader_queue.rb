require "#{File.expand_path File.dirname(__FILE__)}/config/sqs"


class PatientLoaderQueue


  # cmd line: ruby -r "./patient_loader_queue.rb" -e "PatientLoaderQueue.load_patient '3344'"
  def self.load_patient(patient_id, wait_time=2)

    begin

      # patient_id = message['load_patient']

      p "Loading patient #{patient_id}"
      raise "patient_id must be valid" if patient_id.nil? || patient_id.length == 0

      file = File.read("#{File.expand_path File.dirname(__FILE__)}/patients/#{patient_id}.json")

      message_list = JSON.parse(file)
      p "There are #{message_list.length} json messages in patient json file. Processing..."

      queue_name = ENV['queue_name']
      message_list.each do |message|
        p "Publishing message to queue: #{queue_name}: #{message}"
        Aws::Sqs::Publisher.publish(message)

        sleep 30
      end

      p " ================= Done ===================="
    rescue => exception
      p "=========== Error: #{exception.message}"
    end

  end

end