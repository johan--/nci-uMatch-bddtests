require_relative 'helper_methods'

class UploaderHelperMethods
  IR50_DATA_FILE ||= '../../../../DataSetup/match_uploader_seed_data/output/ir_50_data.json'
  IR52_DATA_FILE ||= '../../../../DataSetup/match_uploader_seed_data/output/ir_52_data.json'

  def self.deploy_uploader

  end

  def self.set_config(field, value)
    field_full_name = "configatron.#{field}"
    text = File.open(ENV['uploader_config_location']).read
    text.gsub!(/\r\n?/, "\n")
    text.each_line do |line|
      this_line = line.gsub(' ', '')
      if this_line.starts_with?("#{field_full_name}=")
        text.gsub!(line, "#{field_full_name}=\"#{value}\"\n")
        break
      end
    end
    File.open(ENV['uploader_config_location'], 'w') { |f| f.write(text) }
  end


  def self.update_database(id, data_hash)

  end

  def self.get_database(id, criteria={})

  end

  def self.run_heartbeat
    # cmd = "cd /Users/wangl17/match_apps/nci-match-uploader && bundle exec rails runner Heartbeat.send && cd -"
    # puts `#{cmd}`
  end

  def self.run_job_watcher

    # bundle exec rails runner JobWatcher.runIRSummaryReport
  end

  def self.deploy_ir50(name_list)
    all_jobs = JSON.parse(File.read(IR50_DATA_FILE))
    output = all_jobs.select { |this_job| name_list.include?(this_job) }
    File.open(ENV['mock_ir_50_location'], 'w') { |f| f.write(JSON.pretty_generate(output)) }
  end

  def self.deploy_ir52(name_list)
    all_jobs = JSON.parse(File.read(IR52_DATA_FILE))
    output = all_jobs.select { |this_job| name_list.include?(this_job) }
    File.open(ENV['mock_ir_52_location'], 'w') { |f| f.write(JSON.pretty_generate(output)) }
  end

  def self.deploy_all_ir50
    FileUtils.copy(IR50_DATA_FILE, ENV['mock_ir_50_location'])
  end

  def self.deploy_all_ir52
    FileUtils.copy(IR52_DATA_FILE, ENV['mock_ir_52_location'])
  end
end

UploaderHelperMethods.run_heartbeat