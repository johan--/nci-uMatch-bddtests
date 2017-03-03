require 'rest-client'
require 'json'

module Auth0Token
	module_function

	def user_valid?(user)
		valid_user = %w(ADMIN)
		valid_user.include? user
	end

	def create_auth0_message(user)
		{
			"client_id": ENV['AUTH0_CLIENT_ID'];
    	"username": ENV["#{user}_UI_AUTH0_USERNAME"],
    	"password": ENV["#{user}_UI_AUTH0_PASSWORD"],
    	"grant_type": "password",
    	"scope": "openid email roles",
    	"connection":  "MATCH-Development"
		}.to_json
	end

	def get_auth0_token(user)
		return "Provided user: #{user} is not a valid user" unless user_valid?(user)

		token = "#{user}_AUTH0_TOKEN"
		if ENV[token].to_s.empty?  # check for nil or empty
			begin
				response = RestClient::Request.execute(
						method: :post,
						url: "https://#{ENV['AUTH0_DOMAIN']}/oauth/ro",
						verify_ssl: false,
						payload: create_auth0_message(user),
						headers: {
							content_type: 'application/json',
							accept: 'application/json'
						}
					)
			rescue => e
				p e.backtrace
				raise  #reraising the excpetion to kill the process but print out the proper backtrace. 
			end

			begin
				token_hash = JSON.parse(response)
				ENV[token] = token_hash['id_token']
			rescue

			end

			


		end

	end


end
