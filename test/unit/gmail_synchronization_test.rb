require 'test_helper'
require 'unit/test_gmails/tim_send_chocolate'
# bundle exec rake test TEST=test/unit/gmail_synchronization_test.rb
class GmailSynchronizationTest < ActiveSupport::TestCase
  test "should win" do
  	lxd_tim = users(:lxd_tim)
  	gs = Htkoogle::GmailSynchronization.create!(user: lxd_tim)
  	gmail_data = TestGmails.tim_send_chocolate
  	gs.handle_message(gmail_data)
  	assert email = Email.user(lxd_tim).web_id(gmail_data['id']).first
  	assert_equal ['Tim', 'Lindsay'], email.to_first_names
  end
end
