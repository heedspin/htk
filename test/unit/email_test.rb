# == Schema Information
#
# Table name: emails
#
#  id                      :integer          not null, primary key
#  email_account_id        :integer
#  message_id              :integer
#  email_account_thread_id :integer
#  thread_id               :string(255)
#  web_id                  :string(255)
#  folder                  :string(255)
#  date                    :datetime
#  uid                     :integer
#  guid                    :string(255)
#  from_address            :string(255)
#  subject                 :string(255)
#  encoded_mail            :text
#  data                    :text
#  created_at              :datetime
#

require 'test_helper'

# bundle exec rake test TEST=test/unit/email_test.rb
class EmailTest < ActiveSupport::TestCase
  test "should assign to thread based on subject" do    
  	signed_request_user = signed_request_users(:user1)
  	user1 = email_accounts(:user1)
  	user2 = email_accounts(:user2)
    assert_equal 0, Email.count
    assert_equal 0, Message.count
    assert_equal 0, MessageThread.count
    assert_not_nil email1 = EmailFactory.create_email(email_account: user1, 
    	subject: 'subject',
    	to_addresses: [user2.email])
    assert_equal 1, Message.count
    assert_not_nil email1_receipt = EmailFactory.create_email(email_account: user2, email: email1)
    assert_equal 1, Message.count
    assert_not_nil email2 = EmailFactory.create_email(email_account: user2, 
    	subject: 'subject',
    	to_addresses: [user1.email],
      include_participants: true)
    assert_equal 2, Message.count
    assert_not_nil email3 = EmailFactory.create_email(email_account: user1,
      subject: 'subject',
      date: email1.date.advance(minutes: 1), # otherwise it has same timestamp if test runs quickly
      to_addresses: [user2.email],
      include_participants: true)
    assert_equal email1.email_account_thread, email3.email_account_thread
    assert_equal email1.message, email1_receipt.message
    assert_equal email1.message.message_thread, email2.message.message_thread
    assert_equal email2.message.message_thread, email3.message.message_thread
    assert_equal 6, Email.count
    assert_equal 3, Message.count
    assert_equal 1, MessageThread.count
  end

  test "will match two emails in same account" do
    date = Time.current
    subject = 'test1'
    email_account = email_accounts(:user1)
    assert_equal 0, Message.count
    assert new_email1 = EmailFactory.create_email({
      email_account: email_account,
      subject: subject,
      date: date.to_i.to_s,
      from_address: email_account.username,
      to_addresses: ['user1@example.com']
    })
    assert_equal 1, Message.count
    assert_not_nil message1 = new_email1.message
    assert_equal 1, message1.emails.count
    assert_not_nil message_thread1 = message1.message_thread
    assert_equal 1, message_thread1.messages.count
    assert_not_nil eat1 = new_email1.email_account_thread
    assert_equal message_thread1, eat1.message_thread
    assert_equal 1, email_account.email_account_threads.subject(subject).count
    assert_equal eat1, email_account.email_account_threads.subject(subject).first
    assert_equal 1, eat1.emails.count
    assert_not_nil email1 = eat1.emails.first
    assert_equal new_email1.id, email1.id

    assert new_email2 = EmailFactory.create_email({
      email_account: email_account,
      subject: subject,
      date: date.advance(:days => 1).to_i.to_s,
      from_address: email_account.username,
      to_addresses: ['user1@example.com']
    })
    assert_equal 2, Message.count
    assert_not_nil message2 = new_email2.message
    assert_not_equal message1, message2
    assert_equal 1, message2.emails.count
    assert_not_nil message_thread2 = message2.message_thread
    assert_equal message_thread1, message_thread2
    assert_equal 2, message_thread2.messages.count
    assert_not_nil eat2 = new_email2.email_account_thread
    assert_equal eat1, eat2
    assert_equal 2, eat2.emails.count
    assert_not_nil email2 = eat2.emails.web_id(new_email2.web_id).first
    assert_equal new_email2.id, email2.id
  end

  # bundle exec rake test TEST=test/functional/api/v1/emails_controller_test.rb -- -n 'different accounts'
  test "will match two emails in different accounts" do
    date = Time.current
    subject = 'test1'
    email_account1 = email_accounts(:user1)
    email_account2 = email_accounts(:user2)
    assert_equal 0, Message.count
    assert new_email1 = EmailFactory.create_email({
      email_account: email_account1,
      subject: subject,
      date: date.to_i.to_s,
      from_address: email_account1.username,
      to_addresses: [email_account2.username]
    })
    assert_not_nil eat1 = new_email1.email_account_thread
    assert_equal 1, eat1.emails.count
    assert_equal new_email1, eat1.emails.first
    assert_equal email_account1, eat1.email_account
    assert_equal 1, Message.count
    assert message1 = new_email1.message
    assert_not_nil message_thread1 = message1.message_thread
    assert_equal eat1.message_thread, message_thread1
    assert_equal 1, email_account1.email_account_threads.subject(subject).count
    assert_not_nil eat1 = email_account1.email_account_threads.subject(subject).first
    assert_equal 1, eat1.emails.count
    assert_not_nil email1 = eat1.emails.first
    assert_equal new_email1.id, email1.id

    assert_equal 1, Message.count
    assert new_email2 = EmailFactory.create_email({
      email_account: email_account2,
      subject: subject,
      date: date.to_i.to_s,
      from_address: email_account1.username,
      to_addresses: [email_account2.username]
    })
    assert_not_nil eat2 = new_email2.email_account_thread
    assert_equal 1, eat2.emails.count
    assert_equal new_email2, eat2.emails.first
    assert_equal email_account2, eat2.email_account
    assert_equal 1, Message.count
    assert message2 = new_email2.message
    assert_equal message1, message2
    assert_not_nil message_thread2 = message2.message_thread
    assert_equal eat2.message_thread, message_thread2
    assert_equal message_thread1, message_thread2
    assert_equal 1, email_account2.email_account_threads.subject(subject).count
    assert_not_nil eat2 = email_account2.email_account_threads.subject(subject).first
    assert_equal 1, eat2.emails.count
    assert_not_nil email2 = eat2.emails.first
    assert_equal new_email2.id, email2.id

    assert_equal email1.message, email2.message
  end  
end
