require_relative '../DataSetup/patient_message_loader'
require_relative '../DataSetup/match_test_data_manager'
require_relative '../DataSetup/dynamo_utilities'
require_relative '../DataSetup/sqs_utilities'

class BioMatchPMFullValidation
  PATIENT_URL='http://127.0.0.1:10240/api/v1/patients'
  TREATMENT_ARM_URL='http://127.0.0.1:10235/api/v1/treatment_arms'
  RULE_URL='http://127.0.0.1:10250/api/v1/rules'
  TA_URL='http://127.0.0.1:10235/api/v1/treatment_arms'
  NO_TA='No treatment arm selected'

  def self.test(patient_id, expect_ta_id='', expect_ta_stratum='')
    build_patient(patient_id)
    verify_result(patient_id, expect_ta_id, expect_ta_stratum)
  end

  def self.build_patient(patient_id)

  end
end