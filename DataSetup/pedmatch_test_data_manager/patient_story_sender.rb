require 'json'
require 'active_support'
require 'active_support/core_ext'
require_relative 'ped_match_rest_client'
require_relative 'patient_story'
require_relative 'constants'

class PatientStorySender
  MESSAGE_TEMPLATE_FILE = "#{File.dirname(__FILE__)}/patient_messages.json"
  RETRY_INTERVAL = 1
  TIMEOUT = 45

  def self.set_tier(tier)
    Constants.set_tier(tier)
  end

  def self.send_patient_story(patient_story)
    if patient_story.is_a?(PatientStory)
      templates = JSON.parse(File.read(MESSAGE_TEMPLATE_FILE))
      story = patient_story.full_story
      patient_id = patient_story.patient_id
      Log.info("Start process patient #{patient_id} with #{story.size} steps")
      story.each_with_index do |s, i|
        operation = s['operation']
        message = Marshal.load(Marshal.dump(templates[operation]))
        values = add_realtime_values(s['parameters'])
        url = update_string_values(message['url'], values)
        before = message['before'].collect {|v| update_string_values(v, values)}
        after = message['after'].collect {|v| update_string_values(v, values)}
        payload = update_hash_values(message['payload'], values)
        unless run_operations(before)
          Log.error("Failed to run before operation <#{before}> for patient: #{patient_id}")
          return false
        end
        last_response = PedMatchRestClient.send_until_accept(url, message['http_method'], payload)
        if last_response.code < 203
          Log.info("Patient: #{patient_id} message (#{i+1}/#{story.size})<#{operation}> is done")
        else
          error = "Failed to generate patient: #{patient_id} in step (#{i+1}/#{story.size})<#{operation}> with error: "
          Log.error(error)
          Log.error(last_response)
          return false
        end
        unless run_operations(after)
          Log.error("Failed to run after operation <#{after}> for patient: #{patient_id}")
          return false
        end
      end
      Log.info("Patient #{patient_id} is done")
      true
    else
      Log.error("Expect parameter is PatientStory, but it is #{patient_story.class}")
    end
  end

  def self.send_seed_patient(patient_id)
    pt = PatientStory.new(patient_id)
    if pt.exist?
      send_patient_story(pt)
    else
      Log.error("Patient #{patient_id} doesn't exist, to create patient please use PatientStory")
      false
    end
  end

  private_class_method def self.add_realtime_values(values)
                         values['<patient_api_url>'] = Constants.url_patient_api
                         values['<ir_api_url>'] = Constants.url_ir_api
                         values['<cog_url>'] = Constants.url_mock_cog
                         values.each do |k, v|
                           values[k] = Time.now.iso8601 if v == 'current'
                           values[k] = Time.now.strftime("%Y-%m-%d") if v == 'today'
                         end
                         values
                       end

  private_class_method def self.update_string_values(string, values)
                         values.each {|k, v| string.gsub!(k, v)}
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
                         result = true
                         list.each do |string|
                           op = string.split(':')[0]
                           param = string.gsub("#{op}:", '')
                           this_result = case op
                                           when 'has_result' then
                                             PedMatchRestClient.wait_until_has_result(param)
                                           when 'get_response_update' then
                                             PedMatchRestClient.wait_until_update(param)
                                           when 'post' then
                                             PedMatchRestClient.send_until_accept(param, 'post', {})
                                           when 'sleep' then
                                             sleep(param.to_f)
                                           when 'json_to_int' then
                                             Utilities.copy_json_to_int(param)
                                           when 'upload_vr_file' then
                                             list = param.split('/')
                                             Utilities.upload_vr(list[0], list[1], list[2])
                                           else
                                             Log.warning("#{op} is not a valid operation")
                                         end
                           result = result && this_result
                         end
                         result
                       end
end