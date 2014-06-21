class UserGroupConfig
	def self.find
		new
	end

	def root_deliverable_label
		AppConfig.root_deliverable_label
	end

	def folder_path_for(deliverable)
		[root_deliverable_label, deliverable.folder_name]
	end
end