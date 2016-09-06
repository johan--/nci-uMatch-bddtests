require 'json'
require 'rest-client'
require_relative 'helper_methods.rb'


class COG_helper_methods
  def COG_helper_methods.setTreatmentArmStatus(treatmentArmID, stratumID, status)
    @treatmentArm = {'treatment_arm_id'=>treatmentArmID,'stratum_id'=>stratumID, 'status'=>status}
    @jsonString = @treatmentArm.to_json.to_s
    @response = Helper_Methods.post_request(ENV['cog_mock_endpoint']+'/setTreatmentArmStatus', @jsonString)
    sleep(1.0)
    return @response
  end
  def COG_helper_methods.getTreatmentArmStatus(treatmentArmID, stratumID)
    query = "/treatmentArm?treatment_arm_id=#{treatmentArmID}&stratum_id=#{stratumID}"
    @response = Helper_Methods.get_request(ENV['cog_mock_endpoint']+query)
    sleep(1.0)
    return @response
  end

  def COG_helper_methods.setServiceLostPatient(patient_id, error_times)
    @response = Helper_Methods.post_request(ENV['cog_mock_endpoint']+'/setupServiceLostSimulationForPatient/'+patient_id+'/'+error_times, '')
    sleep(1.0)
    return @response

  end

  def COG_helper_methods.get_patient_assignment_status(patient_id)
    query = "/getPatientAssignmentStatus/#{patient_id}"
    @response = Helper_Methods.get_request(ENV['cog_mock_endpoint']+query)
    sleep(1.0)
    return @response
  end
end