# == Schema Information
#
# Table name: permissions
#
#  id             :integer          not null, primary key
#  deliverable_id :integer
#  user_id        :integer
#  group_id       :integer
#  responsible    :boolean
#  access_id      :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Permission < ApplicationModel
	belongs_to :deliverable
	belongs_to :user
	belongs_to :group
  belongs_to_active_hash :access, :class_name => 'DeliverableAccess'
  attr_accessible :user_id, :access_id, :responsible, :group_id, :access, :deliverable_id

 	def self.user(user)
 		user_id = user.is_a?(User) ? user.id : user
 		where user_id: user_id
 	end
 	def self.deliverable(deliverable)
 		deliverable_id = deliverable.is_a?(Deliverable) ? deliverable.id : deliverable
 		where deliverable_id: deliverable_id
 	end
 	def self.user_or_group(user, group=nil)
 		user_id = user.is_a?(User) ? user.id : user
 		group_id = if group.nil?
 			user.is_a?(User) ? user.user_group_id : User.find(user_id).user_group_id
 		else 
 			group.is_a?(UserGroup) ? group.id : group
 		end
 		where [ 'permissions.user_id = ? or permissions.group_id = ?', user_id, group_id ]
 	end
 	def self.user_group(group)
 		group_id = group.is_a?(UserGroup) ? group.id : group
 		where group_id: group_id
 	end
 	def self.responsible(value=nil)
 		value = true if value.nil?
 		where responsible: value
 	end
 	scope :editable, where(access_id: DeliverableAccess.edit.id)

  protected

	 	before_save :ensure_read_access
	 	def ensure_read_access
	 		# To remove read access, you should delete the record or create a noaccess access value.
	 		self.access_id ||= DeliverableAccess.read.id
	 	end

	 	# after_create :create_todo_folder
	  # def create_todo_folder
	  # 	if self.deliverable.has_behavior?(:todo) and self.responsible
	  # 		log "Creating TODO"
		 #    TodoFolder.new(self).delay.create
		 #  end
	  # end

	  # before_update :update_todo_folder
	  # def update_todo_folder
	  # 	if self.deliverable.has_behavior?(:todo) and self.responsible_changed? and self.deliverable.incomplete?
	  # 		if self.responsible
	  # 			log "Creating TODO"
	  # 			TodoFolder.new(self).delay.create
	  # 		else
	  # 			log "Removing TODO"
	  # 			TodoFolder.new(self).delay.remove
	  # 		end
	  # 	end
	  # end

end
