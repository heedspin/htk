# == Schema Information
#
# Table name: deliverables
#
#  id                    :integer          not null, primary key
#  title                 :string(255)
#  parent_deliverable_id :integer
#  status_id             :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  description           :text
#

require 'test_helper'

# bundle exec rake test TEST=test/unit/deliverable_test.rb
class DeliverableTest < ActiveSupport::TestCase
  test "should return deliverable for thread" do    
  	user1 = users(:red_user1)
  	user2 = users(:red_user2)
    assert_not_nil email1_user1 = EmailFactory.create_email(email_account: user1.email_accounts.first, 
    	subject: 'subject',
    	to_addresses: [user2.email])
   	assert_equal 0, email1_user1.message.message_thread.deliverables.count
		assert_not_nil deliverable = DeliverableFactory.create_deliverable(email: email1_user1, current_user: user1)
   	assert_equal 1, email1_user1.message.message_thread.deliverables.count
    assert_not_nil email1_user2 = EmailFactory.create_email(email_account: user2.email_accounts.first, email: email1_user1)
   	assert_equal 1, email1_user2.message.message_thread.deliverables.count
    assert deliverables = email1_user2.message.message_thread.deliverables.not_deleted
   	assert_equal deliverable, deliverables.first

    assert_not_nil email2_user2 = EmailFactory.create_email(email_account: user2.email_accounts.first, thread: email1_user1)
    assert deliverables = email2_user2.message.message_thread.deliverables.not_deleted
    assert_equal deliverable, deliverables.first
  end
end
