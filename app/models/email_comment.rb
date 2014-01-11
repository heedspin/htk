# == Schema Information
#
# Table name: email_comments
#
#  id               :integer          not null, primary key
#  status_id        :integer
#  user_id          :integer
#  email_message_id :string(255)
#  email_subject    :string(255)
#  email_send_time  :string(255)
#  sender_email     :string(255)
#  format_id        :integer
#  comment          :text
#

class EmailComment < ApplicationModel
  belongs_to_active_hash :status, :class_name => 'EmailCommentStatus'
  belongs_to :user
	has_many :email_comment_users
	has_many :users, :through => :email_comment_users
  belongs_to_active_hash :format, :class_name => 'EmailCommentFormat'
end
