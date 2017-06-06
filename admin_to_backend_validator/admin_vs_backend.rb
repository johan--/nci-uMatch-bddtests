require 'json'
require 'active_support'
require 'active_support/core_ext'
require 'roo'
require_relative 'xlsx'
require_relative 'ped_match_rest_client'
require_relative 'constants'

class AdminVsBackend
  def initialize(spreadsheet_path)
    @spreadsheet = Xlsx.new(spreadsheet_path)
    @name_map = JSON.parse(File.read("#{File.dirname(__FILE__)}/name_map.json"))
  end

  def validate(sheet_id)
    params = ta_params(sheet_id)
    back_end = back_end_ta(params['treatment_arm_id'], params['stratum_id'], params['version'])
    Util.hash_inclusion_validation(back_end, params)
    v_list = variants(sheet_id)
    Util.array_key_match(v_list['snv_indels'], variants(sheet_id)['snv_indels'], 'identifier', 'snv_indels')
  end

  def back_end_ta(ta_id, stratum, version)
    url = "#{Constants.url_ta_api}/#{ta_id}/#{stratum}/#{version}"
    JSON.parse(PedMatchRestClient.rest_request(url, 'get'))
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
    result = {}
    result['snv_indels'] = []
    result['copy_number_variants'] = []
    result['gene_fusions'] = []
    (exclusion+inclusion).each do |v|
      case v['variant_type'].downcase
        when 'mnv', 'snv', 'ins', 'del', 'indel'
          result['snv_indels'] << v
        when 'cnv'
          result['copy_number_variants'] << v
        when 'fusion'
          result['gene_fusions'] << v
        else
          Logger.log("#{v['variant_type']} is not a valid variant type")
      end
    end
    result
  end

end


class Util
  def self.actual_match_expected?(actual, expected)
    if expected.nil?
      return actual == expected
    elsif actual.nil?
      return false
    end
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

  def self.hash_inclusion_validation(big_hash, small_hash)
    small_hash.each do |k, v|
      big_value = big_hash
      if k.include?('[0]')
        parts = k.split('[0]')
        big_value = big_value[parts[0]]
        if big_value.is_a?(Array) && big_value.size == 1
          big_value = big_value[0]
        else
          big_value = nil
        end
        big_value = big_value[parts[1]] if parts.size > 1
      else
        big_value = big_value[k]
      end
      message1 = "*** key:#{k}\n"
      message2 = "    expect:#{v}\n"
      message3 = "    actual:#{big_value}\n"
      if actual_match_expected?(big_value, v)
        Logger.log(message1)
        Logger.log(message2)
        Logger.log(message3)
      else
        Logger.error(message1)
        Logger.error(message2)
        Logger.error(message3)
      end
    end
  end

  def self.array_key_match(expect_array, actual_array, key, test_target)
    expect_keys = expect_array.map { |h| h[key]}
    actual_keys = actual_array.map {|h| h[key]}
    if expect_keys.eql?(actual_keys)
      Logger.log("#{test_target}: actual match expect")
    else
      Logger.error("#{test_target}: actual doesn't match expect")
      Logger.error("The following values of #{key} are missing")
      Logger.error((expect_keys - actual_keys).to_json.to_s)
      Logger.error("The following values of #{key} are should not exist")
      Logger.error((actual_keys - expect_keys).to_json.to_s)
    end
    puts expect_keys - actual_keys
    puts actual_keys - expect_keys
  end

  def self.array_include_hash(array, hash, key)
    array_key_hash = array.select{|a| a[key] == hash[key]}
    unless array_key_hash.size == 1
      error = ("Expect 1 match object for key:#{key}, value:#{hash[key]}, actually there is/are #{array_key_hash.size}")
      Logger.error(error)
    end
    array_key_hash = array_key_hash[0]
    hash_inclusion_validation(array_key_hash, hash)
  end
end

Constants.set_tier('uat')
tas = AdminVsBackend.new('/Users/wangl17/Downloads/PedMATCH_Master_Spreadsheet_for_Treatment_Arm_Loader.xlsx')
tas.validate('APEC1621D2')