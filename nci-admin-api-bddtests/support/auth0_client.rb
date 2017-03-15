require 'rest-client'
require 'json'
require_relative './user_management'

module Auth0Client
	module_function

	def role_valid?(role)
		valid_user = %w(ADMIN)
		valid_user.include? role
	end

	def create_auth0_message(role)
		user_details = UserManagement.get_user_details(role)
		{
			"client_id": ENV['AUTH0_CLIENT_ID'],
    	"username": user_details[:email],
    	"password": user_details[:password],
    	"grant_type": "password",
    	"scope": "openid email roles",
    	"connection":  ENV['AUTH0_DATABASE']
		}.to_json
	end

	def get_auth0_token(role)
		raise "Provided role: #{role} is not a valid role" unless role_valid?(role)
		token_name = "#{role}_UI_AUTH0_TOKEN"
		token_value = create_auth0_message(role)
		url = "https://#{ENV['AUTH0_DOMAIN']}/oauth/ro"

		if ENV[token_name].to_s.empty?  # check for nil or empty
			begin
				response = RestClient::Request.execute(
						method: :post,
						url: url,
						verify_ssl: false,
						payload: create_auth0_message(role),
						headers: {
							content_type: :json,
							accept: :json
						}
					)
			rescue => e
				puts "Failure to acquire Token"
				puts e.backtrace
				raise  #reraising the exception to kill the process but print out the proper backtrace. 
			end

			begin
				token_hash = JSON.parse(response)
				ENV[token_name] = token_hash['id_token']
			rescue => e
				puts "Failure to retireve id_token from response"
				puts e.backtrace
				raise
			end
		end
		ENV[token_name]
	end

	def add_auth0_header(headers, role)
		auth0_token = get_auth0_token(role)
		headers[:Authorization] = "Bearer #{auth0_token}" if auth0_token.size > 1

		headers
	end
end
