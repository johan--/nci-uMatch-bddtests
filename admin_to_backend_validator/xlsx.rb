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
      converted_key = sheet.cell(key_column, row_id).downcase.strip
      if key_mapping_hash.has_key?(converted_key)
        converted_key = key_mapping_hash[converted_key]
        value = sheet.cell(value_column, row_id)
        converted_key, value = special_key_value(converted_key, value)
        result[converted_key] = value
      end
    end
    result
  end

  def grid_hash(sheet_id, column_range = (1..100000), row_range = (1..100000), key_mapping_hash={})
    if column_range.size.odd?
      Logger.error('Column range should be even number')
      return
    end
    sheet = @xlsx.sheet(sheet_id)
    result = {}
    result['excel_location'] = "Sheet: #{sheet_id}, Column: #{column_range}, Row: #{row_range}"
    row_range.each do |row|
      column_range.each_slice(2) do |column|
        next unless sheet.cell(row, column[0]).present?
        converted_key = sheet.cell(row, column[0]).downcase.strip
        if key_mapping_hash.has_key?(converted_key)
          converted_key = key_mapping_hash[converted_key]
          value = sheet.cell(row, column[1])
          converted_key, value = special_key_value(converted_key, value)
          result[converted_key] = value
        end
      end
    end
    result
  end

  def table_hashes(sheet_id, title_row, key_mapping_hash={})
    sheet = @xlsx.sheet(sheet_id)
    keys = sheet.row(title_row).reject {|o| o.blank?}
    result = []
    i = title_row
    while true
      i += 1
      this_row = sheet.row(i)
      break unless this_row.any? {|a| !a.nil? && a.size>0}
      obj = {}
      obj['excel_location'] = "Sheet: #{sheet_id}, Row: #{i}"
      keys.each_with_index do |key, id|
        next unless key.present?
        converted_key = key.downcase.strip
        if key_mapping_hash.has_key?(converted_key)
          converted_key =key_mapping_hash[converted_key]
          value = this_row[id]
          converted_key, value = special_key_value(converted_key, value)
          obj[converted_key] = value
        end
      end
      result << obj
    end
    result
  end

  def special_key_value(key, value)
    if value.nil?
      converted_value = value
    else
      converted_value = value.to_s.strip
      converted_value = converted_value.gsub("\t",'')
      converted_value = converted_value.gsub("\u00A0",'')
    end
    converted_key = key
    if converted_key.end_with?('[STRING_ARRAY]')
      converted_key = converted_key.gsub('[STRING_ARRAY]', '')
      if converted_value.present?
        converted_value = converted_value.split(',')
        converted_value.each {|v| v.strip!}
      else
        converted_value = []
      end
    end
    return converted_key, converted_value
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