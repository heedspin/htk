# == Schema Information
#
# Table name: email_comment_users
#
#  id               :integer          not null, primary key
#  email_comment_id :integer
#  role_id          :integer
#  user_id          :integer
#

class EmailCommentUser < ApplicationModel
	belongs_to :email_comment
	belongs_to :user
  belongs_to_active_hash :role, :class_name => 'EmailCommentRole'

  attr_accessible :email_comment_id, :user_id, :role_id
end
