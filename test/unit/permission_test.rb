# == Schema Information
#
# Table name: permissions
#
#  id             :integer          not null, primary key
#  deliverable_id :integer
#  user_id        :integer
#  group_id       :integer
#  responsible    :boolean
#  access_id      :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'test_helper'

# bundle exec rake test TEST=test/unit/permission_test.rb
class PermissionTest < ActiveSupport::TestCase
  test "should assign permissions" do    
    user1 = users(:user1)
    user2 = users(:user2)
    assert_not_nil email = EmailFactory.create_email(email_account: user1.email_accounts.first, 
      to_addresses: [user2.email, email_accounts(:red_user1).email],
      cc_addresses: [email_accounts(:red_user2).email, 'nobody@nowhere.com'])
    assert_not_nil deliverable = DeliverableFactory.create(email: email, current_user: user1)

    assert_equal 2, deliverable.permissions.count
    assert_not_nil deliverable_owner = deliverable.permissions.all.detect { |du| du.user_id == user1.id }
    assert_equal DeliverableAccess.owner.id, deliverable_owner.access_id
    assert_not_nil deliverable_user = deliverable.permissions.all.detect { |du| du.user_id == user2.id }
    assert_equal DeliverableAccess.edit.id, deliverable_user.access_id
  end
end
