require 'rest-client'

class Auth0Token
  def self.valid_role?(role)
    valid_roles = %w(ADMIN SYSTEM ASSIGNMENT_REPORT_REVIEWER MDA_VARIANT_REPORT_SENDER
                   MDA_VARIANT_REPORT_REVIEWER MOCHA_VARIANT_REPORT_SENDER MOCHA_VARIANT_REPORT_REVIEWER
                   PATIENT_MESSAGE_SENDER SPECIMEN_MESSAGE_SENDER ASSAY_MESSAGE_SENDER)
    valid_roles.include?(role)
  end

  def self.generate_auth0_token(role)
    unless ENV['NEED_AUTH0'] == 'YES'
      puts 'Auth0 is turned off!'
      return ''
    end
    force_generate_auth0_token(role)
  end

  def self.force_generate_auth0_token(role)
    prefix = valid_role?(role) ? "#{role}_" : ''
    token_variable = "#{prefix}AUTH0_TOKEN"
    if ENV[token_variable].nil? || ENV[token_variable].size < 1
      if valid_role?(role)
        scope = 'openid email roles'
        puts "Generating auth0 #{role} token..."
      else
        scope = 'openid email'
        puts "#{role} is not a valid role, generating a basic auth0 token without role..."
      end
      request_body = {:client_id => ENV['AUTH0_CLIENT_ID'],
                      :username => ENV["#{prefix}AUTH0_USERNAME"],
                      :password => ENV["#{prefix}AUTH0_PASSWORD"],
                      :grant_type => 'password',
                      :scope => scope,
                      :connection => ENV['AUTH0_DATABASE']}
      request_body = request_body.to_json
      url = "https://#{ENV['AUTH0_DOMAIN']}/oauth/ro"
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
      puts "A #{ENV[token_variable].length} digi auth0 #{role} token is generated"
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