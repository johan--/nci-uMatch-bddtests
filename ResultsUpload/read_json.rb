require 'json'

# This class is used to manipulate information required
# to access details from cucumber json reports
class ReadJson
  attr_reader :file_list, :collected_results
  def initialize(options = nil)
    raise 'Directory for cucumber json not given' if options[:directory].nil?
    @file_list = trim_file_list(Dir["#{options[:directory]}/*.json"])
    @collected_results = []
    raise 'Could not find any json files' if @file_list.size.zero?
  end

  # This method returns hash of all the scenarios and the number of
  # tests that passed, failed and skipped
  # output - VOID
  def collect_all_results
    @file_list.each do |cuke_file_name|
      cuke = JSON.parse(File.read(cuke_file_name))
      # Section to get rid of all values only scenario and status
      cuke.each do |feature|
        feature['elements'].each do |scenario|
          next if scenario['type'] == 'background'
          name = build_scenario_name scenario
          res = sort_results scenario
          @collected_results << { name: name, passed: res[:passed], failed: res[:failed], skipped: res[:skipped] }
        end
      end
    end
  end

  # This method will reject any json file that is empty
  def trim_file_list(file_list)
    file_list.each do |file|
      if File.read(file).empty? || JSON.parse(File.read(file)).empty?
        file_list.delete(file)
      end
    end
  end

  # Method is used to build a unique scenario name
  # in case of a scenario outline.
  def build_scenario_name(scenario)
    return scenario['name'] if scenario['keyword'] == 'Scenario'
    "#{scenario['name']}_line_#{scenario['line']}"
  end

  def sort_results(scenario)
    passed, failed, skipped = 0, 0, 0
    scenario['steps'].each do |step|
      next if step['result'].nil?
      case step['result']['status']
      when 'passed'
        passed += 1
      when 'failed'
        failed += 1
      when 'skipped'
        skipped += 1
      end
    end
    { passed: passed, failed: failed, skipped: skipped }
  end

  # This method transforms the collected results to a hash that breaks
  # down the build by pass/fail/skipped steps
  def simplify_collected_data
    stats = {passed: 0, failed: 0, skipped: 0, total: 0}
    collect_all_results if @collected_results.empty?
    @collected_results.each do |line|
      if line[:failed] > 0
        stats[:failed] += 1
        next
      elsif line[:skipped] > 0
        stats[:skipped] += 1
        next
      elsif line[:passed] > 0
        stats[:passed] += 1
        next
      end
    end
    stats[:total] = stats.values.reduce(:+)
    stats
  end

  # This method transforms the data into a hash that
  # states whether a scenario has passed or failed.
  def result_by_scenario
    scenario_result = {}
    collect_all_results if @collected_results.empty?
    @collected_results.each do |line|
      if line[:failed] > 0
        scenario_result[line[:name]] = 'F'
        next
      elsif line[:skipped] > 0
        scenario_result[line[:name]] = 'S'
        next
      elsif line[:passed] > 0
        scenario_result[line[:name]] = 'P'
        next
      end
    end
    scenario_result
  end
end
