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
	def post_request(url, body={}, auth0_role='ADMIN', auth0_on=true)
		# puts "POST_URL: #{url}"
    puts "#####################################################################"
    puts "This is the earl"

    start = url.index('/v1/')
    puts url[(start + 4 )..-1]
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

      http_code = "#{response.code}"
      status = http_code.match(/20(\d)/) ? 'Success' : 'Failure'
      post_response['status'] = status
      post_response['http_code'] = http_code
      post_response['message'] = response.body
      if status.eql?('Failure')
        p body.to_json
        p post_response['message']
      end
		rescue StandardError => e
      post_response['status'] = 'Failure'
      p body.to_json
      http_code = '500'
      post_response['http_code'] = http_code

      if e.respond_to?('response')
        post_response['message'] = e.response
        p e.response
      else
        post_response['message'] = e.message
        p e.message
      end
      return post_response
    end
    puts post_response
    
    post_response
	end


  ## Get Request
  # @Params
  # <String> url: Required. Complete url including query parameters.
  # <Boolean> auth0_on: Optional. If True then a request is made to the auth0 endpoint to get a token
  # <String> auth0_role: Optional. provide the role
  #
  # @return
  # This returns a hash object with the following.
  # status_code <String> the status code of the response message.
  # status <String> Passed | Failed
  # message <String> Unaltered response body
  #
  def get_request(url, auth0_role='ADMIN', auth0_on = true)
    # puts "GET url: #{url}"
    headers = {
      content_type: :json,
      accept: :json
    }

    Auth0Client.add_auth0_header(headers, auth0_role) if auth0_on

    get_response = {}

    begin
      response = RestClient::Request.execute(
        url: url,
        method: :get,
        headers: headers
        )

      get_response['status']    = response.code.to_s.match(/20(\d)/) ? 'Success' : 'Failure'
      get_response['http_code'] = response.code
      get_response['message']   = response.body

      if get_response['status'] == "Failure"
        puts get_response['message']
      end
    rescue StandardError => err
      get_response['status'] = 'Failure'
      get_response['http_code'] = err.respond_to?(:http_code) ? err.http_code : 500
      get_response['message'] = err.respond_to?(:response) ? err.response : err.message

      return get_response
    end
    get_response
  end
end
