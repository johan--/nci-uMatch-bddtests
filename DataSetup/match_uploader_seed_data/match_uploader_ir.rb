require 'json'
class MatchUploaderIR
  IR50_DATA_FILE = 'output/ir_50_data.json'
  IR52_DATA_FILE = 'output/ir_52_data.json'
  def self.deploy_ir50(name_list)
    all_jobs = JSON.parse(File.read(IR50_DATA_FILE))
    output = all_jobs.select{ |this_job| name_list.include?(this_job)}
    File.open(ENV['uploader_ir_50_location'], 'w') { |f| f.write(JSON.pretty_generate(output)) }
  end
  def self.deploy_ir52(name_list)
    all_jobs = JSON.parse(File.read(IR52_DATA_FILE))
    output = all_jobs.select{ |this_job| name_list.include?(this_job)}
    File.open(ENV['uploader_ir_52_location'], 'w') { |f| f.write(JSON.pretty_generate(output)) }
  end
  def self.deploy_all_ir50
    FileUtils.copy(IR50_DATA_FILE, ENV['uploader_ir_50_location'])
  end
  def self.deploy_all_ir52
    FileUtils.copy(IR52_DATA_FILE, ENV['uploader_ir_52_location'])
  end
end
