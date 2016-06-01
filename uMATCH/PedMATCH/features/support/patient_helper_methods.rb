require 'json'
require 'rest-client'
require_relative 'env'
require_relative 'helper_methods.rb'

class Patient_helper_methods

  def Patient_helper_methods.createPatientTriggerRequestJSON (studyId,psn,stepNumber,status,comment, _accrualNumber, isDateCreated )
    dateCreated = Helper_Methods.getDateAsRequired(isDateCreated)

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

  def Patient_helper_methods.createBiopsyRequest(params={})
    p params['receivedDate']
    msgHash = JSON.parse(params['msg'])
    specimenHash = msgHash['specimens_received']
    if !params['receivedDate'].nil?
      @reportedDate = Helper_Methods.getDateAsRequired(params['receivedDate'])
      specimenHash[0]['received_ts'] = @reportedDate
    end

    if !params['collectionDate'].nil?
      @collectedDate = Helper_Methods.getDateAsRequired(params['collectionDate'])
      specimenHash[0]['collection_ts'] = @collectedDate
    end

    return msgHash.to_json
  end

end


