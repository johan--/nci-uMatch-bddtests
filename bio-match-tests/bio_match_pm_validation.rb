require_relative '../DataSetup/patient_message_loader'
require_relative '../DataSetup/match_test_data_manager'
require_relative '../DataSetup/dynamo_utilities'
require_relative '../DataSetup/sqs_utilities'

class BioMatchPMValidation
  ION_REPORTER='bio-match-test'
  PATIENT_URL='http://127.0.0.1:10240/api/v1/patients'
  RULE_URL='http://127.0.0.1:10250/api/v1/rules'
  TA_URL='http://127.0.0.1:10235/api/v1/treatment_arms'
  NO_TA='No treatment arm selected'

  def self.test(patient_id, expect_ta_id='', expect_ta_stratum='')
    build_patient(patient_id)
    verify_result(patient_id, expect_ta_id, expect_ta_stratum)
  end

  def self.build_patient(patient_id)
    Environment.setTier('local')
    load_treatment_arms
    pt = PatientDataSet.new(patient_id)
    convert_vcf_to_tsv(pt.id)
    upload_files_to_s3(pt.id, pt.moi, pt.ani)
    generate_variant_report(pt.id, pt.moi, pt.ani)
    generate_assignment(pt.id)
  end

  def self.verify_result(patient_id, expect_ta_id='', expect_ta_stratum='')
    result = Hash.new
    result['test_case'] = "#{patient_id}"
    if @generated_ar['report_status'] == 'TREATMENT_FOUND'
      selected = @generated_ar['treatment_assignment_results'].select { |this_ta|
        this_ta['assignment_status'] == 'SELECTED' }
      if selected.size == 1
        @actual_ta = "#{selected[0]['treatment_arm_id']} (#{selected[0]['stratum_id']})"
      else
        @actual_ta = ''
        selected.each { |this_selected|
          @actual_ta += "#{this_selected[0]['treatment_arm_id']} (#{this_selected[0]['stratum_id']}) " }
      end
    else
      @actual_ta = NO_TA
    end
    if expect_ta_id.eql?('')||expect_ta_stratum.eql?('')
      expect_ta = NO_TA
    else
      expect_ta = "#{expect_ta_id} (#{expect_ta_stratum})"
    end
    test_result = @actual_ta.eql?(expect_ta) ? 'Passed' : 'Failed'
    result['test_result'] = test_result
    result['expected_treatment_arm'] = expect_ta
    result['actual_treatment_arm'] = @actual_ta
    File.open("#{File.dirname(__FILE__)}/results/#{patient_id}.json", 'w') { |f| f.write(JSON.pretty_generate(result)) }
  end

  def self.convert_vcf_to_tsv(patient_id)
    vcf = "#{File.dirname(__FILE__)}/vcfs/#{patient_id}.vcf"
    tsv = "#{File.dirname(__FILE__)}/tsv/#{patient_id}.tsv"
    puts "Converting #{vcf} to #{tsv} ..."
    cmd = "rm -f #{tsv}"
    `#{cmd}`
    cmd = "python #{File.dirname(__FILE__)}/convert_vcf.py -i #{vcf} -o #{tsv}"
    `#{cmd}`
    sleep 10.0
    if File.exist?("#{File.dirname(__FILE__)}/tsv/#{patient_id}.tsv")
      puts "#{tsv} is created successfully!"
    else
      @actual_ta = "Cannot convert vcf file: #{File.dirname(__FILE__)}/vcfs/#{patient_id}.vcf"
    end
  end

  def self.upload_files_to_s3(patient_id, moi, ani)
    tsv_path = "#{File.dirname(__FILE__)}/tsv/#{patient_id}.tsv"
    vcf_path = "#{File.dirname(__FILE__)}/vcfs/#{patient_id}.vcf"
    tmp_folder = "#{File.dirname(__FILE__)}/upload_tmp/#{moi}/#{ani}"
    tmp_root_folder = "#{File.dirname(__FILE__)}/upload_tmp"
    cmd = "mkdir -p #{tmp_folder}"
    puts `#{cmd}`
    cmd = "cp #{tsv_path} #{tmp_folder}"
    puts `#{cmd}`
    cmd = "cp #{vcf_path} #{tmp_folder}"
    puts `#{cmd}`
    cmd = "aws s3 cp #{tmp_root_folder} s3://pedmatch-dev/#{ION_REPORTER}/ --recursive --region us-east-1"
    `#{cmd}`
    cmd = "rm -r -f #{File.dirname(__FILE__)}/upload_tmp"
    `#{cmd}`
    puts "#{patient_id} vcf and tsv have been uploaded to S3"
    sleep 10.0
  end

  def self.load_treatment_arms
    @treatment_arms = JSON.parse(File.read("#{File.dirname(__FILE__)}/treatment_arms.json"))
  end

  def self.generate_variant_report(patient_id, moi, ani)
    url = "#{RULE_URL}/variant_report/#{patient_id}/#{ION_REPORTER}/#{moi}/#{ani}/#{patient_id}"
    @generated_vr = JSON.parse(Helper_Methods.post_request(url, @treatment_arms.to_json)['message'])
  end

  def self.generate_assignment(patient_id)
    url = "#{RULE_URL}/assignment_report/#{patient_id}"
    patient = JSON.parse(File.read("#{File.dirname(__FILE__)}/patients/#{patient_id}.json"))
    patient['patient_id'] = patient_id
    patient['snv_indels'] = @generated_vr['snv_indels']
    patient['copy_number_variants'] = @generated_vr['copy_number_variants']
    patient['gene_fusions'] = @generated_vr['gene_fusions']
    payload = {:treatment_arms => @treatment_arms,
               :study_id => 'APEC1621SC',
               :patient => patient}
    @generated_ar = JSON.parse(Helper_Methods.post_request(url, payload.to_json)['message'])
  end
end

BioMatchPMValidation.test('test_case_PM_TA_A1_1')


