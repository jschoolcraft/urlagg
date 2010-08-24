require "test/test_helper"

class Admin::StatusControllerTest < ActionController::TestCase

  context "Admin" do

    setup do
      @request.session[:typus_user_id] = Factory(:typus_user).id
    end

    should "render index" do
      get :index
      assert_response :success
      assert_template 'index'
    end

    should "not render show" do
      get :show
      assert_response :unprocessable_entity
    end

  end

  context "Editor" do

    setup do
      @request.session[:typus_user_id] = Factory(:typus_user, :role => "editor").id
    end

    should "not render index" do
      get :index
      assert_response :unprocessable_entity
    end

  end

  context "Not logged user" do

    setup do
      @request.session[:typus_user_id] = nil
    end

    should "not render index and redirect to new_admin_session_path with back_to" do
      get :index
      assert_response :redirect
      assert_redirected_to new_admin_session_path(:back_to => '/admin/status')
    end

  end

end
