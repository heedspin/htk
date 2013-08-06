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
#  last_uid              :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'htk_imap/htk_imap'

class EmailAccount < ApplicationModel
  attr_accessible :authentication_string, :port, :server, :username, :status
  attr_protected :user_Id
  belongs_to :user
  belongs_to_active_hash :status, :class_name => 'EmailAccountStatus'
  validates_uniqueness_of :username, :case_sensitive => false
  has_many :email_account_conversations
  has_many :email_receipts, :through => :email_account_conversations

  def self.username(txt)
    where ['lower(email_accounts.username) = ?', txt.downcase]
  end

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

  def fetch_emails(args={})
    HtkImap::GmailImap.imap_connect(self) do |imap|
      current_folder = '[Gmail]/All Mail'
      imap.examine(current_folder)
      if uid = args[:uid]
        return HtkImap::GmailEmail.new(imap: imap, uid: uid, folder: current_folder)
      elsif args[:since_last_check]
        fetch_emails_since_last_check(args, imap)
      elsif message_id = args[:message_id]
        if uid = imap.uid_search(['HEADER', 'MESSAGE-ID', message_id]).first
          HtkImap::GmailEmail.new(imap: imap, uid: uid, folder: current_folder)
        else
          nil
        end
      elsif email_conversation_id = args[:email_conversation_id]
        fetch_emails_for_conversation(args, imap, email_conversation_id, current_folder)
      else
        offset = args[:offset] || 0
        limit = args[:limit] || 1000
        message_ids = imap.uid_search(["ALL"])
        return message_ids.reverse[offset..(offset + (limit-1))].map do |uid| 
          HtkImap::GmailEmail.new(imap: imap, uid: uid, folder: current_folder)
        end.select(&:valid?)
      end
    end
  end
  alias_method :fetch_email, :fetch_emails

  protected

    def fetch_emails_since_last_check(args, imap)
      limit = args[:limit] || 25
      message_ids = if self.last_uid.blank?
        imap.uid_search(['ALL'])[0..(limit-1)]
      else
        imap.uid_search(['UID', "#{self.last_uid}"])[1..limit]
      end
      if message_ids.last
        self.update_attributes(:last_uid => message_ids.last)
        HtkImap::GmailEmail.fetch_range(message_ids.first, message_ids.last).select(&:valid?)
      else
        []
      end
    end

    def fetch_emails_for_conversation(args, imap, email_conversation_id, current_folder)
      message_ids = imap.uid_search(['X-GM-THRID', email_conversation_id])
      message_ids.map do |uid|
        HtkImap::GmailEmail.new(imap: imap, uid: uid, folder: current_folder)
      end.select(&:valid?)
    end

end
