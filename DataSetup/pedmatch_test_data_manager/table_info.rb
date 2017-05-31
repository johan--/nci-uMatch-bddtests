require 'json'
require 'active_support'
require 'active_support/core_ext'

class TableInfo
  DETAILS = JSON.parse(File.read("#{File.dirname(__FILE__)}/table_details.json"))

  def self.treatment_arm_tables
    DETAILS.select { |k, v| k if v['category']=='treatment_arm_table' }.keys
  end

  def self.patient_tables
    DETAILS.select { |k, v| v['category']=='patient_table' }.keys
  end

  def self.ion_tables
    DETAILS.select { |k, v| k if v['category']=='ir_table' }.keys
  end

  def self.all_tables
    DETAILS.keys
  end

  def self.keys(table)
    raise "#{table} is not a valid Ped-Match table" unless DETAILS.keys.include?(table)
    result = [DETAILS[table]['primary_key']]
    result << DETAILS[table]['sorting_key'] if DETAILS[table]['sorting_key'].present?
    result
  end

  def self.primary_key(table)
    raise "#{table} is not a valid Ped-Match table" unless DETAILS.keys.include?(table)
    DETAILS[table]['primary_key']
  end

  def self.sorting_key(table)
    raise "#{table} is not a valid Ped-Match table" unless all_tables.include?(table)
    DETAILS[table]['sorting_key']
  end
end
