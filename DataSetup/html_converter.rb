require 'nokogiri'
require 'tempfile'


options = ARGV.join(' ').scan(/--?([^=\s]+)(?:=(\S+))?/).inject({}) {|memo,e | memo[e[0].to_sym] = e[1]; memo}
raise "Provide file name as --file=<file_name>" if options[:file].nil?
raise "Provide folder name as --folder=<folder>" if options[:folder].nil?
raise "Provide Date as --date=<date>" if options[:date].nil?

class Converter
  def initialize(options)
    puts "Starting the conversion"
    @options = options
    @project_root = File.join(File.expand_path(__FILE__), '..', '..', @options[:folder])
    @file_name = File.expand_path(File.join(@project_root, @options[:file]))
    puts @file_name
    raise "File Name #{@file_name} does not exist" unless File.exists? @file_name
    @doc = Nokogiri::HTML(File.read(@file_name))
  end

  def convert_all
    convert_images
    convert_links
  end

  def convert_images
    puts "Converting all images"
    images = @doc.css 'img.screenshot'
    images.each_with_index do | e, i |
      images[i].attributes['src'].content = "https://s3.amazonaws.com/cucumber-test-reports/#{@options[:date]}/#{e.attributes['src']}"
    end
  end

  def convert_links
    puts "Converting all links"
    links = @doc.css 'a.screenshot'
    links.each_with_index do | e, i |
      links[i].attributes['href'].content = "https://s3.amazonaws.com/cucumber-test-reports/#{@options[:date]}/#{e.attributes['href']}"
    end
  end

  def build_file
    puts "Writing back to html file"
    html_string = @doc.to_html
    file_write = File.open(@file_name, 'w')
    file_write.puts(html_string)
    file_write.close
  end
end

f = Converter.new(options)
f.convert_all
f.build_file
puts "Done"
