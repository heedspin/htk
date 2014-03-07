require 'test_helper'

# bundle exec rake test TEST=test/unit/deliverable_user_test.rb
class DeliverableUserTest < ActiveSupport::TestCase
  test "should assign deliverable users" do    
    user1 = users(:user1)
    user2 = users(:user2)
    assert_not_nil email = EmailFactory.create_email(email_account: user1.email_accounts.first, 
      to_addresses: [user2.email, email_accounts(:red_user1).email],
      cc_addresses: [email_accounts(:red_user2).email, 'nobody@nowhere.com'])
    assert_not_nil deliverable = DeliverableFactory.create_deliverable(email: email, current_user: user1)

    assert_equal 2, deliverable.deliverable_users.count
    assert_not_nil deliverable_owner = deliverable.deliverable_users.all.detect { |du| du.user_id == user1.id }
    assert_equal DeliverableAccess.owner.id, deliverable_owner.access_id
    assert_not_nil deliverable_user = deliverable.deliverable_users.all.detect { |du| du.user_id == user2.id }
    assert_equal DeliverableAccess.edit.id, deliverable_user.access_id
  end
end

