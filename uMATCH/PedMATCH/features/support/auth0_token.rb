require 'rest-client'

class Auth0Token
  def self.generate_auth0_token
    if ENV['AUTH0_TOKEN'].nil? || ENV['AUTH0_TOKEN'] == ''
      # puts 'Generating auth0 token...'
      request_body = {:client_id => ENV['AUTH0_CLIENT_ID'],
                      :username => ENV['AUTH0_USERNAME'],
                      :password => ENV['AUTH0_PASSWORD'],
                      :grant_type => 'password',
                      :scope => 'openid',
                      :connection => ENV['AUTH0_CONNECTION']}
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
      # puts "Auth0 token is generated: #{ENV['AUTH0_TOKEN']}"
    # else
      # puts 'Auth0 token has been generated already, no need to generate again.'
    end
    return ENV['AUTH0_TOKEN']
  end

  def self.add_auth0_if_needed(headers={})
    if ENV['NEED_AUTH0'] == 'YES'
      headers['Authorization'] = "Bearer #{generate_auth0_token}"
    end
    headers
  end
end

if __FILE__ == $0
  Auth0Token.generate_auth0_token
end