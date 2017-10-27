require_relative './spec_helper'

Before do
	Environment.set_tier 'local' #set tier to local for developing tests.
	puts "Testing on tier #{Environment.get_tier}"
end
