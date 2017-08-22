require 'rest-client'

class Auth0Token
  def self.adult_match_token
    message = {:client_id => ENV['ADULT_MATCH_AUTH0_CLIENT_ID'],
               :username => ENV['ADULT_MATCH_AUTH0_USERNAME'],
               :password => ENV['ADULT_MATCH_AUTH0_PASSWORD'],
               :grant_type => 'password',
               :scope => 'openid email roles',
               :connection => ENV['ADULT_MATCH_AUTH0_DATABASE']}.to_json
    token_variable = 'ADULT_MATCH_AUTH0_TOKEN'
    if ENV[token_variable].nil? || ENV[token_variable].size < 1
      begin
        response = RestClient::Request.execute(:url => "https://#{ENV['AUTH0_DOMAIN']}/oauth/ro",
                                               :method => :post,
                                               :verify_ssl => false,
                                               :payload => message,
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
      puts "A #{ENV[token_variable].length} digi adult match auth0 token is generated"
      # else
      #   puts "A #{ENV[token_variable].length} digi auth0 #{role} token exists, keep using that one"
    end
    return ENV[token_variable]
  end

  def self.valid_role?(role)
    converted_role = role.gsub('PWD_', '')
    valid_roles = %w(ADMIN SYSTEM ASSIGNMENT_REPORT_REVIEWER MDA_VARIANT_REPORT_SENDER
                   MDA_VARIANT_REPORT_REVIEWER MOCHA_VARIANT_REPORT_SENDER MOCHA_VARIANT_REPORT_REVIEWER
                   DARTMOUTH_VARIANT_REPORT_REVIEWER DARTMOUTH_VARIANT_REPORT_SENDER
                   PATIENT_MESSAGE_SENDER SPECIMEN_MESSAGE_SENDER ASSAY_MESSAGE_SENDER NCI_MATCH_READONLY NO_ROLE)
    valid_roles.include?(converted_role)
  end

  def self.ped_match_auth0_response(username, password, scope='openid email roles')
    payload = {:client_id => ENV['AUTH0_CLIENT_ID'],
               :username => username,
               :password => password,
               :grant_type => 'password',
               :scope => scope,
               :connection => ENV['AUTH0_DATABASE']}.to_json
    begin
      response = RestClient::Request.execute(:url => "https://#{ENV['AUTH0_DOMAIN']}/oauth/ro",
                                             :method => :post,
                                             :verify_ssl => false,
                                             :payload => payload,
                                             :headers => {:content_type => 'application/json',
                                                          :accept => 'application/json'})
    rescue StandardError => e
      puts e.to_s
      return e.response
    end
    response
  end

  def self.generate_auth0_token(role)
    unless ENV['NEED_AUTH0'] == 'YES'
      puts 'Auth0 is turned off!'
      return ''
    end
    force_generate_auth0_token(role)
  end

  def self.force_generate_auth0_token(role)
    unless valid_role?(role)
      puts "#{role} is not a valid role, return an empty auth0 token..."
      return ''
    end
    token_variable = "#{role}_AUTH0_TOKEN"
    if ENV[token_variable].nil? || ENV[token_variable].size < 1
      prefix = role == 'NO_ROLE'?'':"#{role}_"
      scope = role == 'NO_ROLE'?'openid email':'openid email roles'
      response = ped_match_auth0_response(ENV["#{prefix}AUTH0_USERNAME"], ENV["#{prefix}AUTH0_PASSWORD"], scope)
      puts "Response Code: #{response.code}"

      begin
        raise "Request to Auth0 Failed" unless response.code == 200 # guard clause

        response_hash = JSON.parse(response)
        ENV[token_variable] = response_hash['id_token']
        puts "A #{ENV[token_variable].length} digit auth0 #{role} token is generated"
        ENV[token_variable]
      rescue StandardError => e
        puts response
        puts e.to_s
        ''
      end
    end
  end

  def self.add_auth0_if_needed(headers, role)
    if ENV['NEED_AUTH0'] == 'YES'
      token = generate_auth0_token(role)
      puts token
      if token.length>1
        headers['Authorization'] = "Bearer #{token}"
      end
    end
    headers
  end
end