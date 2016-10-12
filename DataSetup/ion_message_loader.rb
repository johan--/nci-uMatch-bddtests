require 'HTTParty'
require 'json'
require_relative '../uMATCH/PedMATCH/features/support/environment'
require_relative '../uMATCH/PedMATCH/features/support/helper_methods'

class IonMessageLoader
  include HTTParty

  LOCAL_DATA_FOLDER = 'local_patient_data'
  LOCAL_DYNAMODB_URL = 'http://localhost:8000'
  LOCAL_ION_API_URL = 'http://localhost:5000/api/v1'

  def self.upload_start_with_wait_time(time)
    @wait_time = time
    @all_items = 0
    @failure = 0
  end

  def self.upload_done
    pass = @all_items - @failure
    p "#{@all_items} messages processed, #{pass} passed and #{@failure} failed"
  end

  # def self.wait_until_updated(patient_id)
  #   timeout = 15.0
  #   total_time = 0.0
  #   old_status = ''
  #   loop do
  #     output_hash = Helper_Methods.simple_get_request("#{LOCAL_PATIENT_API_URL}/#{patient_id}")['message_json']
  #     if output_hash.length == 1
  #       new_status = output_hash[0]['current_status']
  #       if old_status == ''
  #         old_status = new_status
  #       end
  #       unless new_status==old_status
  #         return
  #       end
  #     end
  #     total_time += 0.5
  #     if total_time>timeout
  #       return
  #     end
  #     sleep(0.5)
  #   end
  # end

  def self.post_request(url)
    @all_items += 1
    output = Helper_Methods.post_request(url, '')
    p "Output from running No.#{@all_items} curl: #{output['message']}"
    unless output['status'].downcase.include?'success'
      p 'Failed'
      puts output['message']
      @failure += 1
    end
    sleep(@wait_time)
  end

  def self.put_message_to_local(service, message_json)
    @all_items += 1
    url = "#{LOCAL_PATIENT_API_URL}/#{service}"
    output = Helper_Methods.put_request(url, message_json.to_json)
    p "Output from running No.#{@all_items} curl: #{output['message']}"
    unless output['message'].downcase.include?'success'
      p 'Failed'
      puts JSON.pretty_generate(message_json)
      @failure += 1
    end
    # sleep(@wait_time)
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

  def self.create_ion_reporter(site)
    url = "#{LOCAL_ION_API_URL}/ion_reporters?site=#{site}"
    post_request(url)
  end

  def self.create_sample_control(site, control_type)
    url = "#{LOCAL_ION_API_URL}/sample_controls?site=#{site}&control_type=#{control_type}"
    post_request(url)
  end
end