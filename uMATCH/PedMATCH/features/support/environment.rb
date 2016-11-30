require 'rest-client'

module Environment
  @tier = "server"

  def self.getTier
    return @tier
  end

  def self.setTier tier
    if tier == "local"
      require_relative './env_local.rb'
    elsif tier == "server"
      require_relative './env.rb'
    end
    @tier = tier
    if (tier)
      puts "environment set to tier [" + tier.to_s + "]"
    end
  end

  def self.get_auth0_token
    if ENV['AUTH0_TOKEN'].nil? || ENV['AUTH0_TOKEN'] == ''
      request_body = {'client_id': ENV['AUTH0_CLIENT_ID'],
                      'username': ENV['AUTH0_USERNAME'],
                      'password': ENV['AUTH0_PASSWORD'],
                      'grant_type': 'password',
                      'scope': 'openid',
                      'connection': ENV['AUTH0_CONNECTION']}
      request_body = request_body.to_json
      url = 'https://ncimatch.auth0.com/oauth/ro'
      begin
        response = RestClient::Request.execute(:url => url,
                                               :method => :post,
                                               :verify_ssl => false,
                                               :payload => request_body,
                                               :headers => {:content_type => 'json', :accept => 'json'})
      rescue StandardError
        return nil
      end
      begin
        response_hash = JSON.parse(response)
      rescue StandardError
        return nil
      end
      ENV['AUTH0_TOKEN'] = response_hash['id_token']
    end
    return ENV['AUTH0_TOKEN']
  end
end