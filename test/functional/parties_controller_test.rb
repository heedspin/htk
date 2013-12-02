require 'test_helper'

class PartiesControllerTest < HtkControllerTest
  test "should create party" do
  	sign_in User.first
  	assert_raises ActiveRecord::RecordNotFound do
	    get :show, id: 'pid-1'
	  end
  end
end
