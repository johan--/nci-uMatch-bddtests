require 'json'
require 'active_support'
require 'active_support/core_ext'
require_relative 'logger'
require 'roo'


class Xlsx
  def initialize(path)
    @xlsx = Roo::Spreadsheet.open(path)
  end

  def row_hash(sheet_id, key_column, value_column, range = (1..100000), key_mapping_hash={})
    sheet = @xlsx.sheet(sheet_id)
    result = {}
    range.each do |row_id|
      next unless sheet.cell(key_column, row_id).present?
      converted_key = sheet.cell(key_column, row_id).strip
      converted_key = key_mapping_hash[converted_key] if key_mapping_hash.has_key?(converted_key)
      result[converted_key] = sheet.cell(value_column, row_id)
    end
    result
  end

  def table_hashes(sheet_id, title_row, key_mapping_hash={})
    sheet = @xlsx.sheet(sheet_id)
    keys = sheet.row(title_row)
    result = []
    i = title_row
    while true
      i += 1
      this_row = sheet.row(i)
      break unless this_row.any? { |a| !a.nil? && a.size>0 }
      obj = {}
      keys.each_with_index do |key, id|
        converted_key = key.strip
        converted_key =key_mapping_hash[converted_key] if key_mapping_hash.has_key?(converted_key)
        obj[converted_key] = this_row[id] if key.present?
      end
      result << obj
    end
    result
  end

  def first_occurrence_row(sheet_id, key_word)
    sheet = @xlsx.sheet(sheet_id)
    result = 0
    found = false
    while result<sheet.last_row
      result += 1
      this_row = sheet.row(result)
      if this_row.include?(key_word)
        found = true
        break
      end
    end
    result = -1 unless found
    result
  end

  def sheets
    @xlsx.sheets
  end
end