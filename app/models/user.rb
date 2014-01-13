# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  status_id              :integer
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  first_name             :string(255)
#  last_name              :string(255)
#

class User < ApplicationModel
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me, :email_accounts_attributes

	has_many :email_accounts
	accepts_nested_attributes_for :email_accounts

	has_many :signed_request_users
	accepts_nested_attributes_for :signed_request_users

  def name
    "#{self.first_name} #{self.last_name}".strip
  end

  def self.emails(emails)
    where ['users.email in (?)', emails]
  end
  def self.accessible_to(user)
    where ['users.email like ?', '%@' + user.email_domain ]
  end

  def email_domain
    self.email.split('@').last
  end

end
