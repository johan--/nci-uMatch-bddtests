require_relative 'utilities'
require_relative 'logger'

class PatientStory
  SAVE_FILE_FOLDER = "#{File.dirname(__FILE__)}/../seed_patient_stories/"
  SAVE_FILE_PREFIX = 'seed_patient_story-'
  MAX_PATIENTS = 200
  DEFAULT_NEW = 'default_new'

  def self.all_patients
    result = []
    Dir["#{SAVE_FILE_FOLDER}*"].each do |file|
      hash = JSON.parse(File.read(file))
      result << hash.keys
    end
    result.flatten
  end

  def initialize(patient_id)
    @patient_id = patient_id
    @story_hash = []
    @file_path = lookup
    @active_sei = "#{@patient_id}_SEI0"
    @active_bd_moi = "#{@patient_id}_BD_MOI0"
    @active_ts_moi = "#{@patient_id}_MOI0"
    @active_bd_ani = "#{@patient_id}_BD_ANI0"
    @active_ts_ani = "#{@patient_id}_ANI0"
    @active_bc = "#{@patient_id}_BC0"
  end

  def full_story
    result = []
    load if @story_hash.empty?
    @story_hash.each { |string|
      this_step={}
      label = string.split(':<')[0]
      this_step[label]={}
      string.gsub("#{label}:", '').split('&').each { |v|
        pair = v.split('=>')
        this_step[label][pair[0]]=pair[1]
      }
      result << this_step
    }
    result
  end

  def create
    yield
    save
  end

  def exist?
    File.exist?(@file_path)
  end

  def lookup
    cmd = "grep -l -r #{@patient_id} #{SAVE_FILE_FOLDER}."
    `#{cmd}`.chop
  end

  def latest_save_file
    file = Dir["#{SAVE_FILE_FOLDER}*"].sort.last
    hash = JSON.parse(File.read(file))
    unless hash.keys.size < MAX_PATIENTS
      id = file.split(SAVE_FILE_PREFIX).last.gsub('.json', '').to_i+1
      id_string = id.to_s.rjust(2, '0')
      file = "#{SAVE_FILE_FOLDER}#{SAVE_FILE_PREFIX}#{id_string}.json"
      File.open(file, 'w') { |f| f.write('{}') }
    end
    file
  end

  def save
    @file_path = latest_save_file unless File.exist?(@file_path)
    file = JSON.parse(File.read(@file_path))
    raise "#{@file_path} is not an Hash" unless file.is_a?(Hash)
    file[@patient_id] = @story_hash
    File.open(@file_path, 'w') { |f| f.write(JSON.pretty_generate(file)) }
    Logger.log("#{@patient_id} has been written to file #{@file_path}")
  end

  def load
    if File.exist?(@file_path)
      file = JSON.parse(File.read(@file_path))
      raise "#{@file_path} is not an Hash" unless file.is_a?(Hash)
      @story_hash = file[@patient_id]
    end
  end

  def process_id(current_id, new_id)
    if new_id == DEFAULT_NEW
      increase_id(current_id)
    else
      new_id
    end
  end

  def increase_id(id_string)
    suffix = id_string.split('_').last
    parts = suffix.split(/(\d+)/)
    new_suffix = "#{parts[0]}#{parts[1].to_i+1}"
    id_string.gsub("_#{suffix}", "_#{new_suffix}")
  end

  def story_register(date='current')
    @step_number = '1.0'
    this_story = "registration:<patient_id>=>#{@patient_id}&<status_date>=>#{date}"
    @story_hash << this_story
  end

  def story_specimen_received_tissue(surgical_event_id = DEFAULT_NEW, collect_date='today')
    @active_sei = process_id(@active_sei, surgical_event_id)
    d = collect_date.include?(':') ? collect_date : "#{collect_date}T00:01:01+00:00"
    d = 'current' if collect_date == 'today'
    this_story = "specimen_received_TISSUE:<patient_id>=>#{@patient_id}&<surgical_event_id>=>#{@active_sei}"
    this_story += "&<collection_dt>=>#{collect_date}&<received_dttm>=>#{d}"
    @story_hash << this_story
  end

  def story_specimen_received_blood(collect_date='today')
    d = collect_date.include?(':') ? collect_date : "#{collect_date}T00:01:01+00:00"
    d = 'current' if collect_date == 'today'
    this_story = "specimen_received_BLOOD:<patient_id>=>#{@patient_id}&"
    this_story += "<collection_dt>=>#{collect_date}&<received_dttm>=>#{d}"
    @story_hash << this_story
  end

  def story_specimen_shipped_tissue(molecular_id = DEFAULT_NEW, destination='MDA', shipped_time='current')
    @active_ts_moi = process_id(@active_ts_moi, molecular_id)
    this_story = "specimen_shipped_TISSUE:<patient_id>=>#{@patient_id}&<surgical_event_id>=>#{@active_sei}"
    this_story += "&<molecular_id>=>#{@active_ts_moi}&<shipped_dttm>=>#{shipped_time}&<destination>=>#{destination}"
    @story_hash << this_story
  end

  def story_specimen_shipped_slide(slide_barcode = DEFAULT_NEW, shipped_time='current')
    @active_bc = process_id(@active_bc, slide_barcode)
    this_story = "specimen_shipped_SLIDE:<patient_id>=>#{@patient_id}&<surgical_event_id>=>#{@active_sei}"
    this_story += "&<slide_barcode>=>#{@active_bc}&<shipped_dttm>=>#{shipped_time}"
    @story_hash << this_story
  end

  def story_specimen_shipped_blood(molecular_id = DEFAULT_NEW, destination='MDA', shipped_time='2016-05-01T19:42:13+00:00')
    @active_bd_moi = process_id(@active_bd_moi, molecular_id)
    this_story = "specimen_shipped_BLOOD:<patient_id>=>#{@patient_id}&"
    this_story += "<molecular_id>=>#{@active_bd_moi}&<shipped_dttm>=>#{shipped_time}&<destination>=>#{destination}"
    @story_hash << this_story
  end

  def story_assay(biomarker, result='POSITIVE', reported_date='current')
    this_story = "assay_result_reported:<patient_id>=>#{@patient_id}&<surgical_event_id>=>#{@active_sei}"
    this_story += "&<biomarker>=>#{biomarker}&<result>=>#{result}&<reported_date>=>#{reported_date}"
    @story_hash << this_story
  end

  def story_tissue_variant_report(analysis_id = DEFAULT_NEW, vr_type='default', site='mda', folder='bdd_test_ion_reporter')
    @active_ts_ani = process_id(@active_ts_ani, analysis_id)
    Utilities.upload_vr(@active_ts_moi, @active_ts_ani, vr_type)
    this_story = "aliquot:<patient_id>=>#{@patient_id}&<ion_reporter_id>=>#{folder}"
    this_story += "&<analysis_id>=>#{@active_ts_ani}&<molecular_id>=>#{@active_ts_moi}&<site>=>#{site}"
    @story_hash << this_story
  end

  def story_blood_variant_report(analysis_id = DEFAULT_NEW, vr_type='default', site='mda', folder='bdd_test_ion_reporter')
    @active_bd_ani = process_id(@active_bd_ani, analysis_id)
    Utilities.upload_vr(@active_bd_moi, @active_bd_ani, vr_type)
    this_story = "aliquot:<patient_id>=>#{@patient_id}&<ion_reporter_id>=>#{folder}"
    this_story += "&<analysis_id>=>#{@active_bd_ani}&<molecular_id>=>#{@active_bd_moi}&<site>=>#{site}"
    @story_hash << this_story
  end

  def story_file_uploaded_cdna(analysis_id, cdna_bam_name='cdna.bam', comment_user='qa')
    @active_ts_ani = analysis_id
    this_story = "variant_cdna_file_uploaded:<patient_id>=>#{@patient_id}&<cdna_bam_name>=>#{cdna_bam_name}"
    this_story += "&<analysis_id>=>#{analysis_id}&<molecular_id>=>#{@active_ts_moi}&<comment_user>=>#{comment_user}"
    @story_hash << this_story
  end

  def story_file_uploaded_dna(analysis_id, dna_bam_name='dna.bam', comment_user='qa')
    @active_ts_ani = analysis_id
    this_story = "variant_dna_file_uploaded:<patient_id>=>#{@patient_id}&<dna_bam_name>=>#{dna_bam_name}"
    this_story += "&<analysis_id>=>#{analysis_id}&<molecular_id>=>#{@active_ts_moi}&<comment_user>=>#{comment_user}"
    @story_hash << this_story
  end

  def story_variant_file_confirmed(status='confirm', comment='Test', comment_user='QA')
    this_story = "variant_report_confirmed:<patient_id>=>#{@patient_id}&"
    this_story += "<analysis_id>=>#{@active_ts_ani}&<status>=>#{status}"
    this_story += "&<comment>=>#{comment}&<comment_user>=>#{comment_user}"
    @story_hash << this_story
  end

  def story_assignment_confirmed(comment='Test', comment_user='QA')
    this_story = "assignment_confirmed:<patient_id>=>#{@patient_id}&<analysis_id>=>#{@active_ts_ani}"
    this_story += "&<comment>=>#{comment}&<comment_user>=>#{comment_user}"
    @story_hash << this_story
  end

  def story_off_study(status_date='current')
    this_story = "off_study:<patient_id>=>#{@patient_id}&<step_number>=>#{@step_number}"
    this_story += "&<status_date>=>#{status_date}&<status>=>OFF_STUDY"
    @story_hash << this_story
  end

  def story_off_study_biopsy_expired(status_date='current')
    this_story = "off_study:<patient_id>=>#{@patient_id}&<step_number>=>#{@step_number}"
    this_story += "&<status_date>=>#{status_date}&<status>=>OFF_STUDY_BIOPSY_EXPIRED"
    @story_hash << this_story
  end


  def story_request_assignment(rebiopsy, step_number='2.0', status_date='current')
    @step_number = step_number
    this_story = "request_assignment:<patient_id>=>#{@patient_id}&<step_number>=>#{step_number}"
    this_story += "&<status_date>=>#{status_date}"
    this_story += "&<status>=>REQUEST_ASSIGNMENT&<rebiopsy>=>#{rebiopsy}"
    @story_hash << this_story
  end


  def story_request_no_assignment(step_number='2.0', status_date='current')
    @step_number = step_number
    this_story = "request_assignment:<patient_id>=>#{@patient_id}&<step_number>=>#{@step_number}"
    this_story += "&<status_date>=>#{status_date}&<status>=>REQUEST_NO_ASSIGNMENT&<rebiopsy>=>N"
    @story_hash << this_story
  end

  def story_on_treatment_arm(treatment_arm_id, stratum_id, status_date='current')
    @step_number = (@step_number.to_i + 0.1).to_s
    this_story = "on_treatment_arm:<patient_id>=>#{@patient_id}&<step_number>=>#{@step_number}"
    this_story += "&<status_date>=>#{status_date}"
    this_story += "&<treatment_arm_id>=>#{treatment_arm_id}&<stratum_id>=>#{stratum_id}"
    @story_hash << this_story
  end

  private :lookup, :latest_save_file, :load
end