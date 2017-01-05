require 'rest-client'

class Auth0Token
  def self.generate_auth0_token(role)
    unless ENV['NEED_AUTH0'] == 'YES'
      puts 'Auth0 is turned off!'
      return ''
    end
    force_generate_auth0_token(role)
  end

  def self.force_generate_auth0_token(role)
    cmd = 'source ~/.bashrc'
    `#{cmd}`
    role_prefix = role.size>0?"#{role.upcase}_":''
    token_variable = "#{role_prefix}AUTH0_TOKEN"
    if ENV[token_variable].nil? || ENV[token_variable] == ''
      puts "Generating auth0 #{role.upcase} token..."
      scope = 'openid email'
      scope += ' roles' if role.size>0
      request_body = {:client_id => ENV['AUTH0_CLIENT_ID'],
                      :username => ENV["#{role_prefix}AUTH0_USERNAME"],
                      :password => ENV["#{role_prefix}AUTH0_PASSWORD"],
                      :grant_type => 'password',
                      :scope => scope,
                      :connection => ENV['AUTH0_DATABASE']}
      request_body = request_body.to_json
      url = 'https://ncimatch.auth0.com/oauth/ro'
      begin
        response = RestClient::Request.execute(:url => url,
                                               :method => :post,
                                               :verify_ssl => false,
                                               :payload => request_body,
                                               :headers => {:content_type => 'application/json', :accept => 'application/json'})
      rescue StandardError
        return nil
      end
      begin
        response_hash = JSON.parse(response)
      rescue StandardError
        return nil
      end
      ENV[token_variable] = response_hash['id_token']
      puts "A #{ENV[token_variable].length} digi auth0 #{token_variable} token is generated"
      # else
      #   puts 'Auth0 token has been generated already, no need to generate again.'
    end
    return ENV[token_variable]
  end

  def self.add_auth0_if_needed(headers, role)
    if ENV['NEED_AUTH0'] == 'YES'
      headers['Authorization'] = "Bearer #{generate_auth0_token(role)}"
    end
    headers
  end
end