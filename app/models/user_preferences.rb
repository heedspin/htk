class UserPreferences
	attr :user, :group_config
	def initialize(user)
		@user = user
		@group_config = UserGroupConfig.find
	end

	def todo_folder_path(for_user)
		[self.group_config.root_todo_label, for_user.short_name]
	end

	def folder_path_for(thing)
		self.group_config.folder_path_for(thing)
	end

	def deliverable_folder_path(deliverable, override={})
		self.group_config.deliverable_folder_path(deliverable, override)
	end

	def deliverable_types
		self.group_config.deliverable_types
	end

	def home_page_url
		Rails.application.routes.url_helpers.dashboard_url(host: AppConfig.hostname)
	end
end