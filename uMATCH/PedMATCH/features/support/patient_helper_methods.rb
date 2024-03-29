require 'json'
require 'rest-client'
# require_relative 'env'
require_relative 'helper_methods.rb'

class Patient_helper_methods

  def self.createPatientTriggerRequestJSON (studyId, psn, stepNumber, status, comment, isDateCreated)
    dateCreated = Helper_Methods.getDateAsRequired(isDateCreated)

    headerHash = {"msg_guid" => "0f8fad5b-d9cb-469f-al65-80067728950e",
                  "msg_dttm" => dateCreated}

    internaUseHash = {"request_id" => "4-654321",
                      "environment" => "4",
                      "request" => "new pateint registration"}

    patientTrigger = {"header" => headerHash,
                      "study_id" => studyId,
                      "patient_id" => psn,
                      "step_number" => stepNumber,
                      "status_date" => dateCreated,
                      "status" => status,
                      # "message" => comment,
                      # "rebiopsy"=>'',
                      "internal_use_only" => internaUseHash
    }

    # tempPatientTrigger = {"Cog"=>actualpatientTrigger}
    return patientTrigger.to_json

  end

  def self.createSpecimenRequest(params={})
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
    # srHash = {"specimen_received"=>msgHash}
    # return srHash.to_json
    p msgHash
    return msgHash.to_json
  end

  def self.create_new_specimen_received_message(psn, type, datePreference)
    dateCreated = Helper_Methods.getDateAsRequired(datePreference)
    p dateCreated
    header_hash = {"msg_guid" => "0f8fad5b-d9cb-469f-al65-80067728950e",
                   "msg_dttm" => dateCreated
    }

    internal_use_Hash = {"stars_patient_id" => psn,
                         "stars_specimen_id" => "bsn"+"-"+psn,
                         "stars_specimen_type" => type,
                         "received_ts" => dateCreated,
                         "qc_ts" => dateCreated
    }

    specimen_hash={"study_id" => 'APEC1621SC',
                   "patient_id" => psn,
                   "type" => type,
                   "surgical_event_id" => "bsn"+"-"+psn,
                   "collected_date" => dateCreated,
                   "received_date" => dateCreated,
                   "internal_use_only" => internal_use_Hash
    }

    specimen_received_hash ={"header" => header_hash,
                             "specimen_received" => specimen_hash
    }

    return specimen_received_hash.to_json
    # srHash = {"specimen_received"=>specimen_received_hash}
    # return srHash.to_json
  end

  def self.create_assay_order_message(params={})
    msgHash = JSON.parse(params['msg'])
    if !params['ordered_date'].nil?
      @reportedDate = Helper_Methods.getDateAsRequired(params['ordered_date'])
      msgHash['ordered_date'] = @reportedDate
    end
    return msgHash.to_json
  end

  def self.create_assay_result_message(params={})
    msgHash = JSON.parse(params['msg'])
    if !params['reported_date'].nil?
      @reportedDate = Helper_Methods.getDateAsRequired(params['reported_date'])
      msgHash['reported_date'] = @reportedDate
    end
    return msgHash.to_json
  end

  def self.createSpecimenShippedMessageRequest(params={})
    msgHash = JSON.parse(params['msg'])
    specimenHash = msgHash['specimen_shipped']
    p specimenHash
    if !params['shipped_date'].nil?
      @shippedDate = Helper_Methods.getDateAsRequired(params['shipped_date'])
      specimenHash['shipped_date'] = @shippedDate
    end

    return msgHash.to_json
  end

  def self.create_new_specimen_shipped_message(psn, type, surgical_id, molecular_id, datePreference)
    dateCreated = Helper_Methods.getDateAsRequired(datePreference)

    header_hash = {"msg_guid" => "0f8fad5b-d9cb-469f-al65-80067728950e",
                   "msg_dttm" => dateCreated
    }

    internal_use_Hash = {"stars_patient_id" => psn,
                         "stars_specimen_id_dna" => surgical_id
    }

    if type == 'BLOOD_DNA'
      specimen_hash={"study_id" => 'APEC1621SC',
                     "patient_id" => psn,
                     "type" => type,
                     "surgical_event_id" => surgical_id,
                     "molecular_id" => molecular_id,
                     "shipped_date" => dateCreated,
                     "carrier" => "Federal Express",
                     "tracking_id" => "7956 4568 1235",
                     "internal_use_only" => internal_use_Hash
      }
    elsif type == 'TISSUE_DNA_AND_CDNA'
      specimen_hash={"study_id" => 'APEC1621SC',
                     "patient_id" => psn,
                     "type" => type,
                     "surgical_event_id" => surgical_id,
                     "molecular_id" => molecular_id,
                     "shipped_date" => dateCreated,
                     "carrier" => "Federal Express",
                     "tracking_id" => "7956 4568 1235",
                     "internal_use_only" => internal_use_Hash
      }
    elsif type == 'SLIDE'
      specimen_hash={"study_id" => 'APEC1621SC',
                     "patient_id" => psn,
                     "type" => type,
                     "surgical_event_id" => surgical_id,
                     "shipped_date" => dateCreated,
                     "carrier" => "Federal Express",
                     "tracking_id" => "7956 4568 1235",
                     "internal_use_only" => internal_use_Hash
      }
    end

    specimen_shipped_hash ={"header" => header_hash,
                            "specimen_received" => specimen_hash
    }
    return specimen_shipped_hash.to_json
  end


  ########   setup    #######


  ######## messages   #######
  def self.load_patient_message_templates(type)
    location = "#{File.dirname(__FILE__)}/../../public/patient_message_templates.json"
    whole_json = JSON(IO.read(location))
    # whole_json = JSON(IO.read('./public/patient_message_templates.json'))
    whole_json[type]
  end

  def self.update_patient_message(key, value)
    if @patient_message_root_key == ''
      @request_hash[key] = value
    else
      @request_hash[@patient_message_root_key][key] = value
    end
  end

  def self.update_vr_event_message(key, value)
    @request_hash[key] = value
    @request_hash['event'][key] = value
  end

  def self.remove_field_patient_message(key)
    if @patient_message_root_key == ''
      @request_hash.delete(key)
    else
      @request_hash[@patient_message_root_key].delete(key)
    end
  end

  def self.load_template(pt_id, type)
    @patient_id = pt_id
    @request_hash = load_patient_message_templates(type)
    if type.start_with?('specimen_received')
      @patient_message_root_key = 'specimen_received'
    elsif type.start_with?('specimen_shipped')
      @patient_message_root_key = 'specimen_shipped'
    else
      @patient_message_root_key = ''
    end
    update_patient_message('patient_id', @patient_id)
  end

  def self.prepare_register(pt_id, reg_date='default')
    @patient_id = pt_id
    @request_hash = load_patient_message_templates('registration')
    @request_hash['patient_id'] = @patient_id
    unless reg_date == 'default'
      @request_hash['status_date'] = reg_date
    end
    @patient_message_root_key = ''
  end

  def self.prepare_specimen_received(pt_id, type, sei, collect_date='default')
    @patient_id = pt_id
    @request_hash = load_patient_message_templates("specimen_received_#{type}")
    @request_hash['specimen_received']['patient_id'] = @patient_id
    if type == 'TISSUE'
      @request_hash['specimen_received']['surgical_event_id'] = sei
    end
    unless collect_date == 'default'
      @request_hash['specimen_received']['collection_dt'] = collect_date
    end
    @patient_message_root_key = 'specimen_received'
  end

  def self.prepare_specimen_shipped(pt_id, type, sei, moi_or_bc, site='default', ship_date='default')
    @patient_id = pt_id
    @request_hash = load_patient_message_templates("specimen_shipped_#{type}")
    @request_hash['specimen_shipped']['patient_id'] = @patient_id
    unless site == 'default'
      @request_hash['specimen_shipped']['destination'] = site
    end
    unless ship_date == 'default'
      @request_hash['specimen_shipped']['shipped_dttm'] = ship_date
    end

    case type
      when 'TISSUE'
        @request_hash['specimen_shipped']['surgical_event_id'] = sei
        @request_hash['specimen_shipped']['molecular_id'] = moi_or_bc
      when 'SLIDE'
        @request_hash['specimen_shipped']['surgical_event_id'] = sei
        @request_hash['specimen_shipped']['slide_barcode'] = moi_or_bc
      when 'BLOOD'
        @request_hash['specimen_shipped']['molecular_id'] = moi_or_bc
    end
    @patient_message_root_key = 'specimen_shipped'
  end

  def self.prepare_assay(pt_id, sei, biomarker='default', result='default', order_date='default', report_date='default')
    @patient_id = pt_id
    @request_hash = load_patient_message_templates('assay_result_reported')
    @request_hash['patient_id'] = @patient_id
    @request_hash['surgical_event_id'] = sei
    unless biomarker=='default'
      @request_hash['biomarker'] = biomarker
    end
    unless order_date=='default'
      @request_hash['ordered_date'] = order_date
    end
    unless report_date=='default'
      @request_hash['reported_date'] = report_date
    end
    unless result=='default'
      @request_hash['result'] = result
    end
    @request_hash['case_number'] = "assay_#{sei}_#{@request_hash['ordered_date']}"
    @patient_message_root_key = ''
  end

  def self.prepare_pathology(pt_id, sei, status='default', report_date='default')
    @patient_id=pt_id
    @request_hash = load_patient_message_templates('pathology_status')
    @request_hash['patient_id'] = @patient_id
    @request_hash['surgical_event_id'] = sei
    unless report_date=='default'
      @request_hash['reported_date'] = report_date
    end
    unless status=='default'
      @request_hash['status'] = status
    end
    @request_hash['case_number'] = "pathology_#{sei}_#{@request_hash['reported_date']}"
    @patient_message_root_key = ''
  end

  def self.upload_vr_to_s3(moi, ani, template='default', tsv_name='test1.tsv')
    Helper_Methods.upload_vr_to_s3('pedmatch-dev', 'bdd_test_ion_reporter', moi, ani, tsv_name.gsub('.tsv', ''), template)
    Helper_Methods.upload_vr_to_s3('pedmatch-int', 'bdd_test_ion_reporter', moi, ani, tsv_name.gsub('.tsv', ''), template)
  end

  def self.prepare_vr_upload(pt_id, moi, ani, need_upload, site='default')
    @patient_id = pt_id
    if need_upload
      Helper_Methods.upload_vr_to_s3('pedmatch-dev', 'bdd_test_ion_reporter', moi, ani)
      Helper_Methods.upload_vr_to_s3('pedmatch-int', 'bdd_test_ion_reporter', moi, ani)
    end
    @request_hash = Patient_helper_methods.load_patient_message_templates('variant_file_uploaded')
    unless site=='default'
      @request_hash['ion_reporter_id'] = site
    end
    @request_hash['molecular_id'] = moi
    @request_hash['analysis_id'] = ani
    @patient_message_root_key = ''
  end

  def self.prepare_variant_confirm(comment='default comment', user='default user')
    @request_hash = load_patient_message_templates('variant_confirmed')
    @request_hash['comment']=comment
    @request_hash['comment_user']=user
    @patient_message_root_key = ''
  end

  def self.prepare_vr_confirm(pt_id, comment='default comment', user='default user')
    @patient_id = pt_id
    @request_hash = load_patient_message_templates('variant_file_confirmed')
    @request_hash['comment']=comment
    @request_hash['comment_user']=user
    @patient_message_root_key = ''
  end

  def self.prepare_assignment_confirm(pt_id, comment='default comment', user='default user')
    @patient_id = pt_id
    @request_hash = load_patient_message_templates('assignment_confirmed')
    @request_hash['comment']=comment
    @request_hash['comment_user']=user
    @patient_message_root_key = ''
  end

  def self.prepare_off_study(pt_id, step_number, date='default')
    @patient_id = pt_id
    @request_hash = load_patient_message_templates('off_study')
    @request_hash['patient_id'] = @patient_id
    @request_hash['status'] = 'OFF_STUDY'
    @request_hash['step_number'] = step_number
    unless date=='default'
      @request_hash['status_date'] = date
    end
    @patient_message_root_key = ''
  end

  def self.prepare_off_study_biopsy_expired(pt_id, step_number, date='default')
    @patient_id = pt_id
    @request_hash = load_patient_message_templates('off_study')
    @request_hash['patient_id'] = @patient_id
    @request_hash['status'] = 'OFF_STUDY_BIOPSY_EXPIRED'
    @request_hash['step_number'] = step_number
    unless date=='default'
      @request_hash['status_date'] = date
    end
    @patient_message_root_key = ''
  end

  def self.prepare_request_assignment(pt_id, rebiopsy, step_number, date='default')
    @patient_id = pt_id
    @request_hash = load_patient_message_templates('request_assignment')
    @request_hash['patient_id'] = @patient_id
    @request_hash['status'] = 'REQUEST_ASSIGNMENT'
    @request_hash['step_number'] = step_number
    @request_hash['rebiopsy'] = rebiopsy
    unless date=='default'
      @request_hash['status_date'] = date
    end
    @patient_message_root_key = ''
  end

  def self.prepare_request_no_assignment(pt_id, step_number, date='default')
    @patient_id = pt_id
    @request_hash = load_patient_message_templates('request_assignment')
    @request_hash['patient_id'] = @patient_id
    @request_hash['status'] = 'REQUEST_NO_ASSIGNMENT'
    @request_hash['step_number'] = step_number
    @request_hash['rebiopsy'] = ''
    unless date=='default'
      @request_hash['status_date'] = date
    end
    @patient_message_root_key = ''
  end

  def self.prepare_on_treatment_arm(pt_id, ta_id, stratum, step_number, date='default')
    @patient_id = pt_id
    @request_hash = load_patient_message_templates('on_treatment_arm')
    @request_hash['patient_id'] = @patient_id
    @request_hash['step_number'] = step_number
    @request_hash['treatment_arm_id'] = ta_id
    @request_hash['stratum_id'] = stratum
    unless date=='default'
      @request_hash['status_date'] = date
    end
    @patient_message_root_key = ''
  end

  ######## services #####
  def self.get_response_and_code(url, auth0_role)
    Helper_Methods.simple_get_request(url, true, auth0_role)
  end

  def self.get_any_result_from_url(url)
    return Helper_Methods.simple_get_request(url)['message_json']
  end

  def self.get_updated_result_from_url(url, timeout)
    internal_timeout = 30.0
    run_time = 0.0
    wait_time = 5.0
    old_response = nil
    loop do
      new_response = Helper_Methods.simple_get_request(url)['message_json']
      if old_response.nil?
        old_response = new_response
      end

      if old_response != new_response || run_time>internal_timeout.to_f
        # if old_response != new_response || run_time>timeout.to_f
        if new_response.length>1
          return new_response
        elsif new_response.length==1
          return new_response[0]
        else
          return {}
        end
      end

      sleep(wait_time)
      run_time += wait_time
    end

  end

  def self.post_to_trigger(auth0_role)
    puts JSON.pretty_generate(@request_hash) if ENV['print_log'] == 'YES'
    url = "#{ENV['patients_endpoint']}/#{@patient_id}"
    Helper_Methods.post_request(url, @request_hash.to_json.to_s, true, auth0_role)
  end

  def self.post_vr_upload_event(auth0_role)
    puts JSON.pretty_generate(@request_hash) if ENV['print_log'] == 'YES'
    url = "#{ENV['patients_endpoint']}/events"
    Helper_Methods.post_request(url, @request_hash.to_json.to_s, true, auth0_role)
  end

  def self.post_vr_upload(moi, auth0_role)
    puts JSON.pretty_generate(@request_hash) if ENV['print_log'] == 'YES'
    url = "#{ENV['patients_endpoint']}/variant_report/#{moi}"
    Helper_Methods.post_request(url, @request_hash.to_json.to_s, true, auth0_role)
  end

  def self.put_variant_confirm(uuid, status, auth0_role)
    puts JSON.pretty_generate(@request_hash) if ENV['print_log'] == 'YES'
    url = "#{ENV['patients_endpoint']}/variant/#{uuid}/#{status}"
    Helper_Methods.put_request(url, @request_hash.to_json.to_s, true, auth0_role)
  end

  def self.put_vr_confirm(ani, status, auth0_role)
    puts JSON.pretty_generate(@request_hash) if ENV['print_log'] == 'YES'
    url = "#{ENV['patients_endpoint']}/#{@patient_id}/variant_reports/#{ani}/#{status}"
    Helper_Methods.put_request(url, @request_hash.to_json.to_s, true, auth0_role)
  end

  def self.put_ar_confirm(ani, status, auth0_role)
    puts JSON.pretty_generate(@request_hash) if ENV['print_log'] == 'YES'
    url = "#{ENV['patients_endpoint']}/#{@patient_id}/assignment_reports/#{ani}/#{status}"
    Helper_Methods.put_request(url, @request_hash.to_json.to_s, true, auth0_role)
  end

  def self.put_rollback(patient_id, step_number, auth0_role)
    @patient_id   = patient_id
    @request_hash = { 'step_number' => step_number, 'patient_id' => patient_id }
    url = "#{ENV['patients_endpoint']}/#{@patient_id}/rollback"
    Helper_Methods.put_request(url, @request_hash.to_json.to_s, true, auth0_role)
  end

  def self.wait_until_patient_updated(patient_id)
    timeout = 30.0
    url = "#{ENV['patients_endpoint']}/#{patient_id}"
    Helper_Methods.wait_until_updated(url, timeout)
  end

  def self.wait_until_specimen_updated(patient_id)
    timeout = 30.0
    url = "#{ENV['patients_endpoint']}/#{patient_id}/specimens"
    Helper_Methods.wait_until_updated(url, timeout)
  end

  def self.wait_until_vr_updated(patient_id)
    timeout = 30.0
    url = "#{ENV['patients_endpoint']}/variant_reports?patient_id=#{patient_id}"
    Helper_Methods.wait_until_updated(url, timeout)
  end

  def self.wait_until_event_updated(patient_id)
    timeout = 30.0
    url = "#{ENV['patients_endpoint']}/events?entity_id=#{patient_id}"
    Helper_Methods.wait_until_updated(url, timeout)
  end

  def self.wait_until_variant_updated(patient_id)
    timeout = 30.0
    url = "#{ENV['patients_endpoint']}/variants?patient_id=#{patient_id}"
    Helper_Methods.wait_until_updated(url, timeout)
  end

  def self.wait_until_patient_field_is(patient_id, field, value)
    url = "#{ENV['patients_endpoint']}/#{patient_id}"
    Helper_Methods.get_special_result_from_url(url, 45, { field => value })
  end

  def self.ui_title_find_variant_value(title, variant_hash)
    return unless title.present?
    result = case title
               when 'Confirm' then
                 variant_hash['confirmed'].to_s.downcase
               when 'ID' then
                 variant_hash['identifier']
               when 'OCP Ref' then
                 variant_hash['ocp_reference']
               when 'OCP Alt' then
                 variant_hash['ocp_alternative']
               when 'Allele Freq' then
                 variant_hash['allele_frequency']
               when 'Raw CN' then
                 variant_hash['raw_copy_number']
               when 'CI 5%' then
                 variant_hash['confidence_interval_5_percent']
               when 'CN' then
                 variant_hash['copy_number']
               when 'CI 95%' then
                 variant_hash['confidence_interval_95_percent']
               when 'Gene1' then
                 variant_hash['partner_gene']
               when 'Gene2' then
                 variant_hash['driver_gene']
               when 'Read Depth' then
                 variant_hash['read_depth'].nil? ? variant_hash['driver_read_count'] : variant_hash['read_depth']
               else
                 variant_hash[title.downcase.gsub(' ', '_')]
             end
    result = '-' if result.nil?
    result
  end
end
