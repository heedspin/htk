require 'test_helper'

# bundle exec rake test TEST=test/functional/api/v1/deliverable_emails_test.rb
class Api::V1::DeliverableEmailsTest < HtkControllerTest
  test "deliverable should be shared in thread" do
    message_thread = ThreadFactory.create_thread(users: 1, messages: 3)
    assert_equal 3, Message.count
    assert_equal 2, User.count
    assert_equal 4, Email.count
  end
end
