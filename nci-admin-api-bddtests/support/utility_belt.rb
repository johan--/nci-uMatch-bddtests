
module Utility
	module_function

	def nil_if_empty(val)
		if val.to_s.empty?
			nil
		else
			val
		end
	end

end