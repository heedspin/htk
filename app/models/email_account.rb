# == Schema Information
#
# Table name: email_accounts
#
#  id                    :integer          not null, primary key
#  status_id             :integer
#  user_id               :integer
#  username              :string(255)
#  authentication_string :string(255)
#  server                :string(255)
#  port                  :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'htk_imap/htk_imap'
require 'plutolib/logger_utils'

class EmailAccount < ApplicationModel
  include Plutolib::LoggerUtils
  attr_accessible :authentication_string, :port, :server, :username, :status
  attr_protected :user_Id
  belongs_to :user
  belongs_to_active_hash :status, :class_name => 'EmailAccountStatus'
  validates_uniqueness_of :username, :case_sensitive => false
  has_many :email_account_conversations
  has_many :message_receipts, :through => :email_account_conversations
  has_many :emails

  def self.username(txt)
    where ['lower(email_accounts.username) = ?', txt.downcase]
  end
  scope :active, :conditions => { :status_id => EmailAccountStatus.active.id }

  before_save :set_default_port
  def set_default_port
  	unless self.port.present?
  		self.port = 993
  	end
  end

  def self.user(user)
  	where(:user_id => user.id)
  end

  def imap_connection
    HtkImap::GmailImap.imap_connect(self)
  end

  def fetch_emails(args={}, &block)
    HtkImap::GmailImap.imap_connect(self) do |imap|
      current_folder = '[Gmail]/All Mail'
      imap.examine(current_folder)
      args = args.clone
      args[:imap] = imap
      args[:current_folder] = current_folder
      if uid = args[:uid]
        return HtkImap::GmailEmail.new(imap: imap, uid: uid, folder: current_folder)
      elsif args.member?(:since_uid)
        return HtkImap::GmailEmail.fetch_since(args, &block)
      elsif message_id = args[:message_id]
        if uid = imap.uid_search(['HEADER', 'MESSAGE-ID', message_id]).first
          HtkImap::GmailEmail.new(imap: imap, uid: uid, folder: current_folder)
        else
          nil
        end
      elsif email_conversation_id = args[:email_conversation_id]
        HtkImap::GmailEmail.fetch_for_conversation(args, &block)
      else
        args[:offset] ||= 0
        args[:limit] ||= 100
        return HtkImap::GmailEmail.fetch_all(args, &block)
      end
    end
  end
  alias_method :fetch_email, :fetch_emails

  def import_emails
    last_email = self.emails.by_uid.last
    proc = Proc.new do |email|
      self.emails.create!(
        folder: email.folder, 
        date: email.date,
        uid: email.uid, 
        guid: email.guid,
        subject: email.subject,
        mail: email.mail)
    end
    emails = if last_email
      self.fetch_emails({since_uid: last_email.try(:uid)}, &proc)
    else
      self.fetch_emails({limit: 50}, &proc)
    end
    deleted_emails = 0
    if last_email = self.emails.order('emails.uid desc').offset(500).first
      delete_conditions = ['emails.uid > ?', last_email.uid]
      deleted_emails = self.emails.where(delete_conditions).count
      self.emails.where(delete_conditions).delete
    end
    log "Imported #{emails.count} and deleted #{deleted_emails} emails from #{self.username}"
    emails
  end
end
