require 'sqlite3'
require 'json'
require 'fileutils'

class MatchUploaderDB
  BACKUP_FILE = 'input/development_blank_backup.sqlite3'
  OUTPUT_FILE = 'output/development.sqlite3'
  DATA_JSON = 'input/db_data.json'

  def self.deploy
    build_sqlite3
    FileUtils.copy(OUTPUT_FILE, ENV['uploader_db_location'])
  end

  def self.build_sqlite3
    clear
    items = JSON.parse(File.read(DATA_JSON))
    items.each { |this_item| add_item(this_item) }
  end

  def self.clear
    FileUtils.copy(BACKUP_FILE, OUTPUT_FILE)
  end

  def self.add_item(item)
    db = SQLite3::Database.new OUTPUT_FILE
    db.execute(
        "insert into analysis_jobs #{insert_string(item)}"
    )
    db.close
  end

  def self.insert_string(hash)
    columns = []
    values = []
    hash.each { |k, v|
      columns << k
      values << "'#{v}'"
    }
    "(#{columns.join(', ')}) values (#{values.join(', ')})"
  end

  def self.get_by_name(name)
    db = SQLite3::Database.new OUTPUT_FILE
    x = db.execute(
        "select * from analysis_jobs where name=#{name}"
    )
    db.close
    wrap_record(x)
  end

  def self.list_all
    db = SQLite3::Database.new OUTPUT_FILE
    x = db.execute(
        'select * from analysis_jobs'
    )
    db.close
    x.collect! { |this_record| wrap_record(this_record) }
  end

  def self.wrap_record(record=[])
    result = {}
    record.each_with_index { |v, i|
      result[schema[i]] = v
    }
    result
  end

  def self.schema
    result = []
    result << 'id'
    result << 'name'
    result << 'analysis_id'
    result << 'status'
    result << 'molecular_sequence_number'
    result << 'start_date'
    result << 'sample_name'
    result << 'dna_bam_file_dir'
    result << 'rna_bam_file_dir'
    result << 'dna_bam_filename'
    result << 'rna_bam_filename'
    result << 'unfiltered_variants_zipfile'
    result << 'status_log'
    result << 'created_at'
    result << 'updated_at'
    result << 'study_type'
    result << 'patient_id'
    result << 'dna_file_upload_status'
    result << 'dna_file_upload_name'
    result << 'rna_file_upload_status'
    result << 'rna_file_upload_name'
    result << 'zip_file_upload_status'
    result << 'zip_file_upload_name'
  end
end
MatchUploaderDB.clear
MatchUploaderDB.build_sqlite3
puts JSON.pretty_generate(MatchUploaderDB.list_all)
