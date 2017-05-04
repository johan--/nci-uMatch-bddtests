require_relative '../DataSetup/patient_message_loader'
require_relative '../DataSetup/match_test_data_manager'
require_relative '../DataSetup/dynamo_utilities'
require_relative '../DataSetup/sqs_utilities'

class BioMatchPMQuickValidation
  NO_TA='No treatment arm selected'


  def initialize(tier)
    if tier.downcase == 'local'
      @ion_reporter='bio-match-test'
      @patient_url='http://127.0.0.1:10240/api/v1/patients'
      @treatment_arm_url='http://127.0.0.1:10235/api/v1/treatment_arms'
      @rule_url='http://127.0.0.1:10250/api/v1/rules'
      @ta_url='http://127.0.0.1:10235/api/v1/treatment_arms'
      @s3_bucket='pedmatch-dev'
    elsif tier.downcase == 'uat'
      @ion_reporter='bio-match-test'
      @patient_url='https://pedmatch-uat.nci.nih.gov/api/v1/patients'
      @treatment_arm_url='https://pedmatch-uat.nci.nih.gov/api/v1/treatment_arms'
      @rule_url='https://pedmatch-uat.nci.nih.gov/api/v1/rules'
      @ta_url='https://pedmatch-uat.nci.nih.gov/api/v1/treatment_arms'
      @s3_bucket='pedmatch-uat'
    else
      raise 'tier value can only by local or uat'
    end
  end
  
  def test(test_id)
    load_test(test_id)
    build_patient
    verify_result
  end

  def load_test(test_id)
    @patient_hash = JSON.parse(File.read("#{File.dirname(__FILE__)}/patients/#{test_id}.json"))
    @expect_ta = ta_string(@patient_hash['expected_treatment_arm_id'], @patient_hash['expected_stratum_id'])
    @pten = @patient_hash['pten_status']
    @baf47 = @patient_hash['baf47_status']
    @brg1 = @patient_hash['brg1_status']
    @patient_id = test_id
    @patient_hash['patient_id'] = @patient_id
    @treatment_arms = JSON.parse(File.read("#{File.dirname(__FILE__)}/treatment_arms.json"))
    @patient_hash['treatment_arm_statuses'].each { |this_status|
      @treatment_arms.each { |this_ta|
        if this_ta['treatment_arm_id'] == this_status['treatment_arm_id'] &&
            this_ta['stratum_id'] == this_status['stratum_id']
          this_ta['treatment_arm_status'] = this_status['status']
        end
      } }
  end

  def build_patient
    Environment.setTier('local')
    pt = PatientDataSet.new(@patient_id)
    convert_vcf_to_tsv(pt.id)
    upload_files_to_s3(pt.id, pt.moi, pt.ani)
    generate_variant_report(pt.id, pt.moi, pt.ani)
    generate_assignment(pt.id)
  end

  def verify_result
    result = Hash.new
    result['test_case'] = "#{@patient_id}"
    if @generated_ar.keys.include?('report_status')
      if @generated_ar['report_status'] == 'TREATMENT_FOUND'
        selected = @generated_ar['treatment_assignment_results'].select { |this_ta|
          this_ta['assignment_status'] == 'SELECTED' }
        if selected.size == 1
          @actual_ta = ta_string(selected[0]['treatment_arm_id'], selected[0]['stratum_id'])
        else
          @actual_ta = ''
          selected.each { |this_selected|
            @actual_ta += ta_string(this_selected[0]['treatment_arm_id'], this_selected[0]['stratum_id']) + ' '}
        end
      else
        @actual_ta = NO_TA
      end
    end
    test_result = @actual_ta.eql?(@expect_ta) ? 'Passed' : 'Failed'
    result['test_result'] = test_result
    result['expected_treatment_arm'] = @expect_ta
    result['actual_treatment_arm'] = @actual_ta
    File.open("#{File.dirname(__FILE__)}/results/#{@patient_id}.json", 'w') { |f| f.write(JSON.pretty_generate(result)) }
    File.open("#{File.dirname(__FILE__)}/results/#{@patient_id}_Assignment_report.json", 'w') { |f| f.write(JSON.pretty_generate(@generated_ar)) }
    File.open("#{File.dirname(__FILE__)}/results/#{@patient_id}_Variant_report.json", 'w') { |f| f.write(JSON.pretty_generate(@generated_vr)) }

  end

  def ta_string(ta_id, stratum)
    if ta_id.eql?('')||stratum.eql?('')
      return NO_TA
    else
      return "#{ta_id} (#{stratum})"
    end
  end

  def convert_vcf_to_tsv(patient_id)
    vcf = "#{File.dirname(__FILE__)}/vcfs/#{patient_id}.vcf"
    tsv = "#{File.dirname(__FILE__)}/tsv/#{patient_id}.tsv"
    puts "Converting #{vcf} to #{tsv} ..."
    cmd = "rm -f #{tsv}"
    `#{cmd}`
    cmd = "python #{File.dirname(__FILE__)}/convert_vcf.py -i #{vcf} -o #{tsv}"
    `#{cmd}`
    if File.exist?("#{File.dirname(__FILE__)}/tsv/#{patient_id}.tsv")
      puts "#{tsv} is created successfully!"
    else
      @actual_ta = "Cannot convert vcf file: #{File.dirname(__FILE__)}/vcfs/#{patient_id}.vcf"
    end
  end

  def upload_files_to_s3(patient_id, moi, ani)
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
    cmd = "aws s3 cp #{tmp_root_folder} s3://#{@s3_bucket}/#{@ion_reporter}/ --recursive --region us-east-1"
    `#{cmd}`
    cmd = "rm -r -f #{File.dirname(__FILE__)}/upload_tmp"
    `#{cmd}`
    puts "#{patient_id} vcf and tsv have been uploaded to S3"
  end

  def generate_variant_report(patient_id, moi, ani)
    url = "#{@rule_url}/variant_report/#{patient_id}/#{@ion_reporter}/#{moi}/#{ani}/#{patient_id}"
    response = Helper_Methods.post_request(url, @treatment_arms.to_json)
    if response['http_code'] == '200'
      @generated_vr = JSON.parse(response['message'])
    else
      @generated_vr = {}
      @actual_ta = "Rule engine cannot generate variant report for patient #{patient_id}"
    end
  end

  def generate_assignment(patient_id)
    if @generated_vr.size<1
      @generated_ar = {}
      return
    end
    url = "#{@rule_url}/assignment_report/#{patient_id}"
    patient = JSON.parse(File.read("#{File.dirname(__FILE__)}/patients/#{patient_id}.json"))
    patient['patient_id'] = patient_id
    patient['snv_indels'] = @generated_vr['snv_indels']
    patient['copy_number_variants'] = @generated_vr['copy_number_variants']
    patient['gene_fusions'] = @generated_vr['gene_fusions']
    payload = {:treatment_arms => @treatment_arms,
               :study_id => 'APEC1621SC',
               :patient => patient}
    response = Helper_Methods.post_request(url, payload.to_json)
    if response['http_code'] == '200'
      @generated_ar = JSON.parse(response['message'])
    else
      @generated_ar = nil
      @actual_ta = "Rule engine cannot generate assignment report for patient #{patient_id}"
    end
  end
  def clear_database
    MatchTestDataManager.clear_all_local_tables
  end
  def update_treatment_arms
    Environment.setTier('local')
    url = "#{@treatment_arm_url}"
    tas = Helper_Methods.simple_get_request(url)['message_json']
    File.open("#{File.dirname(__FILE__)}/results/#{patient_id}.json", 'w') { |f| f.write(JSON.pretty_generate(tas)) }
    puts "#{File.dirname(__FILE__)}/results/#{patient_id}.json is updated"
    puts "#{tas.size} treatment arms in this file, they are:"
    tas.each { |this_ta| puts "#{this_ta['treatment_arm_id']} (#{this_ta[0]['stratum_id']})"}
  end
end