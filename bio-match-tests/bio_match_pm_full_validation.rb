require_relative '../DataSetup/patient_message_loader'
require_relative '../DataSetup/match_test_data_manager'
require_relative '../DataSetup/dynamo_utilities'
require_relative '../DataSetup/sqs_utilities'

class BioMatchPMFullValidation
  NO_TA='No treatment arm selected'

  def initialize(tier)
    Environment.setTier('local')
    if tier.downcase == 'local'
      @ion_reporter='bio-match-test'
      @patient_url='http://127.0.0.1:10240/api/v1/patients'
      @treatment_arm_url='http://127.0.0.1:10235/api/v1/treatment_arms'
      @rule_url='http://127.0.0.1:10250/api/v1/rules'
      @ta_url='http://127.0.0.1:10235/api/v1/treatment_arms'
      @ir_url='http://localhost:5000/api/v1/aliquot'
      @mock_cog_url='http://127.0.0.1:3000'
      @s3_bucket='pedmatch-dev'
      PatientMessageLoader.set_patient_api_url(@patient_url)
    elsif tier.downcase == 'int'
      @ion_reporter='bio-match-test'
      @patient_url='https://pedmatch-int.nci.nih.gov/api/v1/patients'
      @treatment_arm_url='https://pedmatch-int.nci.nih.gov/api/v1/treatment_arms'
      @rule_url='https://pedmatch-int.nci.nih.gov/api/v1/rules'
      @ta_url='https://pedmatch-int.nci.nih.gov/api/v1/treatment_arms'
      @ir_url='https://pedmatch-int.nci.nih.gov/api/v1/aliquot'
      @mock_cog_url='http://umatch-uat-alb-backend-1961495808.us-east-1.elb.amazonaws.com:3000'
      @s3_bucket='pedmatch-int'
      # ENV['AWS_ACCESS_KEY_ID'] = ''
      # ENV['AWS_SECRET_ACCESS_KEY'] = ''
      ENV['AUTH0_CLIENT_ID'] = ENV['INT_AUTH0_CLIENT_ID']
      ENV['ADMIN_AUTH0_USERNAME'] = ENV['INT_ADMIN_AUTH0_USERNAME']
      ENV['ADMIN_AUTH0_PASSWORD'] = ENV['INT_ADMIN_AUTH0_PASSWORD']
      ENV['AUTH0_DATABASE'] = ENV['INT_AUTH0_DATABASE']
      PatientMessageLoader.set_patient_api_url(@patient_url)
    elsif tier.downcase == 'uat'
      @ion_reporter='bio-match-test'
      @patient_url='https://pedmatch-uat.nci.nih.gov/api/v1/patients'
      @treatment_arm_url='https://pedmatch-uat.nci.nih.gov/api/v1/treatment_arms'
      @rule_url='https://pedmatch-uat.nci.nih.gov/api/v1/rules'
      @ta_url='https://pedmatch-uat.nci.nih.gov/api/v1/treatment_arms'
      @ir_url='https://pedmatch-uat.nci.nih.gov/api/v1/aliquot'
      @mock_cog_url='http://umatch-uat-alb-backend-1961495808.us-east-1.elb.amazonaws.com:3000'
      @s3_bucket='pedmatch-uat'
      # ENV['AWS_ACCESS_KEY_ID'] = ''
      # ENV['AWS_SECRET_ACCESS_KEY'] = ''
      ENV['AUTH0_CLIENT_ID'] = ENV['UAT_AUTH0_CLIENT_ID']
      ENV['ADMIN_AUTH0_USERNAME'] = ENV['UAT_ADMIN_AUTH0_USERNAME']
      ENV['ADMIN_AUTH0_PASSWORD'] = ENV['UAT_ADMIN_AUTH0_PASSWORD']
      ENV['AUTH0_DATABASE'] = ENV['UAT_AUTH0_DATABASE']
      PatientMessageLoader.set_patient_api_url(@patient_url)
    else
      raise 'tier value can only by local or uat'
    end
  end

  def test(test_id)
    build_patient(test_id)
    upload_files
    confirm_patient
    verify_result
  end

  def load_test(test_id)
    @test_id = test_id
    @patient_hash = JSON.parse(File.read("#{File.dirname(__FILE__)}/patients/#{test_id}.json"))
    @expect_ta = ta_string(@patient_hash['expected_treatment_arm_id'], @patient_hash['expected_stratum_id'])
    @pten = @patient_hash['pten_status']
    @baf47 = @patient_hash['baf47_status']
    @brg1 = @patient_hash['brg1_status']
    @patient_id = "#{test_id}_#{Time.now.to_i.to_s}"
    @patient_hash['patient_id'] = @patient_id
    @patient_hash['treatment_arm_statuses'].each {|this_status|
      set_ta_status_to_cog(this_status)}
    @pt = PatientDataSet.new(@patient_id)
  end

  def reload_test_for_patient(patient_id)
    puts test_id = patient_id.gsub("_#{patient_id.split('_').last}", '')
    load_test(test_id)
    register_patient_to_cog(test_id, patient_id)
  end

  def build_patient(test_id)
    load_test(test_id)
    register_patient_to_cog(test_id, @pt.id)
    PatientMessageLoader.register_patient(@pt.id, 'current')
    PatientMessageLoader.specimen_received_tissue(@pt.id, @pt.sei, 'today')
    PatientMessageLoader.specimen_shipped_tissue(@pt.id, @pt.sei, @pt.moi, 'current')
    PatientMessageLoader.specimen_shipped_slide(@pt.id, @pt.sei, @pt.bc, 'current')
    PatientMessageLoader.assay(@pt.id, @pt.sei, @pten, 'ICCPTENs', 'current')
    PatientMessageLoader.assay(@pt.id, @pt.sei, @baf47, 'ICCBAF47s', 'current')
    PatientMessageLoader.assay(@pt.id, @pt.sei, @brg1, 'ICCBRG1s', 'current')
  end

  def build_patient_new_step(patient_id, rebiopsy, step_number, pten='POSITIVE', baf47='POSITIVE', brg1='POSITIVE')
    PatientMessageLoader.request_assignment(patient_id, rebiopsy, step_number)
    if rebiopsy=='Y'
      PatientMessageLoader.specimen_received_tissue(patient_id, "#{patient_id}_SEI2", 'today')
      PatientMessageLoader.specimen_shipped_tissue(patient_id, "#{patient_id}_SEI2", "#{patient_id}_MOI2", 'current')
      PatientMessageLoader.specimen_shipped_slide(patient_id, "#{patient_id}_SEI2", "#{patient_id}_BC2", 'current')
      PatientMessageLoader.assay(patient_id, "#{patient_id}_SEI2", pten, 'ICCPTENs', 'current')
      PatientMessageLoader.assay(patient_id, "#{patient_id}_SEI2", baf47, 'ICCBAF47s', 'current')
      PatientMessageLoader.assay(patient_id, "#{patient_id}_SEI2", brg1, 'ICCBRG1s', 'current')
    end
  end

  def send_new_assay(patient_id, sei, biomarker, result='POSITIVE')
    time = DateTime.current.utc.iso8601
    sleep 5.0
    PatientMessageLoader.assay(patient_id, sei, result, biomarker, time)
  end

  def upload_files
    upload_vcf_to_s3(@pt.id, @pt.moi, @pt.ani)
    send_vcf_message(@pt.id, @pt.moi, @pt.ani)
  end

  def confirm_patient
    PatientMessageLoader.variant_file_confirmed(@pt.id, 'confirm', @pt.ani)
    PatientMessageLoader.wait_until_patient_status_is(@pt.id, 'PENDING_CONFIRMATION')
  end

  def send_vcf_message(patient_id, moi, ani)
    hash = {}
    hash['analysis_id'] = ani
    hash['site'] = 'mda'
    hash['ion_reporter_id'] = @ion_reporter
    hash['vcf_name'] = "#{patient_id}.vcf"
    url = "#{@ir_url}/#{moi}"
    response = Helper_Methods.put_request(url, hash.to_json.to_s)
    puts "#{response['message']}"
    PatientMessageLoader.wait_until_patient_status_is(patient_id, 'TISSUE_VARIANT_REPORT_RECEIVED')
    sleep 15.0
  end

  def send_on_ta_message(patient_id, ta_id, stratum, step='1.1')
    PatientMessageLoader.on_treatment_arm(patient_id, ta_id, stratum, step)
  end

  def upload_vcf_to_s3(patient_id, moi, ani)
    vcf_path = "#{File.dirname(__FILE__)}/vcfs/#{@test_id}.vcf"
    tmp_folder = "#{File.dirname(__FILE__)}/upload_tmp/#{moi}/#{ani}"
    tmp_root_folder = "#{File.dirname(__FILE__)}/upload_tmp"
    cmd = "mkdir -p #{tmp_folder}"
    puts `#{cmd}`
    cmd = "cp #{vcf_path} #{tmp_folder}/#{patient_id}.vcf"
    puts `#{cmd}`
    cmd = "aws s3 cp #{tmp_root_folder} s3://#{@s3_bucket}/#{@ion_reporter}/ --recursive --region us-east-1"
    `#{cmd}`
    cmd = "rm -r -f #{File.dirname(__FILE__)}/upload_tmp"
    `#{cmd}`
    puts "#{vcf_path} has been uploaded to S3 in name #{patient_id}.vcf"
    sleep 10.0
  end

  def verify_result
    result = Hash.new
    result['test_case'] = "#{@patient_id}"
    @actual_ta = ''
    if PatientMessageLoader.is_upload_failed?
      @actual_ta = 'Failed generating patient variant report'
      response = {}
    else
      Environment.setTier('local')
      url = "#{@patient_url}/assignments?patient_id=#{@patient_id}"
      response = Helper_Methods.simple_get_request(url)['message_json'][0]
      if response['report_status'] == 'TREATMENT_FOUND'
        selected = response['treatment_assignment_results']['SELECTED']
        if selected.size == 1
          @actual_ta = ta_string(selected[0]['treatment_arm']['treatment_arm_id'],
                                 selected[0]['treatment_arm']['stratum_id'])
        else
          @actual_ta = ''
          selected.each {|this_selected|
            @actual_ta += ta_string(this_selected[0]['treatment_arm']['treatment_arm_id'],
                                    this_selected[0]['treatment_arm']['stratum_id']) + ' '}
        end
      else
        @actual_ta = ta_string('', '')
      end
    end
    test_result = @actual_ta.eql?(@expect_ta) ? 'Passed' : 'Failed'
    result['test_result'] = test_result
    result['expected_treatment_arm'] = @expect_ta
    result['actual_treatment_arm'] = @actual_ta
    File.open("#{File.dirname(__FILE__)}/results/#{@test_id}.json", 'w') {|f| f.write(JSON.pretty_generate(result))}
    File.open("#{File.dirname(__FILE__)}/results/#{@test_id}_Assignment_report.json", 'w') {|f| f.write(JSON.pretty_generate(response))}
    # cmd = "aws s3 rm s3://#{@s3_bucket}/#{@ion_reporter}/ --recursive --region us-east-1"
    `#{cmd}`
    @patient_hash['treatment_arm_statuses'].each {|this_status|
      default_ta = {
          :treatment_arm_id => this_status['treatment_arm_id'],
          :stratum_id => this_status['stratum_id'],
          :status => 'OPEN'
      }
      set_ta_status_to_cog(default_ta)}
  end

  def register_patient_to_cog(test_id, patient_id)
    patient_hash = JSON.parse(File.read("#{File.dirname(__FILE__)}/patients/#{test_id}.json"))
    patient_hash['patient_id'] = patient_id
    url = "#{@mock_cog_url}/register_patient"
    Helper_Methods.post_request(url, patient_hash.to_json)
  end

  def set_ta_status_to_cog(ta_status)
    url = "#{@mock_cog_url}/setTreatmentArmStatus"
    Helper_Methods.post_request(url, ta_status.to_json)
  end

  def ta_string(ta_id, stratum)
    if ta_id.eql?('')||stratum.eql?('')
      return NO_TA
    else
      return "#{ta_id} (#{stratum})"
    end
  end

  def reload_database_local_only
    Environment.setTier('local')
    MatchTestDataManager.clear_all_local_tables
    ta_json = "#{File.dirname(__FILE__)}/treatment_arm.json"
    DynamoUtilities.upload_seed_data('treatment_arm', ta_json, 'local')
  end
end
