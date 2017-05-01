require_relative '../DataSetup/patient_message_loader'
require_relative '../DataSetup/match_test_data_manager'
require_relative '../DataSetup/dynamo_utilities'
require_relative '../DataSetup/sqs_utilities'

class BioMatchPMFullValidation
  ION_REPORTER='bio-match-test'
  PATIENT_URL='http://127.0.0.1:10240/api/v1/patients'
  TREATMENT_ARM_URL='http://127.0.0.1:10235/api/v1/treatment_arms'
  RULE_URL='http://127.0.0.1:10250/api/v1/rules'
  TA_URL='http://127.0.0.1:10235/api/v1/treatment_arms'
  IR_URL='http://localhost:5000/api/v1/aliquot'
  MOCK_COG_URL='http://127.0.0.1:3000'
  S3_BUCKET='pedmatch-dev'
  NO_TA='No treatment arm selected'

  def self.test(test_id)
    load_test(test_id)
    build_patient
    verify_result
  end

  def self.load_test(test_id)
    @test_id = test_id
    @patient_hash = JSON.parse(File.read("#{File.dirname(__FILE__)}/patients/#{test_id}.json"))
    @expect_ta = ta_string(@patient_hash['expected_treatment_arm_id'], @patient_hash['expected_stratum_id'])
    @pten = @patient_hash['pten_status']
    @baf47 = @patient_hash['baf47_status']
    @brg1 = @patient_hash['brg1_status']
    @patient_id = Time.now.to_i.to_s
    @patient_hash['patient_id'] = @patient_id
    @patient_hash['treatment_arm_statuses'].each { |this_status|
      set_ta_status_to_cog(this_status) }
  end

  def self.build_patient
    Environment.setTier('local')
    pt = PatientDataSet.new(@patient_id)
    register_patient_to_cog(@patient_hash)
    PatientMessageLoader.register_patient(pt.id)
    PatientMessageLoader.specimen_received_tissue(pt.id, pt.sei)
    PatientMessageLoader.specimen_shipped_tissue(pt.id, pt.sei, pt.moi)
    PatientMessageLoader.specimen_shipped_slide(pt.id, pt.sei, pt.bc)
    PatientMessageLoader.assay(pt.id, pt.sei, @pten, 'ICCPTENs')
    PatientMessageLoader.assay(pt.id, pt.sei, @baf47, 'ICCBAF47s')
    PatientMessageLoader.assay(pt.id, pt.sei, @brg1, 'ICCBRG1s')
    upload_vcf_to_s3(pt.id, pt.moi, pt.ani)
    send_vcf_message(pt.id, pt.moi, pt.ani)
    PatientMessageLoader.variant_file_confirmed(pt.id, 'confirm', pt.ani)
    PatientMessageLoader.wait_until_patient_status_is(pt.id, 'PENDING_CONFIRMATION')
  end

  def self.send_vcf_message(patient_id, moi, ani)
    hash = {}
    hash['analysis_id'] = ani
    hash['site'] = 'mda'
    hash['ion_reporter_id'] = ION_REPORTER
    hash['vcf_name'] = "#{patient_id}.vcf"
    url = "#{IR_URL}/#{moi}"
    response = Helper_Methods.put_request(url, hash.to_json.to_s)
    puts "#{response['message']}"
    PatientMessageLoader.wait_until_patient_status_is(patient_id, 'TISSUE_VARIANT_REPORT_RECEIVED')
    sleep 15.0
  end

  def self.upload_vcf_to_s3(patient_id, moi, ani)
    vcf_path = "#{File.dirname(__FILE__)}/vcfs/#{@test_id}.vcf"
    tmp_folder = "#{File.dirname(__FILE__)}/upload_tmp/#{moi}/#{ani}"
    tmp_root_folder = "#{File.dirname(__FILE__)}/upload_tmp"
    cmd = "mkdir -p #{tmp_folder}"
    puts `#{cmd}`
    cmd = "cp #{vcf_path} #{tmp_folder}/#{patient_id}.vcf"
    puts `#{cmd}`
    cmd = "aws s3 cp #{tmp_root_folder} s3://#{S3_BUCKET}/#{ION_REPORTER}/ --recursive --region us-east-1"
    `#{cmd}`
    cmd = "rm -r -f #{File.dirname(__FILE__)}/upload_tmp"
    `#{cmd}`
    puts "#{vcf_path} has been uploaded to S3 in name #{patient_id}.vcf"
    sleep 10.0
  end

  def self.verify_result
    result = Hash.new
    result['test_case'] = "#{@patient_id}"
    @actual_ta = ''
    if PatientMessageLoader.is_upload_failed?
      @actual_ta = 'Failed generating patient variant report'
      response = {}
    else
      Environment.setTier('local')
      url = "#{PATIENT_URL}/assignments?patient_id=#{@patient_id}"
      response = Helper_Methods.simple_get_request(url)['message_json'][0]
      if response['report_status'] == 'TREATMENT_FOUND'
        selected = response['treatment_assignment_results']['SELECTED']
        if selected.size == 1
          @actual_ta = ta_string(selected[0]['treatment_arm']['treatment_arm_id'],
                                 selected[0]['treatment_arm']['stratum_id'])
        else
          @actual_ta = ''
          selected.each { |this_selected|
            @actual_ta += ta_string(this_selected[0]['treatment_arm']['treatment_arm_id'],
                                    this_selected[0]['treatment_arm']['stratum_id']) + ' ' }
        end
      else
        @actual_ta = ta_string('', '')
      end
    end
    test_result = @actual_ta.eql?(@expect_ta) ? 'Passed' : 'Failed'
    result['test_result'] = test_result
    result['expected_treatment_arm'] = @expect_ta
    result['actual_treatment_arm'] = @actual_ta
    File.open("#{File.dirname(__FILE__)}/results/#{@test_id}.json", 'w') { |f| f.write(JSON.pretty_generate(result)) }
    File.open("#{File.dirname(__FILE__)}/results/#{@test_id}_Assignment_report.json", 'w') { |f| f.write(JSON.pretty_generate(response)) }
    cmd = "aws s3 rm s3://#{S3_BUCKET}/#{ION_REPORTER}/ --recursive --region us-east-1"
    `#{cmd}`
  end

  def self.register_patient_to_cog(patient_hash)
    url = "#{MOCK_COG_URL}/register_patient"
    Helper_Methods.post_request(url, patient_hash.to_json)
  end

  def self.set_ta_status_to_cog(ta_status)
    url = "#{MOCK_COG_URL}/setTreatmentArmStatus"
    Helper_Methods.post_request(url, ta_status.to_json)
  end

  def self.ta_string(ta_id, stratum)
    if ta_id.eql?('')||stratum.eql?('')
      return NO_TA
    else
      return "#{ta_id} (#{stratum})"
    end
  end

  def self.reload_database_local_only
    Environment.setTier('local')
    MatchTestDataManager.clear_all_local_tables
    ta_json = "#{File.dirname(__FILE__)}/treatment_arm.json"
    DynamoUtilities.upload_seed_data('treatment_arm', ta_json, 'local')
  end
end

BioMatchPMFullValidation.reload_database_local_only
BioMatchPMFullValidation.test('Test_D1_2')