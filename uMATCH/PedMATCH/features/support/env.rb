# ENV['DOCKER_HOSTNAME'] = 'pedmatch-int.nci.nih.gov'
# ENV['patient_api_PORT'] = '10240'
# ENV['patient_processor_PORT'] = '3010'
# ENV['treatment_arm_api_PORT'] = '10235'
# ENV['cog_mock_PORT'] = '3000'
# ENV['protocol'] = 'http'
# ENV['rules_PORT'] = '10250'
# ENV['PATIENT_ASSIGNMENT_JSON_LOCATION'] = '../../../../public'



ENV['rules_endpoint'] = 'http://pedmatch-int.nci.nih.gov/api/v1/rules'
ENV['patients_endpoint'] = 'http://pedmatch-int.nci.nih.gov'
ENV['treatment_arm_endpoint'] = 'http://pedmatch-int.nci.nih.gov'
ENV['cog_mock_endpoint'] = 'http://pedmatch-int.nci.nih.gov:3000'

ENV['PATIENT_ASSIGNMENT_JSON_LOCATION'] = '../../../../public'