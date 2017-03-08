require 'rest-client'
require 'json'
require 'aws-sdk'

module Request
	module_function

  ## Post Request
  # @Params
  # <String> url: Required. Complete url including query parameters.
  # <Hash>   body: Optional. List of all the paramters that are sent in the body of the request. 
  # <Boolean> auth0_on: Optional. If True then a request is made to the auth0 endpoint to get a token
  # <String> auth0_role: Optional. provide the role
  # 
  # @return
  # This returns a hash object with the following. 
  # status_code <String> the status code of the response message. 
  # status <String> Passed | Failed
  # message <String> Unaltered response body
  # 
	def post_request(url, body={}, auth0_on=true, auth0_role='ADMIN')
		puts "POST_URL: #{url}"
		headers = {
			content_type: :json, 
      accept: :json
		}
		Auth0Client.add_auth0_header(headers, auth0_role) if auth0_on

		post_response = {}

		begin
			response = RestClient::Request.execute(
				url: url, 
				method: :post, 
				verify_ssl: false, 
				payload: body.to_json, 
				headers: headers)

		rescue StandardError => e
      post_response['status'] = 'Failure'

      http_code = '500'
      post_response['http_code'] = http_code
      
      if e.respond_to?('response')
        post_response['message'] = e.response
      else
        post_response['message'] = e.message
      end
      return post_response
    end

    http_code = "#{response.code}"
    status = http_code.match(/20(\d)/) ? 'Success' : 'Failure'
    post_response['status'] = status
    post_response['http_code'] = http_code
    post_response['message'] = response.body
    if status.eql?('Failure')
      p post_response['message']
    end
    post_response
	end
end