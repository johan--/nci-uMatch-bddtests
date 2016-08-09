#! /usr/bin/env ruby
require 'google_drive'
require_relative 'read_json'
require_relative 'options_manager'

class UpdateGoogleDrive
  DEFAULT_DOC = 'BDD Test Report'

  OpenSSL::SSL::VERIFY_PEER = 0

  attr_accessor :workbook, :summary_sheet, :metrics_sheet, :cuke

  def initialize (options)
    %w(directory config tag build).map(&:to_sym).each do |elem|
      raise "Value for '#{elem}' not provided." if options[elem].nil?
    end

    doc_name = options[:doc].nil? ? DEFAULT_DOC : options[:doc]
    @config  = options[:config]
    @session = GoogleDrive::Session.from_config(@config)
    @tag = options[:tag]
    @build = options[:build]
    @workbook = @session.file_by_title doc_name
    @summary_sheet = @workbook.worksheet_by_title("#{@tag}_summary")
    @metrics_sheet = @workbook.worksheet_by_title("#{@tag}_metrics")
    @cuke = ReadJson.new(options)
  end

  # This function returns the column numbers for each of the columns
  def set_summ_col_headings
    col_count = @summary_sheet.num_cols
    col_headings = {}
    (1..col_count).each do |col|
      col_headings[@summary_sheet[1, col].downcase.to_sym] = col
    end
    col_headings
  end

  def existing_scenario_list
    list = {}
    total_rows = @metrics_sheet.num_rows
    (2..total_rows).each { |row| list[@metrics_sheet[row, 1]] = row }
    list
  end

  def update_summary_sheet
    results = @cuke.simplify_collected_data
    new_row = @summary_sheet.num_rows + 1
    col_headings = set_summ_col_headings

    @summary_sheet[new_row, col_headings[:build]]   = @build
    @summary_sheet[new_row, col_headings[:passed]]  = results[:passed]
    @summary_sheet[new_row, col_headings[:failed]]  = results[:failed]
    @summary_sheet[new_row, col_headings[:skipped]] = results[:skipped]
    save_sheet(@summary_sheet)
  end

  def update_metrics_sheet
    metrics = @cuke.result_by_scenario
    new_col = @metrics_sheet.num_cols + 1
    new_row = @metrics_sheet.num_rows + 1
    @metrics_sheet[1, new_col] = @build
    existing_scenario_list.each do |k,v|
      @metrics_sheet[v, new_col] = metrics[k]
      metrics.delete(k)
    end
    metrics.each do |k,v|
      @metrics_sheet[new_row, 1] = k
      @metrics_sheet[new_row, new_col] = v
      new_row += 1
    end
    save_sheet(@metrics_sheet)
  end

  def save_sheet(sheet)
    sheet.save if sheet.dirty?
  end

  def update_all_results
    update_summary_sheet
    update_metrics_sheet
  end
end

if __FILE__ == $0
  options = OptionsManager.parse(ARGV)
  UpdateGoogleDrive.new(options).update_all_results
end
