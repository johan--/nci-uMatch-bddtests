require 'json'
require_relative 'constants'
require 'active_record'
require_relative 'utilities'

class PedMatchRestClient
  RETRY_INTERVAL = 0.5
  TIMEOUT = 45

  def self.set_tier(tier)
    Constants.set_tier(tier)
  end

  def self.send_until_accept(url, method, payload)
    time = 0
    last_response = ''
    while time<TIMEOUT
      sleep RETRY_INTERVAL
      time += RETRY_INTERVAL
      last_response = send(url, method, payload)
      break if last_response.code < 203
    end
    last_response
  end

  def self.wait_until_has_result(url)
    time = 0
    last_response = ''
    while time<TIMEOUT
      sleep RETRY_INTERVAL
      time += RETRY_INTERVAL
      last_response = send(url, 'get')
      next if last_response.nil?
      if last_response.code == 200
        response_hash = JSON.parse(last_response.to_s)
        break if response_hash.is_a?(Array) && response_hash.size > 0
      end
    end
    last_response
  end

  def self.wait_until_update(url)
    time = 0
    updated = false
    last_response = send(url, 'get')
    while time<TIMEOUT
      sleep RETRY_INTERVAL
      time += RETRY_INTERVAL
      new_response = send(url, 'get')
      unless new_response == last_response
        updated = true
        break
      end
    end
    updated
  end

  private_class_method def self.ped_match_auth
                         payload = {:client_id => Constants.auth0_client_id,
                                    :username => Constants.auth0_username,
                                    :password => Constants.auth0_password,
                                    :grant_type => 'password',
                                    :scope => 'openid email roles',
                                    :connection => Constants.auth0_database}.to_json
                         token_variable = 'PED_MATCH_TOKEN'
                         unless ENV[token_variable].present?
                           begin
                             response = RestClient::Request.execute(:url => "https://#{Constants.auth0_domain}/oauth/ro",
                                                                    :method => :post,
                                                                    :verify_ssl => false,
                                                                    :payload => payload,
                                                                    :headers => {:content_type => 'application/json',
                                                                                 :accept => 'application/json'})
                           rescue StandardError => e
                             Log.error(e.to_s)
                             return ''
                           end
                           begin
                             response_hash = JSON.parse(response)
                           rescue StandardError => e
                             Log.error(e.to_s)
                             return ''
                           end
                           ENV[token_variable] = response_hash['id_token']
                         end
                         return ENV[token_variable]
                       end

  private_class_method def self.send(service, request_type, payload='')
                         headers = {:Authorization => "Bearer #{ped_match_auth}"}
                         unless request_type.eql?('get')
                           headers[:content_type] = 'application/json'
                           headers[:accept] = 'application/json'
                         end
                         Utilities.rest_request(service, request_type, payload, headers)
                       end
end
