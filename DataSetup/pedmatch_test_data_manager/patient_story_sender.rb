require 'json'
require 'active_support'
require 'active_support/core_ext'
require_relative 'ped_match_rest'
require_relative 'patient_story'

class PatientStorySender
  LOCAL_PATIENT_DATA_FOLDER = 'local_patient_data'
  LOCAL_PATIENT_API_URL = 'http://localhost:10240/api/v1/patients'
  LOCAL_IR_API_URL = 'http://localhost:5000/api/v1'
  LOCAL_COG_URL = 'http://localhost:3000'
  MESSAGE_TEMPLATE_FILE = "#{File.dirname(__FILE__)}/patient_messages.json"
  RETRY_INTERVAL = 1
  TIMEOUT = 45

  def self.set_patient_api_url(url=LOCAL_PATIENT_API_URL)
    @patient_api_url = url
  end

  def self.set_ir_api_url(url=LOCAL_IR_API_URL)
    @ir_api_url = url
  end

  def self.set_cog_url(url=LOCAL_COG_URL)
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

  def self.send_patient(patient_id)
    templates = JSON.parse(File.read(MESSAGE_TEMPLATE_FILE))
    pt = PatientStory.new(patient_id)
    if pt.exist?
      story = pt.full_story
      Logger.log("Start process patient #{patient_id} with #{story.size} steps")
      story.each_with_index do |s, i|
        message = Marshal.load(Marshal.dump(templates[s.keys[0]]))
        values = add_realtime_values(s.values[0])
        url = update_string_values(message['url'], values)
        before = message['before'].collect { |v| update_string_values(v, values) }
        after = message['after'].collect { |v| update_string_values(v, values) }
        payload = update_hash_values(message['payload'], values)
        run_operations(before)
        last_response = PedMatchRest.send_until_accept(url, message['http_method'], payload)
        if last_response.code < 203
          Logger.log("Patient: #{patient_id} message (#{i+1}/#{story.size})<#{s.keys[0]}> is done")
        else
          error = "Failed to generate patient: #{patient_id} in step (#{i+1}/#{story.size})<#{s.keys[0]}> with error: "
          Logger.error(error)
          Logger.error(last_response)
          return false
        end
        run_operations(after)
      end
      Logger.log("Patient #{patient_id} is done")
      true
    else
      Logger.error("Patient #{patient_id} doesn't exist, to create patient please use PatientStory")
      false
    end
  end

  private_class_method def self.add_realtime_values(values)
                         values['<patient_api_url>'] = patient_api_url
                         values['<ir_api_url>'] = ir_api_url
                         values['<cog_url>'] = cog_url
                         values.each do |k, v|
                           values[k] = Time.now.iso8601 if v == 'current'
                           values[k] = Time.now.strftime("%Y-%m-%d") if v == 'today'
                         end
                         values
                       end

  private_class_method def self.update_string_values(string, values)
                         values.each { |k, v| string.gsub!(k, v) }
                         string
                       end

  private_class_method def self.update_hash_values(hash, values)
                         hash.each do |k, v|
                           if v.is_a?(Hash)
                             update_hash_values(v, values)
                           elsif values.has_key?(v)
                             hash[k] = values[v]
                           end
                         end
                         hash
                       end
  private_class_method def self.run_operations(list)
                         list.each do |string|
                           op = string.split(':')[0]
                           param = string.gsub("#{op}:", '')
                           case op
                             when 'has_result' then
                               PedMatchRest.wait_until_has_result(param)
                             when 'get_response_update' then
                               PedMatchRest.wait_until_update(param)
                             when 'json_to_int' then
                               copy_json_to_int(param)
                             else
                           end
                         end
                       end

  private_class_method def self.copy_json_to_int(file_path)
                         dev_path = "s3://pedmatch-dev/#{file_path}"
                         int_path = "s3://pedmatch-int/#{file_path}"
                         cmd = "aws s3 cp #{dev_path} #{int_path} --region us-east-1"
                         `#{cmd}`
                         Logger.log("#{dev_path} has been uploaded to #{int_path}")
                       end
end