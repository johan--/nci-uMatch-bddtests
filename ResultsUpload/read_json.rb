require 'json'

# This class is used to manipulate information required to access details from cucumber json reports
class ReadJson
  attr_reader :file_list, :collected_results
  def initialize(options = nil)
    raise 'Directory for cucumber json not given' if options[:directory].nil?
    @file_list = Dir["#{options[:directory]}/*.json"]
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
          name = scenario['name']
          res = sort_results(scenario)
          @collected_results << {
            name: name,
            passed: res[:passed],
            failed: res[:failed],
            skipped: res[:skipped]
          }
        end
      end
    end
  end

  def sort_results(scenario)
    passed = 0
    failed = 0
    skipped = 0
    scenario["steps"].each do |step|
      next if step['result'].nil?
      @step = step
      case step['result']['status']
      when 'passed'
        passed += 1

      when 'failed'
        failed += 1

      when 'skipped'
        skipped += 1
      end
    end
    { passed: passed, failed:failed, skipped: skipped }
  end

  # This method transforms the collected results to a hash that breaks
  # down the build by pass/fail/skipped steps
  def simplify_collected_data
    stats = {passed: 0, failed: 0, skipped: 0, total: 0}
    collect_all_results if @collected_results.nil?
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
