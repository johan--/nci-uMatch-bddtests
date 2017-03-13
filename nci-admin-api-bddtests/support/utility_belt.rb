module Utility
	module_function

	DATA_FOLDER = File.expand_path(File.join(File.expand_path(__FILE__), '..', '..', 'data_files'))

	def nil_if_empty(val)
		if val.to_s.empty?
			nil
		else
			val
		end
	end

end