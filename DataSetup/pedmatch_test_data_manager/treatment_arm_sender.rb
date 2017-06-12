require_relative 'ped_match_rest_client'

class TreatmentArmSender
  TA_FOLDER="#{File.dirname(__FILE__)}/../local_treatment_arm_data/Treatment_Arm_data.json"
  ALL_TA_DATA=JSON.parse(File.read(TA_FOLDER))
  LOCAL_TA_API_URL = 'http://localhost:10235/api/v1/treatment_arms'

  def self.set_treatment_arm_api_url(url=LOCAL_TA_API_URL)
    @ta_url = url
  end

  def self.treatment_arm_api_url
    @ta_url||=LOCAL_TA_API_URL
  end

  def self.send_by_hash(treatment_arm_hash)
    ta_id = treatment_arm_hash['treatment_arm_id']
    stratum = treatment_arm_hash['stratum_id']
    version = treatment_arm_hash['version']
    treatment_arm_hash['date_created'] = Time.now.iso8601
    url = "#{treatment_arm_api_url}/#{ta_id}/#{stratum}/#{version}"
    last_response = PedMatchRestClient.send_until_accept(url, 'post', treatment_arm_hash)
    if last_response.code < 203
      Logger.info("Treatment Arm: #{ta_id}-#{stratum}(#{version}) is done")
      true
    else
      error = "Failed to generate Treatment Arm: #{ta_id}-#{stratum}(#{version}) with error: "
      Logger.error(error)
      Logger.error(last_response)
      false
    end
  end

  def self.send_by_id(treatment_arm_id, stratum_id, version)
    ta = ALL_TA_DATA.select { |ta|
      ta['treatment_arm_id']==treatment_arm_id && ta['stratum_id'] == stratum_id && ta['version'] == version }[0]
    send_by_hash(ta)
  end


  def self.send_all
    ALL_TA_DATA.each { |ta|
      send_by_hash(ta)
    }
  end

  def self.all_treatment_arms
    keys = %W(treatment_arm_id stratum_id version)
    result = []
    ALL_TA_DATA.each { |ta| result << ta.select { |key, _| keys.include?(key) } }
    result
  end
end