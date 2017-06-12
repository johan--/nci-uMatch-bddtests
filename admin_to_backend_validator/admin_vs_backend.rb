require 'json'
require 'active_support'
require 'active_support/core_ext'
require 'roo'
require_relative 'xlsx'
require_relative 'ped_match_rest_client'
require_relative 'constants'

class AdminVsBackend
  VT_SNV = 'snv_indels'
  VT_CNV = 'copy_number_variants'
  VT_GF = 'gene_fusions'

  def initialize(spreadsheet_path)
    @spreadsheet = Xlsx.new(spreadsheet_path)
    @name_map = JSON.parse(File.read("#{File.dirname(__FILE__)}/name_map.json"))
    Logger.hide_log(true)
  end

  def validate_all
    @spreadsheet.sheets.each {|sheet_id| validate(sheet_id)}
  end

  def validate(sheet_id)
    puts("Validating sheet #{sheet_id}")
    params = ta_params(sheet_id)
    back_end = back_end_ta(params['treatment_arm_id'], params['stratum_id'], params['version'])

    #parameters
    puts("\n\n\n#########Checking primary treatment arm parameters...")
    Util.hash_inclusion_validation(back_end, params)

    #exclusion disease
    puts("\n\n\n#########Checking exclusion disease...")
    Util.array_match_array(exclusion_diseases(sheet_id), back_end['diseases'], 'disease_code', 'disease code')

    #exclusion drug
    puts("\n\n\n#########Checking exclusion drug...")
    Util.array_match_array(exclusion_drugs(sheet_id), back_end['exclusion_drugs'], 'name', 'drug name')

    #assay
    puts("\n\n\n#########Checking IHC rule...")
    Util.array_match_array(assay(sheet_id), back_end['assay_rules'], 'gene', 'assay gene')

    #non-hotspot
    puts("\n\n\n#########Checking non-hotspot rule...")
    excel_nhs = non_hotspots(sheet_id)
    backent_nhs = back_end['non_hotspot_rules']
    excel_in_nhs = excel_nhs.select {|nh| nh['inclusion']}
    excel_ex_nhs = excel_nhs.select {|nh| !nh['inclusion']}
    backend_in_nhs = backent_nhs.select {|nh| nh['inclusion']}
    backend_ex_nhs = backent_nhs.select {|nh| !nh['inclusion']}
    Util.array_match_array(excel_in_nhs, backend_in_nhs, 'func_gene', 'Inclusion non-hotspots gene')
    Util.array_match_array(excel_ex_nhs, backend_ex_nhs, 'func_gene', 'Exclusion non-hotspots gene')

    #variants
    puts("\n\n\n#########Checking variants...")
    v_list = variants(sheet_id)
    types = %W(#{VT_SNV} #{VT_CNV} #{VT_GF})
    types.each {|type| Util.array_match_array(v_list[type], back_end[type], 'identifier', "#{type} ids")}
    puts "Sheet #{sheet_id} is done.\n\n\n"
  end

  def back_end_ta(ta_id, stratum, version)
    url = "#{Constants.url_ta_api}/#{ta_id}/#{stratum}/#{version}"
    JSON.parse(PedMatchRestClient.rest_request(url, 'get'))
  end

  def ta_params(sheet_id)
    @spreadsheet.grid_hash(sheet_id, (1..8), (2..4), @name_map['ta_params'])
  end

  def exclusion_diseases(sheet_id)
    title = @spreadsheet.first_occurrence_row(sheet_id, 'Histologic Disease Exclusion Codes')+1
    result = @spreadsheet.table_hashes(sheet_id, title, @name_map['exclusion_diseases'])
    result.each {|d| d['exclusion'] = true}
    result
  end

  def exclusion_drugs(sheet_id)
    title = @spreadsheet.first_occurrence_row(sheet_id, 'Prior Therapy (Drug Exclusion)')+1
    result = @spreadsheet.table_hashes(sheet_id, title, @name_map['exclusion_drugs'])
    result.each {|d| d.delete('Comment')}
    result
  end

  def assay(sheet_id)
    title = @spreadsheet.first_occurrence_row(sheet_id, 'IHC Results')+1
    result = @spreadsheet.table_hashes(sheet_id, title, @name_map['assay'])
    result.each {|d| d['type'] = 'IHC'}
    result
  end

  def non_hotspots(sheet_id)
    title = @spreadsheet.first_occurrence_row(sheet_id, 'Non-Hotspot Rules')+1
    result = @spreadsheet.table_hashes(sheet_id, title, @name_map['non_hotspots'])
    result.each {|d| d['inclusion'] = d['inclusion'].downcase == 'include'}
  end

  def variants(sheet_id)
    title = @spreadsheet.first_occurrence_row(sheet_id, 'Exclusion Variants')+1
    exclusion = @spreadsheet.table_hashes(sheet_id, title, @name_map['variants'])
    exclusion.each {|v| v['inclusion'] = false}
    title = @spreadsheet.first_occurrence_row(sheet_id, 'Inclusion Variants')+1
    inclusion = @spreadsheet.table_hashes(sheet_id, title, @name_map['variants'])
    inclusion.each {|v| v['inclusion'] = true}
    result = {}
    result[VT_SNV] = []
    result[VT_CNV] = []
    result[VT_GF] = []
    (exclusion+inclusion).each do |v|
      case v['variant_type'].downcase
        when 'mnv', 'snv', 'ins', 'del', 'indel'
          v['variant_type'] = convert_variant_type(v['variant_type'])
          result[VT_SNV] << v
        when 'cnv'
          result[VT_CNV] << v
        when 'fusion'
          result[VT_GF] << v
        else
          Logger.warning("#{v['variant_type']} is not a valid variant type")
      end
    end
    result
  end

  def convert_variant_type(excel_type)
    case excel_type.downcase
      when 'snv'
        'snp'
      when 'mnv'
        'mnp'
      else
        excel_type
    end
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

    return date_string_match?(processed_actual, processed_expected) if Util.is_date?(processed_expected)
    return number_string_match?(processed_actual, processed_expected) if Util.is_number?(expected)

    processed_actual == processed_expected
  end

  def self.is_date?(string)
    true if Time.parse(string) rescue false
  end

  def self.is_number?(string)
    true if Float(string) rescue false
  end

  def self.date_string_match?(s1, s2)
    return false unless is_date?(s1)
    return false unless is_date?(s2)
    t1 = Time.parse(s1).utc.iso8601
    t2 = Time.parse(s2).utc.iso8601
    t1==t2
  end

  def self.number_string_match?(s1, s2)
    return false unless is_number?(s1)
    return false unless is_number?(s2)
    s1.to_f == s2.to_f
  end

  def self.hash_inclusion_validation(actual_hash, expect_hash)
    expect_hash.each do |k, v|
      next if k == 'excel_location'
      parts = k.split('[0]')
      if parts.size == 2
        actual_value = actual_hash[parts[0]][0][parts[1]]
      else
        actual_value = actual_hash[k]
      end
      message0 = expect_hash['excel_location']
      message1 = "*** key:#{k}\n"
      message2 = "    expect:#{v}\n"
      message3 = "    actual:#{actual_value}\n\n"
      if actual_match_expected?(actual_value, v)
        Logger.info(message0)
        Logger.info(message1)
        Logger.info(message2)
        Logger.info(message3)
      else
        Logger.error(message0)
        Logger.error(message1)
        Logger.error(message2)
        Logger.error(message3)
      end
    end
  end

  def self.array_match_array(expect_array, actual_array, key, test_target)
    intersection = array_key_match(expect_array, actual_array, key, test_target)
    Util.array_match(expect_array, actual_array, key, intersection)
  end

  def self.array_key_match(expect_array, actual_array, key, test_target)
    expect_keys = expect_array.map {|h| h[key]}
    actual_keys = actual_array.map {|h| h[key]}
    if expect_keys.sort.eql?(actual_keys.sort)
      Logger.info("#{test_target}: actual match expect")
    else
      Logger.error("#{test_target}: actual doesn't match expect")
      Logger.error("The following values of #{key} are missing")
      Logger.error((expect_keys - actual_keys).to_json.to_s)
      Logger.error("The following values of #{key} should not exist")
      Logger.error((actual_keys - expect_keys).to_json.to_s)
    end
    actual_keys & expect_keys
  end

  def self.array_match(expect_array, actual_array, key_name, key_list)
    key_list.each do |key|
      actual_hash = find_unique_obj(actual_array, key_name, key)
      expect_hash = find_unique_obj(expect_array, key_name, key)
      hash_inclusion_validation(actual_hash, expect_hash)
    end
  end

  def self.find_unique_obj(hashes, key, value)
    result = hashes.select {|a| a[key] == value}
    unless result.size == 1
      Logger.error("Expect 1 match object for key:#{key}, value:#{value}, actually there is/are #{result.size}")
    end
    result[0]
  end

  def self.array_include_hash(array, hash, key)
    array_key_hash = array.select {|a| a[key] == hash[key]}
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
tas.validate_all