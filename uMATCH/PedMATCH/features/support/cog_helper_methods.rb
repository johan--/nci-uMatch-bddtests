require 'json'
require 'rest-client'
require_relative 'helper_methods.rb'
require_relative 'patient_helper_methods.rb'


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

  def COG_helper_methods.register_assignment_decision(patient_id, decision, step_number, ta_id, ta_stratum, rebiopsy)
    decision_json = {}
    if decision.include?'OFF_STUDY'
      decision_json = Patient_helper_methods.load_patient_message_templates('off_study')
    elsif decision.include?'REQUEST'
      decision_json = Patient_helper_methods.load_patient_message_templates('request_assignment')
    else
      decision_json = Patient_helper_methods.load_patient_message_templates('on_treatment_arm')
    end
    decision_json['patient_id'] = patient_id
    decision_json['step_number'] = step_number
    decision_json['status'] = decision
    decision_json['status_date'] = Helper_Methods.getDateAsRequired('current')
    decision_json['treatment_arm_id'] = ta_id
    decision_json['stratum_id'] = ta_stratum
    decision_json['rebiopsy'] = rebiopsy
    @response = Helper_Methods.post_request(ENV['cog_mock_endpoint']+'/setCogDecisionForPatient/'+patient_id, decision_json.to_json)
    sleep(1.0)
    return @response
  end
end