# == Schema Information
#
# Table name: email_comment_users
#
#  id               :integer          not null, primary key
#  email_comment_id :integer
#  user_id          :integer
#

class EmailCommentUser < ApplicationModel
	belongs_to :email_comment
	belongs_to :user
end
