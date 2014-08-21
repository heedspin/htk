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
#  user_id                 :integer
#  snippet                 :string(255)
#

require 'test_helper'

# bundle exec rake test TEST=test/unit/email_test.rb
class EmailTest < ActiveSupport::TestCase
  test "should assign to thread based on thread_id" do    
  	signed_request_user = signed_request_users(:user1)
  	user1 = email_accounts(:user1)
  	user2 = email_accounts(:user2)
    assert_equal 0, Email.count
    assert_equal 0, Message.count
    assert_equal 0, MessageThread.count
    assert_not_nil email1 = EmailFactory.create_email(email_account: user1, 
    	to_addresses: [user2.email])
    assert_equal 1, Message.count
    assert_not_nil email1_receipt = EmailFactory.create_email(email_account: user2, email: email1)
    assert_equal 1, Message.count
    assert_not_nil email2 = EmailFactory.create_email(email_account: user2, 
      thread: email1_receipt,
    	to_addresses: [user1.email],
      include_participants: true)
    assert_equal 2, Message.count
    assert_not_nil email3 = EmailFactory.create_email(email_account: user1,
      thread: email1,
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
end
