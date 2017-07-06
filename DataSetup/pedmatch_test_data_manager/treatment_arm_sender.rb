require_relative 'ped_match_rest_client'

class TreatmentArmSender
  TA_LIBRARY="#{File.dirname(__FILE__)}/../local_treatment_arm_data/Treatment_Arm_data.json"
  LOCAL_TA_API_URL = 'http://localhost:10235/api/v1/treatment_arms'
  @all_ta_data=JSON.parse(File.read(TA_LIBRARY))

  def self.set_treatment_arm_api_url(url=LOCAL_TA_API_URL)
    @ta_url = url
  end

  def self.treatment_arm_api_url
    @ta_url||=LOCAL_TA_API_URL
  end

  def self.send_by_json(ta_json_or_hash)
    treatment_arm_hash = convert_hash(ta_json_or_hash)
    return false if treatment_arm_hash.nil?
    ta_id = treatment_arm_hash['treatment_arm_id']
    stratum = treatment_arm_hash['stratum_id']
    version = treatment_arm_hash['version']
    treatment_arm_hash['date_created'] = Time.now.iso8601
    url = "#{treatment_arm_api_url}/#{ta_id}/#{stratum}/#{version}"
    last_response = PedMatchRestClient.send_until_accept(url, 'post', treatment_arm_hash)
    if last_response.code < 203
      Logger.info("Treatment Arm: #{ta_id}-#{stratum}(#{version}) is done")
      sleep 1.0
      true
    else
      error = "Failed to generate Treatment Arm: #{ta_id}-#{stratum}(#{version}) with error: "
      Logger.error(error)
      Logger.error(last_response)
      false
    end
  end

  def self.send_by_id(treatment_arm_id, stratum_id, version)
    ta = @all_ta_data.select {|ta|
      ta['treatment_arm_id']==treatment_arm_id && ta['stratum_id'] == stratum_id && ta['version'] == version}[0]
    send_by_json(ta)
  end


  def self.send_all
    @all_ta_data.each {|ta|
      send_by_json(ta)
    }
    sleep 10.0
  end

  def self.all_treatment_arms
    keys = %W(treatment_arm_id stratum_id version)
    result = []
    @all_ta_data.each {|ta| result << ta.select {|key, _| keys.include?(key)}}
    result
  end

  def self.save_to_library(ta_json_or_hash)
    hash = convert_hash(ta_json_or_hash)
    return if hash.nil?
    ta_id = hash['treatment_arm_id']
    str = hash['stratum_id']
    v = hash['version']
    exist = hash.any? {|ta| ta['treatment_arm_id'] == ta_id && ta['stratum_id'] == str && ta['version'] == v}
    if  exist
      Logger.error("Treatment arm #{ta_id}-#{str}(#{v}) exists in library!")
    else
      @all_ta_data << hash
      File.open(TA_LIBRARY, 'w') {|f| f.write(JSON.pretty_generate(@all_ta_data))}
      Logger.log("Treatment arm #{ta_id}-#{str}(#{v}) has been inserted to library!")
    end
  end

  private_class_method def self.convert_hash(ta_json_or_hash)
                         if ta_json_or_hash.is_a?(String)
                           begin
                             JSON.parse(ta_json_or_hash)
                           rescue JSON::ParserError => e
                             Logger.log(e.to_s)
                             nil
                           end
                         elsif ta_json_or_hash.is_a?(Hash)
                           ta_json_or_hash
                         else
                           Logger.error("#{ta_json_or_hash.to_s} is not a string or hash!")
                           nil
                         end
                       end
end