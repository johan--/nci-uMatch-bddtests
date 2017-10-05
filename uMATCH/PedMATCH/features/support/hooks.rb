at_exit do
  puts
  puts "Statistics:"
  puts '-' * 100
  stats = Helper_Methods::STATS

  # time stats
  puts "Total idle time: #{stats[:idle_time].round(2)}s"
  puts "Total HTTP request time: #{stats[:http_time].round(2)}s"
  puts "Total HTTP requests: #{stats[:http_count]}"
  puts "Average HTTP request time: #{(stats[:http_time]/stats[:http_count]).round(2)}s" if stats[:http_count] > 0
  puts

  # calls to auth0
  puts "Total Auth0 calls: #{stats[:auth0_calls_count]}"
  puts "Total Auth0 calls per user:"
  puts

  stats[:auth0_calls_per_user].each do |stat|
    puts "#{stat[1].to_s.rjust(4)} => #{stat[0]}"
  end
  puts

  # slow requests
  puts "Slow HTTP requests (over #{stats[:slow_http_request_treshold]} second):"
  puts
  stats[:slow_http_requests].sort.reverse.each_with_index do |stat, index|
    puts "#{(index + 1).to_s.rjust(4)}: #{stat[0].round(2).to_s.rjust(6)}s => #{stat[1]}"
  end
  puts

end
