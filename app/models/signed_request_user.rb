# == Schema Information
#
# Table name: signed_request_users
#
#  id                          :integer          not null, primary key
#  created_at                  :datetime
#  original_opensocial_app_id  :string(255)
#  original_opensocial_app_url :string(255)
#  opensocial_owner_id         :string(255)
#  opensocial_container        :string(255)
#  user_id                     :integer
#

class SignedRequestUser < ApplicationModel
	belongs_to :user
	attr_accessible :user, :original_opensocial_app_id, :original_opensocial_app_url, :opensocial_owner_id, :opensocial_container
	def self.owner_container(opensocial_owner_id, opensocial_container)
		where(:opensocial_owner_id => opensocial_owner_id, :opensocial_container => opensocial_container)
	end
end
