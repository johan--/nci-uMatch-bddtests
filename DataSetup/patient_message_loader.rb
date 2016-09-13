require 'HTTParty'
require_relative '../uMATCH/PedMATCH/features/support/helper_methods'

class PatientMessageLoader
  include HTTParty

  LOCAL_PATIENT_DATA_FOLDER = 'local_patient_data'
  LOCAL_DYNAMODB_URL = 'http://localhost:8000'
  LOCAL_PATIENT_API_URL = 'http://localhost:10240/api/v1/patients/'
  SERVICE_NAME = 'trigger'
  MESSAGE_TEMPLATE_FILE = "#{File.dirname(__FILE__)}/../uMATCH/PedMATCH/public/patient_message_templates.json"

  def self.upload_start_with_wait_time(time)
    @wait_time = time
    @all_items = 0
    @failure = 0
  end

  def self.upload_done
    pass = @all_items - @failure
    p "#{@all_items} messages processed, #{pass} passed and #{@failure} failed"
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
        curl_cmd = curl_cmd + "' #{LOCAL_PATIENT_API_URL}/#{patient_id}"
        output = `#{curl_cmd}`
        p "Output from running No.#{all_items} curl: #{output}"
        unless output.downcase.include?'success'
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

  def self.send_message_to_local(message_json, patient_id)
    @all_items += 1
    curl_cmd ="curl -k -X POST -H \"Content-Type: application/json\""
    curl_cmd = curl_cmd + " -H \"Accept: application/json\"  -d '" + message_json.to_json
    curl_cmd = curl_cmd + "' #{LOCAL_PATIENT_API_URL}/#{patient_id}"
    output = `#{curl_cmd}`
    p "Output from running No.#{@all_items} curl: #{output}"
    unless output.downcase.include?'success'
      p 'Failed'
      puts JSON.pretty_generate(message_json)
      @failure += 1
    end
    sleep(@wait_time)
  end

  def self.send_variant_report_confirm_message(message_json, patient_id, moi, ani, status)
    @all_items += 1
    curl_cmd ="curl -k -X PUT -H \"Content-Type: application/json\""
    curl_cmd = curl_cmd + " -H \"Accept: application/json\"  -d '" + message_json.to_json
    curl_cmd = curl_cmd + "' #{LOCAL_PATIENT_API_URL}/#{patient_id}/variant_reports/#{moi}/#{ani}/#{status}"
    output = `#{curl_cmd}`
    p "Output from running No.#{@all_items} curl: #{output}"
    unless output.downcase.include?'success'
      p 'Failed'
      puts JSON.pretty_generate(message_json)
      @failure += 1
    end
    sleep(@wait_time)

  end

  def self.convert_date(date_string)
    case date_string
      when 'current' then Helper_Methods.dateDDMMYYYYHHMMSS
      when 'older' then Helper_Methods.backDate
      when 'future' then Helper_Methods.futureDate
      when 'older than 6 months' then Helper_Methods.olderThanSixMonthsDate
      when 'a few days older' then Helper_Methods.aFewDaysOlder
      else date_string
    end
  end

  def self.register_patient(patient_id, date='2016-02-09T22:06:33+00:00')
    message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['registration']
    message['patient_id'] = patient_id
    message['registration_date'] = convert_date(date)
    send_message_to_local(message, patient_id)
  end

  def self.specimen_received_tissue(
      patient_id,
      surgical_event_id,
      collect_time='2016-04-25T15:17:11+00:00')
    message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['specimen_received_TISSUE']
    message['specimen_received']['patient_id'] = patient_id
    message['specimen_received']['surgical_event_id'] = surgical_event_id
    message['specimen_received']['collected_dttm'] = convert_date(collect_time)
    send_message_to_local(message, patient_id)
  end

  def self.specimen_received_blood(
      patient_id,
      collect_time='2016-04-22T15:17:11+00:00')
    message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['specimen_received_BLOOD']
    message['specimen_received']['patient_id'] = patient_id
    message['specimen_received']['collected_dttm'] = convert_date(collect_time)
    send_message_to_local(message, patient_id)
  end

  def self.specimen_shipped_tissue(
      patient_id,
      surgical_event_id,
      molecular_id,
      shipped_time='2016-05-01T19:42:13+00:00')
    message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['specimen_shipped_TISSUE']
    message['specimen_shipped']['patient_id'] = patient_id
    message['specimen_shipped']['surgical_event_id'] = surgical_event_id
    message['specimen_shipped']['molecular_id'] = molecular_id
    message['specimen_shipped']['molecular_dna_id'] = molecular_id+'D'
    message['specimen_shipped']['molecular_cdna_id'] = molecular_id+'C'
    message['specimen_shipped']['shipped_dttm'] = convert_date(shipped_time)
    send_message_to_local(message, patient_id)
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
  end

  def self.specimen_shipped_blood(
      patient_id,
      molecular_id,
      shipped_time='2016-05-01T19:42:13+00:00')
    message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['specimen_shipped_BLOOD']
    message['specimen_shipped']['patient_id'] = patient_id
    message['specimen_shipped']['molecular_id'] = molecular_id
    message['specimen_shipped']['shipped_dttm'] = convert_date(shipped_time)
    send_message_to_local(message, patient_id)
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
  end

  # def self.variant_file_uploaded(
  #     patient_id,
  #     molecular_id,
  #     analysis_id)
  #   message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['variant_file_uploaded']
  #   message['patient_id'] = patient_id
  #   message['molecular_id'] = molecular_id
  #   message['analysis_id'] = analysis_id
  #   send_message_to_local(message, patient_id)
  # end

  def self.tsv_vcf_uploaded(
    patient_id,
    molecular_id,
    analysis_id,
    tsv_name='test1.tsv',
    vcf_name='test1.vcf'
  )
    message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['variant_tsv_vcf_uploaded']
    message['molecular_id'] = molecular_id
    message['analysis_id'] = analysis_id
    message['tsv_file_name'] = tsv_name
    message['vcf_file_name'] = vcf_name
    send_message_to_local(message, patient_id)
  end

  def self.dna_uploaded(
      patient_id,
          molecular_id,
          analysis_id,
          bam_name='dna.bam',
          bai_name='dna.bam.bai'
  )
    message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['variant_dna_file_uploaded']
    message['molecular_id'] = molecular_id
    message['analysis_id'] = analysis_id
    message['dna_bam_file_name'] = bam_name
    message['dna_bai_file_name'] = bai_name
    send_message_to_local(message, patient_id)
  end

  def self.cdna_uploaded(
      patient_id,
      molecular_id,
      analysis_id,
      bam_name='cdna.bam',
      bai_name='cdna.bam.bai'
  )
    message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['variant_cdna_file_uploaded']
    message['molecular_id'] = molecular_id
    message['analysis_id'] = analysis_id
    message['cdna_bam_file_name'] = bam_name
    message['cdna_bai_file_name'] = bai_name
    send_message_to_local(message, patient_id)
  end

  def self.variant_file_confirmed(
      patient_id,
      status,
      molecular_id,
      analysis_id)
    message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['variant_file_confirmed']
    send_variant_report_confirm_message(patient_id, molecular_id, analysis_id, status, message)
    send_message_to_local(message, patient_id)
  end

  def self.assignment_confirmed(
      patient_id,
      status,
      molecular_id,
      analysis_id)
    message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['assignment_confirmed']
    message['patient_id'] = patient_id
    message['status'] = status
    message['molecular_id'] = molecular_id
    message['analysis_id'] = analysis_id
    send_message_to_local(message, patient_id)
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
  end

  def self.prepare_request_assignment_message(
    patient_id,
    rebiopsy='Y',
    step_number='2.0',
    status_date='2016-08-10T22:05:33+00:00',
    treatment_arm_id='APEC1621_A',
    treatment_arm_version='2015-08-06',
    stratum_id='100'
  )
    @request_assignment_message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['request_assignment']
    @request_assignment_message['patient_id'] = patient_id
    @request_assignment_message['status_date'] = status_date
    @request_assignment_message['step_number'] = step_number
    @request_assignment_message['treatment_arm_id'] = treatment_arm_id
    @request_assignment_message['stratum_id'] = stratum_id
    @request_assignment_message['status'] = 'REQUEST_ASSIGNMENT'
    @request_assignment_message['rebiopsy'] = rebiopsy
    @request_assignment_message['prior_drugs'] = []
  end

  def self.add_prior_drug_to_request_assignment_message(drug_id, name)
    @request_assignment_message['prior_drugs'] << {'drug_id'=>drug_id, 'name'=>name}
  end

  def self.send_request_assignment
    send_message_to_local(@request_assignment_message, @request_assignment_message['patient_id'])
  end

  def self.on_treatment_arm(
    patient_id,
    step_number='1.1',
    assignment_date='2016-08-10T22:05:33+00:00',
    treatment_arm_id='APEC1621_A',
    treatment_arm_version='2015-08-06',
    stratum_id='100'
  )
    message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['on_treatment_arm']
    message['patient_id'] = patient_id
    message['assignment_date'] = assignment_date
    message['step_number'] = step_number
    message['treatment_arm_id'] = treatment_arm_id
    message['stratum_id'] = stratum_id
    send_message_to_local(message, patient_id)
  end

  # def self.load_patient_script_to_local(message_file, wait_time)
  #   raise 'patient_id must be valid' if message_file.nil? || message_file.length == 0
  #   file = File.read("#{LOCAL_PATIENT_DATA_FOLDER}/#{message_file}.json")
  #
  #   message_list = JSON.parse(file)
  #   p "There are #{message_list.length} script messages in patient json file. Processing..."
  #
  #   all_items = 0
  #   failure = 0
  #
  #   message_list.each do |message|
  #     all_items += 1
  #
  #     message_type = message.keys[0]
  #     message_content = message.values[0]
  #     message_to_send = generate_message(message_type, message_content)
  #
  #     if message_type == 'sleep'
  #       p "Sleep for #{message_content} seconds"
  #       sleep(message_content.to_f)
  #     else
  #       curl_cmd ="curl -k -X POST -H \"Content-Type: application/json\""
  #       curl_cmd = curl_cmd + " -H \"Accept: application/json\"  -d '" + message_to_send.to_json
  #       curl_cmd = curl_cmd + "' #{ç}/#{SERVICE_NAME}"
  #       output = `#{curl_cmd}`
  #       p "Output from running No.#{all_items} curl: #{output}"
  #       unless output.downcase.include?'success'
  #         p 'Failed'
  #         puts JSON.pretty_generate(message_to_send)
  #         failure += 1
  #       end
  #       sleep(wait_time)
  #     end
  #   end
  #
  #   pass = all_items - failure
  #   p ''
  #   p "#{all_items} messages processed, #{pass} passed and #{failure} failed"
  # end
  #
  # def self.generate_message(message_type, message_content)
  #   this_raw_message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))[message_type]
  #   message = Hash.new
  #   if message_content.is_a?(String)
  #     message = set_message_value(this_raw_message, message_type, 'patient_id', message_content)
  #   elsif message_content.is_a?(Hash)
  #     message_content.keys.each do |field|
  #       message = set_message_value(this_raw_message, message_type, field, message_content[field])
  #     end
  #   end
  #   message
  # end
  #
  # def self.set_message_value(raw_message, message_type, message_field, message_value)
  #   if message_type.start_with?('specimen_received')
  #     raw_message['specimen_received'][message_field] = message_value
  #   elsif message_type.start_with?('specimen_shipped')
  #     raw_message['specimen_shipped'][message_field] = message_value
  #   else
  #     raw_message[message_field] = message_value
  #   end
  #   raw_message
  # end
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