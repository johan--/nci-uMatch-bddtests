ENV['HOSTNAME'] = 'http://localhost'
ENV['ADMIN_ENDPOINT'] = "#{ENV['HOSTNAME']}:10260"

ENV['s3_bucket'] = 'test-admin-tool'
ENV['s3_endpoint'] = 'https://s3.amazonaws.com'

ENV['dynamodb_endpoint'] = 'https://dynamodb.us-east-1.amazonaws.com'
ENV['dynamodb_region'] = 'us-east-1'