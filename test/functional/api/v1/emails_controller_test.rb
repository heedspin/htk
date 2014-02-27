require 'test_helper'

# bundle exec rake test TEST=test/functional/api/v1/emails_controller_test.rb
class Api::V1::EmailsControllerTest < HtkControllerTest
  setup do
    sign_in User.first
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
    assert_equal 1, Message.count
    assert_equal 1, email_account.email_account_threads.subject(subject).count
    assert_not_nil eat1 = email_account.email_account_threads.subject(subject).first
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
    assert_equal 1, email_account.email_account_threads.subject(subject).count
    assert_not_nil eat2 = email_account.email_account_threads.subject(subject).first
    assert_equal eat1, eat2
    assert_equal 2, eat2.emails.count
    assert_not_nil email2 = eat2.emails.web_id('webid2').first
    assert_equal new_email2.id, email2.id
  end
end
