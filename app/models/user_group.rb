# == Schema Information
#
# Table name: user_groups
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  data       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserGroup < ApplicationModel
	attr_accessible :name
	has_many :users
	def self.group_name(text)
		where name: text
	end
end
