require 'aws-sdk'

options = ARGV.join(' ').scan(/--?([^=\s]+)(?:=(\S+))?/).inject({}) {|memo,e | memo[e[0].to_sym] = e[1]; memo}
raise "Provide folder name as --folder=<folder>" if options[:folder].nil?
raise "Provide date as --date=<date_string>" if options[:date].nil?
raise "Provide cucumber tag as --cuke=<cucumberTag>" if options[:cuke].nil?


class Uploader
  def initialize(options)
    puts "Starting upload to #{options[:folder]}"

  end
end