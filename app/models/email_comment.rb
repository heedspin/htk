# == Schema Information
#
# Table name: email_comments
#
#  id               :integer          not null, primary key
#  status_id        :integer
#  email_message_id :string(255)
#  email_subject    :string(255)
#  email_send_time  :string(255)
#  email_sender     :string(255)
#  format_id        :integer
#  comment          :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class EmailComment < ApplicationModel
  belongs_to_active_hash :status, :class_name => 'EmailCommentStatus'
	has_many :email_comment_users
	has_many :users, :through => :email_comment_users
  has_one :owner_email_comment_user, class_name: 'EmailCommentUser', foreign_key: 'email_comment_id', conditions: { email_comment_users: {role_id: EmailCommentRole.owner.id} }
  has_one :owner, :class_name => 'User', :through => :owner_email_comment_user, :source => :user
  belongs_to_active_hash :format, :class_name => 'EmailCommentFormat'

  attr_accessible :status, :status_id, :creator, :creator_id, :email_sender, :email_message_id, :email_subject, :email_send_time, :format, :format_id, :comment

  scope :not_deleted, where(['status_id != ?', EmailCommentStatus.deleted])
  def self.accessible_to(user)
  	includes(:email_comment_users).where(:email_comment_users => { :user_id => user.id })
  end
  def self.email_sender(email)
  	where(:email_sender => email)
  end
  def self.email_send_time(send_time)
  	where(:email_send_time => send_time)
  end
  def self.email_subject(subject)
  	where(:email_subject => subject)
  end
  scope :by_created_at_desc, :order => 'email_comments.created_at desc'
end
