require 'test_helper'

# bundle exec rake test TEST=test/functional/api/v1/deliverables_controller_test.rb
class Api::V1::DeliverablesControllerTest < HtkControllerTest
  # test "should 404 if no email" do
  #   signed_request_user = signed_request_users(:user1)
  # 	user1 = users(:user1)
  #   post :create, {
  #     title: 'Deliverable',
  #     from_address: 'billgates@microsoft.com',
  #     date: Time.current.to_i.to_s,
  #     opensocial_owner_id: signed_request_user[:opensocial_owner_id],
  #     opensocial_container: signed_request_user[:opensocial_container]
  #   }
  #   assert_response 422

  #   assert_not_nil email = EmailFactory.create_email(email_account: user1.email_accounts.first)
  #   post :create, {
  #     title: 'Deliverable',
  #     from_address: email.from_address,
  #     date: email.date,
  #     opensocial_owner_id: signed_request_user[:opensocial_owner_id],
  #     opensocial_container: signed_request_user[:opensocial_container]
  #   }
  #   assert_response :success
  #   assert_not_nil deliverable = assigns[:deliverable]
  # end

  test "should return deliverable for thread" do    
  	user1 = users(:red_user1)
  	user2 = users(:red_user2)
    assert_not_nil email1_user1 = EmailFactory.create_email(email_account: user1.email_accounts.first, 
    	subject: 'subject',
    	to_addresses: [user2.email])
   	assert_equal 0, email1_user1.message.message_thread.deliverables.count
		assert_not_nil deliverable = DeliverableFactory.create(email: email1_user1, current_user: user1)
   	assert_equal 1, email1_user1.message.message_thread.deliverables.count
    assert_not_nil email1_user2 = EmailFactory.create_email(email_account: user2.email_accounts.first, email: email1_user1)
   	assert_equal 1, email1_user2.message.message_thread.deliverables.count
   	get :index, {
   		from_address: email1_user1.from_address,
      date: email1_user1.date.to_i.to_s,
   		opensocial_owner_id: user1.signed_request_users.first.opensocial_owner_id,
   		opensocial_container: user1.signed_request_users.first.opensocial_container
   	}
   	assert_response :success
   	assert deliverables = assigns[:deliverables]
   	assert_equal deliverable, deliverables.first
  end
end
