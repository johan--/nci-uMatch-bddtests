require 'json'
require 'rest-client'
require_relative 'env'
require_relative 'helper_methods.rb'

class COG_helper_methods
  def COG_helper_methods.setTreatmentArmStatus(treatmentArmID, status)
    @treatmentArm = {'id'=>treatmentArmID, 'status'=>status}
    @jsonString = @treatmentArm.to_json.to_s
    @response = Helper_Methods.post_request(ENV['protocol']+'://'+ENV['DOCKER_HOSTNAME']+':'+ENV['cog_mock_PORT']+'/setTreatmentArmStatus', @jsonString)
    sleep(1.0)
    return @response
  end
  def COG_helper_methods.getTreatmentArmStatus(treatmentArmID)
    query = "/getTreatmentArmAssignment?treatment_arm_id=#{treatmentArmID}"
    @response = Helper_Methods.get_request(ENV['protocol']+'://'+ENV['DOCKER_HOSTNAME']+':'+ENV['cog_mock_PORT']+query)
    sleep(1.0)
    return @response
  end
end