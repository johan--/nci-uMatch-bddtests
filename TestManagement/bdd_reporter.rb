require 'nokogiri'
require 'tempfile'
require 'json'
require 'active_support'
require 'active_support/core_ext'
require 'rest-client'

class BddReporter
  @date = Date.today.strftime('%m-%d-%y')

  def self.upload(json_folder, level, tag, s3_bucket, remove_background = true)
    html_name = "#{level}#{tag}.html"
    clean_json_files(json_folder, remove_background)
    generate_html(json_folder, html_name, level, tag, @date)
    convert_html(json_folder, html_name, @date)
    upload_report(json_folder, html_name, @date, s3_bucket)
  end

  def self.update_service(project, tag, trigger_author, trigger_repo, trigger_commit, travis_url)
    author = trigger_author.present? ? trigger_author : `git --no-pager show -s --format='%an <%ae>'`.split(' <')[0]
    repo = trigger_repo.present? ? trigger_repo : File.basename(`git rev-parse --show-toplevel`)
    commit = trigger_commit.present? ? trigger_commit : ENV['TRAVIS_COMMIT']
    payload = {
        project: project,
        date: @date,
        tag: tag.sub('@', ''),
        trigger_author: author,
        trigger_repo: repo,
        trigger_commit: commit,
        travis_url: travis_url
    }.to_json

    RestClient::Request.execute(:url => "#{ENV['TEST_MANAGEMENT_URL']}/reports/update",
                                :method => :put,
                                :verify_ssl => false,
                                :payload => payload,
                                :headers => {:content_type => 'application/json'})
  end

  def self.notify_user(project, tag, date=@date)
    url = "#{ENV['TEST_MANAGEMENT_URL']}/report_notified/#{project}/#{date}/#{tag.sub('@', '')}"
    RestClient::Request.execute(:url => url,
                                :method => :get,
                                :verify_ssl => false)
  end

  def self.generate_html(json_folder, html_name, level, tag, date)
    puts "The following files will be converted to bdd report: \n #{Dir["#{json_folder}/*"]}"
    template_file = "#{File.dirname(__FILE__)}/generate_report_js_template.txt"
    js_file = "#{File.dirname(__FILE__)}/bdd_reporter/support/generate_report.js"
    title = "#{tag.sub('@', '').upcase} BDD Reports (#{level}, #{date})"
    template = File.read(template_file)
    template.gsub!('**json_folder**', json_folder)
    template.gsub!('**html_name**', html_name)
    template.gsub!('**report_name**', title)
    file_write = File.open(js_file, 'w')
    file_write.puts(template)
    file_write.close
    cmd = "cd #{File.dirname(__FILE__)}/bdd_reporter; node support/generate_report.js"
    `#{cmd}`
    puts "HTML report file #{html_name} is generated in #{json_folder}"
  end

  def self.clean_json_files(json_folder, remove_background = true)
    Dir["#{json_folder}/*"].each do |j|
      if j.end_with?('.json')
        begin
          report_json = JSON.parse(File.read(j))
        rescue Exception => e
          puts "#{j} is not a valid json, delete it"
          File.delete(j)
        end
        if remove_background
          report_json.each do |r|
            background_found = false
            r['elements'].each do |e|
              if e['keyword'] == 'Background'
                r['elements'].delete(e) if background_found
                background_found = true
              end
            end
          end
          file_write = File.open(j, 'w')
          file_write.puts(report_json.to_json)
          file_write.close
        end
      end
    end
  end

  def self.convert_html(report_folder, report_file_name, date)
    puts 'Starting the conversion'
    html = load_html("#{report_folder}/#{report_file_name}")
    convert_images(html, date)
    convert_links(html, date)
    build_file(html, date)
    puts 'Done'
  end

  private_class_method def self.load_html(html_path)
                         raise "File Name #{html_path} does not exist" unless File.exists? html_path
                         Nokogiri::HTML(File.read(html_path))
                       end

  private_class_method def self.convert_images(html, date)
                         puts 'Converting all images'
                         images = html.css 'img.screenshot'
                         s3 = 'https://s3.amazonaws.com/cucumber-test-reports'
                         images.each_with_index do |e, i|
                           images[i].attributes['src'].content = "#{s3}/#{date}/#{e.attributes['src']}"
                         end
                       end

  private_class_method def self.convert_links(html, date)
                         puts 'Converting all links'
                         links = html.css 'a.screenshot'
                         s3 = 'https://s3.amazonaws.com/cucumber-test-reports'
                         links.each_with_index do |e, i|
                           links[i].attributes['href'].content = "#{s3}/#{date}/#{e.attributes['href']}"
                         end
                       end

  private_class_method def self.build_file(html, file_name)
                         puts 'Writing back to html file'
                         html_string = html.to_html
                         file_write = File.open(file_name, 'w')
                         file_write.puts(html_string)
                         file_write.close
                       end

  def self.upload_report(report_folder, report_file_name, date, s3_bucket)
    file_path = "#{report_folder}/#{report_file_name}"
    cmd = "aws s3 cp #{file_path} s3://#{s3_bucket}/#{date}/#{report_file_name} --region us-east-1"
    `#{cmd}`
    puts "Cucumber report #{file_path} has been uploaded to s3://#{s3_bucket}/#{date}"
    screenshot = "#{report_folder}/screenshot"
    if File.exist?(screenshot)
      cmd = "aws s3 cp #{screenshot} s3://#{s3_bucket}/#{date}/screenshot --region us-east-1 --recursive"
      `#{cmd}`
      puts "Screenshot #{screenshot} has been uploaded to s3://#{s3_bucket}/#{date}/screenshot"
    end
  end
end