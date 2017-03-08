module UserManagement
	module_function

	def get_user_details(role)
		{
			email: ENV["#{role}_UI_AUTH0_USERNAME"],
			password: ENV["#{role}_UI_AUTH0_PASSWORD"]
		}
	end
end