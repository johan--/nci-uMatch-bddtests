require 'json'

class ReadJson


  attr_reader :file_list, :collected_results
  
  def initialize(options = nil)
    raise 'Root folder for cucumber json not provided' if options[:directory].nil?
    @file_list = Dir["#{options[:directory]}/*.json"]
    raise 'Folder provided does not have any json files' if @file_list.size == 0
  end

  # This method returns hash of all the scenarios and the number of tests that passed, failed and skipped
  # output - VOID
  def collect_all_results
    @collected_results  = []
    @file_list.each do |cuke_file_name|
      cuke = JSON.parse(File.read(cuke_file_name))
      # Section to get rid of all values only scenario and status
      cuke.each do |feature|
        feature["elements"].each do |scenario|
          next if scenario["type"] == 'background'
          name = scenario["name"]
          passed = 0
          failed = 0
          skippd = 0

          scenario["steps"].each do |step|
            passed += 1 if step['result']["status"] == 'passed'
            failed += 1 if step['result']["status"] == 'failed'
            skippd += 1 if step['result']["status"] == 'skipped'
          end
          @collected_results << {name: name, passed: passed, failed: failed, skipped: skippd}
        end
      end
    end
  end

  # This method transforms the collected results to a hash that breaks down the build by pass/fail/skipped steps
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


  # This method transforms the data into a hash that states whether a scenario has passed or failed.
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
