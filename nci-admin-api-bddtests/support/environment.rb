module Environment
	module_function

	def set_tier(tier)
		@tier = tier

		raise 'Tier not set. Please set tier to "local" or "server"' if @tier.to_s.empty?

		require_relative('./env_local') if @tier == 'local'
		require_relative('./env') if @tier == 'server'

		puts "Tier set to: #{@tier}"
	end

	def get_tier
		@tier
	end
end

		

