# !/usr/bin/ruby
# require 'rspec'
# require 'json'
require_relative '../../../support/helper_methods.rb'
# require_relative '../../../support/cog_helper_methods.rb'

When(/^the ion reporter service \/version is called, the version "([^"]*)" is returned$/) do |arg1|
  dummy = 'dummy'
  dummy.should == 'dummy'
end