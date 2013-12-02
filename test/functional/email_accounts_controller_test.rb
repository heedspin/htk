require 'test_helper'

class EmailAccountsControllerTest < HtkControllerTest
  setup do
    @email_account = email_accounts(:user1_account1)
    sign_in User.first
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:email_accounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create email_account" do
    assert_difference('EmailAccount.count') do
      post :create, email_account: { authentication_string: 'anything', port: '1234', server: 'server', username: 'username' }
    end

    assert_redirected_to email_account_path(assigns(:email_account))
  end

  test "should show email_account" do
    get :show, id: @email_account
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @email_account
    assert_response :success
  end

  test "should update email_account" do
    put :update, id: @email_account, email_account: { authentication_string: @email_account.authentication_string, port: @email_account.port, server: @email_account.server, username: @email_account.username }
    assert_redirected_to email_account_path(assigns(:email_account))
  end

  test "should destroy email_account" do
    assert_difference('EmailAccount.count', -1) do
      delete :destroy, id: @email_account.id
    end

    assert_redirected_to email_accounts_path
  end
end
