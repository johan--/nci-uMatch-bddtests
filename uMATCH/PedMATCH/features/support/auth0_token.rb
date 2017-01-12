require 'rest-client'

class Auth0Token
  def self.valid_role?(role)
    valid_roles = %w(ADMIN SYSTEM ASSIGNMENT_REPORT_REVIEWER MDA_VARIANT_REPORT_SENDER
                   MDA_VARIANT_REPORT_REVIEWER MOCHA_VARIANT_REPORT_SENDER MOCHA_VARIANT_REPORT_REVIEWER
                   PATIENT_MESSAGE_SENDER SPECIMEN_MESSAGE_SENDER ASSAY_MESSAGE_SENDER NCI_MATCH_READONLY NO_ROLE)
    valid_roles.include?(role)
  end

  def self.generate_auth0_token(role)
    unless ENV['NEED_AUTH0'] == 'YES'
      puts 'Auth0 is turned off!'
      return ''
    end
    force_generate_auth0_token(role)
  end

  def self.create_auth0_request_message(role)
    if role == 'NO_ROLE'
      prefix = ''
      scope = 'openid email'
    else
      prefix = "#{role}_"
      scope = 'openid email roles'
    end
    {:client_id => ENV['AUTH0_CLIENT_ID'],
     :username => ENV["#{prefix}AUTH0_USERNAME"],
     :password => ENV["#{prefix}AUTH0_PASSWORD"],
     :grant_type => 'password',
     :scope => scope,
     :connection => ENV['AUTH0_DATABASE']}.to_json
  end

  def self.force_generate_auth0_token(role)
    unless valid_role?(role)
      puts "#{role} is not a valid role, return an empty auth0 token..."
      return ''
    end
    token_variable = "#{role}_AUTH0_TOKEN"
    if ENV[token_variable].nil? || ENV[token_variable].size < 1
      begin
        response = RestClient::Request.execute(:url => "https://#{ENV['AUTH0_DOMAIN']}/oauth/ro",
                                               :method => :post,
                                               :verify_ssl => false,
                                               :payload => create_auth0_request_message(role),
                                               :headers => {:content_type => 'application/json',
                                                            :accept => 'application/json'})
      rescue StandardError => e
        puts e.to_s
        return ''
      end
      begin
        response_hash = JSON.parse(response)
      rescue StandardError => e
        puts e.to_s
        return ''
      end
      ENV[token_variable] = response_hash['id_token']
      puts "A #{ENV[token_variable].length} digi auth0 #{role} token is generated"
    # else
    #   puts "A #{ENV[token_variable].length} digi auth0 #{role} token exists, keep using that one"
    end
    return ENV[token_variable]
  end

  def self.add_auth0_if_needed(headers, role)
    if ENV['NEED_AUTH0'] == 'YES'
      token = generate_auth0_token(role)
      if token.size>1
        headers['Authorization'] = "Bearer #{token}"
      end
    end
    headers
  end
end