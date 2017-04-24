require_relative '../DataSetup/patient_message_loader'
require_relative '../DataSetup/match_test_data_manager'
require_relative '../DataSetup/dynamo_utilities'

class BioMatchPMValidation
  ION_REPORTER='bio-match-test'

  def self.reload_database
    Environment.setTier('local')
    MatchTestDataManager.clear_all_local_tables
    load_treatment_arms
  end

  def self.test(patient_id, expect_ta_id='', expect_ta_stratum='', pten='POSITIVE', baf47='POSITIVE', brg1='POSITIVE')
    build_patient(patient_id, pten, baf47, brg1)
    verify_result(patient_id, expect_ta_id, expect_ta_stratum)
  end

  def self.build_patient(patient_id, pten='POSITIVE', baf47='POSITIVE', brg1='POSITIVE')
    Environment.setTier('local')
    pt = PatientDataSet.new(patient_id)
    PatientMessageLoader.reset_cog_patient(pt.id)
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
    PatientMessageLoader.assay(pt.id, pt.sei, pten, 'ICCPTENs')
    PatientMessageLoader.assay(pt.id, pt.sei, baf47, 'ICCBAF47s')
    PatientMessageLoader.assay(pt.id, pt.sei, brg1, 'ICCBRG1s')
    upload_vcf_to_s3(pt.id, pt.moi, pt.ani)
    send_vcf_message(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.variant_file_confirmed(pt.id, 'confirm', pt.ani)
  end

  def self.verify_result(patient_id, expect_ta_id='', expect_ta_stratum='')
    result = Hash.new
    result['test_case'] = "#{patient_id}"
    if PatientMessageLoader.is_upload_failed?
      result['test_result'] = 'Failed'
      result['Failed_reason'] = 'Failed generating patient variant report'
    else
      Environment.setTier('local')
      url = "http://localhost:10240/api/v1/patients/#{patient_id}"
      response = Helper_Methods.simple_get_request(url)['message_json']
      if response.keys.include?('current_assignment')
        actual_ta_id = response['current_assignment']['treatment_arm_id']
        actual_ta_stratum = response['current_assignment']['stratum_id']
      else
        actual_ta_id = ''
        actual_ta_stratum = ''
      end
      test_result = 'Passed'
      test_result = 'Failed' unless actual_ta_id == expect_ta_id
      test_result = 'Failed' unless actual_ta_stratum == expect_ta_stratum
      result['test_result'] = test_result
      result['Failed_reason'] = 'Assignment mismatch' if test_result == 'Failed'
      result['expected_treatment_arm_id'] = expect_ta_id
      result['expected_treatment_arm_stratum'] = expect_ta_stratum
      result['actual_treatment_arm_id'] = actual_ta_id
      result['actual_treatment_arm_stratum'] = actual_ta_stratum
    end
    File.open("#{File.dirname(__FILE__)}/results/#{patient_id}.json", 'w') { |f| f.write(JSON.pretty_generate(result)) }
  end

  def self.upload_vcf_to_s3(patient_id, moi, ani)
    vcf_path = "#{File.dirname(__FILE__)}/vcfs/#{patient_id}.vcf"
    tmp_folder = "#{File.dirname(__FILE__)}/upload_tmp/#{moi}/#{ani}"
    tmp_root_folder = "#{File.dirname(__FILE__)}/upload_tmp"
    cmd = "mkdir -p #{tmp_folder}"
    puts `#{cmd}`
    cmd = "cp #{vcf_path} #{tmp_folder}"
    puts `#{cmd}`
    cmd = "aws s3 cp #{tmp_root_folder} s3://pedmatch-dev/#{ION_REPORTER}/ --recursive --region us-east-1"
    `#{cmd}`
    cmd = "rm -r -f #{File.dirname(__FILE__)}/upload_tmp"
    `#{cmd}`
    puts "#{vcf_path} has been uploaded to S3"
    sleep 10.0
  end

  def self.send_vcf_message(patient_id, moi, ani)
    hash = {}
    hash['analysis_id'] = ani
    hash['site'] = 'mda'
    hash['ion_reporter_id'] = ION_REPORTER
    hash['vcf_name'] = "#{patient_id}.vcf"
    url = "http://localhost:5000/api/v1/aliquot/#{moi}"
    response = Helper_Methods.put_request(url, hash.to_json.to_s)
    puts "#{response['message']}"
    PatientMessageLoader.wait_until_patient_status_is(patient_id, 'TISSUE_VARIANT_REPORT_RECEIVED')
    sleep 5.0
  end

  def self.load_treatment_arms
    ta_json = "#{File.dirname(__FILE__)}/treatment_arm.json"
    DynamoUtilities.upload_seed_data('treatment_arm', ta_json, 'local')
  end
end

# BioMatchPMValidation.reload_database
# BioMatchPMValidation.test('test_case_PM_TA_A_2', 'APEC1621A1', '1')


