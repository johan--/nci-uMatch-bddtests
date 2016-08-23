require 'HTTParty'
require_relative '../uMATCH/PedMATCH/features/support/helper_methods'

class PatientMessageLoader
  include HTTParty

  LOCAL_PATIENT_DATA_FOLDER = 'local_patient_data'
  LOCAL_DYNAMODB_URL = 'http://localhost:8000'
  LOCAL_PATIENT_API_URL = 'http://localhost:10240'
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

  def self.load_patient_to_local(message_file, wait_time)
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
        curl_cmd = curl_cmd + "' #{LOCAL_PATIENT_API_URL}/#{SERVICE_NAME}"
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

  def self.send_message_to_local(message_json)
    @all_items += 1
    curl_cmd ="curl -k -X POST -H \"Content-Type: application/json\""
    curl_cmd = curl_cmd + " -H \"Accept: application/json\"  -d '" + message_json.to_json
    curl_cmd = curl_cmd + "' #{LOCAL_PATIENT_API_URL}/#{SERVICE_NAME}"
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
    send_message_to_local(message)
  end

  def self.specimen_received_tissue(
      patient_id,
      collect_time='2016-04-25T15:17:11+00:00',
      received_time='2016-04-26T15:17:11+00:00',
      surgical_event_id='SEI_01')
    message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['specimen_received_TISSUE']
    message['specimen_received']['patient_id'] = patient_id
    message['specimen_received']['surgical_event_id'] = surgical_event_id
    message['specimen_received']['collected_dttm'] = convert_date(collect_time)
    message['specimen_received']['received_dttm'] = convert_date(received_time)
    send_message_to_local(message)
  end

  def self.specimen_received_blood(
      patient_id,
      collect_time='2016-04-25T15:17:11+00:00',
      received_time='2016-04-26T15:17:11+00:00')
    message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['specimen_received_BLOOD']
    message['specimen_received']['patient_id'] = patient_id
    message['specimen_received']['collected_dttm'] = convert_date(collect_time)
    message['specimen_received']['received_dttm'] = convert_date(received_time)
    send_message_to_local(message)
  end

  def self.specimen_shipped_tissue(
      patient_id,
      shipped_time='2016-05-01T19:42:13+00:00',
      surgical_event_id='SEI_01',
      molecular_id='MOI_01')
    message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['specimen_shipped_TISSUE']
    message['specimen_shipped']['patient_id'] = patient_id
    message['specimen_shipped']['surgical_event_id'] = surgical_event_id
    message['specimen_shipped']['molecular_id'] = molecular_id
    message['specimen_shipped']['molecular_dna_id'] = molecular_id+'D'
    message['specimen_shipped']['molecular_cdna_id'] = molecular_id+'C'
    message['specimen_shipped']['shipped_dttm'] = convert_date(shipped_time)
    send_message_to_local(message)
  end

  def self.specimen_shipped_slide(
      patient_id,
      shipped_time='2016-05-01T19:42:13+00:00',
      surgical_event_id='SEI_01',
      slide_barcode='BC_001')
    message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['specimen_shipped_SLIDE']
    message['specimen_shipped']['patient_id'] = patient_id
    message['specimen_shipped']['surgical_event_id'] = surgical_event_id
    message['specimen_shipped']['slide_barcode'] = slide_barcode
    message['specimen_shipped']['shipped_dttm'] = convert_date(shipped_time)
    send_message_to_local(message)
  end

  def self.specimen_shipped_blood(
      patient_id,
      molecular_id='MOI_BR_01',
      shipped_time='2016-05-01T19:42:13+00:00')
    message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['specimen_shipped_BLOOD']
    message['specimen_shipped']['patient_id'] = patient_id
    message['specimen_shipped']['molecular_id'] = molecular_id
    message['specimen_shipped']['shipped_dttm'] = convert_date(shipped_time)
    send_message_to_local(message)
  end

  def self.assay(
      patient_id,
      result='POSITIVE',
      biomarker='ICCPTENs',
      surgical_event_id='SEI_01',
      reported_date='2016-05-30T12:11:09.071-05:00')
    message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['assay_result_reported']
    message['patient_id'] = patient_id
    message['surgical_event_id'] = surgical_event_id
    message['biomarker'] = biomarker
    message['result'] = result
    message['reported_date'] = convert_date(reported_date)
    send_message_to_local(message)
  end

  def self.pathology(
      patient_id,
      status='Y',
      surgical_event_id='SEI_01',
      reported_date='2015-04-27T12:13:09.071-05:00')
    message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['pathology_status']
    message['patient_id'] = patient_id
    message['surgical_event_id'] = surgical_event_id
    message['status'] = status
    message['reported_date'] = convert_date(reported_date)
    send_message_to_local(message)
  end

  def self.variant_file_uploaded(
      patient_id,
      molecular_id='MOI_01',
      analysis_id='ANI_01')
    message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['variant_file_uploaded']
    message['patient_id'] = patient_id
    message['molecular_id'] = molecular_id
    message['analysis_id'] = analysis_id
    send_message_to_local(message)
  end

  def self.variant_file_confirmed(
      patient_id,
      status,
      molecular_id='MOI_01',
      analysis_id='ANI_01')
    message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['variant_file_confirmed']
    message['patient_id'] = patient_id
    message['status'] = status
    message['molecular_id'] = molecular_id
    message['analysis_id'] = analysis_id
    send_message_to_local(message)
  end

  def self.assignment_confirmed(
      patient_id,
      status,
      molecular_id='MOI_01',
      analysis_id='ANI_01')
    message = JSON(IO.read(MESSAGE_TEMPLATE_FILE))['assignment_confirmed']
    message['patient_id'] = patient_id
    message['status'] = status
    message['molecular_id'] = molecular_id
    message['analysis_id'] = analysis_id
    send_message_to_local(message)
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
  #       curl_cmd = curl_cmd + "' #{LOCAL_PATIENT_API_URL}/#{SERVICE_NAME}"
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
