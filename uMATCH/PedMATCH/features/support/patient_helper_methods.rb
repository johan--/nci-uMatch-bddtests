require 'json'
require 'rest-client'
require_relative 'env'
require_relative 'helper_methods.rb'

class Patient_helper_methods

  def Patient_helper_methods.createPatientTriggerRequestJSON (studyId,psn,stepNumber,status,comment, _accrualNumber, isDateCreated )
    dateCreated = Helper_Methods.getDateAsRequired(isDateCreated)

    headerHash = {"msg_guid"=>"0f8fad5b-d9cb-469f-al65-80067728950e",
                  "msg_dttm"=>dateCreated}

    internaUseHash = {"request_id"=>"4-654321",
                      "environment"=>"4",
                      "request"=>"new pateint registration"}

    patientTrigger = {"header"=>headerHash,
                      "study_id" => studyId,
                      "patient_id" => psn,
                      "step_number" => stepNumber,
                      "registration_date" => dateCreated,
                      "status" => status,
                      # "message" => comment,
                      # "rebiopsy"=>'',
                      "internal_use_only"=>internaUseHash
    }

    # tempPatientTrigger = {"Cog"=>actualpatientTrigger}
    return patientTrigger.to_json

  end

  def Patient_helper_methods.createSpecimenRequest(params={})
    msgHash = JSON.parse(params['msg'])
    specimenHash = msgHash['specimen_received']
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

  def Patient_helper_methods.createSpecimenShippedMessageRequest(params={})
    msgHash = JSON.parse(params['msg'])
    specimenHash = msgHash['specimen_shipped']
    p specimenHash
    if !params['shipped_date'].nil?
      @shippedDate = Helper_Methods.getDateAsRequired(params['shipped_date'])
      specimenHash['shipped_date'] = @shippedDate
    end

    return msgHash.to_json
  end

  def Patient_helper_methods.create_new_specimen_shipped_message(psn,type,surgical_id,molecular_id,datePreference)
    dateCreated = Helper_Methods.getDateAsRequired(datePreference)

    header_hash = {"msg_guid"=>"0f8fad5b-d9cb-469f-al65-80067728950e",
                   "msg_dttm"=>dateCreated
    }

    internal_use_Hash = {"stars_patient_id"=>psn,
                         "stars_specimen_id_dna"=>surgical_id
    }

    if type == 'BLOOD_DNA'
      specimen_hash={"study_id"=>'APEC1621',
                     "patient_id"=> psn,
                     "type"=>type,
                     "surgical_event_id"=>surgical_id,
                     "molecular_id"=>molecular_id,
                     "molecular_dna_id"=>molecular_id+'D',
                     "shipped_date"=>dateCreated,
                     "carrier"=> "Federal Express",
                     "tracking_id"=> "7956 4568 1235",
                     "internal_use_only"=>internal_use_Hash
      }
    elsif type == 'TISSUE_DNA_AND_CDNA'
      specimen_hash={"study_id"=>'APEC1621',
                     "patient_id"=> psn,
                     "type"=>type,
                     "surgical_event_id"=>surgical_id,
                     "molecular_id"=>molecular_id,
                     "molecular_dna_id"=>molecular_id+'D',
                     "molecular_cdna_id"=>molecular_id+'C',
                     "shipped_date"=>dateCreated,
                     "carrier"=> "Federal Express",
                     "tracking_id"=> "7956 4568 1235",
                     "internal_use_only"=>internal_use_Hash
      }
    elsif type == 'SLIDE'
      specimen_hash={"study_id"=>'APEC1621',
                     "patient_id"=> psn,
                     "type"=>type,
                     "surgical_event_id"=>surgical_id,
                     "shipped_date"=>dateCreated,
                     "carrier"=> "Federal Express",
                     "tracking_id"=> "7956 4568 1235",
                     "internal_use_only"=>internal_use_Hash
      }
    end

    specimen_shipped_hash ={"header"=>header_hash,
                            "specimen_received"=>specimen_hash
    }
    return specimen_shipped_hash.to_json
  end


end


