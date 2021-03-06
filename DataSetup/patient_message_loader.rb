require 'json'
require_relative '../uMATCH/PedMATCH/features/support/environment'
require_relative '../uMATCH/PedMATCH/features/support/helper_methods'

class PatientMessageLoader

  LOCAL_PATIENT_DATA_FOLDER = 'local_patient_data'
  LOCAL_PATIENT_API_URL = 'http://localhost:10240/api/v1/patients'
  LOCAL_IR_API_URL = 'http://localhost:5000/api/v1'
  LOCAL_COG_URL = 'http://localhost:3000'
  SERVICE_NAME = 'trigger'
  MESSAGE_TEMPLATE_FILE = "#{File.dirname(__FILE__)}/../uMATCH/PedMATCH/public/patient_message_templates.json"

  def self.set_patient_api_url(url='http://localhost:10240/api/v1/patients')
    @patient_api_url = url
  end

  def self.set_cog_url(url='http://localhost:3000')
    @cog_url = url
  end

  def self.patient_api_url
    @patient_api_url||=LOCAL_PATIENT_API_URL
  end

  def self.ir_api_url
    @ir_api_url||=LOCAL_IR_API_URL
  end

  def self.cog_url
    @cog_url||=LOCAL_COG_URL
  end

  def self.load_patient_message(file_name, patient_id)
    message_list = JSON(IO.read(file_name))[patient_id]
    raise "Patient #{patient_id} doesn't exist in file #{file_name}" if message_list.nil?
    message_list.each { |this_row|
      parts = this_row.split(':')
      func = parts[0]
      params = [patient_id]
      if parts.size > 1
        parts[1].split(',').each { |this_param|
          params << this_param.gsub('pt.id', patient_id)
        }
      end
      PatientMessageLoader.send(func, *params)
    }
  end

  def self.upload_start_with_wait_time(time)
    @wait_time = time
    @all_items = 0
    @failure = 0
    @failed_patient_list = []
  end

  def self.is_upload_failed?
    @failure > 0
  end

  def self.upload_done
    pass = @all_items - @failure
    p "#{@all_items} messages processed, #{pass} passed and #{@failure} failed"
    puts "Failed patients are: #{@failed_patient_list.to_s}"
  end

  def self.load_patient_to_local(message_file, patient_id, wait_time)
    raise 'patient_id must be valid' if message_file.nil? || message_file.length == 0
    file = File.read("#{LOCAL_PATIENT_DATA_FOLDER}/#{message_file}.json")

    message_list = JSON.parse(file)
    p "There are #{message_list.length} json messages in patient json file. Processing..."

    all_items = 0
    failure = 0
    message_list.each do |message|
      all_items += 1
      if message.key?('sleep')
        p "Sleep for #{message['sleep']} seconds"
        sleep(message['sleep'].to_f)
      else

        curl_cmd ="curl -k -X POST -H \"Content-Type: application/json\""
        curl_cmd = curl_cmd + " -H \"Accept: application/json\"  -d '" + message.to_json
        curl_cmd = curl_cmd + "' #{patient_api_url}/#{patient_id}"
        output = `#{curl_cmd}`
        p "Output from running No.#{all_items} curl: #{output}"
        unless output.downcase.include? 'success'
          p 'Failed'
          puts JSON.pretty_generate(message)
          failure += 1
        end
        sleep(wait_time)
      end
    end

    pass = all_items - failure
    p ''
    p "#{all_items} messages processed, #{pass} passed and #{failure} failed"
  end

  def self.wait_until_patient_status_is(patient_id, status)
    timeout = 30.0
    total_time = 0.0
    url = "#{patient_api_url}/#{patient_id}"
    loop do
      new_hash = Helper_Methods.simple_get_request(url)['message_json']
      total_time += 0.5
      if new_hash['current_status'] == status || total_time > timeout
        return
      end
      sleep(0.5)
    end
    sleep (1.0)
  end

  def self.wait_until_updated(patient_id, table)
    timeout = 30.0
    total_time = 0.0
    old_hash = nil
    url = "#{patient_api_url}/#{patient_id}"
    if table.size>1
      url += "/#{table}"
    end
    loop do
      new_hash = Helper_Methods.simple_get_request(url)['message_json']
      if old_hash.nil?
        old_hash = new_hash
      end
      total_time += 0.5
      if new_hash != old_hash || total_time > timeout
        return
      end
      sleep(0.5)
    end
    sleep (1.0)
  end

  def self.wait_until_patient_event_updated(patient_id)
    timeout = 30.0
    total_time = 0.0
    old_hash = nil
    url = "#{patient_api_url}/events?entity_id=#{patient_id}"
    loop do
      new_hash = Helper_Methods.simple_get_request(url)['message_json']
      if old_hash.nil?
        old_hash = new_hash
      end
      total_time += 0.5
      if new_hash != old_hash || total_time > timeout
        return
      end
      sleep(0.5)
    end
    sleep (1.0)
  end

  def self.send_message_to_local(message_json, patient_id, message = nil)
    if @all_items.nil?
      @all_items = 0
    end
    if @failure.nil?
      @failure = 0
    end
    @all_items += 1
    output = Helper_Methods.post_request("#{patient_api_url}/#{patient_id}", message_json.to_json)
    # curl_cmd ="curl -k -X POST -H \"Content-Type: application/json\""
    # curl_cmd = curl_cmd + " -H \"Accept: application/json\"  -d '" + message_json.to_json
    # curl_cmd = curl_cmd + "' #{patient_api_url}/#{patient_id}"
    # output = `#{curl_cmd}`
    p "Output from running No.#{@all_items} curl: #{output['message']}"
    p "#{message} completed"
    unless output['message'].downcase.include? 'success'
      p 'Failed'
      puts JSON.pretty_generate(message_json)
      @failure += 1
      @failed_patient_list=[] if @failed_patient_list.nil?
      @failed_patient_list << patient_id unless @failed_patient_list.include?(patient_id)
    end
    # sleep(@wait_time)
  end

  def self.put_aliquot(message_json, patient_id, moi, message = nil)
    if @all_items.nil?
      @all_items = 0
    end
    if @failure.nil?
      @failure = 0
    end
    @all_items += 1
    output = Helper_Methods.put_request("#{ir_api_url}/aliquot/#{moi}", message_json.to_json)
    p "Output from running No.#{@all_items} curl: #{output['message']}"
    p "#{message} completed"
    unless output['status'].downcase.include? 'success'
      p 'Failed'
      puts JSON.pretty_generate(message_json)
      @failure += 1
      @failed_patient_list=[] if @failed_patient_list.nil?
      @failed_patient_list << patient_id unless @failed_patient_list.include?(patient_id)
    end
    # sleep(@wait_time)
  end

  def self.post_patient_event(message_json, message = nil)
    if @all_items.nil?
      @all_items = 0
    end
    if @failure.nil?
      @failure = 0
    end
    @all_items += 1
    output = Helper_Methods.post_request("#{patient_api_url}/events", message_json.to_json)
    p "Output from running No.#{@all_items} curl: #{output['message']}"
    p "#{message} completed"
    unless output['message'].downcase.include? 'success'
      p 'Failed'
      puts JSON.pretty_generate(message_json)
      @failure += 1
      @failed_patient_list=[] if @failed_patient_list.nil?
      @failed_patient_list << patient_id unless @failed_patient_list.include?(patient_id)
    end

  end

  def self.put_message_to_local(service, message_json)
    if @all_items.nil?
      @all_items = 0
    end
    if @failure.nil?
      @failure = 0
    end
    @all_items += 1
    url = "#{patient_api_url}/#{service}"
    output = Helper_Methods.put_request(url, message_json.to_json)
    # curl_cmd ="curl -k -X PUT -H \"Content-Type: application/json\""
    # curl_cmd = curl_cmd + " -H \"Accept: application/json\"  -d '" + message_json.to_json
    # curl_cmd = curl_cmd + "' #{patient_api_url}#{service}"
    # output = `#{curl_cmd}`
    p "Output from running No.#{@all_items} curl: #{output['message']}"
    unless output['message'].downcase.include? 'success'
      p 'Failed'
      puts JSON.pretty_generate(message_json)
      @failure += 1
      @failed_patient_list=[] if @failed_patient_list.nil?
      @failed_patient_list << service unless @failed_patient_list.include?(service)
    end
    # sleep(@wait_time)
  end

  def self.send_message_to_local_cog(service, message_json)
    if @all_items.nil?
      @all_items = 0
    end
    if @failure.nil?
      @failure = 0
    end
    @all_items += 1
    url = "#{cog_url}/#{service}"
    output = Helper_Methods.post_request(url, message_json.to_json)
    # curl_cmd ="curl -k -X POST -H \"Content-Type: application/json\""
    # curl_cmd = curl_cmd + " -H \"Accept: application/json\"  -d '" + message_json.to_json
    # curl_cmd = curl_cmd + "' #{url}"
    # output = `#{curl_cmd}`
    sleep(1.0)
    p "Output from running No.#{@all_items} curl: #{output['message']}"
    unless output['message'].downcase.include? 'success'
      p 'Failed'
      unless message_json==''
        puts JSON.pretty_generate(message_json)
      end
      @failure += 1
      @failed_patient_list=[] if @failed_patient_list.nil?
      @failed_patient_list << message_json.to_json unless @failed_patient_list.include?(message_json.to_json)
    end
    # sleep(@wait_time)
  end

  def self.send_variant_report_confirm_message(message_json, patient_id, ani, status)
    if @all_items.nil?
      @all_items = 0
    end
    if @failure.nil?
      @failure = 0
    end
    @all_items += 1
    url = "#{patient_api_url}/#{patient_id}/variant_reports/#{ani}/#{status}"
    output = Helper_Methods.put_request(url, message_json.to_json)
    # curl_cmd ="curl -k -X PUT -H \"Content-Type: application/json\""
    # curl_cmd = curl_cmd + " -H \"Accept: application/json\"  -d '" + message_json.to_json
    # curl_cmd = curl_cmd + "' #{patient_api_url}/#{patient_id}/variant_reports/#{ani}/#{status}"
    # output = `#{curl_cmd}`
    p "Output from running No.#{@all_items} curl: #{output['message']}"
    unless output['message'].downcase.include? 'success'
      p 'Failed'
      puts JSON.pretty_generate(message_json)
      @failure += 1
      @failed_patient_list=[] if @failed_patient_list.nil?
      @failed_patient_list << patient_id unless @failed_patient_list.include?(patient_id)
    end
    # sleep(@wait_time)

  end

  def self.convert_date(date_string)
    case date_string
      when 'today' then
        Helper_Methods.dateYYYYMMDD
      when 'current' then
        Helper_Methods.dateDDMMYYYYHHMMSS
      when 'older' then
        Helper_Methods.backDate
      when 'future' then
        Helper_Methods.futureDate
      when 'older than 6 months' then
        Helper_Methods.olderThanSixMonthsDate
      when 'a few days older' then
        Helper_Methods.aFewDaysOlder
      else
        date_string
    end
  end

  def self.patient_exist(patient_id)
    url = "http://localhost:10240/api/v1/patients/#{patient_id}"
    response = Helper_Methods.simple_get_request(url)
    response['http_code'].start_with?('2')
  end

  def self.register_patient(patient_id, date='2016-02-09T22:06:33+00:00')
    message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['registration']
    message['patient_id'] = patient_id
    message['status_date'] = convert_date(date)
    send_message_to_local(message, patient_id, "Patient Registration")
    # wait_until_patient_status_is('')
    wait_until_updated(patient_id, '')
  end

  def self.specimen_received_tissue(
      patient_id,
          surgical_event_id,
          collect_time='2016-04-25')
    message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['specimen_received_TISSUE']
    message['specimen_received']['patient_id'] = patient_id
    message['specimen_received']['surgical_event_id'] = surgical_event_id
    message['specimen_received']['collection_dt'] = convert_date(collect_time)
    unless message['specimen_received']['collection_dt'].include?(':')
      message['specimen_received']['received_dttm'] = "#{convert_date(collect_time)}T05:06:33+00:00"
    end
    send_message_to_local(message, patient_id)
    wait_until_updated(patient_id, '')
  end

  def self.specimen_received_blood(
      patient_id,
          collect_time='2016-04-22')
    message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['specimen_received_BLOOD']
    message['specimen_received']['patient_id'] = patient_id
    message['specimen_received']['collection_dt'] = convert_date(collect_time)
    send_message_to_local(message, patient_id, "Blood Specimen Received")
    wait_until_updated(patient_id, 'specimens')
  end

  def self.specimen_shipped_tissue(
      patient_id,
          surgical_event_id,
          molecular_id,
          shipped_time='2016-05-01T19:42:13+00:00',
          destination='MDA'
  )
    message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['specimen_shipped_TISSUE']
    message['specimen_shipped']['patient_id'] = patient_id
    message['specimen_shipped']['surgical_event_id'] = surgical_event_id
    message['specimen_shipped']['molecular_id'] = molecular_id
    message['specimen_shipped']['shipped_dttm'] = convert_date(shipped_time)
    message['specimen_shipped']['destination'] = destination
    send_message_to_local(message, patient_id)
    wait_until_updated(patient_id, '')
  end

  def self.specimen_shipped_slide(
      patient_id,
          surgical_event_id,
          slide_barcode,
          shipped_time='2016-05-01T19:42:13+00:00')
    message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['specimen_shipped_SLIDE']
    message['specimen_shipped']['patient_id'] = patient_id
    message['specimen_shipped']['surgical_event_id'] = surgical_event_id
    message['specimen_shipped']['slide_barcode'] = slide_barcode
    message['specimen_shipped']['shipped_dttm'] = convert_date(shipped_time)
    send_message_to_local(message, patient_id)
    wait_until_updated(patient_id, '')
  end

  def self.specimen_shipped_blood(
      patient_id,
          molecular_id,
          shipped_time='2016-05-01T19:42:13+00:00',
          destination='MDA')
    message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['specimen_shipped_BLOOD']
    message['specimen_shipped']['patient_id'] = patient_id
    message['specimen_shipped']['molecular_id'] = molecular_id
    message['specimen_shipped']['shipped_dttm'] = convert_date(shipped_time)
    message['specimen_shipped']['destination'] = destination
    send_message_to_local(message, patient_id, "Blood Specimen Shipped")
    wait_until_updated(patient_id, 'specimen_events')
  end

  def self.assay(
      patient_id,
          surgical_event_id,
          result='POSITIVE',
          biomarker='ICCPTENs',
          reported_date='2016-05-30T12:11:09.071-05:00')
    message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['assay_result_reported']
    # message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['assay_old']
    message['patient_id'] = patient_id
    message['surgical_event_id'] = surgical_event_id
    message['biomarker'] = biomarker
    message['result'] = result
    message['reported_date'] = convert_date(reported_date)
    send_message_to_local(message, patient_id)
    wait_until_updated(patient_id, '')
  end

  def self.pathology(
      patient_id,
          surgical_event_id,
          status='Y',
          reported_date='2016-04-27T12:13:09.071-05:00')
    message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['pathology_status']
    # message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['pathology_old']
    message['patient_id'] = patient_id
    message['surgical_event_id'] = surgical_event_id
    message['status'] = status
    message['reported_date'] = convert_date(reported_date)
    send_message_to_local(message, patient_id)
    wait_until_updated(patient_id, '')
  end

  def self.variant_file_uploaded(
      patient_id,
          molecular_id,
          analysis_id,
          vr_type='default',
          folder='bdd_test_ion_reporter',
          vcf_name='test1.vcf')
    Helper_Methods.upload_vr_to_s3('pedmatch-dev', folder, molecular_id, analysis_id, vcf_name.gsub('.vcf', ''), vr_type)
    Helper_Methods.upload_vr_to_s3('pedmatch-int', folder, molecular_id, analysis_id, vcf_name.gsub('.vcf', ''), vr_type)
    message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['aliquot']
    message['ion_reporter_id'] = folder
    message['analysis_id'] = analysis_id
    message['vcf_name'] = vcf_name
    put_aliquot(message, patient_id, molecular_id, 'variant report upload')
    wait_until_updated(patient_id, 'variant_report')
    sleep(5) #variant upload might take more time than other service, so wait internally
  end

  def self.file_uploaded_cdna(
      patient_id,
          molecular_id,
          analysis_id,
          cdna_bam_name='cdna.bam',
          comment_user='qa'
  )
    message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['variant_cdna_file_uploaded']
    message['patient_id'] = patient_id
    message['molecular_id'] = molecular_id
    message['analysis_id'] = analysis_id
    message['cdna_bam_name'] = cdna_bam_name
    message['comment_user'] = comment_user
    post_patient_event(message, 'Upload CDNA file')
    wait_until_patient_event_updated(patient_id)
    sleep 5
  end

  def self.file_uploaded_dna(
      patient_id,
          molecular_id,
          analysis_id,
          dna_bam_name='dna.bam',
          comment_user='qa'
  )
    message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['variant_dna_file_uploaded']
    message['patient_id'] = patient_id
    message['molecular_id'] = molecular_id
    message['analysis_id'] = analysis_id
    message['dna_bam_name'] = dna_bam_name
    message['comment_user'] = comment_user
    post_patient_event(message, 'Upload DNA file')
    wait_until_patient_event_updated(patient_id)
    sleep 5
  end

  def self.copy_CNV_json_to_int_folder(
      patient_id,
          molecular_id,
          analysis_id,
          folder='bdd_test_ion_reporter',
          json_name='test1.json')
    # wait_until_updated(patient_id)
    dev_path = "s3://pedmatch-dev/#{folder}/#{molecular_id}/#{analysis_id}/#{json_name}"
    int_path = "s3://pedmatch-int/#{folder}/#{molecular_id}/#{analysis_id}/#{json_name}"
    Helper_Methods.s3_cp_single_file(dev_path, int_path)
  end

  # def self.tsv_vcf_uploaded(
  #   patient_id,
  #   molecular_id,
  #   analysis_id,
  #   tsv_name='test1.tsv',
  #   vcf_name='test1.vcf'
  # )
  #   message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['variant_tsv_vcf_uploaded']
  #   message['molecular_id'] = molecular_id
  #   message['analysis_id'] = analysis_id
  #   message['tsv_file_name'] = tsv_name
  #   message['vcf_file_name'] = vcf_name
  #   send_message_to_local(message, patient_id)
  # end
  #
  # def self.dna_uploaded(
  #     patient_id,
  #         molecular_id,
  #         analysis_id,
  #         bam_name='dna.bam',
  #         bai_name='dna.bai'
  # )
  #   message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['variant_dna_file_uploaded']
  #   message['molecular_id'] = molecular_id
  #   message['analysis_id'] = analysis_id
  #   message['dna_bam_file_name'] = bam_name
  #   message['dna_bai_file_name'] = bai_name
  #   send_message_to_local(message, patient_id)
  # end
  #
  # def self.cdna_uploaded(
  #     patient_id,
  #     molecular_id,
  #     analysis_id,
  #     bam_name='cdna.bam',
  #     bai_name='cdna.bai'
  # )
  #   message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['variant_cdna_file_uploaded']
  #   message['molecular_id'] = molecular_id
  #   message['analysis_id'] = analysis_id
  #   message['cdna_bam_file_name'] = bam_name
  #   message['cdna_bai_file_name'] = bai_name
  #   send_message_to_local(message, patient_id)
  # end

  def self.variant_file_confirmed(
      patient_id,
          status,
          analysis_id)
    message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['variant_file_confirmed']
    send_variant_report_confirm_message(message, patient_id, analysis_id, status)
    wait_until_updated(patient_id, '')
  end

  def self.assignment_confirmed(
      patient_id,
          analysis_id,
          comment='Test',
          comment_user='QA')
    message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['assignment_confirmed']
    message['comment'] = comment
    message['comment_user'] = comment_user
    service = patient_id + '/assignment_reports/' + analysis_id + '/confirm'
    put_message_to_local(service, message)
    wait_until_updated(patient_id, '')
  end

  def self.off_study(
      patient_id,
          step_number,
          status_date='2016-08-30T12:11:09.071-05:00'
  )
    message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['off_study']
    message['patient_id'] = patient_id
    message['step_number'] = step_number
    message['status'] = 'OFF_STUDY'
    message['status_date'] = status_date
    send_message_to_local(message, patient_id)
    wait_until_updated(patient_id, '')
  end

  def self.off_study_biopsy_expired(
      patient_id,
          step_number,
          status_date='2016-08-30T12:11:09.071-05:00'
  )
    message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['off_study']
    message['patient_id'] = patient_id
    message['step_number'] = step_number
    message['status'] = 'OFF_STUDY_BIOPSY_EXPIRED'
    message['status_date'] = status_date
    send_message_to_local(message, patient_id)
    wait_until_updated(patient_id, '')
  end


  def self.request_assignment(
      patient_id,
          rebiopsy='Y',
          step_number='2.0',
          status_date='2016-08-10T22:05:33+00:00'
  )
    @request_assignment_message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['request_assignment']
    @request_assignment_message['patient_id'] = patient_id
    @request_assignment_message['status_date'] = status_date
    @request_assignment_message['step_number'] = step_number
    @request_assignment_message['status'] = 'REQUEST_ASSIGNMENT'
    @request_assignment_message['rebiopsy'] = rebiopsy
    send_message_to_local(@request_assignment_message, patient_id)
    wait_until_updated(patient_id, '')
  end


  def self.request_no_assignment(
      patient_id,
          step_number='2.0',
          status_date='2016-08-10T22:05:33+00:00'
  )
    @request_assignment_message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['request_assignment']
    @request_assignment_message['patient_id'] = patient_id
    @request_assignment_message['status_date'] = status_date
    @request_assignment_message['step_number'] = step_number
    @request_assignment_message['status'] = 'REQUEST_NO_ASSIGNMENT'
    @request_assignment_message['rebiopsy'] = 'N'
    send_message_to_local(@request_assignment_message, patient_id)
    wait_until_updated(patient_id, '')
  end

  def self.on_treatment_arm(
      patient_id,
          treatment_arm_id='APEC1621-A',
          stratum_id='100',
          step_number='1.1')
    message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['on_treatment_arm']
    message['patient_id'] = patient_id
    message['step_number'] = step_number
    message['treatment_arm_id'] = treatment_arm_id
    message['stratum_id'] = stratum_id
    message['status_date'] = Time.now.iso8601
    send_message_to_local(message, patient_id)
  end

  def self.reset_cog
    service ='restart'
    send_message_to_local_cog(service, '')
  end

  def self.reset_cog_patient(patient_id)
    service = 'resetPatient/'+patient_id
    send_message_to_local_cog(service, '')
  end
end

class PatientDataSet
  def initialize(patient_id)
    @patient_id = patient_id
    @sei_number = 1
    @moi_number = 1
    @bd_moi_number = 1
    @ani_number = 1
    @bc_number = 1
  end

  def id
    @patient_id
  end

  def sei
    @patient_id+'_SEI'+@sei_number.to_i.to_s
  end

  def moi
    @patient_id+'_MOI'+@moi_number.to_i.to_s
  end

  def bd_moi
    @patient_id+'_BD_MOI'+@bd_moi_number.to_i.to_s
  end

  def ani
    @patient_id+'_ANI'+@ani_number.to_i.to_s
  end

  def bc
    @patient_id+'_BC'+@bc_number.to_i.to_s
  end

  def sei_increase
    @sei_number += 1
    sei
  end

  def moi_increase
    @moi_number += 1
    moi
  end

  def bd_moi_increase
    @bd_moi_number += 1
    bd_moi
  end

  def ani_increase
    @ani_number += 1
    ani
  end

  def bc_increase
    @bc_number += 1
    bc
  end
end