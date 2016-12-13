require 'HTTParty'
require_relative '../uMATCH/PedMATCH/features/support/environment'
require_relative '../uMATCH/PedMATCH/features/support/helper_methods'

class TreatmentArmMessageLoader
  include HTTParty

  LOCAL_TREATMENT_ARM_DATA_FOLDER = File.expand_path(File.join(__FILE__, '..', 'local_treatment_arm_data'))
  LOCAL_DYNAMODB_URL = 'http://localhost:8000'
  LOCAL_TREATMENT_ARM_API_URL = 'http://localhost:10235/api/v1/treatment_arms'

  def self.upload_start_with_wait_time(time)
    @wait_time = time
    @all_items = 0
    @failure = 0

    file = File.read("#{LOCAL_TREATMENT_ARM_DATA_FOLDER}/Treatment_Arm_data.json")

    @message_list = JSON.parse(file)
    p "There are #{@message_list.length} json messages in treatment arm json file. Processing..."
  end

  def self.upload_done
    pass = @all_items - @failure
    p "#{@all_items} messages processed, #{pass} passed and #{@failure} failed"
  end

  def self.load_treatment_arm_to_local(ta_id, stratum, version)
    ta_hash = {}
    @message_list.each do |message|
      if message['treatment_arm_id'] == ta_id && message['stratum_id'] == stratum && message['version'] == version
        ta_hash = message
      end
    end

    if ta_hash.length>0
      @all_items += 1
      curl_cmd ="curl -k -X POST -H \"Content-Type: application/json\""
      curl_cmd = curl_cmd + " -H \"Accept: application/json\"  -d '" + ta_hash.to_json
      curl_cmd = curl_cmd + "' #{LOCAL_TREATMENT_ARM_API_URL}/#{ta_id}/#{stratum}/#{version}"
      output = `#{curl_cmd}`
      p "Output from running No.#{@all_items} curl: #{output}"
      unless output.downcase.include?'success'
        p 'Failed'
        puts JSON.pretty_generate(message)
        @failure += 1
      end
      sleep(@wait_time)
    else
      puts "#{ta_id} #{stratum} #{version} doesn't exist!!!"
    end
  end

  def self.update_treatment_arm_status
    url = "#{LOCAL_TREATMENT_ARM_API_URL}/status"
    Helper_Methods.put_request(url, '')
  #   curl_cmd ="curl -k -X PUT"
  #   # curl_cmd = curl_cmd + " -H \"Content-Type: application/json\""
  #   # curl_cmd = curl_cmd + " -H \"Accept: application/json\""
  #   curl_cmd = curl_cmd + " #{LOCAL_TREATMENT_ARM_API_URL}/status"
  #   puts curl_cmd
  #   `#{curl_cmd}`
  end
end
