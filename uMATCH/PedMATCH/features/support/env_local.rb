# ENV['DOCKER_HOSTNAME'] = '127.0.0.1' #'192.168.99.100' 127.0.0.1
# ENV['treatment_arm_api_PORT'] = '10235'
# ENV['patient_api_PORT'] = '10240'
# ENV['patient_processor_PORT'] = '3010'
# ENV['cog_mock_PORT'] = '3000'
# ENV['protocol'] = 'http'



ENV['rules_endpoint'] = 'http://127.0.0.1:8080/api/v1/rules'
# ENV['rules_endpoint'] = 'https://pedmatch-int.nci.nih.gov/api/v1/rules'
ENV['patients_endpoint'] = 'http://127.0.0.1:10240/api/v1/patients'
ENV['treatment_arm_endpoint'] = 'http://127.0.0.1:10235'
ENV['cog_mock_endpoint'] = 'http://127.0.0.1:3000'

ENV['PATIENT_ASSIGNMENT_JSON_LOCATION'] = '../../../../public/patient_jsons_for_assignment_report_tests'
ENV['TAs_ASSIGNMENT_JSON_LOCATION'] = '../../../../public/TAs_for_assignment_report_tests'
ENV['rules_treatment_arm_location'] = '../../../../public/TAs_for_amoi_tests'
