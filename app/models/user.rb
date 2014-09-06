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
#  short_name             :string(255)
#  user_group_id          :integer
#

class User < ApplicationModel
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # validates_uniqueness_of :short_name
  belongs_to_active_hash :status, :class_name => 'UserStatus'

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me, :short_name, :name

  has_many :emails, dependent: :destroy

	has_many :signed_request_users
	accepts_nested_attributes_for :signed_request_users

  belongs_to :user_group
  has_one :google_authorization
  has_one :gmail_synchronization, :class_name => 'Htkoogle::GmailSynchronization'

  def self.email(email)
    where ['lower(users.email) = ?', email.downcase]
  end
  def self.emails(emails)
    where ['lower(users.email) in (?)', emails.map(&:downcase)]
  end
  def self.user_group(group)
    group_id = group.is_a?(UserGroup) ? group.id : group
    where user_group_id: group_id
  end
  def self.accessible_to(user)
    where(['users.email like ?', '%@' + user.email_domain ])
  end
  scope :active, where(status_id: UserStatus.active.id)
  scope :surrogate, where(status_id: UserStatus.surrogate.id)

  def name
    "#{self.first_name} #{self.last_name}".strip
  end

  def name=(val)
    if val
      parts = val.split(' ')
      self.first_name = parts[0]
      self.last_name = parts[1..-1].join(' ')
    else
      self.first_name = self.last_name = nil
    end
  end

  def email_domain
    self.email.split('@').last
  end

  def preferences
    UserPreferences.new(self)
  end

  # Allow gplus login.
  def password_required?
    super if false
  end

  def self.build(args)
    args = args.dup
    user_group_id = args.delete(:user_group_id)
    user_group = args.delete(:user_group)
    status = args.delete(:status)
    user = User.new(args)
    user.user_group_id = user_group_id if user_group_id
    user.user_group = user_group if user_group
    user.status = status
    user
  end

  protected

    before_save :set_short_name
    def set_short_name
      unless self.short_name.present?
        self.short_name = self.last_name.present? ? "#{self.first_name} #{self.last_name[0]}" : self.first_name
      end
    end

end
