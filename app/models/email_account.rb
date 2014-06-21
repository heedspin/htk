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
require 'import_single_email'

class EmailAccount < ApplicationModel
  include Plutolib::LoggerUtils
  include ImportSingleEmail
  attr_accessible :authentication_string, :port, :server, :username, :status
  attr_protected :user_id
  belongs_to :user
  belongs_to_active_hash :status, :class_name => 'EmailAccountStatus'
  validates_uniqueness_of :username, :case_sensitive => false, :scope => :user_id
  has_many :emails, dependent: :destroy
  has_many :email_account_threads, dependent: :destroy
  has_many :signed_request_users, :primary_key => :user_id, :foreign_key => :user_id

  alias_attribute :email, :username

  def mailbox_all
    '[Gmail]/All Mail'
  end

  def self.username(txt)
    where username: txt.downcase
  end
  scope :active, :conditions => { :status_id => EmailAccountStatus.active.id }

  def username=(txt)
    super txt.try(:downcase).try(:strip)
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

  def imap_connection(&block)
    HtkImap::GmailImap.imap_connect(self, &block)
  end

  def fetch_raw_emails(args={}, &block)
    self.imap_connection do |imap|
      current_folder = self.mailbox_all
      imap.examine(current_folder) # readonly
      args = args.clone
      args[:imap] = imap
      args[:current_folder] = current_folder
      args[:limit] ||= 10
      if uid = args[:uid]
        return HtkImap::GmailEmail.new(imap: imap, uid: uid, folder: current_folder)
      elsif args.member?(:since_uid)
        return HtkImap::GmailEmail.fetch_since(args, &block)
      elsif envelope_message_id = args[:envelope_message_id]
        email = if (uid = imap.uid_search(['HEADER', 'MESSAGE-ID', envelope_message_id]).first)
          HtkImap::GmailEmail.new(imap: imap, uid: uid, folder: current_folder)
        else
          nil
        end
        return email
      elsif thread_id = args[:thread_id]
        return HtkImap::GmailEmail.fetch_for_thread(args, &block)
      else
        args[:offset] ||= 0
        args[:limit] ||= 10
        return HtkImap::GmailEmail.fetch_all(args, &block)
      end
    end
  end

  def import_emails
    last_email = self.emails.by_uid.last
    proc = Proc.new do |raw_email|
      begin
        email = self.emails.build(raw_email: raw_email)
        import_single_email(email)
      rescue ActiveRecord::StatementInvalid
        log_error "Failed to save email:", $!
      end
    end
    emails = if last_email
      self.fetch_raw_emails({since_uid: last_email.try(:uid)}, &proc)
    else
      self.fetch_raw_emails({limit: 10}, &proc)
    end
    deleted_emails = self.purge_emails
    log "Imported #{emails.count} and deleted #{deleted_emails} emails from #{self.username}"
    emails
  end

  def purge_emails
    deleted_emails = 0
    if last_email = self.emails.order('emails.uid desc').offset(500).first
      delete_conditions = ['emails.uid > ?', last_email.uid]
      deleted_emails = self.emails.where(delete_conditions).count
      # do_not_delete = self.emails.in_party.where(delete_conditions)
      # Delete all emails that are not in a conversation.
      to_delete = self.emails.where(delete_conditions)#.where(['emails.id not in (?)', do_not_delete])
      to_delete.each do |email|
        deleted_emails += 1
        email.destroy
      end
    end
    deleted_emails
  end

  def self.attach_to(objects)
    all_participants = objects.map(&:participants).flatten.uniq
    email_accounts = EmailAccount.where(username: all_participants)
    email_account_cache = {}
    email_accounts.each { |ea| email_account_cache[ea.username] = ea }
    all_participants.each do |email_address|
      unless email_account_cache.member?(email_address)
        email_account_cache[email_address] = nil
      end
    end
    objects.each do |obj|
      obj.email_account_cache = email_account_cache
    end
  end

  def folder_map(imap)
    result = {}
    imap.list('', '*').each do |mbl|
      unless (mbl.attr.include?(:Noselect))
        result[mbl.name] = mbl
      end
    end
    result
  end

  def ensure_folder(imap, folder_path_array)
    folders = folder_map(imap)
    folder_path = nil
    folder_path_array.each_with_index do |name, index|
      folder_path = folder_path_array[0..index].join('/')
      unless folders.member? folder_path
        imap.create folder_path
      end
    end
    folder_path
  end

  def assign_folder(folder_path_array, emails)
    self.imap_connection do |imap|
      imap.select(self.mailbox_all)
      folder_path = self.ensure_folder(imap, folder_path_array)
      emails = [ emails ] if emails.is_a?(Email)
      imap.uid_copy(emails.map(&:uid).map(&:to_i), folder_path)
    end
  end

end
