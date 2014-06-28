class UserGroupConfig
	def self.find
		new
	end

	def root_deliverable_label
		AppConfig.root_deliverable_label
	end

	def root_todo_label
		AppConfig.root_todo_label || 'To Do'
	end

	def folder_path_for(thing)
		deliverable_folder_path = if thing.is_a?(Deliverable)
			self.deliverable_folder_path(thing)
		elsif thing.is_a?(Array)
			thing
		end
		[root_deliverable_label] + deliverable_folder_path
	end

	def deliverable_folder_path(deliverable, override={})
		result = []
		result.push(override[:folder_name] || deliverable.folder_name)
		result
	end
end