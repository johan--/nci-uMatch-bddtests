#! /usr/bin/env ruby
require 'optparse'
require 'ostruct'
require 'json'

# Setting up options for using with the cli
class OptionsManager
  def self.parse(_args)
    options = OpenStruct.new
    options.directory = nil
    options.file_name

    opt_parser = OptParse.new do |opts|
      opts.banner = 'Usage ./update_report.rb [options].'

      opts.on('-d d', '--directory=d', '[Required] Parent directory holding the cucumber json files') do |directory|
        options.directory = directory.to_s
      end

      opts.on('-c c', '--config=c', '[Required] configuration file needed to set up session with Google Sheet') do |build|
        options.config = build
      end

      opts.on('-t t', '--tag=t', '[Required] Cucumber tag used to trigger current tests') do |tag|
        options.tag = tag
      end

      opts.on('-b b', '--build=b', '[Required] Build number of the current run of the tests') do |build|
        options.build = build
      end

      opts.on('-f f', '--file_name=f', '[Optional] Google sheet name default BDD Test Report') do |file|
        options.file_name = file.to_s
      end
    end
    opt_parser.parse!
    options
  end
end
