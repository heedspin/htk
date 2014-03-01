require 'test_helper'

# bundle exec rake test TEST=test/functional/api/v1/emails_controller_test.rb
class Api::V1::EmailsControllerTest < HtkControllerTest
  setup do
    # Any user will get us past verification.
    # sign_in users(:user1)
  end

  test "will match two emails in same account" do
    date = Time.current
    subject = 'test1'
    signed_request_user = signed_request_users(:user1)
    email_account = email_accounts(:user1)
    assert_equal 0, Message.count
    post :create, {
      subject: subject,
      date: date.to_i.to_s,
      from_address: email_account.username,
      web_id: 'webid1',
      body_brief: 'body_brief',
      to_addresses: ['user1@example.com'],
      cc_addresses: [],
      opensocial_owner_id: signed_request_user[:opensocial_owner_id],
      opensocial_container: signed_request_user[:opensocial_container]
    }
    assert_response :success
    assert new_email1 = assigns['email']
    assert new_email1.reload
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

    post :create, {
      subject: subject,
      date: date.advance(:days => 1).to_i.to_s,
      from_address: email_account.username,
      web_id: 'webid2',
      body_brief: 'body_brief',
      to_addresses: ['user1@example.com'],
      cc_addresses: [],
      opensocial_owner_id: signed_request_user[:opensocial_owner_id],
      opensocial_container: signed_request_user[:opensocial_container]
    }
    assert_response :success
    assert new_email2 = assigns['email']
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
    assert_not_nil email2 = eat2.emails.web_id('webid2').first
    assert_equal new_email2.id, email2.id
  end

  # bundle exec rake test TEST=test/functional/api/v1/emails_controller_test.rb -- -n 'different accounts'
  test "will match two emails in different accounts" do
    date = Time.current
    subject = 'test1'
    email_account1 = email_accounts(:user1)
    email_account2 = email_accounts(:user2)
    signed_request_user1 = email_account1.signed_request_users.first
    signed_request_user2 = email_account2.signed_request_users.first

    assert_equal 0, Message.count
    post :create, {
      subject: subject,
      date: date.to_i.to_s,
      from_address: email_account1.username,
      web_id: 'webid1',
      body_brief: 'body_brief',
      to_addresses: [email_account2.username],
      cc_addresses: [],
      opensocial_owner_id: signed_request_user1[:opensocial_owner_id],
      opensocial_container: signed_request_user1[:opensocial_container]
    }
    assert_response :success
    assert new_email1 = assigns['email']
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
    post :create, {
      subject: subject,
      date: date.to_i.to_s,
      from_address: email_account1.username,
      web_id: 'webid1',
      body_brief: 'body_brief',
      to_addresses: [email_account2.username],
      cc_addresses: [],
      opensocial_owner_id: signed_request_user2[:opensocial_owner_id],
      opensocial_container: signed_request_user2[:opensocial_container]
    }
    assert_response :success
    assert new_email2 = assigns['email']
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
