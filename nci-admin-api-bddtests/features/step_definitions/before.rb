require_relative './spec_helper'

Before do
	Environment.set_tier 'server' #set tier to local for developing tests.
	puts "Testing on tier #{Environment.get_tier}"
end
