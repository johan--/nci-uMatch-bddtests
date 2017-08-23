# ENV['DOCKER_HOSTNAME'] = 'pedmatch-int.nci.nih.gov'
# ENV['patient_api_PORT'] = '10240'
# ENV['patient_processor_PORT'] = '3010'
# ENV['treatment_arm_api_PORT'] = '10235'
# ENV['cog_mock_PORT'] = '3000'
# ENV['protocol'] = 'http'
# ENV['rules_PORT'] = '10250'
# ENV['PATIENT_ASSIGNMENT_JSON_LOCATION'] = '../../../../public'


ENV['HOSTNAME'] = 'https://pedmatch-int.nci.nih.gov'
ENV['rules_endpoint'] = 'https://pedmatch-int.nci.nih.gov/api/v1/rules'
ENV['patients_endpoint'] = 'https://pedmatch-int.nci.nih.gov/api/v1/patients'
ENV['treatment_arm_endpoint'] = 'https://pedmatch-int.nci.nih.gov'
ENV['cog_mock_endpoint'] = 'http://umatch-inttest-alb-backend-1-304898384.us-east-1.elb.amazonaws.com:3000/'
# if ENV['OLD_IR_SYSTEM'] == 'TRUE'
  ENV['ion_reporter_endpoint'] = 'https://pedmatch-int.nci.nih.gov/api/v1/ion_reporters'
  ENV['aliquot_endpoint'] = 'https://pedmatch-int.nci.nih.gov/api/v1/aliquot'
  ENV['sample_control_endpoint'] = 'https://pedmatch-int.nci.nih.gov/api/v1/sample_controls'
# else
#   ENV['ion_reporter_endpoint'] = 'http://pedmatch-inttest-alb-backend-2-1381614955.us-east-1.elb.amazonaws.com:3001/api/v1/ion_reporters'
#   ENV['sample_control_endpoint'] = 'http://pedmatch-inttest-alb-backend-2-1381614955.us-east-1.elb.amazonaws.com:3002/api/v1/sample_controls'
#   ENV['aliquot_endpoint'] = 'http://pedmatch-inttest-alb-backend-2-1381614955.us-east-1.elb.amazonaws.com:3003/api/v1/aliquot'
# end

ENV['s3_bucket'] = 'pedmatch-int'
ENV['adult_match_s3_bucket'] = 'adultmatch-int'
ENV['dynamodb_endpoint'] = 'https://dynamodb.us-east-1.amazonaws.com'
ENV['dynamodb_region'] = 'us-east-1'

ENV['PATIENT_ASSIGNMENT_JSON_LOCATION'] = '../../../../public/patient_jsons_for_assignment_report_tests'
ENV['TAs_ASSIGNMENT_JSON_LOCATION'] = '../../../../public/TAs_for_assignment_report_tests'
ENV['rules_treatment_arm_location'] = '../../../../public/TAs_for_amoi_tests'
ENV['GENE_LIST_FILE_LOCATION'] = './public/resources/'
ENV['NEED_AUTH0'] = 'YES' #'YES' or 'NO'
ENV['print_log'] = 'NO' #'YES' or 'NO'

ENV['mock_ir_50_location'] = ''
ENV['mock_ir_52_location'] = ''
ENV['uploader_db_location'] = ''
ENV['uploader_config_location'] = ''
ENV['uploader_service_location'] = ''
