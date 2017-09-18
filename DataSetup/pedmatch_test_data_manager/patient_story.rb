require_relative 'utilities'
require_relative 'log'
require_relative 'general_story'

class PatientStory < GeneralStory
  DEFAULT_NEW = 'default_new'
  DEFAULT_ACTIVE = 'default_active'


  def initialize(patient_id)
    super(patient_id, 'ped-match')
    @active_sei = "#{@patient_id}_SEI0"
    @active_bd_moi = "#{@patient_id}_BD_MOI0"
    @active_ts_moi = "#{@patient_id}_MOI0"
    @active_bd_ani = "#{@patient_id}_BD_ANI0"
    @active_ts_ani = "#{@patient_id}_ANI0"
    @active_bc = "#{@patient_id}_BC0"
    @step_number = '1.0'
  end

  def patient_id
    @data_id
  end

  def process_id(current_id, new_id)
    if new_id == DEFAULT_NEW
      increase_id(current_id)
    elsif new_id == DEFAULT_ACTIVE
      current_id
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
    this_story = {operation: 'registration'}
    this_story['parameters'] = {'<patient_id>': @data_id, '<status_date>': date}
    @story_hash << this_story
  end

  def story_specimen_received_tissue(collect_date='today', surgical_event_id = DEFAULT_NEW)
    @active_sei = process_id(@active_sei, surgical_event_id)
    d = collect_date.include?(':') ? collect_date : "#{collect_date}T00:01:01+00:00"
    d = 'current' if collect_date == 'today'
    this_story = {operation: 'specimen_received_TISSUE'}
    this_story['parameters'] = {
        '<patient_id>': @data_id,
        '<surgical_event_id>': @active_sei,
        '<collection_dt>': collect_date,
        '<received_dttm>': d
    }
    @story_hash << this_story
  end

  def story_specimen_received_blood(collect_date='today')
    d = collect_date.include?(':') ? collect_date : "#{collect_date}T00:01:01+00:00"
    d = 'current' if collect_date == 'today'
    this_story = {operation: 'specimen_received_TISSUE'}
    this_story['parameters'] = {
        '<patient_id>': @data_id,
        '<collection_dt>': collect_date,
        '<received_dttm>': d
    }
    @story_hash << this_story
  end

  def story_specimen_shipped_tissue(destination='MDA',
                                    shipped_time='current',
                                    molecular_id = DEFAULT_NEW,
                                    surgical_event_id = DEFAULT_ACTIVE)
    @active_ts_moi = process_id(@active_ts_moi, molecular_id)
    @active_site = destination
    sei = process_id(@active_sei, surgical_event_id)
    this_story = {operation: 'specimen_shipped_TISSUE'}
    this_story['parameters'] = {
        '<patient_id>': @data_id,
        '<surgical_event_id>': sei,
        '<molecular_id>': @active_ts_moi,
        '<shipped_dttm>': shipped_time,
        '<destination>': destination
    }
    @story_hash << this_story
  end

  def story_specimen_shipped_slide(shipped_time='current',
                                   slide_barcode = DEFAULT_NEW,
                                   surgical_event_id = DEFAULT_ACTIVE)
    @active_bc = process_id(@active_bc, slide_barcode)
    sei = process_id(@active_sei, surgical_event_id)
    this_story = {operation: 'specimen_shipped_SLIDE'}
    this_story['parameters'] = {
        '<patient_id>': @data_id,
        '<surgical_event_id>': sei,
        '<slide_barcode>': @active_bc,
        '<shipped_dttm>': shipped_time
    }
    @story_hash << this_story
  end

  def story_specimen_shipped_blood(destination='MDA', shipped_time='current', molecular_id = DEFAULT_NEW)
    @active_bd_moi = process_id(@active_bd_moi, molecular_id)
    @active_site = destination
    this_story = {operation: 'specimen_shipped_BLOOD'}
    this_story['parameters'] = {
        '<patient_id>': @data_id,
        '<molecular_id>': @active_bd_moi,
        '<shipped_dttm>': shipped_time,
        '<destination>': destination
    }
    @story_hash << this_story
  end

  def story_assay(biomarker, result='POSITIVE', reported_date='current', surgical_event_id = DEFAULT_ACTIVE)
    sei = process_id(@active_sei, surgical_event_id)
    this_story = {operation: 'assay_result_reported'}
    this_story['parameters'] = {
        '<patient_id>': @data_id,
        '<surgical_event_id>': sei,
        '<biomarker>': biomarker,
        '<result>': result,
        '<reported_date>': reported_date
    }
    @story_hash << this_story
  end

  def story_tissue_variant_report(vr_type='default',
                                  folder='bdd_test_ion_reporter',
                                  process_bams=true,
                                  analysis_id = DEFAULT_NEW,
                                  molecular_id=DEFAULT_ACTIVE,
                                  site=DEFAULT_ACTIVE)
    @active_ts_ani = process_id(@active_ts_ani, analysis_id)
    moi = process_id(@active_ts_moi, molecular_id)
    site = process_id(@active_site, site)
    this_story = {operation: 'aliquot'}
    this_story['parameters'] = {
        '<patient_id>': @data_id,
        '<ion_reporter_id>': folder,
        '<vr_type>': vr_type,
        '<analysis_id>': @active_ts_ani,
        '<molecular_id>': moi,
        '<site>': site
    }
    @story_hash << this_story
    if process_bams
      story_file_uploaded_dna(@active_ts_ani)
      story_file_uploaded_cdna(@active_ts_ani)
    end
  end

  def story_blood_variant_report(vr_type='blood_vr',
                                 folder='bdd_test_ion_reporter',
                                 process_bams=true,
                                 analysis_id = DEFAULT_NEW,
                                 molecular_id=DEFAULT_ACTIVE,
                                 site=DEFAULT_ACTIVE)
    @active_bd_ani = process_id(@active_bd_ani, analysis_id)
    moi = process_id(@active_bd_moi, molecular_id)
    site = process_id(@active_site, site)
    this_story = {operation: 'aliquot'}
    this_story['parameters'] = {
        '<patient_id>': @data_id,
        '<ion_reporter_id>': folder,
        '<vr_type>': vr_type,
        '<analysis_id>': @active_bd_ani,
        '<molecular_id>': moi,
        '<site>': site
    }
    @story_hash << this_story
    if process_bams
      story_file_uploaded_dna(@active_bd_ani)
      story_file_uploaded_cdna(@active_bd_ani)
    end
  end

  def story_file_uploaded_cdna(analysis_id, cdna_bam_name='cdna.bam', comment_user='qa', molecular_id=DEFAULT_ACTIVE)
    @active_ts_ani = analysis_id
    moi = process_id(@active_ts_moi, molecular_id)
    this_story = {operation: 'variant_cdna_file_uploaded'}
    this_story['parameters'] = {
        '<patient_id>': @data_id,
        '<cdna_bam_name>': cdna_bam_name,
        '<analysis_id>': analysis_id,
        '<molecular_id>': moi,
        '<comment_user>': comment_user
    }
    @story_hash << this_story
  end

  def story_file_uploaded_dna(analysis_id, dna_bam_name='dna.bam', comment_user='qa', molecular_id=DEFAULT_ACTIVE)
    @active_ts_ani = analysis_id
    moi = process_id(@active_ts_moi, molecular_id)
    this_story = {operation: 'variant_dna_file_uploaded'}
    this_story['parameters'] = {
        '<patient_id>': @data_id,
        '<dna_bam_name>': dna_bam_name,
        '<analysis_id>': analysis_id,
        '<molecular_id>': moi,
        '<comment_user>': comment_user
    }
    @story_hash << this_story
  end

  def story_tissue_vr_confirmed(status='confirm', comment='Test', comment_user='QA', analysis_id=DEFAULT_ACTIVE)
    ani = process_id(@active_ts_ani, analysis_id)
    this_story = {operation: 'variant_report_confirmed'}
    this_story['parameters'] = {
        '<patient_id>': @data_id,
        '<analysis_id>': ani,
        '<status>': status,
        '<comment>': comment,
        '<comment_user>': comment_user
    }
    @story_hash << this_story
  end

  def story_blood_vr_confirmed(status='confirm', comment='Test', comment_user='QA', analysis_id=DEFAULT_ACTIVE)
    ani = process_id(@active_bd_ani, analysis_id)
    this_story = {operation: 'variant_report_confirmed'}
    this_story['parameters'] = {
        '<patient_id>': @data_id,
        '<analysis_id>': ani,
        '<status>': status,
        '<comment>': comment,
        '<comment_user>': comment_user
    }
    @story_hash << this_story
  end

  def story_assignment_confirmed(comment='Test', comment_user='QA', analysis_id=DEFAULT_ACTIVE)
    ani = process_id(@active_ts_ani, analysis_id)
    this_story = {operation: 'assignment_confirmed'}
    this_story['parameters'] = {
        '<patient_id>': @data_id,
        '<analysis_id>': ani,
        '<comment>': comment,
        '<comment_user>': comment_user
    }
    @story_hash << this_story
  end

  def story_off_study(status_date='current', step_number=DEFAULT_ACTIVE)
    step = process_id(@step_number, step_number)
    this_story = {operation: 'off_study'}
    this_story['parameters'] = {
        '<patient_id>': @data_id,
        '<step_number>': step,
        '<status_date>': status_date,
        '<status>': 'OFF_STUDY'
    }
    @story_hash << this_story
  end

  def story_off_study_biopsy_expired(status_date='current', step_number=DEFAULT_ACTIVE)
    step = process_id(@step_number, step_number)
    this_story = {operation: 'off_study'}
    this_story['parameters'] = {
        '<patient_id>': @data_id,
        '<step_number>': step,
        '<status_date>': status_date,
        '<status>': 'OFF_STUDY_BIOPSY_EXPIRED'
    }
    @story_hash << this_story
  end


  def story_request_assignment(rebiopsy, step_number, status_date='current')
    @step_number = step_number
    this_story = {operation: 'request_assignment'}
    this_story['parameters'] = {
        '<patient_id>': @data_id,
        '<step_number>': step_number,
        '<status_date>': status_date,
        '<status>': 'REQUEST_ASSIGNMENT',
        '<rebiopsy>': rebiopsy
    }
    @story_hash << this_story
  end


  def story_request_no_assignment(step_number=DEFAULT_ACTIVE, status_date='current')
    @step_number = process_id(@step_number, step_number)
    this_story = {operation: 'request_assignment'}
    this_story['parameters'] = {
        '<patient_id>': @data_id,
        '<step_number>': @step_number,
        '<status_date>': status_date,
        '<status>': 'REQUEST_NO_ASSIGNMENT',
        '<rebiopsy>': 'N'
    }
    @story_hash << this_story
  end

  def story_on_treatment_arm(treatment_arm_id, stratum_id, status_date='current', step_number=DEFAULT_ACTIVE)
    @step_number = (@step_number.to_i + 0.1).to_s
    step = process_id(@step_number, step_number)
    this_story = {operation: 'on_treatment_arm'}
    this_story['parameters'] = {
        '<patient_id>': @data_id,
        '<step_number>': step,
        '<status_date>': status_date,
        '<treatment_arm_id>': treatment_arm_id,
        '<stratum_id>': stratum_id
    }
    @story_hash << this_story
  end

  # SAVE_FILE_FOLDER = "#{File.dirname(__FILE__)}/seed_patient_stories"
  #
  # def self.convert_to_dynamodb
  #   count = 0
  #   Dir["#{SAVE_FILE_FOLDER}/*"].each do |file|
  #     puts "processing seed story file #{file}"
  #     hashes = JSON.parse(File.read(file))
  #     hashes.each do |pt_id, stories|
  #       puts "processing patient #{pt_id}"
  #       s = []
  #       stories.each do |story|
  #         parts = story.split(':')
  #         op = parts[0]
  #         params = {}
  #         parts = parts[1].split('&')
  #         parts.each do |part|
  #           p = part.split('=>')
  #           params[p[0]]=p[1]
  #         end
  #         s << {
  #             operation: op,
  #             parameters: params
  #         }
  #       end
  #       item = {
  #           data_id: pt_id,
  #           project: "ped-match",
  #           story: s
  #       }
  #       Utilities.dynamodb_put_item(item, STORY_TABLE)
  #       count+=1
  #     end
  #
  #   end
  #   puts "#{count} patients are processed"
  # end

  private :process_id, :increase_id
end