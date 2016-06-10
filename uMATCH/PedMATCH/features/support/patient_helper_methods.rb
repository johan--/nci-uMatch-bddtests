require 'json'
require 'rest-client'
require_relative 'env'
require_relative 'helper_methods.rb'

class Patient_helper_methods

  def Patient_helper_methods.createPatientTriggerRequestJSON (studyId,psn,stepNumber,status,comment, _accrualNumber, isDateCreated )
    dateCreated = Helper_Methods.getDateAsRequired(isDateCreated)

    headerHash = {"msg_guid"=>"0f8fad5b-d9cb-469f-al65-80067728950e",
                  "msg_dttm"=>dateCreated}

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

  def Patient_helper_methods.createSpecimenRequest(params={})
    msgHash = JSON.parse(params['msg'])
    specimenHash = msgHash['specimens_received']
    if !params['receivedDate'].nil?
      @reportedDate = Helper_Methods.getDateAsRequired(params['receivedDate'])
      specimenHash['received_date'] = @reportedDate
    end

    if !params['collectionDate'].nil?
      @collectedDate = Helper_Methods.getDateAsRequired(params['collectionDate'])
      specimenHash['collected_date'] = @collectedDate
    end

    return msgHash.to_json
  end

  def Patient_helper_methods.create_new_specimen_received_message(psn,type,datePreference)
    dateCreated = Helper_Methods.getDateAsRequired(datePreference)

    header_hash = {"msg_guid"=>"0f8fad5b-d9cb-469f-al65-80067728950e",
                  "msg_dttm"=>dateCreated
    }

    internal_use_Hash = {"stars_patient_id"=>psn,
                      "stars_specimen_id"=>"bsn"+"-"+psn,
                      "stars_specimen_type"=>type,
                      "received_ts"=>dateCreated,
                      "qc_ts"=>dateCreated
    }

    specimen_hash={"study_id"=>'APEC1621',
                   "patient_id"=> psn,
                   "type"=>type,
                   "surgical_event_id"=>"bsn"+"-"+psn,
                   "collected_date"=>dateCreated,
                   "received_date"=>dateCreated,
                   "internal_use_only"=>internal_use_Hash
    }

    specimen_received_hash ={"header"=>header_hash,
                             "specimen_received"=>specimen_hash
    }

    return specimen_received_hash.to_json
  end

  def Patient_helper_methods.create_assay_order_message(params={})
    msgHash = JSON.parse(params['msg'])
    if !params['ordered_date'].nil?
      @reportedDate = Helper_Methods.getDateAsRequired(params['ordered_date'])
      msgHash['ordered_date'] = @reportedDate
    end
    return msgHash.to_json
  end

  def Patient_helper_methods.create_assay_result_message(params={})
    msgHash = JSON.parse(params['msg'])
    if !params['reported_date'].nil?
      @reportedDate = Helper_Methods.getDateAsRequired(params['reported_date'])
      msgHash['reported_date'] = @reportedDate
    end
    return msgHash.to_json
  end
end


