ENV['HOSTNAME'] = 'http://pedmatch-admin-int-alb-frontend-792655680.us-east-1.elb.amazonaws.com'
ENV['ADMIN_ENDPOINT'] = "http://pedmatch-admin-int-alb-frontend-792655680.us-east-1.elb.amazonaws.com:10260"

ENV['s3_bucket'] = 'test-admin-tool'
ENV['s3_endpoint'] = 'https://s3.amazonaws.com'

ENV['dynamodb_endpoint'] = 'https://dynamodb.us-east-1.amazonaws.com'
ENV['dynamodb_region'] = 'us-east-1'