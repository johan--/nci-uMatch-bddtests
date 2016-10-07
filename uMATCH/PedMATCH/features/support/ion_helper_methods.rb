require 'json'
require 'rest-client'
require_relative 'helper_methods.rb'

class ION_helper_methods
  ########   setup    #######


  ######## messages   #######
  # def self.load_patient_message_templates(type)
  #   location = "#{File.dirname(__FILE__)}/../../public/patient_message_templates.json"
  #   whole_json = JSON(IO.read(location))
  #   # whole_json = JSON(IO.read('./public/patient_message_templates.json'))
  #   whole_json[type]
  # end
  #
  # def self.update_patient_message(key, value)
  #   if @patient_message_root_key == ''
  #     @request_hash[key] = value
  #   else
  #     @request_hash[@patient_message_root_key][key] = value
  #   end
  # end
  #
  # def self.remove_field_patient_message(key)
  #   if @patient_message_root_key == ''
  #     @request_hash.delete(key)
  #   else
  #     @request_hash[@patient_message_root_key].delete(key)
  #   end
  # end
  #
  # def self.prepare_register(pt_id, reg_date='default')
  #   @patient_id = pt_id
  #   @request_hash = load_patient_message_templates('registration')
  #   @request_hash['patient_id'] = @patient_id
  #   unless reg_date == 'default'
  #     @request_hash['status_date'] = reg_date
  #   end
  #   @patient_message_root_key = ''
  # end
  #
  # def self.prepare_specimen_received(pt_id, type, sei, collect_date='default')
  #   @patient_id = pt_id
  #   @request_hash = load_patient_message_templates("specimen_received_#{type}")
  #   @request_hash['specimen_received']['patient_id'] = @patient_id
  #   if type == 'TISSUE'
  #     @request_hash['specimen_received']['surgical_event_id'] = sei
  #   end
  #   unless collect_date == 'default'
  #     @request_hash['specimen_received']['collected_dttm'] = collect_date
  #   end
  #   @patient_message_root_key = 'specimen_received'
  # end
  #
  # def self.prepare_specimen_shipped(pt_id, type, sei, moi_or_bc, site='default', ship_date='default')
  #   @patient_id = pt_id
  #   @request_hash = load_patient_message_templates("specimen_shipped_#{type}")
  #   @request_hash['specimen_shipped']['patient_id'] = @patient_id
  #   unless site == 'default'
  #     @request_hash['specimen_shipped']['destination'] = site
  #   end
  #   unless ship_date == 'default'
  #     @request_hash['specimen_shipped']['shipped_dttm'] = ship_date
  #   end
  #
  #   case type
  #     when 'TISSUE'
  #       @request_hash['specimen_shipped']['surgical_event_id'] = sei
  #       @request_hash['specimen_shipped']['molecular_id'] = moi_or_bc
  #       @request_hash['specimen_shipped']['molecular_dna_id'] = moi_or_bc+'D'
  #       @request_hash['specimen_shipped']['molecular_cdna_id'] = moi_or_bc+'C'
  #     when 'SLIDE'
  #       @request_hash['specimen_shipped']['surgical_event_id'] = sei
  #       @request_hash['specimen_shipped']['slide_barcode'] = moi_or_bc
  #     when 'BLOOD'
  #       @request_hash['specimen_shipped']['molecular_id'] = moi_or_bc
  #       @request_hash['specimen_shipped']['molecular_dna_id'] = moi_or_bc+'D'
  #       @request_hash['specimen_shipped']['molecular_cdna_id'] = moi_or_bc+'C'
  #   end
  #   @patient_message_root_key = 'specimen_shipped'
  # end
  #
  # def self.prepare_assay(pt_id, sei, biomarker='default', result='default', order_date='default', report_date='default')
  #   @patient_id = pt_id
  #   @request_hash = load_patient_message_templates('assay_result_reported')
  #   @request_hash['patient_id'] = @patient_id
  #   @request_hash['surgical_event_id'] = sei
  #   unless biomarker=='default'
  #     @request_hash['biomarker'] = biomarker
  #   end
  #   unless order_date=='default'
  #     @request_hash['ordered_date'] = order_date
  #   end
  #   unless report_date=='default'
  #     @request_hash['reported_date'] = report_date
  #   end
  #   unless result=='default'
  #     @request_hash['result'] = result
  #   end
  #   @request_hash['case_number'] = "assay_#{sei}_#{@request_hash['ordered_date']}"
  #   @patient_message_root_key = ''
  # end
  #
  # def self.prepare_pathology(pt_id, sei, status='default', report_date='default')
  #   @patient_id=pt_id
  #   @request_hash = load_patient_message_templates('pathology_status')
  #   @request_hash['patient_id'] = @patient_id
  #   @request_hash['surgical_event_id'] = sei
  #   unless report_date=='default'
  #     @request_hash['reported_date'] = report_date
  #   end
  #   unless status=='default'
  #     @request_hash['status'] = status
  #   end
  #   @request_hash['case_number'] = "pathology_#{sei}_#{@request_hash['reported_date']}"
  #   @patient_message_root_key = ''
  # end
  #
  # def self.prepare_vr_upload(pt_id, moi, ani, site='default')
  #   @patient_id = pt_id
  #   @request_hash = Patient_helper_methods.load_patient_message_templates('variant_file_uploaded')
  #   unless site=='default'
  #     @request_hash['ion_reporter_id'] = site
  #   end
  #   @request_hash['molecular_id'] = moi
  #   @request_hash['analysis_id'] = ani
  #   @patient_message_root_key = ''
  # end
  #
  # def self.prepare_variant_confirm(comment='default comment', user='default user')
  #   @request_hash = load_patient_message_templates('variant_confirmed')
  #   @request_hash['comment']=comment
  #   @request_hash['comment_user']=user
  #   @patient_message_root_key = ''
  # end
  #
  # def self.prepare_vr_confirm(pt_id, comment='default comment', user='default user')
  #   @patient_id = pt_id
  #   @request_hash = load_patient_message_templates('variant_file_confirmed')
  #   @request_hash['comment']=comment
  #   @request_hash['comment_user']=user
  #   @patient_message_root_key = ''
  # end
  #
  # def self.prepare_assignment_confirm(pt_id, comment='default comment', user='default user')
  #   @patient_id = pt_id
  #   @request_hash = load_patient_message_templates('assignment_confirmed')
  #   @request_hash['comment']=comment
  #   @request_hash['comment_user']=user
  #   @patient_message_root_key = ''
  # end
  #
  # def self.prepare_off_study(pt_id, step_number, date='default')
  #   @patient_id = pt_id
  #   @request_hash = load_patient_message_templates('off_study')
  #   @request_hash['patient_id'] = @patient_id
  #   @request_hash['status'] = 'OFF_STUDY'
  #   @request_hash['step_number'] = step_number
  #   unless date=='default'
  #     @request_hash['status_date'] = date
  #   end
  # end

  ######## services #####

  def self.get_any_result_from_url(url)
    return Helper_Methods.simple_get_request(url)
  end

  def self.get_special_result_from_url(url, timeout, query_hash, path=[])
    run_time = 0.0
    loop do
      response = Helper_Methods.simple_get_request(url)
      if response.length==1
        target_object = response[0]
        path.each do |path_key|
          target_object = target_object[path_key]
        end
        is_this = true
        query_hash.each do |key, value|
          is_this = is_this && target_object[key.to_s]==value.to_s
        end
        if is_this
          return target_object
        end
      end

      if run_time>timeout.to_f
        if response.length>1
          return response
        elsif response.length==1
          return response[0]
        else
          return {}
        end
      end
      sleep(0.5)
      run_time += 0.5
    end
  end

  def self.get_updated_result_from_url(url, timeout)
    run_time = 0.0
    old_response = nil
    loop do
      new_response = Helper_Methods.simple_get_request(url)
      if old_response.nil?
        old_response = new_response
      end

      if old_response != new_response || run_time>timeout.to_f
        if new_response.length>1
          return new_response
        elsif new_response.length==1
          return new_response[0]
        else
          return {}
        end
      end

      sleep(0.5)
      run_time += 0.5
    end

  end
  
  def self.create_ion_reporters(site, message, expected_status, expected_partial_message)
    url = "#{ENV['ion_system_endpoint']}/ion_reporters?site=#{site}"
    response = Helper_Methods.post_request(url, message.to_json.to_s)
    validate_response(response, expected_status, expected_partial_message)
    JSON.parse(response['message'])['ion_reporter_id']
  end

  def self.put_variant_confirm(uuid, status, expected_status, expected_partial_message)
    puts JSON.pretty_generate(@request_hash)
    url = "#{ENV['patients_endpoint']}/variant/#{uuid}/#{status}"
    response = Helper_Methods.put_request(url, @request_hash.to_json.to_s)
    validate_response(response, expected_status, expected_partial_message)
    response
  end

  def self.put_vr_confirm(ani, status, expected_status, expected_partial_message)
    puts JSON.pretty_generate(@request_hash)
    url = "#{ENV['patients_endpoint']}/#{@patient_id}/variant_reports/#{ani}/#{status}"
    response = Helper_Methods.put_request(url, @request_hash.to_json.to_s)
    validate_response(response, expected_status, expected_partial_message)
    response
  end

  def self.put_ar_confirm(ani, status, expected_status, expected_partial_message)
    puts JSON.pretty_generate(@request_hash)
    url = "#{ENV['patients_endpoint']}/#{@patient_id}/assignment_reports/#{ani}/#{status}"
    response = Helper_Methods.put_request(url, @request_hash.to_json.to_s)
    validate_response(response, expected_status, expected_partial_message)
    response
  end

  def self.validate_response(response, expected_status, expected_partial_message)
    response['status'].downcase.should == expected_status.downcase
    expect_message = "returned message include <#{expected_partial_message}>"
    actual_message = response['message']
    if response['message'].downcase.include?expected_partial_message.downcase
      actual_message = expect_message
    end
    actual_message.should == expect_message
  end

  def self.wait_until_patient_updated(patient_id)
    timeout = 15.0
    total_time = 0.0
    old_status = ''
    loop do
      output_hash = Helper_Methods.simple_get_request("#{ENV['patients_endpoint']}/#{patient_id}")
      if output_hash.length == 1
        new_status = output_hash[0]['current_status']
        if old_status == ''
          old_status = new_status
        end
        unless new_status==old_status
          return
        end
      end
      total_time += 0.5
      if total_time>timeout
        return
      end
      sleep(0.5)
    end
  end

end


