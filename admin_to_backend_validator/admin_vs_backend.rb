require 'json'
require 'rest-client'
require 'active_support'
require 'active_support/core_ext'
require 'roo'
require_relative 'xlsx'

class AdminVsBackend
  def initialize(spreadsheet_path)
    @spreadsheet = Xlsx.new(spreadsheet_path)
    @name_map = JSON.parse(File.read("#{File.dirname(__FILE__)}/name_map.json"))
  end

  def ta_params(sheet_id)
    result = {}
    result.merge!(@spreadsheet.row_hash(sheet_id, 'a', 'b', (2..4), @name_map['ta_params']))
    result.merge!(@spreadsheet.row_hash(sheet_id, 'c', 'd', (2..4), @name_map['ta_params']))
    result.merge!(@spreadsheet.row_hash(sheet_id, 'e', 'f', (2..4), @name_map['ta_params']))
    result.merge!(@spreadsheet.row_hash(sheet_id, 'g', 'h', (2..4), @name_map['ta_params']))
    result
  end

  def exclusion_diseases(sheet_id)
    title = @spreadsheet.first_occurrence_row(sheet_id, 'Histologic Disease Exclusion Codes')+1
    result = @spreadsheet.table_hashes(sheet_id, title, @name_map['exclusion_diseases'])
    result.each { |d| d['exclusion'] = true }
    result
  end

  def exclusion_drugs(sheet_id)
    title = @spreadsheet.first_occurrence_row(sheet_id, 'Prior Therapy (Drug Exclusion)')+1
    result = @spreadsheet.table_hashes(sheet_id, title, @name_map['exclusion_drugs'])
    result.each { |d| d.delete('Comment') }
    result
  end

  def assay(sheet_id)
    title = @spreadsheet.first_occurrence_row(sheet_id, 'IHC Results')+1
    result = spreadsheet.table_hashes(sheet_id, title, @name_map['assay'])
    result.each { |d| d['type'] = 'IHC' }
    result
  end

  def non_hot_spots(sheet_id)
    title = @spreadsheet.first_occurrence_row(sheet_id, 'Non-Hotspot Rules')+1
    @spreadsheet.table_hashes(sheet_id, title, @name_map['non_hot_spots'])

  end

  def variants(sheet_id)
    title = @spreadsheet.first_occurrence_row(sheet_id, 'Exclusion Variants')+1
    exclusion = @spreadsheet.table_hashes(sheet_id, title, @name_map['variants'])
    exclusion.each { |v| v['inclusion'] = false }
    title = @spreadsheet.first_occurrence_row(sheet_id, 'Inclusion Variants')+1
    inclusion = @spreadsheet.table_hashes(sheet_id, title, @name_map['variants'])
    inclusion.each { |v| v['inclusion'] = true }
    exclusion + inclusion
  end

end


class Util
  def self.actual_match_expected?(actual, expected)
    processed_actual = actual.to_s.strip.downcase
    processed_expected = expected.to_s.strip.downcase
    if Util.is_date?(expected)
      return false unless Util.is_date?(processed_actual)
      return date_string_match?(processed_actual, processed_expected)
    end
    if Util.is_number?(expected)
      return false unless Util.is_number?(processed_actual)
      return number_string_match?(processed_actual, processed_expected)
    end
    processed_actual == processed_expected
  end

  def self.is_date?(string)
    true if Date.parse(string) rescue false
  end

  def self.is_number?(string)
    true if Float(string) rescue false
  end

  def self.date_string_match?(s1, s2)
    t1 = Time.parse(s1).utc.iso8601
    t2 = Time.parse(s2).utc.iso8601
    t1==t2
  end

  def self.number_string_match?(s1, s2)
    s1.to_f == s2.to_f
  end
end

tas = AdminVsBackend.new('/Users/wangl17/Downloads/PedMATCH_Master_Spreadsheet_for_Treatment_Arm_Loader.xlsx')
puts tas.variants('APEC1621D2').size