require 'aws-sdk'

module AWS
	module S3
		module_function

		def setup_client(region='us-east-1', endpoint='https://s3.amazonaws.com')
			Aws::S3::Resource.new(
				endpoint: endpoint,
				region: region,
				access_key_id: ENV['AWS_ACCESS_KEY_ID'],
				secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'] )
		end

		## Lists files in the path provided
		# @param client Object : A Aws::S3::Resource Object
		# @param bucket_path String : Path to the Bucket 
		# 
		# Returns an array of files in the bucket. 
		def list_files(client, bucket_path)
			raise "Please initialize S3 client" unless client.kind_of? Aws::S3::Resource
			client.bucket(bucket_path).objects.map(&:key)
		end
	end

	module DynamoDB
		module_function
		def setup_client(region='us-east-1', endpoint='https://dynamodb.us-east-1.amazonaws.com')
			Aws::DynamoDB::Client.new(
				region: region,
				endpoint: endpoint,
				access_key_id: ENV['AWS_ACCESS_KEY_ID'],
				secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'])
		end

		def query_entry(client, query_options)
			raise "Please initialize DynamoDb client" unless client.kind_of? Aws::DynamoDB::Client

			client.query(query_options)
		end
	end
	
end
