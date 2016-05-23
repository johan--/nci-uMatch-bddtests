require 'json'
require 'rest-client'
require_relative 'env'

class Patient_helper_methods

  def Patient_helper_methods.createPatientTriggerRequestJSON (studyId,psn,stepNumber,status,comment, _accrualNumber, isDateCreated )
    dateCreated = getDateAsRequired(isDateCreated)

    headerHash = {"msg_guid"=>"",
                  "msg_dttm"=>""}

    internaUseHash = {"request_id"=>"",
                      "environment"=>"",
                      "request"=>""}

    patientTrigger = {"header"=>headerHash,
                      "study_id" => studyId,
                      "patient_id" => psn,
                      "step_number" => stepNumber,
                      "status" => status,
                      "message" => comment,
                      "registration_date" => dateCreated,
                      "internal_use_only"=>internaUseHash
    }

    return patientTrigger.to_json

  end

end


